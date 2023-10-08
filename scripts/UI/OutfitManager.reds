module EquipmentEx

class OutfitManagerController extends inkLogicController {
    protected let m_player: wref<PlayerPuppet>;
    protected let m_outfitSystem: wref<OutfitSystem>;

    protected let m_wardrobeScreen: wref<WardrobeScreenController>;
    protected let m_buttonHints: wref<ButtonHints>;

    protected let m_outfitList: ref<inkVirtualListController>;
    protected let m_outfitListDataView: ref<OutfitListDataView>;
    protected let m_outfitListDataSource: ref<ScriptableDataSource>;
    protected let m_outfitListTemplateClassifier: ref<inkVirtualItemTemplateClassifier>;
    protected let m_outfitListScroll: wref<inkScrollController>;

    protected let m_popupToken: ref<inkGameNotificationToken>;
    protected let m_popupOutfit: CName;

    protected let m_enabled: Bool;

    protected cb func OnInitialize() -> Bool {
        this.InitializeLayout();
        this.InitializeList();
    }

    public func Setup(outfitSystem: wref<OutfitSystem>, wardrobeScreen: wref<WardrobeScreenController>, buttonHints: wref<ButtonHints>) {
        this.m_outfitSystem = outfitSystem;
        this.m_wardrobeScreen = wardrobeScreen;
        this.m_buttonHints = buttonHints;

        this.PopulateList();
        this.SetEnabled(true);
    }

    public func SetEnabled(enabled: Bool) {
        this.m_enabled = enabled;

        let widget = this.GetRootWidget();
        widget.SetInteractive(this.m_enabled);
        widget.SetOpacity(this.m_enabled ? 1.0 : 0.6);
    }

    protected func InitializeLayout() {
        this.m_outfitListScroll = this.GetChildWidgetByPath(n"scroll_wrapper").GetControllerByType(n"inkScrollController") as inkScrollController;

        let scrollArea = this.GetChildWidgetByPath(n"scroll_wrapper/scroll_area");
        scrollArea.RegisterToCallback(n"OnScrollChanged", this, n"OnScrollChanged");

        let header = new inkVerticalPanel();
        header.SetName(n"header");
        header.SetChildMargin(new inkMargin(130.0, 0.0, 20.0, 0.0));
        header.Reparent(this.GetRootCompoundWidget());

        let title = new inkText();
        title = new inkText();
        title.SetName(n"title");
        title.SetText("LocKey#82878");
        title.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
        title.SetLetterCase(textLetterCase.UpperCase);
        title.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
        title.BindProperty(n"tintColor", n"MainColors.Red");
        title.BindProperty(n"fontStyle", n"MainColors.BodyFontWeight");
        title.BindProperty(n"fontSize", n"MainColors.ReadableFontSize");
        title.SetAnchor(inkEAnchor.TopLeft);
        title.SetMargin(new inkMargin(0.0, 0.0, 0.0, 4.0));
        title.Reparent(header);

        let divider = new inkRectangle();
        divider.SetName(n"divider");
        divider.SetMargin(new inkMargin(0.0, 0.0, 0.0, 15.0));
        divider.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
        divider.BindProperty(n"tintColor", n"MainColors.Red");
        divider.SetOpacity(0.3);
        divider.SetSize(800.0, 3.0);
        divider.Reparent(header);
    }

    protected func InitializeList() {
        this.m_outfitListDataSource = new ScriptableDataSource();
        this.m_outfitListDataView = new OutfitListDataView();
        this.m_outfitListDataView.SetSource(this.m_outfitListDataSource);
        this.m_outfitListTemplateClassifier = new OutfitListTemplateClassifier();
        
        this.m_outfitList = this.GetChildWidgetByPath(n"scroll_wrapper/scroll_area/outfit_list").GetController() as inkVirtualListController;
        this.m_outfitList.SetClassifier(this.m_outfitListTemplateClassifier);
        this.m_outfitList.SetSource(this.m_outfitListDataView);
    }

