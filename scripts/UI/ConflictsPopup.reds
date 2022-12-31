module EquipmentEx

public class ConflictsPopup {
    public static func Show(controller: ref<worlduiIGameController>) -> ref<inkGameNotificationToken> {
        return GenericMessageNotification.Show(
            controller, 
            GetLocalizedText("LocKey#11447"), 
            GetLocalizedTextByKey(n"UI-EquipmentEx-NotificationConflicts"), 
            GenericMessageNotificationType.OK
        );
    }
}
