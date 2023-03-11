import EquipmentEx.{CompatibilityManager, OutfitSystem, ArchivePopup, RequirementsPopup}

@addField(WardrobeUIGameController)
private let m_wardrobePopup: ref<inkGameNotificationToken>;

@replaceMethod(WardrobeUIGameController)
protected cb func OnInitialize() -> Bool {
    this.GetChildWidgetByPath(n"mainScreenContainer").SetVisible(false);
    this.GetChildWidgetByPath(n"setEditorScreenContainer").SetVisible(false);
    this.GetChildWidgetByPath(n"constantContainer/paperDoll").SetVisible(false);

    if !CompatibilityManager.CheckRequirements() {
        this.m_wardrobePopup = RequirementsPopup.Show(this);
        this.m_wardrobePopup.RegisterListener(this, n"OnWardrobePopupClose");
    } else {
        let wardrobe = this.SpawnFromExternal(this.GetRootCompoundWidget(), r"equipment_ex\\gui\\wardrobe.inkwidget", n"Root:EquipmentEx.WardrobeScreenController");
        if !IsDefined(wardrobe) {
            this.m_wardrobePopup = ArchivePopup.Show(this);
            this.m_wardrobePopup.RegisterListener(this, n"OnWardrobePopupClose");
            return false;
        }
    }

    this.m_introAnimProxy = new inkAnimProxy();
}

@replaceMethod(WardrobeUIGameController)
protected cb func OnBack(userData: ref<IScriptable>) -> Bool {
    this.m_menuEventDispatcher.SpawnEvent(n"OnWardrobeClose");
}

@replaceMethod(WardrobeUIGameController)
private final func CloseWardrobe() -> Void {
    this.m_menuEventDispatcher.SpawnEvent(n"OnWardrobeClose");
}

@addMethod(WardrobeUIGameController)
protected cb func OnWardrobePopupClose(data: ref<inkGameNotificationData>) {
    this.m_wardrobePopup = null;
    this.m_menuEventDispatcher.SpawnEvent(n"OnWardrobeClose");
}
