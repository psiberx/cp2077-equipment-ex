@wrapMethod(WardrobeSetPreviewGameController)
protected cb func OnInitialize() -> Bool {
    wrappedMethod();

    ArrayResize(this.cameraController.cameraSetup, Cast<Int32>(EnumGetMax(n"InventoryPaperdollZoomArea") + 1l));
    this.cameraController.cameraSetup[EnumInt(InventoryPaperdollZoomArea.Head)] = new gameuiPuppetPreviewCameraSetup(n"UISlotPreview_UpperBody", 1.85, 1);
}
