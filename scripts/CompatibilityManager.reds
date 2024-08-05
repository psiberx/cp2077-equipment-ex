module EquipmentEx

public abstract class CompatibilityManager {
    public static func RequiredCodeware() -> String = "1.12.3";
    public static func RequiredArchiveXL() -> String = "1.16.4";
    public static func RequiredTweakXL() -> String = "1.10.3";

    public static func CheckRequirements() -> Bool {
        return Codeware.Require(CompatibilityManager.RequiredCodeware())
            && ArchiveXL.Require(CompatibilityManager.RequiredArchiveXL())
            && TweakXL.Require(CompatibilityManager.RequiredTweakXL());
    }

    public static func CheckConflicts(game: GameInstance, out conflicts: array<String>) -> Bool {
        if IsDefined(GameInstance.GetScriptableSystemsContainer(game).Get(n"WardrobeSystemExtra")) {
            ArrayPush(conflicts, "Wardrobe Extras");
        }

        let dataManager = new InventoryDataManagerV2();
        dataManager.Initialize(GetPlayer(game));
        let questsSystem = GameInstance.GetQuestsSystem(game);
        let transmogEnabled = questsSystem.GetFact(n"transmog_enabled");
        questsSystem.SetFact(n"transmog_enabled", 7);
        if dataManager.IsTransmogEnabled() != 7 {
            ArrayPush(conflicts, "True Hidden Everything");
        }
        questsSystem.SetFact(n"transmog_enabled", transmogEnabled);

        let itemController = new InventoryItemDisplayController();
        itemController.SetLocked(true, true);
        if !itemController.m_isLocked {
            if itemController.m_visibleWhenLocked {
                ArrayPush(conflicts, "No Special Outfit Lock");
            } else {
                ArrayPush(conflicts, "Never Lock Outfits");
            }
        }

        if GameFileExists("archive/pc/mod/basegame_underwear_patch.archive") {
            ArrayPush(conflicts, "Underwear Remover by Sorrow446");
        }

        return ArraySize(conflicts) == 0;
    }

    public static func CheckConflicts(game: GameInstance) -> Bool {
        let conflicts: array<String>;
        return CompatibilityManager.CheckConflicts(game, conflicts);
    }

    public static func IsUserNotified() -> Bool {
        return TweakDBInterface.GetBool(t"EquipmentEx.isUserNotified", false);
    }

    public static func MarkAsNotified() {
        TweakDBManager.SetFlat(t"EquipmentEx.isUserNotified", true);
    }
}
