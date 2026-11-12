module EquipmentEx.Localization
import Codeware.Localization.*

public class Arabic extends ModLocalizationPackage {
    protected func DefineTexts() -> Void {
        this.Text("UI-Wardrobe-NoOutfit", "لا يوجد زي");
        this.Text("UI-Wardrobe-CurrentOutfit", "الزي الحالي");
        this.Text("UI-Wardrobe-NotificationSaveSet", "أدخل اسم الزي:");
        this.Text("UI-Wardrobe-NotificationReplaceSet", "زي بهذا الاسم موجود بالفعل ، هل تريد الاستبدال؟");
        this.Text("UI-Wardrobe-SearchByName", "البحث عن طريق الإسم");
        this.Text("UI-EquipmentEx-WardrobeItemSource", "مصدر العنصر");
        this.Text("UI-EquipmentEx-WardrobeItemSource-Description", "المصدر المفضل لعناصر مدير الزي: \"Inventory + Stash\" سيستخدم فقط العناصر الحالية في المخزون ومخابئ المخزون الخاصة بك, \"Wardrobe Store\" سيستخدم كل عنصر حصلت عليه في اللعبة (بما في ذلك العناصر التي تم إسقاطها وتفكيكها).");
        this.Text("UI-EquipmentEx-WardrobeItemSource-InventoryOnly", "المخزون");
        this.Text("UI-EquipmentEx-WardrobeItemSource-InventoryAndStash", "المخزون + Stash");
        this.Text("UI-EquipmentEx-WardrobeItemSource-WardrobeStore", "متجر خزانة الزي");
        this.Text("UI-EquipmentEx-NotificationRequirements", "يتطلب معدات-إكس التالي:\\n- ArchiveXL {archive_xl_req} أو أعلى\\n- TweakXL {tweak_xl_req} أو أعلى\\n- Codeware {codeware_req} أو أعلى\\n\\nتم اكتشاف ArchiveXL {archive_xl_ver} و TweakXL {tweak_xl_ver} و Codeware {codeware_ver}.\\n\\nيرجى تحديث التبعيات لاستخدام هذا التعديل.");
        this.Text("UI-EquipmentEx-NotificationConflicts", "اكتشفت معدات-إكس تعديلًا متضاربًا.\\n\\nقد تتسبب التعديلات التالية في حدوث مشكلات أو تمنع وظيفة هذا التعديل:\\n{conflicts}\\nيرجى تعطيل أو إزالة التعديلات المتضاربة إذا كنت ترغب في استخدام هذا التعديل.");
        this.Text("Gameplay-OutfitSlots-Head", "الرأس");
        this.Text("Gameplay-OutfitSlots-Balaclava", "قناع بالاكلافا");
        this.Text("Gameplay-OutfitSlots-Mask", "قناع");
        this.Text("Gameplay-OutfitSlots-Glasses", "نظارات");
        this.Text("Gameplay-OutfitSlots-Wreath", "إكليل");
        this.Text("Gameplay-OutfitSlots-EarLeft", "الأذن اليسرى");
        this.Text("Gameplay-OutfitSlots-EarRight", "الأذن اليمنى");
        this.Text("Gameplay-OutfitSlots-Neckwear", "الرقبة");
        this.Text("Gameplay-OutfitSlots-NecklaceTight", "قلادة / ضيقة");
        this.Text("Gameplay-OutfitSlots-NecklaceShort", "قلادة / قصيرة");
        this.Text("Gameplay-OutfitSlots-NecklaceLong", "قلادة / طويلة");
        this.Text("Gameplay-OutfitSlots-TorsoUnder", "الجذع / سفلي");
        this.Text("Gameplay-OutfitSlots-TorsoInner", "الجذع / داخلي");
        this.Text("Gameplay-OutfitSlots-TorsoMiddle", "الجذع / وسطي");
        this.Text("Gameplay-OutfitSlots-TorsoOuter", "الجذع / خارجي");
        this.Text("Gameplay-OutfitSlots-TorsoAux", "الجذع / مساعد");
        this.Text("Gameplay-OutfitSlots-Back", "الظهر");
        this.Text("Gameplay-OutfitSlots-ShoulderLeft", "الكتف الأيسر");
        this.Text("Gameplay-OutfitSlots-ShoulderRight", "الكتف الأيمن");
        this.Text("Gameplay-OutfitSlots-WristLeft", "معصم اليد اليسرى");
        this.Text("Gameplay-OutfitSlots-WristRight", "معصم اليد اليمنى");
        this.Text("Gameplay-OutfitSlots-HandLeft", "اليد اليسرى");
        this.Text("Gameplay-OutfitSlots-HandRight", "اليد اليمنى");
        this.Text("Gameplay-OutfitSlots-FingersLeft", "أصابع اليد اليسرى");
        this.Text("Gameplay-OutfitSlots-FingersRight", "أصابع اليد اليمنى");
        this.Text("Gameplay-OutfitSlots-FingernailsLeft", "أظافر اليد اليسرى");
        this.Text("Gameplay-OutfitSlots-FingernailsRight", "أظافر اليد اليمنى");
        this.Text("Gameplay-OutfitSlots-Waist", "الخصر");
        this.Text("Gameplay-OutfitSlots-LegsInner", "الساقين / داخلي");
        this.Text("Gameplay-OutfitSlots-LegsMiddle", "الساقين / وسطي");
        this.Text("Gameplay-OutfitSlots-LegsOuter", "الساقين / خارجي");
        this.Text("Gameplay-OutfitSlots-ThighLeft", "الفخذ الأيسر");
        this.Text("Gameplay-OutfitSlots-ThighRight", "الفخذ الأيمن");
        this.Text("Gameplay-OutfitSlots-AnkleLeft", "الكاحل الأيسر");
        this.Text("Gameplay-OutfitSlots-AnkleRight", "الكاحل الأيمن");
        this.Text("Gameplay-OutfitSlots-Feet", "الأقدام");
        this.Text("Gameplay-OutfitSlots-ToesLeft", "أصابع القدم اليسرى");
        this.Text("Gameplay-OutfitSlots-ToesRight", "أصابع القدم اليمنى");
        this.Text("Gameplay-OutfitSlots-ToenailsLeft", "أظافر القدم اليسرى");
        this.Text("Gameplay-OutfitSlots-ToenailsRight", "أظافر القدم اليمنى");
        this.Text("Gameplay-OutfitSlots-BodyUnder", "الجسم / سفلي");
        this.Text("Gameplay-OutfitSlots-BodyInner", "الجسم / داخلي");
        this.Text("Gameplay-OutfitSlots-BodyMiddle", "الجسم / وسطي");
        this.Text("Gameplay-OutfitSlots-BodyOuter", "الجسم / خارجي");
        this.Text("Gameplay-OutfitSlots-HandPropLeft", "دعامة اليد اليسرى");
        this.Text("Gameplay-OutfitSlots-HandPropRight", "دعامة اليد اليمنى");
    }
}
