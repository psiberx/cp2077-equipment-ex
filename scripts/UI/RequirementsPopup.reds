module EquipmentEx

public class RequirementsPopup {
    public static func Show(controller: ref<worlduiIGameController>) -> ref<inkGameNotificationToken> {
        let params = new inkTextParams();

        params.AddString("archive_xl_req", CompatibilityManager.RequiredArchiveXL());
        params.AddString("tweak_xl_req", CompatibilityManager.RequiredTweakXL());
        params.AddString("codeware_req", CompatibilityManager.RequiredCodeware());

        params.AddString("archive_xl_ver", ArchiveXL.Version());
        params.AddString("tweak_xl_ver", TweakXL.Version());
        params.AddString("codeware_ver", Codeware.Version());

        return GenericMessageNotification.Show(
            controller, 
            GetLocalizedText("LocKey#11447"), 
            GetLocalizedTextByKey(n"UI-EquipmentEx-NotificationRequirements"), 
            params,
            GenericMessageNotificationType.OK
        );
    }
}
