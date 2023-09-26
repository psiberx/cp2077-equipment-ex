@replaceMethod(InventoryItemModeLogicController)
private final func UpdateOutfitWardrobe(active: Bool, activeSetOverride: Int32) {
    inkWidgetRef.SetVisible(this.m_wardrobeSlotsContainer, active);
    inkWidgetRef.SetVisible(this.m_wardrobeSlotsLabel, active);
    inkWidgetRef.SetVisible(this.m_outfitsFilterInfoText, active);
    inkWidgetRef.SetVisible(this.m_filterButtonsGrid, !active);

    if active && !this.m_outfitWardrobeSpawned {
        let wardrobeContainer = inkCompoundRef.Get(this.m_wardrobeSlotsContainer) as inkCompoundWidget;

        let wardrobeInfo = new inkText();
        wardrobeInfo.SetLocalizedTextString("UI-Wardrobe-Tooltip-OutfitInfo");
        wardrobeInfo.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
        wardrobeInfo.SetStyle(r"base\\gameplay\\gui\\common\\main_colors.inkstyle");
        wardrobeInfo.BindProperty(n"tintColor", n"MainColors.Red");
        wardrobeInfo.BindProperty(n"fontWeight", n"MainColors.BodyFontWeight");
        wardrobeInfo.BindProperty(n"fontSize", n"MainColors.ReadableXSmall");
        wardrobeInfo.SetWrapping(true, 660.0);
        wardrobeInfo.Reparent(wardrobeContainer);

        // let wardrobeLink = this.SpawnFromLocal(wardrobeContainer, n"HyperlinkButton:EquipmentEx.WardrobeHubLink");
        // wardrobeLink.RegisterToCallback(n"OnClick", this.m_inventoryController, n"OnWardrobeScreenClick");
        // wardrobeLink.SetMargin(new inkMargin(16.0, 0.0, 0.0, 0.0));

        let wardrobeBtn = this.SpawnFromLocal(wardrobeContainer, n"wardrobeOutfitSlot:EquipmentEx.WardrobeHubBtnController");
        wardrobeBtn.SetMargin(new inkMargin(16.0, 0.0, 0.0, 0.0));

        this.m_outfitWardrobeSpawned = true;
    }
}

@replaceMethod(InventoryItemModeLogicController)
protected cb func OnWardrobeOutfitSlotClicked(e: ref<WardrobeOutfitSlotClickedEvent>) -> Bool {
    this.m_inventoryController.ShowWardrobeScreen();
}

@replaceMethod(InventoryItemModeLogicController)
protected cb func OnWardrobeOutfitSlotHoverOver(e: ref<WardrobeOutfitSlotHoverOverEvent>) -> Bool {
    //
}

@wrapMethod(InventoryItemModeLogicController)
private final func SetInventoryItemButtonHintsHoverOver(const displayingData: script_ref<InventoryItemData>, opt display: ref<InventoryItemDisplayController>) {
    if ItemID.IsValid(displayingData.ID) {
        wrappedMethod(displayingData, display);
    }
}
