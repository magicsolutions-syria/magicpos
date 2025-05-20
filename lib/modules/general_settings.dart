import 'package:shared_preferences/shared_preferences.dart';

import '../database/shared_preferences_functions.dart';

class GeneralSettings {
  String _priceType = "";
  String _screenType = "";
  String _startScale = "";
  int _weightScale = 0;
  int _productNumberScale = 0;
  int _priceComma = 0;
  int _qtyComma = 0;
  String _billLogo = "";
  String _billFooter = "";
  String _billHeader = "";
  String _headerType = "";
  int _defaultPrinter = 0;

  GeneralSettings({
    required String priceType,
    required String screenType,
    required String startScale,
    required int weightScale,
    required int productNumberScale,
    required int priceComma,
    required int qtyComma,
    required String billLogo,
    required String billFooter,
    required String billHeader,
    required String headerType,
    required int defaultPrinter,
  }) {
    _priceType = priceType;
    _screenType = screenType;
    _startScale = startScale;
    _weightScale = weightScale;
    _productNumberScale = productNumberScale;
    _priceComma = priceComma;
    _qtyComma = qtyComma;
    _billLogo = billLogo;
    _billFooter = billFooter;
    _billHeader = billHeader;
    _headerType = headerType;
    _defaultPrinter = defaultPrinter;
  }

  static Future<GeneralSettings> getSettings() async {
    SharedPreferences data = await SharedPreferences.getInstance();
    return GeneralSettings(
      priceType: data.getString(SharedPreferencesNames.priceType) ??
          DefaultValues.priceType,
      screenType: data.getString(SharedPreferencesNames.screenType) ??
          "resturant",
      startScale: data.getString(SharedPreferencesNames.startScale) ??
          DefaultValues.startScale,
      weightScale: data.getInt(SharedPreferencesNames.weightScale) ??
          DefaultValues.weightScale,
      productNumberScale:
          data.getInt(SharedPreferencesNames.productNumberScale) ??
              DefaultValues.productNumberScale,
      priceComma: data.getInt(SharedPreferencesNames.priceComma) ??
          DefaultValues.priceComma,
      qtyComma: data.getInt(SharedPreferencesNames.qtyComma) ??
          DefaultValues.qtyComma,
      billLogo: data.getString(SharedPreferencesNames.billLogo) ??
          DefaultValues.billLogo,
      billFooter: data.getString(SharedPreferencesNames.billFooter) ??
          DefaultValues.billFooter,
      billHeader: data.getString(SharedPreferencesNames.billHeader) ??
          DefaultValues.billHeader,
      headerType: data.getString(SharedPreferencesNames.billHeaderType) ??
          DefaultValues.billHeaderType,
      defaultPrinter: data.getInt(SharedPreferencesNames.defaultPrinter) ??
          DefaultValues.defaultPrinter,
    );
  }

  Future<void> setHeaderType({required String value}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
        SharedPreferencesNames.billHeaderType, value);
    _headerType = value;
  }

  Future<void> setBillHeader({required String value}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(SharedPreferencesNames.billHeader, value);
    _billHeader = value;
  }

  Future<void> setBillFooter({required String value}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(SharedPreferencesNames.billFooter, value);
    _billFooter = value;
  }

  Future<void> setBillLogo({required String value}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(SharedPreferencesNames.billLogo, value);
    _billLogo = value;
  }

  Future<void> setScreenType({required String value}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(SharedPreferencesNames.screenType, value);
    _screenType = value;
  }

  Future<void> setPriceType({required String value}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(SharedPreferencesNames.priceType, value);
    _priceType = value;
  }

  Future<void> setStartScale({required String value}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(SharedPreferencesNames.startScale, value);
    _startScale = value;
  }

  Future<void> setWeightScale({required int value}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt(SharedPreferencesNames.weightScale, value);
    _weightScale = value;
  }

  Future<void> setProductNumberScale({required int value}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt(
        SharedPreferencesNames.productNumberScale, value);
    _productNumberScale = value;
  }

  Future<void> setPriceComma({required int value}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt(SharedPreferencesNames.priceComma, value);
    _priceComma = value;
  }

  Future<void> setQtyComma({required int value}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt(SharedPreferencesNames.qtyComma, value);
    _qtyComma = value;
  }

  Future<void> setDefaultPrinter({required int value}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt(
        SharedPreferencesNames.defaultPrinter, value);
    _defaultPrinter = value;
  }

  String get priceType => _priceType;

  String get screenType => _screenType;

  String get startScale => _startScale;

  int get weightScale => _weightScale;

  int get productNumberScale => _productNumberScale;

  int get priceComma => _priceComma;

  int get qtyComma => _qtyComma;

  String get billLogo => _billLogo;

  String get billFooter => _billFooter;

  String get billHeader => _billHeader;

  String get headerType => _headerType;

  int get defaultPrinter => _defaultPrinter;
}
