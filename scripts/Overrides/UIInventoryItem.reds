@addMethod(UIInventoryItem)
public static func Make(owner: wref<GameObject>, slotID: TweakDBID, itemData: script_ref<InventoryItemData>, opt manager: wref<UIInventoryItemsManager>) -> ref<UIInventoryItem> {
    let self = UIInventoryItem.FromInventoryItemData(owner, itemData, manager);
    self.m_data.IconPath = UIInventoryItemsManager.ResolveItemIconName(self.m_itemTweakID, self.m_itemRecord, self.m_manager);
    self.m_slotID = slotID;

    return self;
}

@addMethod(UIInventoryItem)
public func IsForWardrobe() -> Bool {
    return TDBID.IsValid(this.m_slotID);
}

@wrapMethod(UIInventoryItem)
public final func IsEquipped(opt force: Bool) -> Bool {
    if this.IsForWardrobe() && IsDefined(this.m_manager) {
        return this.m_manager.IsItemEquippedInSlot(this.ID, this.m_slotID);
    }

    return wrappedMethod(force);
}

@wrapMethod(UIInventoryItem)
public final func IsTransmogItem() -> Bool {
    if this.IsForWardrobe()  {
        return false;
    }

    return wrappedMethod();
}
