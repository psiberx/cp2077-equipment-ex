module EquipmentEx

class ItemRecordCacheEntry {
    public let iconName: String;
}

@addField(UIInventoryItemsManager)
private let m_itemRecordCache: ref<inkHashMap>;

@addField(UIInventoryItemsManager)
private let m_itemRecordLock: RWLock;

@addField(UIInventoryItemsManager)
private let m_outfitSystem: wref<OutfitSystem>;

@wrapMethod(UIInventoryItemsManager)
public final static func Make(player: wref<PlayerPuppet>, transactionSystem: ref<TransactionSystem>, uiScriptableSystem: wref<UIScriptableSystem>) -> ref<UIInventoryItemsManager> {
    let instance = wrappedMethod(player, transactionSystem, uiScriptableSystem);
    instance.m_outfitSystem = OutfitSystem.GetInstance(player.GetGame());
    instance.m_itemRecordCache = new inkHashMap();

    return instance;
}

@addMethod(UIInventoryItemsManager)
public final func IsItemEquippedInSlot(itemID: ItemID, slotID: TweakDBID) -> Bool {
    return this.m_outfitSystem.IsActive() ? this.m_outfitSystem.IsEquipped(itemID) : this.IsItemEquipped(itemID);
}

@wrapMethod(UIInventoryItemsManager)
public final func IsItemTransmog(itemID: ItemID) -> Bool {
    return this.m_outfitSystem.IsActive() && this.m_outfitSystem.IsEquipped(itemID);
}

@wrapMethod(UIInventoryItemsManager)
public final static func ResolveItemIconName(itemTweakID: TweakDBID, itemRecord: wref<Item_Record>, manager: wref<UIInventoryItemsManager>) -> String {
	if !IsDefined(manager) {
		return wrappedMethod(itemTweakID, itemRecord, manager);
	}

	let key = TDBID.ToNumber(itemTweakID);

	RWLock.AcquireShared(manager.m_itemRecordLock);
    let cached = manager.m_itemRecordCache.Get(key) as ItemRecordCacheEntry;
    RWLock.ReleaseShared(manager.m_itemRecordLock);

    if IsDefined(cached) {
        return cached.iconName;
    }

    let entry = new ItemRecordCacheEntry();
    entry.iconName = wrappedMethod(itemTweakID, itemRecord, manager);

	RWLock.Acquire(manager.m_itemRecordLock);
    manager.m_itemRecordCache.Insert(key, entry);
    RWLock.Release(manager.m_itemRecordLock);

    return entry.iconName;
}
