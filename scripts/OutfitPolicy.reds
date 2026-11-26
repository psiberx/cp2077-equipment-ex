module EquipmentEx

// Extend and pass to OutfitSystem.RegisterPolicy()
public abstract class OutfitPolicy {
    // Same ID allows, another copy of the record swaps, ItemID.None() refuses
    public func ResolveItem(itemID: ItemID, slotID: TweakDBID) -> ItemID = itemID;

    // False stops EquipItem(recordID) from giving the player the item
    public func CanGiveItem(recordID: TweakDBID) -> Bool = true;

    // True keeps the vanilla Outfit item on (hidden) instead of deactivating
    public func KeepsOutfitArea(itemID: ItemID) -> Bool = false;

    // True hides the wardrobe buttons in the inventory hub and outfit slot screens
    public func HidesWardrobeButtons() -> Bool = false;

    // True hides the item source button in the wardrobe
    public func HidesItemSourceButton() -> Bool = false;
}
