module EquipmentEx

public class WardrobeSlotBtn extends WardrobeOutfitSlotController {
    protected cb func OnInitialize() -> Bool {
        super.OnInitialize();

        this.Setup(0, true, false, false);
        this.GetRootWidget().SetWidth(600);

        inkTextRef.SetText(this.m_slotNumberText, GetLocalizedTextByKey(n"UI-Wardrobe-Tooltip-OutfitInfoTitle"));
    }
}
