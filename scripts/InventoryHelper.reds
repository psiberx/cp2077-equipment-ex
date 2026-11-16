module EquipmentEx

class ItemQuantityEntry {
    public let id: ItemID;
    public let quantity: Int32;
    public let next: ref<ItemQuantityEntry>;
}

class ItemQuantities {
    private let m_entries: ref<inkHashMap>;

    public static func Create() -> ref<ItemQuantities> {
        let quantities = new ItemQuantities();
        quantities.m_entries = new inkHashMap();
        return quantities;
    }

    private func Find(itemID: ItemID, key: Uint64) -> ref<ItemQuantityEntry> {
        let entry = this.m_entries.Get(key) as ItemQuantityEntry;
        while IsDefined(entry) {
            if Equals(entry.id, itemID) { return entry; }
            entry = entry.next;
        }
        return null;
    }

    public func Add(itemID: ItemID, quantity: Int32) {
        let key = ItemID.GetCombinedHash(itemID);
        let entry = this.Find(itemID, key);
        if IsDefined(entry) {
            entry.quantity += quantity;
            return;
        }
        entry = new ItemQuantityEntry();
        entry.id = itemID;
        entry.quantity = quantity;
        let head = this.m_entries.Get(key) as ItemQuantityEntry;
        if IsDefined(head) {
            entry.next = head.next;
            head.next = entry;
        } else {
            this.m_entries.Insert(key, entry);
        }
    }

    public func Get(itemID: ItemID) -> Int32 {
        let entry = this.Find(itemID, ItemID.GetCombinedHash(itemID));
        return IsDefined(entry) ? entry.quantity : 0;
    }
}

public class InventoryHelper extends ScriptableSystem {
    private let m_player: wref<GameObject>;
    private let m_transactionSystem: wref<TransactionSystem>;
    private let m_wardrobeSystem: wref<WardrobeSystem>;
    private let m_inventoryManager: wref<InventoryDataManagerV2>;
    private let m_stash: wref<Stash>;

    private func OnPlayerAttach(request: ref<PlayerAttachRequest>) {
        this.m_player = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerMainGameObject();
        this.m_transactionSystem = GameInstance.GetTransactionSystem(this.GetGameInstance());
        this.m_wardrobeSystem = GameInstance.GetWardrobeSystem(this.GetGameInstance());
        this.m_inventoryManager = EquipmentSystem.GetData(this.m_player).GetInventoryManager();
    }

    private func IsValidItem(itemID: ItemID) -> Bool {
        let itemRecordId = ItemID.GetTDBID(itemID);
        let itemRecord = TweakDBInterface.GetClothingRecord(itemRecordId);

        return IsDefined(itemRecord);
    }

    public func GetStash() -> wref<Stash> {
        return this.m_stash;
    }

    public func AddStash(stash: ref<Stash>) {
        if !IsDefined(this.m_stash) {
            this.m_stash = stash;
            let cache = WardrobeCache.GetInstance(this.GetGameInstance());
            if IsDefined(cache) { cache.StashChanged(); }
        }
    }

    public func GetStashItems(out items: array<InventoryItemData>) {
        if !IsDefined(this.m_stash) { return; }
        let stashItems: array<wref<gameItemData>>;
        this.m_transactionSystem.GetItemList(this.m_stash, stashItems);

        for itemData in stashItems {
            if this.IsValidItem(itemData.GetID()) {
                ArrayPush(items, this.m_inventoryManager.GetCachedInventoryItemData(itemData));
            }
        }
    }

    public func GetPlayerItems(out items: array<InventoryItemData>, opt excludes: array<ItemModParams>) {
        let pending: ref<ItemQuantities>;
        let excludeCount = ArraySize(excludes);
        if excludeCount > 1 {
            pending = ItemQuantities.Create();
            for exclude in excludes {
                pending.Add(exclude.itemID, exclude.quantity);
            }
        }
        for itemData in this.m_inventoryManager.GetPlayerInventoryData() {
            let itemID = itemData.ID;

            if this.IsValidItem(itemID) {
                let diff = 0;
                if IsDefined(pending) {
                    diff = pending.Get(itemID);
                } else {
                    if excludeCount == 1 && Equals(excludes[0].itemID, itemID) { diff = excludes[0].quantity; }
                }

                if itemData.Quantity - diff > 0 {
                    ArrayPush(items, itemData);
                }
            }
        }
    }

    public func GetWardrobeItems(out items: array<InventoryItemData>) {
        for itemID in this.m_wardrobeSystem.GetStoredItemIDs() {
            if this.IsValidItem(itemID) {
                ArrayPush(items, this.m_inventoryManager.GetInventoryItemDataFromItemID(itemID));
            }
        }
    }

    public func GetAvailableItems(opt excludes: array<ItemModParams>) -> array<InventoryItemData> {
        let items: array<InventoryItemData>;

        switch ViewManager.GetInstance(this.GetGameInstance()).GetItemSource() {
            case WardrobeItemSource.InventoryOnly:
                this.GetPlayerItems(items, excludes);
                break;
            case WardrobeItemSource.InventoryAndStash:
                this.GetPlayerItems(items, excludes);
                this.GetStashItems(items);
                break;
            case WardrobeItemSource.WardrobeStore:
                this.GetWardrobeItems(items);
                break;
        }

        return items;
    }

    public func IsWardrobeInventoryReady(player: wref<GameObject>) -> Bool {
        return Equals(this.m_player, player) && IsDefined(this.m_inventoryManager)
            && IsDefined(this.m_transactionSystem) && IsDefined(this.m_wardrobeSystem);
    }

