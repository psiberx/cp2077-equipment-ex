module EquipmentEx

public class RequirementsPopup {
    public static func Show(controller: ref<worlduiIGameController>) -> ref<inkGameNotificationToken> {
        let params = new inkTextParams();

        params.AddString("archive_xl_ver", ArchiveXL.Version());
        params.AddString("tweak_xl_ver", TweakXL.Version());

        params.AddString("archive_xl_req", EquipmentEx.RequiredArchiveXL());
        params.AddString("tweak_xl_req", EquipmentEx.RequiredTweakXL());

        return GenericMessageNotification.Show(
            controller, 
            GetLocalizedText("LocKey#11447"), 
            GetLocalizedTextByKey(n"UI-EquipmentEx-NotificationRequirements"), 
            params,
            GenericMessageNotificationType.OK
        );
    }
}
