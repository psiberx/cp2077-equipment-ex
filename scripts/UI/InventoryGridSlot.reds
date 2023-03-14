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

    private let m_root: wref<inkCompoundWidget>;
    private let m_arrow: wref<inkImage>;
    private let m_slotName: wref<inkText>;
    private let m_itemName: wref<inkText>;
    private let m_itemCount: wref<inkText>;

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

        let slotName = new inkText();
        slotName.SetName(n"slot_name");
        slotName.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
        slotName.SetLetterCase(textLetterCase.UpperCase);
        slotName.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
        slotName.BindProperty(n"tintColor", n"MainColors.Red");
        slotName.BindProperty(n"fontWeight", n"MainColors.BodyFontWeight");
        slotName.BindProperty(n"fontSize", n"MainColors.ReadableFontSize");
        slotName.SetFitToContent(true);
        slotName.Reparent(content);

        let itemName = new inkText();
        itemName.SetName(n"item_name");
        itemName.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
        itemName.SetLetterCase(textLetterCase.UpperCase);
        itemName.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
        itemName.BindProperty(n"tintColor", n"MainColors.Blue");
        itemName.BindProperty(n"fontSize", n"MainColors.ReadableXSmall");
        itemName.SetFitToContent(true);
        itemName.Reparent(content);

        let itemCount = new inkText();
        itemCount.SetName(n"item_count");
        itemCount.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
        itemCount.SetLetterCase(textLetterCase.UpperCase);
        itemCount.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
        itemCount.BindProperty(n"tintColor", n"MainColors.Grey");
        itemCount.BindProperty(n"fontSize", n"MainColors.ReadableXSmall");
        itemCount.SetFitToContent(true);
        itemCount.Reparent(content);

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

        let arrow = new inkImage();
        arrow.SetName(n"arrow");
        arrow.SetAnchor(inkEAnchor.CenterRight);
        arrow.SetAnchorPoint(new Vector2(1.0, 0.5));
        arrow.SetMargin(new inkMargin(0.0, 0.0, 40.0, 0.0));
        arrow.SetFitToContent(true);
        arrow.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
        arrow.SetTexturePart(n"arrow_right_bg");
        arrow.SetStyle(r"base\\gameplay\\gui\\common\\components\\slots_style.inkstyle");
        arrow.BindProperty(n"tintColor", n"ItemDisplay.borderColor");
        arrow.BindProperty(n"opacity", n"ItemDisplay.borderOpacity");
        arrow.Reparent(panel);

        this.m_arrow = arrow;
        this.m_slotName = slotName;
        this.m_itemName = itemName;
        this.m_itemCount = itemCount;

        this.RegisterToCallback(n"OnClick", this, n"OnClick");
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

    protected cb func OnClick(evt: ref<inkPointerEvent>) {
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
        this.m_slotName.SetText(this.m_uiSlot.ItemData.CategoryName);

        let itemCount = GetLocalizedText("LocKey#53719") + ": ";
        if this.m_uiSlot.TotalItems != this.m_uiSlot.VisibleItems {
            itemCount += ToString(this.m_uiSlot.VisibleItems) + " / ";
        }
        itemCount += ToString(this.m_uiSlot.TotalItems);

        this.m_itemCount.SetText(itemCount);
    }

    protected func UpdateActiveItem() {
        let uiItem = this.m_uiSlot.GetActiveItem();
        
        if IsDefined(uiItem) {
            this.m_itemName.SetText(uiItem.Item.GetName());
            this.m_itemName.BindProperty(n"tintColor", n"MainColors.Blue");
        } else {
            this.m_itemName.SetText(GetLocalizedTextByKey(n"UI-Labels-EmptySlot"));
            this.m_itemName.BindProperty(n"tintColor", n"MainColors.Grey");
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
