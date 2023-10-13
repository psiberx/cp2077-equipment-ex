import EquipmentEx.OutfitSystem

@addField(BackpackMainGameController)
private let m_outfitSystem: wref<OutfitSystem>;

@addField(BackpackMainGameController)
private let m_outfitSystem: wref<OutfitSystem>;

@wrapMethod(BackpackMainGameController)
protected cb func OnInitialize() -> Bool {
    wrappedMethod();

    this.m_outfitSystem = OutfitSystem.GetInstance(this.GetPlayerControlledObject().GetGame());
}

@wrapMethod(BackpackMainGameController)
protected cb func OnItemDisplayClick(evt: ref<ItemDisplayClickEvent>) -> Bool {
    if this.m_outfitSystem.IsActive() && evt.actionName.IsAction(n"preview_item") {
        if evt.uiInventoryItem.IsClothing() {
            return false;
        }
    }

    return wrappedMethod(evt);
}

@wrapMethod(BackpackMainGameController)
private final func NewShowItemHints(itemData: wref<UIInventoryItem>) {
    wrappedMethod(itemData);

    if this.m_outfitSystem.IsActive() {
        if itemData.IsClothing() {
            this.m_buttonHintsController.RemoveButtonHint(n"preview_item");
        }
    }
}
