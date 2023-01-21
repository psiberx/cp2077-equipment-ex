module EquipmentEx

public class OutfitSystem extends ScriptableSystem {
    private persistent let m_state: ref<OutfitState>;
    private let m_firstUse: Bool;

    private let m_baseSlots: array<TweakDBID>;
    private let m_outfitSlots: array<TweakDBID>;
    private let m_managedSlots: array<TweakDBID>;
    private let m_managedAreas: array<gamedataEquipmentArea>;
    private let m_cameraDependentSlots: array<TweakDBID>;

    private let m_player: wref<GameObject>;
    private let m_equipmentData: wref<EquipmentSystemPlayerData>;
    private let m_transactionSystem: wref<TransactionSystem>;
    private let m_attachmentSlotsListener: ref<AttachmentSlotsScriptListener>;
    private let m_delaySystem: wref<DelaySystem>;

    private let m_equipmentDef: wref<UI_EquipmentDef>;
    private let m_equipmentBlackboard: wref<IBlackboard>;
    private let m_equipmentHash: Uint64;

    private func OnAttach() {
        this.InitializeState();
        this.InitializeSlotsInfo();
        this.InitializeBlackboards();
    }

    private func OnDetach() {
        this.UninitializeSystems();
    }

    private func OnRestored(saveVersion: Int32, gameVersion: Int32) {
        this.InitializePlayerAndSystems();
        this.MigrateState();

        if this.m_state.IsActive() {
            this.HideEquipment();

            this.m_delaySystem.DelayCallback(DelayedRestoreCallback.Create(this), 1.0 / 30.0, false);
        }
    }

    private func OnPlayerAttach(request: ref<PlayerAttachRequest>) {
        this.InitializePlayerAndSystems();
        this.ConvertClothingSets();
    }

    private func InitializeState() {
        if !IsDefined(this.m_state) {
            this.m_state = new OutfitState();
            this.m_firstUse = true;
        } else {
            this.m_state.Restore();
        }
    }

    private func InitializeSlotsInfo() {
        for baseSlot in OutfitConfig.BaseSlots() {
            ArrayPush(this.m_baseSlots, baseSlot.slotID);
            ArrayPush(this.m_managedSlots, baseSlot.slotID);
            ArrayPush(this.m_managedAreas, baseSlot.equipmentArea);
        }

        for outfitSlot in OutfitConfig.OutfitSlots() {
            ArrayPush(this.m_outfitSlots, outfitSlot.slotID);
            ArrayPush(this.m_managedSlots, outfitSlot.slotID);

            if outfitSlot.isCameraDependent {
                ArrayPush(this.m_cameraDependentSlots, outfitSlot.slotID);
            }
        }
    }

    private func InitializeBlackboards() {
        this.m_equipmentDef = GetAllBlackboardDefs().UI_Equipment;
        this.m_equipmentBlackboard = GameInstance.GetBlackboardSystem(this.GetGameInstance()).Get(this.m_equipmentDef);
    }

    private func InitializePlayerAndSystems() {
        if !IsDefined(this.m_player) {
            this.m_player = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerMainGameObject();
            this.m_equipmentData = EquipmentSystem.GetData(this.m_player);
            this.m_transactionSystem = GameInstance.GetTransactionSystem(this.GetGameInstance());
            this.m_attachmentSlotsListener = this.m_transactionSystem.RegisterAttachmentSlotListener(this.m_player, PlayerSlotsCallback.Create(this));
            this.m_delaySystem = GameInstance.GetDelaySystem(this.GetGameInstance());
        }
    }

    private func UninitializeSystems() {
        if IsDefined(this.m_attachmentSlotsListener) {
            this.m_transactionSystem.UnregisterAttachmentSlotListener(this.m_player, this.m_attachmentSlotsListener);
        }
    }

