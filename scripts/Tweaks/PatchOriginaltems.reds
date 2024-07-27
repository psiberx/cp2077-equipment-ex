module EquipmentEx

class PatchOriginaltems extends ScriptableTweak {
    protected func OnApply() -> Void {
        let batch = TweakDBManager.StartBatch();
        let outfitSlots = OutfitConfig.OutfitSlots();
        let outfitMap = OutfitTweakHelper.BuildOutfitSlotMap(outfitSlots);
        let slotMatcher = OutfitTweakHelper.PrepareOriginalSlotMatcher();

        for record in TweakDBInterface.GetRecords(n"Clothing_Record") {
            let item = record as Clothing_Record;
            let placementSlots = TweakDBInterface.GetForeignKeyArray(item.GetID() + t".placementSlots");
            let garmentOffset = item.GarmentOffset();

            let outfitSlotID: TweakDBID;
            if ArraySize(placementSlots) == 1 || DevMode() {
                outfitSlotID = slotMatcher.Match(item);
            } else {
                outfitSlotID = ArrayLast(placementSlots);
            }

            if TDBID.IsValid(outfitSlotID) {
                let updated = false;

                let outfitHash = TDBID.ToNumber(outfitSlotID);
                if outfitMap.KeyExist(outfitHash) {
                    let outfitIndex = outfitMap.Get(outfitHash);
                    let outfitSlot = outfitSlots[outfitIndex];

                    if NotEquals(ArrayLast(placementSlots), outfitSlot.slotID) {
                        ArrayRemove(placementSlots, outfitSlot.slotID);
                        ArrayPush(placementSlots, outfitSlot.slotID);
                        if garmentOffset == 0 || DevMode() {
                            garmentOffset = outfitSlot.garmentOffset;
                        }
                        updated = true;
                    }
                }

                if updated {
                    batch.SetFlat(item.GetID() + t".placementSlots", placementSlots);
                    batch.SetFlat(item.GetID() + t".garmentOffset", garmentOffset);
                    batch.UpdateRecord(item.GetID());
                }
            }
        }

        batch.Commit();
    }
}
