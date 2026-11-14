module EquipmentEx.Localization
import Codeware.Localization.*

public class French extends ModLocalizationPackage {
    protected func DefineTexts() -> Void {
        this.Text("UI-Wardrobe-NoOutfit", "Pas de tenue");
        this.Text("UI-Wardrobe-CurrentOutfit", "Tenue actuelle");
        this.Text("UI-Wardrobe-NotificationSaveSet", "Saisissez le nom de la tenue");
        this.Text("UI-Wardrobe-NotificationReplaceSet", "La tenue portant ce nom existe déjà, voulez-vous la remplacer ?");
        this.Text("UI-Wardrobe-SearchByName", "Rechercher par nom");
        this.Text("UI-Wardrobe-OverwriteWarning", "Remplacement de la tenue existante");
        this.Text("UI-EquipmentEx-WardrobeItemSource", "Origine des objets");
        this.Text("UI-EquipmentEx-WardrobeItemSource-Description", "Source préférée des objets pour la gestion des tenues : \"Inventaire + Planque\" n'utilisera que les objets actuels présents dans votre inventaire et dans votre planque, \"Garde-robe\" utilisera tous les objets que vous avez obtenus dans le jeu (y compris les objets abandonnés et démontés).");
        this.Text("UI-EquipmentEx-WardrobeItemSource-InventoryOnly", "Inventaire");
        this.Text("UI-EquipmentEx-WardrobeItemSource-InventoryAndStash", "Inventaire + Planque");
        this.Text("UI-EquipmentEx-WardrobeItemSource-WardrobeStore", "Garde-robe");
        this.Text("UI-EquipmentEx-NotificationRequirements", "Equipment-EX requiert : \\n- ArchiveXL {archive_xl_req} ou plus récent, \\n- TweakXL {tweak_xl_req} ou plus récent\\n- Codeware {codeware_req} ou plus récent\\n\\nDétectés : ArchiveXL {archive_xl_ver}, TweakXL {tweak_xl_ver} et Codeware {codeware_ver}. \\n\\nVeuillez mettre à jour ces prérequis pour utiliser ce mod.");
        this.Text("UI-EquipmentEx-NotificationConflicts", "Equipment-EX a détecté un mod conflictuel (conflit de mods non compatibles). \\n\\nLes mods suivants peuvent causer des problèmes ou bloquer la fonctionnalité de ce mod : \\n{conflicts}\\nVeuillez désactiver ou supprimer les mods en conflit si vous souhaitez utiliser ce mod.");
        this.Text("Gameplay-OutfitSlots-Head", "Tête");
        this.Text("Gameplay-OutfitSlots-Balaclava", "Cagoule");
        this.Text("Gameplay-OutfitSlots-Mask", "Masque");
        this.Text("Gameplay-OutfitSlots-Eyes", "Yeux");
        this.Text("Gameplay-OutfitSlots-EyeLeft", "Œil gauche");
        this.Text("Gameplay-OutfitSlots-EyeRight", "Œil droit");
        this.Text("Gameplay-OutfitSlots-Glasses", "Lunettes");
        this.Text("Gameplay-OutfitSlots-Wreath", "Bandeau / Couronne");
        this.Text("Gameplay-OutfitSlots-EarLeft", "Oreille gauche");
        this.Text("Gameplay-OutfitSlots-EarRight", "Oreille droite");
        this.Text("Gameplay-OutfitSlots-Neckwear", "Cou / Cravate");
        this.Text("Gameplay-OutfitSlots-NecklaceTight", "Collier / Ras-de-cou");
        this.Text("Gameplay-OutfitSlots-NecklaceShort", "Collier / Court");
        this.Text("Gameplay-OutfitSlots-NecklaceLong", "Collier / Long");
        this.Text("Gameplay-OutfitSlots-TorsoUnder", "Torse / Dessous");
        this.Text("Gameplay-OutfitSlots-TorsoInner", "Torse / Intérieur");
        this.Text("Gameplay-OutfitSlots-TorsoMiddle", "Torse / Milieu");
        this.Text("Gameplay-OutfitSlots-TorsoOuter", "Torse / Extérieur");
        this.Text("Gameplay-OutfitSlots-TorsoAux", "Torse / Aux.");
        this.Text("Gameplay-OutfitSlots-Back", "Dos");
        this.Text("Gameplay-OutfitSlots-ShoulderLeft", "Épaule gauche");
        this.Text("Gameplay-OutfitSlots-ShoulderRight", "Épaule droite");
        this.Text("Gameplay-OutfitSlots-ElbowLeft", "Coude gauche");
        this.Text("Gameplay-OutfitSlots-ElbowRight", "Coude droit");
        this.Text("Gameplay-OutfitSlots-WristLeft", "Poignet gauche");
        this.Text("Gameplay-OutfitSlots-WristRight", "Poignet droit");
        this.Text("Gameplay-OutfitSlots-Hands", "Mains");
        this.Text("Gameplay-OutfitSlots-HandLeft", "Main gauche");
        this.Text("Gameplay-OutfitSlots-HandRight", "Main droite");
        this.Text("Gameplay-OutfitSlots-FingersLeft", "Doigts gauches");
        this.Text("Gameplay-OutfitSlots-FingersRight", "Doigts droits");
        this.Text("Gameplay-OutfitSlots-FingernailsLeft", "Ongles main gauche");
        this.Text("Gameplay-OutfitSlots-FingernailsRight", "Ongles main droite");
        this.Text("Gameplay-OutfitSlots-Waist", "Taille");
        this.Text("Gameplay-OutfitSlots-LegsInner", "Jambes / Intérieur");
        this.Text("Gameplay-OutfitSlots-LegsMiddle", "Jambes / Milieu");
        this.Text("Gameplay-OutfitSlots-LegsOuter", "Jambes / Extérieur");
        this.Text("Gameplay-OutfitSlots-ThighLeft", "Cuisse gauche");
        this.Text("Gameplay-OutfitSlots-ThighRight", "Cuisse droite");
        this.Text("Gameplay-OutfitSlots-KneeLeft", "Genou gauche");
        this.Text("Gameplay-OutfitSlots-KneeRight", "Genou droit");
        this.Text("Gameplay-OutfitSlots-AnkleLeft", "Cheville gauche");
        this.Text("Gameplay-OutfitSlots-AnkleRight", "Cheville droite");
        this.Text("Gameplay-OutfitSlots-Feet", "Pieds");
        this.Text("Gameplay-OutfitSlots-ToesLeft", "Orteils gauches");
        this.Text("Gameplay-OutfitSlots-ToesRight", "Orteils droits");
        this.Text("Gameplay-OutfitSlots-ToenailsLeft", "Ongles pied gauche");
        this.Text("Gameplay-OutfitSlots-ToenailsRight", "Ongles pied droit");
        this.Text("Gameplay-OutfitSlots-BodyUnder", "Corps / Dessous");
        this.Text("Gameplay-OutfitSlots-BodyInner", "Corps / Intérieur");
        this.Text("Gameplay-OutfitSlots-BodyMiddle", "Corps / Milieu");
        this.Text("Gameplay-OutfitSlots-BodyOuter", "Corps / Extérieur");
        this.Text("Gameplay-OutfitSlots-HandPropLeft", "Accessoire main gauche");
        this.Text("Gameplay-OutfitSlots-HandPropRight", "Accessoire main droite");
    }
}