    private func ConvertClothingSets() {
        if this.m_firstUse {
            let clothingSets = ExtractClothingSets(this.GetGameInstance());

            for clothingSet in clothingSets {
                let outfitParts: array<ref<OutfitPart>>;

                for clothingItem in clothingSet.clothingList {
                    if ItemID.IsValid(clothingItem.visualItem) && !clothingItem.isHidden {
                        let itemID = clothingItem.visualItem;
                        let slotID = this.GetItemSlot(itemID);

                        if this.IsOutfitSlot(slotID) {
                            ArrayPush(outfitParts, OutfitPart.Create(itemID, slotID));
                        }
                    }
                }

                if ArraySize(outfitParts) > 0 {
                    let outfitName = StringToName("Wardrobe Set " + ToString(clothingSet.setID));
                    this.m_state.SaveOutfit(outfitName, outfitParts, false, this.GetTimestamp());
                }
            }
        }
    }

    private func GetTimestamp() -> Float {
        return EngineTime.ToFloat(GameInstance.GetPlaythroughTime(this.GetGameInstance()));
    }

    private func AddItemToState(itemID: ItemID, slotID: TweakDBID) {
        this.m_state.UpdatePart(itemID, slotID);
    }

    private func RemoveItemFromState(itemID: ItemID) {
        this.m_state.RemovePart(itemID);
    }

    private func RemoveSlotFromState(slotID: TweakDBID) {
        this.m_state.RemovePart(slotID);
    }

    private func RemoveAllItemsFromState() {
        this.m_state.ClearParts();
    }

    private func MigrateState() {
        for part in this.m_state.GetParts() {
            let itemID = part.GetItemID();
            let slotID = this.GetItemSlot(itemID);

            if NotEquals(slotID, part.GetSlotID()) {
                if this.IsOutfitSlot(slotID) {
                    this.m_state.UpdatePart(itemID, slotID);
                } else {
                    this.m_state.RemovePart(itemID);
                }
            }
        }
    }

    private func AttachVisualToSlot(itemID: ItemID, slotID: TweakDBID) {
        let randomID = ItemID.FromTDBID(ItemID.GetTDBID(itemID));
        let previewID = this.m_transactionSystem.CreatePreviewItemID(randomID);

        this.m_transactionSystem.GivePreviewItemByItemID(this.m_player, randomID);
        this.m_transactionSystem.AddItemToSlot(this.m_player, slotID, previewID, true);

        this.TriggerAttachmentEvent(itemID, slotID);
        this.UpdateBlackboard(itemID, slotID);
    }

    private func DetachVisualFromSlot(itemID: ItemID, slotID: TweakDBID) {
        let itemObject = this.m_transactionSystem.GetItemInSlot(this.m_player, slotID);
        if IsDefined(itemObject) {
            let previewID = itemObject.GetItemID();

            this.m_transactionSystem.RemoveItemFromSlot(this.m_player, slotID);
            this.m_transactionSystem.RemoveItem(this.m_player, previewID, 1);
        }

        this.TriggerDetachmentEvent(itemID, slotID);
        this.UpdateBlackboard(slotID);
    }

    private func AttachAllVisualsToSlots(opt refresh: Bool) {
        for part in this.m_state.GetParts() {
            if this.IsOutfitSlot(part.GetSlotID()) {
                this.AttachVisualToSlot(part.GetItemID(), part.GetSlotID());

                if refresh {
                    this.RefreshSlotAttachment(part.GetSlotID());
                }
            }
        }
    }

    private func DetachAllVisualsFromSlots(opt refresh: Bool) {
        for part in this.m_state.GetParts() {
            if this.IsOutfitSlot(part.GetSlotID()) {
                this.DetachVisualFromSlot(part.GetItemID(), part.GetSlotID());

                if refresh {
                    this.RefreshSlotAttachment(part.GetSlotID());
                }
            }
        }
    }

    private func ReattachVisualInSlot(slotID: TweakDBID) {
        let part = this.m_state.GetPart(slotID);
        if IsDefined(part) {
            let itemObject = this.m_transactionSystem.GetItemInSlot(this.m_player, slotID);
            if IsDefined(itemObject) {
                let previewID = itemObject.GetItemID();

                this.m_transactionSystem.RemoveItemFromSlot(this.m_player, slotID);
                this.m_delaySystem.DelayCallback(DelayedAttachCallback.Create(this.m_transactionSystem, this.m_player, slotID, previewID), 1.0 / 30.0, false);
            }
        }
    }

