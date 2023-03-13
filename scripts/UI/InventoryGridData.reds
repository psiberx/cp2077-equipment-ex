module EquipmentEx

class InventoryGridItemData extends VendorUIInventoryItemData {
    public let SlotIndex: Int32;
    public let ItemIndex: Int32;
    public let Parent: wref<InventoryGridSlotData>;
    public let IsVisible: Bool;
}

class InventoryGridSlotData extends VendorUIInventoryItemData {
    public let SlotIndex: Int32;
    public let ItemIndex: Int32;
    public let Children: array<wref<InventoryGridItemData>>;
    public let TotalItems: Int32;
    public let VisibleItems: Int32;
    public let IsCollapsed: Bool;

    protected func GetActiveItem() -> wref<InventoryGridItemData> {
        for uiItem in this.Children {
            if uiItem.Item.IsEquipped() {
                return uiItem;
            }
        }

        return null;
    }
}

class InventoryGridDataView extends BackpackDataView {
    private let m_filter: Bool;
    private let m_refresh: Bool;
    private let m_reverse: Bool;
    private let m_searchQuery: String;
    private let m_viewManager: wref<ViewManager>;

    public func SetViewManager(viewManager: wref<ViewManager>) {
        this.m_viewManager = viewManager;
    }

    public func SetCollapsed(state: Bool) {
        this.m_viewManager.SetCollapsed(state);
    }

    public func ToggleCollapsed() {
        this.m_viewManager.ToggleCollapsed();
    }

    public func ToggleCollapsed(slotID: TweakDBID) {
        this.m_viewManager.ToggleCollapsed(slotID);
    }

    public func SetSearchQuery(searchQuery: String) {
        this.m_searchQuery = StrLower(searchQuery);
    }

    public func UpdateView() {
        this.DisableSorting();
        this.m_filter = true;
        this.Filter();
        this.m_filter = false;
        this.Filter();
    }

    public func FilterItem(data: ref<IScriptable>) -> Bool {
        let uiItem = data as InventoryGridItemData;

        if IsDefined(uiItem) {
            if this.m_filter {
                uiItem.IsVisible = true;

                if Equals(this.m_itemFilterType, ItemFilterCategory.Clothes) {
                    if !uiItem.Item.IsEquipped() {
                        uiItem.IsVisible = false;
                    }
                }

                if NotEquals(this.m_searchQuery, "") {
                    let itemName = StrLower(uiItem.Item.GetName());
                    if !StrContains(itemName, this.m_searchQuery) {
                        uiItem.IsVisible = false;
                    }
                }
            }

            return uiItem.IsVisible && !uiItem.Parent.IsCollapsed;
        }

        let uiSlot = data as InventoryGridSlotData;

        if IsDefined(uiSlot) {
            if this.m_filter {
                uiSlot.IsCollapsed = this.m_viewManager.IsCollapsed(uiSlot.ItemData.SlotID);
            } else {
                uiSlot.TotalItems = ArraySize(uiSlot.Children);
                uiSlot.VisibleItems = 0;

                for uiChildData in uiSlot.Children {
                    if uiChildData.IsVisible {
                        uiSlot.VisibleItems += 1;
                    }
                }
            }

            return uiSlot.VisibleItems > 0;
        }

        return false;
    }
}

class InventoryGridTemplateClassifier extends inkVirtualItemTemplateClassifier {
    public func ClassifyItem(data: Variant) -> Uint32 {
        return IsDefined(FromVariant<ref<IScriptable>>(data) as InventoryGridSlotData) ? 1u : 0u;
    }
}
