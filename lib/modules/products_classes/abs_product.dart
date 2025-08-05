import '../../theme/locale/errors.dart';
import '../custom_exception.dart';

class AbsProduct {
  int _id = -1;
  String arName = "";
  String enName = "";

  AbsProduct({
    int id = 0,
    required this.arName,
    required this.enName,
  }) {
    _id = id;
  }
  int get id {
    return _id;
  }
  set id(int value) {
    if (value < 0) {
      throw CustomException(ErrorsCodes.invalidID);
    }
    _id = value;
  }
  external static instanceFromMap(Map item);
  static Future<List<AbsProduct>> getList(List<Map> list) async {
    List<AbsProduct> products = [];
    for (Map product in list) {
      products.add(AbsProduct.instanceFromMap(product));
    }
    return products;
  }
}