    private func RefreshSlotAttachment(slotID: TweakDBID) {
        this.m_transactionSystem.RefreshAttachment(this.m_player, slotID);
    }

    private func UpdateCameraDependentVisuals() {
        for part in this.m_state.GetParts() {
            if this.IsCameraDependentSlot(part.GetSlotID()) {
                let itemObject = this.m_transactionSystem.GetItemInSlot(this.m_player, part.GetSlotID());
                if IsDefined(itemObject) {
                    this.m_transactionSystem.ResetItemAppearance(this.m_player, itemObject.GetItemID());
                }
            }
        }
    }
    private func HideEquipment() {
        this.m_equipmentData.UnlockVisualChanges();
        this.m_equipmentData.UnequipItem(this.m_equipmentData.GetEquipAreaIndex(gamedataEquipmentArea.Outfit));

        for baseSlot in OutfitConfig.BaseSlots() {
            this.m_equipmentData.ClearVisuals(baseSlot.equipmentArea);
        }

        this.m_equipmentData.LockVisualChanges();
        this.UpdateEquipmentHash();
    }

    private func ShowEquipment() {
        this.m_equipmentData.UnlockVisualChanges();

        for baseSlot in OutfitConfig.BaseSlots() {
            this.m_equipmentData.UnequipVisuals(baseSlot.equipmentArea);
        }

        this.m_equipmentData.LockVisualChanges();
        this.ResetEquipmentHash();
    }

    private func CloneEquipment(opt ignoreItemID: ItemID, opt ignoreSlotID: TweakDBID) {
        for baseSlotID in this.m_baseSlots {
            let itemObject = this.m_transactionSystem.GetItemInSlot(this.m_player, baseSlotID);
            if IsDefined(itemObject) {
                let itemID = itemObject.GetItemID();
                if NotEquals(itemID, ignoreItemID){
                    let slotID = this.GetItemSlot(itemID);
                    if this.IsOutfitSlot(slotID) && NotEquals(slotID, ignoreSlotID) {
                        this.EquipItem(itemID, slotID);
                        this.RefreshSlotAttachment(slotID);
                    }
                }
            }
        }

        this.UpdateEquipmentHash();
    }

    private func GetEquipmentParts() -> array<ref<OutfitPart>> {
        let parts: array<ref<OutfitPart>>;

        for baseSlot in OutfitConfig.BaseSlots() {
            let itemID = this.m_equipmentData.GetActiveItem(baseSlot.equipmentArea);
            if ItemID.IsValid(itemID) {
                let visualTag = this.m_equipmentData.GetVisualTagByAreaType(baseSlot.equipmentArea);
                let forceHide = this.m_equipmentData.IsVisualTagActive(visualTag);
                if !forceHide {
                    ArrayPush(parts, OutfitPart.Create(itemID, baseSlot.slotID));
                }
            }
        }

        return parts;
    }

    private func ResetEquipmentHash() {
        this.m_equipmentHash = 0ul;
    }

    private func UpdateEquipmentHash() {
        this.m_equipmentHash = OutfitSet.MakeHash(this.GetEquipmentParts());
    }

    private func UpdateBlackboard(slotID: TweakDBID) {
        this.UpdateBlackboard(ItemID.None(), slotID);
    }

    private func UpdateBlackboard(itemID: ItemID, slotID: TweakDBID) {
        this.m_equipmentBlackboard.SetInt(this.m_equipmentDef.areaChangedSlotIndex, 0);
        this.m_equipmentBlackboard.SetInt(this.m_equipmentDef.areaChanged, EnumInt(gamedataEquipmentArea.Invalid), true);

        this.m_equipmentBlackboard.SetVariant(this.m_equipmentDef.itemEquipped, ToVariant(itemID), true);

        let modifiedArea: SPaperdollEquipData;
        modifiedArea.equipped = ItemID.IsValid(itemID);
        modifiedArea.placementSlot = slotID;
        this.m_equipmentBlackboard.SetVariant(this.m_equipmentDef.lastModifiedArea, ToVariant(modifiedArea), true);

        this.m_equipmentBlackboard.FireCallbacks();
    }
    
