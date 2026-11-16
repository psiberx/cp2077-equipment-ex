module EquipmentEx

import Codeware.Localization.LocalizationSystem

public class ItemVisualGroup {
    public let entityName: CName;
    public let appearanceName: CName;
    public let hasEquipped: Bool;
    public let index: Int32;
    public let next: ref<ItemVisualGroup>;

    public static func Key(entityName: CName, appearanceName: CName) -> Uint64 {
        return NameToHash(entityName) ^ (NameToHash(appearanceName) * 31ul);
    }

    public static func Find(groups: ref<inkHashMap>, entityName: CName, appearanceName: CName) -> ref<ItemVisualGroup> {
        let head = groups.Get(ItemVisualGroup.Key(entityName, appearanceName)) as ItemVisualGroup;

        while IsDefined(head) {
            if Equals(head.entityName, entityName) && Equals(head.appearanceName, appearanceName) {
                return head;
            }

            head = head.next;
        }

        return null;
    }

    public static func Add(groups: ref<inkHashMap>, entry: ref<ItemVisualGroup>) {
        let key = ItemVisualGroup.Key(entry.entityName, entry.appearanceName);
        let head = groups.Get(key) as ItemVisualGroup;

        if !IsDefined(head) {
            groups.Insert(key, entry);
            return;
        }

        while IsDefined(head.next) {
            head = head.next;
        }

        head.next = entry;
    }
}

struct WardrobeInventoryItem {
    public let id: ItemID;
    public let data: wref<gameItemData>;
    public let quantity: Int32;
    public let quality: Float;
    public let tierPlus: Float;
    public let weight: Float;
    public let quest: Bool;
    public let iconic: Bool;
    public let fromStash: Bool;
}

struct WardrobeSortRow {
    public let id: ItemID;
    public let slot: TweakDBID;
    public let slotIndex: Int32;
    public let appearance: CName;
}

struct WardrobeWornItem {
    public let id: ItemID;
    public let slot: TweakDBID;
}

struct WardrobeCacheInput {
    public let source: WardrobeItemSource;
    public let stash: wref<Stash>;
    public let stored: array<ItemID>;
    public let inventory: array<WardrobeInventoryItem>;
    public let worn: array<WardrobeWornItem>;
    public let slots: array<TweakDBID>;
    public let language: CName;
    public let captured: Bool;
}

public class WardrobeCache extends ScriptableSystem {
    private let m_player: wref<GameObject>;
    private let m_inventoryHelper: wref<InventoryHelper>;
    private let m_outfitSystem: wref<OutfitSystem>;
    private let m_itemsManager: wref<UIInventoryItemsManager>;
    private let m_delaySystem: wref<DelaySystem>;
    private let m_owner: wref<WardrobeScreenController>;
    private let m_hasScreenOwner: Bool;

    private let m_slots: array<ref<InventoryGridSlotData>>;
    private let m_job: ref<WardrobeCacheBuildJob>;
    private let m_isReady: Bool;
    private let m_itemCount: Int32;
    private let m_input: WardrobeCacheInput;
    private let m_sortRows: array<WardrobeSortRow>;
    private let m_sortSlots: array<TweakDBID>;
    private let m_sortOrder: array<Int32>;

    private func OnPlayerAttach(request: ref<PlayerAttachRequest>) {
        this.Reset();
        this.Initialize();
    }

    private func OnRestored(saveVersion: Int32, gameVersion: Int32) {
        this.Reset();
    }

    private func OnDetach() {
        this.Reset();
        this.m_player = null;
        this.m_inventoryHelper = null;
        this.m_outfitSystem = null;
        this.m_itemsManager = null;
        this.m_delaySystem = null;
    }

