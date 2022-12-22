module EquipmentEx

class InventoryGridItemController extends VendorItemVirtualController {
    protected cb func OnOutfitUpdated(evt: ref<OutfitUpdated>) {
        this.UpdateEquippedState();
    }

    protected cb func OnOutfitPartUpdated(evt: ref<OutfitPartUpdated>) {
        this.UpdateEquippedState();
    }

    protected func UpdateEquippedState() {
        this.m_itemViewController.NewUpdateEquipped(this.m_itemViewController.m_uiInventoryItem);
        this.m_itemViewController.NewUpdateLocked(this.m_itemViewController.m_uiInventoryItem);
    }
}
