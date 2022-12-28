module EquipmentEx

enum LegsState {
    Flat = 0,
    Lifted = 1,
}

public class PuppetAttachmentChangeRequest extends ScriptableSystemRequest {
    public let puppet: wref<ScriptedPuppet>;
    public let slotID: TweakDBID;
    public let itemID: ItemID;
    public let isEquipped: Bool;

    public static func Create(puppet: wref<ScriptedPuppet>, slotID: TweakDBID, itemID: ItemID, isEquipped: Bool) -> ref<PuppetAttachmentChangeRequest> {
        let self = new PuppetAttachmentChangeRequest();
        self.puppet = puppet;
        self.slotID = slotID;
        self.itemID = itemID;
        self.isEquipped = isEquipped;

        return self;
    }
}

public class PuppetAppearanceChangeRequest extends ScriptableSystemRequest {
    public let puppet: wref<ScriptedPuppet>;

    public static func Create(puppet: wref<ScriptedPuppet>) -> ref<PuppetAppearanceChangeRequest> {
        let self = new PuppetAppearanceChangeRequest();
        self.puppet = puppet;

        return self;
    }
}

public class PuppetStateSystem extends ScriptableSystem {
    private let m_legsSlots: array<TweakDBID>;
    private let m_feetSlots: array<TweakDBID>;

    private let m_transactionSystem: wref<TransactionSystem>;

    private func OnAttach() {
        ArrayPush(this.m_legsSlots, t"AttachmentSlots.Legs");
        ArrayPush(this.m_feetSlots, t"AttachmentSlots.Feet");

        for outfitSlot in OutfitConfig.OutfitSlots() {
            if Equals(outfitSlot.parentID, t"AttachmentSlots.Legs") {
                ArrayPush(this.m_legsSlots, outfitSlot.slotID);
            }
            if Equals(outfitSlot.parentID, t"AttachmentSlots.Feet") {
                ArrayPush(this.m_feetSlots, outfitSlot.slotID);
            }
        }
    }

    private func OnPlayerAttach(request: ref<PlayerAttachRequest>) {
        this.m_transactionSystem = GameInstance.GetTransactionSystem(this.GetGameInstance());
    }

    private func OnAttachmentChange(request: ref<PuppetAttachmentChangeRequest>) {
        if this.IsFeetSlot(request.slotID) || this.IsFeetCovering(request.itemID) {
            this.UpdateLegsState(request.puppet);
            this.RefreshItemAppearances(request.puppet);
        }

        if request.isEquipped && this.IsLegsSlot(request.slotID) {
            this.RefreshItemAppearance(request.puppet, request.itemID);
        }
    }

    private func RefreshItemAppearances(puppet: wref<ScriptedPuppet>) {
        for slotID in this.m_legsSlots {
            let itemObject = this.m_transactionSystem.GetItemInSlot(puppet, slotID);
            if IsDefined(itemObject) {
                this.RefreshItemAppearance(puppet, itemObject.GetItemID());
            }
        }
    }

    private func RefreshItemAppearance(puppet: wref<ScriptedPuppet>, itemID: ItemID) {
        let itemAppearance = this.m_transactionSystem.GetItemAppearance(puppet, itemID);

        if NotEquals(itemAppearance, n"") && NotEquals(itemAppearance, n"empty_appearance_default") {
            this.m_transactionSystem.ResetItemAppearance(puppet, itemID);
        }
    }

    private func UpdateLegsState(puppet: wref<ScriptedPuppet>) {
        puppet.m_legsState = this.ResolveLegsState(puppet);
    }

    private func ResolveLegsState(puppet: wref<ScriptedPuppet>) -> LegsState {
        let state = LegsState.Flat;

        for slotID in this.m_feetSlots {
            if !this.m_transactionSystem.IsSlotEmpty(puppet, slotID) || this.m_transactionSystem.IsSlotEmptySpawningItem(puppet, slotID) {
                let itemObject = this.m_transactionSystem.GetItemInSlot(puppet, slotID);
                let itemAppearance = this.m_transactionSystem.GetItemAppearance(puppet, itemObject.GetItemID());

                if NotEquals(itemAppearance, n"empty_appearance_default") {
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

    private func IsFeetCovering(itemID: ItemID) -> Bool {
        return false; // hide_S1
    }

    public func GetLegsStateSuffix(itemD: ItemID, owner: wref<GameObject>, suffixRecord: ref<ItemsFactoryAppearanceSuffixBase_Record>) -> String {
        let puppet = owner as ScriptedPuppet;

        if !IsDefined(puppet) || Equals(puppet.GetResolvedGenderName(), n"Male") {
            return "";
        }

        return ToString(puppet.m_legsState);
    }
}
