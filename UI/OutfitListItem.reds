module EquipmentEx

public class OutfitListItemController extends inkLogicController {
    private let m_checkboxFrame: ref<inkWidget>;
    private let m_checkbox: ref<inkWidget>;
    private let m_outfitName: ref<inkText>;

    private let m_isDisabled: Bool;
    private let m_isHovered: Bool;

    protected cb func OnInitialize() -> Bool {
        let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
        this.m_checkboxFrame = root.GetWidget(n"titleAndCheckbox/checkbox");
        this.m_checkbox = root.GetWidget(n"titleAndCheckbox/checkbox/checkbox");
        this.m_outfitName = root.GetWidget(n"titleAndCheckbox/FilterName") as inkText;
        this.RegisterToCallback(n"OnHoverOver", this, n"OnHoverOverItem");
        this.RegisterToCallback(n"OnHoverOut", this, n"OnHoverOutItem");
    }

    protected cb func OnUninitialize() -> Bool {
        this.UnregisterFromCallback(n"OnHoverOver", this, n"OnHoverOverItem");
        this.UnregisterFromCallback(n"OnHoverOut", this, n"OnHoverOutItem");
    }

    protected cb func OnHoverOverItem(evt: ref<inkPointerEvent>) -> Bool {
        if this.m_isDisabled {
            return false;
        }

        this.m_isHovered = true;
        this.SetItemState(n"Hover");
    }

    protected cb func OnHoverOutItem(evt: ref<inkPointerEvent>) -> Bool {
        this.m_isHovered = false;
        if this.IsChecked() {
            this.SetItemState(n"Selected");
        } else {
            this.SetItemState(n"Default");
        }
    }

    public final func PlayIntroAnimation(delay: Float) -> Void {
        let animOptions: inkAnimOptions;
        animOptions.executionDelay = delay;
        this.PlayLibraryAnimation(n"OnFiltersListItem", animOptions);
    }

    public final func SetText(text: String) -> Void {
        this.m_outfitName.SetText(text);
    }

    public final func SetEquipped(equipped: Bool) -> Void {
        this.m_checkbox.SetVisible(equipped);
        if this.m_isHovered {
            this.SetItemState(n"Hover");
            return;
        }
        if equipped {
            this.SetItemState(n"Selected");
        } else {
            this.SetItemState(n"Default");
        }
    }

    public final func HideCheckboxFrame() -> Void {
        this.m_checkboxFrame.SetVisible(false);
        this.m_outfitName.SetMargin(new inkMargin(10.0, 0.0, 0.0, 0.0));
    }

    public final func SetCustomAppearance(text: String, color: CName) -> Void {
        this.m_outfitName.SetText(text);
        this.m_outfitName.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
        this.m_outfitName.BindProperty(n"tintColor", color);
    }

    public final func SetEnabled(enabled: Bool) -> Void {
        this.m_isDisabled = !enabled;
        if enabled {
            this.GetRootCompoundWidget().SetOpacity(1.0);
        } else {
            this.GetRootCompoundWidget().SetOpacity(0.3);
        }
    }

    private final func IsChecked() -> Bool {
        return this.m_checkbox.IsVisible();
    }

    private final func SetItemState(state: CName) -> Void {
        this.GetRootWidget().SetState(state);
    }
}
