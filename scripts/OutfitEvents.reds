module EquipmentEx

public class OutfitUpdated extends Event {
    public let isActive: Bool;
    public let outfitName: CName;
}

public class OutfitPartUpdated extends Event {
    public let itemID: ItemID;
    public let itemName: String;
    public let slotID: TweakDBID;
    public let slotName: String;
    public let isEquipped: Bool;
}

public class OutfitListUpdated extends Event {}
