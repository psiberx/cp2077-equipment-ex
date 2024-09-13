import EquipmentEx.OutfitSystem

@addField(WardrobeSetPreviewGameController)
private let m_outfitSystem: wref<OutfitSystem>;

@wrapMethod(WardrobeSetPreviewGameController)
protected cb func OnInitialize() -> Bool {
    wrappedMethod();

    let cameraSetup: gameuiPuppetPreviewCameraSetup;
    cameraSetup.slotName = n"UISlotPreview_UpperBody";
    cameraSetup.cameraZoom = 1.85;
    cameraSetup.interpolationTime = 1;

    ArrayResize(this.cameraController.cameraSetup, Cast<Int32>(EnumGetMax(n"InventoryPaperdollZoomArea") + 1l));
    this.cameraController.cameraSetup[EnumInt(InventoryPaperdollZoomArea.Head)] = cameraSetup;
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
