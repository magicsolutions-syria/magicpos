import 'package:magicposbeta/database/functions/product_functions.dart';
import 'package:magicposbeta/modules/product_unit.dart';
import 'package:magicposbeta/modules/products_classes/abs_product.dart';

class ViewProduct extends AbsProduct {
  final String printName;
  ProductUnit unit = ProductUnit.emptyInstance("_1");

  ViewProduct(
      {super.id,
      required super.arName,
      required super.enName,
      required this.printName,
      required this.unit});

  static ViewProduct instanceFromMap(Map item, String suffix) {
    ProductUnit unit = ProductUnit(
      suffix: suffix,
      name: item["name_$suffix"],
      barcode: item["code$suffix"],
      costPrice: item["cost_price_$suffix"],
      groupPrice: item["group_price_$suffix"],
      piecePrice: item["piece_price_$suffix"],
      currentQTY: item["current_quantity_$suffix"],
      soldQty1: item["sold_quantity_one_$suffix"],
      soldQty2: item["sold_quantity_two_$suffix"],
      soldPrice2: item["total_sells_price_two_$suffix"],
      soldPrice1: item["total_sells_price_one_$suffix"],
    );
    return ViewProduct(
      arName: item[ProductFunctions.arNameF],
      enName: item[ProductFunctions.enNameF],
      printName: item[ProductFunctions.printNameF],
      unit: unit,
    );
  }

  static Future<List<ViewProduct>> getList(List<Map> response) async {
    List<ViewProduct> products = [];
    for (Map product in response) {
      products.add(AbsProduct.instanceFromMap(product));
    }
    return products;
  }
}
