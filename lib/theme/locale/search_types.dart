class SearchTypes {
  static const String arName = "الاسم بالعربي";
  static const String enName = "الاسم بالإنكليزي";
  static const String code = "الباركود";
  static const String number = "الرقم";
  static const String code1 = "باركود الوحدة الأولى";
  static const String code2 = "باركود الوحدة الثانية";
  static const String code3 = "باركود الوحدة الثالثة";
  static const String jopTitle = "المسمى الوظيفي";
  static const String email = "الإيميل";
  static const String whatsappNum = "رقم الواتساب";
  static const String telNum = "رقم الهاتف";
  static const String inOperation = "إدخال";
  static const String outOperation = "إخراج";

  static List<String> searchTypesUser() {
    return [arName, enName, jopTitle];
  }

  static List<String> searchTypesProduct() {
    return [arName, enName, code1, code2, code3];
  }

  static searchTypesPerson() {
    return [code, enName, arName, number];
  }
}
