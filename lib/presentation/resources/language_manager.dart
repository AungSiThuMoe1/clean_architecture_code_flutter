enum LanguageType { ENGLISH, MYANMAR }

const String MYANMAR = "mm";
const String ENGLISH = "en";

extension LanguageTypeExtension on LanguageType {
  String getValue() {
    switch (this) {
      case LanguageType.ENGLISH:
        return ENGLISH;
      case LanguageType.MYANMAR:
        return MYANMAR;
    }
  }
}