    protected func PopulateList() {
        let saveAction = new OutfitListEntryData();
        saveAction.Title = GetLocalizedTextByKey(n"UI-Wardrobe-SaveSet");
        saveAction.Color = n"MainColors.ActiveBlue";
        saveAction.Action = OutfitListAction.Save;
        saveAction.Postition = 1;

        let unequipAction = new OutfitListEntryData();
        unequipAction.Title = GetLocalizedTextByKey(n"UI-Wardrobe-NoOutfit");
        unequipAction.Action = OutfitListAction.Unequip;
        unequipAction.IsSelectable = true;
        unequipAction.IsSelected = !this.m_outfitSystem.IsActive();
        unequipAction.Postition = 2;

        this.m_outfitListDataSource.Clear();
        this.m_outfitListDataSource.AppendItem(saveAction);
        this.m_outfitListDataSource.AppendItem(unequipAction);

        for outfitName in this.m_outfitSystem.GetOutfits() {
            this.AppendToList(outfitName, false);
        }

        this.m_outfitListDataView.UpdateView();
    }

    protected func AppendToList(outfitName: CName, opt updateView: Bool) {
        let outfitEntry = new OutfitListEntryData();
        outfitEntry.Name = outfitName;
        outfitEntry.Title = NameToString(outfitName);
        outfitEntry.IsRemovable = true;
        outfitEntry.IsSelectable = true;
        outfitEntry.IsSelected = this.m_outfitSystem.IsEquipped(outfitEntry.Name);

        this.m_outfitListDataSource.AppendItem(outfitEntry);

        if updateView {
            this.m_outfitListDataView.UpdateView();
        }
    }

    protected func RemoveFromList(outfitName: CName, opt updateView: Bool) {
        for data in this.m_outfitListDataSource.GetArray() {
            let outfitEntry = data as OutfitListEntryData;
            if Equals(outfitEntry.Name, outfitName)  {
                this.m_outfitListDataSource.RemoveItem(outfitEntry);

                if updateView {
                    this.m_outfitListDataView.UpdateView();
                }

                break;
            }
        }
    }

    protected func RefreshList(opt updateState: Bool) {
        if updateState {
            for data in this.m_outfitListDataSource.GetArray() {
                let outfitEntry = data as OutfitListEntryData;
                if outfitEntry.IsSelectable {
                    outfitEntry.IsSelected = this.m_outfitSystem.IsEquipped(outfitEntry.Name);
                }
            }
        }

        this.QueueEvent(new OutfitListRefresh());
    }

    protected cb func OnOutfitListEntryClick(evt: ref<OutfitListEntryClick>) {
        if !this.m_enabled {
            return;
        }

        if evt.action.IsAction(n"click") && this.AccessOutfitSystem() {
            this.PlaySound(n"Button", n"OnPress");

            switch evt.entry.Action {
                case OutfitListAction.Equip:
                    this.m_outfitSystem.LoadOutfit(evt.entry.Name);
                    break;
                case OutfitListAction.Unequip:
                    this.m_outfitSystem.Deactivate();
                    break;
                case OutfitListAction.Save:
                    this.ShowSaveOutfitPopup();
                    break;
            }

            this.ShowButtonHints(evt.entry);
            return;
        }

        if evt.action.IsAction(n"drop_item") && Equals(evt.entry.Action, OutfitListAction.Equip) && this.AccessOutfitSystem() {
            this.ShowDeleteOutfitPopup(evt.entry.Name);
        }
    }

    protected cb func OnOutfitListEntryItemHoverOver(evt: ref<OutfitListEntryHoverOver>) {
        this.ShowButtonHints(evt.entry);
    }

    protected cb func OnOutfitListEntryItemHoverOut(evt: ref<OutfitListEntryHoverOut>) {
        this.ShowButtonHints(null);
    }

    protected cb func ShowSaveOutfitPopup() {
        this.m_popupToken = GenericMessageNotification.ShowInput(this.m_wardrobeScreen, GetLocalizedTextByKey(n"UI-Wardrobe-SaveSet"), GetLocalizedTextByKey(n"UI-Wardrobe-NotificationSaveSet"), GenericMessageNotificationType.ConfirmCancel);
        this.m_popupToken.RegisterListener(this, n"OnSaveOutfitPopupClosed");
    }

