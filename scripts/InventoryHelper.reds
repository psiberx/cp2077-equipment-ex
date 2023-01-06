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
            if !InventoryDataManagerV2.IsItemBlacklisted(itemData) {
                ArrayPush(items, itemData);
            }
        }
    }

    public func GetPlayerItems(out items: array<ref<gameItemData>>, opt excludes: array<ItemModParams>) {
        let playerItems: array<wref<gameItemData>>;
        this.m_transactionSystem.GetItemList(this.m_player, playerItems);

        for itemData in playerItems {
            if !InventoryDataManagerV2.IsItemBlacklisted(itemData) {
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
            let itemData = this.m_transactionSystem.GetItemData(this.m_player, itemID);

            if IsDefined(itemData) {
                ArrayPush(items, itemData);
            } else {
                ArrayPush(items, Inventory.CreateItemData(new ItemModParams(itemID, 1), this.m_player));
            }
        }
    }

    public func GetAvailableItems(opt excludes: array<ItemModParams>) -> array<ref<gameItemData>> {
        let items: array<ref<gameItemData>>;
        let settings = new Settings();

        if Equals(settings.wardrobeItemSource, WardrobeItemSource.WardrobeStore) {
            this.GetWardrobeItems(items);
        } else {
            this.GetPlayerItems(items, excludes);
            this.GetStashItems(items);
        }

        return items;
    }

    public static func GetInstance(game: GameInstance) -> ref<InventoryHelper> {
        return GameInstance.GetScriptableSystemsContainer(game).Get(n"EquipmentEx.InventoryHelper") as InventoryHelper;
    }
}
