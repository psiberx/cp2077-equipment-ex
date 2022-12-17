import EquipmentEx.OutfitSystem

@replaceMethod(WardrobeUIGameController)
protected cb func OnInitialize() -> Bool {
    this.GetChildWidgetByPath(n"mainScreenContainer").SetVisible(false);
    this.GetChildWidgetByPath(n"setEditorScreenContainer").SetVisible(false);
    this.GetChildWidgetByPath(n"constantContainer/paperDoll").SetVisible(false);

    this.SpawnFromExternal(this.GetRootCompoundWidget(), r"equipment_ex\\gui\\outfit_manager.inkwidget", n"Root:EquipmentEx.OutfitManagerController");
}
