module EquipmentEx.Localization
import Codeware.Localization.*

public class English extends ModLocalizationPackage {
    protected func DefineTexts() -> Void {
        this.Text("UI-Wardrobe-NoOutfit", "No outfit");
        this.Text("UI-Wardrobe-CurrentOutfit", "Current outfit");
        this.Text("UI-Wardrobe-NotificationSaveSet", "Enter outfit name");
        this.Text("UI-Wardrobe-NotificationReplaceSet", "Outfit with this name already exists, do you want to overwrite it?");
        this.Text("UI-Wardrobe-SearchByName", "Search by name");
        this.Text("UI-Wardrobe-OverwriteWarning", "Overwriting existing outfit");
        this.Text("UI-EquipmentEx-WardrobeItemSource", "Item Source");
        this.Text("UI-EquipmentEx-WardrobeItemSource-Description", "Preferred source of items for outfit manager: \"Inventory + Stash\" will only use the current items in your inventory and stashes, \"Wardrobe Store\" will use every item you have ever obtained in the game (including dropped and disassembled items).");
        this.Text("UI-EquipmentEx-WardrobeItemSource-InventoryOnly", "Inventory");
        this.Text("UI-EquipmentEx-WardrobeItemSource-InventoryAndStash", "Inventory + Stash");
        this.Text("UI-EquipmentEx-WardrobeItemSource-WardrobeStore", "Wardrobe Store");
        this.Text("UI-EquipmentEx-NotificationRequirements", "Equipment-EX requires:\\n- ArchiveXL {archive_xl_req} or higher\\n- TweakXL {tweak_xl_req} or higher\\n- Codeware {codeware_req} or higher\\n\\nDetected ArchiveXL {archive_xl_ver}, TweakXL {tweak_xl_ver} and Codeware {codeware_ver}.\\n\\nPlease update the dependencies to use this mod.");
        this.Text("UI-EquipmentEx-NotificationConflicts", "Equipment-EX has detected a conflicting mod.\\n\\nThe following mods may cause problems or block the functionality of this mod:\\n{conflicts}\\nPlease disable or remove conflicting mods if you wish to use this mod.");
        this.Text("Gameplay-OutfitSlots-Head", "Head");
        this.Text("Gameplay-OutfitSlots-Balaclava", "Balaclava");
        this.Text("Gameplay-OutfitSlots-Mask", "Mask");
        this.Text("Gameplay-OutfitSlots-Eyes", "Eyes");
        this.Text("Gameplay-OutfitSlots-EyeLeft", "Left Eye");
        this.Text("Gameplay-OutfitSlots-EyeRight", "Right Eye");
        this.Text("Gameplay-OutfitSlots-Glasses", "Glasses");
        this.Text("Gameplay-OutfitSlots-Wreath", "Wreath");
        this.Text("Gameplay-OutfitSlots-EarLeft", "Left Ear");
        this.Text("Gameplay-OutfitSlots-EarRight", "Right Ear");
        this.Text("Gameplay-OutfitSlots-Neckwear", "Neckwear");
        this.Text("Gameplay-OutfitSlots-NecklaceTight", "Necklace / Tight");
        this.Text("Gameplay-OutfitSlots-NecklaceShort", "Necklace / Short");
        this.Text("Gameplay-OutfitSlots-NecklaceLong", "Necklace / Long");
        this.Text("Gameplay-OutfitSlots-TorsoUnder", "Torso / Under");
        this.Text("Gameplay-OutfitSlots-TorsoInner", "Torso / Inner");
        this.Text("Gameplay-OutfitSlots-TorsoMiddle", "Torso / Middle");
        this.Text("Gameplay-OutfitSlots-TorsoOuter", "Torso / Outer");
        this.Text("Gameplay-OutfitSlots-TorsoAux", "Torso / Aux");
        this.Text("Gameplay-OutfitSlots-Back", "Back");
        this.Text("Gameplay-OutfitSlots-ShoulderLeft", "Left Shoulder");
        this.Text("Gameplay-OutfitSlots-ShoulderRight", "Right Shoulder");
        this.Text("Gameplay-OutfitSlots-ElbowLeft", "Left Elbow");
        this.Text("Gameplay-OutfitSlots-ElbowRight", "Right Elbow");
        this.Text("Gameplay-OutfitSlots-WristLeft", "Left Wrist");
        this.Text("Gameplay-OutfitSlots-WristRight", "Right Wrist");
        this.Text("Gameplay-OutfitSlots-Hands", "Hands");
        this.Text("Gameplay-OutfitSlots-HandLeft", "Left Hand");
        this.Text("Gameplay-OutfitSlots-HandRight", "Right Hand");
        this.Text("Gameplay-OutfitSlots-FingersLeft", "Left Fingers");
        this.Text("Gameplay-OutfitSlots-FingersRight", "Right Fingers");
        this.Text("Gameplay-OutfitSlots-FingernailsLeft", "Left Fingernails");
        this.Text("Gameplay-OutfitSlots-FingernailsRight", "Right Fingernails");
        this.Text("Gameplay-OutfitSlots-Waist", "Waist");
        this.Text("Gameplay-OutfitSlots-LegsInner", "Legs / Inner");
        this.Text("Gameplay-OutfitSlots-LegsMiddle", "Legs / Middle");
        this.Text("Gameplay-OutfitSlots-LegsOuter", "Legs / Outer");
        this.Text("Gameplay-OutfitSlots-ThighLeft", "Left Thigh");
        this.Text("Gameplay-OutfitSlots-ThighRight", "Right Thigh");
        this.Text("Gameplay-OutfitSlots-KneeLeft", "Left Knee");
        this.Text("Gameplay-OutfitSlots-KneeRight", "Right Knee");
        this.Text("Gameplay-OutfitSlots-AnkleLeft", "Left Ankle");
        this.Text("Gameplay-OutfitSlots-AnkleRight", "Right Ankle");
        this.Text("Gameplay-OutfitSlots-Feet", "Feet");
        this.Text("Gameplay-OutfitSlots-ToesLeft", "Left Toes");
        this.Text("Gameplay-OutfitSlots-ToesRight", "Right Toes");
        this.Text("Gameplay-OutfitSlots-ToenailsLeft", "Left Toenails");
        this.Text("Gameplay-OutfitSlots-ToenailsRight", "Right Toenails");
        this.Text("Gameplay-OutfitSlots-BodyUnder", "Body / Under");
        this.Text("Gameplay-OutfitSlots-BodyInner", "Body / Inner");
        this.Text("Gameplay-OutfitSlots-BodyMiddle", "Body / Middle");
        this.Text("Gameplay-OutfitSlots-BodyOuter", "Body / Outer");
        this.Text("Gameplay-OutfitSlots-HandPropLeft", "Left Hand Prop");
        this.Text("Gameplay-OutfitSlots-HandPropRight", "Right Hand Prop");
    }
}
