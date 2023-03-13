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

    public func SetCollapsedState(slotID: TweakDBID, state: Bool) {
        this.m_state.SetCollapsedState(slotID, state);
    }

    public func ToggleCollapsedState(slotID: TweakDBID) {
        this.m_state.ToggleCollapsedState(slotID);
    }

    public static func GetInstance(game: GameInstance) -> ref<ViewManager> {
        return GameInstance.GetScriptableSystemsContainer(game).Get(n"EquipmentEx.ViewManager") as ViewManager;
    }
}