    public func RefreshWardrobeInventory() {
        this.m_inventoryManager.MarkToRebuild();
    }

    // Detect inventory mutations while the worker is running. The sorting cache
    // has a separate key derived directly from the items sent to the worker.
    public func CaptureWardrobeInventory(out input: WardrobeCacheInput) -> Bool {
        if Equals(input.source, WardrobeItemSource.WardrobeStore) {
            input.stored = this.m_wardrobeSystem.GetStoredItemIDs();
        }
        if !this.AppendWardrobeInventory(this.m_player, input.inventory) { return false; }
        if Equals(input.source, WardrobeItemSource.InventoryAndStash) {
            input.stash = this.m_stash;
            if IsDefined(input.stash) && !this.AppendWardrobeInventory(input.stash, input.inventory, true) { return false; }
        }
        return true;
    }

    private func AppendWardrobeInventory(owner: ref<GameObject>, out stamp: array<WardrobeInventoryItem>, opt fromStash: Bool) -> Bool {
        let items: array<wref<gameItemData>>;
        if !this.m_transactionSystem.GetItemList(owner, items) { return false; }
        for data in items {
            if IsDefined(data) {
                let id = data.GetID();
                if this.IsValidItem(id) {
                    let item: WardrobeInventoryItem;
                    item.id = id;
                    item.data = data;
                    item.quantity = data.GetQuantity();
                    item.quality = data.GetStatValueByType(gamedataStatType.Quality);
                    item.tierPlus = data.GetStatValueByType(gamedataStatType.IsItemPlus);
                    item.weight = data.GetStatValueByType(gamedataStatType.Weight);
                    item.quest = data.HasTag(n"Quest") || data.HasTag(n"UnequipBlocked");
                    item.iconic = RPGManager.IsItemIconic(data);
                    item.fromStash = fromStash;
                    ArrayPush(stamp, item);
                }
            }
        }
        return true;
    }

    public func MatchesWardrobeInventory(const input: script_ref<WardrobeCacheInput>) -> Bool {
        if Equals(input.source, WardrobeItemSource.WardrobeStore)
            && !this.SameStoredItems(this.m_wardrobeSystem.GetStoredItemIDs(), input.stored) {
            return false;
        }
        let includeStash = Equals(input.source, WardrobeItemSource.InventoryAndStash);
        if includeStash && NotEquals(input.stash, this.m_stash) { return false; }
        let matched = this.MatchWardrobeInventory(this.m_player, input.inventory, 0);
        if matched < 0 { return false; }
        if includeStash && IsDefined(this.m_stash) {
            matched = this.MatchWardrobeInventory(this.m_stash, input.inventory, matched, true);
        }
        return matched == ArraySize(input.inventory);
    }

    // Read the same ordered fields as capture and stop on the first change.
    private func MatchWardrobeInventory(owner: ref<GameObject>, const stamp: script_ref<array<WardrobeInventoryItem>>, index: Int32, opt fromStash: Bool) -> Int32 {
        let items: array<wref<gameItemData>>;
        if !this.m_transactionSystem.GetItemList(owner, items) { return -1; }
        let count = ArraySize(Deref(stamp));
        for data in items {
            if IsDefined(data) {
                let id = data.GetID();
                if this.IsValidItem(id) {
                    if index >= count || !this.MatchesWardrobeItem(data, id, fromStash, stamp[index]) { return -1; }
                    index += 1;
                }
            }
        }
        return index;
    }

    private func MatchesWardrobeItem(data: wref<gameItemData>, id: ItemID, fromStash: Bool, const expected: script_ref<WardrobeInventoryItem>) -> Bool {
        return Equals(id, expected.id) && Equals(data, expected.data) && Equals(fromStash, expected.fromStash)
            && data.GetQuantity() == expected.quantity
            && data.GetStatValueByType(gamedataStatType.Quality) == expected.quality
            && data.GetStatValueByType(gamedataStatType.IsItemPlus) == expected.tierPlus
            && data.GetStatValueByType(gamedataStatType.Weight) == expected.weight
            && Equals(data.HasTag(n"Quest") || data.HasTag(n"UnequipBlocked"), expected.quest)
            && Equals(RPGManager.IsItemIconic(data), expected.iconic);
    }

    private func SameStoredItems(const left: script_ref<array<ItemID>>, const right: script_ref<array<ItemID>>) -> Bool {
        let count = ArraySize(Deref(left));
        if count != ArraySize(Deref(right)) { return false; }
        let index = 0;
        while index < count {
            if NotEquals(left[index], right[index]) { return false; }
            index += 1;
        }
        return true;
    }

    public func DiscardItem(itemID: ItemID) {
        switch ViewManager.GetInstance(this.GetGameInstance()).GetItemSource() {
            case WardrobeItemSource.InventoryOnly:
                this.m_transactionSystem.RemoveItem(this.m_player, itemID, 1);
                break;
            case WardrobeItemSource.InventoryAndStash:
                this.m_transactionSystem.RemoveItem(this.m_player, itemID, 1);
                this.m_transactionSystem.RemoveItem(this.m_stash, itemID, 1);
                break;
            case WardrobeItemSource.WardrobeStore:
                this.m_wardrobeSystem.ForgetItemID(itemID);
                break;
        }
    }

    public static func GetInstance(game: GameInstance) -> ref<InventoryHelper> {
        return GameInstance.GetScriptableSystemsContainer(game).Get(NameOf<InventoryHelper>()) as InventoryHelper;
    }
}