    protected cb func OnSaveOutfitPopupClosed(data: ref<inkGameNotificationData>) {
        let resultData = data as GenericMessageNotificationCloseData;

        if Equals(resultData.result, GenericMessageNotificationResult.Confirm) && NotEquals(resultData.input, "") {
            let outfitName = StringToName(resultData.input);

            if this.m_outfitSystem.HasOutfit(outfitName) {
                this.ShowReplaceOutfitPopup(outfitName);
                return;
            }
            
            this.PlaySound(n"Item", n"OnBuy");
            
            if this.m_outfitSystem.SaveOutfit(outfitName, true) {
                this.AppendToList(outfitName, true);
            }
        }

        this.ResetPopupState();
    }

    protected cb func ShowReplaceOutfitPopup(outfitName: CName) {
        this.m_popupOutfit = outfitName;
        this.m_popupToken = GenericMessageNotification.Show(this.m_wardrobeScreen, GetLocalizedTextByKey(n"UI-Wardrobe-SaveSet"), GetLocalizedTextByKey(n"UI-Wardrobe-NotificationReplaceSet"), GenericMessageNotificationType.ConfirmCancel);
        this.m_popupToken.RegisterListener(this, n"OnReplaceOutfitPopupClosed");
    }

    protected cb func OnReplaceOutfitPopupClosed(data: ref<inkGameNotificationData>) {
        let resultData = data as GenericMessageNotificationCloseData;

        if Equals(resultData.result, GenericMessageNotificationResult.Confirm) {
            this.PlaySound(n"Item", n"OnBuy");

            if this.m_outfitSystem.SaveOutfit(this.m_popupOutfit, true) {
                this.RefreshList(true);
            }
        }

        this.ResetPopupState();
    }

    protected cb func ShowDeleteOutfitPopup(outfitName: CName) {
        this.m_popupOutfit = outfitName;
        this.m_popupToken = GenericMessageNotification.Show(this.m_wardrobeScreen, GetLocalizedTextByKey(n"UI-Wardrobe-Deleteset"), GetLocalizedTextByKey(n"UI-Wardrobe-NotificationDeleteSet"), GenericMessageNotificationType.ConfirmCancel);
        this.m_popupToken.RegisterListener(this, n"OnDeleteOutfitPopupClosed");
    }

    protected cb func OnDeleteOutfitPopupClosed(data: ref<inkGameNotificationData>) {
        let resultData = data as GenericMessageNotificationCloseData;

        if Equals(resultData.result, GenericMessageNotificationResult.Confirm) {
            this.PlaySound(n"Item", n"OnDisassemble");

            if this.m_outfitSystem.DeleteOutfit(this.m_popupOutfit) {
                this.RemoveFromList(this.m_popupOutfit, true);
            }
        }

        this.ResetPopupState();
    }

    protected func ResetPopupState() {
        this.m_popupOutfit = n"";
        this.m_popupToken = null;
    }

    protected func ShowButtonHints(entry: wref<OutfitListEntryData>) {
        this.m_buttonHints.RemoveButtonHint(n"click");
        this.m_buttonHints.RemoveButtonHint(n"drop_item");
        
        if IsDefined(entry) {
            if entry.IsRemovable {
                this.m_buttonHints.AddButtonHint(n"drop_item", GetLocalizedTextByKey(n"UI-Wardrobe-Deleteset"));
            }

            if entry.IsSelectable && !entry.IsSelected {
                this.m_buttonHints.AddButtonHint(n"click", GetLocalizedTextByKey(n"Gameplay-Devices-Interactions-Equip"));
            }
        }
    }

    protected cb func OnOutfitUpdated(evt: ref<OutfitUpdated>) {
        this.RefreshList(true);
    }

    protected cb func OnOutfitPartUpdated(evt: ref<OutfitPartUpdated>) {
        this.RefreshList(true);
    }

    protected cb func OnOutfitListUpdated(evt: ref<OutfitListUpdated>) {
        this.PopulateList();
    }

    protected cb func OnScrollChanged(value: Vector2) {
        this.RefreshList();
    }

    protected func AccessOutfitSystem() -> Bool {
        if this.m_outfitSystem.IsBlocked() {
            let notification = new UIMenuNotificationEvent();
            notification.m_notificationType = UIMenuNotificationType.InventoryActionBlocked;           
            this.QueueEvent(notification);

            return false;
        }

        return true;
    }
}
