module EquipmentEx

struct BaseSlotConfig {
    public let slotID: TweakDBID;
    public let equipmentArea: gamedataEquipmentArea;

    public static func Create(slotID: TweakDBID, equipmentArea: gamedataEquipmentArea) -> BaseSlotConfig {
        return new BaseSlotConfig(slotID, equipmentArea);
    }
}

enum ExtraSlotFlag {
    CameraDependent = 1,
    SwitchesLegs = 2,
    CoversLegs = 3
}

struct ExtraSlotConfig {
    public let slotID: TweakDBID;
    public let slotName: CName;
    public let slotArea: CName;
    public let garmentOffset: Int32;
    public let parentID: TweakDBID;
    public let displayName: String;
    public let dependsOnCamera: Bool;
    public let switchesLegs: Bool;
    public let coversLegs: Bool;

    public static func Create(slotArea: CName, slotName: CName, garmentOffset: Int32, opt parentID: TweakDBID, opt flags: array<ExtraSlotFlag>) -> ExtraSlotConfig {
        return new ExtraSlotConfig(
            TDBID.Create(NameToString(slotName)),
            slotName,
            slotArea,
            garmentOffset,
            parentID,
            "Gameplay-" + StrReplace(NameToString(slotName), ".", "-"),
            ArrayContains(flags, ExtraSlotFlag.CameraDependent),
            ArrayContains(flags, ExtraSlotFlag.SwitchesLegs),
            ArrayContains(flags, ExtraSlotFlag.CoversLegs)
        );
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
        ExtraSlotConfig.Create(n"Head", n"OutfitSlots.Head", 0, t"AttachmentSlots.Head"),
        ExtraSlotConfig.Create(n"Head", n"OutfitSlots.Balaclava", -4, t"AttachmentSlots.Head"),

        // Face
        ExtraSlotConfig.Create(n"Face", n"OutfitSlots.Mask", -1, t"AttachmentSlots.Eyes"),
        ExtraSlotConfig.Create(n"Face", n"OutfitSlots.Glasses", 0, t"AttachmentSlots.Eyes"),
        ExtraSlotConfig.Create(n"Face", n"OutfitSlots.Wreath", 0, t"AttachmentSlots.Eyes"),

        // Ears
        ExtraSlotConfig.Create(n"Ears", n"OutfitSlots.EarLeft", 0, t"", [ExtraSlotFlag.CameraDependent]),
        ExtraSlotConfig.Create(n"Ears", n"OutfitSlots.EarRight", 0, t"", [ExtraSlotFlag.CameraDependent]),

        // Neck
        ExtraSlotConfig.Create(n"Neck", n"OutfitSlots.Neckwear", 0, t"", [ExtraSlotFlag.CameraDependent]),
        ExtraSlotConfig.Create(n"Neck", n"OutfitSlots.NecklaceTight", 0),
        ExtraSlotConfig.Create(n"Neck", n"OutfitSlots.NecklaceShort", 0),
        ExtraSlotConfig.Create(n"Neck", n"OutfitSlots.NecklaceLong", 0),

        // Torso
        ExtraSlotConfig.Create(n"Torso", n"OutfitSlots.TorsoUnder", -4, t"AttachmentSlots.Chest", [ExtraSlotFlag.CameraDependent]),
        ExtraSlotConfig.Create(n"Torso", n"OutfitSlots.TorsoInner", -3, t"AttachmentSlots.Chest", [ExtraSlotFlag.CameraDependent]),
        ExtraSlotConfig.Create(n"Torso", n"OutfitSlots.TorsoMiddle", -2, t"AttachmentSlots.Torso", [ExtraSlotFlag.CameraDependent]),
        ExtraSlotConfig.Create(n"Torso", n"OutfitSlots.TorsoOuter", 2, t"AttachmentSlots.Torso", [ExtraSlotFlag.CameraDependent]),
        ExtraSlotConfig.Create(n"Torso", n"OutfitSlots.TorsoAux", 4, t"AttachmentSlots.Torso", [ExtraSlotFlag.CameraDependent]),
        
        // Back
        ExtraSlotConfig.Create(n"Back", n"OutfitSlots.Back", 3),

        // Waist
        ExtraSlotConfig.Create(n"Waist", n"OutfitSlots.Waist", 1),

        // Shoulders
        ExtraSlotConfig.Create(n"Arms", n"OutfitSlots.ShoulderLeft", -1),
        ExtraSlotConfig.Create(n"Arms", n"OutfitSlots.ShoulderRight", -1),

        // Wrists
        ExtraSlotConfig.Create(n"Arms", n"OutfitSlots.WristLeft", -1),
        ExtraSlotConfig.Create(n"Arms", n"OutfitSlots.WristRight", -1),

        // Hands
        ExtraSlotConfig.Create(n"Hands", n"OutfitSlots.HandLeft", -1),
        ExtraSlotConfig.Create(n"Hands", n"OutfitSlots.HandRight", -1),
        ExtraSlotConfig.Create(n"Hands", n"OutfitSlots.HandPropLeft", 0),
        ExtraSlotConfig.Create(n"Hands", n"OutfitSlots.HandPropRight", 0),

        // Fingers
        ExtraSlotConfig.Create(n"Fingers", n"OutfitSlots.FingersLeft", -2),
        ExtraSlotConfig.Create(n"Fingers", n"OutfitSlots.FingersRight", -2),
        ExtraSlotConfig.Create(n"Fingers", n"OutfitSlots.FingernailsLeft", -3),
        ExtraSlotConfig.Create(n"Fingers", n"OutfitSlots.FingernailsRight", -3),

        // Legs
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.LegsInner", -3, t"AttachmentSlots.Legs", [ExtraSlotFlag.CoversLegs]),
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.LegsMiddle", -1, t"AttachmentSlots.Legs", [ExtraSlotFlag.CoversLegs]),
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.LegsOuter", 0, t"AttachmentSlots.Legs", [ExtraSlotFlag.CoversLegs]),

        // Thighs
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.ThighLeft", -2),
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.ThighRight", -2),
        
        // Ankles
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.AnkleLeft", -2),
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.AnkleRight", -2),

        // Feet
        ExtraSlotConfig.Create(n"Feet", n"OutfitSlots.Feet", 0, t"AttachmentSlots.Feet", [ExtraSlotFlag.SwitchesLegs]),

        // Toes
        ExtraSlotConfig.Create(n"Toes", n"OutfitSlots.ToesLeft", -2, t"", [ExtraSlotFlag.CoversLegs]),
        ExtraSlotConfig.Create(n"Toes", n"OutfitSlots.ToesRight", -2, t"", [ExtraSlotFlag.CoversLegs]),
        ExtraSlotConfig.Create(n"Toes", n"OutfitSlots.ToenailsLeft", -3, t"", [ExtraSlotFlag.CoversLegs]),
        ExtraSlotConfig.Create(n"Toes", n"OutfitSlots.ToenailsRight", -3, t"", [ExtraSlotFlag.CoversLegs]),

        // Body
        ExtraSlotConfig.Create(n"Body", n"OutfitSlots.BodyUnder", -10, t"AttachmentSlots.Torso", [ExtraSlotFlag.CameraDependent, ExtraSlotFlag.CoversLegs]),
        ExtraSlotConfig.Create(n"Body", n"OutfitSlots.BodyInner", -2, t"AttachmentSlots.Torso", [ExtraSlotFlag.CameraDependent, ExtraSlotFlag.CoversLegs]),
        ExtraSlotConfig.Create(n"Body", n"OutfitSlots.BodyMiddle", -1, t"AttachmentSlots.Torso", [ExtraSlotFlag.CameraDependent, ExtraSlotFlag.CoversLegs]),
        ExtraSlotConfig.Create(n"Body", n"OutfitSlots.BodyOuter", 10, t"AttachmentSlots.Torso", [ExtraSlotFlag.CameraDependent, ExtraSlotFlag.CoversLegs])
    ];

    public static func AppearanceSuffixes() -> array<AppearanceSuffixConfig> = [
        AppearanceSuffixConfig.Create(n"itemsFactoryAppearanceSuffix.LegsState", n"EquipmentEx.PuppetStateSystem", n"GetLegsStateSuffix")
    ];
}
