module EquipmentEx
import EquipmentEx.Codeware.UI.*

public class OutfitManagerController extends inkPuppetPreviewGameController {
    private let m_player: wref<PlayerPuppet>;

    private let m_outfitSystem: wref<OutfitSystem>;
    private let m_inventoryHelper: wref<InventoryHelper>;

    private let m_inventoryBlackboard: wref<IBlackboard>;
    private let m_itemAddedCallback: ref<CallbackHandle>;
    private let m_itemRemovedCallback: ref<CallbackHandle>;
    private let m_uiScriptableSystem: wref<UIScriptableSystem>;
    private let m_tooltipManager: wref<gameuiTooltipsManager>;
    private let m_buttonHintsController: wref<ButtonHints>;

    private let m_filtersContainer: ref<inkUniformGrid>;
    private let m_filtersRadioGroup: ref<FilterRadioGroup>;
    private let m_filterManager: ref<ItemCategoryFliterManager>;
    private let m_currentFilter: ItemFilterCategory;

    private let m_inventoryManager: ref<InventoryDataManagerV2>;
    private let m_uiInventorySystem: wref<UIInventoryScriptableSystem>;
    
    private let m_itemsClassifier: ref<TemplateClassifier>;
    private let m_playerItemsDataView: ref<BackpackDataView>;
    private let m_playerItemsDataSource: ref<ScriptableDataSource>;
    private let m_itemsGrid: wref<inkVirtualGridController>;
    private let m_scrollController: wref<inkScrollController>;
    private let m_playerUIInventoryItems: array<ref<UIInventoryItem>>;
    
    private let m_lastItemHoverOverEvent: ref<ItemDisplayHoverOverEvent>;
    private let m_itemDisplayContext: ref<ItemDisplayContextData>;
    private let m_searchInput: ref<HubTextInput>;
    private let m_outfitsList: ref<inkVerticalPanel>;
    private let m_previewWrapper: wref<inkWidget>;

    private let m_leftMouseButtonPressed: Bool;

    private let m_confirmationRequestToken: ref<inkGameNotificationToken>;
    private let m_overwriteRequestToken: ref<inkGameNotificationToken>;
    private let m_lastHoveredOutfit: CName;
    private let m_outfitToCreate: CName;
    private let m_outfitToDelete: CName;

