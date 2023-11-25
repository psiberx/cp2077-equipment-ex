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
        ExtraSlotConfig.Create(n"Head", n"OutfitSlots.Head", 31000, [t"AttachmentSlots.Head"], [t"AttachmentSlots.Head"]),
        ExtraSlotConfig.Create(n"Head", n"OutfitSlots.Balaclava", 12000, [t"AttachmentSlots.Head"], [t"AttachmentSlots.Head"]),
        ExtraSlotConfig.Create(n"Face", n"OutfitSlots.Mask", 13000, [t"AttachmentSlots.Eyes"], [t"AttachmentSlots.Head"]),
        ExtraSlotConfig.Create(n"Face", n"OutfitSlots.Glasses", 14000, [t"AttachmentSlots.Eyes"], [t"AttachmentSlots.Head"]),
        ExtraSlotConfig.Create(n"Face", n"OutfitSlots.Wreath", 14000, [t"AttachmentSlots.Eyes"], [t"AttachmentSlots.Head"]),
        ExtraSlotConfig.Create(n"Ears", n"OutfitSlots.EarLeft", 14000, [], [t"AttachmentSlots.Head"]),
        ExtraSlotConfig.Create(n"Ears", n"OutfitSlots.EarRight", 14000, [], [t"AttachmentSlots.Head"]),
        ExtraSlotConfig.Create(n"Neck", n"OutfitSlots.Neckwear", 20000, [], [t"AttachmentSlots.Head"]),
        ExtraSlotConfig.Create(n"Neck", n"OutfitSlots.NecklaceTight", 19000, [], [t"AttachmentSlots.Head"]),
        ExtraSlotConfig.Create(n"Neck", n"OutfitSlots.NecklaceShort", 19000),
        ExtraSlotConfig.Create(n"Neck", n"OutfitSlots.NecklaceLong", 19000),
        ExtraSlotConfig.Create(n"Torso", n"OutfitSlots.TorsoUnder", 12000, [t"AttachmentSlots.Chest"], [t"AttachmentSlots.Head", t"AttachmentSlots.Torso"]),
        ExtraSlotConfig.Create(n"Torso", n"OutfitSlots.TorsoInner", 15000, [t"AttachmentSlots.Chest"], [t"AttachmentSlots.Head", t"AttachmentSlots.Torso"]),
        ExtraSlotConfig.Create(n"Torso", n"OutfitSlots.TorsoMiddle", 18000, [t"AttachmentSlots.Torso"], [t"AttachmentSlots.Head"]),
        ExtraSlotConfig.Create(n"Torso", n"OutfitSlots.TorsoOuter", 21000, [t"AttachmentSlots.Torso"], [t"AttachmentSlots.Head"]),
        ExtraSlotConfig.Create(n"Torso", n"OutfitSlots.TorsoAux", 24000, [t"AttachmentSlots.Torso"], [t"AttachmentSlots.Head"]),
        ExtraSlotConfig.Create(n"Back", n"OutfitSlots.Back", 22000),
        ExtraSlotConfig.Create(n"Waist", n"OutfitSlots.Waist", 20000),
        ExtraSlotConfig.Create(n"Arms", n"OutfitSlots.ShoulderLeft", 20000),
        ExtraSlotConfig.Create(n"Arms", n"OutfitSlots.ShoulderRight", 16000),
        ExtraSlotConfig.Create(n"Arms", n"OutfitSlots.WristLeft", 16000, [], [t"AttachmentSlots.Hands"]),
        ExtraSlotConfig.Create(n"Arms", n"OutfitSlots.WristRight", 16000, [], [t"AttachmentSlots.Hands"]),
        ExtraSlotConfig.Create(n"Hands", n"OutfitSlots.HandLeft", 16000, [], [t"AttachmentSlots.Hands"]),
        ExtraSlotConfig.Create(n"Hands", n"OutfitSlots.HandRight", 16000, [], [t"AttachmentSlots.Hands"]),
        ExtraSlotConfig.Create(n"Hands", n"OutfitSlots.HandPropLeft", 31000, [], [t"AttachmentSlots.Hands"]),
        ExtraSlotConfig.Create(n"Hands", n"OutfitSlots.HandPropRight", 31000, [], [t"AttachmentSlots.Hands"]),
        ExtraSlotConfig.Create(n"Fingers", n"OutfitSlots.FingersLeft", 17000, [], [t"AttachmentSlots.Hands"]),
        ExtraSlotConfig.Create(n"Fingers", n"OutfitSlots.FingersRight", 17000, [], [t"AttachmentSlots.Hands"]),
        ExtraSlotConfig.Create(n"Fingers", n"OutfitSlots.FingernailsLeft", 10000, [], [t"AttachmentSlots.Hands"]),
        ExtraSlotConfig.Create(n"Fingers", n"OutfitSlots.FingernailsRight", 10000, [], [t"AttachmentSlots.Hands"]),
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.LegsInner", 13000, [t"AttachmentSlots.Legs"], [t"AttachmentSlots.Feet"]),
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.LegsMiddle", 16000, [t"AttachmentSlots.Legs"], [t"AttachmentSlots.Feet"]),
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.LegsOuter", 19000, [t"AttachmentSlots.Legs"], [t"AttachmentSlots.Feet"]),
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.ThighLeft", 14000),
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.ThighRight", 14000),
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.AnkleLeft", 14000),
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.AnkleRight", 14000),
        ExtraSlotConfig.Create(n"Feet", n"OutfitSlots.Feet", 18000, [t"AttachmentSlots.Feet"]),
        ExtraSlotConfig.Create(n"Toes", n"OutfitSlots.ToesLeft", 12000, [], [t"AttachmentSlots.Feet"]),
        ExtraSlotConfig.Create(n"Toes", n"OutfitSlots.ToesRight", 12000, [], [t"AttachmentSlots.Feet"]),
        ExtraSlotConfig.Create(n"Toes", n"OutfitSlots.ToenailsLeft", 10000, [], [t"AttachmentSlots.Feet"]),
        ExtraSlotConfig.Create(n"Toes", n"OutfitSlots.ToenailsRight", 10000, [], [t"AttachmentSlots.Feet"]),
        ExtraSlotConfig.Create(n"Body", n"OutfitSlots.BodyUnder", 11000, [t"AttachmentSlots.Chest", t"AttachmentSlots.Legs"], [t"AttachmentSlots.Head", t"AttachmentSlots.Torso", t"AttachmentSlots.Feet"]),
        ExtraSlotConfig.Create(n"Body", n"OutfitSlots.BodyInner", 14000, [t"AttachmentSlots.Chest", t"AttachmentSlots.Legs"], [t"AttachmentSlots.Head", t"AttachmentSlots.Torso", t"AttachmentSlots.Feet"]),
        ExtraSlotConfig.Create(n"Body", n"OutfitSlots.BodyMiddle", 17000, [t"AttachmentSlots.Torso", t"AttachmentSlots.Legs"], [t"AttachmentSlots.Head", t"AttachmentSlots.Feet"]),
        ExtraSlotConfig.Create(n"Body", n"OutfitSlots.BodyOuter", 30000, [t"AttachmentSlots.Torso", t"AttachmentSlots.Legs"], [t"AttachmentSlots.Head", t"AttachmentSlots.Feet"])
   ];
}