    private func TriggerActivationEvent(opt outfitName: CName) {
        let event = new OutfitUpdated();
        event.isActive = true;
        event.outfitName = outfitName;

        GameInstance.GetUISystem(this.GetGameInstance()).QueueEvent(event);
    }

    private func TriggerDeactivationEvent() {
        let event = new OutfitUpdated();
        event.isActive = false;

        GameInstance.GetUISystem(this.GetGameInstance()).QueueEvent(event);
    }

    private func TriggerAttachmentEvent(itemID: ItemID, slotID: TweakDBID) {
        let event = new OutfitPartUpdated();
        event.itemID = itemID;
        event.itemName = this.GetItemName(itemID);
        event.slotID = slotID;
        event.slotName = this.GetSlotName(slotID);
        event.isEquipped = true;

        GameInstance.GetUISystem(this.GetGameInstance()).QueueEvent(event);
    }

    private func TriggerDetachmentEvent(itemID: ItemID, slotID: TweakDBID) {
        let event = new OutfitPartUpdated();
        event.itemID = itemID;
        event.itemName = this.GetItemName(itemID);
        event.slotID = slotID;
        event.slotName = this.GetSlotName(slotID);
        event.isEquipped = false;

        GameInstance.GetUISystem(this.GetGameInstance()).QueueEvent(event);       
    }

    private func TriggerOutfitListEvent() {
        GameInstance.GetUISystem(this.GetGameInstance()).QueueEvent(new OutfitListUpdated());
    }

    public func IsBlocked() -> Bool {
        if this.m_state.IsDisabled() {
            return true;
        }

        let outfitItem = this.m_transactionSystem.GetItemInSlot(this.m_player, t"AttachmentSlots.Outfit");
        if IsDefined(outfitItem) && outfitItem.GetItemData().HasTag(n"UnequipBlocked") {
            return true;
        }

        return false;
    }

    public func IsDisabled() -> Bool {
        return this.m_state.IsDisabled();
    }

    public func Enable() {
        this.m_state.SetDisabled(false);
    }

    public func Disable() {
        this.m_state.SetDisabled(true);
    }

    public func IsActive() -> Bool {
        return this.m_state.IsActive();
    }

    public func Activate() {
        if this.IsBlocked() {
            return;
        }

        if !this.m_state.IsActive() {
            this.HideEquipment();

            this.m_state.SetActive(true);
            this.m_state.ClearParts();

            this.CloneEquipment();
            
            this.TriggerActivationEvent();
        }
    }

    private func ActivateWithoutClone() {
        if this.IsBlocked() {
            return;
        }

        if !this.m_state.IsActive() {
            this.HideEquipment();

            this.m_state.SetActive(true);
            this.m_state.ClearParts();

            this.TriggerActivationEvent();
        }
    }

    private func ActivateWithoutSlot(slotID: TweakDBID) {
        if this.IsBlocked() {
            return;
        }

        if !this.m_state.IsActive() {
            this.HideEquipment();

            this.m_state.SetActive(true);
            this.m_state.ClearParts();

            this.CloneEquipment(ItemID.None(), slotID);

            this.TriggerActivationEvent();
        }
    }

    private func ActivateWithoutItem(itemID: ItemID) {
        if this.IsBlocked() {
            return;
        }

        if !this.m_state.IsActive() {
            this.HideEquipment();

            this.m_state.SetActive(true);
            this.m_state.ClearParts();

            this.CloneEquipment(itemID, TDBID.None());

            this.TriggerActivationEvent();
        }
    }

    public func Reactivate() {
        if this.IsBlocked() {
            return;
        }

        if !this.m_state.IsActive() {
            this.HideEquipment();

            this.m_state.SetActive(true);
            
            this.AttachAllVisualsToSlots(true);

            this.TriggerActivationEvent();
        }
    }

    public func Deactivate() {
        if this.m_state.IsActive() {
            this.m_state.SetActive(false);

            this.ShowEquipment();
            this.DetachAllVisualsFromSlots(false);

            this.TriggerDeactivationEvent();
        }
    }

