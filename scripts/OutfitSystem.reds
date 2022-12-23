module EquipmentEx

public class OutfitSystem extends ScriptableSystem {
    private persistent let m_state: ref<OutfitState>;
    private let m_firstUse: Bool;

    private let m_baseSlots: array<TweakDBID>;
    private let m_outfitSlots: array<TweakDBID>;
    private let m_managedSlots: array<TweakDBID>;

    private let m_player: wref<GameObject>;
    private let m_equipmentData: wref<EquipmentSystemPlayerData>;
    private let m_transactionSystem: wref<TransactionSystem>;
    private let m_attachmentSlotsListener: ref<AttachmentSlotsScriptListener>;

    private let m_equipmentDef: wref<UI_EquipmentDef>;
    private let m_equipmentBlackboard: wref<IBlackboard>;

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

        if this.m_state.IsActive() {
            this.HideEquipment();
            this.AttachAllVisualsToSlots();
        }
    }

    private func OnPlayerAttach(request: ref<PlayerAttachRequest>) {
        this.InitializePlayerAndSystems();
        this.ConvertWardrobeSets();
    }

    private func OnQuestDisableWardrobeSetRequest(request: ref<QuestDisableWardrobeSetRequest>) {
        this.Deactivate();
    }

    private func OnQuestEnableWardrobeSetRequest(request: ref<QuestEnableWardrobeSetRequest>) {
        // this.Activate();
    }

    private func OnQuestRestoreWardrobeSetRequest(request: ref<QuestRestoreWardrobeSetRequest>) {
        this.Reactivate();
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
        }
        for outfitSlot in OutfitConfig.OutfitSlots() {
            ArrayPush(this.m_outfitSlots, outfitSlot.slotID);
            ArrayPush(this.m_managedSlots, outfitSlot.slotID);
        }
    }

    private func InitializeBlackboards() {
        this.m_equipmentDef = GetAllBlackboardDefs().UI_Equipment;
        this.m_equipmentBlackboard = GameInstance.GetBlackboardSystem(this.GetGameInstance()).Get(this.m_equipmentDef);
    }

    private func InitializePlayerAndSystems() {
        this.m_player = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerControlledGameObject();
        this.m_equipmentData = EquipmentSystem.GetData(this.m_player);
        this.m_transactionSystem = GameInstance.GetTransactionSystem(this.GetGameInstance());
        this.m_attachmentSlotsListener = this.m_transactionSystem.RegisterAttachmentSlotListener(this.m_player, AttachmentSlotsCallback.Create(this));
    }

    private func UninitializeSystems() {
        if IsDefined(this.m_attachmentSlotsListener) {
            this.m_transactionSystem.UnregisterAttachmentSlotListener(this.m_player, this.m_attachmentSlotsListener);
        }
    }

    private func ConvertWardrobeSets() {
        if this.m_firstUse {
            let wardrobeSystem = GameInstance.GetWardrobeSystem(this.GetGameInstance());
            let clothingSets = wardrobeSystem.GetClothingSets();

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
                    let outfitName = StringToName("Wardrobe Set " + ToString(EnumInt(clothingSet.setID) + 1));
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

    private func AttachVisualToSlot(itemID: ItemID, slotID: TweakDBID) {
        let previewID = this.m_transactionSystem.CreatePreviewItemID(itemID);
        this.m_transactionSystem.GivePreviewItemByItemID(this.m_player, itemID);
        this.m_transactionSystem.AddItemToSlot(this.m_player, slotID, previewID, true);

        this.TriggerAttachmentEvent(itemID, slotID);
        this.UpdateBlackboard(itemID, slotID);
    }

    private func DetachVisualFromSlot(itemID: ItemID, slotID: TweakDBID) {
        let previewID = this.m_transactionSystem.CreatePreviewItemID(itemID);
        this.m_transactionSystem.RemoveItemFromSlot(this.m_player, slotID);
        this.m_transactionSystem.RemoveItem(this.m_player, previewID, 1);

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
            let itemID = part.GetItemID();
            let previewID = this.m_transactionSystem.CreatePreviewItemID(itemID);
            this.m_transactionSystem.RemoveItemFromSlot(this.m_player, slotID);
            this.m_transactionSystem.AddItemToSlot(this.m_player, slotID, previewID, true);
        }
    }

    private func ReattachItemInSlot(slotID: TweakDBID) {
        let itemObject = this.m_transactionSystem.GetItemInSlot(this.m_player, slotID);
        if IsDefined(itemObject) {
            let itemID = itemObject.GetItemID();
            this.m_transactionSystem.RemoveItemFromSlot(this.m_player, slotID);
            this.m_transactionSystem.AddItemToSlot(this.m_player, slotID, itemID);
        }
    }

    private func RefreshSlotAttachment(slotID: TweakDBID) {
        this.m_transactionSystem.RefreshAttachment(this.m_player, slotID);
    }

    private func CloneEquipment(opt ignoreItemID: ItemID, opt ignoreSlotID: TweakDBID) {
        for baseSlotID in this.m_baseSlots {
            let itemObject = this.m_transactionSystem.GetItemInSlot(this.m_player, baseSlotID);
            if IsDefined(itemObject) {
                let itemID = itemObject.GetItemID();
                if NotEquals(itemID, ignoreItemID){
                    let slotID = this.GetItemSlot(itemID);
                    if NotEquals(slotID, ignoreSlotID) {
                        this.EquipItem(itemID);
                        this.RefreshSlotAttachment(slotID);
                    }
                }
            }
        }
    }

    private func HideEquipment() {
        this.m_equipmentData.UnequipItem(this.m_equipmentData.GetEquipAreaIndex(gamedataEquipmentArea.Outfit));

        for baseSlot in OutfitConfig.BaseSlots() {
            this.m_equipmentData.ClearVisuals(baseSlot.equipmentArea);
        }
    }

    private func ShowEquipment() {
        for baseSlot in OutfitConfig.BaseSlots() {
            this.m_equipmentData.UnequipVisuals(baseSlot.equipmentArea);
        }
    }

    public func IsActive() -> Bool {
        return this.m_state.IsActive();
    }

    public func Activate() {
        if !this.m_state.IsActive() {
            this.HideEquipment();

            this.m_state.SetActive(true);
            this.m_state.ClearParts();

            this.CloneEquipment();
            
            this.TriggerActivationEvent();
        }
    }

    private func ActivateWithoutClone() {
        if !this.m_state.IsActive() {
            this.HideEquipment();

            this.m_state.SetActive(true);
            this.m_state.ClearParts();

            this.TriggerActivationEvent();
        }
    }

    private func ActivateWithoutSlot(slotID: TweakDBID) {
        if !this.m_state.IsActive() {
            this.HideEquipment();

            this.m_state.SetActive(true);
            this.m_state.ClearParts();

            this.CloneEquipment(ItemID.None(), slotID);

            this.TriggerActivationEvent();
        }
    }

    private func ActivateWithoutItem(itemID: ItemID) {
        if !this.m_state.IsActive() {
            this.HideEquipment();

            this.m_state.SetActive(true);
            this.m_state.ClearParts();

            this.CloneEquipment(itemID, TDBID.None());

            this.TriggerActivationEvent();
        }
    }

    public func Reactivate() {
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
        let itemData = this.m_transactionSystem.GetItemDataByTDBID(this.m_player, recordID);

        if !IsDefined(itemData) {
            return false;
        }

        return this.UnequipItem(itemData.GetID());
    }

    public func UnequipItem(itemID: ItemID) -> Bool {
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
        this.Activate();

        for part in this.m_state.GetParts() {
            if this.IsOutfitSlot(part.GetSlotID()) {
                this.RemoveItemFromState(part.GetItemID());
                this.DetachVisualFromSlot(part.GetItemID(), part.GetSlotID());
            }
        }
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

    public func UpdatePuppetFromBlackboard(puppet: ref<gamePuppet>) {
        if !IsDefined(puppet) || !this.m_state.IsActive() {
            return;
        }

        let modifiedArea = FromVariant<SPaperdollEquipData>(this.m_equipmentBlackboard.GetVariant(this.m_equipmentDef.lastModifiedArea)); 
        let slotID = modifiedArea.placementSlot;      

        if !this.IsOutfitSlot(slotID) {
            return;
        }

        let itemID = FromVariant<ItemID>(this.m_equipmentBlackboard.GetVariant(this.m_equipmentDef.itemEquipped));
        let itemObject = this.m_transactionSystem.GetItemInSlot(puppet, slotID);

        if IsDefined(itemObject) {
            let previewID = itemObject.GetItemID();

            if Equals(previewID, itemID) {
                return;
            }

            this.m_transactionSystem.RemoveItemFromSlot(puppet, slotID);
            this.m_transactionSystem.RemoveItem(puppet, previewID, 1);
        }

        if ItemID.IsValid(itemID) && modifiedArea.equipped {
            let previewID = this.m_transactionSystem.CreatePreviewItemID(itemID);
            this.m_transactionSystem.GivePreviewItemByItemID(puppet, itemID);
            this.m_transactionSystem.AddItemToSlot(puppet, slotID, previewID, true);
        }
    }

    public func UpdatePuppetFromState(puppet: ref<gamePuppet>, opt items: script_ref<array<ItemID>>) {
        if !IsDefined(puppet) || !this.m_state.IsActive() {
            return;
        }

        for slotID in this.m_managedSlots {
            this.m_transactionSystem.RemoveItemFromSlot(puppet, slotID);
        }

        for part in this.m_state.GetParts() {
            let itemID = part.GetItemID();
            let slotID = part.GetSlotID();

            let previewID = this.m_transactionSystem.CreatePreviewItemID(itemID);
            this.m_transactionSystem.GivePreviewItemByItemID(puppet, itemID);
            this.m_transactionSystem.AddItemToSlot(puppet, slotID, previewID, true);

            ArrayPush(Deref(items), previewID);
        }
    }

    public func IsEquipped(name: CName) -> Bool {
        return this.m_state.IsActive() ? this.m_state.IsOutfit(name) : Equals(name, n"");
    }

    public func HasOutfit(name: CName) -> Bool {
        return IsDefined(this.m_state.GetOutfit(name));
    }

    public func LoadOutfit(name: CName) -> Bool {
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

    public func GetOutfits() -> array<CName> {
        let outfits: array<CName>;
        
        // for outfit in this.m_state.GetOutfits() {
        //     let index = 0;
        //     while index < ArraySize(outfits) && StrCmp(NameToString(outfit.GetName()), NameToString(outfits[index])) > 0 {
        //         index += 1;
        //     }
        //     ArrayInsert(outfits, index, outfit.GetName());
        // }

        for outfit in this.m_state.GetOutfits() {
            ArrayPush(outfits, outfit.GetName());
        }

        return outfits;
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

    public func GetSlotName(slotID: TweakDBID) -> String {
        let key = TweakDBInterface.GetAttachmentSlotRecord(slotID).LocalizedName();
        let name = GetLocalizedTextByKey(StringToName(key));
        return NotEquals(name, "") ? name : key;
    }

    public func GetItemName(itemID: ItemID) -> String {
        return ItemID.IsValid(itemID) ? GetLocalizedTextByKey(TweakDBInterface.GetItemRecord(ItemID.GetTDBID(itemID)).DisplayName()) : "";
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

    private func GetLegsStateSuffix(itemD: ItemID, owner: wref<GameObject>, suffixRecord: ref<ItemsFactoryAppearanceSuffixBase_Record>) -> String {
        if Equals((this.m_player as gamePuppet).GetResolvedGenderName(), n"Male") {
            return "";
        }

        let isLifted = this.m_state.IsActive()
            ? !this.m_transactionSystem.IsSlotEmpty(this.m_player, t"OutfitSlots.Feet") 
                || this.m_transactionSystem.IsSlotEmptySpawningItem(this.m_player, t"OutfitSlots.Feet")
            : !this.m_transactionSystem.IsSlotEmpty(this.m_player, t"AttachmentSlots.Feet") 
                || this.m_transactionSystem.IsSlotEmptySpawningItem(this.m_player, t"AttachmentSlots.Feet");
        
        return isLifted ? "Lifted" : "Flat";
    }

    public static func GetInstance(game: GameInstance) -> ref<OutfitSystem> {
        return GameInstance.GetScriptableSystemsContainer(game).Get(n"EquipmentEx.OutfitSystem") as OutfitSystem;
    }
}

public class AttachmentSlotsCallback extends AttachmentSlotsScriptCallback {
    private let m_system: wref<OutfitSystem>;

    public func OnItemEquipped(slotID: TweakDBID, itemID: ItemID) -> Void {
        if ItemID.IsValid(itemID) && Equals(slotID, t"AttachmentSlots.Outfit") {
            this.m_system.Deactivate();
        }
    }

    public func OnItemEquippedVisual(slotID: TweakDBID, itemID: ItemID) -> Void {
        if this.m_system.IsActive() && this.m_system.IsBaseSlot(slotID) {
            this.m_system.ReattachVisualInSlot(this.m_system.GetItemSlot(itemID));
        }
    }

    public func OnItemUnequippedComplete(slotID: TweakDBID, itemID: ItemID) -> Void {
        if this.m_system.IsActive() && this.m_system.IsBaseSlot(slotID) {
            this.m_system.ReattachVisualInSlot(this.m_system.GetItemSlot(itemID));
        }
    }

    public static func Create(system: ref<OutfitSystem>) -> ref<AttachmentSlotsCallback> {
        let self = new AttachmentSlotsCallback();
        self.m_system = system;

        return self;
    }
}
