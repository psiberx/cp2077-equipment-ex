module EquipmentEx

class PatchCustomClothingItems extends ScriptableTweak {
    protected func OnApply() -> Void {
        let outfitSlots = OutfitConfig.OutfitSlots();
        let slotMatcher = OutfitSlotMatcher.Create();

        slotMatcher.IgnoreEntities([
            n"player_head_item",
            n"player_face_item",
            n"player_inner_torso_item",
            n"player_outer_torso_item",
            n"player_legs_item",
            n"player_feet_item",
            n"player_outfit_item"
        ]);

        slotMatcher.MapEquipmentAreas([
            new EquipmentAreaMapping(t"OutfitSlots.Headwear", [t"EquipmentArea.HeadArmor"]),
            new EquipmentAreaMapping(t"OutfitSlots.TorsoInner", [t"EquipmentArea.InnerChest"]),
            new EquipmentAreaMapping(t"OutfitSlots.TorsoOuter", [t"EquipmentArea.ChestArmor"]),
            new EquipmentAreaMapping(t"OutfitSlots.LegsMiddle", [t"EquipmentArea.LegArmor"]),
            new EquipmentAreaMapping(t"OutfitSlots.Feet", [t"EquipmentArea.Feet"]),
            new EquipmentAreaMapping(t"OutfitSlots.BodyInner", [t"EquipmentArea.Outfit"])
        ]);

        for record in TweakDBInterface.GetRecords(n"Clothing_Record") {
            let item = record as Clothing_Record;
            let slotID = slotMatcher.Match(item);

            if TDBID.IsValid(slotID) {
                for outfitSlot in outfitSlots {
                    if outfitSlot.slotID == slotID {
                        let updated = false;

                        let placementSlots = TweakDBInterface.GetForeignKeyArray(item.GetID() + t".placementSlots");
                        if ArraySize(placementSlots) == 1 && !ArrayContains(placementSlots, outfitSlot.slotID) {
                            ArrayPush(placementSlots, outfitSlot.slotID);
                            TweakDBManager.SetFlat(item.GetID() + t".placementSlots", placementSlots);
                            updated = true;
                        }
                        
                        if item.GarmentOffset() == 0 {
                            TweakDBManager.SetFlat(item.GetID() + t".garmentOffset", outfitSlot.garmentOffset);
                            updated = true;
                        }
                        
                        if updated {
                            TweakDBManager.UpdateRecord(item.GetID());
                        }
                        break;
                    }
                }
            }
        }
    }
}