    public func GetItemSlot(recordID: TweakDBID) -> TweakDBID {
        let supportedSlots = TweakDBInterface.GetForeignKeyArray(recordID + t".placementSlots");
        return ArraySize(supportedSlots) > 0 ? ArrayLast(supportedSlots) : TDBID.None();
    }

    public func GetItemSlot(itemID: ItemID) -> TweakDBID {
        return ItemID.IsValid(itemID) ? this.GetItemSlot(ItemID.GetTDBID(itemID)) : TDBID.None();
    }

    public func IsOccupied(slotID: TweakDBID) -> Bool {
        return this.m_state.IsActive() && this.m_state.HasPart(slotID);
    }

    public func IsEquipped(itemID: ItemID) -> Bool {
        return this.m_state.IsActive() && this.m_state.HasPart(itemID);
    }

    public func IsEquippable(recordID: TweakDBID) -> Bool {
        let itemRecord = TweakDBInterface.GetItemRecord(recordID);

        if !IsDefined(itemRecord) {
            return false;
        }

        if !Equals(itemRecord.ItemCategory().Type(), gamedataItemCategory.Clothing) {
            return false;
        }

        if !this.IsOutfitSlot(this.GetItemSlot(recordID)) {
            return false;
        }

        return true;
    }

    public func IsEquippable(itemID: ItemID) -> Bool {
        if !ItemID.IsValid(itemID) {
            return false;
        }

        return this.IsEquippable(ItemID.GetTDBID(itemID));
    }

    public func IsEquippable(recordID: TweakDBID, slotID: TweakDBID) -> Bool {
        return this.IsEquippable(recordID) && this.GetItemSlot(recordID) == slotID;
    }

    public func IsEquippable(itemID: ItemID, slotID: TweakDBID) -> Bool {
        return this.IsEquippable(itemID) && this.GetItemSlot(itemID) == slotID;
    }

    public func EquipItem(recordID: TweakDBID, opt slotID: TweakDBID) -> Bool {
        if !this.IsEquippable(recordID) {
            return false;
        }
        
        let itemID = this.GiveItem(recordID);

        return this.EquipItem(itemID, slotID);
    }

    public func EquipItem(itemID: ItemID, opt slotID: TweakDBID) -> Bool {
        if this.IsBlocked() {
            return false;
        }

        if TDBID.IsValid(slotID) {
            if !this.IsEquippable(itemID, slotID) {
                return false;
            }
        } else {
            if !this.IsEquippable(itemID) {
                return false;
            }
            slotID = this.GetItemSlot(itemID);
        }
        
        this.ActivateWithoutSlot(slotID);

        this.UnequipItem(itemID);
        this.UnequipSlot(slotID);

        this.AddItemToState(itemID, slotID);
        this.AttachVisualToSlot(itemID, slotID);

        return true;
    }

    public func UnequipItem(recordID: TweakDBID) -> Bool {
        if this.IsBlocked() {
            return false;
        }

        let itemData = this.m_transactionSystem.GetItemDataByTDBID(this.m_player, recordID);

        if !IsDefined(itemData) {
            return false;
        }

        return this.UnequipItem(itemData.GetID());
    }

    public func UnequipItem(itemID: ItemID) -> Bool {
        if this.IsBlocked() {
            return false;
        }

        this.ActivateWithoutItem(itemID);
        
        let part = this.m_state.GetPart(itemID);

        if !IsDefined(part) {
            return false;
        }

        let slotID = part.GetSlotID();

        this.RemoveItemFromState(itemID);
        this.DetachVisualFromSlot(itemID, slotID);

        return true;
    }

    public func UnequipSlot(slotID: TweakDBID) -> Bool {
        if this.IsBlocked() {
            return false;
        }

        this.ActivateWithoutSlot(slotID);

        let part = this.m_state.GetPart(slotID);

        if !IsDefined(part) {
            return false;
        }

        let itemID = part.GetItemID();

        this.RemoveItemFromState(itemID);
        this.DetachVisualFromSlot(itemID, slotID);

        return true;
    }

