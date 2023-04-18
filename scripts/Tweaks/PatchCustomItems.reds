module EquipmentEx

class PatchCustomItems extends ScriptableTweak {
    protected func OnApply() -> Void {
        let outfitSlots = OutfitConfig.OutfitSlots();
        let slotMatcher = OutfitTweakHelper.PrepareCustomSlotMatcher();

        for record in TweakDBInterface.GetRecords(n"Clothing_Record") {
            let item = record as Clothing_Record;
            let placementSlots = TweakDBInterface.GetForeignKeyArray(item.GetID() + t".placementSlots");

            if ArraySize(placementSlots) == 1 {
                let outfitSlotID = slotMatcher.Match(item);
                if TDBID.IsValid(outfitSlotID) {
                    for outfitSlot in outfitSlots {
                        if outfitSlot.slotID == outfitSlotID {
                            if !ArrayContains(placementSlots, outfitSlot.slotID) {
                                ArrayPush(placementSlots, outfitSlot.slotID);
                                TweakDBManager.SetFlat(item.GetID() + t".placementSlots", placementSlots);
                                TweakDBManager.UpdateRecord(item.GetID());
                            }                           
                            break;
                        }
                    }
                }
            }
        }

        for record in TweakDBInterface.GetRecords(n"Clothing_Record") {
            let item = record as Clothing_Record;
            let placementSlots = TweakDBInterface.GetForeignKeyArray(item.GetID() + t".placementSlots");
            let garmentOffset = item.GarmentOffset();

            if (garmentOffset == 0 || DevMode()) && ArraySize(placementSlots) > 1 {
                let outfitSlotID = ArrayLast(placementSlots);
                if TDBID.IsValid(outfitSlotID) {
                    for outfitSlot in outfitSlots {
                        if outfitSlot.slotID == outfitSlotID {
                            TweakDBManager.SetFlat(item.GetID() + t".garmentOffset", outfitSlot.garmentOffset);
                            TweakDBManager.UpdateRecord(item.GetID());                       
                            break;
                        }
                    }
                }
            }
        }
    }
}
