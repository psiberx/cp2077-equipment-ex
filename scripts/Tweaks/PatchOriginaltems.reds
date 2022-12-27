module EquipmentEx

class PatchOriginaltems extends ScriptableTweak {
    protected func OnApply() -> Void {
        let outfitSlots = OutfitConfig.OutfitSlots();
        let slotMatcher = OutfitSlotMatcher.Create();

        slotMatcher.IgnoreEntities([
            n"player_outfit_item"
        ]);

        slotMatcher.MapEntities([
            new EntityNameSlotMapping(t"OutfitSlots.Head", n"player_head_item"),
            new EntityNameSlotMapping(t"OutfitSlots.Mask", n"player_face_item"),
            new EntityNameSlotMapping(t"OutfitSlots.TorsoInner", n"player_inner_torso_item"),
            new EntityNameSlotMapping(t"OutfitSlots.TorsoOuter", n"player_outer_torso_item"),
            new EntityNameSlotMapping(t"OutfitSlots.LegsMiddle", n"player_legs_item"),
            new EntityNameSlotMapping(t"OutfitSlots.Feet", n"player_feet_item")
        ]);

        slotMatcher.MapAppearances([
            new AppearanceNameSlotMapping(t"OutfitSlots.Glasses", ["f1_tech_01_"]),
            new AppearanceNameSlotMapping(t"OutfitSlots.Wreath", ["f1_tech_02_"]),
            new AppearanceNameSlotMapping(t"OutfitSlots.Balaclava", ["h1_balaclava_"]),
            new AppearanceNameSlotMapping(t"OutfitSlots.TorsoUnder", ["t1_undershirt_02_", "t1_undershirt_03_", "t1_shirt_01_", "t1_shirt_02_"]),
            new AppearanceNameSlotMapping(t"OutfitSlots.TorsoInner", ["t1_undershirt_01_", "t1_tshirt_", "t1_formal_", "set_01_fixer_01_t1_"]),
            new AppearanceNameSlotMapping(t"OutfitSlots.TorsoInner", ["t2_dress_01_", "t2_jacket_16_"]),
            new AppearanceNameSlotMapping(t"OutfitSlots.TorsoMiddle", ["t1_shirt_03_"]),
            new AppearanceNameSlotMapping(t"OutfitSlots.TorsoMiddle", ["t2_dress_", "t2_shirt_", "t2_vest_", "t2_formal_"]),
            new AppearanceNameSlotMapping(t"OutfitSlots.TorsoAux", ["t2_vest_01_", "t2_vest_02_", "t2_vest_03_", "t2_vest_04_", "t2_vest_06_", "t2_vest_07_", "t2_vest_08_", "t2_vest_10_", "t2_vest_12_", "t2_vest_16_"]),
            new AppearanceNameSlotMapping(t"OutfitSlots.LegsOuter", ["l1_shorts_03_", "l1_shorts_04_", "l1_shorts_05_", "set_01_fixer_01_l1_"]),
            new AppearanceNameSlotMapping(t"OutfitSlots.LegsOuter", ["l1_pants_04_", "l1_pants_05_", "l1_pants_06_", "l1_pants_07_", "l1_pants_08_", "l1_pants_09_", "l1_pants_10_", "l1_pants_11_", "l1_pants_12_", "l1_pants_13_", "l1_pants_14_"]),
            new AppearanceNameSlotMapping(t"OutfitSlots.BodyUnder", ["t1_jumpsuit_", "set_01_netrunner_01_t1_"]),
            new AppearanceNameSlotMapping(t"OutfitSlots.BodyMiddle", ["t2_jumpsuit_"]) // "outfit_02_q114_cyberspace_"
        ]);

        slotMatcher.MapPrices([
            new PriceModifierSlotMapping(t"OutfitSlots.Mask", [t"Price.Mask"]),
            new PriceModifierSlotMapping(t"OutfitSlots.Glasses", [t"Price.Glasses", t"Price.Visor"]),
            new PriceModifierSlotMapping(t"OutfitSlots.Wreath", [t"Price.TechFaceClothing"]),
            new PriceModifierSlotMapping(t"OutfitSlots.LegsOuter", [t"Price.Skirt"])
        ]);

        slotMatcher.MapRecords([
            new RecordSlotMapping(t"OutfitSlots.Glasses", [
                t"Items.Media_01_Set_Tech",
                t"Items.Techie_01_Set_Tech"
            ]),
            new RecordSlotMapping(t"OutfitSlots.TorsoUnder", [
                t"Items.Media_01_Set_Shirt"
            ]),
            new RecordSlotMapping(t"OutfitSlots.TorsoMiddle", [
                t"Items.Corporate_01_Set_FormalJacket",
                t"Items.Rockerboy_01_Set_Jacket"
            ]),
            new RecordSlotMapping(t"OutfitSlots.TorsoAux", [
                t"Items.Media_01_Set_Vest",
                t"Items.SQ021_Wraiths_Vest",
                t"Items.Techie_01_Set_Vest"
            ]),
            new RecordSlotMapping(t"OutfitSlots.LegsOuter", [
                t"Items.Cop_01_Set_Pants",
                t"Items.Media_01_Set_Pants",
                t"Items.Netrunner_01_Set_Pants",
                t"Items.Nomad_01_Set_Pants",
                t"Items.Q202_Epilogue_Pants",
                t"Items.Q203_Epilogue_Pants",
                t"Items.Q204_Epilogue_Pants",
                t"Items.Solo_01_Set_Pants",
                t"Items.Techie_01_Set_Pants"
            ])
        ]);

        let offsetMatcher = OutfitOffsetMatcher.Create();

        offsetMatcher.MapEntities([
            new EntityNameOffsetMapping(-1500, n"player_underwear_top_item"),
            new EntityNameOffsetMapping(-1500, n"player_underwear_bottom_item")
        ]);

        offsetMatcher.MapAppearances([
            new AppearanceNameOffsetMapping(2000, ["t2_shirt_02_", "t2_vest_19_"]),
            new AppearanceNameOffsetMapping(4000, ["t2_jacket_11_", "set_01_nomad_01_t2_"]),
            new AppearanceNameOffsetMapping(-1000, ["t2_", "t1_formal_", "t1_shirt_01_", "t1_shirt_02_", "t1_undershirt_", "set_01_media_01_t1_", "t1_jumpsuit_", "set_01_netrunner_01_t1_"])
        ]);

        for record in TweakDBInterface.GetRecords(n"Clothing_Record") {
            let item = record as Clothing_Record;
            let placementSlots = TweakDBInterface.GetForeignKeyArray(item.GetID() + t".placementSlots");
            let garmentOffset = item.GarmentOffset();
            let updated = false;

            let outfitSlotID = slotMatcher.Match(item);
            if TDBID.IsValid(outfitSlotID) {
                for outfitSlot in outfitSlots {
                    if outfitSlot.slotID == outfitSlotID {
                        if !ArrayContains(placementSlots, outfitSlot.slotID) {
                            ArrayPush(placementSlots, outfitSlot.slotID);
                            updated = true;
                        }
                        if outfitSlot.garmentOffset != 0 {
                            garmentOffset = outfitSlot.garmentOffset;
                            updated = true;
                        }
                        break;
                    }
                }
            }

            let outfitOffset = offsetMatcher.Match(item);
            if outfitOffset >= 0 || garmentOffset <= 0 {
                garmentOffset += outfitOffset;
                updated = true;
            }

            if updated {
                TweakDBManager.SetFlat(item.GetID() + t".placementSlots", placementSlots);
                TweakDBManager.SetFlat(item.GetID() + t".garmentOffset", garmentOffset);
                TweakDBManager.UpdateRecord(item.GetID());
            }
        }
    }
}
