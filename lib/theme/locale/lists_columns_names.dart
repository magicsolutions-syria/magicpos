class ListsColumnsNames {
  static const String arName = "الاسم بالعربي";
  static const String number = "الرقم";
  static const String enName = "الاسم بالإنكليزي";
  static const String code = "الباركود";

  static const String code1 = "باركود الوحدة الأولى";
  static const String code2 = "باركود الوحدة الثانية";
  static const String code3 = "باركود الوحدة الثالثة";
  static const String jopTitle = "المسمى الوظيفي";

  static List<String> userListNames() {
    return [arName, enName, jopTitle];
  }

  static List<String> productListNames() {
    return [number, arName, enName, code];
  }

  static  List<String>personListNames() {
    return [code, enName, arName, number];
  }
}