    private func Initialize() -> Bool {
        let game = this.GetGameInstance();

        let player: wref<GameObject> = GameInstance.GetPlayerSystem(game).GetLocalPlayerMainGameObject();
        if NotEquals(player, this.m_player) {
            this.Invalidate();
            this.ClearSortOrder();
            this.m_player = player;
        }

        let inventoryHelper: wref<InventoryHelper> = InventoryHelper.GetInstance(game);
        let outfits: wref<OutfitSystem> = OutfitSystem.GetInstance(game);
        let inventory = UIInventoryScriptableSystem.GetInstance(game);
        let manager: wref<UIInventoryItemsManager> = IsDefined(inventory) ? inventory.GetInventoryItemsManager() : null;
        this.m_delaySystem = GameInstance.GetDelaySystem(game);
        if NotEquals(inventoryHelper, this.m_inventoryHelper) || NotEquals(outfits, this.m_outfitSystem)
            || NotEquals(manager, this.m_itemsManager) {
            this.Invalidate();
            this.ClearSortOrder();
        }

        this.m_inventoryHelper = inventoryHelper;
        this.m_outfitSystem = outfits;
        this.m_itemsManager = manager;

        return IsDefined(this.m_player) && IsDefined(this.m_itemsManager) && IsDefined(this.m_delaySystem)
            && IsDefined(this.m_inventoryHelper) && this.m_inventoryHelper.IsWardrobeInventoryReady(this.m_player)
            && IsDefined(this.m_outfitSystem) && IsDefined(this.m_outfitSystem.m_state);
    }

    public func Invalidate() {
        let empty: WardrobeCacheInput;
        this.m_input = empty;
        this.m_job = null;
        this.m_isReady = false;
        this.m_itemCount = 0;
        ArrayClear(this.m_slots);
    }

    private func ClearSortOrder() {
        ArrayClear(this.m_sortRows);
        ArrayClear(this.m_sortSlots);
        ArrayClear(this.m_sortOrder);
    }

    private func Reset() {
        this.Invalidate();
        this.ClearSortOrder();
        this.m_owner = null;
        this.m_hasScreenOwner = false;
    }

    public func IsForScreen(owner: wref<WardrobeScreenController>) -> Bool {
        return IsDefined(owner) && Equals(this.m_owner, owner);
    }

    public func InvalidateScreen(owner: wref<WardrobeScreenController>) {
        if this.IsForScreen(owner) { this.Invalidate(); }
    }

    public func CloseScreen(owner: wref<WardrobeScreenController>) {
        if this.IsForScreen(owner) {
            this.Invalidate();
            this.m_owner = null;
            this.m_hasScreenOwner = false;
        }
    }

    public func StashChanged() {
        if IsDefined(this.m_owner) && Equals(this.GetCurrentSource(), WardrobeItemSource.InventoryAndStash) {
            this.m_owner.InvalidateInventoryGrid();
        }
    }

    // The worn copy wins when multiple ItemIDs share an appearance.
    public func OutfitChanged() {
        if IsDefined(this.m_job) && !this.SameWorn(this.CaptureWornItems(), this.m_input.worn) {
            this.Invalidate();
        }
    }

    public func IsReady() -> Bool {
        return this.m_isReady && Equals(this.GetCurrentSource(), this.m_input.source);
    }

    private func GetCurrentSource() -> WardrobeItemSource {
        return ViewManager.GetInstance(this.GetGameInstance()).GetItemSource();
    }

    public static func SameExcludes(const left: script_ref<array<ItemModParams>>, const right: script_ref<array<ItemModParams>>) -> Bool {
        let count = ArraySize(Deref(left));
        if count != ArraySize(Deref(right)) { return false; }
        let index = 0;
        while index < count {
            if NotEquals(left[index].itemID, right[index].itemID) || left[index].quantity != right[index].quantity {
                return false;
            }
            index += 1;
        }
        return true;
    }

    private func SameWorn(const left: script_ref<array<WardrobeWornItem>>, const right: script_ref<array<WardrobeWornItem>>) -> Bool {
        let count = ArraySize(Deref(left));
        if count != ArraySize(Deref(right)) { return false; }
        let index = 0;
        while index < count {
            if NotEquals(left[index].id, right[index].id) || NotEquals(left[index].slot, right[index].slot) { return false; }
            index += 1;
        }
        return true;
    }

    private func SameSlots(const left: script_ref<array<TweakDBID>>, const right: script_ref<array<TweakDBID>>) -> Bool {
        let count = ArraySize(Deref(left));
        if count != ArraySize(Deref(right)) { return false; }
        let index = 0;
        while index < count {
            if NotEquals(left[index], right[index]) { return false; }
            index += 1;
        }
        return true;
    }

