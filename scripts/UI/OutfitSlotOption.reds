module EquipmentEx

class OutfitSlotOptionChange extends Event {
    public let slotID: TweakDBID;
}

class OutfitSlotOptionController extends inkButtonController {
    private let m_data: ExtraSlotConfig;

    private let m_root: wref<inkCompoundWidget>;
    private let m_label: wref<inkText>;
    private let m_checkbox: wref<inkWidget>;
    private let m_selection: wref<inkWidget>;

    private let m_disabled: Bool;
    private let m_hovered: Bool;
    private let m_selected: Bool;

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

    protected cb func OnRelease(evt: ref<inkPointerEvent>) {
        if !this.m_disabled && !this.m_selected && evt.IsAction(n"click") {
            this.TriggerChangeEvent();
        }
    }

    protected cb func OnHoverOver(evt: ref<inkPointerEvent>) {
        if !this.m_disabled {
            this.m_hovered = true;

            this.UpdateState();
            // this.TriggerHoverOverEvent();
        }
    }

    protected cb func OnHoverOut(evt: ref<inkPointerEvent>) {
        if !this.m_disabled {
            this.m_hovered = false;    
                   
            this.UpdateState();
            // this.TriggerHoverOutEvent();
        }
    }

    protected cb func OnOptionChange(evt: ref<OutfitSlotOptionChange>) {
        this.m_selected = Equals(this.m_data.slotID, evt.slotID);
        this.UpdateState();
    }

    protected func UpdateView() {
        this.m_root.SetSize(new Vector2(this.m_label.GetDesiredWidth() + 170.0, 80.0));

        this.m_label.SetText(GetLocalizedText(this.m_data.displayName));
        this.m_label.BindProperty(n"fontStyle", n"MainColors.BodyFontWeight");
        this.m_label.BindProperty(n"fontSize", n"MainColors.ReadableSmall");

        this.m_checkbox.SetVisible(true);
        this.m_label.SetMargin(new inkMargin(20, 0, 0, 0));

        this.GetChildWidgetByPath(n"titleAndCheckbox").SetMargin(new inkMargin(0, 0, 0, 0));
        this.GetChildWidgetByPath(n"background").SetVisible(false);
    }

    protected func UpdateState() {
        this.m_selection.SetVisible(this.m_selected);

        if this.m_disabled {
            this.m_root.SetState(n"Default");
            this.m_root.SetOpacity(0.3);
        } else {
            this.m_root.SetOpacity(1.0);

            if this.m_hovered {
                this.m_root.SetState(n"Hover");
            }
            else {
                if this.m_selected {
                    this.m_root.SetState(n"Selected");
                }
                else {
                    this.m_root.SetState(n"Default");
                }
            }

            this.m_label.BindProperty(n"tintColor", this.m_selected ? n"MainColors.Blue" : n"MainColors.Red");
        }
    }

    protected func TriggerChangeEvent() {
        let evt = new OutfitSlotOptionChange();
        evt.slotID = this.m_data.slotID;

        this.QueueEvent(evt);
    }

    public func SetData(data: ExtraSlotConfig, selected: Bool) {
        this.m_data = data;
        this.m_selected = selected;

        this.UpdateView();
        this.UpdateState();
    }

    public func GetSlotID() -> TweakDBID {
        return this.m_data.slotID;
    }

    public func IsSelected() -> Bool {
        return this.m_selected;
    }
}
