module EquipmentEx

public class VirtualGridItemData extends VendorUIInventoryItemData {
    public let GroupIndex: Int32;
    public let ItemIndex: Int32;
    public let IsVisible: Bool;
}

public class VirtualGridGroupData extends VirtualGridItemData {
    public let Children: array<wref<VirtualGridItemData>>;

    protected func GetActiveItem() -> wref<VirtualGridItemData> {
        for uiItem in this.Children {
            if uiItem.Item.IsEquipped() {
                return uiItem;
            }
        }

        return null;
    }
}

public class VirtualGridDataView extends BackpackDataView {
    private let m_filter: Bool;
    private let m_refresh: Bool;
    private let m_reverse: Bool;
    private let m_searchQuery: String;

    public func SetSearchQuery(searchQuery: String) {
        this.m_searchQuery = StrLower(searchQuery);
    }

    public func ApplySortingAndFilters() {
        this.DisableSorting();
        this.m_filter = true;
        this.Filter();
        this.m_filter = false;
        this.Filter();
    }

    public func FilterItem(data: ref<IScriptable>) -> Bool {
        let uiItemData = data as VirtualGridItemData;
        let uiGroupData = data as VirtualGridGroupData;

        if this.m_filter {
            if !IsDefined(uiGroupData) {
                uiItemData.IsVisible = true;

                if Equals(this.m_itemFilterType, ItemFilterCategory.Clothes) {
                    if !uiItemData.Item.IsEquipped() {
                        uiItemData.IsVisible = false;
                    }
                }

                if NotEquals(this.m_searchQuery, "") {
                    let itemName = StrLower(uiItemData.Item.GetName());
                    if !StrContains(itemName, this.m_searchQuery) {
                        uiItemData.IsVisible = false;
                    }
                }
            }
        } else {
            if IsDefined(uiGroupData) {
                uiGroupData.IsVisible = false;

                for uiChildData in uiGroupData.Children {
                    if uiChildData.IsVisible {
                        uiGroupData.IsVisible = true;
                        break;
                    }
                }
            }
        }

        return uiItemData.IsVisible;
    }

    public func SortItem(left: ref<IScriptable>, right: ref<IScriptable>) -> Bool {
        let uiLeft = left as VirtualGridItemData;
        let uiRight = right as VirtualGridItemData;

        return this.m_reverse
            ? uiLeft.ItemIndex > uiRight.ItemIndex
            : uiLeft.ItemIndex < uiRight.ItemIndex;
    }
}
