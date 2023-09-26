import EquipmentEx.{CompatibilityManager, OutfitSystem, ArchivePopup, RequirementsPopup}

@addField(gameuiInventoryGameController)
private let m_outfitSystem: wref<OutfitSystem>;

@addField(gameuiInventoryGameController)
private let m_wardrobeButton: wref<inkWidget>;

@addField(gameuiInventoryGameController)
private let m_wardrobePopup: ref<inkGameNotificationToken>;

@addField(gameuiInventoryGameController)
private let m_wardrobeReady: Bool;

@wrapMethod(gameuiInventoryGameController)
protected cb func OnInitialize() -> Bool {
    wrappedMethod();

    this.m_outfitSystem = OutfitSystem.GetInstance(this.GetPlayerControlledObject().GetGame());
}

@wrapMethod(gameuiInventoryGameController)
protected cb func OnUninitialize() -> Bool {
    wrappedMethod();

    this.m_wardrobeButton.UnregisterFromCallback(n"OnClick", this, n"OnWardrobeBtnClick");
}

@replaceMethod(gameuiInventoryGameController)
private final func SetupSetButton() -> Void {
    let btnWrapper = this.GetChildWidgetByPath(n"default_wrapper/menuLinks") as inkCompoundWidget;
    let btnList = this.GetChildWidgetByPath(n"default_wrapper/menuLinks/btnsContainer") as inkCompoundWidget;

    //
    btnList.GetWidgetByIndex(3).SetVisible(false);
    btnList.GetWidgetByIndex(4).SetVisible(false);

    // Spawn new button
    this.m_wardrobeButton = this.SpawnFromLocal(btnList, n"HyperlinkButton:EquipmentEx.WardrobeHubLinkController");
    this.m_wardrobeButton.RegisterToCallback(n"OnClick", this, n"OnWardrobeBtnClick");

    // Adjust button container size
    let btnSpacing = btnList.GetChildMargin();
    btnWrapper.SetHeight(btnWrapper.GetHeight() + this.m_wardrobeButton.GetHeight() + btnSpacing.top);

    // Adjust fluff text position
    let fluff = btnWrapper.GetWidget(n"buttonFluff2");
    fluff.SetAnchor(inkEAnchor.BottomLeft);
    fluff.SetMargin(new inkMargin(0, 0, 0, 4.0));

    // Force hide original button
    inkWidgetRef.SetVisible(this.m_btnSets, false);
}

@addMethod(gameuiInventoryGameController)
protected cb func OnWardrobeBtnClick(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"click") {
        this.ShowWardrobeScreen();
    }
}

@addMethod(gameuiInventoryGameController)
protected cb func OnWardrobePopupClose(data: ref<inkGameNotificationData>) {
    this.m_wardrobePopup = null;
}

@wrapMethod(gameuiInventoryGameController)
protected cb func OnBack(userData: ref<IScriptable>) -> Bool {
    if this.m_wardrobeReady && IsDefined(this.GetChildWidgetByPath(n"wardrobe")) {
        return this.HideWardrobeScreen();
    } else {
        return wrappedMethod(userData);
    }
}

@addMethod(gameuiInventoryGameController)
protected func ShowWardrobeScreen() -> Bool {
    if !CompatibilityManager.CheckRequirements() {
        this.m_wardrobePopup = RequirementsPopup.Show(this);
        this.m_wardrobePopup.RegisterListener(this, n"OnWardrobePopupClose");
        return false;
    }

    if IsDefined(this.GetChildWidgetByPath(n"wardrobe")) {
        return false;
    }

    let wardrobe = this.SpawnFromExternal(this.GetRootCompoundWidget(), r"equipment_ex\\gui\\wardrobe.inkwidget", n"Root:EquipmentEx.WardrobeScreenController") as inkCompoundWidget;
    
    if !IsDefined(wardrobe) {
        this.m_wardrobePopup = ArchivePopup.Show(this);
        this.m_wardrobePopup.RegisterListener(this, n"OnWardrobePopupClose");
        return false;
    }

    wardrobe.SetName(n"wardrobe");

    let alphaAnim = new inkAnimTransparency();
    alphaAnim.SetStartTransparency(0.0);
    alphaAnim.SetEndTransparency(1.0);
    alphaAnim.SetType(inkanimInterpolationType.Linear);
    alphaAnim.SetMode(inkanimInterpolationMode.EasyOut);
    alphaAnim.SetDuration(0.8);
    
    let animDef = new inkAnimDef();
    animDef.AddInterpolator(alphaAnim);

    wardrobe.GetWidgetByPathName(n"wrapper/wrapper").PlayAnimation(animDef);
    // animProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnWardrobeScreenShown");

    this.m_wardrobeReady = true;

    if Equals(this.m_mode, InventoryModes.Item) {
        this.PlayShowHideItemChooserAnimation(false);
    } else {
        this.PlayLibraryAnimation(n"default_wrapper_outro");
    }

    this.GetChildWidgetByPath(n"wardrobe/wrapper/preview").SetVisible(false);
    this.PlaySlidePaperdollAnimationToOutfit();

    this.m_buttonHintsController.Hide();

    let evt = new DropQueueUpdatedEvent();
    evt.m_dropQueue = this.m_itemModeLogicController.m_itemDropQueue;
    wardrobe.GetController().QueueEvent(evt);

    return true;
}

