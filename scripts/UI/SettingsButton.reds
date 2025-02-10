module EquipmentEx
import Codeware.UI.*

class SettingsButtonClick extends Event {
    public let action: ref<inkActionName>;
}

class SettingsButton extends inkCustomController {
    protected let m_frame: wref<inkImage>;
    protected let m_icon: wref<inkCompoundWidget>;

    protected cb func OnCreate() {
        let root = new inkCanvas();
        root.SetSize(110.0, 80.0);
        root.SetAnchorPoint(new Vector2(0.5, 0.5));
        root.SetInteractive(true);

        let frame = new inkImage();
        frame.SetName(n"frame");
        frame.SetAnchor(inkEAnchor.Fill);
        frame.SetNineSliceScale(true);
        frame.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
        frame.SetTexturePart(n"status_cell_fg");
        //frame.SetBrushMirrorType(inkBrushMirrorType.Horizontal);
        frame.SetStyle(r"base\\gameplay\\gui\\common\\components\\toggles_style.inkstyle");
        frame.BindProperty(n"tintColor", n"FilterButton.frameColor");
        frame.BindProperty(n"opacity", n"FilterButton.frameOpacity");
        frame.Reparent(root);

        let icon = new inkVerticalPanel();
        icon.SetAnchor(inkEAnchor.Centered);
        icon.SetAnchorPoint(new Vector2(0.5, 0.5));
        icon.SetChildMargin(new inkMargin(0.0, 4.0, 0.0, 4.0));
        icon.Reparent(root);

        let i = 0;
        while i < 3 {
            let line = new inkRectangle();
            line.SetHAlign(inkEHorizontalAlign.Center);
            line.SetSize(new Vector2(33.0, 2.0));
            line.SetStyle(r"base\\gameplay\\gui\\common\\components\\toggles_style.inkstyle");
            line.BindProperty(n"tintColor", n"FilterButton.iconColor");
            line.Reparent(icon);

            i += 1;
        }

        this.m_frame = frame;
        this.m_icon = icon;

        this.SetRootWidget(root);
    }

    protected cb func OnInitialize() {
        this.RegisterToCallback(n"OnClick", this, n"OnClick");
        this.RegisterToCallback(n"OnHoverOver", this, n"OnHoverOver");
        this.RegisterToCallback(n"OnHoverOut", this, n"OnHoverOut");
    }

    protected cb func OnClick(evt: ref<inkPointerEvent>) {
        this.TriggerClickEvent(evt.GetActionName());
    }

    protected cb func OnHoverOver(evt: ref<inkPointerEvent>) {
        this.GetRootWidget().SetState(n"Hover");
    }

    protected cb func OnHoverOut(evt: ref<inkPointerEvent>) {
        this.GetRootWidget().SetState(n"Default");
    }

    protected func TriggerClickEvent(action: ref<inkActionName>) {
        let evt = new SettingsButtonClick();
        evt.action = action;

        let uiSystem = GameInstance.GetUISystem(this.GetGame());
        uiSystem.QueueEvent(evt);
    }

    public static func Create() -> ref<SettingsButton> {
        let self = new SettingsButton();
        self.CreateInstance();

        return self;
    }

    func OnReparent(parent: ref<inkCompoundWidget>) {}
}
