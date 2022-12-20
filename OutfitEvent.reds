module EquipmentEx

public class OutfitItemUpdated extends Event {
    public let itemID: ItemID;
    public let itemName: String;
    public let slotID: TweakDBID;
    public let slotName: String;
    public let isEquipped: Bool;
}
