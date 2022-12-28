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
