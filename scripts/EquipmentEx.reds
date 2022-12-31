module EquipmentEx

public abstract class EquipmentEx {
    public static func Version() -> String = "0.7.6";

    public static func RequiredArchiveXL() -> String = "1.3.4";
    public static func RequiredTweakXL() -> String = "1.1.0";

    public static func CheckRequirements() -> Bool {
        return ArchiveXL.Require(EquipmentEx.RequiredArchiveXL()) && TweakXL.Require(EquipmentEx.RequiredTweakXL());
    }

    public static func CheckConflicts(game: GameInstance) -> Bool {
        let container =  GameInstance.GetScriptableSystemsContainer(game);
        let wardrobeExtras = container.Get(n"WardrobeSystemExtra");
        return !IsDefined(wardrobeExtras);
    }

    public static func IsUserNotified() -> Bool {
        return TweakDBInterface.GetBool(t"EquipmentEx.isUserNotified", false);
    }

    public static func MarkAsNotified() -> Bool {
        TweakDBManager.SetFlat(t"EquipmentEx.isUserNotified", true);
    }
}
