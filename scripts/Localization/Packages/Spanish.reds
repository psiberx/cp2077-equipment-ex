module EquipmentEx.Localization
import Codeware.Localization.*

public class Spanish extends ModLocalizationPackage {
    protected func DefineTexts() -> Void {
        this.Text("UI-Wardrobe-NoOutfit", "Sin conjunto");
        this.Text("UI-Wardrobe-CurrentOutfit", "Conjunto actual");
        this.Text("UI-Wardrobe-NotificationSaveSet", "Escribe el nombre del conjunto");
        this.Text("UI-Wardrobe-NotificationReplaceSet", "Un conjunto con este nombre ya existe, ¿deseas sobreescribirlo?");
        this.Text("UI-Wardrobe-SearchByName", "Buscar por nombre");
        this.Text("UI-EquipmentEx-WardrobeItemSource", "Fuente de los objetos");
        this.Text("UI-EquipmentEx-WardrobeItemSource-Description", "Preferencia de la fuente de los objetos para el gerente de conjuntos: \"Inventario y alijo sólo usará los objetos actuales en tu inventario y el alijo, \"Armario usará todos los objetos que hayas obtenido en el juego (incluidos los caídos y desmontados).");
        this.Text("UI-EquipmentEx-WardrobeItemSource-InventoryOnly", "Inventario");
        this.Text("UI-EquipmentEx-WardrobeItemSource-InventoryAndStash", "Inventario y alijo");
        this.Text("UI-EquipmentEx-WardrobeItemSource-WardrobeStore", "Armario");
        this.Text("UI-EquipmentEx-NotificationRequirements", "Equipment-EX requiere:\\n- ArchiveXL {archive_xl_req} o superior\\n- TweakXL {tweak_xl_req} o superior\\n- Codeware {codeware_req} o mayor\\n\\nDetectado ArchiveXL {archive_xl_ver}, TweakXL {tweak_xl_ver} y Codeware {codeware_ver}.\\n\\nPor favor actualiza estas dependencias para usar el mod.");
        this.Text("UI-EquipmentEx-NotificationConflicts", "Equipment-EX ha detectado un mod causando conflicto.\\n\\nLos siguientes mods pueden causar problemas o bloquear la funcionalidad de este mod:\\n{conflicts}\\nPor favor, deshabilita o elimina los mods en conflicto si deseas usar este mod.");
        this.Text("Gameplay-OutfitSlots-Head", "Cabeza");
        this.Text("Gameplay-OutfitSlots-Balaclava", "Pasamontañas");
        this.Text("Gameplay-OutfitSlots-Mask", "Máscara");
        this.Text("Gameplay-OutfitSlots-Glasses", "Gafas");
        this.Text("Gameplay-OutfitSlots-Wreath", "Corona");
        this.Text("Gameplay-OutfitSlots-EarLeft", "Oreja izquierda");
        this.Text("Gameplay-OutfitSlots-EarRight", "Oreja derecha");
        this.Text("Gameplay-OutfitSlots-Neckwear", "Cuello");
        this.Text("Gameplay-OutfitSlots-NecklaceTight", "Collar / Ajustado");
        this.Text("Gameplay-OutfitSlots-NecklaceShort", "Collar / Corto");
        this.Text("Gameplay-OutfitSlots-NecklaceLong", "Collar / Largo");
        this.Text("Gameplay-OutfitSlots-TorsoUnder", "Torso / Debajo");
        this.Text("Gameplay-OutfitSlots-TorsoInner", "Torso / Interior");
        this.Text("Gameplay-OutfitSlots-TorsoMiddle", "Torso / Medio");
        this.Text("Gameplay-OutfitSlots-TorsoOuter", "Torso / Exterior");
        this.Text("Gameplay-OutfitSlots-TorsoAux", "Torso / Auxiliar");
        this.Text("Gameplay-OutfitSlots-Back", "Espalda");
        this.Text("Gameplay-OutfitSlots-ShoulderLeft", "Hombro izquierdo");
        this.Text("Gameplay-OutfitSlots-ShoulderRight", "Hombro derecho");
        this.Text("Gameplay-OutfitSlots-WristLeft", "Muñeca izquierda");
        this.Text("Gameplay-OutfitSlots-WristRight", "Muñeca derecha");
        this.Text("Gameplay-OutfitSlots-HandLeft", "Mano izquierda");
        this.Text("Gameplay-OutfitSlots-HandRight", "Mano derecha");
        this.Text("Gameplay-OutfitSlots-FingersLeft", "Dedos de mano izquierda");
        this.Text("Gameplay-OutfitSlots-FingersRight", "Dedos de mano derecha");
        this.Text("Gameplay-OutfitSlots-FingernailsLeft", "Uñas de mano izquierda");
        this.Text("Gameplay-OutfitSlots-FingernailsRight", "Uñas de mano derecha");
        this.Text("Gameplay-OutfitSlots-Waist", "Cintura");
        this.Text("Gameplay-OutfitSlots-LegsInner", "Piernas / Interior");
        this.Text("Gameplay-OutfitSlots-LegsMiddle", "Piernas / Medio");
        this.Text("Gameplay-OutfitSlots-LegsOuter", "Piernas / Exterior");
        this.Text("Gameplay-OutfitSlots-ThighLeft", "Muslo izquierdo");
        this.Text("Gameplay-OutfitSlots-ThighRight", "Muslo derecho");
        this.Text("Gameplay-OutfitSlots-AnkleLeft", "Tobillo izquierdo");
        this.Text("Gameplay-OutfitSlots-AnkleRight", "Tobillo derecho");
        this.Text("Gameplay-OutfitSlots-Feet", "Pies");
        this.Text("Gameplay-OutfitSlots-ToesLeft", "Dedos de pie izquierdo");
        this.Text("Gameplay-OutfitSlots-ToesRight", "Dedos de pie derecho");
        this.Text("Gameplay-OutfitSlots-ToenailsLeft", "Uñas de pie izquierdo");
        this.Text("Gameplay-OutfitSlots-ToenailsRight", "Uñas de pie derecho");
        this.Text("Gameplay-OutfitSlots-BodyUnder", "Cuerpo / Debajo");
        this.Text("Gameplay-OutfitSlots-BodyInner", "Cuerpo / Interior");
        this.Text("Gameplay-OutfitSlots-BodyMiddle", "Cuerpo / Medio");
        this.Text("Gameplay-OutfitSlots-BodyOuter", "Cuerpo / Exterior");
        this.Text("Gameplay-OutfitSlots-HandPropLeft", "Accesorio de mano izquierda");
        this.Text("Gameplay-OutfitSlots-HandPropRight", "Accesorio de mano derecha");
    }
}
