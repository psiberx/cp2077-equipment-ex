module EquipmentEx

class PatchOriginaltems extends ScriptableTweak {
    protected func OnApply() -> Void {
        let batch = TweakDBManager.StartBatch();
        let devMode = DevMode();
        let outfitSlots = OutfitConfig.OutfitSlots();
        let outfitMap = OutfitTweakHelper.BuildOutfitSlotMap(outfitSlots);
        let slotMatcher = OutfitTweakHelper.PrepareOriginalSlotMatcher();

        for record in TweakDBInterface.GetRecords(n"Clothing_Record") {
            let item = record as Clothing_Record;
            let recordID = item.GetID();
            let placementSlots = TweakDBInterface.GetForeignKeyArray(recordID + t".placementSlots");
            let garmentOffset = item.GarmentOffset();

            let outfitSlotID: TweakDBID;
            if ArraySize(placementSlots) == 1 || devMode {
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
                        if garmentOffset == 0 || devMode {
                            garmentOffset = outfitSlot.garmentOffset;
                        }
                        updated = true;
                    }
                }

                if updated {
                    batch.SetFlat(recordID + t".placementSlots", placementSlots);
                    batch.SetFlat(recordID + t".garmentOffset", garmentOffset);
                    batch.UpdateRecord(recordID);
                }
            }
        }

        batch.Commit();
    }
}
