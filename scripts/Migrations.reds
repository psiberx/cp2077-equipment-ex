module EquipmentEx

struct ExtractedSet {
    public let setID: Int32;
    public let clothingList: array<SSlotVisualInfo>;
}

@if(!ModuleExists("ExtraWardrobeSlots.Utils"))
func ExtractClothingSets(game: GameInstance) -> array<ExtractedSet> {
    let wardrobeSystem = GameInstance.GetWardrobeSystem(game);
    let clothingSets = wardrobeSystem.GetClothingSets();
    let extractedSets: array<ExtractedSet>;

    for clothingSet in clothingSets {
        if ArraySize(clothingSet.clothingList) > 0 {
            ArrayPush(extractedSets, new ExtractedSet(
                EnumInt(clothingSet.setID) + 1,
                clothingSet.clothingList
            ));
        }
    }

    return extractedSets;
}

@if(ModuleExists("ExtraWardrobeSlots.Utils"))
func ExtractClothingSets(game: GameInstance) -> array<ExtractedSet> {
    let wardrobeSystem = WardrobeSystemExtra.GetInstance(game);
    let clothingSets = wardrobeSystem.GetClothingSets();
    let extractedSets: array<ExtractedSet>;

    for clothingSet in clothingSets {
        if ArraySize(clothingSet.clothingList) > 0 {
            ArrayPush(extractedSets, new ExtractedSet(
                EnumInt(clothingSet.setID) + 1,
                clothingSet.clothingList
            ));
        }
    }

    return extractedSets;
}
