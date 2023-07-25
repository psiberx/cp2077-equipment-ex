module EquipmentEx

class PatchOriginaltems extends ScriptableTweak {
    protected func OnApply() -> Void {
        let outfitSlots = OutfitConfig.OutfitSlots();
        let slotMatcher = OutfitTweakHelper.PrepareOriginalSlotMatcher();

        for record in TweakDBInterface.GetRecords(n"Clothing_Record") {
            let item = record as Clothing_Record;
            let placementSlots = TweakDBInterface.GetForeignKeyArray(item.GetID() + t".placementSlots");
            let garmentOffset = item.GarmentOffset();

            let updated = false;
            let outfitSlotID: TweakDBID;

            if ArraySize(placementSlots) == 1 || DevMode() {
                outfitSlotID = slotMatcher.Match(item);
            } else {
                outfitSlotID = ArrayLast(placementSlots);
            }

            if TDBID.IsValid(outfitSlotID) {
                for outfitSlot in outfitSlots {
                    if outfitSlot.slotID == outfitSlotID {
                        ArrayRemove(placementSlots, outfitSlot.slotID);
                        ArrayPush(placementSlots, outfitSlot.slotID);
                        if garmentOffset == 0 || DevMode() {
                            garmentOffset = outfitSlot.garmentOffset;
                        }
                        updated = true;
                        break;
                    }
                }
            }

            if updated {
                TweakDBManager.SetFlat(item.GetID() + t".placementSlots", placementSlots);
                TweakDBManager.SetFlat(item.GetID() + t".garmentOffset", garmentOffset);
                TweakDBManager.UpdateRecord(item.GetID());
            }
        }
    }
}
