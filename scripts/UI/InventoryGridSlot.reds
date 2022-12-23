module EquipmentEx

class InventoryGridSlotController extends inkVirtualCompoundItemController {
    protected let m_uiSlot: ref<InventoryGridSlotData>;
    protected let m_slotNameText: ref<inkText>;
    protected let m_itemNameText: ref<inkText>;
    
    protected cb func OnInitialize() {
        let container = new inkVerticalPanel();
        container.SetName(n"slot_header");
        container.SetHAlign(inkEHorizontalAlign.Left);
        container.SetVAlign(inkEVerticalAlign.Center);
        container.SetAnchor(inkEAnchor.CenterLeft);
        container.SetAnchorPoint(0.0, 0.5);
        container.Reparent(this.GetRootCompoundWidget());

        this.m_slotNameText = new inkText();
        this.m_slotNameText.SetName(n"slot_name");
        this.m_slotNameText.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
        this.m_slotNameText.SetLetterCase(textLetterCase.UpperCase);
        this.m_slotNameText.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
        this.m_slotNameText.BindProperty(n"tintColor", n"MainColors.Red");
        this.m_slotNameText.BindProperty(n"fontWeight", n"MainColors.BodyFontWeight");
        this.m_slotNameText.BindProperty(n"fontSize", n"MainColors.ReadableFontSize");
        this.m_slotNameText.SetFitToContent(true);
        this.m_slotNameText.Reparent(container);

        this.m_itemNameText = new inkText();
        this.m_itemNameText.SetName(n"item_name");
        this.m_itemNameText.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
        this.m_itemNameText.SetLetterCase(textLetterCase.UpperCase);
        this.m_itemNameText.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
        this.m_itemNameText.BindProperty(n"tintColor", n"MainColors.Blue");
        this.m_itemNameText.BindProperty(n"fontSize", n"MainColors.ReadableXSmall");
        this.m_itemNameText.SetFitToContent(true);
        this.m_itemNameText.Reparent(container);
    }

    protected cb func OnDataChanged(value: Variant) {
        this.m_uiSlot = FromVariant<ref<IScriptable>>(value) as InventoryGridSlotData;

        this.UpdateSlotInfo();
        this.UpdateActiveItem();
    }

    protected cb func OnOutfitUpdated(evt: ref<OutfitUpdated>) {
        this.UpdateActiveItem();
    }

    protected cb func OnOutfitPartUpdated(evt: ref<OutfitPartUpdated>) {
        if Equals(this.m_uiSlot.ItemData.SlotID, evt.slotID) {
            this.UpdateActiveItem();
        }
    }

    protected func UpdateSlotInfo() {
        this.m_slotNameText.SetText(this.m_uiSlot.ItemData.CategoryName);
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
}
