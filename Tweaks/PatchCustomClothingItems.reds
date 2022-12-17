module EquipmentEx

class PatchCustomClothingItems extends ScriptableTweak {
    protected func OnApply() -> Void {
        let outfitSlots = OutfitConfig.OutfitSlots();

        let originalEntities = [
            n"player_head_item",
            n"player_face_item",
            n"player_inner_torso_item",
            n"player_outer_torso_item",
            n"player_legs_item",
            n"player_feet_item",
            n"player_outfit_item"
        ];
        
        for record in TweakDBInterface.GetRecords(n"Clothing_Record") {
            let item = record as Clothing_Record;
            let entityName = item.EntityName();
            let garmentOffset = item.GarmentOffset();
            let placementSlots = TweakDBInterface.GetForeignKeyArray(item.GetID() + t".placementSlots");
            let placementSlot = ArrayLast(placementSlots);

            // Process only custom items with default offset
            if garmentOffset == 0 && !ArrayContains(originalEntities, entityName) {
                for outfitSlot in outfitSlots {
                    if outfitSlot.slotID == placementSlot {
                        if outfitSlot.garmentOffset != garmentOffset {
                            TweakDBManager.SetFlat(item.GetID() + t".garmentOffset", outfitSlot.garmentOffset);
                            TweakDBManager.UpdateRecord(item.GetID());
                        }
                        break;
                    }
                }
            }
        }
    }
}
