import EquipmentEx.OutfitSystem

@wrapMethod(CraftingGarmentItemPreviewGameController)
protected cb func OnCrafrtingPreview(evt: ref<CraftingItemPreviewEvent>) -> Bool {
    if this.m_outfitSystem.IsActive() {
        if ItemID.IsValid(this.m_previewedItem) {
            this.m_previewedItem = ItemID.None();
            this.m_outfitSystem.EquipPuppetOutfit(this.GetGamePuppet());
        }
        
        if evt.isGarment {
            this.m_previewedItem = evt.itemID;
            this.m_outfitSystem.EquipPuppetItem(this.GetGamePuppet(), this.m_previewedItem);
        }
    } else {
        wrappedMethod(evt);
    }
}
