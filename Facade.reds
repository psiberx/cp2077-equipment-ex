import EquipmentEx.OutfitSystem

public abstract class EquipmentEx {
    public static func Activate(game: GameInstance) {
        OutfitSystem.GetInstance(game).Activate();
    }
    
    public static func Reactivate(game: GameInstance) {
        OutfitSystem.GetInstance(game).Reactivate();
    }
    
    public static func Deactivate(game: GameInstance) {
        OutfitSystem.GetInstance(game).Deactivate();
    }
    
    public static func EquipItem(game: GameInstance, itemID: TweakDBID) {
        OutfitSystem.GetInstance(game).EquipItem(itemID);
    }

    public static func EquipItem(game: GameInstance, itemID: TweakDBID, slotID: TweakDBID) {
        OutfitSystem.GetInstance(game).EquipItem(itemID, slotID);
    }

    public static func UnequipItem(game: GameInstance, itemID: TweakDBID) {
        OutfitSystem.GetInstance(game).UnequipItem(itemID);
    }

    public static func UnequipSlot(game: GameInstance, slotID: TweakDBID) {
        OutfitSystem.GetInstance(game).UnequipSlot(slotID);
    }

    public static func UnequipAll(game: GameInstance) {
        OutfitSystem.GetInstance(game).UnequipAll();
    }

    public static func PrintItems(game: GameInstance) {
        let outfitSystem = OutfitSystem.GetInstance(game);
        let usedSlots = outfitSystem.GetUsedSlots();

        if ArraySize(usedSlots) > 0 {
            let transactionSystem = GameInstance.GetTransactionSystem(game);
            let player = GetPlayer(game);

            LogChannel(n"DEBUG", "=== Equipped Items ===");
            
            for slotID in usedSlots {
                let itemID = transactionSystem.GetItemInSlot(player, slotID).GetItemID();
                LogChannel(n"DEBUG", s"\(outfitSystem.GetSlotName(slotID)) : \(outfitSystem.GetItemName(itemID))");
            }
            
            LogChannel(n"DEBUG", "===");
        } else {
            LogChannel(n"DEBUG", "=== No Equipped Items ===");
        }
    }

    public static func LoadOutfit(game: GameInstance, name: CName) {
        OutfitSystem.GetInstance(game).LoadOutfit(name);
    }

    public static func SaveOutfit(game: GameInstance, name: String) {
        OutfitSystem.GetInstance(game).SaveOutfit(StringToName(name), true);
    }

    public static func CopyOutfit(game: GameInstance, name: String, from: CName) {
        OutfitSystem.GetInstance(game).CopyOutfit(StringToName(name), from);
    }

    public static func DeleteOutfit(game: GameInstance, name: CName) {
        OutfitSystem.GetInstance(game).DeleteOutfit(name);
    }

    public static func PrintOutfits(game: GameInstance) {
        let outfitSystem = OutfitSystem.GetInstance(game);
        let outfitNames = outfitSystem.GetOutfits();

        if ArraySize(outfitNames) > 0 {
            LogChannel(n"DEBUG", "=== Saved Outfits ===");

            for outfitName in outfitNames {
                LogChannel(n"DEBUG", NameToString(outfitName));
            }

            LogChannel(n"DEBUG", "===");
        } else {
            LogChannel(n"DEBUG", "=== No Saved Outfits ===");
        }
    }
}
