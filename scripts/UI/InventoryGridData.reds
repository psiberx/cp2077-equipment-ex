module EquipmentEx

class InventoryGridItemData extends VendorUIInventoryItemData {
    public let SlotIndex: Int32;
    public let ItemIndex: Int32;
    public let IsVisible: Bool;
}

class InventoryGridSlotData extends InventoryGridItemData {
    public let SlotID: TweakDBID;
    public let SlotName: String;
    public let Children: array<wref<InventoryGridItemData>>;

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
        let uiSlot = data as InventoryGridSlotData;

        if this.m_filter {
            if !IsDefined(uiSlot) {
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
        } else {
            if IsDefined(uiSlot) {
                uiSlot.IsVisible = false;

                for uiChildData in uiSlot.Children {
                    if uiChildData.IsVisible {
                        uiSlot.IsVisible = true;
                        break;
                    }
                }
            }
        }

        return uiItem.IsVisible;
    }

    public func SortItem(left: ref<IScriptable>, right: ref<IScriptable>) -> Bool {
        let uiItemLeft = left as InventoryGridItemData;
        let uiItemRight = right as InventoryGridItemData;

        return this.m_reverse
            ? uiItemLeft.ItemIndex > uiItemRight.ItemIndex
            : uiItemLeft.ItemIndex < uiItemRight.ItemIndex;
    }
}

class InventoryGridTemplateClassifier extends inkVirtualItemTemplateClassifier {
    public func ClassifyItem(data: Variant) -> Uint32 {
        return IsDefined(FromVariant<ref<IScriptable>>(data) as InventoryGridSlotData) ? 1u : 0u;
    }
}
