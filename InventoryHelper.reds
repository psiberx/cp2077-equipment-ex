module EquipmentEx

public class InventoryHelper extends ScriptableSystem {
    private let m_player: wref<GameObject>;
    private let m_transactionSystem: wref<TransactionSystem>;

    private let m_stash: wref<Stash>;
    private let m_preview: wref<inkInventoryPuppetPreviewGameController>;
    
    private func OnPlayerAttach(request: ref<PlayerAttachRequest>) {
        this.m_player = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerControlledGameObject();
        this.m_transactionSystem = GameInstance.GetTransactionSystem(this.GetGameInstance());
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

    public func GetStashItems(out items: array<wref<gameItemData>>) {
        this.m_transactionSystem.GetItemList(this.m_stash, items);
    }

    public func GetPlayerItems(out items: array<wref<gameItemData>>, opt excludes: array<ItemModParams>) {
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

    public func GetPlayerAndStashItems(opt excludes: array<ItemModParams>) -> array<wref<gameItemData>> {
        let items: array<wref<gameItemData>>;
        this.GetPlayerItems(items, excludes);
        this.GetStashItems(items);

        return items;
    }

    public func AddPreview(preview: ref<inkInventoryPuppetPreviewGameController>) {
        this.m_preview = preview;
    }

    public func GetPreview() -> wref<inkInventoryPuppetPreviewGameController> {
        return this.m_preview;
    }

    public static func GetInstance(game: GameInstance) -> ref<InventoryHelper> {
        return GameInstance.GetScriptableSystemsContainer(game).Get(n"EquipmentEx.InventoryHelper") as InventoryHelper;
    }
}
