import EquipmentEx.{CompatibilityManager, OutfitSystem, WardrobeCache, ArchivePopup, RequirementsPopup}

@addField(WardrobeUIGameController)
private let m_wardrobeCache: wref<WardrobeCache>;

@addField(WardrobeUIGameController)
private let m_wardrobePopup: ref<inkGameNotificationToken>;

@replaceMethod(WardrobeUIGameController)
protected cb func OnInitialize() -> Bool {
    this.m_wardrobeCache = WardrobeCache.GetInstance(this.GetPlayerControlledObject().GetGame());

    this.GetChildWidgetByPath(n"mainScreenContainer").SetVisible(false);
    this.GetChildWidgetByPath(n"setEditorScreenContainer").SetVisible(false);
    this.GetChildWidgetByPath(n"constantContainer/paperDoll").SetVisible(false);

    if !CompatibilityManager.CheckRequirements() {
        this.m_wardrobePopup = RequirementsPopup.Show(this);
        this.m_wardrobePopup.RegisterListener(this, n"OnWardrobePopupClose");
    } else {
        this.m_wardrobeCache.StartBuild();

        let wardrobe = this.SpawnFromExternal(this.GetRootCompoundWidget(), r"equipment_ex\\gui\\wardrobe.inkwidget", n"Root:EquipmentEx.WardrobeScreenController");
        if !IsDefined(wardrobe) {
            this.m_wardrobePopup = ArchivePopup.Show(this);
            this.m_wardrobePopup.RegisterListener(this, n"OnWardrobePopupClose");
            return false;
        }
    }

    this.m_introAnimProxy = new inkAnimProxy();
}

@wrapMethod(WardrobeUIGameController)
protected cb func OnUninitialize() -> Bool {
    wrappedMethod();

    this.m_wardrobeCache.Invalidate();
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
