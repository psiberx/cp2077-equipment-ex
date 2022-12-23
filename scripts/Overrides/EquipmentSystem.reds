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
    wrappedMethod();
    
    this.UnequipWardrobeSet();
}

@replaceMethod(EquipmentSystemPlayerData)
public final func EquipWardrobeSet(setID: gameWardrobeClothingSetIndex) {}
