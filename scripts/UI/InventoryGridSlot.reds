module EquipmentEx

class InventoryGridSlotClick extends Event {
    public let slot: ref<InventoryGridSlotData>;
    public let action: ref<inkActionName>;
}

class InventoryGridSlotHoverOver extends Event {
    public let slot: ref<InventoryGridSlotData>;
}

class InventoryGridSlotHoverOut extends Event {
    public let slot: ref<InventoryGridSlotData>;
}

class InventoryGridSlotController extends inkVirtualCompoundItemController {
    private let m_uiSlot: ref<InventoryGridSlotData>;

    private let m_root: ref<inkCompoundWidget>;
    private let m_arrow: ref<inkImage>;
    private let m_slotNameText: ref<inkText>;
    private let m_itemNameText: ref<inkText>;
    private let m_itemCountText: ref<inkText>;

    private let m_isToggled: Bool;
    private let m_isHovered: Bool;

    protected cb func OnInitialize() {
        this.m_root = this.GetRootCompoundWidget();

        let content = new inkVerticalPanel();
        content.SetName(n"content");
        content.SetHAlign(inkEHorizontalAlign.Left);
        content.SetVAlign(inkEVerticalAlign.Center);
        content.SetAnchor(inkEAnchor.CenterLeft);
        content.SetAnchorPoint(0.0, 0.5);
        content.SetMargin(new inkMargin(28.0, 0.0, 0.0, 4.0));
        content.Reparent(this.m_root);

        this.m_slotNameText = new inkText();
        this.m_slotNameText.SetName(n"slot_name");
        this.m_slotNameText.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
        this.m_slotNameText.SetLetterCase(textLetterCase.UpperCase);
        this.m_slotNameText.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
        this.m_slotNameText.BindProperty(n"tintColor", n"MainColors.Red");
        this.m_slotNameText.BindProperty(n"fontWeight", n"MainColors.BodyFontWeight");
        this.m_slotNameText.BindProperty(n"fontSize", n"MainColors.ReadableFontSize");
        this.m_slotNameText.SetFitToContent(true);
        this.m_slotNameText.Reparent(content);

        this.m_itemNameText = new inkText();
        this.m_itemNameText.SetName(n"item_name");
        this.m_itemNameText.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
        this.m_itemNameText.SetLetterCase(textLetterCase.UpperCase);
        this.m_itemNameText.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
        this.m_itemNameText.BindProperty(n"tintColor", n"MainColors.Blue");
        this.m_itemNameText.BindProperty(n"fontSize", n"MainColors.ReadableXSmall");
        this.m_itemNameText.SetFitToContent(true);
        this.m_itemNameText.Reparent(content);

        this.m_itemCountText = new inkText();
        this.m_itemCountText.SetName(n"item_count");
        this.m_itemCountText.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
        this.m_itemCountText.SetLetterCase(textLetterCase.UpperCase);
        this.m_itemCountText.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
        this.m_itemCountText.BindProperty(n"tintColor", n"MainColors.Grey");
        this.m_itemCountText.BindProperty(n"fontSize", n"MainColors.ReadableXSmall");
        this.m_itemCountText.SetFitToContent(true);
        this.m_itemCountText.Reparent(content);

        let panel = new inkCanvas();
        panel.SetName(n"panel");       
        panel.SetAnchor(inkEAnchor.Fill);
        panel.SetMargin(new inkMargin(0.0, 2.0, 0.0, 8.0));
        panel.Reparent(this.m_root);

        let bg1 = new inkImage();
        bg1.SetName(n"bg1");
        bg1.SetAnchor(inkEAnchor.Fill);
        bg1.SetAnchorPoint(new Vector2(0.5, 0.5));
        bg1.SetNineSliceScale(true);
        bg1.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
        bg1.SetTexturePart(n"item_bg");
        bg1.SetStyle(r"base\\gameplay\\gui\\common\\components\\slots_style.inkstyle");
        bg1.BindProperty(n"tintColor", n"ItemDisplay.background");
        bg1.BindProperty(n"opacity", n"ItemDisplay.backgroundOpacity");
        bg1.Reparent(panel);

        let bg2 = new inkImage();
        bg2.SetName(n"bg2");
        bg2.SetAnchor(inkEAnchor.Fill);
        bg2.SetAnchorPoint(new Vector2(0.5, 0.5));
        bg2.SetNineSliceScale(true);
        bg2.SetNineSliceGrid(new inkMargin(0.0, 0.0, 20.0, 0.0));
        bg2.SetAtlasResource(r"base\\gameplay\\gui\\fullscreen\\inventory\\atlas_inventory.inkatlas");
        bg2.SetTexturePart(n"texture_2slot_iconic");
        bg2.SetOpacity(0.03);
        bg2.SetStyle(r"base\\gameplay\\gui\\common\\components\\slots_style.inkstyle");
        bg2.BindProperty(n"tintColor", n"ItemDisplay.emptyLinesColor");
        //bg2.BindProperty(n"opacity", n"ItemDisplay.emptyLinesOpacity");
        bg2.Reparent(panel);

        let fg = new inkImage();
        fg.SetName(n"fg");
        fg.SetAnchor(inkEAnchor.Fill);
        fg.SetAnchorPoint(new Vector2(0.5, 0.5));
        fg.SetNineSliceScale(true);
        fg.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
        fg.SetTexturePart(n"item_fg");
        fg.SetStyle(r"base\\gameplay\\gui\\common\\components\\slots_style.inkstyle");
        fg.BindProperty(n"tintColor", n"ItemDisplay.borderColor");
        fg.BindProperty(n"opacity", n"ItemDisplay.borderOpacity");
        fg.Reparent(panel);

        this.m_arrow = new inkImage();
        this.m_arrow.SetName(n"arrow");
        this.m_arrow.SetAnchor(inkEAnchor.CenterRight);
        this.m_arrow.SetAnchorPoint(new Vector2(1.0, 0.5));
        this.m_arrow.SetMargin(new inkMargin(0.0, 0.0, 40.0, 0.0));
        this.m_arrow.SetFitToContent(true);
        this.m_arrow.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
        this.m_arrow.SetTexturePart(n"arrow_right_bg");
        this.m_arrow.SetStyle(r"base\\gameplay\\gui\\common\\components\\slots_style.inkstyle");
        this.m_arrow.BindProperty(n"tintColor", n"ItemDisplay.borderColor");
        this.m_arrow.BindProperty(n"opacity", n"ItemDisplay.borderOpacity");
        this.m_arrow.Reparent(panel);

        this.RegisterToCallback(n"OnRelease", this, n"OnRelease");
        this.RegisterToCallback(n"OnEnter", this, n"OnHoverOver");
        this.RegisterToCallback(n"OnLeave", this, n"OnHoverOut");
    }

