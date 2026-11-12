module EquipmentEx.Localization
import Codeware.Localization.*

public class Czech extends ModLocalizationPackage {
    protected func DefineTexts() -> Void {
        this.Text("UI-Wardrobe-NoOutfit", "Žádný oblek");
        this.Text("UI-Wardrobe-CurrentOutfit", "Současný oblek");
        this.Text("UI-Wardrobe-NotificationSaveSet", "Zadej název obleku");
        this.Text("UI-Wardrobe-NotificationReplaceSet", "Oblek s timto názvem už existuje, chceš ho přepsat?");
        this.Text("UI-Wardrobe-SearchByName", "Hledat podle jména");
        this.Text("UI-EquipmentEx-WardrobeItemSource", "Zdroj předmětů");
        this.Text("UI-EquipmentEx-WardrobeItemSource-Description", "Preferovaný zdroj položek pro správce vybavení: \"Inventář + Skrýš\" použije pouze aktuální položky v inventáři a skrýši, \"Kompletní šatník\" použije všechny předměty, které jste kdy ve hře získali (včetně upuštěných a rozebraných předmětů).");
        this.Text("UI-EquipmentEx-WardrobeItemSource-InventoryOnly", "Inventář");
        this.Text("UI-EquipmentEx-WardrobeItemSource-InventoryAndStash", "Inventář + Skrýš");
        this.Text("UI-EquipmentEx-WardrobeItemSource-WardrobeStore", "Kompletní šatník");
        this.Text("UI-EquipmentEx-NotificationRequirements", "Equipment-EX vyžaduje:\\n- ArchiveXL {archive_xl_req} nebo novější\\n- TweakXL {tweak_xl_req} nebo novější\\n- Codeware {codeware_req} nebo novější\\n\\nNalezen ArchiveXL {archive_xl_ver}, TweakXL {tweak_xl_ver} a Codeware {codeware_ver}.\\n\\nPro správnou funkci prosím všechny zastaralé mody aktualizuj.");
        this.Text("UI-EquipmentEx-NotificationConflicts", "Equipment-EX nalezl konfliktní mod.\\n\\nNásledující mody mohou způsobit problémy nebo blokovat funkce tohoto modu:\\n{conflicts}\\nPokud chceš používat tento mod, prosím zakaž nebo odstraň konfliktní mody.");
        this.Text("Gameplay-OutfitSlots-Head", "Hlava");
        this.Text("Gameplay-OutfitSlots-Balaclava", "Kukla");
        this.Text("Gameplay-OutfitSlots-Mask", "Maska");
        this.Text("Gameplay-OutfitSlots-Eyes", "Oči");
        this.Text("Gameplay-OutfitSlots-EyeLeft", "Levé oko");
        this.Text("Gameplay-OutfitSlots-EyeRight", "Pravé oko");
        this.Text("Gameplay-OutfitSlots-Glasses", "Brýle");
        this.Text("Gameplay-OutfitSlots-Wreath", "Čelenka");
        this.Text("Gameplay-OutfitSlots-EarLeft", "Levé ucho");
        this.Text("Gameplay-OutfitSlots-EarRight", "Pravé ucho");
        this.Text("Gameplay-OutfitSlots-Neckwear", "Krk");
        this.Text("Gameplay-OutfitSlots-NecklaceTight", "Náhrdelník / Těsný");
        this.Text("Gameplay-OutfitSlots-NecklaceShort", "Náhrdelník / Krátký");
        this.Text("Gameplay-OutfitSlots-NecklaceLong", "Náhrdelník / Dlouhý");
        this.Text("Gameplay-OutfitSlots-TorsoUnder", "Trup / Spodní");
        this.Text("Gameplay-OutfitSlots-TorsoInner", "Trup / Vnitřní");
        this.Text("Gameplay-OutfitSlots-TorsoMiddle", "Trup / Střední");
        this.Text("Gameplay-OutfitSlots-TorsoOuter", "Trup / Vnější");
        this.Text("Gameplay-OutfitSlots-TorsoAux", "Trup / Funkční");
        this.Text("Gameplay-OutfitSlots-Back", "Záda");
        this.Text("Gameplay-OutfitSlots-ShoulderLeft", "Levé rameno");
        this.Text("Gameplay-OutfitSlots-ShoulderRight", "Pravé rameno");
        this.Text("Gameplay-OutfitSlots-ElbowLeft", "Levý loket");
        this.Text("Gameplay-OutfitSlots-ElbowRight", "Pravý loket");
        this.Text("Gameplay-OutfitSlots-WristLeft", "Levé zápěstí");
        this.Text("Gameplay-OutfitSlots-WristRight", "Pravé zápěstí");
        this.Text("Gameplay-OutfitSlots-Hands", "Ruce");
        this.Text("Gameplay-OutfitSlots-HandLeft", "Levá ruka");
        this.Text("Gameplay-OutfitSlots-HandRight", "Pravá ruka");
        this.Text("Gameplay-OutfitSlots-FingersLeft", "Prsty levé ruky");
        this.Text("Gameplay-OutfitSlots-FingersRight", "Prsty pravé ruky");
        this.Text("Gameplay-OutfitSlots-FingernailsLeft", "Nehty na levé ruce");
        this.Text("Gameplay-OutfitSlots-FingernailsRight", "Nehty na pravé ruce");
        this.Text("Gameplay-OutfitSlots-Waist", "Pas");
        this.Text("Gameplay-OutfitSlots-LegsInner", "Nohy / Vnitřní");
        this.Text("Gameplay-OutfitSlots-LegsMiddle", "Nohy / Střední");
        this.Text("Gameplay-OutfitSlots-LegsOuter", "Nohy / Vnější");
        this.Text("Gameplay-OutfitSlots-ThighLeft", "Levé stehno");
        this.Text("Gameplay-OutfitSlots-ThighRight", "Pravé stehno");
        this.Text("Gameplay-OutfitSlots-KneeLeft", "Levé koleno");
        this.Text("Gameplay-OutfitSlots-KneeRight", "Pravé koleno");
        this.Text("Gameplay-OutfitSlots-AnkleLeft", "Levý kotník");
        this.Text("Gameplay-OutfitSlots-AnkleRight", "Pravý kotník");
        this.Text("Gameplay-OutfitSlots-Feet", "Chodidla");
        this.Text("Gameplay-OutfitSlots-ToesLeft", "Prsty levé nohy");
        this.Text("Gameplay-OutfitSlots-ToesRight", "Prsty pravé nohy");
        this.Text("Gameplay-OutfitSlots-ToenailsLeft", "Nehty na levé noze");
        this.Text("Gameplay-OutfitSlots-ToenailsRight", "Nehty na pravé noze");
        this.Text("Gameplay-OutfitSlots-BodyUnder", "Tělo / Spodní");
        this.Text("Gameplay-OutfitSlots-BodyInner", "Tělo / Vnitřní");
        this.Text("Gameplay-OutfitSlots-BodyMiddle", "Tělo / Střední");
        this.Text("Gameplay-OutfitSlots-BodyOuter", "Tělo / Vnější");
        this.Text("Gameplay-OutfitSlots-HandPropLeft", "Rekvizita v levé ruce");
        this.Text("Gameplay-OutfitSlots-HandPropRight", "Rekvizita v levé ruce");
    }
}
