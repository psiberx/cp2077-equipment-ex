module EquipmentEx

public class VirtualGridItemController extends VendorItemVirtualController {
    protected cb func OnOutfitItemUpdated(evt: ref<OutfitItemUpdated>) {
        if Equals(this.m_newData.Item.GetID(), evt.itemID) {
            this.m_itemViewController.NewUpdateEquipped(this.m_itemViewController.m_uiInventoryItem);
        }
    }
}
