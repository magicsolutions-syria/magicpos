import 'package:equatable/equatable.dart';

class ProductUnitExpanded implements Equatable {
  final int id;

  double piecesQTY = 0;
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

  ProductUnitExpanded(
      {required this.suffix,
      required String name,
      required String barcode,
      required double costPrice,
      required double groupPrice,
      required double piecePrice,
      required double currentQTY,
      required double piecesQTY,
      this.id = -1,
      this.soldPrice1 = 0,
      this.soldPrice2 = 0,
      this.soldQty1 = 0,
      this.soldQty2 = 0}) {
    if (barcode != "" && piecesQTY != 0) {
      this.piecesQTY = piecesQTY;
      this.currentQTY = currentQTY;
      this.piecePrice = piecePrice;
      this.costPrice = costPrice;
      this.groupPrice = groupPrice;
      this.name = name;
      this.barcode = barcode;
    } else if (name != "" ||
        barcode != "" ||
        piecePrice != 0 ||
        piecesQTY != 0 ||
        groupPrice != 0 ||
        costPrice != 0 ||
        currentQTY != 0) {
      this.piecesQTY = 0;
      this.currentQTY = 0;
      this.piecePrice = 0;
      this.costPrice = 0;
      this.groupPrice = 0;
      this.name = "";
      barcode = "";
      String unitName = suffix == "_2" ? "الوحدة الثانية" : "الوحدة الثالثة";
      String qtyException =
          currentQTY != 0 ? "يوجد كميات من هذه الوحدة في المستودع" : "";
      throw Exception(
          "يوجد نقص في بيانات $unitName يرجى إكمال البيانات أو حذف البيانات المدخلة$qtyException");
    } else {
      this.piecesQTY = 0;
      this.currentQTY = 0;
      this.piecePrice = 0;
      this.costPrice = 0;
      this.groupPrice = 0;
      this.name = "";
      barcode = "";
    }
  }

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

  void updatePiecesQTY(String value) {
    if (value == "") {
      piecesQTY = 0;
    } else {
      piecesQTY = double.parse(value);
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

  String piecesQTYText() {
    return piecesQTY.toString();
  }

  @override
  // TODO: implement props
  List<Object?> get props =>
      [name, barcode, costPrice, piecePrice, groupPrice, currentQTY, piecesQTY];

  @override
  // TODO: implement stringify
  bool? get stringify => true;

  bool get isNotEmpty => barcode!="";

  bool get isEmpty => barcode!="";

  static emptyInstance(String s) {
    return ProductUnitExpanded(
        suffix: s,
        name: "",
        barcode: "",
        costPrice: 0,
        groupPrice: 0,
        piecePrice: 0,
        currentQTY: 0,
        piecesQTY: 0);
  }
}
