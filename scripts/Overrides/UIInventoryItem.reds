@addMethod(UIInventoryItem)
public static func Make(owner: wref<GameObject>, slotID: TweakDBID, itemData: ref<gameItemData>, opt manager: wref<UIInventoryItemsManager>) -> ref<UIInventoryItem> {
    let self = UIInventoryItem.Make(owner, itemData, manager);
    self.m_slotID = slotID;

    return self;
}

@addMethod(UIInventoryItem)
public func IsForWardrobe() -> Bool {
    return TDBID.IsValid(this.m_slotID);
}

@wrapMethod(UIInventoryItem)
public final func IsEquipped() -> Bool {
    if this.IsForWardrobe() && IsDefined(this.m_manager) {
        return this.m_manager.IsItemEquippedInSlot(this.ID, this.m_slotID);
    }

    return wrappedMethod();
}
