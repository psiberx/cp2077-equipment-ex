module EquipmentEx

public abstract class EquipmentEx {
    public static func Version() -> String = "0.8.2";

    public static func RequiredArchiveXL() -> String = "1.3.4";
    public static func RequiredTweakXL() -> String = "1.1.0";

    public static func CheckRequirements() -> Bool {
        return ArchiveXL.Require(EquipmentEx.RequiredArchiveXL()) && TweakXL.Require(EquipmentEx.RequiredTweakXL());
    }

    public static func CheckConflicts(game: GameInstance, opt conflicts: script_ref<array<String>>) -> Bool {
        let container =  GameInstance.GetScriptableSystemsContainer(game);
       
        let wardrobeExtrasFound = IsDefined(container.Get(n"WardrobeSystemExtra"));
        if wardrobeExtrasFound {
            ArrayPush(Deref(conflicts), "Wardrobe Extras");
        }
        
        let dataManager = new InventoryDataManagerV2();
        dataManager.Initialize(GetPlayer(game));

        let questsSystem = GameInstance.GetQuestsSystem(game);
        let transmogEnabled = questsSystem.GetFact(n"transmog_enabled");
        questsSystem.SetFact(n"transmog_enabled", 7);

        let trueHiddenEverythingFound = dataManager.IsTransmogEnabled() != 7;
        if trueHiddenEverythingFound {
            ArrayPush(Deref(conflicts), "True Hidden Everything");
        }

        questsSystem.SetFact(n"transmog_enabled", transmogEnabled);

        return !wardrobeExtrasFound && !trueHiddenEverythingFound;
    }

    public static func IsUserNotified() -> Bool {
        return TweakDBInterface.GetBool(t"EquipmentEx.isUserNotified", false);
    }

    public static func MarkAsNotified() -> Bool {
        TweakDBManager.SetFlat(t"EquipmentEx.isUserNotified", true);
    }
}
