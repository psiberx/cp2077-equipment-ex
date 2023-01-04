import EquipmentEx.OutfitSystem

@addField(UIInventoryItemsManager)
private let m_outfitSystem: wref<OutfitSystem>;

@wrapMethod(UIInventoryItemsManager)
public final static func Make(player: wref<PlayerPuppet>, transactionSystem: ref<TransactionSystem>, uiScriptableSystem: wref<UIScriptableSystem>) -> ref<UIInventoryItemsManager> {
    let instance = wrappedMethod(player, transactionSystem, uiScriptableSystem);
    instance.m_outfitSystem = OutfitSystem.GetInstance(player.GetGame());

    return instance;
}

@addMethod(UIInventoryItemsManager)
public final func IsItemEquippedInSlot(itemID: ItemID, slotID: TweakDBID) -> Bool {
    return this.m_outfitSystem.IsActive() ? this.m_outfitSystem.IsEquipped(itemID) : this.IsItemEquipped(itemID);
}
