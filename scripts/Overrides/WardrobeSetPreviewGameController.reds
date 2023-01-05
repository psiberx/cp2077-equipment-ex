import EquipmentEx.OutfitSystem

@addField(WardrobeSetPreviewGameController)
private let m_outfitSystem: wref<OutfitSystem>;

@wrapMethod(WardrobeSetPreviewGameController)
protected cb func OnInitialize() -> Bool {
    wrappedMethod();

    ArrayResize(this.cameraController.cameraSetup, Cast<Int32>(EnumGetMax(n"InventoryPaperdollZoomArea") + 1l));
    this.cameraController.cameraSetup[EnumInt(InventoryPaperdollZoomArea.Head)] = new gameuiPuppetPreviewCameraSetup(n"UISlotPreview_UpperBody", 1.85, 1);
}

@wrapMethod(WardrobeSetPreviewGameController)
protected cb func OnPreviewInitialized() -> Bool {
    this.m_outfitSystem = OutfitSystem.GetInstance(this.GetGamePuppet().GetGame());

    if this.m_isNotification && this.m_outfitSystem.IsActive() {
        this.m_outfitSystem.EquipPuppetOutfit(this.GetGamePuppet());
        this.m_outfitSystem.EquipPuppetItem(this.GetGamePuppet(), this.m_data.itemID);
    } else {
        wrappedMethod();
    }
}

@wrapMethod(WardrobeSetPreviewGameController)
public final func RestorePuppetEquipment() {
    wrappedMethod();

    if this.m_outfitSystem.IsActive() {
        this.m_outfitSystem.EquipPuppetOutfit(this.GetGamePuppet());
    }
}