    private func CaptureWornItems() -> array<WardrobeWornItem> {
        let wornItems: array<WardrobeWornItem>;
        if IsDefined(this.m_outfitSystem) && this.m_outfitSystem.IsActive() {
            for part in this.m_outfitSystem.m_state.GetParts() {
                if IsDefined(part) {
                    let worn: WardrobeWornItem;
                    worn.id = part.GetItemID();
                    worn.slot = part.GetSlotID();
                    ArrayPush(wornItems, worn);
                }
            }
        }
        return wornItems;
    }

    private func CaptureInput() -> WardrobeCacheInput {
        let input: WardrobeCacheInput;
        input.source = this.GetCurrentSource();
        input.language = this.GetInterfaceLanguage();
        input.worn = this.CaptureWornItems();
        input.slots = this.m_outfitSystem.GetOutfitSlots();
        input.captured = this.m_inventoryHelper.CaptureWardrobeInventory(input);
        return input;
    }

    private func GetInterfaceLanguage() -> CName {
        let localization = LocalizationSystem.GetInstance(this.GetGameInstance());
        return IsDefined(localization) ? localization.GetInterfaceLanguage() : n"";
    }

    public func StartBuild(opt excludes: array<ItemModParams>) {
        this.RequestBuild(excludes);
    }

    public func RequestBuild(excludes: array<ItemModParams>, opt owner: wref<WardrobeScreenController>) {
        this.Invalidate();
        this.m_owner = owner;

        this.m_hasScreenOwner = IsDefined(owner);
        if !this.Initialize() { return; }

        let source = this.GetCurrentSource();
        let outfitSlots = this.m_outfitSystem.GetOutfitSlots();
        this.m_input.source = source;
        let slots: array<ref<InventoryGridSlotData>>;
        for slotID in outfitSlots {
            let uiSlotData = new InventoryGridSlotData();
            uiSlotData.ItemData.SlotID = slotID;
            uiSlotData.ItemData.CategoryName = this.m_outfitSystem.GetSlotName(slotID);

            ArrayPush(slots, uiSlotData);
        }

        this.m_inventoryHelper.RefreshWardrobeInventory();
        let items = this.MergeVisualGroups(this.m_inventoryHelper.GetAvailableItems(excludes));

        let count = ArraySize(items);
        if count == 0 {
            this.ClearSortOrder();
            this.m_slots = slots;
            this.m_isReady = true;
            return;
        }

        let job = WardrobeCacheBuildJob.Create(this, this.m_player, this.m_itemsManager, this.m_outfitSystem, slots, items, count);

        // Reuse indices into the fresh item list, independent of its UI data.
        if this.SameSlots(outfitSlots, this.m_sortSlots) && this.SameSortRows(job.m_sortRows, this.m_sortRows) {
            job.m_sortOrder = this.m_sortOrder;
        }

        // A small catalog completes before this callback returns.
        // Only work that can outlive the callback needs an inventory snapshot.
        if count <= 24 {
            this.m_input.slots = outfitSlots;
        } else {
            this.m_input = this.CaptureInput();
        }
        this.m_job = job;

        // A source with no readable transaction snapshot still uses the
        // fresh inventory data. Keep that build on the caller's thread.
        let queue: ref<JobQueue> = this.m_input.captured ? JobQueue.Create() : null;
        if !IsDefined(queue) || !queue.DispatchJob(job, count) {
            job.Handle(0, count);
            job.PrepareResults();
            this.PublishBuild(job);
        }
    }

    private func MatchesCurrentInput() -> Bool {
        return this.m_input.captured && Equals(this.GetCurrentSource(), this.m_input.source)
            && Equals(this.GetInterfaceLanguage(), this.m_input.language)
            && this.SameWorn(this.CaptureWornItems(), this.m_input.worn)
            && this.SameSlots(this.m_outfitSystem.GetOutfitSlots(), this.m_input.slots)
            && this.m_inventoryHelper.MatchesWardrobeInventory(this.m_input);
    }

