module EquipmentEx
import Codeware.UI.*

public class ViewSettingsPopup extends InMenuPopup {
    private let m_itemSource: WardrobeItemSource;
    private let m_viewManager: ref<ViewManager>;
    private let m_options: array<wref<ItemSourceOptionController>>;
    private let m_arranged: Bool;

    protected cb func OnCreate() {
        super.OnCreate();

        this.m_viewManager = ViewManager.GetInstance(this.GetGame());
        this.m_itemSource = this.m_viewManager.GetItemSource();

        let content = InMenuPopupContent.Create();
        content.SetTitle(GetLocalizedTextByKey(n"UI-EquipmentEx-WardrobeItemSource"));
        content.Reparent(this);

        let panel = new inkVerticalPanel();
        panel.SetMargin(new inkMargin(0, 24, 0, 0));
        panel.Reparent(content.GetContainerWidget());

        for itemSource in [WardrobeItemSource.WardrobeStore, WardrobeItemSource.InventoryAndStash, WardrobeItemSource.InventoryOnly] {
            let option = this.SpawnOption(panel);
            option.SetData(itemSource, Equals(this.m_itemSource, itemSource));
            ArrayPush(this.m_options, option);
        }

        let footer = InMenuPopupFooter.Create();
        footer.Reparent(this);

        let confirmBtn = PopupButton.Create();
        confirmBtn.SetText(GetLocalizedTextByKey(n"UI-ResourceExports-Confirm"));
        confirmBtn.SetInputAction(n"one_click_confirm");
        confirmBtn.Reparent(footer);

        let cancelBtn = PopupButton.Create();
        cancelBtn.SetText(GetLocalizedText("LocKey#22175"));
        cancelBtn.SetInputAction(n"cancel");
        cancelBtn.Reparent(footer);
    }

    protected func SpawnOption(parent: ref<inkCompoundWidget>) -> ref<ItemSourceOptionController> {
        let widget = this.SpawnFromExternal(parent, r"equipment_ex\\gui\\wardrobe.inkwidget",
            n"OutfitListEntry:EquipmentEx.ItemSourceOptionController");
        return widget.GetController() as ItemSourceOptionController;
    }

    protected cb func OnArrangeChildrenComplete() {
        if !this.m_arranged {
            for option in this.m_options {
                option.UpdateView();
            }

            this.m_arranged = true;
        }
    }

    protected cb func OnChange(evt: ref<ItemSourceOptionChange>) {
        this.m_itemSource = evt.value;
    }

    protected cb func OnConfirm() {
        this.m_viewManager.SetItemSource(this.m_itemSource);
    }

    public static func Show(requester: ref<inkGameController>) {
        let popup = new ViewSettingsPopup();
        popup.Open(requester);
    }
}
