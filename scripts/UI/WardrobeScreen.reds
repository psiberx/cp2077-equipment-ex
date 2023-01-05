module EquipmentEx
import EquipmentEx.Codeware.UI.*

public class WardrobeScreenController extends inkPuppetPreviewGameController {
    protected let m_player: wref<PlayerPuppet>;
    protected let m_outfitSystem: wref<OutfitSystem>;
    protected let m_inventoryHelper: wref<InventoryHelper>;
    protected let m_paperdollHelper: wref<PaperdollHelper>;
    protected let m_delaySystem: wref<DelaySystem>;
    protected let m_uiScriptableSystem: wref<UIScriptableSystem>;
    protected let m_uiInventorySystem: wref<UIInventoryScriptableSystem>;

    protected let m_outfitManager: wref<OutfitManagerController>;
    protected let m_buttonHints: wref<ButtonHints>;
    protected let m_tooltipManager: wref<gameuiTooltipsManager>;

    protected let m_filtersContainer: ref<inkUniformGrid>;
    protected let m_filtersRadioGroup: ref<FilterRadioGroup>;
    protected let m_filterManager: ref<ItemCategoryFliterManager>;
    protected let m_itemDropQueue: array<ItemModParams>;

    protected let m_inventoryScrollArea: wref<inkCompoundWidget>;
    protected let m_inventoryScrollController: wref<inkScrollController>;
    protected let m_scrollResetPending: Bool;

    protected let m_inventoryGridArea: wref<inkWidget>;
    protected let m_inventoryGridController: wref<inkVirtualGridController>;
    protected let m_inventoryGridDataView: ref<InventoryGridDataView>;
    protected let m_inventoryGridDataSource: ref<ScriptableDataSource>;
    protected let m_inventoryGridTemplateClassifier: ref<inkVirtualItemTemplateClassifier>;
    protected let m_inventoryGridUpdateDelay: Float = 0.5;
    protected let m_inventoryGridUpdateDelayID: DelayID;

    protected let m_searchInput: ref<HubTextInput>;

    protected let m_inventoryBlackboard: wref<IBlackboard>;
    protected let m_itemAddedCallback: ref<CallbackHandle>;
    protected let m_itemRemovedCallback: ref<CallbackHandle>;

    protected let m_previewWrapper: wref<inkWidget>;

    protected let m_isPreviewMouseHold: Bool;
    protected let m_isCursorOverManager: Bool;
    protected let m_isCursorOverPreview: Bool;

    protected let m_itemDisplayContext: ref<ItemDisplayContextData>;

