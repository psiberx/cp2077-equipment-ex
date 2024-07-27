module EquipmentEx

class PatchCustomItems extends ScriptableTweak {
    protected func OnApply() -> Void {
        let batch = TweakDBManager.StartBatch();
        let outfitSlots = OutfitConfig.OutfitSlots();
        let outfitMap = OutfitTweakHelper.BuildOutfitSlotMap(outfitSlots);
        let slotMatcher = OutfitTweakHelper.PrepareCustomSlotMatcher();

        for record in TweakDBInterface.GetRecords(n"Clothing_Record") {
            let item = record as Clothing_Record;
            let placementSlots = TweakDBInterface.GetForeignKeyArray(item.GetID() + t".placementSlots");

            if ArraySize(placementSlots) == 1 {
                let outfitSlotID = slotMatcher.Match(item);
                if TDBID.IsValid(outfitSlotID) {
                    let outfitHash = TDBID.ToNumber(outfitSlotID);
                    if outfitMap.KeyExist(outfitHash) {
                        let outfitIndex = outfitMap.Get(outfitHash);
                        let outfitSlot = outfitSlots[outfitIndex];
                        if !ArrayContains(placementSlots, outfitSlot.slotID) {
                            ArrayPush(placementSlots, outfitSlot.slotID);
                            batch.SetFlat(item.GetID() + t".placementSlots", placementSlots);
                            batch.UpdateRecord(item.GetID());
                        }
                    }
                }
            }
        }

        batch.Commit();

        for record in TweakDBInterface.GetRecords(n"Clothing_Record") {
            let item = record as Clothing_Record;
            let placementSlots = TweakDBInterface.GetForeignKeyArray(item.GetID() + t".placementSlots");
            let garmentOffset = item.GarmentOffset();

            if (garmentOffset == 0 || DevMode()) && ArraySize(placementSlots) > 1 {
                let outfitSlotID = ArrayLast(placementSlots);
                if TDBID.IsValid(outfitSlotID) {
                    let outfitHash = TDBID.ToNumber(outfitSlotID);
                    if outfitMap.KeyExist(outfitHash) {
                        let outfitIndex = outfitMap.Get(outfitHash);
                        let outfitSlot = outfitSlots[outfitIndex];
                        batch.SetFlat(item.GetID() + t".garmentOffset", outfitSlot.garmentOffset);
                        batch.UpdateRecord(item.GetID());
                    }
                }
            }
        }

        batch.Commit();
    }
}
