module EquipmentEx

public class OutfitManagerController extends inkLogicController {
    protected let m_player: wref<PlayerPuppet>;
    protected let m_outfitSystem: wref<OutfitSystem>;

    protected let m_wardrobeScreen: wref<WardrobeScreenController>;
    protected let m_buttonHints: wref<ButtonHints>;

    protected let m_outfitsList: ref<inkVerticalPanel>;

    protected let m_confirmationRequestToken: ref<inkGameNotificationToken>;
    protected let m_overwriteRequestToken: ref<inkGameNotificationToken>;
    protected let m_lastHoveredOutfit: CName;
    protected let m_outfitToCreate: CName;
    protected let m_outfitToDelete: CName;

    protected cb func OnInitialize() -> Bool {
        this.InitializeLayout();
    }

    public func Setup(outfitSystem: wref<OutfitSystem>, wardrobeScreen: wref<WardrobeScreenController>, buttonHints: wref<ButtonHints>) {
        this.m_outfitSystem = outfitSystem;
        this.m_wardrobeScreen = wardrobeScreen;
        this.m_buttonHints = buttonHints;

        this.PopulateOutfitList(true);
        this.RefreshOutfitList();
    }

    protected func InitializeLayout() {
        let outerContainer: ref<inkCanvas> = new inkCanvas();
        outerContainer.SetName(n"OuterContainer");
        outerContainer.SetMargin(new inkMargin(100.0, 0.0, 0.0, 0.0));
        outerContainer.Reparent(this.GetRootCompoundWidget());

        let verticalContainer: ref<inkVerticalPanel> = new inkVerticalPanel();
        verticalContainer.SetName(n"Vertical");
        verticalContainer.SetChildMargin(new inkMargin(0.0, 0.0, 20.0, 0.0));
        verticalContainer.Reparent(outerContainer);

        let inputLabel: ref<inkText> = new inkText();
        inputLabel = new inkText();
        inputLabel.SetName(n"InputLabel");
        inputLabel.SetText("LocKey#82878");
        inputLabel.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
        inputLabel.SetHAlign(inkEHorizontalAlign.Left);
        inputLabel.SetVAlign(inkEVerticalAlign.Top);
        inputLabel.SetAnchor(inkEAnchor.TopLeft);
        inputLabel.SetAnchorPoint(1.0, 1.0);
        inputLabel.SetLetterCase(textLetterCase.UpperCase);
        inputLabel.SetMargin(new inkMargin(28.0, 0.0, 0.0, 4.0));
        inputLabel.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
        inputLabel.BindProperty(n"tintColor", n"MainColors.Red");
        inputLabel.BindProperty(n"fontStyle", n"MainColors.BodyFontWeight");
        inputLabel.BindProperty(n"fontSize", n"MainColors.ReadableFontSize");
        inputLabel.Reparent(verticalContainer);

        let divider: ref<inkRectangle> = new inkRectangle();
        divider.SetName(n"divider");
        divider.SetHAlign(inkEHorizontalAlign.Left);
        divider.SetVAlign(inkEVerticalAlign.Top);
        divider.SetAnchor(inkEAnchor.TopLeft);
        divider.SetSize(840.0, 3.0);
        divider.SetMargin(new inkMargin(28.0, 0.0, 0.0, 15.0));
        divider.SetOpacity(0.3);
        divider.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
        divider.BindProperty(n"tintColor", n"MainColors.Red");
        divider.Reparent(verticalContainer);

        this.m_outfitsList = new inkVerticalPanel();
        this.m_outfitsList.SetName(n"OutfitsList");
        this.m_outfitsList.SetHAlign(inkEHorizontalAlign.Left);
        this.m_outfitsList.SetVAlign(inkEVerticalAlign.Fill);
        this.m_outfitsList.SetMargin(new inkMargin(0.0, 20.0, 0.0, 0.0));
        this.m_outfitsList.SetChildMargin(new inkMargin(0.0, 10.0, 0.0, 0.0));
        this.m_outfitsList.Reparent(verticalContainer);
    }

