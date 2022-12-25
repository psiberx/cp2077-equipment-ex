import EquipmentEx.{OutfitSystem,PaperdollHelper}

enum PhotoModeUI {
    CharacterPage = 2,
    VisibilityAttribute = 27,
    ExpressionAttribute = 28,
    OutfitAttribute = 3301
}

@addField(gameuiPhotoModeMenuController)
private let m_outfitSystem: wref<OutfitSystem>;

@addField(gameuiPhotoModeMenuController)
private let m_paperdollHelper: wref<PaperdollHelper>;

@addField(gameuiPhotoModeMenuController)
private let m_outfitAttribute: Uint32;

@wrapMethod(gameuiPhotoModeMenuController)
protected cb func OnInitialize() -> Bool {
    wrappedMethod();

    this.m_outfitSystem = OutfitSystem.GetInstance(this.GetPlayerControlledObject().GetGame());
    this.m_paperdollHelper = PaperdollHelper.GetInstance(this.GetPlayerControlledObject().GetGame());
    this.m_outfitAttribute = Cast<Uint32>(EnumInt(PhotoModeUI.OutfitAttribute));
}

@wrapMethod(gameuiPhotoModeMenuController)
protected cb func OnAddMenuItem(label: String, attribute: Uint32, page: Uint32) -> Bool {
    wrappedMethod(label, attribute, page);

    if Equals(page, PhotoModeUI.CharacterPage) && Equals(attribute, PhotoModeUI.VisibilityAttribute) {
        this.AddMenuItem(StrUpper(GetLocalizedTextByKey(n"UI-Inventory-Labels-Outfit")), this.m_outfitAttribute, page, false);
    }
}

@wrapMethod(gameuiPhotoModeMenuController)
protected cb func OnShow(reversedUI: Bool) -> Bool {
    let outfitMenuItem = this.GetMenuItem(this.m_outfitAttribute);
    if IsDefined(outfitMenuItem) {
        let outfits = this.m_outfitSystem.GetOutfits();
        let options: array<PhotoModeOptionSelectorData>;
        let current: Int32 = 0;
        
        ArrayResize(options, ArraySize(outfits) + 1);

        options[0].optionText = GetLocalizedTextByKey(n"UI-Wardrobe-NoOutfit");

        let i = 1;
        for outfitName in outfits {
            options[i].optionText = NameToString(outfitName); // StrUpper()
            options[i].optionData = i;

            if this.m_outfitSystem.IsEquipped(outfitName) {
                current = i;
            }

            i += 1;
        }

        outfitMenuItem.m_photoModeController = this;
        outfitMenuItem.SetupOptionSelector(options, current);
        outfitMenuItem.SetIsEnabled(true);

        this.GetChildWidgetByPath(n"options_panel").SetHeight(1000.0);
        this.GetChildWidgetByPath(n"options_panel/horizontalMenu").SetMargin(0.0, 0.0, -10.0, 920.0);
    }

    wrappedMethod(reversedUI);
}

@wrapMethod(gameuiPhotoModeMenuController)
protected cb func OnSetAttributeOptionEnabled(attribute: Uint32, enabled: Bool) -> Bool {
    wrappedMethod(attribute, enabled);

    if Equals(attribute, PhotoModeUI.ExpressionAttribute) {
        let outfitMenuItem = this.GetMenuItem(this.m_outfitAttribute);
        if IsDefined(outfitMenuItem) {
            outfitMenuItem.SetIsEnabled(enabled);
        }
    }
}

@addMethod(gameuiPhotoModeMenuController)
public func OnAttributeOptionSelected(attribute: Uint32, option: PhotoModeOptionSelectorData) {
    if Equals(attribute, PhotoModeUI.OutfitAttribute) {
        let outfitName = option.optionData > 0 ? StringToName(option.optionText) : n"";
        this.m_outfitSystem.EquipPuppetOutfit(this.m_paperdollHelper.GetPuppet(), outfitName);
    }
}

@wrapMethod(PhotoModeMenuListItem)
private final func StartArrowClickedEffect(widget: inkWidgetRef) {
    wrappedMethod(widget);

    this.m_photoModeController.OnAttributeOptionSelected(
        (this.GetData() as PhotoModeMenuListItemData).attributeKey, 
        this.m_OptionSelectorValues[this.m_OptionSelector.GetCurrIndex()]
    );
}