    protected cb func OnInitialize() -> Bool {
        super.OnInitialize();

        (this.GetChildWidgetByPath(n"wrapper/wrapper/vendorPanel/vendorHeader/vendoHeaderWrapper/vendorNameWrapper/value") as inkText).SetLocalizedTextString("LocKey#83290");

        let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
        let scrollable: ref<inkWidget> = root.GetWidget(n"wrapper/wrapper/vendorPanel/inventoryContainer");
        let grid: ref<inkWidget> = root.GetWidget(n"wrapper/wrapper/vendorPanel/inventoryContainer/stash_scroll_area_cache/scrollArea/vendor_virtualgrid");

        this.m_player = this.GetPlayerControlledObject() as PlayerPuppet;
        this.m_outfitSystem = OutfitSystem.GetInstance(this.m_player.GetGame());
        this.m_inventoryHelper = InventoryHelper.GetInstance(this.m_player.GetGame());

        this.m_itemsGrid = grid.GetController() as inkVirtualGridController;
        
        this.m_scrollController = scrollable.GetController() as inkScrollController;
        // this.m_scrollController.SetViewportHeight(scrollable.GetHeight());
        // this.m_scrollController.UpdateScrollPositionFromScrollArea();

        this.m_tooltipManager = this.GetRootWidget().GetControllerByType(n"gameuiTooltipsManager") as gameuiTooltipsManager;
        this.m_tooltipManager.Setup(ETooltipsStyle.Menus);

        this.m_inventoryBlackboard = GameInstance.GetBlackboardSystem(this.GetPlayerControlledObject().GetGame()).Get(GetAllBlackboardDefs().UI_Inventory);
        this.m_itemAddedCallback = this.m_inventoryBlackboard.RegisterListenerVariant(GetAllBlackboardDefs().UI_Inventory.itemAdded, this, n"OnInventoryItemsChanged");
        this.m_itemRemovedCallback = this.m_inventoryBlackboard.RegisterListenerVariant(GetAllBlackboardDefs().UI_Inventory.itemRemoved, this, n"OnInventoryItemsChanged");

        this.m_uiScriptableSystem = UIScriptableSystem.GetInstance(this.m_player.GetGame());

        this.m_buttonHintsController = this.SpawnFromExternal(this.GetRootCompoundWidget().GetWidget(n"button_hints"), r"base\\gameplay\\gui\\common\\buttonhints.inkwidget", n"Root").GetController() as ButtonHints;

        // Filters

        this.m_currentFilter = ItemFilterCategory.AllItems;

        this.m_filtersContainer = root.GetWidget(n"wrapper/wrapper/vendorPanel/vendorHeader/inkHorizontalPanelWidget2/filtersContainer") as inkUniformGrid;
        this.m_filtersContainer.SetWrappingWidgetCount(2u);

        this.m_filterManager = ItemCategoryFliterManager.Make();
        this.m_filterManager.Clear();
        this.m_filterManager.AddFilter(ItemFilterCategory.AllItems);
        this.m_filterManager.AddFilter(ItemFilterCategory.Clothes); // Equipped

        this.m_filtersRadioGroup = this.m_filtersContainer.GetController() as FilterRadioGroup;
        this.m_filtersRadioGroup.SetData(this.m_filterManager.GetIntFiltersList());
        this.m_filtersRadioGroup.RegisterToCallback(n"OnValueChanged", this, n"OnFilterChange");
        this.m_filtersRadioGroup.Toggle(EnumInt(ItemFilterCategory.AllItems));

        // Paper Doll

        this.m_previewWrapper = root.GetWidget(n"wrapper/preview");

        // Display Context

        this.m_itemDisplayContext = ItemDisplayContextData.Make(this.m_player, ItemDisplayContext.GearPanel);

        this.m_inventoryManager = new InventoryDataManagerV2();
        this.m_inventoryManager.Initialize(this.m_player);
        this.m_uiInventorySystem = UIInventoryScriptableSystem.GetInstance(this.m_player.GetGame());

        // Listeners
        
        this.m_previewWrapper.RegisterToCallback(n"OnPress", this, n"OnPreviewPress");
        this.RegisterToGlobalInputCallback(n"OnPostOnPress", this, n"OnGlobalPress");
        this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnGlobalRelease");
        this.RegisterToGlobalInputCallback(n"OnPostOnRelative", this, n"OnGlobalRelative");

        this.InitializeVirtualItemLists();
        this.InitializeOutfitsLayout();
        this.InitializeSearchField();

        this.PopulateOutfitsList();
        this.RefreshOutfitItemsList();
        this.UpdateButtonHints();
    }

    protected cb func OnUninitialize() -> Bool {
        super.OnUninitialize();

        this.PlaySound(n"GameMenu", n"OnClose");

        this.m_inventoryManager.ClearInventoryItemDataCache();
        this.m_inventoryManager.UnInitialize();

        this.m_uiInventorySystem.FlushFullscreenCache();

        this.m_playerItemsDataView.SetSource(null);
        this.m_itemsGrid.SetSource(null);
        this.m_itemsGrid.SetClassifier(null);
        this.m_itemsClassifier = null;
        this.m_playerItemsDataView = null;
        this.m_playerItemsDataSource = null;

        // this.m_searchInput.UnregisterFromCallback(n"OnInput", this, n"OnSearchFieldInput");

        this.m_previewWrapper.UnregisterFromCallback(n"OnPress", this, n"OnPreviewPress");
        this.UnregisterFromGlobalInputCallback(n"OnPostOnPress", this, n"OnGlobalPress");
        this.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"OnGlobalRelease");
        this.UnregisterFromGlobalInputCallback(n"OnPostOnRelative", this, n"OnGlobalRelative");

