module EquipmentEx

public class ArchivePopup {
    public static func Show(controller: ref<worlduiIGameController>) -> ref<inkGameNotificationToken> {
        return GenericMessageNotification.Show(
            controller, 
            GetLocalizedText("LocKey#11447"), 
            "Equipment-EX has detected an issue:\n" + 
            "- archive/pc/mod/EquipmentEx.archive is missing\n\n" +
            "Possible solutions:\n" +
            "- Reinstall the mod from the original distribution\n" +
            "- If you installed it as REDmod, make sure mods are enabled\n", 
            GenericMessageNotificationType.OK
        );
    }
}
