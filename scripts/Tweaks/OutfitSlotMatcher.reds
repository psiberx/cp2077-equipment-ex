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

struct EquipmentAreaSlotMapping {
    public let slotID: TweakDBID;
    public let equipmentAreas: array<TweakDBID>;
}

struct PriceModifierSlotMapping {
    public let slotID: TweakDBID;
    public let priceModifiers: array<TweakDBID>;
}

class OutfitSlotMatcher {
    private let m_recordMappings: array<RecordSlotMapping>;
    private let m_entityMappings: array<EntityNameSlotMapping>;
    private let m_appearanceMappings: array<AppearanceNameSlotMapping>;
    private let m_equipmentMappings: array<EquipmentAreaSlotMapping>;
    private let m_priceMappings: array<PriceModifierSlotMapping>;
    private let m_entityBans: array<CName>;

    public func MapRecords(mappings: array<RecordSlotMapping>) {
        this.m_recordMappings = mappings;
    }

    public func MapEntities(mappings: array<EntityNameSlotMapping>) {
        this.m_entityMappings = mappings;
    }

    public func MapAppearances(mappings: array<AppearanceNameSlotMapping>) {
        this.m_appearanceMappings = mappings;
    }

    public func MapEquipmentAreas(mappings: array<EquipmentAreaSlotMapping>) {
        this.m_equipmentMappings = mappings;
    }

    public func MapPrices(mappings: array<PriceModifierSlotMapping>) {
        this.m_priceMappings = mappings;
    }

    public func IgnoreEntities(ignores: array<CName>) {
        this.m_entityBans = ignores;
    }
    
    public func Match(item: ref<Clothing_Record>) -> TweakDBID {
        let recordID = item.GetID();
        let entityName = item.EntityName();
        let appearanceName = NameToString(item.AppearanceName());
        let priceModifiers = TweakDBInterface.GetForeignKeyArray(item.GetID() + t".buyPrice");
        let equipmentArea = item.EquipArea().GetID();

        if Equals(appearanceName, n"") {
            return TDBID.None();
        }

        if ArrayContains(this.m_entityBans, entityName) {
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

        // Equipment area exact match
        for mapping in this.m_equipmentMappings {
            if ArrayContains(mapping.equipmentAreas, equipmentArea) {
                return mapping.slotID;
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
