module EquipmentEx.Localization
import Codeware.Localization.*

public class Korean extends ModLocalizationPackage {
    protected func DefineTexts() -> Void {
        this.Text("UI-Wardrobe-NoOutfit", "복장 없음");
        this.Text("UI-Wardrobe-CurrentOutfit", "현재 복장");
        this.Text("UI-Wardrobe-NotificationSaveSet", "복장 이름 입력");
        this.Text("UI-Wardrobe-NotificationReplaceSet", "이미 이름이 있는 복장입니다. 덮어씌우겠습니까?");
        this.Text("UI-Wardrobe-SearchByName", "이름으로 검색");
        this.Text("UI-EquipmentEx-WardrobeItemSource", "아이템 소스");
        this.Text("UI-EquipmentEx-WardrobeItemSource-Description", "복장 관리자가 선호하는 아이템 소스: \"인벤토리 + 보관\"은 인벤토리 내의 현재 아이템과 보관한 것만을 사용하며, \"옷장 상점\"은 게임하면서 얻은 아이템(버리거나 분해된 아이템 포함)을 전부 사용합니다.");
        this.Text("UI-EquipmentEx-WardrobeItemSource-InventoryAndStash", "인벤토리 + 보관");
        this.Text("UI-EquipmentEx-WardrobeItemSource-WardrobeStore", "옷장 상점");
        this.Text("UI-EquipmentEx-NotificationRequirements", "Equipment-EX에서 요구:\\n- ArchiveXL {archive_xl_req} 버전 또는 더 높은 버전\\n- TweakXL {tweak_xl_req} 버전 또는 더 높은 버전\\n\\nArchiveXL {archive_xl_ver} 버전과 TweakXL {tweak_xl_ver} 버전을 감지했습니다.\\n\\n선행되는 모드를 업데이트하세요.");
        this.Text("UI-EquipmentEx-NotificationConflicts", "Equipment-EX에서 충돌하는 모드를 발견했습니다.\\n\\n다음과 같은 모드가 문제를 일으킵니다:\\n{conflicts}\\n문제 되는 모드를 비활성화하거나 삭제하세요.");
        this.Text("Gameplay-OutfitSlots-Head", "머리");
        this.Text("Gameplay-OutfitSlots-Balaclava", "목토시");
        this.Text("Gameplay-OutfitSlots-Mask", "마스크");
        this.Text("Gameplay-OutfitSlots-Glasses", "안경");
        this.Text("Gameplay-OutfitSlots-Wreath", "화관");
        this.Text("Gameplay-OutfitSlots-EarLeft", "왼쪽 귀");
        this.Text("Gameplay-OutfitSlots-EarRight", "오른쪽 귀");
        this.Text("Gameplay-OutfitSlots-Neckwear", "목도리");
        this.Text("Gameplay-OutfitSlots-NecklaceTight", "목걸이 / 달라붙음");
        this.Text("Gameplay-OutfitSlots-NecklaceShort", "목걸이 / 짧음");
        this.Text("Gameplay-OutfitSlots-NecklaceLong", "목걸이 / 긺");
        this.Text("Gameplay-OutfitSlots-TorsoUnder", "몸통 / 아래");
        this.Text("Gameplay-OutfitSlots-TorsoInner", "몸통 / 안쪽");
        this.Text("Gameplay-OutfitSlots-TorsoMiddle", "몸통 / 중간");
        this.Text("Gameplay-OutfitSlots-TorsoOuter", "몸통 / 바깥쪽");
        this.Text("Gameplay-OutfitSlots-TorsoAux", "몸통 / 보조");
        this.Text("Gameplay-OutfitSlots-Back", "등");
        this.Text("Gameplay-OutfitSlots-ShoulderLeft", "왼쪽 어깨");
        this.Text("Gameplay-OutfitSlots-ShoulderRight", "오른쪽 어깨");
        this.Text("Gameplay-OutfitSlots-WristLeft", "왼쪽 손목");
        this.Text("Gameplay-OutfitSlots-WristRight", "오른쪽 손목");
        this.Text("Gameplay-OutfitSlots-HandLeft", "왼손");
        this.Text("Gameplay-OutfitSlots-HandRight", "오른손");
        this.Text("Gameplay-OutfitSlots-FingersLeft", "왼쪽 손가락");
        this.Text("Gameplay-OutfitSlots-FingersRight", "오른쪽 손가락");
        this.Text("Gameplay-OutfitSlots-FingernailsLeft", "왼쪽 손톱");
        this.Text("Gameplay-OutfitSlots-FingernailsRight", "오른쪽 손톱");
        this.Text("Gameplay-OutfitSlots-Waist", "허리");
        this.Text("Gameplay-OutfitSlots-LegsInner", "다리 / 안쪽");
        this.Text("Gameplay-OutfitSlots-LegsMiddle", "다리 / 중간");
        this.Text("Gameplay-OutfitSlots-LegsOuter", "다리 / 바깥쪽");
        this.Text("Gameplay-OutfitSlots-ThighLeft", "왼쪽 허벅지");
        this.Text("Gameplay-OutfitSlots-ThighRight", "오른쪽 허벅지");
        this.Text("Gameplay-OutfitSlots-AnkleLeft", "왼쪽 발목");
        this.Text("Gameplay-OutfitSlots-AnkleRight", "오른쪽 발목");
        this.Text("Gameplay-OutfitSlots-Feet", "발");
        this.Text("Gameplay-OutfitSlots-ToesLeft", "왼쪽 발가락");
        this.Text("Gameplay-OutfitSlots-ToesRight", "오른쪽 발가락");
        this.Text("Gameplay-OutfitSlots-ToenailsLeft", "왼쪽 발톱");
        this.Text("Gameplay-OutfitSlots-ToenailsRight", "오른쪽 발톱");
        this.Text("Gameplay-OutfitSlots-BodyUnder", "몸 / 아래");
        this.Text("Gameplay-OutfitSlots-BodyInner", "몸 / 안쪽");
        this.Text("Gameplay-OutfitSlots-BodyMiddle", "몸 / 중간");
        this.Text("Gameplay-OutfitSlots-BodyOuter", "몸 / 바깥쪽");
        this.Text("Gameplay-OutfitSlots-HandPropLeft", "왼손 소품");
        this.Text("Gameplay-OutfitSlots-HandPropRight", "오른손 소품");
    }
}