    private static func GetSortRows(const items: script_ref<array<InventoryItemData>>, outfits: wref<OutfitSystem>, const slots: script_ref<array<ref<InventoryGridSlotData>>>) -> array<WardrobeSortRow> {
        let slotIndices = new inkIntHashMap();
        let index = 0;
        for slot in Deref(slots) {
            let key = TDBID.ToNumber(slot.ItemData.SlotID);
            if !slotIndices.KeyExist(key) { slotIndices.Insert(key, index); }
            index += 1;
        }
        let rows: array<WardrobeSortRow>;
        for item in Deref(items) {
            let row: WardrobeSortRow;
            row.id = item.ID;
            row.slot = outfits.GetItemSlot(row.id);
            let key = TDBID.ToNumber(row.slot);
            row.slotIndex = -1;
            let record = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(row.id));
            if IsDefined(record) && slotIndices.KeyExist(key) {
                let slotIndex = slotIndices.Get(key);
                if Equals(slots[slotIndex].ItemData.SlotID, row.slot) { row.slotIndex = slotIndex; }
                row.appearance = record.AppearanceName();
            }
            ArrayPush(rows, row);
        }
        return rows;
    }

    private func SameSortRows(const left: script_ref<array<WardrobeSortRow>>, const right: script_ref<array<WardrobeSortRow>>) -> Bool {
        let count = ArraySize(Deref(left));
        if count != ArraySize(Deref(right)) { return false; }
        let index = 0;
        while index < count {
            let a = left[index];
            let b = right[index];
            if NotEquals(a.id, b.id) || NotEquals(a.slot, b.slot) || a.slotIndex != b.slotIndex
                || NotEquals(a.appearance, b.appearance) { return false; }
            index += 1;
        }
        return true;
    }

    protected func MergeVisualGroups(items: array<InventoryItemData>) -> array<InventoryItemData> {
        let merged: array<InventoryItemData>;
        let groups = new inkHashMap();

        for itemData in items {
            let record = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(itemData.ID));

            if IsDefined(record) {
                let entityName = record.EntityName();
                let appearanceName = record.AppearanceName();

                let slot = ItemVisualGroup.Find(groups, entityName, appearanceName);

                if IsDefined(slot) {
                    if !slot.hasEquipped && this.m_outfitSystem.IsEquipped(itemData.ID) {
                        slot.hasEquipped = true;
                        if !this.m_outfitSystem.IsEquipped(merged[slot.index].ID) {
                            merged[slot.index] = itemData;
                        }
                    }
                } else {
                    let entry = new ItemVisualGroup();
                    entry.entityName = entityName;
                    entry.appearanceName = appearanceName;
                    entry.index = ArraySize(merged);

                    ItemVisualGroup.Add(groups, entry);
                    ArrayPush(merged, itemData);
                }
            }
        }

        return merged;
    }

    public func FinishBuild(job: ref<WardrobeCacheBuildJob>) {
        if !IsDefined(job) || NotEquals(job, this.m_job) { return; }
        if (this.m_hasScreenOwner && !IsDefined(this.m_owner)) || !this.Initialize()
            || NotEquals(job, this.m_job) || !this.MatchesCurrentInput() {
            this.Invalidate();
            return;
        }

        this.PublishBuild(job);
        if IsDefined(this.m_owner) { this.m_owner.AcceptInventoryGrid(this, true); }
    }

    private func PublishBuild(job: ref<WardrobeCacheBuildJob>) {
        this.m_slots = job.m_slots;
        for slot in this.m_slots {
            slot.UpdateEquippedItems(this.m_outfitSystem);
        }
        this.m_sortRows = job.m_sortRows;
        this.m_sortSlots = this.m_input.slots;

        this.m_sortOrder = job.m_sortOrder;
        let source = this.m_input.source;
        let empty: WardrobeCacheInput;
        this.m_input = empty;
        this.m_input.source = source;
        this.m_itemCount = job.GetItemCount();

        this.m_job = null;
        this.m_isReady = true;
    }

    public func IsBuilding() -> Bool {
        return IsDefined(this.m_job);
    }

    public func GetSlots() -> array<ref<InventoryGridSlotData>> {
        return this.m_slots;
    }

    public func FindSlot(slotID: TweakDBID) -> ref<InventoryGridSlotData> {
        for slot in this.m_slots {
            if Equals(slot.ItemData.SlotID, slotID) {
                return slot;
            }
        }

        return null;
    }

    public func GetItemCount() -> Int32 {
        return this.m_itemCount;
    }

    public static func GetInstance(game: GameInstance) -> ref<WardrobeCache> {
        return GameInstance.GetScriptableSystemsContainer(game).Get(NameOf<WardrobeCache>()) as WardrobeCache;
    }
}

