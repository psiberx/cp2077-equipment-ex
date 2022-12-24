module EquipmentEx

struct AppearanceNameOffsetMapping {
    public let garmentOffset: Int32;
    public let appearanceTokens: array<String>;
}

class OutfitOffsetMatcher {
    private let m_appearanceMappings: array<AppearanceNameOffsetMapping>;

    public func MapAppearances(mappings: array<AppearanceNameOffsetMapping>) {
        this.m_appearanceMappings = mappings;
    }
    
    public func Match(item: ref<Clothing_Record>) -> Int32 {
        let appearanceName = NameToString(item.AppearanceName());

        if Equals(appearanceName, n"") {
            return 0;
        }

        // Appearance exact match
        for mapping in this.m_appearanceMappings {
            for appearanceToken in mapping.appearanceTokens {
                if Equals(appearanceName, appearanceToken) {
                    return mapping.garmentOffset;
                }
            }
        }

        // Appearance partial match
        for mapping in this.m_appearanceMappings {
            for appearanceToken in mapping.appearanceTokens {
                if StrFindFirst(appearanceName, appearanceToken) >= 0 {
                    return mapping.garmentOffset;
                }
            }
        }

        return 0;
    }

    public static func Create() -> ref<OutfitOffsetMatcher> {
        return new OutfitOffsetMatcher();
    }
}
