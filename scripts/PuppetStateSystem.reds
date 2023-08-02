module EquipmentEx

enum LegsState {
    Flat = 0,
    Lifted = 1,
    HighHeels = 2,
    FlatShoes = 3,
}

public class PuppetStateSystem extends ScriptableSystem {
    private let m_legsSlots: array<TweakDBID>;
    private let m_feetSlots: array<TweakDBID>;

    private let m_transactionSystem: wref<TransactionSystem>;
    private let m_listeners: array<ref<AttachmentSlotsScriptListener>>;
    private let m_handlers: array<ref<PuppetStateHandler>>;
    private let m_handlerMap: ref<inkHashMap>;

    private func OnAttach() {
        ArrayPush(this.m_legsSlots, t"AttachmentSlots.Legs");
        ArrayPush(this.m_feetSlots, t"AttachmentSlots.Feet");

        for outfitSlot in OutfitConfig.OutfitSlots() {
            if outfitSlot.coversLegs {
                ArrayPush(this.m_legsSlots, outfitSlot.slotID);
            }
            if outfitSlot.switchesLegs {
                ArrayPush(this.m_feetSlots, outfitSlot.slotID);
            }
        }

        this.m_transactionSystem = GameInstance.GetTransactionSystem(this.GetGameInstance());
        this.m_handlerMap = new inkHashMap();
    }

    private func OnDetach() {
        ArrayClear(this.m_handlers);
        ArrayClear(this.m_listeners);

        this.m_handlerMap.Clear();
    }

    private func RegisterPuppet(puppet: ref<GameObject>) {
        let key = Cast<Uint64>(EntityID.GetHash(puppet.GetEntityID()));

        if this.m_handlerMap.KeyExist(key) {
            return;
        }

        let handler = PuppetStateHandler.Create(this, puppet);
        let listener = this.m_transactionSystem.RegisterAttachmentSlotListener(puppet, handler);

        ArrayPush(this.m_handlers, handler);
        ArrayPush(this.m_listeners, listener);

        this.m_handlerMap.Insert(key, handler);
    }

    private func UnregisterPuppet(puppet: ref<GameObject>) {
        let key = Cast<Uint64>(EntityID.GetHash(puppet.GetEntityID()));

        if !this.m_handlerMap.KeyExist(key) {
            return;
        }

        let handler = this.m_handlerMap.Get(key) as PuppetStateHandler;
        let index: Int32; // = ArrayFindFirst(this.m_handlers, handler);

        while index < ArraySize(this.m_handlers) {
            if Equals(handler, this.m_handlers[index]) {
                break;
            }
            index += 1;
        }

        ArrayErase(this.m_handlers, index);
        ArrayErase(this.m_listeners, index);

        this.m_handlerMap.Remove(key);
    }

    private func RefreshItemAppearances(puppet: wref<GameObject>) {
        for slotID in this.m_legsSlots {
            let itemObject = this.m_transactionSystem.GetItemInSlot(puppet, slotID);
            if IsDefined(itemObject) {
                this.RefreshItemAppearance(puppet, itemObject.GetItemID());
            }
        }
    }

    private func RefreshItemAppearance(puppet: wref<GameObject>, itemID: ItemID) {
        let itemAppearance = this.m_transactionSystem.GetItemAppearance(puppet, itemID);

        if NotEquals(itemAppearance, n"") && NotEquals(itemAppearance, n"empty_appearance_default") {
            this.m_transactionSystem.ResetItemAppearance(puppet, itemID);
        }
    }

