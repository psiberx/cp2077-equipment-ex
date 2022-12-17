module EquipmentEx

struct RecordMapping {
    public let slotID: TweakDBID;
    public let recordIDs: array<TweakDBID>;
}

struct EntityNameMapping {
    public let slotID: TweakDBID;
    public let entityName: CName;
}

struct AppearanceNameMapping {
    public let slotID: TweakDBID;
    public let appearanceTokens: array<String>;
}

struct PriceModifierMapping {
    public let slotID: TweakDBID;
    public let priceModifiers: array<TweakDBID>;
}

class OutfitSlotMatcher {
    private let m_recordMappings: array<RecordMapping>;
    private let m_entityMappings: array<EntityNameMapping>;
    private let m_appearanceMappings: array<AppearanceNameMapping>;
    private let m_priceMappings: array<PriceModifierMapping>;
    
    public func Match(item: ref<Clothing_Record>) -> TweakDBID {
        let recordID = item.GetID();
        let entityName = item.EntityName();
        let appearanceName = NameToString(item.AppearanceName());
        let priceModifiers = TweakDBInterface.GetForeignKeyArray(item.GetID() + t".buyPrice");

        if Equals(entityName, n"player_outfit_item") {
            return TDBID.None();
        }

        // Record exact match
        for mapping in this.m_recordMappings {
            if ArrayContains(mapping.recordIDs, recordID) {
                return mapping.slotID;
            }
        }

        // Appearance exact match
        for mapping in this.m_appearanceMappings {
            for appearanceToken in mapping.appearanceTokens {
                if Equals(appearanceName, appearanceToken) {
                    return mapping.slotID;
                }
            }
        }

        // Price exact match
        for mapping in this.m_priceMappings {
            for priceModifier in mapping.priceModifiers {
                if ArrayContains(priceModifiers, priceModifier) {
                    return mapping.slotID;
                }
            }
        }

        // Appearance partial match
        for mapping in this.m_appearanceMappings {
            for appearanceToken in mapping.appearanceTokens {
                if StrFindFirst(appearanceName, appearanceToken) >= 0 {
                    return mapping.slotID;
                }
            }
        }

        // Entity exact match
        for mapping in this.m_entityMappings {
            if Equals(entityName, mapping.entityName) {
                return mapping.slotID;
            }
        }

        return TDBID.None();
    }

