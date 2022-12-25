module EquipmentEx

public class PaperdollHelper extends ScriptableSystem {
    private let m_puppet: wref<gamePuppet>;
    private let m_preview: wref<inkInventoryPuppetPreviewGameController>;

    public func AddPreview(preview: ref<inkInventoryPuppetPreviewGameController>) {
        this.m_preview = preview;
    }

    public func GetPreview() -> wref<inkInventoryPuppetPreviewGameController> {
        return this.m_preview;
    }

    public func AddPuppet(puppet: ref<gamePuppet>) {
        this.m_puppet = puppet;
    }

    public func GetPuppet() -> wref<gamePuppet> {
        return this.m_puppet;
    }

    public static func GetInstance(game: GameInstance) -> ref<PaperdollHelper> {
        return GameInstance.GetScriptableSystemsContainer(game).Get(n"EquipmentEx.PaperdollHelper") as PaperdollHelper;
    }
}
