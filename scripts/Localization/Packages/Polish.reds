module EquipmentEx.Localization
import Codeware.Localization.*

public class Polish extends ModLocalizationPackage {
    protected func DefineTexts() -> Void {
        this.Text("UI-Wardrobe-NoOutfit", "Brak stroju");
        this.Text("UI-Wardrobe-CurrentOutfit", "Obecny strój");
        this.Text("UI-Wardrobe-NotificationSaveSet", "Wprowadź nazwę stroju");
        this.Text("UI-Wardrobe-NotificationReplaceSet", "Strój o tej nazwie już istnieje. Czy chcesz go zastąpić?");
        this.Text("UI-Wardrobe-SearchByName", "Szukaj według nazwy");
        this.Text("UI-EquipmentEx-WardrobeItemSource", "Źródło Przedmiotu");
        this.Text("UI-EquipmentEx-WardrobeItemSource-Description", "Preferowane źródło przedmiotów dla menedżera strojów: \"Ekwipunek + Schowek\" użyje tylko bieżących przedmiotów z twojego ekwipunku i schowka, \"Garderoba\" użyje każdego przedmiotu, który kiedykolwiek zdobyłeś w grze (w tym przedmiotów upuszczonych i rozmontowanych).");
        this.Text("UI-EquipmentEx-WardrobeItemSource-InventoryOnly", "Ekwipunek");
        this.Text("UI-EquipmentEx-WardrobeItemSource-InventoryAndStash", "Ekwipunek + Schowek");
        this.Text("UI-EquipmentEx-WardrobeItemSource-WardrobeStore", "Garderoba");
        this.Text("UI-EquipmentEx-NotificationRequirements", "Equipment-EX wymaga:\\n- ArchiveXL {archive_xl_req} albo nowszego\\n- TweakXL {tweak_xl_req} albo nowszego\\n- Codeware {codeware_req} albo nowszego\\n\\nWykryto ArchiveXL {archive_xl_ver}, TweakXL {tweak_xl_ver} i Codeware {codeware_ver}.\\n\\nAby móc korzystać z tego moda, zaktualizuj zależności.");
        this.Text("UI-EquipmentEx-NotificationConflicts", "Equipment-EX wykrył konfliktującego moda.\\n\\nNastępujące mody mogą powodować problemy lub blokować funkcjonalność tego moda:\\n{conflicts}\\nJeśli chcesz używać tego moda, wyłącz lub usuń konfliktujące mody.");
        this.Text("Gameplay-OutfitSlots-Head", "Głowa");
        this.Text("Gameplay-OutfitSlots-Balaclava", "Kominiarka");
        this.Text("Gameplay-OutfitSlots-Mask", "Maska");
        this.Text("Gameplay-OutfitSlots-Glasses", "Okulary");
        this.Text("Gameplay-OutfitSlots-Wreath", "Wieniec");
        this.Text("Gameplay-OutfitSlots-EarLeft", "Lewe Ucho");
        this.Text("Gameplay-OutfitSlots-EarRight", "Prawe Ucho");
        this.Text("Gameplay-OutfitSlots-Neckwear", "Szyja");
        this.Text("Gameplay-OutfitSlots-NecklaceTight", "Naszyjnik / Ciasny");
        this.Text("Gameplay-OutfitSlots-NecklaceShort", "Naszyjnik / Krótki");
        this.Text("Gameplay-OutfitSlots-NecklaceLong", "Naszyjnik / Długi");
        this.Text("Gameplay-OutfitSlots-TorsoUnder", "Tułów / Pod");
        this.Text("Gameplay-OutfitSlots-TorsoInner", "Tułów / Spód");
        this.Text("Gameplay-OutfitSlots-TorsoMiddle", "Tułów / Środek");
        this.Text("Gameplay-OutfitSlots-TorsoOuter", "Tułów / Wierz");
        this.Text("Gameplay-OutfitSlots-TorsoAux", "Tułów / Aux");
        this.Text("Gameplay-OutfitSlots-Back", "Plecy");
        this.Text("Gameplay-OutfitSlots-ShoulderLeft", "Lewe Ramię");
        this.Text("Gameplay-OutfitSlots-ShoulderRight", "Prawe Ramię");
        this.Text("Gameplay-OutfitSlots-WristLeft", "Lewy Nadgarstek");
        this.Text("Gameplay-OutfitSlots-WristRight", "Prawy Nadgarstek");
        this.Text("Gameplay-OutfitSlots-HandLeft", "Lewa Dłoń");
        this.Text("Gameplay-OutfitSlots-HandRight", "Prawa Dłoń");
        this.Text("Gameplay-OutfitSlots-FingersLeft", "Lewe Palce");
        this.Text("Gameplay-OutfitSlots-FingersRight", "Prawe Palce");
        this.Text("Gameplay-OutfitSlots-FingernailsLeft", "Lewe Paznokcie");
        this.Text("Gameplay-OutfitSlots-FingernailsRight", "Prawe Paznokcie");
        this.Text("Gameplay-OutfitSlots-Waist", "Talia");
        this.Text("Gameplay-OutfitSlots-LegsInner", "Nogi / Spód");
        this.Text("Gameplay-OutfitSlots-LegsMiddle", "Nogi / Środek");
        this.Text("Gameplay-OutfitSlots-LegsOuter", "Nogi / Wierzch");
        this.Text("Gameplay-OutfitSlots-ThighLeft", "Lewe Udo");
        this.Text("Gameplay-OutfitSlots-ThighRight", "Prawe Udo");
        this.Text("Gameplay-OutfitSlots-AnkleLeft", "Lewa Kostka");
        this.Text("Gameplay-OutfitSlots-AnkleRight", "Prawa Kostka");
        this.Text("Gameplay-OutfitSlots-Feet", "Stopy");
        this.Text("Gameplay-OutfitSlots-ToesLeft", "Lewe Palce u Stóp");
        this.Text("Gameplay-OutfitSlots-ToesRight", "Prawe Palce u Stóp");
        this.Text("Gameplay-OutfitSlots-ToenailsLeft", "Lewe Paznokcie u Stóp");
        this.Text("Gameplay-OutfitSlots-ToenailsRight", "Prawe Paznokcie u Stóp");
        this.Text("Gameplay-OutfitSlots-BodyUnder", "Ciało / Pod");
        this.Text("Gameplay-OutfitSlots-BodyInner", "Ciało / Spód");
        this.Text("Gameplay-OutfitSlots-BodyMiddle", "Ciało / Środek");
        this.Text("Gameplay-OutfitSlots-BodyOuter", "Ciało / Wierzch");
        this.Text("Gameplay-OutfitSlots-HandPropLeft", "Prop Lewej Dłoni");
        this.Text("Gameplay-OutfitSlots-HandPropRight", "Prop Prawej Dłoni");
    }
}
