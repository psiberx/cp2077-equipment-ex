module EquipmentEx

class ConfigureClothingSlots extends ScriptableTweak {
    protected func OnApply() -> Void {
        let outfitSlots = OutfitConfig.OutfitSlots();

        for outfitSlot in outfitSlots {
            TweakDBManager.CreateRecord(outfitSlot.slotID, n"AttachmentSlot_Record");
            TweakDBManager.SetFlat(outfitSlot.slotID + t".localizedName", outfitSlot.displayName);

            if TDBID.IsValid(outfitSlot.relatedSlotID) {
                TweakDBManager.SetFlat(outfitSlot.slotID + t".parentSlot", outfitSlot.relatedSlotID);
            }

            TweakDBManager.UpdateRecord(outfitSlot.slotID);
            TweakDBManager.RegisterName(outfitSlot.slotName);
        }

        for record in TweakDBInterface.GetRecords(n"Character_Record") {
            let character = record as Character_Record;
            if Equals(GetLocalizedTextByKey(character.DisplayName()), "V") {
                let characterSlots = TweakDBInterface.GetForeignKeyArray(character.GetID() + t".attachmentSlots");

                for outfitSlot in outfitSlots {
                    if !ArrayContains(characterSlots, outfitSlot.slotID) {
                        ArrayPush(characterSlots, outfitSlot.slotID);
                    }
                }

                TweakDBManager.SetFlat(character.GetID() + t".attachmentSlots", characterSlots);
                TweakDBManager.UpdateRecord(character.GetID());
            }
        }
    }
}
