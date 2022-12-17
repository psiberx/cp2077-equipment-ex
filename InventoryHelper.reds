module EquipmentEx

public class InventoryHelper extends ScriptableSystem {
    private let m_stash: wref<Stash>;
    private let m_preview: wref<inkInventoryPuppetPreviewGameController>;

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
        GameInstance.GetTransactionSystem(this.GetGameInstance()).GetItemList(this.m_stash, items);
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
