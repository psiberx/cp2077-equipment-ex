import EquipmentEx.{LegsState,PuppetAttachmentChangeRequest,PuppetAppearanceChangeRequest}

@addField(ScriptedPuppet)
private let m_legsState: LegsState;

@addMethod(ScriptedPuppet)
protected cb func OnPuppetItemAddedToSlot(evt: ref<ItemAddedToSlot>) -> Bool {
    GameInstance.GetScriptableSystemsContainer(this.GetGame())
        .QueueRequest(PuppetAttachmentChangeRequest.Create(this, evt.GetSlotID(), evt.GetItemID(), true));
}

@addMethod(ScriptedPuppet)
protected cb func OnPuppetItemVisualsAddedToSlot(evt: ref<ItemVisualsAddedToSlot>) -> Bool {
    GameInstance.GetScriptableSystemsContainer(this.GetGame())
        .QueueRequest(PuppetAttachmentChangeRequest.Create(this, evt.GetSlotID(), evt.GetItemID(), true));
}

@addMethod(ScriptedPuppet)
protected cb func OnPuppetItemRemovedFromSlot(evt: ref<ItemRemovedFromSlot>) -> Bool {
    GameInstance.GetScriptableSystemsContainer(this.GetGame())
        .QueueRequest(PuppetAttachmentChangeRequest.Create(this, evt.GetSlotID(), evt.GetItemID(), false));
}

@addMethod(ScriptedPuppet)
protected cb func OnPuppetAppearanceChanged(evt: ref<entAppearanceChangeFinishEvent>) -> Bool {
    GameInstance.GetScriptableSystemsContainer(this.GetGame())
        .QueueRequest(PuppetAppearanceChangeRequest.Create(this));
}
