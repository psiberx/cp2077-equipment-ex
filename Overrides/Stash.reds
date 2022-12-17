import EquipmentEx.InventoryHelper

@addMethod(Stash)
protected cb func OnGameAttached() -> Bool {
    InventoryHelper.GetInstance(this.GetGame()).AddStash(this);
}
