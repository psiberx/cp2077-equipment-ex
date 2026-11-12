module EquipmentEx

class InventoryGridItemData extends VendorUIInventoryItemData {
    public let Parent: wref<InventoryGridSlotData>;
    public let SourceItemID: ItemID;
    public let SearchName: String;
    public let SortKey: String;
    public let IsEquipped: Bool;
    public let IsVisible: Bool;
}

class InventoryGridSlotData extends VendorUIInventoryItemData {
    public let Children: array<ref<InventoryGridItemData>>;
    public let ActiveItem: wref<InventoryGridItemData>;
    public let TotalItems: Int32;
    public let VisibleItems: Int32;
    public let IsCollapsed: Bool;

    protected func GetActiveItem() -> wref<InventoryGridItemData> {
        return this.ActiveItem;
    }

    public func UpdateActiveItem() {
        this.ActiveItem = null;

        for uiItem in this.Children {
            if uiItem.IsEquipped {
                this.ActiveItem = uiItem;
                return;
            }
        }
    }

    public func AddItem(entry: ref<InventoryGridItemData>) {
        let index = 0;

        while index < ArraySize(this.Children) && StrCmp(entry.SortKey, this.Children[index].SortKey) > 0 {
            index += 1;
        }

        ArrayInsert(this.Children, index, entry);

        if entry.IsEquipped {
            this.ItemData.ID = entry.Item.GetID();
            this.ItemData.Name = entry.Item.GetName();
            this.ItemData.IsEquipped = true;
        }
    }
}

class InventoryGridDataView extends BackpackDataView {
    private let m_filter: Bool;
    private let m_searchQuery: String;
    private let m_viewManager: wref<ViewManager>;
    private let m_slots: array<ref<InventoryGridSlotData>>;
    private let m_items: array<ref<InventoryGridItemData>>;

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
        this.m_searchQuery = UTF8StrLower(searchQuery);
    }

    public func GetSearchQuery() -> String {
        return this.m_searchQuery;
    }

    public func SetSlots(slots: array<ref<InventoryGridSlotData>>) {
        this.m_slots = slots;
        ArrayClear(this.m_items);

        for uiSlot in this.m_slots {
            for uiItem in uiSlot.Children {
                ArrayPush(this.m_items, uiItem);
            }
        }
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
                uiItem.IsVisible = this.IsItemVisible(uiItem);
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

    public func RefreshVisibility() {
        let filterClothes = Equals(this.m_itemFilterType, ItemFilterCategory.Clothes);
        let hasQuery = NotEquals(this.m_searchQuery, "");

        for uiSlot in this.m_slots {
            uiSlot.IsCollapsed = this.m_viewManager.IsCollapsed(uiSlot.ItemData.SlotID);
            uiSlot.TotalItems = ArraySize(uiSlot.Children);
            uiSlot.VisibleItems = 0;

            for uiItem in uiSlot.Children {
                uiItem.IsVisible = !filterClothes || uiItem.IsEquipped;
                if uiItem.IsVisible && hasQuery {
                    uiItem.IsVisible = StrContains(this.GetSearchName(uiItem), this.m_searchQuery);
                }

                if uiItem.IsVisible {
                    uiSlot.VisibleItems += 1;
                }
            }
        }
    }

    public func RefreshItem(uiItem: ref<InventoryGridItemData>) {
        if !IsDefined(uiItem) {
            return;
        }

        let uiSlot = uiItem.Parent;
        if !IsDefined(uiSlot) {
            return;
        }

        let wasVisible = uiItem.IsVisible;
        uiItem.IsVisible = this.IsItemVisible(uiItem);

        if NotEquals(wasVisible, uiItem.IsVisible) {
            uiSlot.VisibleItems += uiItem.IsVisible ? 1 : -1;
        }
    }

    private func IsItemVisible(uiItem: ref<InventoryGridItemData>) -> Bool {
        if Equals(this.m_itemFilterType, ItemFilterCategory.Clothes) && !uiItem.IsEquipped {
            return false;
        }

        if NotEquals(this.m_searchQuery, "") && !StrContains(this.GetSearchName(uiItem), this.m_searchQuery) {
            return false;
        }

        return true;
    }

    private func GetSearchName(uiItem: ref<InventoryGridItemData>) -> String {
        if Equals(uiItem.SearchName, "") {
            uiItem.SearchName = UTF8StrLower(GetLocalizedText(uiItem.Item.m_data.Name));
        }

        return uiItem.SearchName;
    }
}

class InventoryGridTemplateClassifier extends inkVirtualItemTemplateClassifier {
    public func ClassifyItem(data: Variant) -> Uint32 {
        return IsDefined(FromVariant<ref<IScriptable>>(data) as InventoryGridSlotData) ? 1u : 0u;
    }
}
