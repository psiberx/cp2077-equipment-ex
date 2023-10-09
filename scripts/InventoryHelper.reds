module EquipmentEx

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
        }
    }

    public func GetStash() -> wref<Stash> {
        return this.m_stash;
    }

    public func GetStashItems(out items: array<InventoryItemData>) {
        let stashItems: array<wref<gameItemData>>;
        this.m_transactionSystem.GetItemList(this.m_stash, stashItems);

        for itemData in stashItems {
            if this.IsValidItem(itemData.GetID()) {
                ArrayPush(items, this.m_inventoryManager.GetCachedInventoryItemData(itemData));
            }
        }
    }

    public func GetPlayerItems(out items: array<InventoryItemData>, opt excludes: array<ItemModParams>) {
        for itemData in this.m_inventoryManager.GetPlayerInventoryData() {
            let itemID = itemData.ID;

            if this.IsValidItem(itemID) {
                let diff = 0;
                for exclude in excludes {
                    if Equals(exclude.itemID, itemID) {
                        diff += exclude.quantity;
                    }
                }

                if itemData.Quantity - diff > 0 {
                    ArrayPush(items, itemData);
                }
            }
        }
    }

    public func GetWardrobeItems(out items: array<InventoryItemData>) {
        let equipmentAreas = [
            gamedataEquipmentArea.Head,
            gamedataEquipmentArea.Face,
            gamedataEquipmentArea.InnerChest,
            gamedataEquipmentArea.OuterChest,
            gamedataEquipmentArea.Legs,
            gamedataEquipmentArea.Feet,
            gamedataEquipmentArea.Outfit
        ];

        for equipmentArea in equipmentAreas {
            for itemData in this.m_wardrobeSystem.GetFilteredInventoryItemsData(equipmentArea, this.m_inventoryManager) {
                if this.IsValidItem(itemData.ID) {
                    ArrayPush(items, itemData);
                }
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
        return GameInstance.GetScriptableSystemsContainer(game).Get(n"EquipmentEx.InventoryHelper") as InventoryHelper;
    }
}
