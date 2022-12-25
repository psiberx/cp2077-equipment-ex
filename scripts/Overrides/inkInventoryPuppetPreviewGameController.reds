import EquipmentEx.PaperdollHelper

@wrapMethod(inkInventoryPuppetPreviewGameController)
protected cb func OnInitialize() -> Bool {
    wrappedMethod();

    PaperdollHelper.GetInstance(this.GetPlayerControlledObject().GetGame()).AddPreview(this);
}
