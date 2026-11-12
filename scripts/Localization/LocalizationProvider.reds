module EquipmentEx.Localization
import Codeware.Localization.*

// Resolves localization packages by game language. Packages are created on demand rather than
// cached: the localization system asks for one only while rebuilding translations.
//
// Keys a translation is missing are taken from the fallback package, so partial translations
// are valid and do not need to be completed before being added.
public class LocalizationProvider extends ModLocalizationProvider {
    public func GetPackage(language: CName) -> ref<ModLocalizationPackage> {
        switch language {
            case n"ar-ar":
                return new Arabic();
            case n"cz-cz":
                return new Czech();
            case n"de-de":
                return new German();
            case n"en-us":
                return new English();
            case n"es-es":
                return new Spanish();
            case n"fr-fr":
                return new French();
            case n"it-it":
                return new Italian();
            case n"kr-kr":
                return new Korean();
            case n"pl-pl":
                return new Polish();
            case n"pt-br":
                return new Brazilian();
            case n"ru-ru":
                return new Russian();
            case n"tr-tr":
                return new Turkish();
            case n"zh-cn":
                return new ChineseSimplified();
            default:
                return null;
        }
    }

    public func GetFallback() -> CName {
        return n"en-us";
    }
}