    protected func PopulateOutfitList(opt animate: Bool) {
        this.m_outfitsList.RemoveAllChildren();

        let buttonCreate = this.SpawnFromLocal(this.m_outfitsList, n"OutfitListItem:EquipmentEx.OutfitListItemController");
        buttonCreate.SetName(n"ButtonCreate");
        buttonCreate.RegisterToCallback(n"OnPress", this, n"OnCreateButtonClick");
        let buttonCreateController = buttonCreate.GetController() as OutfitListItemController;
        buttonCreateController.SetCustomAppearance("Save outfit", n"MainColors.ActiveBlue");
        buttonCreateController.HideCheckboxFrame();
        buttonCreateController.SetEquipped(false);
        
        let buttonNoOutfit = this.SpawnFromLocal(this.m_outfitsList, n"OutfitListItem:EquipmentEx.OutfitListItemController");
        buttonNoOutfit.SetName(n"ButtonNoOutfit");
        buttonNoOutfit.RegisterToCallback(n"OnPress", this, n"OnNoOutfitButtonClick");
        let buttonNoOutfitController = buttonNoOutfit.GetController() as OutfitListItemController;
        buttonNoOutfitController.SetCustomAppearance("No outfit", n"MainColors.Red");
        buttonNoOutfitController.SetEquipped(!this.m_outfitSystem.IsActive());

        for name in this.m_outfitSystem.GetOutfits() {
            this.SpawnOutfitListItem(name);
        }

        if animate {
            let controller: ref<OutfitListItemController>;
            let delay: Float = 30.0;
            let numChildren: Int32 = this.m_outfitsList.GetNumChildren();
            let i: Int32 = 0;
            while i < numChildren {
                delay = Cast<Float>(i) / 20.0;
                controller = this.m_outfitsList.GetWidgetByIndex(i).GetController() as OutfitListItemController;
                if IsDefined(controller) {
                    controller.PlayIntroAnimation(delay);
                }
                i += 1;
            }
        }
    }

    protected func SpawnOutfitListItem(name: CName) {
        let item = this.SpawnFromLocal(this.m_outfitsList, n"OutfitListItem:EquipmentEx.OutfitListItemController") as inkCompoundWidget;
        item.SetName(name);
        item.RegisterToCallback(n"OnPress", this, n"OnOutfitItemClick");
        item.RegisterToCallback(n"OnHoverOver", this, n"OnHoverOverOutfitItem");
        item.RegisterToCallback(n"OnHoverOut", this, n"OnHoverOutOutfitItem");

        let itemController = item.GetController() as OutfitListItemController;
        itemController.SetText(NameToString(name));
        itemController.SetEquipped(this.m_outfitSystem.IsEquipped(name));
    }

    protected func RefreshOutfitList() {
        let numChildren: Int32 = this.m_outfitsList.GetNumChildren();
        if numChildren < 2 { return ; }

        let child: ref<inkWidget>;
        let childName: CName;
        let controller: ref<OutfitListItemController>;
        let i: Int32 = 0;
        while i < numChildren {
            child = this.m_outfitsList.GetWidgetByIndex(i);
            childName = child.GetName();
            controller = child.GetController() as OutfitListItemController;
            if IsDefined(controller) {
                if Equals(childName, n"ButtonNoOutfit") {
                    controller.SetEquipped(!this.m_outfitSystem.IsActive());
                } else {
                    if Equals(childName, n"ButtonCreate") {
                        controller.SetEnabled(this.m_outfitSystem.IsActive());
                    } else {
                        controller.SetEquipped(this.m_outfitSystem.IsEquipped(childName));
                    }
                }
            }
            i += 1;
        }
    }

    protected cb func OnCreateButtonClick(evt: ref<inkPointerEvent>) -> Bool {
        if evt.IsAction(n"activate") && this.m_outfitSystem.IsActive() {
            this.PlaySound(n"Button", n"OnPress");
            this.m_confirmationRequestToken = GenericMessageNotification.ShowInput(this.m_wardrobeScreen, "Save outfit", "Enter outfit name:", GenericMessageNotificationType.ConfirmCancel);
            this.m_confirmationRequestToken.RegisterListener(this, n"OnCreateOutfitConfirmation");
        }
    }

    protected cb func OnCreateOutfitConfirmation(data: ref<inkGameNotificationData>) -> Bool {
        let resultData = data as GenericMessageNotificationCloseData;
        if Equals(resultData.result, GenericMessageNotificationResult.Confirm) && NotEquals(resultData.input, "") {
            let newOutfit = StringToName(resultData.input);
            if this.m_outfitSystem.HasOutfit(newOutfit) {
                this.m_overwriteRequestToken = GenericMessageNotification.Show(this.m_wardrobeScreen, GetLocalizedText("UI-Wardrobe-LabelWarning"), "Outfit with this name already exists, do you want to overwrite it?", GenericMessageNotificationType.ConfirmCancel);
                this.m_overwriteRequestToken.RegisterListener(this, n"OnOverwriteOutfitConfirmation");
                this.m_outfitToCreate = newOutfit;
            } else {
                this.CreateOutfit(newOutfit, true);
            }
        }
        this.m_confirmationRequestToken = null;
    }