    protected cb func OnInitialize() -> Bool {
        super.OnInitialize();

        this.m_player = this.GetPlayerControlledObject() as PlayerPuppet;
        this.m_outfitSystem = OutfitSystem.GetInstance(this.m_player.GetGame());
        this.m_inventoryHelper = InventoryHelper.GetInstance(this.m_player.GetGame());
        this.m_paperdollHelper = PaperdollHelper.GetInstance(this.m_player.GetGame());
        this.m_delaySystem = GameInstance.GetDelaySystem(this.m_player.GetGame());
        this.m_uiScriptableSystem = UIScriptableSystem.GetInstance(this.m_player.GetGame());
        this.m_uiInventorySystem = UIInventoryScriptableSystem.GetInstance(this.m_player.GetGame());

        this.m_buttonHints = this.SpawnFromExternal(this.GetChildWidgetByPath(n"button_hints"), r"base\\gameplay\\gui\\common\\buttonhints.inkwidget", n"Root").GetController() as ButtonHints;
        this.m_buttonHints.AddButtonHint(n"back", GetLocalizedTextByKey(n"Common-Access-Close"));
        this.m_buttonHints.AddButtonHint(n"disassemble_item", "[" + GetLocalizedText("Gameplay-Devices-Interactions-Helpers-Hold") + "] " + GetLocalizedTextByKey(n"UI-UserActions-Unequip") + " " + GetLocalizedTextByKey(n"UI-Filters-AllItems"));

        this.m_outfitManager = this.SpawnFromLocal(this.GetChildWidgetByPath(n"wrapper/wrapper"), n"OutfitManager:EquipmentEx.OutfitManagerController").GetController() as OutfitManagerController;
        this.m_outfitManager.Setup(this.m_outfitSystem, this, this.m_buttonHints);

        this.m_inventoryScrollArea = this.GetChildWidgetByPath(n"wrapper/wrapper/vendorPanel/inventoryContainer") as inkCompoundWidget;
        this.m_inventoryScrollController = this.m_inventoryScrollArea.GetController() as inkScrollController;

        this.m_inventoryGridArea = this.m_inventoryScrollArea.GetWidget(n"stash_scroll_area_cache/scrollArea/vendor_virtualgrid");
        this.m_inventoryGridController = this.m_inventoryGridArea.GetController() as inkVirtualGridController;

        // this.m_itemInteractionArea = this.m_inventoryScrollArea.GetWidget(n"interactiveArea");
        this.m_isCursorOverManager = false;
        this.m_isCursorOverPreview = false;

        this.m_tooltipManager = this.GetRootWidget().GetControllerByType(n"gameuiTooltipsManager") as gameuiTooltipsManager;
        this.m_tooltipManager.Setup(ETooltipsStyle.Menus);

        this.m_inventoryBlackboard = GameInstance.GetBlackboardSystem(this.GetPlayerControlledObject().GetGame()).Get(GetAllBlackboardDefs().UI_Inventory);
        this.m_itemAddedCallback = this.m_inventoryBlackboard.RegisterListenerVariant(GetAllBlackboardDefs().UI_Inventory.itemAdded, this, n"OnInventoryItemsChanged");
        this.m_itemRemovedCallback = this.m_inventoryBlackboard.RegisterListenerVariant(GetAllBlackboardDefs().UI_Inventory.itemRemoved, this, n"OnInventoryItemsChanged");

        // Filters

        this.m_filtersContainer = this.GetChildWidgetByPath(n"wrapper/wrapper/vendorPanel/vendorHeader/inkHorizontalPanelWidget2/filtersContainer") as inkUniformGrid;
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

        this.m_previewWrapper = this.GetChildWidgetByPath(n"wrapper/preview");

        // Display Context

        this.m_itemDisplayContext = ItemDisplayContextData.Make(this.m_player, ItemDisplayContext.GearPanel);

        // Listeners

        this.m_outfitManager.RegisterToCallback(n"OnEnter", this, n"OnManagerHoverOver");
        this.m_outfitManager.RegisterToCallback(n"OnLeave", this, n"OnManagerHoverOut");
        
        this.m_previewWrapper.RegisterToCallback(n"OnPress", this, n"OnPreviewPress");
        this.m_previewWrapper.RegisterToCallback(n"OnAxis", this, n"OnPreviewAxis");
        this.m_previewWrapper.RegisterToCallback(n"OnRelative", this, n"OnPreviewRelative");
        this.m_previewWrapper.RegisterToCallback(n"OnEnter", this, n"OnPreviewHoverOver");
        this.m_previewWrapper.RegisterToCallback(n"OnLeave", this, n"OnPreviewHoverOut");

        this.RegisterToGlobalInputCallback(n"OnPostOnPress", this, n"OnGlobalPress");
        this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnGlobalRelease");
        this.RegisterToGlobalInputCallback(n"OnPostOnHold", this, n"OnGlobalHold");
        this.RegisterToGlobalInputCallback(n"OnPreOnRelative", this, n"OnGlobalRelative");
        this.RegisterToGlobalInputCallback(n"OnPreOnAxis", this, n"OnGlobalAxis");

        this.InitializeInventoryGrid();
        this.InitializeSearchField();
    }

