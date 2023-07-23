module EquipmentEx
import Codeware.UI.*

class CollapseButtonClick extends Event {
    public let collapse: Bool;
    public let action: ref<inkActionName>;
}

class CollapseButton extends inkCustomController {
    protected let m_isFlipped: Bool;
    protected let m_isCollapse: Bool;

    protected let m_bg: wref<inkImage>;
    protected let m_frame: wref<inkImage>;
    protected let m_icon: wref<inkCompoundWidget>;

    protected cb func OnCreate() {
        let root = new inkCanvas();
        root.SetSize(110.0, 80.0);
        root.SetAnchorPoint(new Vector2(0.5, 0.5));
        root.SetInteractive(true);

        let bg = new inkImage();
        bg.SetName(n"bg");
        bg.SetAnchor(inkEAnchor.Fill);
        bg.SetNineSliceScale(true);
        bg.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
        bg.SetStyle(r"base\\gameplay\\gui\\common\\components\\toggles_style.inkstyle");
        bg.BindProperty(n"tintColor", n"FilterButton.backgroundColor");
        bg.BindProperty(n"opacity", n"FilterButton.backgroundOpacity");
        bg.Reparent(root);

        let frame = new inkImage();
        frame.SetName(n"frame");
        frame.SetAnchor(inkEAnchor.Fill);
        frame.SetNineSliceScale(true);
        frame.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
        frame.SetTexturePart(n"tooltip_map_fg");
        frame.SetStyle(r"base\\gameplay\\gui\\common\\components\\toggles_style.inkstyle");
        frame.BindProperty(n"tintColor", n"FilterButton.frameColor");
        frame.BindProperty(n"opacity", n"FilterButton.frameOpacity");
        frame.Reparent(root);

        let icon = new inkVerticalPanel();
        icon.SetAnchor(inkEAnchor.Centered);
        icon.SetAnchorPoint(new Vector2(0.5, 0.5));
        icon.Reparent(root);

        let arrowScale = 0.4;
        let arrowSize = new Vector2(44.0 * arrowScale, 38.0 * arrowScale);

        let arrowUp = new inkImage();
        arrowUp.SetName(n"arrowUp");
        arrowUp.SetHAlign(inkEHorizontalAlign.Center);
        arrowUp.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
        arrowUp.SetTexturePart(n"arrow_rect_bg");
        arrowUp.SetSize(arrowSize);
        arrowUp.SetStyle(r"base\\gameplay\\gui\\common\\components\\toggles_style.inkstyle");
        arrowUp.BindProperty(n"tintColor", n"FilterButton.iconColor");
        arrowUp.Reparent(icon);

        let line = new inkRectangle();
        line.SetHAlign(inkEHorizontalAlign.Center);
        line.SetSize(new Vector2(arrowSize.X + 12.0, 2.0));
        line.SetStyle(r"base\\gameplay\\gui\\common\\components\\toggles_style.inkstyle");
        line.BindProperty(n"tintColor", n"FilterButton.iconColor");
        line.Reparent(icon);

        let arrowDown = new inkImage();
        arrowDown.SetName(n"arrowDown");
        arrowDown.SetHAlign(inkEHorizontalAlign.Center);
        arrowDown.SetAtlasResource(r"base\\gameplay\\gui\\common\\shapes\\atlas_shapes_sync.inkatlas");
        arrowDown.SetTexturePart(n"arrow_down_bg");
        arrowDown.SetSize(arrowSize);
        arrowDown.SetStyle(r"base\\gameplay\\gui\\common\\components\\toggles_style.inkstyle");
        arrowDown.BindProperty(n"tintColor", n"FilterButton.iconColor");
        arrowDown.Reparent(icon);

        this.m_bg = bg;
        this.m_frame = frame;
        this.m_icon = icon;

        this.SetRootWidget(root);
        this.ApplyCollapseState();
        this.ApplyFlippedState();
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

    protected func ApplyCollapseState() {
        this.m_icon.SetChildOrder(this.m_isCollapse ? inkEChildOrder.Backward : inkEChildOrder.Forward);
        this.m_icon.SetChildMargin(this.m_isCollapse ? new inkMargin(0.0, 3.0, 0.0, 3.0) : new inkMargin(0.0, 3.0, 0.0, 3.0));
    }

    protected func ApplyFlippedState() {
        this.m_bg.SetTexturePart(this.m_isFlipped ? n"cell_flip_bg" : n"cell_bg");
        this.m_frame.SetBrushMirrorType(this.m_isFlipped ? inkBrushMirrorType.Horizontal : inkBrushMirrorType.NoMirror);
    }

    protected func TriggerClickEvent(action: ref<inkActionName>) {
        let evt = new CollapseButtonClick();
        evt.collapse = this.m_isCollapse;
        evt.action = action;

        let uiSystem = GameInstance.GetUISystem(this.GetGame());
        uiSystem.QueueEvent(evt);
    }

    public func SetCollapse(isCollapse: Bool) {
        this.m_isCollapse = isCollapse;

        this.ApplyCollapseState();
    }

    public func SetFlipped(isFlipped: Bool) {
        this.m_isFlipped = isFlipped;

        this.ApplyFlippedState();
    }

    public static func Create() -> ref<CollapseButton> {
        let self = new CollapseButton();
        self.CreateInstance();

        return self;
    }
}