public class WardrobeCacheBuildJob {
    private let m_cache: wref<WardrobeCache>;
    private let m_delaySystem: wref<DelaySystem>;
    private let m_player: wref<GameObject>;
    private let m_manager: wref<UIInventoryItemsManager>;
    private let m_items: array<InventoryItemData>;
    private let m_slots: array<ref<InventoryGridSlotData>>;
    private let m_results: array<ref<InventoryGridItemData>>;
    private let m_sortRows: array<WardrobeSortRow>;
    private let m_sortOrder: array<Int32>;
    private let m_itemCount: Int32;

    public func Handle(start: Int32, end: Int32) {
        let i = start;
        let count = ArraySize(this.m_items);

        while i < end && i < count {
            let entry = this.BuildEntry(this.m_items[i], this.m_sortRows[i]);
            if IsDefined(entry) { entry.BuildIndex = i; }
            this.m_results[i] = entry;
            i += 1;
        }
    }

    private func BuildEntry(itemData: InventoryItemData, row: WardrobeSortRow) -> ref<InventoryGridItemData> {
        if row.slotIndex < 0 || !IsDefined(TweakDBInterface.GetItemRecord(ItemID.GetTDBID(itemData.ID))) {
            return null;
        }

        let slot = this.m_slots[row.slotIndex];

        if !IsDefined(slot) {
            return null;
        }

        let entry = new InventoryGridItemData();
        entry.Item = UIInventoryItem.Make(this.m_player, row.slot, itemData, this.m_manager);
        entry.Parent = slot;
        entry.SourceItemID = itemData.ID;
        entry.SortKey = NameToString(row.appearance);

        return entry;
    }

    public func GetResults() -> array<ref<InventoryGridItemData>> {
        return this.m_results;
    }

    public func GetItems() -> array<InventoryItemData> {
        return this.m_items;
    }

    public func PrepareResults() {
        // These slots belong to this job until the cache accepts its results.
        if ArraySize(this.m_sortOrder) > 0 {
            for index in this.m_sortOrder { this.AppendResult(this.m_results[index]); }
            return;
        }
        for entry in this.m_results {
            this.AppendResult(entry);
        }
        for slot in this.m_slots {
            slot.SortItems();
            for entry in slot.Children { ArrayPush(this.m_sortOrder, entry.BuildIndex); }
        }
    }

    private func AppendResult(entry: ref<InventoryGridItemData>) {
        if IsDefined(entry) && IsDefined(entry.Parent) {
            ArrayPush(entry.Parent.Children, entry);
            this.m_itemCount += 1;
        }
    }

    public func GetItemCount() -> Int32 {
        return this.m_itemCount;
    }

    public func Finish() {
        // Keep sorting on Codeware's worker. Adopt completed results through
        // the delayed callback path that the wardrobe uses to read the cache.
        if IsDefined(this.m_cache) && IsDefined(this.m_delaySystem) {
            this.PrepareResults();
            this.m_delaySystem.DelayCallbackNextFrame(WardrobeCacheFinishedCallback.Create(this.m_cache, this));
        }
    }

    public static func Create(cache: ref<WardrobeCache>, player: wref<GameObject>, manager: wref<UIInventoryItemsManager>, outfitSystem: wref<OutfitSystem>, slots: array<ref<InventoryGridSlotData>>, items: array<InventoryItemData>, count: Int32) -> ref<WardrobeCacheBuildJob> {
        let job = new WardrobeCacheBuildJob();
        job.m_cache = cache;
        job.m_delaySystem = cache.m_delaySystem;
        job.m_player = player;
        job.m_manager = manager;
        job.m_slots = slots;
        job.m_items = items;
        job.m_sortRows = WardrobeCache.GetSortRows(items, outfitSystem, slots);

        ArrayResize(job.m_results, count);

        return job;
    }
}

class WardrobeCacheFinishedCallback extends DelayCallback {
    private let m_cache: wref<WardrobeCache>;
    private let m_job: wref<WardrobeCacheBuildJob>;

    public func Call() {
        if IsDefined(this.m_cache) && IsDefined(this.m_job) { this.m_cache.FinishBuild(this.m_job); }
    }

    public static func Create(cache: wref<WardrobeCache>, job: wref<WardrobeCacheBuildJob>) -> ref<WardrobeCacheFinishedCallback> {
        let self = new WardrobeCacheFinishedCallback();
        self.m_cache = cache;
        self.m_job = job;
        return self;
    }
}