    public func UnequipAll() {
        if this.IsBlocked() {
            return;
        }

        if this.m_state.IsActive() {
            for part in this.m_state.GetParts() {
                if this.IsOutfitSlot(part.GetSlotID()) {
                    this.RemoveItemFromState(part.GetItemID());
                    this.DetachVisualFromSlot(part.GetItemID(), part.GetSlotID());
                }
            }
        } else {
            this.ActivateWithoutClone();
        }
    }

    public func IsEquipped(name: CName) -> Bool {
        return this.m_state.IsActive()
            ? this.m_state.IsOutfit(name)
            : Equals(name, n"");
    }

    public func HasOutfit(name: CName) -> Bool {
        return IsDefined(this.m_state.GetOutfit(name));
    }

    public func LoadOutfit(name: CName) -> Bool {
        if this.IsBlocked() {
            return false;
        }

        let outfit = this.m_state.GetOutfit(name);

        if !IsDefined(outfit) {
            return false;
        }

        this.ActivateWithoutClone();

        let slots = this.GetOutfitSlots();

        for part in outfit.GetParts() {
            let itemID = part.GetItemID();
            let slotID = this.GetItemSlot(itemID); // part.GetSlotID()

            this.EquipItem(itemID, slotID);
            ArrayRemove(slots, slotID);
        }

        for slotID in slots {
            this.UnequipSlot(slotID);
        }

        this.TriggerActivationEvent(name);

        return true;
    }

    public func SaveOutfit(name: CName, opt overwrite: Bool) -> Bool {
        this.Activate();

        return this.m_state.SaveOutfit(name, overwrite, this.GetTimestamp());
    }

    public func CopyOutfit(name: CName, from: CName) -> Bool {
        return this.m_state.CopyOutfit(name, from, this.GetTimestamp());
    }

    public func DeleteOutfit(name: CName) -> Bool {
        return this.m_state.DeleteOutfit(name);
    }

    public func DeleteAllOutfits() -> Bool {
        this.TriggerOutfitListEvent();

        return this.m_state.DeleteAllOutfits();
    }

    public func GetOutfits() -> array<CName> {
        let outfits: array<CName>;
        
        for outfit in this.m_state.GetOutfits() {
            let index = 0;
            while index < ArraySize(outfits) && StrCmp(NameToString(outfit.GetName()), NameToString(outfits[index])) > 0 {
                index += 1;
            }
            ArrayInsert(outfits, index, outfit.GetName());
        }

        return outfits;
    }

    public func GiveItem(recordID: TweakDBID) -> ItemID {
        let itemID: ItemID;
        let itemData = this.m_transactionSystem.GetItemDataByTDBID(this.m_player, recordID);

        if IsDefined(itemData) {
            itemID = itemData.GetID();
        } else {
            itemID = ItemID.FromTDBID(recordID);
            this.m_transactionSystem.GiveItem(this.m_player, itemID, 1, TweakDBInterface.GetItemRecord(recordID).Tags());
        }

        return itemID;
    }

    public func GiveItem(itemID: ItemID) -> ItemID {
        let recordID: TweakDBID;
        let itemData = this.m_transactionSystem.GetItemData(this.m_player, itemID);

        if IsDefined(itemData) {
            itemID = itemData.GetID();
        } else {
            recordID = ItemID.GetTDBID(itemID);
            itemData = this.m_transactionSystem.GetItemDataByTDBID(this.m_player, recordID);

            if IsDefined(itemData) {
                itemID = itemData.GetID();
            } else {
                this.m_transactionSystem.GiveItem(this.m_player, itemID, 1, TweakDBInterface.GetItemRecord(recordID).Tags());
            }
        }

        return itemID;
    }

    public func EquipPuppetItem(puppet: ref<gamePuppet>, itemID: ItemID) {
        let slotID = this.GetItemSlot(itemID);
        let previewID = this.m_transactionSystem.CreatePreviewItemID(itemID);

        this.m_transactionSystem.GivePreviewItemByItemID(puppet, itemID);
        this.m_transactionSystem.AddItemToSlot(puppet, slotID, previewID, true);
    }

