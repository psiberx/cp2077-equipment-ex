import EquipmentEx.OutfitSystem

@addField(gameuiInventoryGameController)
private let m_outfitSystem: wref<OutfitSystem>;

@addField(gameuiInventoryGameController)
private let m_wardrobeButton: wref<inkWidget>;

@addField(gameuiInventoryGameController)
private let m_outfitManagerReady: Bool;

@wrapMethod(gameuiInventoryGameController)
protected cb func OnInitialize() -> Bool {
    wrappedMethod();

    this.m_outfitSystem = OutfitSystem.GetInstance(this.GetPlayerControlledObject().GetGame());

    this.m_wardrobeButton.RegisterToCallback(n"OnClick", this, n"OnOutfitManagerClick");
}

@wrapMethod(gameuiInventoryGameController)
protected cb func OnUninitialize() -> Bool {
    wrappedMethod();

    this.m_wardrobeButton.UnregisterFromCallback(n"OnClick", this, n"OnOutfitManagerClick");
}

@replaceMethod(gameuiInventoryGameController)
private final func SetupSetButton() -> Void {
    let btnWrapper = this.GetChildWidgetByPath(n"default_wrapper/menuLinks") as inkCompoundWidget;
    let btnList = this.GetChildWidgetByPath(n"default_wrapper/menuLinks/btnsContainer") as inkCompoundWidget;

    // Spawn new button
    this.m_wardrobeButton = this.SpawnFromLocal(btnList, n"HyperlinkButton:EquipmentEx.WardrobeHubLink");

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
protected cb func OnOutfitManagerClick(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"click") {
        this.ShowOutfitManager();
    }
}

@wrapMethod(gameuiInventoryGameController)
protected cb func OnBack(userData: ref<IScriptable>) -> Bool {
    if this.m_outfitManagerReady && IsDefined(this.GetChildWidgetByPath(n"outfit_manager")) {
        return this.HideOutfitManager();
    } else {
        return wrappedMethod(userData);
    }
}

@addMethod(gameuiInventoryGameController)
protected func ShowOutfitManager() -> Bool {
    if IsDefined(this.GetChildWidgetByPath(n"outfit_manager")) {
        return false;
    }

    let outfitManager = this.SpawnFromExternal(this.GetRootCompoundWidget(), r"equipment_ex\\gui\\outfit_manager.inkwidget", n"Root:EquipmentEx.OutfitManagerController") as inkCompoundWidget;
    outfitManager.SetName(n"outfit_manager");

    let alphaAnim = new inkAnimTransparency();
    alphaAnim.SetStartTransparency(0.0);
    alphaAnim.SetEndTransparency(1.0);
    alphaAnim.SetType(inkanimInterpolationType.Linear);
    alphaAnim.SetMode(inkanimInterpolationMode.EasyOut);
    alphaAnim.SetDuration(0.8);
    
    let animDef = new inkAnimDef();
    animDef.AddInterpolator(alphaAnim);

    outfitManager.GetWidgetByPathName(n"wrapper/wrapper").PlayAnimation(animDef);
    // animProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnOutfitManagerShown");

    this.m_outfitManagerReady = true;

    if Equals(this.m_mode, InventoryModes.Item) {
        this.PlayShowHideItemChooserAnimation(false);
    } else {
        this.PlayLibraryAnimation(n"default_wrapper_outro");
    }

    this.GetChildWidgetByPath(n"outfit_manager/wrapper/preview").SetVisible(false);
    this.PlaySlidePaperdollAnimationToOutfit();

    this.m_buttonHintsController.Hide();

    return true;
}

// @addMethod(gameuiInventoryGameController)
// protected cb func OnOutfitManagerShown(anim: ref<inkAnimProxy>) {
//     LogDebug(s"OnOutfitManagerShown \(this.GetRootCompoundWidget().GetNumChildren())");
//     this.m_outfitManagerReady = true;
// }

@addMethod(gameuiInventoryGameController)
protected func HideOutfitManager() -> Bool {
    if !this.m_outfitManagerReady {
        return false;
    }

    let outfitManager = this.GetChildWidgetByPath(n"outfit_manager") as inkCompoundWidget;

    this.m_outfitManagerReady = false;
    
    let alphaAnim = new inkAnimTransparency();
    alphaAnim.SetStartTransparency(1.0);
    alphaAnim.SetEndTransparency(0.0);
    alphaAnim.SetType(inkanimInterpolationType.Linear);
    alphaAnim.SetMode(inkanimInterpolationMode.EasyOut);
    alphaAnim.SetDuration(0.3);
    
    let animDef = new inkAnimDef();
    animDef.AddInterpolator(alphaAnim);

    let animProxy = outfitManager.GetWidgetByPathName(n"wrapper/wrapper").PlayAnimation(animDef);
    animProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnOutfitManagerHidden");

    if Equals(this.m_mode, InventoryModes.Item) {
        this.SwapMode(InventoryModes.Default);
        this.m_itemModeLogicController.m_isShown = false;
    }

    this.PlayLibraryAnimation(n"default_wrapper_Intro");

    this.GetChildWidgetByPath(n"outfit_manager/wrapper/preview").SetVisible(false);
    inkWidgetRef.SetVisible(this.m_paperDollWidget, true);

    // this.ZoomCamera(EnumInt(InventoryPaperdollZoomArea.Default));
    this.PlaySlidePaperdollAnimation(PaperdollPositionAnimation.Center, false);

    this.m_buttonHintsController.Show();

    return true;
}

@addMethod(gameuiInventoryGameController)
protected cb func OnOutfitManagerHidden(anim: ref<inkAnimProxy>) {
    this.GetRootCompoundWidget().RemoveChildByName(n"outfit_manager");
}

@addMethod(gameuiInventoryGameController)
protected final func PlaySlidePaperdollAnimationToOutfit() {
    let outfitPreview = this.GetChildWidgetByPath(n"outfit_manager/wrapper/preview");
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
    this.GetChildWidgetByPath(n"outfit_manager/wrapper/preview").SetVisible(true);
}

@wrapMethod(gameuiInventoryGameController)
protected cb func OnEquipmentClick(evt: ref<ItemDisplayClickEvent>) -> Bool {
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
