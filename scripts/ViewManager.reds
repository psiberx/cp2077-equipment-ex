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

    public func SetCollapsed(state: Bool) {
        if state {
            let outfitSystem = OutfitSystem.GetInstance(this.GetGameInstance());
            this.m_state.SetCollapsed(outfitSystem.GetOutfitSlots());
        } else {
            this.m_state.SetCollapsed([]);
        }        
    }

    public func ToggleCollapsed(slotID: TweakDBID) {
        this.m_state.ToggleCollapsed(slotID);
    }

    public func ToggleCollapsed() {
        let outfitSystem = OutfitSystem.GetInstance(this.GetGameInstance());
        let outfitSlots = outfitSystem.GetOutfitSlots();
        let collapsedSlots = this.m_state.GetCollapsed();

        this.SetCollapsed(ArraySize(outfitSlots) != ArraySize(collapsedSlots));
    }

    public static func GetInstance(game: GameInstance) -> ref<ViewManager> {
        return GameInstance.GetScriptableSystemsContainer(game).Get(n"EquipmentEx.ViewManager") as ViewManager;
    }
}