    public func UnequipPuppetItem(puppet: ref<gamePuppet>, itemID: ItemID) {
        let slotID = this.GetItemSlot(itemID);
        let previewID = this.m_transactionSystem.CreatePreviewItemID(itemID);

        this.m_transactionSystem.RemoveItemFromSlot(puppet, slotID);
        this.m_transactionSystem.RemoveItem(puppet, previewID, 1);
    }

    public func EquipPuppetOutfit(puppet: ref<gamePuppet>, opt items: script_ref<array<ItemID>>) {
        this.EquipPuppetOutfit(puppet, this.m_state.IsActive(), items);
    }

    public func EquipPuppetOutfit(puppet: ref<gamePuppet>, useOutfit: Bool, opt items: script_ref<array<ItemID>>) {
        if useOutfit {
            this.EquipPuppetParts(puppet, this.m_state.GetParts(), items);
        } else {
            this.EquipPuppetParts(puppet, this.GetEquipmentParts(), items);
        }
    }

    public func EquipPuppetOutfit(puppet: ref<gamePuppet>, outfitName: CName, opt items: script_ref<array<ItemID>>) {
        if NotEquals(outfitName, n"") {
            let outfit = this.m_state.GetOutfit(outfitName);
            if IsDefined(outfit) {
                this.EquipPuppetParts(puppet, outfit.GetParts(), items);
            }
        } else {
            this.EquipPuppetParts(puppet, this.GetEquipmentParts(), items);
        }
    }

    private func EquipPuppetParts(puppet: ref<gamePuppet>, parts: array<ref<OutfitPart>>, opt items: script_ref<array<ItemID>>) {
        for slotID in this.m_managedSlots {
            this.m_transactionSystem.RemoveItemFromSlot(puppet, slotID);
        }

        for part in parts {
            let itemID = part.GetItemID();
            let slotID = part.GetSlotID();

            if !this.IsBaseSlot(slotID) {
                slotID = this.GetItemSlot(itemID);
            }

            let previewID = this.m_transactionSystem.CreatePreviewItemID(itemID);
            this.m_transactionSystem.GivePreviewItemByItemID(puppet, itemID);
            this.m_transactionSystem.AddItemToSlot(puppet, slotID, previewID, true);

            ArrayPush(Deref(items), previewID);
        }
    }

    public func UpdatePuppetFromBlackboard(puppet: ref<gamePuppet>) -> Bool {
        if !IsDefined(puppet) {
            return false;
        }

        let modifiedArea = FromVariant<SPaperdollEquipData>(this.m_equipmentBlackboard.GetVariant(this.m_equipmentDef.lastModifiedArea));
        let slotID = modifiedArea.placementSlot;

        if !this.IsOutfitSlot(slotID) {
            return this.IsBaseSlot(slotID) ? this.m_state.IsActive() : false;
        }

        let itemID = FromVariant<ItemID>(this.m_equipmentBlackboard.GetVariant(this.m_equipmentDef.itemEquipped));
        let itemObject = this.m_transactionSystem.GetItemInSlot(puppet, slotID);

        if IsDefined(itemObject) {
            let previewID = itemObject.GetItemID();

            if Equals(previewID, itemID) {
                return true;
            }

            this.m_transactionSystem.RemoveItemFromSlot(puppet, slotID);
            this.m_transactionSystem.RemoveItem(puppet, previewID, 1);
        }

        if ItemID.IsValid(itemID) && modifiedArea.equipped {
            let previewID = this.m_transactionSystem.CreatePreviewItemID(itemID);
            this.m_transactionSystem.GivePreviewItemByItemID(puppet, itemID);
            this.m_transactionSystem.AddItemToSlot(puppet, slotID, previewID, true);
        }

        return true;
    }

    public func IsBaseSlot(slotID: TweakDBID) -> Bool {
        return ArrayContains(this.m_baseSlots, slotID);
    }

    public func IsOutfitSlot(slotID: TweakDBID) -> Bool {
        return ArrayContains(this.m_outfitSlots, slotID);
    }

    public func IsManagedSlot(slotID: TweakDBID) -> Bool {
        return ArrayContains(this.m_managedSlots, slotID);
    }

