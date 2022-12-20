module EquipmentEx

class PatchOriginalSlots extends ScriptableTweak {
    protected func OnApply() -> Void {
        for baseSlot in OutfitConfig.BaseSlots() {
            TweakDBManager.SetFlat(baseSlot.slotID + t".localizedName", UIItemsHelper.GetSlotName(baseSlot.equipmentArea));
            TweakDBManager.UpdateRecord(baseSlot.slotID);
        }
    }
}
