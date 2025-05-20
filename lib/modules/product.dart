import 'package:equatable/equatable.dart';

class Product extends Equatable {
  String productDesc;
  String printName;
  double quantity;
  double price;
  bool isBonus;
  bool isDiscount;
  String barcode;
  int id;
  int unitNum;
  int groupId;
  int deptId;
  int printerId;

  Product({
    required this.productDesc,
    required this.quantity,
    required this.price,
    this.isBonus = false,
    this.isDiscount = false,
    required this.barcode,
    required this.id,
    required this.unitNum,
    required this.groupId,
    required this.deptId,
    required this.printName,
    this.printerId = -1
  });

  String get desc {
    return productDesc;
  }

  double get qty {
    return quantity;
  }

  double get unitPrice {
    return price;
  }

  bool get isNotProduct {
    return isBonus || isDiscount;
  }

  void changeQty(double newQty) {
    quantity = newQty;
  }

  double calcTotalPrice() {
    return quantity * price;
  }

  static Product fromDataMap(Map mp) {
    return Product(
      productDesc: mp["ar_name"],
      quantity: mp["current_quantity_1"],
      price: mp["piece_price_1"],
      barcode: mp["code_1"],
      id: mp["id"],
      unitNum: 1,
      groupId: mp["id_group"],
      deptId: mp["id_department"],
      printName: mp["Print_Name"],
    );
  }

  @override
  List<Object?> get props => barcode == "-2" ? [productDesc] : [price, barcode];
}
