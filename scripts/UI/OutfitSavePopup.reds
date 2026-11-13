module EquipmentEx
import Codeware.UI.*

public class OutfitSavePopup extends InMenuPopup {
    private let m_outfitSystem: wref<OutfitSystem>;
    private let m_requester: wref<inkGameController>;
    private let m_manager: wref<OutfitManagerController>;
    private let m_input: ref<HubTextInput>;
    private let m_warning: wref<inkText>;
    private let m_suggestedName: String;
    private let m_outfitName: CName;

    protected cb func OnCreate() {
        super.OnCreate();

        let content = InMenuPopupContent.Create();
        content.SetTitle(GetLocalizedTextByKey(n"UI-Wardrobe-SaveSet"));
        content.Reparent(this);

        let panel = new inkVerticalPanel();
        panel.SetMargin(inkMargin(0, 24, 0, 0));
        panel.Reparent(content.GetContainerWidget());

        let input = HubTextInput.Create();
        input.SetName(n"OutfitNameInput");
        input.SetDefaultText(GetLocalizedTextByKey(n"UI-Wardrobe-NotificationSaveSet"));
        input.SetLetterCase(textLetterCase.UpperCase);
        input.SetMaxLength(32);
        input.SetWidth(600.0);
        input.RegisterToCallback(n"OnInput", this, n"OnNameInput");
        input.Reparent(panel);

        let warning = new inkText();
        warning.SetName(n"overwrite_warning");
        warning.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
        warning.SetLetterCase(textLetterCase.UpperCase);
        warning.SetFitToContent(true);
        warning.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
        warning.BindProperty(n"fontSize", n"MainColors.ReadableXSmall");
        warning.BindProperty(n"tintColor", n"MainColors.Yellow");
        warning.SetMargin(inkMargin(0, 8, 0, 0));
        warning.SetHAlign(inkEHorizontalAlign.Left);
        warning.SetVAlign(inkEVerticalAlign.Top);
        warning.SetText(GetLocalizedTextByKey(n"UI-Wardrobe-OverwriteWarning"));
        warning.SetOpacity(0.0);
        warning.SetAffectsLayoutWhenHidden(true);
        warning.Reparent(panel);

        this.m_input = input;
        this.m_warning = warning;

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

    protected cb func OnInitialize() {
        super.OnInitialize();

        if NotEquals(this.m_suggestedName, "") {
            this.m_input.SetText(this.m_suggestedName);
        }

		this.m_input.SelectAll();
		this.m_input.RequestSetFocus();

        this.UpdateOverwriteWarning();
    }

    protected cb func OnNameInput(widget: wref<inkWidget>) {
        this.UpdateOverwriteWarning();
    }

    protected cb func OnConfirm() {
        let inputName = this.m_input.GetText();

        if Equals(inputName, "") {
            return;
        }

        this.m_outfitName = StringToName(inputName);

        if !this.m_outfitSystem.SaveOutfit(this.m_outfitName, true) {
            return;
        }

        if IsDefined(this.m_manager) {
            this.m_manager.OnOutfitSaved(this.m_outfitName);
        }
    }

    protected func UpdateOverwriteWarning() {
    	let inputName = this.m_input.GetText();
        let isOverwrite = NotEquals(inputName, "") && this.m_outfitSystem.HasOutfit(StringToName(inputName));

        this.m_warning.SetOpacity(isOverwrite ? 1.0 : 0.0);
    }

    public func GetOutfitName() -> CName {
        return this.m_outfitName;
    }

    public static func Show(requester: ref<inkGameController>, outfitSystem: ref<OutfitSystem>, suggestedName: CName, list: ref<OutfitManagerController>) -> ref<OutfitSavePopup> {
        let popup = new OutfitSavePopup();
        popup.m_outfitSystem = outfitSystem;
        popup.m_requester = requester;
        popup.m_manager = list;

        if NotEquals(suggestedName, n"") {
            popup.m_suggestedName = NameToString(suggestedName);
        }

        popup.Open(requester);

        return popup;
    }
}
