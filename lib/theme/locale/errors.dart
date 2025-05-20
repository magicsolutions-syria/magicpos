class ErrorsCodes {
  static const String notEmptyQtyProduct =
      "لا يمكنك حذف المادة يوجد كميات منها في المستودع";

  static const String notEmptySellsProduct =
      "لا يمكنك حذف المادة قبل تصفير تقارير حركة المواد و حركة الكاش وحركة الأقسام";

  static const String emailIsNotUnique = "الإيميل موجود مسبقاً";

  static const String whatsAppIsNotUnique = "رقم الوتساب موجود مسبقاً";

  static const String telIsNotUnique = "رقم الهاتف موجود مسبقاً";

  static const String startAppFail = "Error while start app , try again Later";

  static const String emptyGroupData = "there is no groups";

  static const String emptySectionData = "there is no departments";

  static const String emptyData = "no results";

  static String get emptyBarcode {
    return "لا يجب ترك حقل الباركود فارغاً";
  }

  static String get invalidQty {
    return "invalid min,max QTY";
  }

  static String get arNameIsNotUnique {
    return "arabic name is exist previously";
  }

  static String get enNameIsNotUnique {
    return "english name is exist previously";
  }

  static String get code1IsNotUnique {
    return "unit1's barcode is exist previously";
  }

  static String get code2IsNotUnique {
    return "unit2's barcode is exist previously";
  }

  static String get code3IsNotUnique {
    return "unit3's barcode is exist previously";
  }

  static String get emptyArName {
    return "arabic name can't be empty";
  }

  static String get emptyEnName {
    return "english name can't be empty";
  }

  static String get emptyGroupName {
    return "group name can't be empty";
  }

  static String get emptyUser {
    return "user name can't be empty";
  }

  static String get invalidID {
    return "id should not be negative";
  }

  static String get barcodeIsNotUnique {
    return "wrong barcode , please change it";
  }

  static String get emptyPassword {
    return "password can't be empty";
  }

  static String get connectProblem {
    return "connection error please check your internet connection and try again";
  }

  static String get unAuthorizedApi {
    return "unauthorized problem";
  }

  static String get notFoundUserName {
    return "user name not found";
  }

  static String get falsePassword {
    return "password is wrong";
  }

  static String get userNameExist {
    return "user name is exist previously";
  }

  static String get falseCode {
    return "code isn't true";
  }

  static String get notZeroBalanceAccount {
    return "لا يمكن حذف هذا الحساب \n الرجاء تصفية الرصيد أولاً";
  }
}
