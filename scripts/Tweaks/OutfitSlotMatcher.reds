module EquipmentEx

struct RecordSlotMapping {
    public let slotID: TweakDBID;
    public let recordIDs: array<TweakDBID>;
}

struct EntityNameSlotMapping {
    public let slotID: TweakDBID;
    public let entityName: CName;
}

struct AppearanceNameSlotMapping {
    public let slotID: TweakDBID;
    public let appearanceTokens: array<String>;
}

struct AppearanceTokenSlotMapping {
    public let slotID: TweakDBID;
    public let token: String;
    public let length: Int32;
}

struct EquipmentAreaSlotMapping {
    public let slotID: TweakDBID;
    public let equipmentAreas: array<TweakDBID>;
}

struct PriceModifierSlotMapping {
    public let slotID: TweakDBID;
    public let priceModifiers: array<TweakDBID>;
}

struct SlotMappingMatch {
    public let slotID: TweakDBID;
    public let score: Int32;
}

class OutfitSlotMatcher {
    private let m_recordMappings: array<RecordSlotMapping>;
    private let m_entityMappings: array<EntityNameSlotMapping>;
    private let m_appearanceTokens: array<AppearanceTokenSlotMapping>;
    private let m_equipmentMappings: array<EquipmentAreaSlotMapping>;
    private let m_priceMappings: array<PriceModifierSlotMapping>;
    private let m_ignoredEntities: array<CName>;

    public func MapRecords(mappings: array<RecordSlotMapping>) {
        this.m_recordMappings = mappings;
    }

    public func MapEntities(mappings: array<EntityNameSlotMapping>) {
        this.m_entityMappings = mappings;
    }

    public func MapAppearances(mappings: array<AppearanceNameSlotMapping>) {
        ArrayClear(this.m_appearanceTokens);
        for mapping in mappings {
            for token in mapping.appearanceTokens {
                ArrayPush(this.m_appearanceTokens, AppearanceTokenSlotMapping(mapping.slotID, token, StrLen(token)));
            }
        }
    }

    public func MapEquipmentAreas(mappings: array<EquipmentAreaSlotMapping>) {
        this.m_equipmentMappings = mappings;
    }

    public func MapPrices(mappings: array<PriceModifierSlotMapping>) {
        this.m_priceMappings = mappings;
    }

    public func IgnoreEntities(ignores: array<CName>) {
        this.m_ignoredEntities = ignores;
    }
    
    public func Match(item: ref<Clothing_Record>) -> TweakDBID {
        let appearanceName = item.AppearanceName();
        if Equals(appearanceName, n"") {
            return TDBID.None();
        }

        let entityName = item.EntityName();

        if ArrayContains(this.m_ignoredEntities, entityName) {
            return TDBID.None();
        }

        let recordID = item.GetID();

        // Record exact match
        for mapping in this.m_recordMappings {
            if ArrayContains(mapping.recordIDs, recordID) {
                return mapping.slotID;
            }
        }

        if ArraySize(this.m_appearanceTokens) > 0 {
            // Appearance exact match
            let appearanceNameStr = NameToString(appearanceName);
            for mapping in this.m_appearanceTokens {
                if Equals(appearanceNameStr, mapping.token) {
                    return mapping.slotID;
                }
            }

            // Appearance partial match
            let match: SlotMappingMatch;
            for mapping in this.m_appearanceTokens {
                if mapping.length > match.score && StrFindFirst(appearanceNameStr, mapping.token) >= 0 {
                    match.score = mapping.length;
                    match.slotID = mapping.slotID;
                }
            }
            if match.score > 0 {
                return match.slotID;
            }
        }

        if ArraySize(this.m_priceMappings) > 0 {
            let priceModifiers = TweakDBInterface.GetForeignKeyArray(recordID + t".buyPrice");

            // Price exact match
            for mapping in this.m_priceMappings {
                for priceModifier in mapping.priceModifiers {
                    if ArrayContains(priceModifiers, priceModifier) {
                        return mapping.slotID;
                    }
                }
            }
        }

        if ArraySize(this.m_equipmentMappings) > 0 {
            let equipmentArea = item.EquipArea().GetID();

            // Equipment area exact match
            for mapping in this.m_equipmentMappings {
                if ArrayContains(mapping.equipmentAreas, equipmentArea) {
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
        return new OutfitSlotMatcher();
    }
}
