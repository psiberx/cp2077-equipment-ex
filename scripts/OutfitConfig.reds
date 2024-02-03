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
    public let slotArea: CName;
    public let garmentOffset: Int32;
    public let relatedSlotIDs: array<TweakDBID>;
    public let dependencySlotIDs: array<TweakDBID>;
    public let displayName: String;

    public static func Create(slotArea: CName, slotName: CName, garmentOffset: Int32, opt relatedIDs: array<TweakDBID>, opt dependencyIDs: array<TweakDBID>) -> ExtraSlotConfig {
        return new ExtraSlotConfig(
            TDBID.Create(NameToString(slotName)),
            slotName,
            slotArea,
            garmentOffset,
            relatedIDs,
            dependencyIDs,
            "Gameplay-" + StrReplace(NameToString(slotName), ".", "-")
        );
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
        ExtraSlotConfig.Create(n"Head", n"OutfitSlots.Head", 310000, [t"AttachmentSlots.Head"]),
        ExtraSlotConfig.Create(n"Head", n"OutfitSlots.Balaclava", 160000, [t"AttachmentSlots.Head"]),
        ExtraSlotConfig.Create(n"Face", n"OutfitSlots.Mask", 170000, [t"AttachmentSlots.Eyes"]),
        ExtraSlotConfig.Create(n"Face", n"OutfitSlots.Glasses", 190000, [t"AttachmentSlots.Eyes"]),
        ExtraSlotConfig.Create(n"Face", n"OutfitSlots.Eyes", 130000, [t"AttachmentSlots.Eyes"]),
        ExtraSlotConfig.Create(n"Face", n"OutfitSlots.EyeLeft", 140000, [t"AttachmentSlots.Eyes"]),
        ExtraSlotConfig.Create(n"Face", n"OutfitSlots.EyeRight", 140000, [t"AttachmentSlots.Eyes"]),
        ExtraSlotConfig.Create(n"Face", n"OutfitSlots.Wreath", 180000, [t"AttachmentSlots.Eyes"]),
        ExtraSlotConfig.Create(n"Ears", n"OutfitSlots.EarLeft", 140000, [], [t"AttachmentSlots.Head"]),
        ExtraSlotConfig.Create(n"Ears", n"OutfitSlots.EarRight", 140000, [], [t"AttachmentSlots.Head"]),
        ExtraSlotConfig.Create(n"Neck", n"OutfitSlots.Neckwear", 200000, [], [t"AttachmentSlots.Head"]),
        ExtraSlotConfig.Create(n"Neck", n"OutfitSlots.NecklaceTight", 190000, [], [t"AttachmentSlots.Head"]),
        ExtraSlotConfig.Create(n"Neck", n"OutfitSlots.NecklaceShort", 190000),
        ExtraSlotConfig.Create(n"Neck", n"OutfitSlots.NecklaceLong", 190000),
        ExtraSlotConfig.Create(n"Torso", n"OutfitSlots.TorsoUnder", 120000, [t"AttachmentSlots.Chest"], [t"AttachmentSlots.Head", t"AttachmentSlots.Torso"]),
        ExtraSlotConfig.Create(n"Torso", n"OutfitSlots.TorsoInner", 150000, [t"AttachmentSlots.Chest"], [t"AttachmentSlots.Head", t"AttachmentSlots.Torso"]),
        ExtraSlotConfig.Create(n"Torso", n"OutfitSlots.TorsoMiddle", 180000, [t"AttachmentSlots.Torso"], [t"AttachmentSlots.Head"]),
        ExtraSlotConfig.Create(n"Torso", n"OutfitSlots.TorsoOuter", 210000, [t"AttachmentSlots.Torso"], [t"AttachmentSlots.Head"]),
        ExtraSlotConfig.Create(n"Torso", n"OutfitSlots.TorsoAux", 240000, [t"AttachmentSlots.Torso"], [t"AttachmentSlots.Head"]),
        ExtraSlotConfig.Create(n"Back", n"OutfitSlots.Back", 220000),
        ExtraSlotConfig.Create(n"Waist", n"OutfitSlots.Waist", 200000),
        ExtraSlotConfig.Create(n"Arms", n"OutfitSlots.ShoulderLeft", 200000),
        ExtraSlotConfig.Create(n"Arms", n"OutfitSlots.ShoulderRight", 200000),
        ExtraSlotConfig.Create(n"Arms", n"OutfitSlots.ElbowLeft", 200000),
        ExtraSlotConfig.Create(n"Arms", n"OutfitSlots.ElbowRight", 200000),
        ExtraSlotConfig.Create(n"Arms", n"OutfitSlots.WristLeft", 160000, [], [t"AttachmentSlots.Hands"]),
        ExtraSlotConfig.Create(n"Arms", n"OutfitSlots.WristRight", 160000, [], [t"AttachmentSlots.Hands"]),
        ExtraSlotConfig.Create(n"Hands", n"OutfitSlots.Hands", 160000, [], [t"AttachmentSlots.Hands"]),
        ExtraSlotConfig.Create(n"Hands", n"OutfitSlots.HandLeft", 170000, [], [t"AttachmentSlots.Hands"]),
        ExtraSlotConfig.Create(n"Hands", n"OutfitSlots.HandRight", 170000, [], [t"AttachmentSlots.Hands"]),
        ExtraSlotConfig.Create(n"Hands", n"OutfitSlots.HandPropLeft", 310000, [], [t"AttachmentSlots.Hands"]),
        ExtraSlotConfig.Create(n"Hands", n"OutfitSlots.HandPropRight", 310000, [], [t"AttachmentSlots.Hands"]),
        ExtraSlotConfig.Create(n"Fingers", n"OutfitSlots.FingersLeft", 180000, [], [t"AttachmentSlots.Hands"]),
        ExtraSlotConfig.Create(n"Fingers", n"OutfitSlots.FingersRight", 180000, [], [t"AttachmentSlots.Hands"]),
        ExtraSlotConfig.Create(n"Fingers", n"OutfitSlots.FingernailsLeft", 100000, [], [t"AttachmentSlots.Hands"]),
        ExtraSlotConfig.Create(n"Fingers", n"OutfitSlots.FingernailsRight", 100000, [], [t"AttachmentSlots.Hands"]),
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.LegsInner", 130000, [t"AttachmentSlots.Legs"], [t"AttachmentSlots.Feet"]),
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.LegsMiddle", 160000, [t"AttachmentSlots.Legs"], [t"AttachmentSlots.Feet"]),
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.LegsOuter", 190000, [t"AttachmentSlots.Legs"], [t"AttachmentSlots.Feet"]),
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.ThighLeft", 140000),
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.ThighRight", 140000),
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.KneeLeft", 140000),
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.KneeRight", 140000),
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.AnkleLeft", 140000),
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.AnkleRight", 140000),
        ExtraSlotConfig.Create(n"Feet", n"OutfitSlots.Feet", 180000, [t"AttachmentSlots.Feet"]),
        ExtraSlotConfig.Create(n"Toes", n"OutfitSlots.ToesLeft", 120000, [], [t"AttachmentSlots.Feet"]),
        ExtraSlotConfig.Create(n"Toes", n"OutfitSlots.ToesRight", 120000, [], [t"AttachmentSlots.Feet"]),
        ExtraSlotConfig.Create(n"Toes", n"OutfitSlots.ToenailsLeft", 100000, [], [t"AttachmentSlots.Feet"]),
        ExtraSlotConfig.Create(n"Toes", n"OutfitSlots.ToenailsRight", 100000, [], [t"AttachmentSlots.Feet"]),
        ExtraSlotConfig.Create(n"Body", n"OutfitSlots.BodyUnder", 110000, [t"AttachmentSlots.Chest", t"AttachmentSlots.Legs"], [t"AttachmentSlots.Head", t"AttachmentSlots.Torso", t"AttachmentSlots.Feet"]),
        ExtraSlotConfig.Create(n"Body", n"OutfitSlots.BodyInner", 140000, [t"AttachmentSlots.Chest", t"AttachmentSlots.Legs"], [t"AttachmentSlots.Head", t"AttachmentSlots.Torso", t"AttachmentSlots.Feet"]),
        ExtraSlotConfig.Create(n"Body", n"OutfitSlots.BodyMiddle", 170000, [t"AttachmentSlots.Torso", t"AttachmentSlots.Legs"], [t"AttachmentSlots.Head", t"AttachmentSlots.Feet"]),
        ExtraSlotConfig.Create(n"Body", n"OutfitSlots.BodyOuter", 300000, [t"AttachmentSlots.Torso", t"AttachmentSlots.Legs"], [t"AttachmentSlots.Head", t"AttachmentSlots.Feet"])
   ];
}
