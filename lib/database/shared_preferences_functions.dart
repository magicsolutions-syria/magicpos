import 'package:flutter/widgets.dart';
import 'package:magicposbeta/modules/general_settings.dart';
import 'package:magicposbeta/theme/locale/radios_values.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens_data/constants.dart';

class SharedPreferencesFunctions {
  static Future<String> getScreen() async {
    SharedPreferences data = await SharedPreferences.getInstance();
    return data.getString("screen_type") ?? posScreenGroup.first;
  }

  static Future<String> getPrice() async {
    SharedPreferences data = await SharedPreferences.getInstance();
    return data.getString("price_type") ?? priceGroup.first;
  }

  static Future<Map<String, String>> getScaleData() async {
    SharedPreferences data = await SharedPreferences.getInstance();

    return {
      "start_scale": data.getString("start_scale") ?? "99",
      "weight_scale": (data.getInt("weight_scale") ?? 5).toString(),
      "product_number_scale":
          (data.getInt("product_number_scale") ?? 5).toString()
    };
  }

  static Future<Map<String, int>> getCommas() async {
    SharedPreferences data = await SharedPreferences.getInstance();
    print(data.getInt(SharedPreferencesNames.qtyComma));
    return {
      SharedPreferencesNames.qtyComma:
          data.getInt(SharedPreferencesNames.qtyComma) ?? 1,
      SharedPreferencesNames.priceComma:
          data.getInt(SharedPreferencesNames.priceComma) ?? 1
    };
  }

  static Future<String> getHeaderType() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(SharedPreferencesNames.billHeaderType) ??
        "header";
  }

  static Future<String> getBillHeader() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(SharedPreferencesNames.billHeader) ?? "";
  }

  static Future<String> getBillFooter() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(SharedPreferencesNames.billFooter) ?? "";
  }

  static Future<String> getBillLogo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(SharedPreferencesNames.billLogo) ?? "";
  }

  static Future<void> setBillDecoration(
      {required String imagePath,
      required String headerType,
      required String tailText,
      required String headerText}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
        SharedPreferencesNames.billLogo, imagePath);
    await sharedPreferences.setString(
        SharedPreferencesNames.billHeaderType, headerType);
    await sharedPreferences.setString(
        SharedPreferencesNames.billHeader, headerText);
    await sharedPreferences.setString(
        SharedPreferencesNames.billFooter, tailText);
  }

  static Future<void> setDefaultPrinter({
    required int printerId
    })
  async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt(SharedPreferencesNames.defaultPrinter, printerId);
  }

  static Future<int> getDefaultPrinter()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(SharedPreferencesNames.defaultPrinter)??-1;
  }
}

class SharedPreferencesNames {
  static String get defaultPrinter{
    return "default_printer";
  }
  static String get billHeaderType {
    return "scale_header_type";
  }

  static String get billHeader {
    return "bill_header";
  }

  static String get billLogo {
    return "bill_logo";
  }

  static String get billFooter {
    return "bill_footer";
  }

  static String get qtyComma {
    return "qty_comma";
  }

  static String get priceComma {
    return "price_comma";
  }

  static String get startScale {
    return "start_scale";
  }

  static String get weightScale {
    return "weight_scale";
  }

  static String get productNumberScale {
    return "product_number_scale";
  }

  static String get priceType {
    return "price_type";
  }

  static String get screenType {
    return "screen_type";
  }
}

class DefaultValues {
  static int get defaultPrinter{
    return -1;
  }
  static String get billHeaderType {
    return "header";
  }

  static String get billHeader {
    return "";
  }

  static String get billLogo {
    return "";
  }

  static String get billFooter {
    return "";
  }

  static int get qtyComma {
    return 1;
  }

  static int get priceComma {
    return 1;
  }

  static String get startScale {
    return "99";
  }

  static int get weightScale {
    return 5;
  }

  static int get productNumberScale {
    return 5;
  }

  static String get priceType {
    return  RadiosValues.piece;
  }

  static String get screenType {
    return RadiosValues.pos;
  }
}