    protected cb func OnOverwriteOutfitConfirmation(data: ref<inkGameNotificationData>) -> Bool {
        let resultData = data as GenericMessageNotificationCloseData;
        if Equals(resultData.result, GenericMessageNotificationResult.Confirm) {
            this.CreateOutfit(this.m_outfitToCreate);
        }
        this.m_outfitToCreate = n"";
        this.m_overwriteRequestToken = null;
    }

    protected cb func OnOutfitItemClick(evt: ref<inkPointerEvent>) -> Bool {
        if evt.IsAction(n"activate") {
            this.PlaySound(n"Button", n"OnPress");
            this.m_outfitSystem.LoadOutfit(evt.GetTarget().GetName());
        }

        if evt.IsAction(n"drop_item") && NotEquals(this.m_lastHoveredOutfit, n"") {
            this.m_outfitToDelete = this.m_lastHoveredOutfit;
            this.m_confirmationRequestToken = GenericMessageNotification.Show(this.m_wardrobeScreen, GetLocalizedText("UI-Wardrobe-LabelWarning"), GetLocalizedText("UI-Wardrobe-NotificationDeleteSet"), GenericMessageNotificationType.ConfirmCancel);
            this.m_confirmationRequestToken.RegisterListener(this, n"OnDeleteOutfitConfirmation");
            evt.Consume();
        }
    }

    protected cb func OnNoOutfitButtonClick(evt: ref<inkPointerEvent>) -> Bool {
        if evt.IsAction(n"activate") {
            this.PlaySound(n"Button", n"OnPress");
            this.m_outfitSystem.Deactivate();
        }
    }

    protected cb func OnHoverOverOutfitItem(evt: ref<inkPointerEvent>) -> Bool {
        let item: ref<inkWidget> = evt.GetTarget();
        let controller: ref<OutfitListItemController> = item.GetController() as OutfitListItemController;
        if IsDefined(controller) {
            this.m_lastHoveredOutfit = item.GetName();
            this.m_buttonHints.AddButtonHint(n"drop_item", GetLocalizedTextByKey(n"UI-Wardrobe-Deleteset"));
            if !controller.IsChecked() {
                this.m_buttonHints.AddButtonHint(n"activate", GetLocalizedTextByKey(n"Gameplay-Devices-Interactions-Equip"));
            }
        }
    }

    protected cb func OnHoverOutOutfitItem(evt: ref<inkPointerEvent>) -> Bool {
        this.m_buttonHints.RemoveButtonHint(n"activate");
        this.m_buttonHints.RemoveButtonHint(n"drop_item");
        this.m_lastHoveredOutfit = n"";
    }

    protected cb func OnDeleteOutfitConfirmation(data: ref<inkGameNotificationData>) -> Bool {
      let resultData: ref<GenericMessageNotificationCloseData> = data as GenericMessageNotificationCloseData;
      if Equals(resultData.result, GenericMessageNotificationResult.Confirm) {
          this.PlaySound(n"Item", n"OnDisassemble");
          this.DeleteOutfit(this.m_outfitToDelete);
      }
      this.m_outfitToDelete = n"";
      this.m_confirmationRequestToken = null;
    }

    protected func CreateOutfit(name: CName, opt createListItem: Bool) {
        if createListItem {
            this.SpawnOutfitListItem(name);
        }
        this.PlaySound(n"Item", n"OnBuy");
        this.m_outfitSystem.SaveOutfit(name, true);
        this.PopulateOutfitList();
    }

    protected func DeleteOutfit(name: CName) {
        this.m_outfitsList.RemoveChildByName(name);
        this.m_outfitSystem.DeleteOutfit(name);
        this.RefreshOutfitList();
    }

    protected cb func OnOutfitUpdated(evt: ref<OutfitUpdated>) {
        this.RefreshOutfitList();
    }

    protected cb func OnOutfitPartUpdated(evt: ref<OutfitPartUpdated>) {
        this.RefreshOutfitList();
    }
}