    private func ResolveLegsState(puppet: wref<GameObject>) -> LegsState {
        let state = LegsState.Flat;

        for slotID in this.m_feetSlots {
            if !this.m_transactionSystem.IsSlotEmpty(puppet, slotID) || this.m_transactionSystem.IsSlotEmptySpawningItem(puppet, slotID) {
                let itemObject = this.m_transactionSystem.GetItemInSlot(puppet, slotID);
                let itemAppearance = this.m_transactionSystem.GetItemAppearance(puppet, itemObject.GetItemID());

                if NotEquals(itemAppearance, n"") && NotEquals(itemAppearance, n"empty_appearance_default") {
                    if this.m_transactionSystem.MatchVisualTag(itemObject, n"HighHeels") {
                        state = LegsState.HighHeels;
                        break;
                    }
                    
                    if this.m_transactionSystem.MatchVisualTag(itemObject, n"FlatShoes")
                        || this.m_transactionSystem.MatchVisualTag(itemObject, n"force_FlatFeet") {
                        state = LegsState.FlatShoes;
                        break;
                    }

                    state = LegsState.Lifted;
                    break;
                }                
            }
        }

        return state;
    }

    private func IsLegsSlot(slotID: TweakDBID) -> Bool {
        return ArrayContains(this.m_legsSlots, slotID);
    }

    private func IsFeetSlot(slotID: TweakDBID) -> Bool {
        return ArrayContains(this.m_feetSlots, slotID);
    }

    private func IsFeetCovering(puppet: wref<GameObject>, itemID: ItemID) -> Bool {
        return this.m_transactionSystem.MatchVisualTagByItemID(itemID, puppet, n"hide_S1");
    }

    public func GetLegsStateSuffix(itemID: ItemID, owner: wref<GameObject>, suffixRecord: ref<ItemsFactoryAppearanceSuffixBase_Record>) -> String {
        let puppet = owner as ScriptedPuppet;

        if !IsDefined(puppet) || Equals(puppet.GetResolvedGenderName(), n"Male") {
            return "";
        }

        let key = Cast<Uint64>(EntityID.GetHash(puppet.GetEntityID()));

        if !this.m_handlerMap.KeyExist(key) {
            return "";
        }

        let handler = this.m_handlerMap.Get(key) as PuppetStateHandler;

        if !IsDefined(handler) {
            return "";
        }

        return ToString(handler.m_legsState);
    }

    public static func GetInstance(game: GameInstance) -> ref<PuppetStateSystem> {
        return GameInstance.GetScriptableSystemsContainer(game).Get(n"EquipmentEx.PuppetStateSystem") as PuppetStateSystem;
    }
}

public class PuppetStateHandler extends AttachmentSlotsScriptCallback {
    private let m_system: wref<PuppetStateSystem>;
    private let m_puppet: wref<GameObject>;
    private let m_legsState: LegsState;

    public func OnItemEquipped(slotID: TweakDBID, itemID: ItemID) -> Void {
        if IsDefined(this.m_puppet) {
            this.HandleAppearanceChange(slotID, itemID);

            // if this.m_system.IsLegsSlot(slotID) {
            //    this.m_system.RefreshItemAppearance(this.m_puppet, itemID);
            // }
        }
    }

    public func OnItemEquippedVisual(slotID: TweakDBID, itemID: ItemID) -> Void {
        if IsDefined(this.m_puppet) {
            this.HandleAppearanceChange(slotID, itemID);
        }
    }

    public func OnItemUnequipped(slotID: TweakDBID, itemID: ItemID) -> Void {
        if IsDefined(this.m_puppet) {
            this.HandleAppearanceChange(slotID, itemID);
        }
    }

    private func HandleAppearanceChange(slotID: TweakDBID, itemID: ItemID) {
        if this.m_system.IsFeetSlot(slotID) || this.m_system.IsFeetCovering(this.m_puppet, itemID) {
            if this.UpdateLegsState() {
                this.m_system.RefreshItemAppearances(this.m_puppet);
            }
        }
    }

    private func UpdateLegsState() -> Bool {
        let state = this.m_system.ResolveLegsState(this.m_puppet);
        let updated = NotEquals(this.m_legsState, state);
        this.m_legsState = state;
        return updated;
    }

    public static func Create(system: ref<PuppetStateSystem>, puppet: ref<GameObject>) -> ref<PuppetStateHandler> {
        let self = new PuppetStateHandler();
        self.m_system = system;
        self.m_puppet = puppet;

        return self;
    }
}
