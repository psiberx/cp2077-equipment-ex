module EquipmentEx

class PatchOriginaltems extends ScriptableTweak {
    protected func OnApply() -> Void {
        let outfitSlots = OutfitConfig.OutfitSlots();
        let slotMatcher = OutfitSlotMatcher.Create();
        let offsetMatcher = OutfitOffsetMatcher.Create();

        slotMatcher.IgnoreEntities([
            n"player_outfit_item"
        ]);

        slotMatcher.MapEntities([
            new EntityNameSlotMapping(t"OutfitSlots.Head", n"player_head_item"),
            new EntityNameSlotMapping(t"OutfitSlots.Mask", n"player_face_item"),
            new EntityNameSlotMapping(t"OutfitSlots.TorsoInner", n"player_inner_torso_item"),
            new EntityNameSlotMapping(t"OutfitSlots.TorsoOuter", n"player_outer_torso_item"),
            new EntityNameSlotMapping(t"OutfitSlots.LegsInner", n"player_legs_item"),
            new EntityNameSlotMapping(t"OutfitSlots.Feet", n"player_feet_item")
        ]);

        slotMatcher.MapAppearances([
            new AppearanceNameSlotMapping(t"OutfitSlots.Balaclava", ["h1_balaclava_"]),
            new AppearanceNameSlotMapping(t"OutfitSlots.TorsoInner", ["t1_undershirt_", "t1_tshirt_", "t1_formal_", "set_01_fixer_01_t1_"]),
            new AppearanceNameSlotMapping(t"OutfitSlots.TorsoMiddle", ["t2_dress_", "t2_shirt_", "t2_vest_"]),
            new AppearanceNameSlotMapping(t"OutfitSlots.LegsOuter", ["set_01_fixer_01_l1_"]),
            new AppearanceNameSlotMapping(t"OutfitSlots.BodyInner", ["t1_jumpsuit_", "set_01_netrunner_01_t1_"])
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
                t"Items.Tech_01_basic_01",
                t"Items.Tech_01_basic_01_Crafting",
                t"Items.Tech_01_basic_02",
                t"Items.Tech_01_old_01",
                t"Items.Tech_01_rich_01",
                t"Items.Tech_01_rich_02",
                t"Items.Techie_01_Set_Tech"
            ]),
            new RecordSlotMapping(t"OutfitSlots.TorsoTight", [
                t"Items.Media_01_Set_Shirt",
                t"Items.Proficiency_Shirt_02_basic_02_Crafting",
                t"Items.Proficiency_Undershirt_03_basic_03_Crafting",
                t"Items.Q201_SpaceHospitalShirt",
                t"Items.Shirt_01_basic_01",
                t"Items.Shirt_01_basic_02",
                t"Items.Shirt_01_old_01",
                t"Items.Shirt_01_old_02",
                t"Items.Shirt_01_rich_01",
                t"Items.Shirt_01_rich_02",
                t"Items.Shirt_02_basic_01",
                t"Items.Shirt_02_basic_02",
                t"Items.Shirt_02_basic_03",
                t"Items.Shirt_02_basic_04",
                t"Items.Shirt_02_old_01",
                t"Items.Shirt_02_old_02",
                t"Items.Shirt_02_old_03",
                t"Items.Shirt_02_rich_01",
                t"Items.Shirt_02_rich_02",
                t"Items.Shirt_02_rich_03",
                t"Items.Undershirt_02_basic_01",
                t"Items.Undershirt_02_basic_02",
                t"Items.Undershirt_02_rich_01",
                t"Items.Undershirt_02_rich_02",
                t"Items.Undershirt_03_basic_01",
                t"Items.Undershirt_03_basic_02",
                t"Items.Undershirt_03_basic_03",
                t"Items.Undershirt_03_basic_04",
                t"Items.Undershirt_03_basic_04_Crafting",
                t"Items.Undershirt_03_rich_01",
                t"Items.Undershirt_03_rich_02"
            ]),
            new RecordSlotMapping(t"OutfitSlots.TorsoInner", [
                t"Items.Dress_01_basic_01",
                t"Items.Dress_01_basic_02",
                t"Items.Dress_01_basic_03",
                t"Items.Dress_01_rich_01",
                t"Items.Dress_01_rich_02",
                t"Items.Dress_01_rich_03",
                t"Items.Dress_01_rich_03_Crafting",
                t"Items.Jacket_16_basic_01",
                t"Items.Jacket_16_basic_02",
                t"Items.Jacket_16_old_01",
                t"Items.Jacket_16_old_02",
                t"Items.Jacket_16_rich_01",
                t"Items.Q005_Yorinobu_FormalShirt"
            ]),
            new RecordSlotMapping(t"OutfitSlots.TorsoMiddle", [
                t"Items.Corporate_01_Set_FormalJacket",
                t"Items.FormalJacket_01_basic_01",
                t"Items.FormalJacket_01_basic_02",
                t"Items.FormalJacket_01_old_01",
                t"Items.FormalJacket_01_old_02",
                t"Items.FormalJacket_01_rich_01",
                t"Items.FormalJacket_01_rich_02",
                t"Items.FormalJacket_02_basic_01",
                t"Items.FormalJacket_02_basic_02",
                t"Items.FormalJacket_02_basic_03",
                t"Items.FormalJacket_02_rich_01",
                t"Items.FormalJacket_02_rich_02",
                t"Items.FormalJacket_02_rich_03",
                t"Items.FormalJacket_03_basic_01",
                t"Items.FormalJacket_03_basic_02",
                t"Items.FormalJacket_03_basic_03",
                t"Items.FormalJacket_03_rich_01",
                t"Items.FormalJacket_03_rich_02",
                t"Items.FormalJacket_03_rich_03",
                t"Items.FormalJacket_04_basic_01",
                t"Items.FormalJacket_04_basic_02",
                t"Items.FormalJacket_04_basic_03",
                t"Items.FormalJacket_04_rich_01",
                t"Items.FormalJacket_04_rich_02",
                t"Items.FormalJacket_04_rich_03",
                t"Items.FormalJacket_05_basic_01",
                t"Items.FormalJacket_05_basic_02",
                t"Items.FormalJacket_05_basic_03",
                t"Items.FormalJacket_05_rich_01",
                t"Items.FormalJacket_05_rich_02",
                t"Items.FormalJacket_05_rich_03",
                t"Items.Q000_Corpo_FormalJacket",
                t"Items.Q000_Corpo_FormalJacket2",
                t"Items.Shirt_03_basic_01",
                t"Items.Shirt_03_basic_02",
                t"Items.Shirt_03_basic_02_Crafting",
                t"Items.Shirt_03_basic_03",
                t"Items.Shirt_03_old_01",
                t"Items.Shirt_03_old_02",
                t"Items.Shirt_03_old_03",
                t"Items.Shirt_03_rich_01",
                t"Items.Shirt_03_rich_02",
                t"Items.Shirt_03_rich_03",
                t"Items.TShirt_02_old_02",
                t"Items.Rockerboy_01_Set_Jacket"
            ]),
            new RecordSlotMapping(t"OutfitSlots.TorsoOuter", [
                t"Items.Jacket_11_basic_01",
                t"Items.Jacket_11_basic_02",
                t"Items.Jacket_11_old_01",
                t"Items.Jacket_11_old_02",
                t"Items.Jacket_11_rich_01",
                t"Items.Jacket_11_rich_02"
            ]),
            new RecordSlotMapping(t"OutfitSlots.TorsoAux", [
                t"Items.Vest_07_basic_03",
                t"Items.Vest_07_old_03",
                t"Items.Vest_12_basic_01",
                t"Items.Vest_12_basic_02",
                t"Items.Vest_12_old_01",
                t"Items.Vest_12_old_02",
                t"Items.Vest_12_rich_01",
                t"Items.Vest_12_rich_02"
            ]),
            new RecordSlotMapping(t"OutfitSlots.TorsoAux", [
                t"Items.Media_01_Set_Vest",
                t"Items.Techie_01_Set_Vest",
                t"Items.SQ021_Wraiths_Vest",
                t"Items.Vest_07_basic_01",
                t"Items.Vest_07_basic_02",
                t"Items.Vest_07_old_01",
                t"Items.Vest_07_old_02",
                t"Items.Vest_07_rich_01",
                t"Items.Vest_07_rich_02",
                t"Items.Vest_07_rich_03",
                t"Items.Vest_01_basic_01",
                t"Items.Vest_01_basic_02",
                t"Items.Vest_01_old_01",
                t"Items.Vest_01_old_02",
                t"Items.Vest_01_rich_01",
                t"Items.Vest_01_rich_02",
                t"Items.Vest_02_basic_01",
                t"Items.Vest_02_basic_02",
                t"Items.Vest_02_old_01",
                t"Items.Vest_02_old_02",
                t"Items.Vest_02_rich_01",
                t"Items.Vest_02_rich_02",
                t"Items.Vest_03_basic_01",
                t"Items.Vest_03_basic_02",
                t"Items.Vest_03_old_01",
                t"Items.Vest_03_old_02",
                t"Items.Vest_03_rich_01",
                t"Items.Vest_03_rich_02",
                t"Items.Vest_04_basic_01",
                t"Items.Vest_04_basic_02",
                t"Items.Vest_04_old_02",
                t"Items.Vest_04_rich_01",
                t"Items.Vest_04_rich_02",
                t"Items.Vest_06_basic_01",
                t"Items.Vest_06_basic_02",
                t"Items.Vest_06_old_01",
                t"Items.Vest_06_old_02",
                t"Items.Vest_06_rich_01",
                t"Items.Vest_06_rich_02",
                t"Items.Vest_06_rich_03",
                t"Items.Vest_06_rich_04",
                t"Items.Vest_08_basic_01",
                t"Items.Vest_08_basic_02",
                t"Items.Vest_08_old_01",
                t"Items.Vest_08_old_02",
                t"Items.Vest_08_rich_01",
                t"Items.Vest_08_rich_02",
                t"Items.Vest_10_basic_01",
                t"Items.Vest_10_basic_02",
                t"Items.Vest_10_old_01",
                t"Items.Vest_10_old_02",
                t"Items.Vest_10_rich_01",
                t"Items.Vest_10_rich_02",
                t"Items.Vest_04_old_01",
                t"Items.Vest_16_basic_01",
                t"Items.Vest_16_basic_02",
                t"Items.Vest_16_old_01",
                t"Items.Vest_16_old_02",
                t"Items.Vest_16_rich_01",
                t"Items.Vest_16_rich_02"
            ]),
            new RecordSlotMapping(t"OutfitSlots.LegsOuter", [
                t"Items.Shorts_03_basic_01",
                t"Items.Shorts_03_basic_02",
                t"Items.Shorts_03_basic_03",
                t"Items.Shorts_03_old_01",
                t"Items.Shorts_03_rich_01",
                t"Items.Shorts_04_old_01",
                t"Items.Shorts_04_old_02",
                t"Items.Shorts_04_old_03",
                t"Items.Shorts_04_old_04",
                t"Items.Shorts_05_old_01",
                t"Items.Shorts_05_old_02",
                t"Items.Shorts_05_old_03",
                t"Items.Shorts_05_old_04",
                t"Items.Shorts_05_old_05"
            ]),
            new RecordSlotMapping(t"OutfitSlots.LegsOuter", [
                t"Items.Netrunner_01_Set_Pants",
                t"Items.Nomad_01_Set_Pants",
                t"Items.Pants_05_basic_01",
                t"Items.Pants_05_basic_02",
                t"Items.Pants_05_old_01",
                t"Items.Pants_05_old_02",
                t"Items.Pants_05_rich_01",
                t"Items.Pants_05_rich_02",
                t"Items.Pants_09_rich_01",
                t"Items.Q000_StreetKid_Pants",
                t"Items.Q202_Epilogue_Pants",
                t"Items.Q203_Epilogue_Pants",
                t"Items.Q204_Epilogue_Pants",
                t"Items.Solo_01_Set_Pants",
                t"Items.Proficiency_Pants_13_basic_01_Crafting",
                t"Items.Pants_09_rich_02",
                t"Items.Pants_07_basic_02",
                t"Items.Pants_12_rich_01",
                t"Items.Pants_04_basic_02",
                t"Items.Pants_12_old_01",
                t"Items.Pants_14_basic_01",
                t"Items.Pants_09_old_02",
                t"Items.Pants_08_rich_03",
                t"Items.Pants_07_rich_02",
                t"Items.Pants_12_rich_02",
                t"Items.Pants_06_old_03",
                t"Items.Pants_14_basic_02",
                t"Items.Pants_11_rich_01",
                t"Items.Pants_03_rich_03",
                t"Items.Pants_12_basic_01",
                t"Items.Pants_08_old_03",
                t"Items.Pants_06_basic_01",
                t"Items.Pants_10_old_01",
                t"Items.Pants_07_rich_03",
                t"Items.Pants_10_basic_02",
                t"Items.Pants_11_basic_03",
                t"Items.Cop_01_Set_Pants",
                t"Items.Pants_06_rich_01",
                t"Items.Pants_12_basic_03",
                t"Items.Pants_14_old_01",
                t"Items.Pants_07_rich_01",
                t"Items.Pants_08_rich_01",
                t"Items.Pants_13_basic_02",
                t"Items.Pants_09_old_01",
                t"Items.Pants_09_basic_02",
                t"Items.SQ030_MaxTac_Pants",
                t"Items.Pants_11_old_03",
                t"Items.Pants_07_old_02",
                t"Items.Pants_08_rich_02",
                t"Items.Pants_04_basic_03",
                t"Items.Pants_04_rich_02",
                t"Items.Pants_08_old_01",
                t"Items.Pants_12_rich_03",
                t"Items.Pants_08_basic_01",
                t"Items.Pants_12_old_03",
                t"Items.Pants_12_old_02",
                t"Items.Pants_04_basic_01_Crafting",
                t"Items.Pants_13_old_01",
                t"Items.Pants_09_basic_01",
                t"Items.Pants_10_old_02",
                t"Items.Pants_04_old_01",
                t"Items.Pants_11_basic_01",
                t"Items.Pants_04_rich_01",
                t"Items.Techie_01_Set_Pants",
                t"Items.Pants_07_basic_03",
                t"Items.Pants_10_basic_01",
                t"Items.Pants_10_rich_02",
                t"Items.Pants_12_basic_02",
                t"Items.Pants_13_basic_03",
                t"Items.Pants_13_old_02",
                t"Items.Pants_06_old_02",
                t"Items.Pants_14_rich_02",
                t"Items.Pants_11_basic_02",
                t"Items.Pants_06_rich_02",
                t"Items.Pants_13_old_03",
                t"Items.Pants_08_rich_01_Crafting",
                t"Items.Pants_14_rich_01",
                t"Items.Pants_11_rich_03",
                t"Items.Pants_04_basic_04",
                t"Items.Pants_04_old_03",
                t"Items.Pants_04_basic_01",
                t"Items.Pants_08_basic_03",
                t"Items.Pants_09_old_03",
                t"Items.Pants_13_rich_01",
                t"Items.Pants_11_rich_02",
                t"Items.Pants_14_old_02",
                t"Items.Media_01_Set_Pants",
                t"Items.Pants_06_basic_02",
                t"Items.Pants_08_basic_02",
                t"Items.Pants_04_rich_03",
                t"Items.Pants_11_old_01",
                t"Items.Pants_07_old_01",
                t"Items.Pants_07_basic_01",
                t"Items.Pants_13_rich_02",
                t"Items.Pants_06_old_01",
                t"Items.Pants_07_old_03",
                t"Items.Pants_13_basic_01",
                t"Items.Pants_08_old_02",
                t"Items.Pants_11_old_02",
                t"Items.Pants_10_rich_01"
            ]),
            new RecordSlotMapping(t"OutfitSlots.BodyOuter", [
                t"Items.Jumpsuit_01_basic_01",
                t"Items.Jumpsuit_01_basic_02",
                t"Items.Jumpsuit_01_basic_03",
                t"Items.Jumpsuit_01_old_01",
                t"Items.Jumpsuit_01_old_02",
                t"Items.Jumpsuit_01_old_03",
                t"Items.Jumpsuit_01_rich_01",
                t"Items.Jumpsuit_01_rich_02",
                t"Items.Jumpsuit_02_basic_01",
                t"Items.Jumpsuit_02_basic_02",
                t"Items.Jumpsuit_02_old_01",
                t"Items.Jumpsuit_02_rich_01",
                t"Items.Jumpsuit_02_rich_02",
                t"Items.Jumpsuit_02_rich_03",
                t"Items.Jumpsuit_02_old_02",
                t"Items.Proficiency_Jumpsuit_02_rich_03_Crafting",
                t"Items.Q114_Cyberspace_Jumpsuit"
            ])
        ]);

        offsetMatcher.MapAppearances([
            new AppearanceNameOffsetMapping(2000, ["t2_shirt_02_"]),
            new AppearanceNameOffsetMapping(4000, ["t2_jacket_11_", "set_01_nomad_01_t2_"]),
            new AppearanceNameOffsetMapping(-1000, ["t2_", "t1_formal_", "t1_shirt_01_", "t1_shirt_02_", "t1_undershirt_", "set_01_media_01_t1_"])
        ]);

        for record in TweakDBInterface.GetRecords(n"Clothing_Record") {
            let item = record as Clothing_Record;
            let slotID = slotMatcher.Match(item);

            if TDBID.IsValid(slotID) {
                for outfitSlot in outfitSlots {
                    if outfitSlot.slotID == slotID {
                        let placementSlots = TweakDBInterface.GetForeignKeyArray(item.GetID() + t".placementSlots");

                        if !ArrayContains(placementSlots, outfitSlot.slotID) {
                            ArrayPush(placementSlots, outfitSlot.slotID);
                            TweakDBManager.SetFlat(item.GetID() + t".placementSlots", placementSlots);
                        }

                        let itemOffset = offsetMatcher.Match(item);
                        let garmentOffset = outfitSlot.garmentOffset;
                        if itemOffset >= 0 || garmentOffset < 0 {
                            garmentOffset += itemOffset;
                        }

                        if garmentOffset != item.GarmentOffset() {
                            TweakDBManager.SetFlat(item.GetID() + t".garmentOffset", garmentOffset);
                        }
                        
                        TweakDBManager.UpdateRecord(item.GetID());
                        break;
                    }
                }
            }
        }
    }
}