    public func IsManagedArea(area: gamedataEquipmentArea) -> Bool {
        return ArrayContains(this.m_managedAreas, area);
    }

    public func IsCameraDependentSlot(slotID: TweakDBID) -> Bool {
        return ArrayContains(this.m_cameraDependentSlots, slotID);
    }

    public func GetOutfitSlots() -> array<TweakDBID> {
        return this.m_outfitSlots;
    }

    public func GetUsedSlots() -> array<TweakDBID> {
        let slots: array<TweakDBID>;
        for part in this.m_state.GetParts() {
            ArrayPush(slots, part.GetSlotID());
        }
        return slots;
    }

    public func GetSlotName(slotID: TweakDBID) -> String {
        let key = TweakDBInterface.GetAttachmentSlotRecord(slotID).LocalizedName();
        let name = GetLocalizedTextByKey(StringToName(key));
        return NotEquals(name, "") ? name : key;
    }

    public func GetItemName(itemID: ItemID) -> String {
        return ItemID.IsValid(itemID) ? GetLocalizedTextByKey(TweakDBInterface.GetItemRecord(ItemID.GetTDBID(itemID)).DisplayName()) : "";
    }

    public static func GetInstance(game: GameInstance) -> ref<OutfitSystem> {
        return GameInstance.GetScriptableSystemsContainer(game).Get(n"EquipmentEx.OutfitSystem") as OutfitSystem;
    }
}

public class PlayerSlotsCallback extends AttachmentSlotsScriptCallback {
    private let m_system: wref<OutfitSystem>;

    public func OnItemEquipped(slotID: TweakDBID, itemID: ItemID) -> Void {
        if this.m_system.IsActive() && ItemID.IsValid(itemID) {
            if Equals(slotID, t"AttachmentSlots.Outfit") {
                this.m_system.Deactivate();
            } else {
                if Equals(slotID, t"AttachmentSlots.TppHead") {
                    this.m_system.UpdateCameraDependentVisuals();
                }
            }
        }
    }

    public func OnItemEquippedVisual(slotID: TweakDBID, itemID: ItemID) -> Void {
        if this.m_system.IsActive() && ItemID.IsValid(itemID) {
            if this.m_system.IsBaseSlot(slotID) {
                this.m_system.ReattachVisualInSlot(this.m_system.GetItemSlot(itemID));
            }
        }
    }

    public func OnItemUnequippedComplete(slotID: TweakDBID, itemID: ItemID) -> Void {
        if this.m_system.IsActive() && ItemID.IsValid(itemID) {
            if this.m_system.IsBaseSlot(slotID) {
                this.m_system.ReattachVisualInSlot(this.m_system.GetItemSlot(itemID));
            }
        }
    }

    public static func Create(system: ref<OutfitSystem>) -> ref<PlayerSlotsCallback> {
        let self = new PlayerSlotsCallback();
        self.m_system = system;

        return self;
    }
}

class DelayedRestoreCallback extends DelayCallback {
    private let m_system: wref<OutfitSystem>;

    public func Call() {
        this.m_system.AttachAllVisualsToSlots();
    }

    public static func Create(system: ref<OutfitSystem>) -> ref<DelayedRestoreCallback> {
        let self = new DelayedRestoreCallback();
        self.m_system = system;

        return self;
    }
}

class DelayedAttachCallback extends DelayCallback {
    private let m_transactionSystem: wref<TransactionSystem>;
    private let m_player: wref<GameObject>;
    private let m_slotID: TweakDBID;
    private let m_itemID: ItemID;

    public func Call() {
        this.m_transactionSystem.AddItemToSlot(this.m_player, this.m_slotID, this.m_itemID, true);
    }

    public static func Create(transactionSystem: wref<TransactionSystem>, player: wref<GameObject>, slotID: TweakDBID, itemID: ItemID) -> ref<DelayedAttachCallback> {
        let self = new DelayedAttachCallback();
        self.m_transactionSystem = transactionSystem;
        self.m_player = player;
        self.m_slotID = slotID;
        self.m_itemID = itemID;

        return self;
    }
}
