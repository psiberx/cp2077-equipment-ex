module EquipmentEx

public class WardrobeHubLink extends MenuItemController {
    protected cb func OnInitialize() -> Bool {
        super.OnInitialize();

        let data: MenuData;
        data.label = GetLocalizedTextByKey(n"UI-Wardrobe-Tooltip-OutfitInfoTitle");
        data.icon = n"ico_wardrobe";
        data.fullscreenName = n"inventory_screen";
        data.identifier = EnumInt(HubMenuItems.Inventory);
        data.parentIdentifier = EnumInt(HubMenuItems.None);

        this.Init(data);
    }
}
