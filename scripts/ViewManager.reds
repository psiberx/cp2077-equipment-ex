module EquipmentEx

public class ViewManager extends ScriptableSystem {
    private persistent let m_state: ref<ViewState>;

    private func OnAttach() {
        if !IsDefined(this.m_state) {
            this.m_state = new ViewState();
            this.m_state.SetItemSource(WardrobeItemSource.InventoryAndStash);
        }
    }

    public func GetItemSource() -> WardrobeItemSource {
        return this.m_state.GetItemSource();
    }

    public func SetItemSource(source: WardrobeItemSource) {
        if NotEquals(this.m_state.GetItemSource(), source) {
            this.m_state.SetItemSource(source);
            this.TriggerItemSourceEvent();
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

    private func TriggerItemSourceEvent() {
        GameInstance.GetUISystem(this.GetGameInstance()).QueueEvent(new ItemSourceUpdated());
    }

    public static func GetInstance(game: GameInstance) -> ref<ViewManager> {
        return GameInstance.GetScriptableSystemsContainer(game).Get(n"EquipmentEx.ViewManager") as ViewManager;
    }
}
