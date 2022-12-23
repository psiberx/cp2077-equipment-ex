import EquipmentEx.OutfitSystem

@addField(PhotoModePlayerEntityComponent)
private let m_outfitSystem: wref<OutfitSystem>;

@wrapMethod(PhotoModePlayerEntityComponent)
private final func OnGameAttach() {
    wrappedMethod();

    this.m_outfitSystem = OutfitSystem.GetInstance(this.GetOwner().GetGame());
}

@wrapMethod(PhotoModePlayerEntityComponent)
private final func SetupInventory(isCurrentPlayerObjectCustomizable: Bool) {
    wrappedMethod(isCurrentPlayerObjectCustomizable);

    if this.m_outfitSystem.IsActive() {
        this.m_outfitSystem.UpdatePuppetFromState(this.fakePuppet, this.loadingItems);
    }
}

@wrapMethod(PhotoModePlayerEntityComponent)
protected cb func OnItemAddedToSlot(evt: ref<ItemAddedToSlot>) -> Bool {
    if this.m_outfitSystem.IsActive() {
        ArrayRemove(this.loadingItems, evt.GetItemID());
    } else {
        wrappedMethod(evt);
    }
}
