module EquipmentEx.Localization
import Codeware.Localization.*

public class Italian extends ModLocalizationPackage {
    protected func DefineTexts() -> Void {
        this.Text("UI-Wardrobe-NoOutfit", "Nessun abito");
        this.Text("UI-Wardrobe-CurrentOutfit", "Abito attuale");
        this.Text("UI-Wardrobe-NotificationSaveSet", "Nome abito:");
        this.Text("UI-Wardrobe-NotificationReplaceSet", "Esiste gi� un abito con questo nome, sovrascriverlo?");
        this.Text("UI-Wardrobe-SearchByName", "Ricerca per nome");
        this.Text("UI-EquipmentEx-WardrobeItemSource", "Fonte oggetti");
        this.Text("UI-EquipmentEx-WardrobeItemSource-Description", "Fonte preferita degli oggetti per il gestore degli abiti: \"Inventario + Magazzino\" user� solo gli oggetti correnti nel vostro inventario e magazzino, \"Guardaroba\" user� ogni oggetto che hai ottenuto nel gioco (compresi gli oggetti lasciati e smontati).");
        this.Text("UI-EquipmentEx-WardrobeItemSource-InventoryAndStash", "Inventario + Magazzino");
        this.Text("UI-EquipmentEx-WardrobeItemSource-WardrobeStore", "Guardaroba");
        this.Text("UI-EquipmentEx-NotificationRequirements", "Equipment-EX richiede:\\n- ArchiveXL {archive_xl_req} o successivo\\n- TweakXL {tweak_xl_req} o successivo\\n\\nRilevati ArchiveXL {archive_xl_ver} e TweakXL {tweak_xl_ver}.\\n\\nAggiorna i requisiti per utilizzare questa mod.");
        this.Text("UI-EquipmentEx-NotificationConflicts", "Equipment-EX ha rilevato una mod in conflitto.\\n\\nLe seguenti mod possono causare problemi o impedire il funzionamento di questa mod:\\n{conflicts}\\nDisabilita o rimuovi le mod in conflitto se vuoi utilizzare questa mod.");
        this.Text("Gameplay-OutfitSlots-Head", "Testa");
        this.Text("Gameplay-OutfitSlots-Balaclava", "Passamontagna");
        this.Text("Gameplay-OutfitSlots-Mask", "Maschera");
        this.Text("Gameplay-OutfitSlots-Glasses", "Occhiali");
        this.Text("Gameplay-OutfitSlots-Wreath", "Corona");
        this.Text("Gameplay-OutfitSlots-EarLeft", "Orecchio sinistro");
        this.Text("Gameplay-OutfitSlots-EarRight", "Orecchio destro");
        this.Text("Gameplay-OutfitSlots-Neckwear", "Cravatta");
        this.Text("Gameplay-OutfitSlots-NecklaceTight", "Collana / Stretta");
        this.Text("Gameplay-OutfitSlots-NecklaceShort", "Collana / Corta");
        this.Text("Gameplay-OutfitSlots-NecklaceLong", "Collana / Lunga");
        this.Text("Gameplay-OutfitSlots-TorsoUnder", "Torso / Inferiore");
        this.Text("Gameplay-OutfitSlots-TorsoInner", "Torso / Interno");
        this.Text("Gameplay-OutfitSlots-TorsoMiddle", "Torso / Intermedio");
        this.Text("Gameplay-OutfitSlots-TorsoOuter", "Torso / Esterno");
        this.Text("Gameplay-OutfitSlots-TorsoAux", "Torso / Aggiuntivo");
        this.Text("Gameplay-OutfitSlots-Back", "Schiena");
        this.Text("Gameplay-OutfitSlots-ShoulderLeft", "Spalla Sinistra");
        this.Text("Gameplay-OutfitSlots-ShoulderRight", "Spalla Destra");
        this.Text("Gameplay-OutfitSlots-WristLeft", "Polso sinistro");
        this.Text("Gameplay-OutfitSlots-WristRight", "Polso destro");
        this.Text("Gameplay-OutfitSlots-HandLeft", "Mano Sinistra");
        this.Text("Gameplay-OutfitSlots-HandRight", "Mano Destra");
        this.Text("Gameplay-OutfitSlots-FingersLeft", "Dita Sinistra");
        this.Text("Gameplay-OutfitSlots-FingersRight", "Dita Destra");
        this.Text("Gameplay-OutfitSlots-FingernailsLeft", "Unghie Sinistra");
        this.Text("Gameplay-OutfitSlots-FingernailsRight", "Unghie Destra");
        this.Text("Gameplay-OutfitSlots-Waist", "Girovita");
        this.Text("Gameplay-OutfitSlots-LegsInner", "Gambe / Interno");
        this.Text("Gameplay-OutfitSlots-LegsMiddle", "Gambe / Intermedio");
        this.Text("Gameplay-OutfitSlots-LegsOuter", "Gambe / Esterno");
        this.Text("Gameplay-OutfitSlots-ThighLeft", "Coscia Sinistra");
        this.Text("Gameplay-OutfitSlots-ThighRight", "Coscia Destra");
        this.Text("Gameplay-OutfitSlots-AnkleLeft", "Caviglia Sinistra");
        this.Text("Gameplay-OutfitSlots-AnkleRight", "Caviglia Destra");
        this.Text("Gameplay-OutfitSlots-Feet", "Piedi");
        this.Text("Gameplay-OutfitSlots-ToesLeft", "Dita dei Piedi Sinistra");
        this.Text("Gameplay-OutfitSlots-ToesRight", "Dita dei Piedi Destra");
        this.Text("Gameplay-OutfitSlots-ToenailsLeft", "Unghie dei Piedi Sinistra");
        this.Text("Gameplay-OutfitSlots-ToenailsRight", "Unghie dei Piedi Destra");
        this.Text("Gameplay-OutfitSlots-BodyUnder", "Corpo / Inferiore");
        this.Text("Gameplay-OutfitSlots-BodyInner", "Corpo / Interno");
        this.Text("Gameplay-OutfitSlots-BodyMiddle", "Corpo / Intermedio");
        this.Text("Gameplay-OutfitSlots-BodyOuter", "Corpo / Esterno");
        this.Text("Gameplay-OutfitSlots-HandPropLeft", "Prop Mano Sinistra");
        this.Text("Gameplay-OutfitSlots-HandPropRight", "Prop Mano Destra");
    }
}
