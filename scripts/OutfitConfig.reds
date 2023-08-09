module EquipmentEx

struct BaseSlotConfig {
    public let slotID: TweakDBID;
    public let equipmentArea: gamedataEquipmentArea;

    public static func Create(slotID: TweakDBID, equipmentArea: gamedataEquipmentArea) -> BaseSlotConfig {
        return new BaseSlotConfig(slotID, equipmentArea);
    }
}

enum SlotDependency {
    Camera = 1,
    Feet = 2,
    Sleeves = 3
}

struct ExtraSlotConfig {
    public let slotID: TweakDBID;
    public let slotName: CName;
    public let slotArea: CName;
    public let garmentOffset: Int32;
    public let relatedIDs: array<TweakDBID>;
    public let displayName: String;
    public let dependsOnCamera: Bool;
    public let dependsOnSleeves: Bool;
    public let dependsOnFeet: Bool;

    public static func Create(slotArea: CName, slotName: CName, garmentOffset: Int32, opt relatedIDs: array<TweakDBID>, opt flags: array<SlotDependency>) -> ExtraSlotConfig {
        return new ExtraSlotConfig(
            TDBID.Create(NameToString(slotName)),
            slotName,
            slotArea,
            garmentOffset,
            relatedIDs,
            "Gameplay-" + StrReplace(NameToString(slotName), ".", "-"),
            ArrayContains(flags, SlotDependency.Camera),
            ArrayContains(flags, SlotDependency.Sleeves),
            ArrayContains(flags, SlotDependency.Feet)
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
        ExtraSlotConfig.Create(n"Head", n"OutfitSlots.Head", 310, [t"AttachmentSlots.Head"], [SlotDependency.Camera]),
        ExtraSlotConfig.Create(n"Head", n"OutfitSlots.Balaclava", 120, [t"AttachmentSlots.Head"], [SlotDependency.Camera]),
        ExtraSlotConfig.Create(n"Face", n"OutfitSlots.Mask", 130, [t"AttachmentSlots.Eyes"], [SlotDependency.Camera]),
        ExtraSlotConfig.Create(n"Face", n"OutfitSlots.Glasses", 140, [t"AttachmentSlots.Eyes"], [SlotDependency.Camera]),
        ExtraSlotConfig.Create(n"Face", n"OutfitSlots.Wreath", 140, [t"AttachmentSlots.Eyes"], [SlotDependency.Camera]),
        ExtraSlotConfig.Create(n"Ears", n"OutfitSlots.EarLeft", 140, [], [SlotDependency.Camera]),
        ExtraSlotConfig.Create(n"Ears", n"OutfitSlots.EarRight", 140, [], [SlotDependency.Camera]),
        ExtraSlotConfig.Create(n"Neck", n"OutfitSlots.Neckwear", 200, [], [SlotDependency.Camera]),
        ExtraSlotConfig.Create(n"Neck", n"OutfitSlots.NecklaceTight", 190, [], [SlotDependency.Camera]),
        ExtraSlotConfig.Create(n"Neck", n"OutfitSlots.NecklaceShort", 190),
        ExtraSlotConfig.Create(n"Neck", n"OutfitSlots.NecklaceLong", 190),
        ExtraSlotConfig.Create(n"Torso", n"OutfitSlots.TorsoUnder", 120, [t"AttachmentSlots.Chest"], [SlotDependency.Camera, SlotDependency.Sleeves]),
        ExtraSlotConfig.Create(n"Torso", n"OutfitSlots.TorsoInner", 150, [t"AttachmentSlots.Chest"], [SlotDependency.Camera, SlotDependency.Sleeves]),
        ExtraSlotConfig.Create(n"Torso", n"OutfitSlots.TorsoMiddle", 180, [t"AttachmentSlots.Torso"], [SlotDependency.Camera]),
        ExtraSlotConfig.Create(n"Torso", n"OutfitSlots.TorsoOuter", 210, [t"AttachmentSlots.Torso"], [SlotDependency.Camera]),
        ExtraSlotConfig.Create(n"Torso", n"OutfitSlots.TorsoAux", 240, [t"AttachmentSlots.Torso"], [SlotDependency.Camera]),
        ExtraSlotConfig.Create(n"Back", n"OutfitSlots.Back", 220),
        ExtraSlotConfig.Create(n"Waist", n"OutfitSlots.Waist", 200),
        ExtraSlotConfig.Create(n"Arms", n"OutfitSlots.ShoulderLeft", 200),
        ExtraSlotConfig.Create(n"Arms", n"OutfitSlots.ShoulderRight", 160),
        ExtraSlotConfig.Create(n"Arms", n"OutfitSlots.WristLeft", 160),
        ExtraSlotConfig.Create(n"Arms", n"OutfitSlots.WristRight", 160),
        ExtraSlotConfig.Create(n"Hands", n"OutfitSlots.HandLeft", 160),
        ExtraSlotConfig.Create(n"Hands", n"OutfitSlots.HandRight", 160),
        ExtraSlotConfig.Create(n"Hands", n"OutfitSlots.HandPropLeft", 310),
        ExtraSlotConfig.Create(n"Hands", n"OutfitSlots.HandPropRight", 310),
        ExtraSlotConfig.Create(n"Fingers", n"OutfitSlots.FingersLeft", 170),
        ExtraSlotConfig.Create(n"Fingers", n"OutfitSlots.FingersRight", 170),
        ExtraSlotConfig.Create(n"Fingers", n"OutfitSlots.FingernailsLeft", 100),
        ExtraSlotConfig.Create(n"Fingers", n"OutfitSlots.FingernailsRight", 100),
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.LegsInner", 130, [t"AttachmentSlots.Legs"], [SlotDependency.Feet]),
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.LegsMiddle", 160, [t"AttachmentSlots.Legs"], [SlotDependency.Feet]),
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.LegsOuter", 190, [t"AttachmentSlots.Legs"], [SlotDependency.Feet]),
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.ThighLeft", 140),
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.ThighRight", 140),
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.AnkleLeft", 140),
        ExtraSlotConfig.Create(n"Legs", n"OutfitSlots.AnkleRight", 140),
        ExtraSlotConfig.Create(n"Feet", n"OutfitSlots.Feet", 180, [t"AttachmentSlots.Feet"]),
        ExtraSlotConfig.Create(n"Toes", n"OutfitSlots.ToesLeft", 120, [], [SlotDependency.Feet]),
        ExtraSlotConfig.Create(n"Toes", n"OutfitSlots.ToesRight", 120, [], [SlotDependency.Feet]),
        ExtraSlotConfig.Create(n"Toes", n"OutfitSlots.ToenailsLeft", 100, [], [SlotDependency.Feet]),
        ExtraSlotConfig.Create(n"Toes", n"OutfitSlots.ToenailsRight", 100, [], [SlotDependency.Feet]),
        ExtraSlotConfig.Create(n"Body", n"OutfitSlots.BodyUnder", 110, [t"AttachmentSlots.Chest", t"AttachmentSlots.Legs"], [SlotDependency.Camera, SlotDependency.Sleeves, SlotDependency.Feet]),
        ExtraSlotConfig.Create(n"Body", n"OutfitSlots.BodyInner", 140, [t"AttachmentSlots.Chest", t"AttachmentSlots.Legs"], [SlotDependency.Camera, SlotDependency.Sleeves, SlotDependency.Feet]),
        ExtraSlotConfig.Create(n"Body", n"OutfitSlots.BodyMiddle", 170, [t"AttachmentSlots.Torso", t"AttachmentSlots.Legs"], [SlotDependency.Camera, SlotDependency.Feet]),
        ExtraSlotConfig.Create(n"Body", n"OutfitSlots.BodyOuter", 300, [t"AttachmentSlots.Torso", t"AttachmentSlots.Legs"], [SlotDependency.Camera, SlotDependency.Feet])
   ];
}