    protected cb func OnUninitialize() -> Bool {
        super.OnUninitialize();

        this.PlaySound(n"GameMenu", n"OnClose");

        this.m_delaySystem.CancelDelay(this.m_inventoryGridUpdateDelayID);

        this.m_uiInventorySystem.FlushFullscreenCache();

        this.m_inventoryGridDataView.SetSource(null);
        this.m_inventoryGridController.SetSource(null);
        this.m_inventoryGridController.SetClassifier(null);
        this.m_inventoryGridTemplateClassifier = null;
        this.m_inventoryGridDataView = null;
        this.m_inventoryGridDataSource = null;

        this.UnregisterFromGlobalInputCallback(n"OnPostOnPress", this, n"OnGlobalPress");
        this.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"OnGlobalRelease");
        this.UnregisterFromGlobalInputCallback(n"OnPostOnHold", this, n"OnGlobalHold");
        this.UnregisterFromGlobalInputCallback(n"OnPostOnRelative", this, n"OnGlobalRelative");
        this.UnregisterFromGlobalInputCallback(n"OnPreOnAxis", this, n"OnGlobalAxis");

        this.m_inventoryBlackboard.UnregisterListenerVariant(GetAllBlackboardDefs().UI_Inventory.itemAdded, this.m_itemAddedCallback);
        this.m_inventoryBlackboard.UnregisterListenerVariant(GetAllBlackboardDefs().UI_Inventory.itemRemoved, this.m_itemRemovedCallback);
    }

    protected func InitializeSearchField() {
        let filterWrapper = this.GetRootCompoundWidget().GetWidget(n"wrapper/wrapper/vendorPanel/vendorHeader/inkHorizontalPanelWidget2") as inkCompoundWidget;
        let filterSpacing = this.m_filtersContainer.GetChildMargin();

        let searchWrapper = new inkCanvas();
        searchWrapper.SetMargin(new inkMargin(filterSpacing.right, 0, 0, filterSpacing.bottom));
        searchWrapper.Reparent(filterWrapper);

        this.m_searchInput = HubTextInput.Create();
        this.m_searchInput.SetName(n"SearchTextInput");
        this.m_searchInput.SetDefaultText(GetLocalizedTextByKey(n"UI-Wardrobe-SearchByName"));
        this.m_searchInput.SetLetterCase(textLetterCase.UpperCase);
        this.m_searchInput.SetMaxLength(24);
        this.m_searchInput.RegisterToCallback(n"OnInput", this, n"OnSearchFieldInput");
        this.m_searchInput.Reparent(searchWrapper);
    }

    protected func InitializeInventoryGrid() {
        this.m_inventoryGridDataSource = new ScriptableDataSource();
        
        this.m_inventoryGridDataView = new InventoryGridDataView();
        this.m_inventoryGridDataView.BindUIScriptableSystem(this.m_uiScriptableSystem);
        this.m_inventoryGridDataView.SetFilterType(ItemFilterCategory.AllItems);
        this.m_inventoryGridDataView.SetSortMode(ItemSortMode.Default);
        this.m_inventoryGridDataView.SetSource(this.m_inventoryGridDataSource);

        this.m_inventoryGridTemplateClassifier = new InventoryGridTemplateClassifier();
        
        this.m_inventoryGridController.SetClassifier(this.m_inventoryGridTemplateClassifier);
        this.m_inventoryGridController.SetSource(this.m_inventoryGridDataView);

        this.PopulateInventoryGrid();
    }

    protected func PopulateInventoryGrid() {
        let allItems = this.m_inventoryHelper.GetAvailableItems(this.m_itemDropQueue);
        let finalItems: array<ref<IScriptable>>;
        let slotItems: array<ref<gameItemData>>;
        let searchQuery = StrLower(this.m_searchInput.GetText());
        let groupIndex: Int32;
        let itemIndex: Int32;

        for slotID in this.m_outfitSystem.GetOutfitSlots() {
            ArrayClear(slotItems);

            for itemData in allItems {
                if this.m_outfitSystem.IsEquippable(itemData.GetID(), slotID) {
                    ArrayPush(slotItems, itemData);
                }
            }

            if ArraySize(slotItems) > 0 {
                let uiSlotData = new InventoryGridSlotData();
                uiSlotData.ItemData.SlotID = slotID;
                uiSlotData.ItemData.CategoryName = this.m_outfitSystem.GetSlotName(slotID);
                uiSlotData.SlotIndex = groupIndex;
                uiSlotData.ItemIndex = itemIndex;
                uiSlotData.IsVisible = true;
                groupIndex += 1;
                itemIndex += 1;
                
                ArrayPush(finalItems, uiSlotData);

                for itemData in slotItems {
                    let uiItemData = new InventoryGridItemData();
                    uiItemData.Item = UIInventoryItem.Make(this.m_player, slotID, itemData, this.m_uiInventorySystem.GetInventoryItemsManager());
                    uiItemData.DisplayContextData = this.m_itemDisplayContext;
                    uiItemData.SlotIndex = groupIndex;
                    uiItemData.ItemIndex = itemIndex;
                    uiItemData.IsVisible = true;
                    itemIndex += 1;

                    ArrayPush(finalItems, uiItemData);
                    ArrayPush(uiSlotData.Children, uiItemData);

                    if uiItemData.Item.IsEquipped() {
                        uiSlotData.ItemData.ID = uiItemData.Item.GetID();
                        uiSlotData.ItemData.Name = uiItemData.Item.GetName();
                        uiSlotData.ItemData.IsEquipped = true;
                    }
                }
            }
        }

        this.m_inventoryGridDataSource.Reset(finalItems);
    }

    protected func RefreshInventoryGrid() {
        this.m_inventoryGridDataView.UpdateView();
        this.m_inventoryScrollController.UpdateScrollPositionFromScrollArea();
    }

    protected func UpdateScrollPosition(opt forceReset: Bool) {
        if forceReset || this.m_scrollResetPending {
            this.m_inventoryScrollController.SetScrollPosition(0.0);
            this.m_scrollResetPending = false;
        }
    }

    protected cb func QueueInventoryGridUpdate(opt resetScroll: Bool) {
        if resetScroll {
            this.m_scrollResetPending = true;
        }

        this.m_delaySystem.CancelDelay(this.m_inventoryGridUpdateDelayID);
        this.m_inventoryGridUpdateDelayID = this.m_delaySystem.DelayCallback(UpdateInventoryGridCallback.Create(this), this.m_inventoryGridUpdateDelay, false);
    }

    protected cb func OnOutfitUpdated(evt: ref<OutfitUpdated>) {
        this.RefreshInventoryGrid();
    }

    protected cb func OnDropQueueUpdated(evt: ref<DropQueueUpdatedEvent>) {
        this.m_itemDropQueue = evt.m_dropQueue;

        if IsDefined(this.m_inventoryGridDataSource) {
            this.PopulateInventoryGrid();
        }
    }

    protected cb func OnInventoryItemsChanged(value: Variant) {
        let itemID = FromVariant<ItemID>(value);
        if ItemID.IsValid(itemID) && this.m_outfitSystem.IsEquippable(itemID) {
            this.QueueInventoryGridUpdate();
        }
    }

    protected cb func OnFilterChange(controller: wref<inkRadioGroupController>, selectedIndex: Int32) {
        this.UpdateScrollPosition(true);
        this.m_inventoryGridDataView.SetFilterType(this.m_filterManager.GetAt(selectedIndex));
        this.m_inventoryGridDataView.UpdateView();
    }

    protected cb func OnSearchFieldInput(widget: wref<inkWidget>) {
        this.UpdateScrollPosition(true);
        this.m_inventoryGridDataView.SetSearchQuery(this.m_searchInput.GetText());
        this.m_inventoryGridDataView.UpdateView();
    }

    protected final func ShowItemTooltip(widget: wref<inkWidget>, item: wref<UIInventoryItem>) {
        this.m_tooltipManager.HideTooltips();

        if IsDefined(item) {
            let data = UIInventoryItemTooltipWrapper.Make(item, this.m_itemDisplayContext);
            this.m_tooltipManager.ShowTooltipAtWidget(n"itemTooltip", widget, data, gameuiETooltipPlacement.RightTop);
        }
    }

    protected final func ShowItemButtonHints(item: wref<UIInventoryItem>) {
        this.m_buttonHints.RemoveButtonHint(n"equip_item");
        this.m_buttonHints.RemoveButtonHint(n"unequip_item");
        
        if IsDefined(item) {
            if item.IsEquipped() {
                this.m_buttonHints.AddButtonHint(n"unequip_item", GetLocalizedTextByKey(n"UI-UserActions-Unequip"));
            } else {
                this.m_buttonHints.AddButtonHint(n"equip_item", GetLocalizedTextByKey(n"UI-UserActions-Equip"));
            }
        }
    }

    protected cb func OnInventoryClick(evt: ref<ItemDisplayClickEvent>) -> Bool {
        if evt.actionName.IsAction(n"equip_item") {
            if !evt.uiInventoryItem.IsEquipped() {
                if this.m_outfitSystem.EquipItem(evt.uiInventoryItem.ID) {
                    this.ShowItemButtonHints(evt.uiInventoryItem);
                }
            }
        } else {
            if evt.actionName.IsAction(n"unequip_item") {
                if evt.uiInventoryItem.IsEquipped() {
                    if this.m_outfitSystem.UnequipItem(evt.uiInventoryItem.ID) {
                        this.ShowItemButtonHints(evt.uiInventoryItem);
                    }
                }
            }
        }
    }

    protected cb func OnInventoryItemHoverOver(evt: ref<ItemDisplayHoverOverEvent>) -> Bool {
        this.ShowItemButtonHints(evt.uiInventoryItem);
        this.ShowItemTooltip(evt.widget, evt.uiInventoryItem);
    }

    protected cb func OnInventoryItemHoverOut(evt: ref<ItemDisplayHoverOutEvent>) {
        this.ShowItemButtonHints(null);
        this.m_tooltipManager.HideTooltips();
    }

    protected cb func OnManagerHoverOver(evt: ref<inkPointerEvent>) -> Bool {
        this.m_isCursorOverManager = true;
    }

    protected cb func OnManagerHoverOut(evt: ref<inkPointerEvent>) -> Bool {
        this.m_isCursorOverManager = false;
    }

    protected cb func OnPreviewHoverOver(evt: ref<inkPointerEvent>) -> Bool {
        if this.m_player.PlayerLastUsedKBM() {
            this.m_buttonHints.AddButtonHint(n"mouse_wheel", GetLocalizedTextByKey(n"UI-ScriptExports-Zoom0"));
            this.m_buttonHints.AddButtonHint(n"mouse_left", GetLocalizedTextByKey(n"UI-ResourceExports-Rotate"));
        } else {
            this.m_buttonHints.AddButtonHint(n"right_stick_y", GetLocalizedTextByKey(n"UI-ScriptExports-Zoom0"));
            this.m_buttonHints.AddButtonHint(n"right_stick_x", GetLocalizedTextByKey(n"UI-ResourceExports-Rotate"));
        }

        this.m_isCursorOverPreview = true;
    }

    protected cb func OnPreviewHoverOut(evt: ref<inkPointerEvent>) -> Bool {
        this.m_buttonHints.RemoveButtonHint(n"mouse_wheel");
        this.m_buttonHints.RemoveButtonHint(n"mouse_left");
        this.m_buttonHints.RemoveButtonHint(n"right_stick_y");
        this.m_buttonHints.RemoveButtonHint(n"right_stick_x");

        this.m_isCursorOverPreview = false;
    }

    protected cb func OnPreviewPress(evt: ref<inkPointerEvent>) -> Bool {
        if evt.IsAction(n"mouse_left") {
            this.m_isPreviewMouseHold = true;

            let cursorEvent = new inkMenuLayer_SetCursorVisibility();
            cursorEvent.Init(false);
            this.QueueEvent(cursorEvent);
        }
    }

    protected cb func OnPreviewAxis(evt: ref<inkPointerEvent>) -> Bool {
        if evt.IsAction(n"right_stick_x") {
            this.RotatePreview(evt.GetAxisData(), 0.5);
        }

        if evt.IsAction(n"right_stick_y") && AbsF(evt.GetAxisData()) >= 0.85 {
            this.SetPreviewCamera(evt.GetAxisData() > 0.0);
        }
    }

    protected cb func OnPreviewRelative(evt: ref<inkPointerEvent>) -> Bool {
        if evt.IsAction(n"mouse_wheel") && evt.GetAxisData() != 0.0 {
            this.SetPreviewCamera(evt.GetAxisData() > 0.0);
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
        if this.m_isPreviewMouseHold && evt.IsAction(n"mouse_left") {
            this.m_isPreviewMouseHold = false;

            let cursorEvent = new inkMenuLayer_SetCursorVisibility();
            cursorEvent.Init(true, new Vector2(0.50, 0.50));
            this.QueueEvent(cursorEvent);

            evt.Consume();
        }
    }

    protected cb func OnGlobalHold(evt: ref<inkPointerEvent>) -> Bool {
        if evt.IsAction(n"disassemble_item") && evt.GetHoldProgress() >= 1.0 {
            this.m_outfitSystem.UnequipAll();
        }
    }

    protected cb func OnGlobalAxis(evt: ref<inkPointerEvent>) -> Bool {
        if evt.IsAction(n"right_stick_x") || evt.IsAction(n"right_stick_y") {
            this.m_inventoryScrollController.SetEnabled(!this.m_isCursorOverManager && !this.m_isCursorOverPreview);
        }
    }

    protected cb func OnGlobalRelative(evt: ref<inkPointerEvent>) -> Bool {
        if evt.IsAction(n"mouse_wheel") {
            this.m_inventoryScrollController.SetEnabled(!this.m_isCursorOverManager && !this.m_isCursorOverPreview);
        }

        if this.m_isPreviewMouseHold && evt.IsAction(n"mouse_x") {
            this.RotatePreview(evt.GetAxisData(), 1.0, true);
        }
    }

    protected func RotatePreview(offset: Float, speed: Float, opt clamp: Bool) {
        let puppet = this.m_paperdollHelper.GetPreview();

        if clamp {
            if offset > 0.00 {
                offset = ClampF(offset / puppet.m_maxMousePointerOffset, 0.50, 1.00);
            } else {
                offset = ClampF(offset / puppet.m_maxMousePointerOffset, -1.00, -0.50);
            }
        }

        puppet.Rotate(offset * speed * puppet.m_mouseRotationSpeed);
    }

    protected func SetPreviewCamera(zoomIn: Bool) {
        let puppet = this.m_paperdollHelper.GetPreview();
        let zoomArea = zoomIn ? InventoryPaperdollZoomArea.Head : InventoryPaperdollZoomArea.Default;

        let setCameraSetupEvent = new gameuiPuppetPreview_SetCameraSetupEvent();
        setCameraSetupEvent.setupIndex = Cast<Uint32>(EnumInt(zoomArea));

        puppet.QueueEvent(setCameraSetupEvent);
    }
}

class UpdateInventoryGridCallback extends DelayCallback {
    protected let m_controller: wref<WardrobeScreenController>;

    public func Call() {
        if IsDefined(this.m_controller) {
            this.m_controller.UpdateScrollPosition();
            this.m_controller.PopulateInventoryGrid();
        }
    }

    public static func Create(controller: ref<WardrobeScreenController>) -> ref<UpdateInventoryGridCallback> {
        let self = new UpdateInventoryGridCallback();
        self.m_controller = controller;
        return self;
    }
}
