module EquipmentEx

class ViewState {
    private persistent let m_collapsedSlots: array<TweakDBID>;

    public func IsCollapsed(slotID: TweakDBID) -> Bool {
        return ArrayContains(this.m_collapsedSlots, slotID);
    }
    
    public func SetCollapsed(slotID: TweakDBID, state: Bool) {
        if (state) {
            if !ArrayContains(this.m_collapsedSlots, slotID) {
                ArrayPush(this.m_collapsedSlots, slotID);
            }
        } else {
            ArrayRemove(this.m_collapsedSlots, slotID);
        }
    }

    public func ToggleCollapsed(slotID: TweakDBID) {
        this.SetCollapsed(slotID, !ArrayContains(this.m_collapsedSlots, slotID));
    }
    
    public func SetCollapsed(slots: array<TweakDBID>) {
        this.m_collapsedSlots = slots;
    }
}