    protected cb func OnDataChanged(value: Variant) {
        this.m_uiSlot = FromVariant<ref<IScriptable>>(value) as InventoryGridSlotData;

        this.UpdateSlotInfo();
        this.UpdateActiveItem();
        this.UpdateState();
    }

    protected cb func OnOutfitUpdated(evt: ref<OutfitUpdated>) {
        this.UpdateActiveItem();
    }

    protected cb func OnOutfitPartUpdated(evt: ref<OutfitPartUpdated>) {
        if Equals(this.m_uiSlot.ItemData.SlotID, evt.slotID) {
            this.UpdateActiveItem();
        }
    }

    protected cb func OnRelease(evt: ref<inkPointerEvent>) {
        this.TriggerClickEvent(evt.GetActionName());
    }

    protected cb func OnHoverOver(evt: ref<inkPointerEvent>) {
        this.UpdateState();
        this.TriggerHoverOverEvent();
    }

    protected cb func OnHoverOut(evt: ref<inkPointerEvent>) {
        this.UpdateState();
        this.TriggerHoverOutEvent();
    }

    protected func UpdateSlotInfo() {
        this.m_slotNameText.SetText(this.m_uiSlot.ItemData.CategoryName);

        let itemCount = GetLocalizedText("LocKey#53719") + ": ";
        if this.m_uiSlot.TotalItems != this.m_uiSlot.VisibleItems {
            itemCount += ToString(this.m_uiSlot.VisibleItems) + " / ";
        }
        itemCount += ToString(this.m_uiSlot.TotalItems);

        this.m_itemCountText.SetText(itemCount);
    }

    protected func UpdateActiveItem() {
        let uiItem = this.m_uiSlot.GetActiveItem();
        
        if IsDefined(uiItem) {
            this.m_itemNameText.SetText(uiItem.Item.GetName());
            this.m_itemNameText.BindProperty(n"tintColor", n"MainColors.Blue");
        } else {
            this.m_itemNameText.SetText(GetLocalizedTextByKey(n"UI-Labels-EmptySlot"));
            this.m_itemNameText.BindProperty(n"tintColor", n"MainColors.Grey");
        }
    }

    protected func UpdateState() {
        this.m_arrow.SetRotation(this.m_uiSlot.IsCollapsed ? 0.0 : 90.0);
    }

    protected func TriggerClickEvent(action: ref<inkActionName>) {
        let evt = new InventoryGridSlotClick();
        evt.slot = this.m_uiSlot;
        evt.action = action;

        this.QueueEvent(evt);
    }

    protected func TriggerHoverOverEvent() {
        let evt = new InventoryGridSlotHoverOver();
        evt.slot = this.m_uiSlot;

        this.QueueEvent(evt);
    }

    protected func TriggerHoverOutEvent() {
        let evt = new InventoryGridSlotHoverOut();
        evt.slot = this.m_uiSlot;

        this.QueueEvent(evt);
    }
}
