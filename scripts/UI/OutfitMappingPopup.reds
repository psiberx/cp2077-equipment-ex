module EquipmentEx
import Codeware.UI.*

public class OutfitMappingPopup extends InMenuPopup {
    private let m_itemID: ItemID;
    private let m_slotID: TweakDBID;
    private let m_system: ref<OutfitSystem>;
    private let m_options: array<wref<OutfitSlotOptionController>>;
    private let m_arranged: Bool;

    protected cb func OnCreate() {
        super.OnCreate();

        let content = InMenuPopupContent.Create();
        content.SetTitle(this.m_system.GetItemName(this.m_itemID));
        content.Reparent(this);

        let panel = new inkHorizontalPanel();
        panel.SetMargin(new inkMargin(0, 24, 0, 0));
        panel.Reparent(content.GetContainerWidget());

        let outfitSlots = OutfitConfig.OutfitSlots();

        let schema = [
            [n"Head", n"Face", n"Ears", n"Neck"],
            [n"Torso", n"Back",  n"Waist", n"Body"],
            [n"Arms", n"Hands", n"Fingers"],
            [n"Legs", n"Feet", n"Toes"]
        ];

        for areas in schema {
            let column = new inkVerticalPanel();
            column.Reparent(panel);
            
            for area in areas {
                for outfitSlot in outfitSlots {
                    if Equals(outfitSlot.slotArea, area) {
                        let option = this.SpawnOption(column);
                        option.SetData(outfitSlot, Equals(this.m_slotID, outfitSlot.slotID));

                        ArrayPush(this.m_options, option);
                    }
                }

                if NotEquals(area, ArrayLast(areas)) {
                    let divider = new inkCanvas();
                    divider.SetMargin(0, 0, 0, 40);
                    divider.Reparent(column);
                }
            }
        }

        let footer = InMenuPopupFooter.Create();
        footer.Reparent(this);

        let confirmBtn = PopupButton.Create();
        confirmBtn.SetText(GetLocalizedTextByKey(n"UI-UserActions-Equip")); // GetLocalizedText("LocKey#23123")
        confirmBtn.SetInputAction(n"system_notification_confirm");
        //confirmBtn.RegisterToCallback(n"OnBtnClick", this, n"OnConfirm");
        confirmBtn.Reparent(footer);

        let cancelBtn = PopupButton.Create();
        cancelBtn.SetText(GetLocalizedText("LocKey#22175"));
        cancelBtn.SetInputAction(n"back");
        //cancelBtn.RegisterToCallback(n"OnBtnClick", this, n"OnCancel");
        cancelBtn.Reparent(footer);
    }

    protected func SpawnOption(parent: ref<inkCompoundWidget>) -> ref<OutfitSlotOptionController> {
        let widget = this.SpawnFromExternal(parent, r"equipment_ex\\gui\\wardrobe.inkwidget",
            n"OutfitListEntry:EquipmentEx.OutfitSlotOptionController");
        return widget.GetController() as OutfitSlotOptionController;
    }

    protected cb func OnArrangeChildrenComplete() {
        if !this.m_arranged {
            for option in this.m_options {
                option.UpdateView();
            }

            this.m_arranged = true;
        }
    }

    protected cb func OnChange(evt: ref<OutfitSlotOptionChange>) {
        this.m_slotID = evt.slotID;
    }

    protected cb func OnConfirm() {
        this.m_system.AssignItem(this.m_itemID, this.m_slotID);

        if !this.m_system.IsEquipped(this.m_itemID) {
            this.m_system.EquipItem(this.m_itemID);
        }

        //this.Close();
    }

    //protected cb func OnCancel(widget: wref<inkWidget>) {
    //    this.Close();
    //}

    public static func Show(requester: ref<inkGameController>, itemID: ItemID, system: ref<OutfitSystem>) {
        let popup = new OutfitMappingPopup();
        popup.m_itemID = itemID;
        popup.m_slotID = system.GetItemSlot(itemID);
        popup.m_system = system;
        popup.Open(requester);
    }
}
