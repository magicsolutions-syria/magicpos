import 'dart:math';

import 'package:equatable/equatable.dart';

import 'package:intl/intl.dart';
import 'package:magicposbeta/components/reverse_string.dart';
import 'package:magicposbeta/database/functions/person_functions.dart';
import 'package:magicposbeta/database/functions/product_functions.dart';
import '../providers/products_table_provider.dart';
import '../screens_data/constants.dart';

class InOutProduct extends Equatable {
  String printName;
  int _id = 0;
  String name;
  List<List<double>> prices;
  List<String> names;
  double qty;
  double price;
  double currentTotalPrice = 0;
  int _currentPriceGroup = 0;
  String unit = "";
  static double totalPrice = 0;
  static double totalQty = 0;
  InOutProduct(
      {required this.prices,
      required this.name,
      required this.printName,
      required this.price,
      required this.qty,
      required this.currentTotalPrice,
      required this.names,
      required this.unit,
      bool add = true,
      required int id}) {
    if (add) {
      totalPrice += price;
      totalQty += qty;
    }
    _id = id;
  }
  static InOutProduct initializeMap(Map item) {
    List<String> names = [];

    names.add(item['name_1'] != "" ? item['name_1'] : "الوحدة الأولى");
    if (item['code_2'] != "") {
      names.add(item['name_2'] != "" ? item['name_2'] : "الوحدة الثانية");
    }
    if (item['code_3'] != "") {
      names.add(item['name_3'] != "" ? item['name_3'] : "الوحدة الثالثة");
    }

    List<List<double>> prices = [
      [
        item["cost_price_1"],
        item["group_price_1"],
        item["piece_price_1"],
      ],
      [
        item["cost_price_2"],
        item["group_price_2"],
        item["piece_price_2"],
      ],
      [
        item["cost_price_3"],
        item["group_price_3"],
        item["piece_price_3"],
      ]
    ];
    return InOutProduct(
      prices: prices,
      name: item["ar_name"],
      printName: item["Print_Name"],
      price: item["cost_price_1"],
      qty: 1,
      names: names,
      unit: names[0],
      id: item["id"],
      currentTotalPrice: item["cost_price_1"],
    );
  }

  double initialPrices() {
    int index = prices[_currentPriceGroup].indexOf(price);
    _currentPriceGroup=names.indexOf(unit);
    if (index != -1) {
     return prices[_currentPriceGroup][index];
    }
    return price;
  }
  List<double> priceGroupList() {
    return  prices[_currentPriceGroup];
  }

  void mergeProduct(InOutProduct item) {
    qty += item.qty;
    currentTotalPrice += item.currentTotalPrice;
  }

  static Map<String, List<InOutProduct>> mergeList(List<InOutProduct> items) {
    List<InOutProduct> updateList = [];
    List<InOutProduct> printList = [];
    for (InOutProduct element in items) {
      int index1 = updateList.indexOf(element);
      int index2 = printList.indexOf(element);
      if (index1 == -1) {
        updateList.add(InOutProduct(
            prices: [],
            name: element.name,
            printName: element.printName,
            price: element.price,
            qty: element.qty,
            currentTotalPrice: element.currentTotalPrice,
            names: [],
            unit: element.unit,
            add: false,
            id: element._id));
      } else {
        updateList[index1].mergeProduct(element);
      }
      if (index2 == -1 || printList[index2].price != element.price) {
        printList.add(InOutProduct(
            prices: [],
            name: element.name,
            printName: element.printName,
            price: element.price,
            qty: element.qty,
            currentTotalPrice: element.currentTotalPrice,
            names: [],
            add: false,
            unit: element.unit,
            id: element._id));
      } else {
        printList[index2].mergeProduct(element);
      }
    }

    return {"update": updateList, "print": printList};
  }

  int get currentPriceGroup {
    return _currentPriceGroup;
  }

