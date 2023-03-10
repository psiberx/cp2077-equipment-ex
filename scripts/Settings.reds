module EquipmentEx

enum WardrobeItemSource {
    InventoryAndStash = 0,
    WardrobeStore = 1
}

class Settings {
    @runtimeProperty("ModSettings.mod", "Equipment-EX")
    @runtimeProperty("ModSettings.displayName", "UI-EquipmentEx-WardrobeItemSource")
    @runtimeProperty("ModSettings.description", "UI-EquipmentEx-WardrobeItemSource-Description")
    @runtimeProperty("ModSettings.displayValues.InventoryAndStash", "UI-EquipmentEx-WardrobeItemSource-InventoryAndStash")
    @runtimeProperty("ModSettings.displayValues.WardrobeStore", "UI-EquipmentEx-WardrobeItemSource-WardrobeStore")
    public let wardrobeItemSource: WardrobeItemSource = WardrobeItemSource.InventoryAndStash;
}
