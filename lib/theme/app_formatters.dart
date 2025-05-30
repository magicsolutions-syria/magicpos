import 'dart:math';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AppFormatters {
  static String leftZerosFormat(int id, {int digitsNumber = 4}) {
    String zeros = "";
    for (int i = 0; i < digitsNumber; i++) {
      zeros += "0";
    }
    return zeros.substring(0, max((digitsNumber - (id.toString().length)).toInt(), 0)) +
        (id.toString());
  }

  static List<TextInputFormatter> numbersIntFormat() {
    return [
      FilteringTextInputFormatter.allow(
        RegExp('[0-9]'),
      ),
    ];
  }

  static List<TextInputFormatter> numbersDoubleFormat() {
    return [
      FilteringTextInputFormatter.allow(
        RegExp(r'(^\d*\.?\d*)'),
      ),
    ];
  }

  static String formatPriceText(double num, int comma) {
    final newValue = NumberFormat("#,###,###", "en_US");
    newValue.minimumFractionDigits = comma;
    newValue.maximumFractionDigits = comma;

    if (num.abs() < 1) {
      return "0${newValue.format(num)}";
    }

    return newValue.format(num);
  }

  static double formatPriceNumber(String text, int comma) {
    final newValue = NumberFormat("#,###,###", "en_US");
    newValue.minimumFractionDigits = comma;
    newValue.maximumFractionDigits = comma;
    if (text[0] == "0") {
      return newValue.parse(text.substring(1)).toDouble();
    }
    return newValue.parse(text).toDouble();
  }
}
