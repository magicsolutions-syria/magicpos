import 'package:equatable/equatable.dart';
import 'package:magicposbeta/database/functions/Sections_functions.dart';
import 'package:magicposbeta/database/functions/groups_functions.dart';
import 'package:magicposbeta/database/functions/product_functions.dart';
import 'package:magicposbeta/modules/products_classes/info_department.dart';
import 'package:magicposbeta/modules/products_classes/abs_product.dart';
import 'package:magicposbeta/modules/products_classes/info_group.dart';
import 'package:magicposbeta/theme/locale/locale.dart';

import '../product_unit.dart';
import '../product_unit_expanded.dart';

class InfoProduct extends AbsProduct implements Equatable {
  InfoDepartment department;
  InfoGroup group;
  int _productType = 0;
  double minQty = 0;
  double maxQty = 0;
  String description = "";
  String imagePath = "";
  ProductUnit unit1;
  ProductUnitExpanded unit2;
  ProductUnitExpanded unit3;

  InfoProduct(
      {required String productType,
      required double minQty,
      required double maxQty,
      required this.description,
      required this.imagePath,
      required this.department,
      required this.group,
      required this.unit1,
      required this.unit2,
      required this.unit3,
      required super.arName,
      required super.enName,
      super.id}) {
    setProductType(productType);
  }

  void setProductType(String value) {
    _productType = DiversePhrases.productTypes().indexOf(value);
  }

  void updateMinAmount(text) {
    if (text == "") {
      minQty = 0;
    } else {
      minQty = double.parse(text);
    }
  }

  void updateMaxAmount(text) {
    if (text == "") {
      maxQty = 0;
    } else {
      maxQty = double.parse(text);
    }
  }

  int get productType {
    return _productType;
  }

  get productTypeName => DiversePhrases.productTypes().elementAt(_productType);

  void updateProductType(String productType) {
    _productType = DiversePhrases.productTypes().indexOf(productType);
  }

  bool checkBarcodes() {
    String barcode1 = unit1.barcode;
    String barcode2 = unit2.barcode;
    String barcode3 = unit3.barcode;
    bool code12 = (barcode1 == barcode2 && barcode1 != "" && barcode2 != "");
    bool code13 = (barcode1 == barcode3 && barcode1 != "" && barcode3 != "");
    bool code23 = (barcode3 == barcode2 && barcode3 != "" && barcode2 != "");
    if (code12 || code13 || code23) {
      return true;
    }
    return false;
  }

  bool checkQty() {
    if (maxQty == 0 || minQty == 0) {
      return false;
    }
    if (maxQty >= minQty) {
      return false;
    }
    return true;
  }

  String minQTYText() {
    return minQty.toString();
  }

  String maxQTYText() {
    return maxQty.toString();
  }

  static InfoProduct emptyInstance() {
    return InfoProduct(
        arName: "",
        enName: "",
        productType: DiversePhrases.productTypes()[0],
        minQty: 0,
        maxQty: 0,
        description: "",
        imagePath: "",
        unit1: ProductUnit.emptyInstance("_1"),
        unit2: ProductUnitExpanded.emptyInstance("_2"),
        unit3: ProductUnitExpanded.emptyInstance("_3"),
        department: InfoDepartment.emptyInstance(),
        group: InfoGroup.emptyInstance());
  }

  static InfoProduct instanceFromMap(Map item) {
    ProductUnit unit1 = ProductUnit(
        id: item["id_1"],
        suffix: "_1",
        name: item["name_1"],
        barcode: item["code_1"],
        costPrice: item["cost_price_1"],
        groupPrice: item["group_price_1"],
        piecePrice: item["piece_price_1"],
        currentQTY: item["current_quantity_1"],
        soldPrice1: item['total_sells_price_one_1'],
        soldPrice2: item['total_sells_price_two_1'],
        soldQty1: item['sold_quantity_one_1'],
        soldQty2: item['sold_quantity_two_1']);
    ProductUnitExpanded unit2 = ProductUnitExpanded(
        id: item["id_2"],
        suffix: "_2",
        name: item["name_2"],
        barcode: item["code_2"],
        costPrice: item["cost_price_2"],
        groupPrice: item["group_price_2"],
        piecePrice: item["piece_price_2"],
        currentQTY: item["current_quantity_2"],
        piecesQTY: item["pieces_quantity_2"],
        soldPrice1: item['total_sells_price_one_2'],
        soldPrice2: item['total_sells_price_two_2'],
        soldQty1: item['sold_quantity_one_2'],
        soldQty2: item['sold_quantity_two_2']);
    ProductUnitExpanded unit3 = ProductUnitExpanded(
        id: item["id_3"],
        suffix: "_3",
        name: item["name_3"],
        barcode: item["code_3"],
        costPrice: item["cost_price_3"],
        groupPrice: item["group_price_3"],
        piecePrice: item["piece_price_3"],
        currentQTY: item["current_quantity_3"],
        piecesQTY: item["pieces_quantity_3"],
        soldPrice1: item['total_sells_price_one_3'],
        soldPrice2: item['total_sells_price_two_3'],
        soldQty1: item['sold_quantity_one_3'],
        soldQty2: item['sold_quantity_two_3']);
    InfoDepartment department = InfoDepartment.fullInstance(
      id: item[SectionsFunctions.idF],
      name: item[SectionsFunctions.nameF],
    );
    InfoGroup group = InfoGroup.fullInstance(
      id: item[GroupsFunctions.idF],
      name: item[GroupsFunctions.nameF],
      department: department,
    );
    return InfoProduct(
      id: item[ProductFunctions.idF],
      arName: item[ProductFunctions.arNameF],
      enName: item[ProductFunctions.enNameF],
      productType: DiversePhrases.productTypes()
          .elementAt(item[ProductFunctions.productTypeF]),
      minQty: item[ProductFunctions.minAmountF].toDouble(),
      maxQty: item[ProductFunctions.maxAmountF].toDouble(),
      description: item[ProductFunctions.descriptionF],
      imagePath: item[ProductFunctions.imagePathF],
      unit1: unit1,
      unit2: unit2,
      unit3: unit3,
      department: department,
      group: group,
    );
  }

  @override
  String toString() {
    return "arname:{$arName},enname:{$enName}";
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        arName,
        enName,
        productType,
        minQty,
        maxQty,
        imagePath,
        description,
        unit1,
        unit2,
        unit3
      ];

  @override
  // TODO: implement stringify
  bool? get stringify => true;

  double totalSoldQty1() {
    return unit1.soldQty1 + unit2.soldQty1 + unit3.soldQty1;
  }

  double totalSoldQty2() {
    return unit1.soldQty2 + unit2.soldQty2 + unit3.soldQty2;
  }

  double totalSoldPrice1() {
    return unit1.soldPrice1 + unit2.soldPrice1 + unit3.soldPrice1;
  }

  double totalSoldPrice2() {
    return unit1.soldPrice2 + unit2.soldPrice2 + unit3.soldPrice2;
  }

  static Future<List<InfoProduct>> getList(List<Map> list) async {
    List<InfoProduct> products = [];
    for (var product in list) {
      products.add(instanceFromMap(product));
    }
    return products;
  }
}
