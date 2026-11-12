module EquipmentEx

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

public class WardrobeCache extends ScriptableSystem {
    private let m_player: wref<GameObject>;
    private let m_inventoryHelper: wref<InventoryHelper>;
    private let m_outfitSystem: wref<OutfitSystem>;
    private let m_itemsManager: wref<UIInventoryItemsManager>;

    private let m_slots: array<ref<InventoryGridSlotData>>;
    private let m_items: array<InventoryItemData>;
    private let m_job: ref<WardrobeCacheBuildJob>;
    private let m_isBuilding: Bool;
    private let m_isReady: Bool;
    private let m_isStale: Bool;
    private let m_itemCount: Int32;
    private let m_builtSource: WardrobeItemSource;

    private func OnAttach() {
        this.m_isStale = true;
    }

    private func OnPlayerAttach(request: ref<PlayerAttachRequest>) {
        this.Initialize();
    }

    private func Initialize() -> Bool {
        let game = this.GetGameInstance();

        if !IsDefined(this.m_player) {
            this.m_player = GameInstance.GetPlayerSystem(game).GetLocalPlayerMainGameObject();
        }

        if !IsDefined(this.m_inventoryHelper) {
            this.m_inventoryHelper = InventoryHelper.GetInstance(game);
        }

        if !IsDefined(this.m_outfitSystem) {
            this.m_outfitSystem = OutfitSystem.GetInstance(game);
        }

        if !IsDefined(this.m_itemsManager) {
            this.m_itemsManager = UIInventoryScriptableSystem.GetInstance(game).GetInventoryItemsManager();
        }

        return IsDefined(this.m_player) && IsDefined(this.m_itemsManager);
    }

    public func Invalidate() {
        this.m_isStale = true;
        this.m_isReady = false;
    }

    public func IsReady() -> Bool {
        if this.m_isStale || !this.m_isReady {
            return false;
        }

        if NotEquals(this.GetCurrentSource(), this.m_builtSource) {
            this.m_isStale = true;
            return false;
        }

        return true;
    }

    private func GetCurrentSource() -> WardrobeItemSource {
        return ViewManager.GetInstance(this.GetGameInstance()).GetItemSource();
    }

    public func IsBuilding() -> Bool {
        return this.m_isBuilding;
    }

    public func GetItemCount() -> Int32 {
        return this.m_itemCount;
    }

    public func GetSlots() -> array<ref<InventoryGridSlotData>> {
        return this.m_slots;
    }

    public func StartBuild(opt excludes: array<ItemModParams>) {
        if !this.Initialize() {
            return;
        }

        this.m_isBuilding = true;
        this.m_isReady = false;
        this.m_isStale = false;
        this.m_itemCount = 0;

        ArrayClear(this.m_slots);
        ArrayClear(this.m_items);

        for slotID in this.m_outfitSystem.GetOutfitSlots() {
            let uiSlotData = new InventoryGridSlotData();
            uiSlotData.ItemData.SlotID = slotID;
            uiSlotData.ItemData.CategoryName = this.m_outfitSystem.GetSlotName(slotID);

            ArrayPush(this.m_slots, uiSlotData);
        }

        this.m_items = this.m_inventoryHelper.GetAvailableItems(excludes);
        this.m_items = this.MergeVisualGroups(this.m_items);

        this.m_builtSource = this.GetCurrentSource();

        let count = ArraySize(this.m_items);
        if count == 0 {
            this.m_isBuilding = false;
            this.m_isReady = true;
            this.m_job = null;
            return;
        }

        this.m_job = WardrobeCacheBuildJob.Create(this, this.m_player, this.m_itemsManager, this.m_outfitSystem, this.m_slots, this.m_items, count);

        let queue = JobQueue.Create();
        queue.DispatchJob(this.m_job, count);
    }

    protected func MergeVisualGroups(items: array<InventoryItemData>) -> array<InventoryItemData> {
        let merged: array<InventoryItemData>;
        let groups = new inkHashMap();

        for itemData in items {
            let record = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(itemData.ID));

            if IsDefined(record) {
                let entityName = record.EntityName();
                let appearanceName = record.AppearanceName();
                let isEquipped = this.m_outfitSystem.IsEquipped(itemData.ID);

                let slot = ItemVisualGroup.Find(groups, entityName, appearanceName);

                if IsDefined(slot) {
                    if isEquipped && !slot.hasEquipped {
                        slot.hasEquipped = true;
                        merged[slot.index] = itemData;
                    }
                } else {
                    let entry = new ItemVisualGroup();
                    entry.entityName = entityName;
                    entry.appearanceName = appearanceName;
                    entry.hasEquipped = isEquipped;
                    entry.index = ArraySize(merged);

                    ItemVisualGroup.Add(groups, entry);
                    ArrayPush(merged, itemData);
                }
            }
        }

