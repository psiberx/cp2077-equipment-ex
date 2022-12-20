module EquipmentEx

class RegisterAppearanceSuffixes extends ScriptableTweak {
    protected func OnApply() -> Void {
        let appearanceSuffixes = OutfitConfig.AppearanceSuffixes();

        for appearanceSuffix in appearanceSuffixes {
            TweakDBManager.CreateRecord(appearanceSuffix.suffixID, n"ItemsFactoryAppearanceSuffixBase_Record");
            TweakDBManager.SetFlat(appearanceSuffix.suffixID + t".scriptedSystem", appearanceSuffix.system);
            TweakDBManager.SetFlat(appearanceSuffix.suffixID + t".scriptedFunction", appearanceSuffix.method);
            TweakDBManager.UpdateRecord(appearanceSuffix.suffixID);
            TweakDBManager.RegisterName(appearanceSuffix.suffixName);
        }

        let suffixOrderID = t"itemsFactoryAppearanceSuffix.ItemsFactoryAppearanceSuffixOrderDefault";
        let suffixOrderList = TweakDBInterface.GetForeignKeyArray(suffixOrderID + t".appearanceSuffixes");

        for appearanceSuffix in appearanceSuffixes {
            if !ArrayContains(suffixOrderList, appearanceSuffix.suffixID) {
                ArrayPush(suffixOrderList, appearanceSuffix.suffixID);
            }
        }

        TweakDBManager.SetFlat(suffixOrderID + t".appearanceSuffixes", suffixOrderList);
        TweakDBManager.UpdateRecord(suffixOrderID);
    }
}
