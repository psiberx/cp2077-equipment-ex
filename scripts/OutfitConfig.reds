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
    public let relatedSlotID: TweakDBID;
    public let displayName: String;

    public static func Create(slotName: CName, garmentOffset: Int32, relatedSlotID: TweakDBID, displayName: String) -> ExtraSlotConfig {
        return new ExtraSlotConfig(TDBID.Create(NameToString(slotName)), slotName, garmentOffset, relatedSlotID, "Gameplay-" + StrReplace(NameToString(slotName), ".", "-"));
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
        BaseSlotConfig.Create(t"AttachmentSlots.Feet", gamedataEquipmentArea.Feet)
    ];

    public static func OutfitSlots() -> array<ExtraSlotConfig> = [
        // Head
        ExtraSlotConfig.Create(n"OutfitSlots.Headwear", 0, t"AttachmentSlots.Head", "Headwear"),
        ExtraSlotConfig.Create(n"OutfitSlots.Balaclava", -4, t"AttachmentSlots.Head", "Balaclava"),

        // Face
        ExtraSlotConfig.Create(n"OutfitSlots.Mask", -1, t"AttachmentSlots.Eyes", "Mask"),
        ExtraSlotConfig.Create(n"OutfitSlots.Glasses", 0, t"AttachmentSlots.Eyes", "Glasses"),
        ExtraSlotConfig.Create(n"OutfitSlots.Wreath", 0, t"AttachmentSlots.Eyes", "Wreath"),

        // Ears
        ExtraSlotConfig.Create(n"OutfitSlots.EarLeft", 0, t"", "Left Ear"),
        ExtraSlotConfig.Create(n"OutfitSlots.EarRight", 0, t"", "Right Ear"),

        // Neck
        ExtraSlotConfig.Create(n"OutfitSlots.Neckwear", 0, t"", "Neckwear"),
        ExtraSlotConfig.Create(n"OutfitSlots.NecklaceShort", -1, t"", "Short Necklace"),
        ExtraSlotConfig.Create(n"OutfitSlots.NecklaceLong", -1, t"", "Long Necklace"),

        // Torso
        ExtraSlotConfig.Create(n"OutfitSlots.TorsoInner", -3, t"AttachmentSlots.Chest", "Inner Torso"),
        ExtraSlotConfig.Create(n"OutfitSlots.TorsoMiddle", -2, t"AttachmentSlots.Torso", "Middle Torso"),
        ExtraSlotConfig.Create(n"OutfitSlots.TorsoOuter", 1, t"AttachmentSlots.Torso", "Outer Torso"),
        ExtraSlotConfig.Create(n"OutfitSlots.TorsoAux", 2, t"AttachmentSlots.Torso", "Aux Torso"),

        // Shoulders
        ExtraSlotConfig.Create(n"OutfitSlots.ShoulderLeft", -1, t"", "Left Shoulder"),
        ExtraSlotConfig.Create(n"OutfitSlots.ShoulderRight", -1, t"", "Right Shoulder"),

        // Wrists
        ExtraSlotConfig.Create(n"OutfitSlots.WristLeft", -1, t"", "Left Wrist"),
        ExtraSlotConfig.Create(n"OutfitSlots.WristRight", -1, t"", "Right Wrist"),

        // Hands
        ExtraSlotConfig.Create(n"OutfitSlots.HandLeft", -1, t"", "Left Hand"),
        ExtraSlotConfig.Create(n"OutfitSlots.HandRight", -1, t"", "Right Hand"),

        // Waist
        ExtraSlotConfig.Create(n"OutfitSlots.Waist", 1, t"", "Waist"),

        // Legs
        ExtraSlotConfig.Create(n"OutfitSlots.LegsInner", -3, t"AttachmentSlots.Legs", "Inner Legs"),
        ExtraSlotConfig.Create(n"OutfitSlots.LegsMiddle", -1, t"AttachmentSlots.Legs", "Middle Legs"),
        ExtraSlotConfig.Create(n"OutfitSlots.LegsOuter", 0, t"AttachmentSlots.Legs", "Outer Legs"),

        // Thighs
        ExtraSlotConfig.Create(n"OutfitSlots.ThighLeft", -2, t"", "Left Thigh"),
        ExtraSlotConfig.Create(n"OutfitSlots.ThighRight", -2, t"", "Right Thigh"),
        
        // Ankles
        ExtraSlotConfig.Create(n"OutfitSlots.AnkleLeft", -2, t"", "Left Ankle"),
        ExtraSlotConfig.Create(n"OutfitSlots.AnkleRight", -2, t"", "Right Ankle"),

        // Feet
        ExtraSlotConfig.Create(n"OutfitSlots.Feet", 0, t"AttachmentSlots.Feet", "Feet"),

        // Full Body
        ExtraSlotConfig.Create(n"OutfitSlots.BodyInner", -10, t"AttachmentSlots.Torso", "Inner Body"),
        ExtraSlotConfig.Create(n"OutfitSlots.BodyOuter", 0, t"AttachmentSlots.Torso", "Outer Body")
    ];

    public static func AppearanceSuffixes() -> array<AppearanceSuffixConfig> = [
        AppearanceSuffixConfig.Create(n"itemsFactoryAppearanceSuffix.LegsState", n"EquipmentEx.OutfitSystem", n"GetLegsStateSuffix")
    ];
}