        return merged;
    }

    public func FinishBuild(job: ref<WardrobeCacheBuildJob>) {
        if !IsDefined(job) || NotEquals(job, this.m_job) {
            return;
        }

        let results = job.GetResults();
        let items = job.GetItems();
        let count = ArraySize(results);
        let i = 0;

        while i < count {
            let entry = results[i];

            if IsDefined(entry) && IsDefined(entry.Parent) {
                if i < ArraySize(items) {
                    entry.IsEquipped = this.m_outfitSystem.IsEquipped(items[i].ID);
                }

                entry.Parent.AddItem(entry);
                this.m_itemCount += 1;
            }
            i += 1;
        }

        for slot in this.m_slots {
            slot.UpdateActiveItem();
        }

        this.m_job = null;
        this.m_isBuilding = false;
        this.m_isReady = true;
    }

    public func FindSlot(slotID: TweakDBID) -> ref<InventoryGridSlotData> {
        for slot in this.m_slots {
            if Equals(slot.ItemData.SlotID, slotID) {
                return slot;
            }
        }

        return null;
    }

    public static func GetInstance(game: GameInstance) -> ref<WardrobeCache> {
        return GameInstance.GetScriptableSystemsContainer(game).Get(n"EquipmentEx.WardrobeCache") as WardrobeCache;
    }
}

public class WardrobeCacheBuildJob {
    private let m_cache: wref<WardrobeCache>;
    private let m_player: wref<GameObject>;
    private let m_manager: wref<UIInventoryItemsManager>;
    private let m_outfitSystem: wref<OutfitSystem>;
    private let m_items: array<InventoryItemData>;
    private let m_slots: array<ref<InventoryGridSlotData>>;
    private let m_results: array<ref<InventoryGridItemData>>;

    public func Handle(start: Int32, end: Int32) {
        let i = start;
        let count = ArraySize(this.m_items);

        while i < end && i < count {
            this.m_results[i] = this.BuildEntry(this.m_items[i]);
            i += 1;
        }
    }

    private func BuildEntry(itemData: InventoryItemData) -> ref<InventoryGridItemData> {
        let record = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(itemData.ID));
        if !IsDefined(record) {
            return null;
        }

        let slotID = this.m_outfitSystem.GetItemSlot(itemData.ID);
        let slot = this.FindSlot(slotID);

        if !IsDefined(slot) {
            return null;
        }

        let entry = new InventoryGridItemData();
        entry.Item = UIInventoryItem.Make(this.m_player, slotID, itemData, this.m_manager);
        entry.Parent = slot;
        entry.SourceItemID = itemData.ID;
        entry.SortKey = NameToString(record.AppearanceName());

        return entry;
    }

    private func FindSlot(slotID: TweakDBID) -> ref<InventoryGridSlotData> {
        for slot in this.m_slots {
            if Equals(slot.ItemData.SlotID, slotID) {
                return slot;
            }
        }

        return null;
    }

    public func GetResults() -> array<ref<InventoryGridItemData>> {
        return this.m_results;
    }

    public func GetItems() -> array<InventoryItemData> {
        return this.m_items;
    }

    public func Finish() {
        if IsDefined(this.m_cache) {
            this.m_cache.FinishBuild(this);
        }
    }

    public static func Create(cache: ref<WardrobeCache>, player: wref<GameObject>, manager: wref<UIInventoryItemsManager>, outfitSystem: wref<OutfitSystem>, slots: array<ref<InventoryGridSlotData>>, items: array<InventoryItemData>, count: Int32) -> ref<WardrobeCacheBuildJob> {
        let job = new WardrobeCacheBuildJob();
        job.m_cache = cache;
        job.m_player = player;
        job.m_manager = manager;
        job.m_outfitSystem = outfitSystem;
        job.m_slots = slots;
        job.m_items = items;

        ArrayResize(job.m_results, count);

        return job;
    }
}
