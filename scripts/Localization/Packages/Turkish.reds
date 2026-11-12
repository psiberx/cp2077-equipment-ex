module EquipmentEx.Localization
import Codeware.Localization.*

public class Turkish extends ModLocalizationPackage {
    protected func DefineTexts() -> Void {
        this.Text("UI-Wardrobe-NoOutfit", "Kıyafet yok");
        this.Text("UI-Wardrobe-CurrentOutfit", "Mevcut Kıyafet");
        this.Text("UI-Wardrobe-NotificationSaveSet", "Kıyafet adı gir:");
        this.Text("UI-Wardrobe-NotificationReplaceSet", "Bu isime sahip bir kıyafet zaten mevcut, üzerine yazmak ister misiniz?");
        this.Text("UI-Wardrobe-SearchByName", "İsime göre ara");
        this.Text("UI-EquipmentEx-WardrobeItemSource", "Eşya Kaynağı");
        this.Text("UI-EquipmentEx-WardrobeItemSource-Description", "Kıyafet yöneticisi için tercih edilen eşya kaynağı: \"Envanter + Zula\" sadece envanter ve zulalarınızdaki mevcut eşyaları kullanacaktır, \"Gardırop Mağazası\" oyunda elde ettiğiniz her eşyayı kullanacaktır (bırakılan ve sökülen eşyalar dahil).");
        this.Text("UI-EquipmentEx-WardrobeItemSource-InventoryOnly", "Envanter");
        this.Text("UI-EquipmentEx-WardrobeItemSource-InventoryAndStash", "Envanter + Zula");
        this.Text("UI-EquipmentEx-WardrobeItemSource-WardrobeStore", "Gardırop Mağazası");
        this.Text("UI-EquipmentEx-NotificationRequirements", "Equipment-EX gereksinimleri:\\n- ArchiveXL {archive_xl_req} veya daha üstü\\n- TweakXL {tweak_xl_req} veya daha üstü\\n- Codeware {codeware_req} veya daha üstü\\n\\nAlgılandı ArchiveXL {archive_xl_ver}, TweakXL {tweak_xl_ver} ve Codeware {codeware_ver}.\\n\\nBu modu kullanmak için lütfen gereksinimleri güncelleyin.");
        this.Text("UI-EquipmentEx-NotificationConflicts", "Equipment-EX çakışan bir mod tespit etti.\\n\\nAşağıdaki modlar sorunlara neden olabilir veya bu modun işlevselliğini engelleyebilir:\\n{conflicts}\\nBu modu kullanmak istiyorsanız lütfen çakışan modları devre dışı bırakın veya kaldırın.");
        this.Text("Gameplay-OutfitSlots-Head", "Baş");
        this.Text("Gameplay-OutfitSlots-Balaclava", "Kar Maskesi");
        this.Text("Gameplay-OutfitSlots-Mask", "Maske");
        this.Text("Gameplay-OutfitSlots-Eyes", "Gözler");
        this.Text("Gameplay-OutfitSlots-EyeLeft", "Sol Göz");
        this.Text("Gameplay-OutfitSlots-EyeRight", "Sağ Göz");
        this.Text("Gameplay-OutfitSlots-Glasses", "Gözlükler");
        this.Text("Gameplay-OutfitSlots-Wreath", "Çelenk");
        this.Text("Gameplay-OutfitSlots-EarLeft", "Sol Kulak");
        this.Text("Gameplay-OutfitSlots-EarRight", "Sağ Kulak");
        this.Text("Gameplay-OutfitSlots-Neckwear", "Boyunluk");
        this.Text("Gameplay-OutfitSlots-NecklaceTight", "Kolye / Dar");
        this.Text("Gameplay-OutfitSlots-NecklaceShort", "Kolye / Kısa");
        this.Text("Gameplay-OutfitSlots-NecklaceLong", "Kolye / Uzun");
        this.Text("Gameplay-OutfitSlots-TorsoUnder", "Gövde / Alt");
        this.Text("Gameplay-OutfitSlots-TorsoInner", "Gövde / İç");
        this.Text("Gameplay-OutfitSlots-TorsoMiddle", "Gövde / Orta");
        this.Text("Gameplay-OutfitSlots-TorsoOuter", "Gövde / Dış");
        this.Text("Gameplay-OutfitSlots-TorsoAux", "Gövde / Soket");
        this.Text("Gameplay-OutfitSlots-Back", "Sırt");
        this.Text("Gameplay-OutfitSlots-ShoulderLeft", "Sol Omuz");
        this.Text("Gameplay-OutfitSlots-ShoulderRight", "Sağ Omuz");
        this.Text("Gameplay-OutfitSlots-ElbowLeft", "Sol Dirsek");
        this.Text("Gameplay-OutfitSlots-ElbowRight", "Sağ Dirsek");
        this.Text("Gameplay-OutfitSlots-WristLeft", "Sol El Bileği");
        this.Text("Gameplay-OutfitSlots-WristRight", "Sağ El Bileği");
        this.Text("Gameplay-OutfitSlots-Hands", "Eller");
        this.Text("Gameplay-OutfitSlots-HandLeft", "Sol El");
        this.Text("Gameplay-OutfitSlots-HandRight", "Sağ El");
        this.Text("Gameplay-OutfitSlots-FingersLeft", "Sol El Parmakları");
        this.Text("Gameplay-OutfitSlots-FingersRight", "Sağ El Parmakları");
        this.Text("Gameplay-OutfitSlots-FingernailsLeft", "Sol El Tırnakları");
        this.Text("Gameplay-OutfitSlots-FingernailsRight", "Sağ El Tırnakları");
        this.Text("Gameplay-OutfitSlots-Waist", "Bel");
        this.Text("Gameplay-OutfitSlots-LegsInner", "Bacaklar / İç");
        this.Text("Gameplay-OutfitSlots-LegsMiddle", "Bacaklar / Orta");
        this.Text("Gameplay-OutfitSlots-LegsOuter", "Bacaklar / Dış");
        this.Text("Gameplay-OutfitSlots-ThighLeft", "Sol Kalça");
        this.Text("Gameplay-OutfitSlots-ThighRight", "Sağ Kalça");
        this.Text("Gameplay-OutfitSlots-KneeLeft", "Sol Diz");
        this.Text("Gameplay-OutfitSlots-KneeRight", "Sağ Diz");
        this.Text("Gameplay-OutfitSlots-AnkleLeft", "Sol Ayak Bileği");
        this.Text("Gameplay-OutfitSlots-AnkleRight", "Sağ Ayak Bileği");
        this.Text("Gameplay-OutfitSlots-Feet", "Ayak");
        this.Text("Gameplay-OutfitSlots-ToesLeft", "Sol Ayak Parmakları");
        this.Text("Gameplay-OutfitSlots-ToesRight", "Sağ Ayak Parmakları");
        this.Text("Gameplay-OutfitSlots-ToenailsLeft", "Sol Ayak Tırnakları");
        this.Text("Gameplay-OutfitSlots-ToenailsRight", "Sağ Ayak Tırnakları");
        this.Text("Gameplay-OutfitSlots-BodyUnder", "Beden / Alt");
        this.Text("Gameplay-OutfitSlots-BodyInner", "Beden / İç");
        this.Text("Gameplay-OutfitSlots-BodyMiddle", "Beden / Orta");
        this.Text("Gameplay-OutfitSlots-BodyOuter", "Beden / Dış");
        this.Text("Gameplay-OutfitSlots-HandPropLeft", "Sol El Aksesuarı");
        this.Text("Gameplay-OutfitSlots-HandPropRight", "Sağ El Aksesuarı");
    }
}