  int get id {
    return _id;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [name, unit];

  static Future<String> insertProducts(List<InOutProduct> products, String name,
      String inOut, String type,
      {required int priceComma, required int qtyComma}) async {
    if (products.isEmpty) {
      throw Exception("قائمة المواد فارغة");
    }
    if (name == "" && inOut == "إدخال") {
      throw Exception("يرجى تحديد اسم المورد");
    }
    if (inOut == "") {
      throw Exception("يرجى تحديد نوع العملية");
    }
    Map<String, List<InOutProduct>> merged = mergeList(products);

    List<InOutProduct>? updateList = merged["update"];
    List<InOutProduct>? printList = merged["print"];
    for (InOutProduct element in updateList!) {
      List<double> qty = [0, 0, 0];
      qty[element.currentPriceGroup] = element.qty;
      inOut == "إدخال"
          ? ProductFunctions.increaseProductQty(
          id: element.id.toString(),
          qty1: qty[0].toString(),
          qty2: qty[1].toString(),
          qty3: qty[2].toString())
          : ProductFunctions.decreaseProductQty(
          id: element.id.toString(),
          qty1: qty[0].toString(),
          qty2: qty[1].toString(),
          qty3: qty[2].toString());
    }
    inOut == "إدخال"
        ? await PersonFunctions.addToAccount(
        name: name,
        amount: totalPrice,
        type: type == "الزبائن" ? "clients" : "suppliers")
        : name != ""
        ? await PersonFunctions.withDrawFromAccount(
        name: name,
        amount: totalPrice,
        type: type == "الزبائن" ? "clients" : "suppliers")
        : null;
    return printerText(
      products: printList!,
      supplierName: name,
      priceComma: priceComma,
      qtyComma: qtyComma,
    );
  }

  static String printerText({required List<InOutProduct> products,
    required String supplierName,
    required int priceComma,
    required int qtyComma}) {
    DateTime now = DateTime.now();
    String dateTime = DateFormat('dd/MM/yyyy').format(now);
    String hour = DateFormat(' HH:mm:ss').format(now);

    String date = dateTime;

    String ans = "$date                             $hour\n"
        "UserName : ${currentUserss.printName.substring(
      0, min(36, currentUserss.printName.length),)
    }\n"
        "------------------------------------------------\n";
    ans +=
    "Supplier name : ${reversArString(supplierName).substring(
        0, min(32, supplierName.length))}\n";

    ans += "Product Name          QTY        Unit      Total\n";
    ans += "                                 Price     Price\n";

    ans += "------------------------------------------------\n";

    for (int i = 0; i < products.length; i++) {
      ans +=
      "${products[i].printName}${"                     ".substring(
          products[i].printName
              .toString()
              .length + 2)}${"       ".substring(ProductsTableProvider
          .formatPriceText(products[i].qty, qtyComma)
          .length)}${ProductsTableProvider.formatPriceText(
          products[i].qty, qtyComma)}${"            ".substring(
          products[i].price
              .toInt()
              .toString()
              .length)}${ProductsTableProvider.formatPriceText(
          products[i].price, priceComma)}${"          ".substring(
          ProductsTableProvider
              .formatPriceText(products[i].currentTotalPrice, priceComma)
              .length)}${ProductsTableProvider.formatPriceText(
          products[i].currentTotalPrice, priceComma)}\n";
    }

    ans += "------------------------------------------------\n";
    ans +=
    "Total Price                ${"                    ".substring(
        ProductsTableProvider
            .formatPriceText(totalPrice, priceComma)
            .length)}${ProductsTableProvider.formatPriceText(
        totalPrice, priceComma)}\n";
    ans +=
    "Total QTY                  ${"                    ".substring(
        ProductsTableProvider
            .formatPriceText(totalQty, qtyComma)
            .length)}${ProductsTableProvider.formatPriceText(
        totalQty, qtyComma)}\n";

    ans += "------------------------------------------------\n";

    return
      ans;
  }

}
