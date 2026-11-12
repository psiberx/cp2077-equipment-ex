module EquipmentEx.Localization
import Codeware.Localization.*

public class ChineseSimplified extends ModLocalizationPackage {
    protected func DefineTexts() -> Void {
        this.Text("UI-Wardrobe-NoOutfit", "无穿搭");
        this.Text("UI-Wardrobe-CurrentOutfit", "当前穿搭");
        this.Text("UI-Wardrobe-NotificationSaveSet", "输入此穿搭名称：");
        this.Text("UI-Wardrobe-NotificationReplaceSet", "具有相同此名称的穿搭已存在，是否要覆盖它？");
        this.Text("UI-Wardrobe-SearchByName", "按名称搜索");
        this.Text("UI-EquipmentEx-WardrobeItemSource", "服装来源");
        this.Text("UI-EquipmentEx-WardrobeItemSource-Description", "“背包+仓库”将仅使用当前背包和仓库的服装；“所有装备”将使用您在游戏中获得的所有物品（包括掉落和拆卸的物品）");
        this.Text("UI-EquipmentEx-WardrobeItemSource-InventoryOnly", "背包");
        this.Text("UI-EquipmentEx-WardrobeItemSource-InventoryAndStash", "背包+仓库");
        this.Text("UI-EquipmentEx-WardrobeItemSource-WardrobeStore", "所有装备");
        this.Text("UI-EquipmentEx-NotificationRequirements", "幻化衣柜系统需要：\\n- ArchiveXL {archive_xl_req} 或最新版本\\n- TweakXL {tweak_xl_req} 或最新版本\\n- Codeware {codeware_req} 或最新版本\\n\\n检测到的 ArchiveXL {archive_xl_ver} 和 TweakXL {tweak_xl_ver} 和 Codeware {codeware_ver}.\\n\\n请更新所需前置模组至最新版本");
        this.Text("UI-EquipmentEx-NotificationConflicts", "幻化衣柜系统检测到冲突模组\\n\\n以下模组可能有冲突：\\n{conflicts}\\n如果您希望继续使用此模组，请禁用或删除冲突的模组");
        this.Text("Gameplay-OutfitSlots-Head", "头部");
        this.Text("Gameplay-OutfitSlots-Balaclava", "头套");
        this.Text("Gameplay-OutfitSlots-Mask", "面罩");
        this.Text("Gameplay-OutfitSlots-Glasses", "眼镜");
        this.Text("Gameplay-OutfitSlots-Wreath", "颈圈");
        this.Text("Gameplay-OutfitSlots-EarLeft", "左耳");
        this.Text("Gameplay-OutfitSlots-EarRight", "右耳");
        this.Text("Gameplay-OutfitSlots-Neckwear", "颈部");
        this.Text("Gameplay-OutfitSlots-NecklaceTight", "项链/紧款");
        this.Text("Gameplay-OutfitSlots-NecklaceShort", "项链/短款");
        this.Text("Gameplay-OutfitSlots-NecklaceLong", "项链/长款");
        this.Text("Gameplay-OutfitSlots-TorsoUnder", "上身/底层");
        this.Text("Gameplay-OutfitSlots-TorsoInner", "上身/内层");
        this.Text("Gameplay-OutfitSlots-TorsoMiddle", "上身/中层");
        this.Text("Gameplay-OutfitSlots-TorsoOuter", "上身/外层");
        this.Text("Gameplay-OutfitSlots-TorsoAux", "上身/附着");
        this.Text("Gameplay-OutfitSlots-Back", "背部");
        this.Text("Gameplay-OutfitSlots-ShoulderLeft", "左肩");
        this.Text("Gameplay-OutfitSlots-ShoulderRight", "右肩");
        this.Text("Gameplay-OutfitSlots-WristLeft", "左手腕");
        this.Text("Gameplay-OutfitSlots-WristRight", "右手腕");
        this.Text("Gameplay-OutfitSlots-HandLeft", "左手");
        this.Text("Gameplay-OutfitSlots-HandRight", "右手");
        this.Text("Gameplay-OutfitSlots-FingersLeft", "左指");
        this.Text("Gameplay-OutfitSlots-FingersRight", "右指");
        this.Text("Gameplay-OutfitSlots-FingernailsLeft", "左指甲");
        this.Text("Gameplay-OutfitSlots-FingernailsRight", "右指甲");
        this.Text("Gameplay-OutfitSlots-Waist", "腰部");
        this.Text("Gameplay-OutfitSlots-LegsInner", "腿部/内层");
        this.Text("Gameplay-OutfitSlots-LegsMiddle", "腿部/中层");
        this.Text("Gameplay-OutfitSlots-LegsOuter", "腿部/外层");
        this.Text("Gameplay-OutfitSlots-ThighLeft", "左腿");
        this.Text("Gameplay-OutfitSlots-ThighRight", "右腿");
        this.Text("Gameplay-OutfitSlots-AnkleLeft", "左脚踝");
        this.Text("Gameplay-OutfitSlots-AnkleRight", "右脚踝");
        this.Text("Gameplay-OutfitSlots-Feet", "足部");
        this.Text("Gameplay-OutfitSlots-ToesLeft", "左脚趾");
        this.Text("Gameplay-OutfitSlots-ToesRight", "右脚趾");
        this.Text("Gameplay-OutfitSlots-ToenailsLeft", "左趾甲");
        this.Text("Gameplay-OutfitSlots-ToenailsRight", "右趾甲");
        this.Text("Gameplay-OutfitSlots-BodyUnder", "躯干/底层");
        this.Text("Gameplay-OutfitSlots-BodyInner", "躯干/内层");
        this.Text("Gameplay-OutfitSlots-BodyMiddle", "躯干/中层");
        this.Text("Gameplay-OutfitSlots-BodyOuter", "躯干/外层");
        this.Text("Gameplay-OutfitSlots-HandPropLeft", "左手道具");
        this.Text("Gameplay-OutfitSlots-HandPropRight", "右手道具");
    }
}