// @addMethod(gameuiInventoryGameController)
// protected cb func OnWardrobeScreenShown(anim: ref<inkAnimProxy>) {
//     LogDebug(s"OnWardrobeScreenShown \(this.GetRootCompoundWidget().GetNumChildren())");
//     this.m_wardrobeReady = true;
// }

@addMethod(gameuiInventoryGameController)
protected func HideWardrobeScreen() -> Bool {
    if !this.m_wardrobeReady {
        return false;
    }

    let wardrobe = this.GetChildWidgetByPath(n"wardrobe") as inkCompoundWidget;

    this.m_wardrobeReady = false;
    
    let alphaAnim = new inkAnimTransparency();
    alphaAnim.SetStartTransparency(1.0);
    alphaAnim.SetEndTransparency(0.0);
    alphaAnim.SetType(inkanimInterpolationType.Linear);
    alphaAnim.SetMode(inkanimInterpolationMode.EasyOut);
    alphaAnim.SetDuration(0.3);
    
    let animDef = new inkAnimDef();
    animDef.AddInterpolator(alphaAnim);

    let animProxy = wardrobe.GetWidgetByPathName(n"wrapper/wrapper").PlayAnimation(animDef);
    animProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnWardrobeScreenHidden");

    if Equals(this.m_mode, InventoryModes.Item) {
        this.SwapMode(InventoryModes.Default);
        this.m_itemModeLogicController.m_isShown = false;
    }

    this.PlayLibraryAnimation(n"default_wrapper_Intro");

    this.GetChildWidgetByPath(n"wardrobe/wrapper/preview").SetVisible(false);
    inkWidgetRef.SetVisible(this.m_paperDollWidget, true);

    this.PlaySlidePaperdollAnimation(PaperdollPositionAnimation.Center, false);
    this.ZoomCamera(EnumInt(InventoryPaperdollZoomArea.Default));

    this.m_buttonHintsController.Show();

    return true;
}

@addMethod(gameuiInventoryGameController)
protected cb func OnWardrobeScreenHidden(anim: ref<inkAnimProxy>) {
    this.GetRootCompoundWidget().RemoveChildByName(n"wardrobe");
}

@addMethod(gameuiInventoryGameController)
protected final func PlaySlidePaperdollAnimationToOutfit() {
    let outfitPreview = this.GetChildWidgetByPath(n"wardrobe/wrapper/preview");
    let outfitPreviewMargin = outfitPreview.GetMargin();

    let translationInterpolator = new inkAnimTranslation();
    translationInterpolator.SetDuration(0.2);
    translationInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
    translationInterpolator.SetType(inkanimInterpolationType.Linear);
    translationInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    translationInterpolator.SetStartTranslation(inkWidgetRef.GetTranslation(this.m_paperDollWidget));
    translationInterpolator.SetEndTranslation(new Vector2(outfitPreviewMargin.left, 0.00));

    let translationAnimation = new inkAnimDef();
    translationAnimation.AddInterpolator(translationInterpolator);

    let animProxy = inkWidgetRef.PlayAnimation(this.m_paperDollWidget, translationAnimation);
    animProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnPaperDollSlideComplete");
}

@addMethod(gameuiInventoryGameController)
protected cb func OnPaperDollSlideComplete(anim: ref<inkAnimProxy>) {
    inkWidgetRef.SetVisible(this.m_paperDollWidget, false);
    this.GetChildWidgetByPath(n"wardrobe/wrapper/preview").SetVisible(true);
}

@wrapMethod(gameuiInventoryGameController)
protected cb func OnEquipmentClick(evt: ref<ItemDisplayClickEvent>) -> Bool {
    if IsDefined(this.GetChildWidgetByPath(n"wardrobe")) {
        return false;
    }

    if evt.actionName.IsAction(n"unequip_item") && Equals(evt.display.GetEquipmentArea(), gamedataEquipmentArea.Outfit) && this.m_outfitSystem.IsActive() {
        this.m_outfitSystem.Deactivate();
    } else {
        wrappedMethod(evt);
    }
}

@replaceMethod(gameuiInventoryGameController)
private final func RefreshEquippedWardrobeItems() {
    ArrayClear(this.m_wardrobeOutfitAreas);

    if this.m_outfitSystem.IsActive() {
        ArrayPush(this.m_wardrobeOutfitAreas, gamedataEquipmentArea.Head);
        ArrayPush(this.m_wardrobeOutfitAreas, gamedataEquipmentArea.Face);
        ArrayPush(this.m_wardrobeOutfitAreas, gamedataEquipmentArea.OuterChest);
        ArrayPush(this.m_wardrobeOutfitAreas, gamedataEquipmentArea.InnerChest);
        ArrayPush(this.m_wardrobeOutfitAreas, gamedataEquipmentArea.Legs);
        ArrayPush(this.m_wardrobeOutfitAreas, gamedataEquipmentArea.Feet);
    }
}
