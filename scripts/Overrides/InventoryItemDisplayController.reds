import EquipmentEx.OutfitSystem

@addField(InventoryItemDisplayController)
private let m_outfitSystem: wref<OutfitSystem>;

@wrapMethod(InventoryItemDisplayController)
public func Bind(inventoryDataManager: ref<InventoryDataManagerV2>, equipmentArea: gamedataEquipmentArea, opt slotIndex: Int32, opt displayContext: ItemDisplayContext, opt setWardrobeOutfit: Bool, opt wardrobeOutfitIndex: Int32) {
    this.m_outfitSystem = OutfitSystem.GetInstance(inventoryDataManager.GetGame());

    wrappedMethod(inventoryDataManager, equipmentArea, slotIndex, displayContext, setWardrobeOutfit, wardrobeOutfitIndex);
}

@wrapMethod(InventoryItemDisplayController)
public func Bind(inventoryScriptableSystem: ref<UIInventoryScriptableSystem>, equipmentArea: gamedataEquipmentArea, opt slotIndex: Int32, displayContext: ItemDisplayContext) {
    this.m_outfitSystem = OutfitSystem.GetInstance(inventoryScriptableSystem.GetGameInstance());

    wrappedMethod(inventoryScriptableSystem, equipmentArea, slotIndex, displayContext);
}

@wrapMethod(InventoryItemDisplayController)
protected func RefreshUI() {
    let isOutfit = Equals(this.m_equipmentArea, gamedataEquipmentArea.Outfit);
    let isOverriden = this.m_outfitSystem.IsActive();

    if isOutfit && isOverriden {
        this.m_wardrobeOutfitIndex = 1;
    } else {
        this.m_wardrobeOutfitIndex = -1;
    }

    wrappedMethod();

    if isOutfit && isOverriden {
        inkWidgetRef.SetVisible(this.m_wardrobeInfoText, false);
        inkWidgetRef.SetVisible(this.m_slotItemsCountWrapper, false);
        inkWidgetRef.SetMargin(this.m_wardrobeInfoContainer, new inkMargin(12.0, 0, 0, 12.0));
    }
}

@wrapMethod(InventoryItemDisplayController)
public func Setup(inventoryItem: wref<UIInventoryItem>, displayContextData: wref<ItemDisplayContextData>, opt enoughMoney: Bool, opt owned: Bool, opt isUpgradable: Bool, opt overrideQuantity: Int32) {
    this.m_outfitSystem = OutfitSystem.GetInstance(inventoryItem.m_manager.m_uiScriptableSystem.GetGameInstance());

    wrappedMethod(inventoryItem, displayContextData, enoughMoney, owned, isUpgradable, overrideQuantity);
}

@wrapMethod(InventoryItemDisplayController)
protected func NewUpdateEquipped(itemData: ref<UIInventoryItem>) {
    if this.m_displayContextData.IsWardrobe() && this.m_outfitSystem.IsActive() {
        itemData.TEMP_isEquippedPrefetched = true;
        itemData.TEMP_isEquipped = this.m_outfitSystem.IsEquipped(itemData.ID);
    }

    wrappedMethod(itemData);

    if this.m_displayContextData.IsWardrobe() {
        itemData.TEMP_isEquippedPrefetched = false;
    }
}

@wrapMethod(InventoryItemDisplayController)
protected func NewUpdateRequirements(itemData: ref<UIInventoryItem>) {
    if !this.m_displayContextData.IsWardrobe() {
        wrappedMethod(itemData);
    }
}
