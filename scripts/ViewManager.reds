module EquipmentEx

public class ViewManager extends ScriptableSystem {
    private persistent let m_state: ref<ViewState>;

    private func OnAttach() {
        if !IsDefined(this.m_state) {
            this.m_state = new ViewState();
        }
    }

    public func IsCollapsed(slotID: TweakDBID) -> Bool {
        return this.m_state.IsCollapsed(slotID);
    }

    public func SetCollapsed(slotID: TweakDBID, state: Bool) {
        this.m_state.SetCollapsed(slotID, state);
    }

    public func ToggleCollapsed(slotID: TweakDBID) {
        this.m_state.ToggleCollapsed(slotID);
    }

    public func SetCollapsed(state: Bool) {
        if state {
            let outfitSystem = OutfitSystem.GetInstance(this.GetGameInstance());
            this.m_state.SetCollapsed(outfitSystem.GetOutfitSlots());
        } else {
            this.m_state.SetCollapsed([]);
        }        
    }

    public static func GetInstance(game: GameInstance) -> ref<ViewManager> {
        return GameInstance.GetScriptableSystemsContainer(game).Get(n"EquipmentEx.ViewManager") as ViewManager;
    }
}
