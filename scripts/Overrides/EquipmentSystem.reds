import EquipmentEx.OutfitSystem

@addField(EquipmentSystemPlayerData)
private let m_outfitSystem: wref<OutfitSystem>;

@wrapMethod(EquipmentSystemPlayerData)
public final func OnAttach() {
    wrappedMethod();
    
    this.m_outfitSystem = OutfitSystem.GetInstance(this.m_owner.GetGame());
}

@wrapMethod(EquipmentSystemPlayerData)
public final const func IsVisualSetActive() -> Bool {
    return wrappedMethod() || this.m_outfitSystem.IsActive();
}

@wrapMethod(EquipmentSystemPlayerData)
public final const func IsSlotOverriden(area: gamedataEquipmentArea) -> Bool {
    return wrappedMethod(area) || this.m_outfitSystem.IsActive();
}

@wrapMethod(EquipmentSystemPlayerData)
public final func OnRestored() {
    this.m_wardrobeSystem = GameInstance.GetWardrobeSystem(this.m_owner.GetGame());

    if NotEquals(this.m_wardrobeSystem.GetActiveClothingSetIndex(), gameWardrobeClothingSetIndex.INVALID) {
        this.m_wardrobeSystem.SetActiveClothingSetIndex(gameWardrobeClothingSetIndex.INVALID);
        this.m_lastActiveWardrobeSet = gameWardrobeClothingSetIndex.INVALID;

        let i = 0;
        while i <= ArraySize(this.m_clothingVisualsInfo) {
            this.m_clothingVisualsInfo[i].isHidden = false;
            this.m_clothingVisualsInfo[i].visualItem = ItemID.None();
            i += 1;
        }
    }

    wrappedMethod();
}

@replaceMethod(EquipmentSystemPlayerData)
public final func EquipWardrobeSet(setID: gameWardrobeClothingSetIndex) {}

@wrapMethod(EquipmentSystemPlayerData)
private final func ResetItemAppearance(area: gamedataEquipmentArea, opt force: Bool) -> Void {
    wrappedMethod(area, force);

    if Equals(area, gamedataEquipmentArea.Feet) && !this.IsSlotHidden(area) && !this.IsSlotOverriden(area) {
        let itemID = this.GetActiveItem(area);
        if ItemID.IsValid(itemID) {
            let slotID = this.GetPlacementSlotByAreaType(area);
            let transactionSystem = GameInstance.GetTransactionSystem(this.m_owner.GetGame());
            transactionSystem.RemoveItemFromSlot(this.m_owner, slotID);
            GameInstance.GetDelaySystem(this.m_owner.GetGame()).DelayCallback(EquipmentSystemReattachItem.Create(this, slotID, itemID), 1.0 / 60.0, false);
        }
    }
}

class EquipmentSystemReattachItem extends DelayCallback {
    protected let m_data: ref<EquipmentSystemPlayerData>;
    protected let m_slotID: TweakDBID;
    protected let m_itemID: ItemID;

    public func Call() -> Void {
        let transactionSystem = GameInstance.GetTransactionSystem(this.m_data.m_owner.GetGame());
        transactionSystem.AddItemToSlot(this.m_data.m_owner, this.m_slotID, this.m_itemID, true);
    }

    public static func Create(data: ref<EquipmentSystemPlayerData>, slotID: TweakDBID, itemID: ItemID) -> ref<EquipmentSystemReattachItem> {
        let self = new EquipmentSystemReattachItem();
        self.m_data = data;
        self.m_slotID = slotID;
        self.m_itemID = itemID;

        return self;
    }
}