        this.m_inventoryBlackboard.UnregisterListenerVariant(GetAllBlackboardDefs().UI_Inventory.itemAdded, this.m_itemAddedCallback);
        this.m_inventoryBlackboard.UnregisterListenerVariant(GetAllBlackboardDefs().UI_Inventory.itemRemoved, this.m_itemRemovedCallback);
    }

    protected func UpdateButtonHints() {
        this.m_buttonHintsController.AddButtonHint(n"back", GetLocalizedText("Common-Access-Close"));

        // this.m_buttonHintsController.AddButtonHint(n"disassemle_item", "[" + GetLocalizedText("Gameplay-Devices-Interactions-Helpers-Hold") + "] Unequip outfit");

        // if this.m_outfitSystem.IsActive() {
        //     this.m_buttonHintsController.AddButtonHint(n"drop_item", "Unequip outfit");
        // } else {
        //     if this.m_outfitSystem.HasOutfit() {
        //         this.m_buttonHintsController.AddButtonHint(n"drop_item", "Reequip outfit");
        //     } else {
        //         this.m_buttonHintsController.RemoveButtonHint(n"drop_item");
        //     }
        // }

        // this.m_buttonHintsController.AddButtonHint(n"world_map_fake_rotate", GetLocalizedTextByKey(n"Gameplay-Player-ButtonHelper-Move"));
        // this.m_buttonHintsController.AddButtonHint(n"mouse_wheel", GetLocalizedTextByKey(n"Gameplay-Devices-DisplayNames-Scale"));
        // this.m_buttonHintsController.AddButtonHint(n"mouse_left", GetLocalizedTextByKey(n"UI-ResourceExports-Rotate"));
    }

    private final func ShowTooltipForUIInventoryItem(widget: wref<inkWidget>, inspectedItem: wref<UIInventoryItem>) -> Void {
        this.m_tooltipManager.HideTooltips();

        if IsDefined(inspectedItem) {
            let data = UIInventoryItemTooltipWrapper.Make(inspectedItem, this.m_itemDisplayContext);

            this.m_tooltipManager.ShowTooltipAtWidget(n"itemTooltip", widget, data, gameuiETooltipPlacement.RightTop);
        }
    }

    protected cb func OnFilterChange(controller: wref<inkRadioGroupController>, selectedIndex: Int32) -> Bool {
        this.m_currentFilter = this.m_filterManager.GetAt(selectedIndex);
        this.PopulateItemsList();
        this.m_scrollController.SetScrollPosition(0.0);
    }

    protected cb func OnInventoryClick(evt: ref<ItemDisplayClickEvent>) -> Bool {
        if evt.actionName.IsAction(n"equip_item") {
            if !evt.uiInventoryItem.IsEquipped() {
                if this.m_outfitSystem.EquipItem(evt.uiInventoryItem.ID) {
                    this.QueueEvent(new ItemDisplayRefreshEvent());
                    this.RefreshOutfitItemsList();
                }
            }
        } else {
            if evt.actionName.IsAction(n"unequip_item") {
                if evt.uiInventoryItem.IsEquipped() {
                    if this.m_outfitSystem.UnequipItem(evt.uiInventoryItem.ID) {
                        this.QueueEvent(new ItemDisplayRefreshEvent());
                        this.RefreshOutfitItemsList();
                    }
                }
            }
        }
    }

    protected cb func OnInventoryItemHoverOver(evt: ref<ItemDisplayHoverOverEvent>) -> Bool {
        if evt.uiInventoryItem.IsEquipped() {
            this.m_buttonHintsController.AddButtonHint(n"unequip_item", GetLocalizedText("UI-UserActions-Unequip"));
        } else {
            this.m_buttonHintsController.AddButtonHint(n"equip_item", GetLocalizedText("UI-UserActions-Equip"));
        }

        this.ShowTooltipForUIInventoryItem(evt.widget, evt.uiInventoryItem);
    }

    protected cb func OnInventoryItemHoverOut(evt: ref<ItemDisplayHoverOutEvent>) {
        this.m_tooltipManager.HideTooltips();
        this.m_buttonHintsController.RemoveButtonHint(n"equip_item");
        this.m_buttonHintsController.RemoveButtonHint(n"unequip_item");
        this.m_lastItemHoverOverEvent = null;
    }

    protected cb func OnPreviewPress(evt: ref<inkPointerEvent>) -> Bool {
        if evt.IsAction(n"mouse_left") {
            this.m_leftMouseButtonPressed = true;

            let cursorEvent = new inkMenuLayer_SetCursorVisibility();
            cursorEvent.Init(false);
            this.QueueEvent(cursorEvent);
        }
    }

    protected cb func OnGlobalPress(evt: ref<inkPointerEvent>) -> Bool {
        if evt.IsAction(n"mouse_left") {
            if !IsDefined(evt.GetTarget()) || !evt.GetTarget().CanSupportFocus() {
                this.RequestSetFocus(null);
            }
        }
    }

    protected cb func OnGlobalRelease(evt: ref<inkPointerEvent>) -> Bool {
        if this.m_leftMouseButtonPressed && evt.IsAction(n"mouse_left") {
            this.m_leftMouseButtonPressed = false;

            let cursorEvent = new inkMenuLayer_SetCursorVisibility();
            cursorEvent.Init(true, new Vector2(0.50, 0.50));
            this.QueueEvent(cursorEvent);

            evt.Consume();
        };

        if evt.IsAction(n"drop_item") && NotEquals(this.m_lastHoveredOutfit, n"") {
            this.m_outfitToDelete = this.m_lastHoveredOutfit;
            this.m_confirmationRequestToken = GenericMessageNotification.Show(this, GetLocalizedText("UI-Wardrobe-LabelWarning"), GetLocalizedText("UI-Wardrobe-NotificationDeleteSet"), GenericMessageNotificationType.ConfirmCancel);
            this.m_confirmationRequestToken.RegisterListener(this, n"OnDeleteOutfitConfirmation");
            evt.Consume();
        }
    }

    protected cb func OnGlobalRelative(evt: ref<inkPointerEvent>) -> Bool {
        if this.m_leftMouseButtonPressed && evt.IsAction(n"mouse_x") {
            let previewPuppet = this.m_inventoryHelper.GetPreview();

            let ratio: Float;
            let offset: Float = evt.GetAxisData();

            if offset > 0.00 {
                ratio = ClampF(offset / previewPuppet.m_maxMousePointerOffset, 0.50, 1.00);
            } else {
                ratio = ClampF(offset / previewPuppet.m_maxMousePointerOffset, -1.00, -0.50);
            }

            previewPuppet.Rotate(ratio * previewPuppet.m_mouseRotationSpeed);
        }
    }

    private func GetAnimFeature(out animFeature: ref<AnimFeature_Paperdoll>) -> Void {
        animFeature = new AnimFeature_Paperdoll();
        animFeature.inventoryScreen = true;
    }

    protected cb func OnSearchFieldInput(widget: wref<inkWidget>) -> Bool {
        this.PopulateItemsList();
        this.m_scrollController.SetScrollPosition(0.0);
    }

    protected cb func OnCreateButtonClick(evt: ref<inkPointerEvent>) -> Bool {
        if evt.IsAction(n"activate") && this.m_outfitSystem.IsActive() {
            this.PlaySound(n"Button", n"OnPress");
            this.m_confirmationRequestToken = GenericMessageNotification.ShowInput(this, "Save outfit", "Enter outfit name:", GenericMessageNotificationType.ConfirmCancel);
            this.m_confirmationRequestToken.RegisterListener(this, n"OnCreateOutfitConfirmation");
        };
    }

    protected cb func OnCreateOutfitConfirmation(data: ref<inkGameNotificationData>) -> Bool {
        let resultData = data as GenericMessageNotificationCloseData;
        if Equals(resultData.result, GenericMessageNotificationResult.Confirm) && NotEquals(resultData.input, "") {
            let newOutfit = StringToName(resultData.input);
            if this.m_outfitSystem.HasOutfit(newOutfit) {
                this.m_overwriteRequestToken = GenericMessageNotification.Show(this, GetLocalizedText("UI-Wardrobe-LabelWarning"), "Outfit with this name already exists, do you want to overwrite it?", GenericMessageNotificationType.ConfirmCancel);
                this.m_overwriteRequestToken.RegisterListener(this, n"OnOverwriteOutfitConfirmation");
                this.m_outfitToCreate = newOutfit;
            } else {
                this.CreateOutfit(newOutfit, true);
            };
        };
        this.m_confirmationRequestToken = null;
    }

    protected cb func OnOverwriteOutfitConfirmation(data: ref<inkGameNotificationData>) -> Bool {
        let resultData = data as GenericMessageNotificationCloseData;
        if Equals(resultData.result, GenericMessageNotificationResult.Confirm) {
            this.CreateOutfit(this.m_outfitToCreate);
        };
        this.m_outfitToCreate = n"";
        this.m_overwriteRequestToken = null;
    }

    protected cb func OnOutfitItemClick(evt: ref<inkPointerEvent>) -> Bool {
        if evt.IsAction(n"activate") {
            this.PlaySound(n"Button", n"OnPress");
            this.m_outfitSystem.LoadOutfit(evt.GetTarget().GetName());
            this.PopulateItemsList();
            this.RefreshOutfitItemsList();
        };
    }

    protected cb func OnNoOutfitButtonClick(evt: ref<inkPointerEvent>) -> Bool {
        if evt.IsAction(n"activate") {
            this.PlaySound(n"Button", n"OnPress");
            this.m_outfitSystem.Deactivate();
            this.PopulateItemsList();
            this.RefreshOutfitItemsList();
        };
    }

    protected cb func OnHoverOverOutfitItem(evt: ref<inkPointerEvent>) -> Bool {
        let item: ref<inkWidget> = evt.GetTarget();
        let controller: ref<OutfitListItemController> = item.GetController() as OutfitListItemController;
        if IsDefined(controller) {
            this.m_lastHoveredOutfit = item.GetName();
            this.m_buttonHintsController.AddButtonHint(n"drop_item", GetLocalizedTextByKey(n"UI-Wardrobe-Deleteset"));
            if !controller.IsChecked() {
                this.m_buttonHintsController.AddButtonHint(n"activate", GetLocalizedTextByKey(n"Gameplay-Devices-Interactions-Equip"));
            };
        };
    }

    protected cb func OnHoverOutOutfitItem(evt: ref<inkPointerEvent>) -> Bool {
        this.m_buttonHintsController.RemoveButtonHint(n"activate");
        this.m_buttonHintsController.RemoveButtonHint(n"drop_item");
        this.m_lastHoveredOutfit = n"";
    }

    protected cb func OnDeleteOutfitConfirmation(data: ref<inkGameNotificationData>) -> Bool {
      let resultData: ref<GenericMessageNotificationCloseData> = data as GenericMessageNotificationCloseData;
      if Equals(resultData.result, GenericMessageNotificationResult.Confirm) {
          this.PlaySound(n"Item", n"OnDisassemble");
          this.DeleteOutfit(this.m_outfitToDelete);
      };
      this.m_outfitToDelete = n"";
      this.m_confirmationRequestToken = null;
    }

    protected cb func OnInventoryItemsChanged(value: Variant) -> Bool {
        this.PopulateItemsList();
    }

    private func InitializeVirtualItemLists() -> Void {
        this.m_itemsClassifier = new TemplateClassifier();
        
        this.m_playerItemsDataSource = new ScriptableDataSource();
        
        this.m_playerItemsDataView = new BackpackDataView(); // VendorDataView
        this.m_playerItemsDataView.BindUIScriptableSystem(this.m_uiScriptableSystem);
        this.m_playerItemsDataView.SetFilterType(ItemFilterCategory.AllItems);
        this.m_playerItemsDataView.SetSortMode(ItemSortMode.Default);
        this.m_playerItemsDataView.SetSource(this.m_playerItemsDataSource);

        this.m_itemsGrid.SetClassifier(this.m_itemsClassifier);
        this.m_itemsGrid.SetSource(this.m_playerItemsDataView);

        this.PopulateItemsList();
    }

    private func PopulateItemsList() -> Void {
        let allItems = this.m_inventoryManager.GetPlayerInventoryItems();
        this.m_inventoryHelper.GetStashItems(allItems);
        let finalItems = this.BuildCategorizedClothingList(allItems);
        this.m_playerItemsDataSource.Reset(finalItems);
    }

    private func BuildCategorizedClothingList(allItems: array<wref<gameItemData>>) -> array<ref<IScriptable>> {
        let searchQuery: String = StrLower(this.m_searchInput.GetText());

        let result: array<ref<IScriptable>>;
        let slotItems: array<wref<gameItemData>>;
        let header: ref<VendorUIInventoryItemData>;
        let itemData: ref<VendorUIInventoryItemData>;
        let itemsCount: Int32;

        for slotID in this.m_outfitSystem.GetOutfitSlots() {
            ArrayClear(slotItems);

            for item in allItems {
                if this.ShouldDisplayInCategory(item, slotID, this.m_currentFilter, searchQuery) {
                    ArrayPush(slotItems, item);
                }
            }
            
            itemsCount = ArraySize(slotItems);

            if itemsCount > 0 {
                header = new VendorUIInventoryItemData();
                header.Item = new UIInventoryItem();
                header.ItemData.SlotID = slotID;
                header.ItemData.CategoryName = this.m_outfitSystem.GetSlotName(slotID);
                
                ArrayPush(result, header);

                for item in slotItems {
                    itemData = new VendorUIInventoryItemData();
                    itemData.Item = UIInventoryItem.Make(this.m_player, item, this.m_uiInventorySystem.GetInventoryItemsManager());
                    itemData.DisplayContextData = this.m_itemDisplayContext;

                    ArrayPush(result, itemData);

                    if itemData.Item.IsEquipped() {
                        header.ItemData.ID = item.GetID();
                        header.ItemData.Name = this.m_outfitSystem.GetItemName(item.GetID());
                    }
                }
            }
        }

        return result;
    }

    private func ShouldDisplayInCategory(item: ref<gameItemData>, slotID: TweakDBID, filterCategory: ItemFilterCategory, searchQuery: String) -> Bool {
        if !this.m_outfitSystem.IsEquippable(item.GetID(), slotID) {
            return false;
        }

        if Equals(filterCategory, ItemFilterCategory.Clothes) {
            if !this.m_uiInventorySystem.GetInventoryItemsManager().IsItemEquipped(item.GetID()) {
                return false;
            }
        }

        if NotEquals(searchQuery, "") {
            let itemName = StrLower(this.m_outfitSystem.GetItemName(item.GetID()));
            if !StrContains(itemName, searchQuery) {
                return false;
            }
        }

        return true;
    }

    private func InitializeOutfitsLayout() -> Void {
        let outerContainer: ref<inkCanvas> = new inkCanvas();
        outerContainer.SetName(n"OuterContainer");
        outerContainer.SetMargin(new inkMargin(100.0, 0.0, 0.0, 0.0));
        outerContainer.Reparent(this.GetChildWidgetByPath(n"wrapper/wrapper") as inkCompoundWidget);

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

    private func InitializeSearchField() -> Void {
        let filterWrapper = this.GetRootCompoundWidget().GetWidget(n"wrapper/wrapper/vendorPanel/vendorHeader/inkHorizontalPanelWidget2") as inkCompoundWidget;
        let filterSpacing = this.m_filtersContainer.GetChildMargin();

        let searchWrapper = new inkCanvas();
        searchWrapper.SetMargin(new inkMargin(filterSpacing.right, 0, 0, filterSpacing.bottom));
        searchWrapper.Reparent(filterWrapper);

        this.m_searchInput = HubTextInput.Create();
        this.m_searchInput.SetName(n"SearchTextInput");
        this.m_searchInput.SetDefaultText("Search by name");
        this.m_searchInput.SetLetterCase(textLetterCase.UpperCase);
        this.m_searchInput.SetMaxLength(24);
        this.m_searchInput.RegisterToCallback(n"OnInput", this, n"OnSearchFieldInput");
        this.m_searchInput.Reparent(searchWrapper);
    }

    private func PopulateOutfitsList() -> Void {
        this.m_outfitsList.RemoveAllChildren();

        let buttonCreate = this.SpawnFromExternal(this.m_outfitsList, r"equipment_ex\\gui\\outfit_list_item.inkwidget", n"FiltersListItem:EquipmentEx.OutfitListItemController");
        buttonCreate.SetName(n"ButtonCreate");
        buttonCreate.RegisterToCallback(n"OnPress", this, n"OnCreateButtonClick");
        let buttonCreateController = buttonCreate.GetController() as OutfitListItemController;
        buttonCreateController.SetCustomAppearance("Save outfit", n"MainColors.ActiveBlue");
        buttonCreateController.HideCheckboxFrame();
        buttonCreateController.SetEquipped(false);
        
        let buttonNoOutfit = this.SpawnFromExternal(this.m_outfitsList, r"equipment_ex\\gui\\outfit_list_item.inkwidget", n"FiltersListItem:EquipmentEx.OutfitListItemController");
        buttonNoOutfit.SetName(n"ButtonNoOutfit");
        buttonNoOutfit.RegisterToCallback(n"OnPress", this, n"OnNoOutfitButtonClick");
        let buttonNoOutfitController = buttonNoOutfit.GetController() as OutfitListItemController;
        buttonNoOutfitController.SetCustomAppearance("No outfit", n"MainColors.Red");
        buttonNoOutfitController.SetEquipped(!this.m_outfitSystem.IsActive());

        for name in this.m_outfitSystem.GetOutfits() {
            this.SpawnOutfitListItem(name);
        };
        
        let controller: ref<OutfitListItemController>;
        let delay: Float = 30.0;
        let numChildren: Int32 = this.m_outfitsList.GetNumChildren();
        let i: Int32 = 0;
        while i < numChildren {
            delay = Cast<Float>(i) / 20.0;
            controller = this.m_outfitsList.GetWidgetByIndex(i).GetController() as OutfitListItemController;
            if IsDefined(controller) {
                controller.PlayIntroAnimation(delay);
            };
          i += 1;
        };
    }

    private func CreateOutfit(name: CName, opt createListItem: Bool) -> Void {
        if createListItem {
            this.SpawnOutfitListItem(name);
        };
        this.PlaySound(n"Item", n"OnBuy");
        this.m_outfitSystem.SaveOutfit(name, true);
        this.RefreshOutfitItemsList();
    }

    private func DeleteOutfit(name: CName) -> Void {
        this.m_outfitsList.RemoveChildByName(name);
        this.m_outfitSystem.DeleteOutfit(name);
        this.RefreshOutfitItemsList();
    }

    private func SpawnOutfitListItem(name: CName) -> Void {
        let item = this.SpawnFromExternal(this.m_outfitsList, r"equipment_ex\\gui\\outfit_list_item.inkwidget", n"FiltersListItem:EquipmentEx.OutfitListItemController") as inkCompoundWidget;
        item.SetName(name);
        item.RegisterToCallback(n"OnPress", this, n"OnOutfitItemClick");
        item.RegisterToCallback(n"OnHoverOver", this, n"OnHoverOverOutfitItem");
        item.RegisterToCallback(n"OnHoverOut", this, n"OnHoverOutOutfitItem");

        let itemController = item.GetController() as OutfitListItemController;
        itemController.SetText(NameToString(name));
        itemController.SetEquipped(this.m_outfitSystem.IsEquipped(name));
    }

    private func RefreshOutfitItemsList() -> Void {
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
                    };
                };
            };
            i += 1;
        };
    }
}

public class TemplateClassifier extends inkVirtualItemTemplateClassifier {
    public func ClassifyItem(data: Variant) -> Uint32 {
        let data = FromVariant<ref<IScriptable>>(data) as WrappedInventoryItemData;

        if IsDefined(data) && TDBID.IsValid(data.ItemData.SlotID) && NotEquals(data.ItemData.CategoryName, "") {
            return 1u;
        }

        return 0u;
    }
}
