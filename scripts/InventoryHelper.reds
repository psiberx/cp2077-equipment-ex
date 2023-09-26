module EquipmentEx

public class InventoryHelper extends ScriptableSystem {
    private let m_player: wref<GameObject>;
    private let m_transactionSystem: wref<TransactionSystem>;
    private let m_wardrobeSystem: wref<WardrobeSystem>;
    private let m_stash: wref<Stash>;
    
    private func OnPlayerAttach(request: ref<PlayerAttachRequest>) {
        this.m_player = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerMainGameObject();
        this.m_transactionSystem = GameInstance.GetTransactionSystem(this.GetGameInstance());
        this.m_wardrobeSystem = GameInstance.GetWardrobeSystem(this.GetGameInstance());
    }

    private func IsItemValid(itemID: ItemID) -> Bool {
        let itemRecordId = ItemID.GetTDBID(itemID);
        let itemRecord = TweakDBInterface.GetClothingRecord(itemRecordId);

        return IsDefined(itemRecord);
    }

    private func IsItemValid(itemData: wref<gameItemData>) -> Bool {
        return this.IsItemValid(itemData.GetID()) && !InventoryDataManagerV2.IsItemBlacklisted(itemData);
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

    public func GetStashItems(out items: array<ref<gameItemData>>) {
        let stashItems: array<wref<gameItemData>>;
        this.m_transactionSystem.GetItemList(this.m_stash, stashItems);

        for itemData in stashItems {
            if this.IsItemValid(itemData) {
                ArrayPush(items, itemData);
            }
        }
    }

    public func GetPlayerItems(out items: array<ref<gameItemData>>, opt excludes: array<ItemModParams>) {
        let playerItems: array<wref<gameItemData>>;
        this.m_transactionSystem.GetItemList(this.m_player, playerItems);

        for itemData in playerItems {
            if this.IsItemValid(itemData) {
                let itemID = itemData.GetID();
                let diff = 0;

                for exclude in excludes {
                    if Equals(exclude.itemID, itemID) {
                        diff += exclude.quantity;
                    }
                }

                if diff == 0 {
                    ArrayPush(items, itemData);
                } else {
                    let quantity = this.m_transactionSystem.GetItemQuantity(this.m_player, itemID);
                    if quantity - diff > 0 {
                        ArrayPush(items, itemData);
                    }
                }
            }
        }
    }

    public func GetWardrobeItems(out items: array<ref<gameItemData>>) {
        for itemID in this.m_wardrobeSystem.GetStoredItemIDs() {
            if this.IsItemValid(itemID) {
                let itemData = this.m_transactionSystem.GetItemData(this.m_player, itemID);

                if IsDefined(itemData) {
                    ArrayPush(items, itemData);
                } else {
                    ArrayPush(items, Inventory.CreateItemData(new ItemModParams(itemID, 1, []), this.m_player));
                }
            }
        }
    }

    public func GetAvailableItems(opt excludes: array<ItemModParams>) -> array<ref<gameItemData>> {
        let items: array<ref<gameItemData>>;

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
