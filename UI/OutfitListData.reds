module EquipmentEx

enum OutfitListAction {
    Equip = 0,
    Unequip = 1,
    Save = 2
}

class OutfitListEntryData {
    public let Name: CName;
    public let Title: String;
    public let Color: CName;
    public let Action: OutfitListAction;
    public let Postition: Int32 = 2147483647;
    public let IsRemovable: Bool;
    public let IsSelectable: Bool;
    public let IsSelected: Bool;
}

class OutfitListDataView extends ScriptableDataView {
    public func UpdateView() {
        this.EnableSorting();
        this.Sort();
        this.DisableSorting();
    }

    public func SortItem(left: ref<IScriptable>, right: ref<IScriptable>) -> Bool {
        let leftEntry = left as OutfitListEntryData;
        let rightEntry = right as OutfitListEntryData;

        if leftEntry.Postition != rightEntry.Postition {
            return leftEntry.Postition < rightEntry.Postition;
        }
        
        return StrCmp(leftEntry.Title, rightEntry.Title) < 0;
    }
}

class OutfitListTemplateClassifier extends inkVirtualItemTemplateClassifier {
    // public func ClassifyItem(data: Variant) -> Uint32 {
    //     return 0u;
    // }
}
