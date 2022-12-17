import EquipmentEx.InventoryHelper

@wrapMethod(inkInventoryPuppetPreviewGameController)
protected cb func OnInitialize() -> Bool {
    wrappedMethod();

    InventoryHelper.GetInstance(this.GetPlayerControlledObject().GetGame()).AddPreview(this);
}
