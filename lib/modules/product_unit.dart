import 'package:equatable/equatable.dart';

class ProductUnit implements Equatable {
  final int id;
  String name = "";
  final String suffix;
  String barcode = "";
  double costPrice = 0;
  double groupPrice = 0;
  double piecePrice = 0;
  double currentQTY = 0;
  final double soldQty1;

  final double soldQty2;

  final double soldPrice1;

  final double soldPrice2;

  ProductUnit(
      {required this.suffix,
      required this.name,
      required this.barcode,
      required this.costPrice,
      required this.groupPrice,
      required this.piecePrice,
      required this.currentQTY,
      this.id = -1,
      this.soldPrice1 = 0,
      this.soldPrice2 = 0,
      this.soldQty1 = 0,
      this.soldQty2 = 0});

  void updateCostPrice(String value) {
    if (value == "") {
      costPrice = 0;
    } else {
      costPrice = double.parse(value);
    }
  }

  void updateGroupPrice(String value) {
    if (value == "") {
      groupPrice = 0;
    } else {
      groupPrice = double.parse(value);
    }
  }

  void updatePiecePrice(String value) {
    if (value == "") {
      piecePrice = 0;
    } else {
      piecePrice = double.parse(value);
    }
  }

  String getViewName(String s) {
    if (name == "" || name == "بدون اسم") {
      return s;
    } else {
      return name;
    }
  }

  String costPriceText() {
    return costPrice.toString();
  }

  String groupPriceText() {
    return groupPrice.toString();
  }

  String piecePriceText() {
    return piecePrice.toString();
  }

  @override
  // TODO: implement props
  List<Object?> get props =>
      [name, barcode, costPrice, piecePrice, groupPrice, currentQTY];

  @override
  // TODO: implement stringify
  bool? get stringify => true;

  static ProductUnit emptyInstance(String s) {
    return ProductUnit(
        suffix: s,
        name: "",
        barcode: "",
        costPrice: 0,
        groupPrice: 0,
        piecePrice: 0,
        currentQTY: 0);
  }
}
