module EquipmentEx.Localization
import Codeware.Localization.*

public class Russian extends ModLocalizationPackage {
    protected func DefineTexts() -> Void {
        this.Text("UI-Wardrobe-NoOutfit", "Без комплекта");
        this.Text("UI-Wardrobe-CurrentOutfit", "Текущий комплект");
        this.Text("UI-Wardrobe-NotificationSaveSet", "Введите название комплекта:");
        this.Text("UI-Wardrobe-NotificationReplaceSet", "Комплект с таким названием уже существует, вы хотите перезаписать его?");
        this.Text("UI-Wardrobe-SearchByName", "Поиск");
        this.Text("UI-EquipmentEx-WardrobeItemSource", "Источник предметов");
        this.Text("UI-EquipmentEx-WardrobeItemSource-Description", "Предпочтительный источник предметов для менеджера комплектов одежды: \"Инвентарь + Тайник\" будет показывать только предметы из инвентаря и тайника, \"Гардероб\" будет отображать все когда-либо полученные предметы.");
        this.Text("UI-EquipmentEx-WardrobeItemSource-InventoryOnly", "Инвентарь");
        this.Text("UI-EquipmentEx-WardrobeItemSource-InventoryAndStash", "Инвентарь + Тайник");
        this.Text("UI-EquipmentEx-WardrobeItemSource-WardrobeStore", "Гардероб");
        this.Text("UI-EquipmentEx-NotificationRequirements", "Для работы Equipment-EX необходимы:\\n- ArchiveXL {archive_xl_req}+\\n- TweakXL {tweak_xl_req}+\\n- Codeware {codeware_req}+\\n\\nОбнаружены ArchiveXL {archive_xl_ver}, TweakXL {tweak_xl_ver} и Codeware {codeware_ver}.\\n\\nПожалуйста, обновите все зависимости, чтобы использовать этот мод.");
        this.Text("UI-EquipmentEx-NotificationConflicts", "Equipment-EX обнаружил конфликт модов.\\n\\nСледующие моды могут вызвать проблемы или блокировать работу этого мода:\\n{conflicts}\\nПожалуйста отключите или удалите конфликтующие моды если вы хотите использовать этот мод.");
        this.Text("Gameplay-OutfitSlots-Head", "Голова");
        this.Text("Gameplay-OutfitSlots-Balaclava", "Балаклава");
        this.Text("Gameplay-OutfitSlots-Mask", "Маска");
        this.Text("Gameplay-OutfitSlots-Glasses", "Очки");
        this.Text("Gameplay-OutfitSlots-Wreath", "Венок");
        this.Text("Gameplay-OutfitSlots-EarLeft", "Левое Ухо");
        this.Text("Gameplay-OutfitSlots-EarRight", "Правое Ухо");
        this.Text("Gameplay-OutfitSlots-Neckwear", "Шейный Убор");
        this.Text("Gameplay-OutfitSlots-NecklaceTight", "Ожерелье / Узкое");
        this.Text("Gameplay-OutfitSlots-NecklaceShort", "Ожерелье / Короткое");
        this.Text("Gameplay-OutfitSlots-NecklaceLong", "Ожерелье / Длинное");
        this.Text("Gameplay-OutfitSlots-TorsoUnder", "Торс / Плотно");
        this.Text("Gameplay-OutfitSlots-TorsoInner", "Торс / Внутри");
        this.Text("Gameplay-OutfitSlots-TorsoMiddle", "Торс / Середина");
        this.Text("Gameplay-OutfitSlots-TorsoOuter", "Торс / Снаружи");
        this.Text("Gameplay-OutfitSlots-TorsoAux", "Торс / Дополнительно");
        this.Text("Gameplay-OutfitSlots-Back", "Спина");
        this.Text("Gameplay-OutfitSlots-ShoulderLeft", "Левое Плечо");
        this.Text("Gameplay-OutfitSlots-ShoulderRight", "Правое Плечо");
        this.Text("Gameplay-OutfitSlots-WristLeft", "Левое Запястье");
        this.Text("Gameplay-OutfitSlots-WristRight", "Правое Запястье");
        this.Text("Gameplay-OutfitSlots-HandLeft", "Левая Рука");
        this.Text("Gameplay-OutfitSlots-HandRight", "Правая Рука");
        this.Text("Gameplay-OutfitSlots-FingersLeft", "Пальцы левой руки");
        this.Text("Gameplay-OutfitSlots-FingersRight", "Пальцы правой руки");
        this.Text("Gameplay-OutfitSlots-FingernailsLeft", "Левые Ногти левой руки");
        this.Text("Gameplay-OutfitSlots-FingernailsRight", "Ногти правой руки");
        this.Text("Gameplay-OutfitSlots-Waist", "Талия");
        this.Text("Gameplay-OutfitSlots-LegsInner", "Ноги / Внутри");
        this.Text("Gameplay-OutfitSlots-LegsMiddle", "Ноги / Середина");
        this.Text("Gameplay-OutfitSlots-LegsOuter", "Ноги / Снаружи");
        this.Text("Gameplay-OutfitSlots-ThighLeft", "Левое Бедро");
        this.Text("Gameplay-OutfitSlots-ThighRight", "Правое Бедро");
        this.Text("Gameplay-OutfitSlots-AnkleLeft", "Левая Лодыжка");
        this.Text("Gameplay-OutfitSlots-AnkleRight", "Правая Лодыжка");
        this.Text("Gameplay-OutfitSlots-Feet", "Стопы");
        this.Text("Gameplay-OutfitSlots-ToesLeft", "Пальцы левой ноги");
        this.Text("Gameplay-OutfitSlots-ToesRight", "Пальцы правой ноги");
        this.Text("Gameplay-OutfitSlots-ToenailsLeft", "Ногти левой ноги");
        this.Text("Gameplay-OutfitSlots-ToenailsRight", "Ногти правой ноги");
        this.Text("Gameplay-OutfitSlots-BodyUnder", "Тело / Плотно");
        this.Text("Gameplay-OutfitSlots-BodyInner", "Тело / Внутри");
        this.Text("Gameplay-OutfitSlots-BodyMiddle", "Тело / Середина");
        this.Text("Gameplay-OutfitSlots-BodyOuter", "Тело / Снаружи");
        this.Text("Gameplay-OutfitSlots-HandPropLeft", "Реквизит для левой руки");
        this.Text("Gameplay-OutfitSlots-HandPropRight", "Реквизит для правой руки");
    }
}
