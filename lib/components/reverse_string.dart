import 'package:flutter/cupertino.dart';

String reversArString(String s) {
  String text = s;
  List<String> alphapet = [
    'ا',
    'ب',
    'ت',
    'ث',
    'ج',
    'ح',
    'خ',
    'د',
    'ذ',
    'ر',
    'ز',
    'س',
    'ش',
    'ص',
    'ض',
    'ط',
    'ظ',
    'ع',
    'غ',
    'ف',
    'ق',
    'ك',
    'ل',
    'م',
    'ن',
    'ه',
    'و',
    'ي',
    'إ',
    'أ',
    'آ',
    'ئ',
    'ء',
    'ؤ',
    'ى',
    "ة",
  ];
  List numbers = [
    '٠',
    '٩',
    '٨',
    '٧',
    '٦',
    '٥',
    '٤',
    '٣',
    '٢',
    '١',
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
  ];
  String value = '';
  String arHelper = '';
  String numHelper = '';
  String enHelper = '';
  List<String> words = [];

  for (int i = 0; i < s.length; i++) {
    if (s[i] == ' ') {
      if (numHelper != '') {
        words.add(numHelper);
        numHelper = '';
      }
      if (arHelper != '') {
        arHelper = reverseString(arHelper);

        words.add(arHelper);
        arHelper = '';
      }
      if (enHelper != '') {
        words.add(enHelper);
        enHelper = '';
      }
      words.add(s[i]);
    } else if (alphapet.contains(s[i])) {
      if (enHelper != '') {
        words.add(enHelper);
        enHelper = '';
      }
      if (numHelper != '') {
        words.add(numHelper);
        numHelper = '';
      }
      arHelper += s[i];
    } else if (numbers.contains(s[i]) ||
        ((s[i] == '.' || s[i] == ',') && numHelper != '')) {
      if (enHelper != '') {
        words.add(enHelper);
        enHelper = '';
      }
      if (arHelper != '') {
        arHelper = reverseString(arHelper);
        words.add(arHelper);
        arHelper = '';
      }
      numHelper += s[i];
    } else {
      if (numHelper != '') {
        words.add(numHelper);
        numHelper = '';
      }
      if (arHelper != '') {
        arHelper = reverseString(arHelper);
        words.add(arHelper);
        arHelper = '';
      }
      enHelper += s[i];
    }
  }
  if (numHelper != '') {
    words.add(numHelper);
    numHelper = '';
  }
  if (arHelper != '') {
    arHelper = reverseString(arHelper);

    words.add(arHelper);
    arHelper = '';
  }
  if (enHelper != '') {
    words.add(enHelper);
    enHelper = '';
  }
  for (int i = words.length - 1; i >= 0; i--) {
    value += words[i];
  }
  return value;
}

String reverseString(String input) {
  return String.fromCharCodes(input.codeUnits.reversed);
}
