module EquipmentEx

class PatchCustomItems extends ScriptableTweak {
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

        slotMatcher.MapPrices([
            new PriceModifierSlotMapping(t"OutfitSlots.Glasses", [t"Price.Glasses", t"Price.Visor"]),
            new PriceModifierSlotMapping(t"OutfitSlots.Wreath", [t"Price.TechFaceClothing"]),
            new PriceModifierSlotMapping(t"OutfitSlots.LegsOuter", [t"Price.Skirt"])
        ]);

        slotMatcher.MapEquipmentAreas([
            new EquipmentAreaSlotMapping(t"OutfitSlots.Head", [t"EquipmentArea.HeadArmor"]),
            new EquipmentAreaSlotMapping(t"OutfitSlots.Mask", [t"EquipmentArea.FaceArmor"]),
            new EquipmentAreaSlotMapping(t"OutfitSlots.TorsoInner", [t"EquipmentArea.InnerChest"]),
            new EquipmentAreaSlotMapping(t"OutfitSlots.TorsoOuter", [t"EquipmentArea.ChestArmor"]),
            new EquipmentAreaSlotMapping(t"OutfitSlots.LegsMiddle", [t"EquipmentArea.LegArmor"]),
            new EquipmentAreaSlotMapping(t"OutfitSlots.Feet", [t"EquipmentArea.Feet"]),
            new EquipmentAreaSlotMapping(t"OutfitSlots.BodyOuter", [t"EquipmentArea.Outfit"])
        ]);

        for record in TweakDBInterface.GetRecords(n"Clothing_Record") {
            let item = record as Clothing_Record;
            let placementSlots = TweakDBInterface.GetForeignKeyArray(item.GetID() + t".placementSlots");

            if ArraySize(placementSlots) == 1 {
                let outfitSlotID = slotMatcher.Match(item);
                if TDBID.IsValid(outfitSlotID) {
                    for outfitSlot in outfitSlots {
                        if outfitSlot.slotID == outfitSlotID {
                            if !ArrayContains(placementSlots, outfitSlot.slotID) {
                                ArrayPush(placementSlots, outfitSlot.slotID);
                                TweakDBManager.SetFlat(item.GetID() + t".placementSlots", placementSlots);
                                TweakDBManager.UpdateRecord(item.GetID());
                            }                           
                            break;
                        }
                    }
                }
            }
        }

        for record in TweakDBInterface.GetRecords(n"Clothing_Record") {
            let item = record as Clothing_Record;
            let placementSlots = TweakDBInterface.GetForeignKeyArray(item.GetID() + t".placementSlots");
            let garmentOffset = item.GarmentOffset();

            if garmentOffset == 0 && ArraySize(placementSlots) > 1 {
                let outfitSlotID = ArrayLast(placementSlots);
                if TDBID.IsValid(outfitSlotID) {
                    for outfitSlot in outfitSlots {
                        if outfitSlot.slotID == outfitSlotID {
                            TweakDBManager.SetFlat(item.GetID() + t".garmentOffset", outfitSlot.garmentOffset);
                            TweakDBManager.UpdateRecord(item.GetID());                       
                            break;
                        }
                    }
                }
            }
        }
    }
}
