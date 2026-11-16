module EquipmentEx

class InventoryGridItemData extends VendorUIInventoryItemData {
    public let Parent: wref<InventoryGridSlotData>;
    public let SourceItemID: ItemID;
    public let SearchName: String;
    public let SortKey: String;
    public let IsEquipped: Bool;
    public let IsVisible: Bool;
    public let BuildIndex: Int32;
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

    public func UpdateEquippedItems(outfits: ref<OutfitSystem>) {
        let latest: ref<InventoryGridItemData>;
        this.ActiveItem = null;
        for item in this.Children {
            item.IsEquipped = outfits.IsEquipped(item.SourceItemID);
            if item.IsEquipped {
                if !IsDefined(this.ActiveItem) { this.ActiveItem = item; }
                if !IsDefined(latest) || latest.BuildIndex < item.BuildIndex { latest = item; }
            }
        }
        this.ItemData.IsEquipped = false;
        this.ItemData.ID = ItemID.None();
        this.ItemData.Name = "";
        if IsDefined(latest) { this.SetEquippedItemData(latest); }
    }

    public func AddItem(entry: ref<InventoryGridItemData>) {
        let index = 0;

        while index < ArraySize(this.Children) && StrCmp(entry.SortKey, this.Children[index].SortKey) > 0 {
            index += 1;
        }

        ArrayInsert(this.Children, index, entry);
        this.SetEquippedItemData(entry);
    }

    private func SetEquippedItemData(entry: ref<InventoryGridItemData>) {

        if entry.IsEquipped {
            this.ItemData.ID = entry.Item.GetID();
            this.ItemData.Name = entry.Item.GetName();
            this.ItemData.IsEquipped = true;
        }
    }

    // Both sort paths keep newer equal-key entries first, as AddItem does.
    public func SortItems() {
        let count = ArraySize(this.Children);
        if count < 2 { return; }
        if count <= 24 {
            this.SortSmallSlot();
            return;
        }

        // Reverse first so the stable merge preserves the required tie order.
        let source: array<ref<InventoryGridItemData>>;
        let scratch: array<ref<InventoryGridItemData>>;
        ArrayResize(scratch, count);
        ArrayResize(source, count);
        let index = 0;
        while index < count {
            source[index] = this.Children[count - index - 1];
            index += 1;
        }

        let width = 1;
        while width < count {
            this.MergeItemRuns(source, scratch, width, count);
            width *= 2;
            if width < count {
                this.MergeItemRuns(scratch, source, width, count);
                width *= 2;
            } else {
                this.Children = scratch;
                return;
            }
        }
        this.Children = source;
    }

    private func SortSmallSlot() {
        let sorted: array<ref<InventoryGridItemData>>;
        for entry in this.Children {
            let left = 0;
            let right = ArraySize(sorted);
            while left < right {
                let middle = left + (right - left) / 2;
                if StrCmp(sorted[middle].SortKey, entry.SortKey) < 0 {
                    left = middle + 1;
                } else {
                    right = middle;
                }
            }
            ArrayInsert(sorted, left, entry);
        }
        this.Children = sorted;
    }

    private func MergeItemRuns(const source: script_ref<array<ref<InventoryGridItemData>>>, scratch: script_ref<array<ref<InventoryGridItemData>>>, width: Int32, count: Int32) {
        let index = 0;
        while index < count {
            let left = index;
            let middle = Min(index + width, count);
            let right = middle;
            let end = Min(middle + width, count);
            while index < end {
                if left < middle && (right >= end || StrCmp(source[left].SortKey, source[right].SortKey) <= 0) {
                    scratch[index] = source[left];
                    left += 1;
                } else {
                    scratch[index] = source[right];
                    right += 1;
                }
                index += 1;
            }
        }
    }
}

class InventoryGridDataView extends BackpackDataView {
    private let m_filter: Bool;
    private let m_visibilityPrepared: Bool;
    private let m_searchQuery: String;
    private let m_viewManager: wref<ViewManager>;
    private let m_slots: array<ref<InventoryGridSlotData>>;

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
    }

    public func UpdateView() {
        this.DisableSorting();
        this.m_filter = true;
        this.Filter();
        this.m_filter = false;
        this.Filter();
    }

    public func UpdateFullGrid() {
        // The full grid has all slot headers. External data sources still use UpdateView.
        this.RefreshVisibility();
        this.DisableSorting();
        this.m_visibilityPrepared = true;
        this.Filter();
        this.m_visibilityPrepared = false;
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
                if !this.m_visibilityPrepared {
                    uiSlot.TotalItems = ArraySize(uiSlot.Children);
                    uiSlot.VisibleItems = 0;

                    for uiChildData in uiSlot.Children {
                        if uiChildData.IsVisible {
                            uiSlot.VisibleItems += 1;
                        }
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
