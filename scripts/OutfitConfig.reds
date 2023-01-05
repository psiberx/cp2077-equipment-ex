module EquipmentEx

struct BaseSlotConfig {
    public let slotID: TweakDBID;
    public let equipmentArea: gamedataEquipmentArea;

    public static func Create(slotID: TweakDBID, equipmentArea: gamedataEquipmentArea) -> BaseSlotConfig {
        return new BaseSlotConfig(slotID, equipmentArea);
    }
}

struct ExtraSlotConfig {
    public let slotID: TweakDBID;
    public let slotName: CName;
    public let garmentOffset: Int32;
    public let parentID: TweakDBID;
    public let displayName: String;

    public static func Create(slotName: CName, garmentOffset: Int32, opt parentID: TweakDBID) -> ExtraSlotConfig {
        return new ExtraSlotConfig(TDBID.Create(NameToString(slotName)), slotName, garmentOffset, parentID, "Gameplay-" + StrReplace(NameToString(slotName), ".", "-"));
    }
}

struct AppearanceSuffixConfig {
    public let suffixID: TweakDBID;
    public let suffixName: CName;
    public let system: CName;
    public let method: CName;

    public static func Create(suffixName: CName, system: CName, method: CName) -> AppearanceSuffixConfig {
        return new AppearanceSuffixConfig(TDBID.Create(NameToString(suffixName)), suffixName, system, method);
    }
}

public abstract class OutfitConfig {
    public static func BaseSlots() -> array<BaseSlotConfig> = [
        BaseSlotConfig.Create(t"AttachmentSlots.Head", gamedataEquipmentArea.Head),
        BaseSlotConfig.Create(t"AttachmentSlots.Eyes", gamedataEquipmentArea.Face),
        BaseSlotConfig.Create(t"AttachmentSlots.Chest", gamedataEquipmentArea.InnerChest),
        BaseSlotConfig.Create(t"AttachmentSlots.Torso", gamedataEquipmentArea.OuterChest),
        BaseSlotConfig.Create(t"AttachmentSlots.Legs", gamedataEquipmentArea.Legs),
        BaseSlotConfig.Create(t"AttachmentSlots.Feet", gamedataEquipmentArea.Feet),
        BaseSlotConfig.Create(t"AttachmentSlots.UnderwearTop", gamedataEquipmentArea.UnderwearTop),
        BaseSlotConfig.Create(t"AttachmentSlots.UnderwearBottom", gamedataEquipmentArea.UnderwearBottom)
    ];

    public static func OutfitSlots() -> array<ExtraSlotConfig> = [
        // Head
        ExtraSlotConfig.Create(n"OutfitSlots.Head", 0, t"AttachmentSlots.Head"),
        ExtraSlotConfig.Create(n"OutfitSlots.Balaclava", -4, t"AttachmentSlots.Head"),

        // Face
        ExtraSlotConfig.Create(n"OutfitSlots.Mask", -1, t"AttachmentSlots.Eyes"),
        ExtraSlotConfig.Create(n"OutfitSlots.Glasses", 0, t"AttachmentSlots.Eyes"),
        ExtraSlotConfig.Create(n"OutfitSlots.Wreath", 0, t"AttachmentSlots.Eyes"),

        // Ears
        ExtraSlotConfig.Create(n"OutfitSlots.EarLeft", 0),
        ExtraSlotConfig.Create(n"OutfitSlots.EarRight", 0),

        // Neck
        ExtraSlotConfig.Create(n"OutfitSlots.Neckwear", 0),
        ExtraSlotConfig.Create(n"OutfitSlots.NecklaceTight", 0),
        ExtraSlotConfig.Create(n"OutfitSlots.NecklaceShort", 0),
        ExtraSlotConfig.Create(n"OutfitSlots.NecklaceLong", 0),

        // Torso
        ExtraSlotConfig.Create(n"OutfitSlots.TorsoUnder", -4, t"AttachmentSlots.Chest"),
        ExtraSlotConfig.Create(n"OutfitSlots.TorsoInner", -3, t"AttachmentSlots.Chest"),
        ExtraSlotConfig.Create(n"OutfitSlots.TorsoMiddle", -2, t"AttachmentSlots.Torso"),
        ExtraSlotConfig.Create(n"OutfitSlots.TorsoOuter", 2, t"AttachmentSlots.Torso"),
        ExtraSlotConfig.Create(n"OutfitSlots.TorsoAux", 4, t"AttachmentSlots.Torso"),

        // Shoulders
        ExtraSlotConfig.Create(n"OutfitSlots.ShoulderLeft", -1),
        ExtraSlotConfig.Create(n"OutfitSlots.ShoulderRight", -1),

        // Wrists
        ExtraSlotConfig.Create(n"OutfitSlots.WristLeft", -1),
        ExtraSlotConfig.Create(n"OutfitSlots.WristRight", -1),

        // Hands
        ExtraSlotConfig.Create(n"OutfitSlots.HandLeft", -1),
        ExtraSlotConfig.Create(n"OutfitSlots.HandRight", -1),

        // Waist
        ExtraSlotConfig.Create(n"OutfitSlots.Waist", 1),

        // Legs
        ExtraSlotConfig.Create(n"OutfitSlots.LegsInner", -3, t"AttachmentSlots.Legs"),
        ExtraSlotConfig.Create(n"OutfitSlots.LegsMiddle", -1, t"AttachmentSlots.Legs"),
        ExtraSlotConfig.Create(n"OutfitSlots.LegsOuter", 0, t"AttachmentSlots.Legs"),

        // Thighs
        ExtraSlotConfig.Create(n"OutfitSlots.ThighLeft", -2),
        ExtraSlotConfig.Create(n"OutfitSlots.ThighRight", -2),
        
        // Ankles
        ExtraSlotConfig.Create(n"OutfitSlots.AnkleLeft", -2),
        ExtraSlotConfig.Create(n"OutfitSlots.AnkleRight", -2),

        // Feet
        ExtraSlotConfig.Create(n"OutfitSlots.Feet", 0, t"AttachmentSlots.Feet"),

        // Body
        ExtraSlotConfig.Create(n"OutfitSlots.BodyUnder", -10, t"AttachmentSlots.Torso"),
        ExtraSlotConfig.Create(n"OutfitSlots.BodyInner", -2, t"AttachmentSlots.Torso"),
        ExtraSlotConfig.Create(n"OutfitSlots.BodyMiddle", -1, t"AttachmentSlots.Torso"),
        ExtraSlotConfig.Create(n"OutfitSlots.BodyOuter", 10, t"AttachmentSlots.Torso")
    ];

    public static func OutfitSlotMap() -> ref<inkIntHashMap> {
        let map = new inkIntHashMap();
        let outfitSlots = OutfitConfig.OutfitSlots();

        let i = 0;
        for slot in outfitSlots {
            map.Insert(TDBID.ToNumber(slot.slotID), i);
            i += 1;
        }

        return map;
    }

    public static func AppearanceSuffixes() -> array<AppearanceSuffixConfig> = [
        AppearanceSuffixConfig.Create(n"itemsFactoryAppearanceSuffix.LegsState", n"EquipmentEx.PuppetStateSystem", n"GetLegsStateSuffix")
    ];
}
