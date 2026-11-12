module EquipmentEx.Localization
import Codeware.Localization.*

public class Brazilian extends ModLocalizationPackage {
    protected func DefineTexts() -> Void {
        this.Text("UI-Wardrobe-NoOutfit", "Sem traje");
        this.Text("UI-Wardrobe-CurrentOutfit", "Traje atual");
        this.Text("UI-Wardrobe-NotificationSaveSet", "Digite o nome do traje:");
        this.Text("UI-Wardrobe-NotificationReplaceSet", "Um traje com este nome ja existe, deseja substituí-lo?");
        this.Text("UI-Wardrobe-SearchByName", "Procurar por nome");
        this.Text("UI-EquipmentEx-WardrobeItemSource", "Fonte de items");
        this.Text("UI-EquipmentEx-WardrobeItemSource-Description", "A fonte preferida de items: \"Inventário + Esconderijo\" vai utilizar apenas os items presentes no seu inventário e esconderijo, \"Guarda-roupa\" vai utilizar todos os items que você já obteve no jogo (incluindo items soltos e desmontados).");
        this.Text("UI-EquipmentEx-WardrobeItemSource-InventoryOnly", "Inventário");
        this.Text("UI-EquipmentEx-WardrobeItemSource-InventoryAndStash", "Inventário + Esconderijo");
        this.Text("UI-EquipmentEx-WardrobeItemSource-WardrobeStore", "Guarda-roupa");
        this.Text("UI-EquipmentEx-NotificationRequirements", "Equipment-EX requer:\\n- ArchiveXL {archive_xl_req} ou mais recente\\n- TweakXL {tweak_xl_req} ou mais recente\\n- Codeware {codeware_req} ou mais recente\\n\\nDetectado ArchiveXL {archive_xl_ver}, TweakXL {tweak_xl_ver} e Codeware {codeware_ver}.\\n\\nPor favor, atualize as dependências para utilizar o mod.");
        this.Text("UI-EquipmentEx-NotificationConflicts", "Equipment-EX encontrou um mod com conflito.\\n\\nOs seguintes mods podem causar problemas ou bloquear funcionalidades deste mod:\\n{conflicts}\\nPor favor, desabilite ou remova os mods com conflitos se você deseja utilizar este mod.");
        this.Text("Gameplay-OutfitSlots-Head", "Cabeça");
        this.Text("Gameplay-OutfitSlots-Balaclava", "Balaclava");
        this.Text("Gameplay-OutfitSlots-Mask", "Máscara");
        this.Text("Gameplay-OutfitSlots-Glasses", "Óculos");
        this.Text("Gameplay-OutfitSlots-Wreath", "Coroa");
        this.Text("Gameplay-OutfitSlots-EarLeft", "Orelha Esquerda");
        this.Text("Gameplay-OutfitSlots-EarRight", "Orelha Direita");
        this.Text("Gameplay-OutfitSlots-Neckwear", "Pescoço");
        this.Text("Gameplay-OutfitSlots-NecklaceTight", "Colar / Apertado");
        this.Text("Gameplay-OutfitSlots-NecklaceShort", "Colar / Curto");
        this.Text("Gameplay-OutfitSlots-NecklaceLong", "Colar / Longo");
        this.Text("Gameplay-OutfitSlots-TorsoUnder", "Torso / Sob");
        this.Text("Gameplay-OutfitSlots-TorsoInner", "Torso / Interno");
        this.Text("Gameplay-OutfitSlots-TorsoMiddle", "Torso / Meio");
        this.Text("Gameplay-OutfitSlots-TorsoOuter", "Torso / Exterior");
        this.Text("Gameplay-OutfitSlots-TorsoAux", "Torso / Auxiliar");
        this.Text("Gameplay-OutfitSlots-Back", "Costas");
        this.Text("Gameplay-OutfitSlots-ShoulderLeft", "Ombro Esquerdo");
        this.Text("Gameplay-OutfitSlots-ShoulderRight", "Ombro Direito");
        this.Text("Gameplay-OutfitSlots-WristLeft", "Pulso Esquerdo");
        this.Text("Gameplay-OutfitSlots-WristRight", "Pulso Direito");
        this.Text("Gameplay-OutfitSlots-HandLeft", "Mão Esquerda");
        this.Text("Gameplay-OutfitSlots-HandRight", "Mão Direita");
        this.Text("Gameplay-OutfitSlots-Waist", "Cintura");
        this.Text("Gameplay-OutfitSlots-LegsInner", "Pernas / Interno");
        this.Text("Gameplay-OutfitSlots-LegsMiddle", "Legs / Meio");
        this.Text("Gameplay-OutfitSlots-LegsOuter", "Legs / Exterior");
        this.Text("Gameplay-OutfitSlots-ThighLeft", "Coxa Esquerda");
        this.Text("Gameplay-OutfitSlots-ThighRight", "Coxa Direita");
        this.Text("Gameplay-OutfitSlots-AnkleLeft", "Tornozelo Esquerdo");
        this.Text("Gameplay-OutfitSlots-AnkleRight", "Tornozelo Direito");
        this.Text("Gameplay-OutfitSlots-Feet", "Pés");
        this.Text("Gameplay-OutfitSlots-BodyUnder", "Corpo / Sob");
        this.Text("Gameplay-OutfitSlots-BodyInner", "Corpo / Interno");
        this.Text("Gameplay-OutfitSlots-BodyMiddle", "Corpo / Meio");
        this.Text("Gameplay-OutfitSlots-BodyOuter", "Corpo / Exterior");
    }
}
