module EquipmentEx

public abstract class EquipmentEx {
    public static func Version() -> String = "0.6.2";

    public static func RequiredArchiveXL() -> String = "1.3.4";
    public static func RequiredTweakXL() -> String = "1.1.0";

    public static func CheckRequirements() -> Bool {
        return ArchiveXL.Require(EquipmentEx.RequiredArchiveXL()) && TweakXL.Require(EquipmentEx.RequiredTweakXL());
    }
}
