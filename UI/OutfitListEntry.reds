module EquipmentEx

class OutfitListRefresh extends Event {}

class OutfitListEntryClick extends Event {
    public let entry: ref<OutfitListEntryData>;
    public let action: ref<inkActionName>;
}

class OutfitListEntryHoverOver extends Event {
    public let entry: ref<OutfitListEntryData>;
}

class OutfitListEntryHoverOut extends Event {
    public let entry: ref<OutfitListEntryData>;
}

class OutfitListEntryController extends inkVirtualCompoundItemController {
    private let m_data: ref<OutfitListEntryData>;
    
    private let m_root: ref<inkCompoundWidget>;
    private let m_label: ref<inkText>;
    private let m_checkbox: ref<inkWidget>;
    private let m_selection: ref<inkWidget>;

    private let m_isDisabled: Bool;
    private let m_isHovered: Bool;

    protected cb func OnInitialize() {
        this.m_root = this.GetRootCompoundWidget();

        this.m_label = this.GetChildWidgetByPath(n"titleAndCheckbox/FilterName") as inkText;
        this.m_label.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
        
        this.m_checkbox = this.GetChildWidgetByPath(n"titleAndCheckbox/checkbox");
        this.m_selection = this.GetChildWidgetByPath(n"titleAndCheckbox/checkbox/checkbox");

        this.RegisterToCallback(n"OnRelease", this, n"OnRelease");
        this.RegisterToCallback(n"OnEnter", this, n"OnHoverOver");
        this.RegisterToCallback(n"OnLeave", this, n"OnHoverOut");       
    }

    protected cb func OnDataChanged(value: Variant) {
        this.m_data = FromVariant<ref<IScriptable>>(value) as OutfitListEntryData;

        if IsDefined(this.m_data) {
            this.UpdateView();
            this.UpdateState();
        }
    }

    protected cb func OnRefresh(evt: ref<OutfitListRefresh>) {
        if IsDefined(this.m_data) {
            this.UpdateView();
            this.UpdateState();
        }
    }

    protected cb func OnRelease(evt: ref<inkPointerEvent>) {
        if !this.m_isDisabled {
            this.TriggerClickEvent(evt.GetActionName());
        }
    }

    protected cb func OnHoverOver(evt: ref<inkPointerEvent>) {
        if !this.m_isDisabled {
            this.m_isHovered = true;

            this.UpdateState();
            this.TriggerHoverOverEvent();
        }
    }

    protected cb func OnHoverOut(evt: ref<inkPointerEvent>) {
        if !this.m_isDisabled {
            this.m_isHovered = false;    
                   
            this.UpdateState();
            this.TriggerHoverOutEvent();
        }
    }

    protected func UpdateView() {
        this.m_label.SetText(this.m_data.Title);
        
        if NotEquals(this.m_data.Color, n"") {
            this.m_label.BindProperty(n"tintColor", this.m_data.Color);
        } else {
            this.m_label.BindProperty(n"tintColor", n"MainColors.Red");
        }

        if this.m_data.IsSelectable {
            this.m_checkbox.SetVisible(true);
            this.m_selection.SetVisible(this.m_data.IsSelected);
            this.m_label.SetMargin(new inkMargin(30.0, 0.0, 0.0, 0.0));
        } else {
            this.m_checkbox.SetVisible(false);
            this.m_label.SetMargin(new inkMargin(10.0, 0.0, 0.0, 0.0));
        }
    }

    protected func UpdateState() {
        if this.m_isDisabled {
            this.m_root.SetState(n"Default");
            this.m_root.SetOpacity(0.3);
        } else {
            this.m_root.SetOpacity(1.0);

            if this.m_isHovered {
                this.m_root.SetState(n"Hover");
            }
            else {
                if this.m_data.IsSelectable && this.m_data.IsSelected {
                    this.m_root.SetState(n"Selected");
                }
                else {
                    this.m_root.SetState(n"Default");
                }
            }
        }
    }

    protected func TriggerClickEvent(action: ref<inkActionName>) {
        let evt = new OutfitListEntryClick();
        evt.entry = this.m_data;
        evt.action = action;

        this.QueueEvent(evt);
    }

    protected func TriggerHoverOverEvent() {
        let evt = new OutfitListEntryHoverOver();
        evt.entry = this.m_data;

        this.QueueEvent(evt);
    }

    protected func TriggerHoverOutEvent() {
        let evt = new OutfitListEntryHoverOut();
        evt.entry = this.m_data;

        this.QueueEvent(evt);
    }

    // public final func PlayIntroAnimation(delay: Float) {
    //     let animOptions: inkAnimOptions;
    //     animOptions.executionDelay = delay;
    //     this.PlayLibraryAnimation(n"OnFiltersListItem", animOptions);
    // }
}
