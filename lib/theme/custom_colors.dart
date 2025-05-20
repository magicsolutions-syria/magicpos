import 'package:flutter/material.dart';

extension MyCustomColors on ThemeData {
  Color get cancelButtonColor {
    return Colors.greenAccent;
  }

  static Color get primaryColor {
    return Colors.blue;
  }

  Color get whatsAppButtonColor {
    return const Color(0xFF25D366);
  }

  Color get warningColor {
    return Colors.orangeAccent;
  }

  Color get okColor {
    return Colors.green;
  }

  Color get deleteButtonColor {
    return Colors.redAccent;
  }

  Color get fieldsColor {
    return Colors.white;
  }

  static Color get fieldsColorStatic {
    return Colors.white;
  }

  Color get iconsTextsColors {
    return Colors.black;
  }

  Color get secondaryTextColor {
    return Colors.white;
  }

  Color get closeImageColor {
    return const Color(0x69AB0303);
  }

  Color get selectedColor {
    return const Color(0xFFE0E0E0);
  }

  Color get dividerSecondaryColor {
    return Colors.grey;
  }
}
