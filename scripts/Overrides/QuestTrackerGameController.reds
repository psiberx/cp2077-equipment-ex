import EquipmentEx.{EquipmentEx, ConflictsPopup}

@addField(QuestTrackerGameController)
private let m_wardrobePopup: ref<inkGameNotificationToken>;

@wrapMethod(QuestTrackerGameController)
protected cb func OnInitialize() -> Bool {
    wrappedMethod();

    if !EquipmentEx.IsUserNotified() {
        if !EquipmentEx.CheckConflicts(this.m_player.GetGame()) {
            this.m_wardrobePopup = ConflictsPopup.Show(this);
            this.m_wardrobePopup.RegisterListener(this, n"OnWardrobePopupClose");
        }
        EquipmentEx.MarkAsNotified();
    }
}

@addMethod(QuestTrackerGameController)
protected cb func OnWardrobePopupClose(data: ref<inkGameNotificationData>) {
    this.m_wardrobePopup = null;
}