    public static func Create() -> ref<OutfitSlotMatcher> {
        let instance = new OutfitSlotMatcher();

        instance.m_entityMappings = [
            new EntityNameMapping(t"OutfitSlots.Headwear", n"player_head_item"),
            new EntityNameMapping(t"OutfitSlots.Mask", n"player_face_item"),
            new EntityNameMapping(t"OutfitSlots.TorsoInner", n"player_inner_torso_item"),
            new EntityNameMapping(t"OutfitSlots.TorsoOuter", n"player_outer_torso_item"),
            new EntityNameMapping(t"OutfitSlots.LegsMiddle", n"player_legs_item"),
            new EntityNameMapping(t"OutfitSlots.Feet", n"player_feet_item")
        ];

        instance.m_appearanceMappings = [
            new AppearanceNameMapping(t"OutfitSlots.Balaclava", ["h1_balaclava_"]),
            new AppearanceNameMapping(t"OutfitSlots.TorsoInner", ["t1_undershirt_", "t1_tshirt_", "set_01_fixer_01_t1_"]),
            new AppearanceNameMapping(t"OutfitSlots.TorsoInner", ["t2_shirt_", "t2_jacket_16_basic_01_"]),
            new AppearanceNameMapping(t"OutfitSlots.TorsoMiddle", ["t1_formal_"]),
            new AppearanceNameMapping(t"OutfitSlots.TorsoMiddle", ["t2_vest_"]),
            new AppearanceNameMapping(t"OutfitSlots.TorsoOuter", ["t2_dress_", "t2_vest_01_basic_01_"]),
            new AppearanceNameMapping(t"OutfitSlots.LegsOuter", ["set_01_fixer_01_l1_"]),
            new AppearanceNameMapping(t"OutfitSlots.BodyInner", ["t1_jumpsuit_", "set_01_netrunner_01_t1_"])
        ];

        instance.m_priceMappings = [
            new PriceModifierMapping(t"OutfitSlots.Mask", [t"Price.Mask"]),
            new PriceModifierMapping(t"OutfitSlots.Glasses", [t"Price.Glasses", t"Price.Visor"]),
            new PriceModifierMapping(t"OutfitSlots.Wreath", [t"Price.TechFaceClothing"]),
            new PriceModifierMapping(t"OutfitSlots.LegsOuter", [t"Price.Skirt"])
        ];

        instance.m_recordMappings = [
            /*new RecordMapping(t"OutfitSlots.Headcovering", [
                t"Items.Scarf_03_basic_01",
                t"Items.Scarf_03_basic_02",
                t"Items.Scarf_03_basic_03",
                t"Items.Scarf_03_basic_03_Crafting",
                t"Items.Scarf_03_old_01",
                t"Items.Scarf_03_old_02",
                t"Items.Scarf_03_old_03",
                t"Items.Scarf_03_rich_01",
                t"Items.Scarf_03_rich_02",
                t"Items.Scarf_03_rich_03"
            ]),*/
            new RecordMapping(t"OutfitSlots.Glasses", [
                t"Items.Media_01_Set_Tech",
                t"Items.Tech_01_basic_01",
                t"Items.Tech_01_basic_01_Crafting",
                t"Items.Tech_01_basic_02",
                t"Items.Tech_01_old_01",
                t"Items.Tech_01_rich_01",
                t"Items.Tech_01_rich_02",
                t"Items.Techie_01_Set_Tech"
            ]),
            new RecordMapping(t"OutfitSlots.Neckwear", [
                t"Items.Vest_07_basic_03",
                t"Items.Vest_07_old_03",
                t"Items.Vest_12_basic_01",
                t"Items.Vest_12_basic_02",
                t"Items.Vest_12_old_01",
                t"Items.Vest_12_old_02",
                t"Items.Vest_12_rich_01",
                t"Items.Vest_12_rich_02"
            ]),
            new RecordMapping(t"OutfitSlots.TorsoMiddle", [
                t"Items.Corporate_01_Set_FormalShirt",
                t"Items.FormalShirt_01_basic_01",
                t"Items.FormalShirt_01_basic_02",
                t"Items.FormalShirt_01_basic_03",
                t"Items.FormalShirt_01_old_01",
                t"Items.FormalShirt_01_old_02",
                t"Items.FormalShirt_01_old_03",
                t"Items.FormalShirt_01_rich_01",
                t"Items.FormalShirt_01_rich_02",
                t"Items.FormalShirt_01_rich_03",
                t"Items.FormalShirt_01_rich_04",
                t"Items.FormalShirt_01_rich_05",
                t"Items.FormalShirt_01_rich_06",
                t"Items.FormalShirt_01_rich_06_Crafting",
                t"Items.FormalShirt_02_old_02",
                t"Items.LooseShirt_01_basic_01",
                t"Items.LooseShirt_01_basic_02",
                t"Items.LooseShirt_01_old_01",
                t"Items.LooseShirt_01_old_02",
                t"Items.LooseShirt_01_rich_01",
                t"Items.LooseShirt_01_rich_02",
                t"Items.LooseShirt_01_rich_02_Crafting",
                t"Items.LooseShirt_02_basic_01",
                t"Items.LooseShirt_02_basic_02",
                t"Items.LooseShirt_02_old_01",
                t"Items.LooseShirt_02_old_02",
                t"Items.LooseShirt_02_rich_01",
                t"Items.LooseShirt_02_rich_02",
                t"Items.Media_01_Set_Shirt",
                t"Items.Nomad_01_Set_TShirt",
                t"Items.Proficiency_LooseShirt_02_rich_01_Crafting",
                t"Items.Q005_Yorinobu_FormalShirt",
                t"Items.Q201_SpaceHospitalShirt",
                t"Items.Q203_Epilogue_TShirt",
                t"Items.Q204_Epilogue_TShirt",
                t"Items.Shirt_03_basic_01",
                t"Items.Shirt_03_basic_02",
                t"Items.Shirt_03_basic_02_Crafting",
                t"Items.Shirt_03_basic_03",
                t"Items.Shirt_03_old_01",
                t"Items.Shirt_03_old_02",
                t"Items.Shirt_03_rich_01",
                t"Items.Shirt_03_rich_02",
                t"Items.Shirt_03_rich_03",
                t"Items.Solo_01_Set_TShirt",
                t"Items.SQ012_Shirt_VoteForPeralez",
                t"Items.SQ023_Switchblade_Shirt",
                t"Items.TShirt_02_old_02"
            ]),
            new RecordMapping(t"OutfitSlots.TorsoMiddle", [
                t"Items.Jacket_11_basic_01",
                t"Items.Jacket_11_basic_02",
                t"Items.Jacket_11_old_01",
                t"Items.Jacket_11_old_02",
                t"Items.Jacket_11_rich_01",
                t"Items.Jacket_11_rich_02",
                t"Items.Jacket_16_basic_01",
                t"Items.Jacket_16_basic_02",
                t"Items.Jacket_16_old_01",
                t"Items.Jacket_16_old_02",
                t"Items.Jacket_16_rich_01"
            ]),
            new RecordMapping(t"OutfitSlots.TorsoAux", [
                t"Items.Media_01_Set_Vest",
                t"Items.Vest_01_basic_01",
                t"Items.Vest_01_basic_02",
                t"Items.Vest_01_old_01",
                t"Items.Vest_01_old_02",
                t"Items.Vest_01_rich_01",
                t"Items.Vest_01_rich_02",
                t"Items.Vest_02_basic_01",
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
                t"Items.Vest_10_rich_02"
            ]),
            new RecordMapping(t"OutfitSlots.LegsOuter", [
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
            new RecordMapping(t"OutfitSlots.LegsOuter", [
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
            new RecordMapping(t"OutfitSlots.BodyInner", [
                t"Items.Rockerboy_01_Set_Jacket"
            ]),
            new RecordMapping(t"OutfitSlots.BodyOuter", [
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
                t"Items.Proficiency_Jumpsuit_02_rich_03_Crafting",
                t"Items.Q114_Cyberspace_Jumpsuit"
            ])
        ];

        return instance;
    }
}

class PatchOriginalClothingItems extends ScriptableTweak {
    protected func OnApply() -> Void {
        let outfitSlots = OutfitConfig.OutfitSlots();
        let slotMatcher = OutfitSlotMatcher.Create();

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
                        
                        if outfitSlot.garmentOffset != item.GarmentOffset() {
                            TweakDBManager.SetFlat(item.GetID() + t".garmentOffset", outfitSlot.garmentOffset);
                        }
                        
                        TweakDBManager.UpdateRecord(item.GetID());
                        break;
                    }
                }
            }
        }
    }
}
