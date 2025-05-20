import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:magicposbeta/database/shared_preferences_functions.dart';
import 'package:magicposbeta/screens_data/constants.dart';
import '../components/printer_helper_functions.dart';
import "../modules/product.dart";
import '../modules/product_lisit.dart';

class ProductsTableProvider with ChangeNotifier {
  final value = NumberFormat("#,###,###", "en_US");

  int qtyCommas = 1;
  int priceCommas = 1;
  String priceType = "piece";
  String scaleStart = "99";
  String sacleWeight = "99";
  String productNumberScale = "99";

  bool rcPdChOpened = false;

  bool printerOn = currentUserss.operationKeys.printer;

  String _ans = "0";

  double _qty = 1;

  bool _rfToggled = false;

  ProductsTableProvider() {
    initData();
  }

  Future<void> initData() async {
    Map sh = await SharedPreferencesFunctions.getCommas();
    qtyCommas = sh[SharedPreferencesNames.qtyComma];
    priceCommas = sh[SharedPreferencesNames.priceComma];
    priceType = await SharedPreferencesFunctions.getPrice();
    Map mp = await SharedPreferencesFunctions.getScaleData();
    scaleStart = mp["start_scale"];
    sacleWeight = mp["weight_scale"];
    productNumberScale = mp["product_number_scale"];
    notifyListeners();
  }

  bool get isPrinterOn {
    return printerOn;
  }

  bool get isRfToggled {
    return _rfToggled;
  }

  bool get isRcPdChOpened {
    return rcPdChOpened;
  }

  double get qty {
    return _qty;
  }

  String get ans {
    return _ans;
  }

  double get total {
    return _currentProducts.totalPrice;
  }

  double get bonus {
    return _currentProducts.calcBonus();
  }

  double get discount {
    return _currentProducts.calcDiscount();
  }

  double get finalPrice {
    return _currentProducts.finalPrice;
  }

  String _convertToDecimal(int numb) {
    String ans = "";

    if (numb.toString().length < 3) {}

    return ans;
  }

  void changeProductPriceAtIndex(double amount) {
    _currentProducts.products[selectedProductIndex].price = amount;
    notifyListeners();
  }

  static String formatPriceText(double num, int n) {

    final newValue = NumberFormat("#,###,###", "en_US");
    newValue.minimumFractionDigits = n;
    newValue.maximumFractionDigits = n;

    if (num.abs() < 1) {
      return "0${newValue.format(num)}";
    }

    return newValue.format(num);
  }

  String printerText(double paid,List<Product> ls) {
    DateTime now = DateTime.now();
    String dateTime = DateFormat('dd/MM/yyyy').format(now);
    String hour = DateFormat(' HH:mm:ss').format(now);

    String date = dateTime;

    String ans = "${PrinterHelperFunctions.putTextInSpaces(date.toString(), 24,position: 2)}${PrinterHelperFunctions.putTextInSpaces(hour.toString(), 24)}\nUserName : ${PrinterHelperFunctions.putTextInSpaces(currentUserss.printName, 37,position: 2)}\n${PrinterHelperFunctions.line}";

    ans += "${PrinterHelperFunctions.putTextInSpaces("ProductName",paid>=0? 19:41,position: 2)}${PrinterHelperFunctions.putTextInSpaces("QTY",6)}${paid>=0?PrinterHelperFunctions.putTextInSpaces("Unit", 10):""}${paid>=0?PrinterHelperFunctions.putTextInSpaces("Total", 13):""}\n";
    if(paid>=0){
      ans += "${paid>=0?PrinterHelperFunctions.putTextInSpaces("Price", 36):""}${paid>=0?PrinterHelperFunctions.putTextInSpaces("Price", 12):""}\n";
    }

    ans += PrinterHelperFunctions.line;

    for (int i = 0; i < ls.length; i++) {
      if (ls[i].isNotProduct) {
        continue;
      }
      ans +=
          "${PrinterHelperFunctions.putTextInSpaces(ls[i].printName,paid>=0? 19:41,position: 2)}${PrinterHelperFunctions.putTextInSpaces(ls[i].qty.toStringAsFixed(qtyCommas), 7)}${paid>=0?PrinterHelperFunctions.putTextInSpaces(ls[i].unitPrice.toStringAsFixed(priceCommas), 10):""}${paid>=0?PrinterHelperFunctions.putTextInSpaces(ls[i].calcTotalPrice().toInt().toString(), 12):""}\n";
    }
    print(paid>=0);

    if(paid >=0){
      ans += PrinterHelperFunctions.line;
      ans +=
          "${PrinterHelperFunctions.putTextInSpaces("Total  ", 25,position: 2)}${PrinterHelperFunctions.putTextInSpaces(value.format(_currentProducts.totalPrice.toInt()).toString(), 23)}\n";
    }
    ans += PrinterHelperFunctions.line;

    return ans;
  }

  void togglePrinter() {
    printerOn = !printerOn;
    printerOn = printerOn && currentUserss.operationKeys.printer;
    notifyListeners();
  }

  void openRcPdCh() {
    rcPdChOpened = true;
    notifyListeners();
  }

  void closeRcPdCh() {
    rcPdChOpened = false;
    notifyListeners();
  }

  void holdRf() {
    _rfToggled = true;
    notifyListeners();
  }

  void dHoldRf() {
    _rfToggled = false;
    notifyListeners();
  }

  double getAnsAsDouble() {
    try {
      double result = double.parse(_ans);
      if (result > 0) {
        return result;
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  int getAnsAsInt() {
    if (_ans.contains(".")) {
      throw Exception();
    }
    try {
      int result = int.parse(_ans);
      if (result > 0) {
        return result;
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  void clearAll() {
    rcPdChOpened = false;
    _ans = "0";

    _currentProducts.clearProductsList();

    _qty = 1;

    notifyListeners();
  }

  void clearAns() {
    _ans = "0";
    notifyListeners();
  }

  void setQty(double newQty) {
    _qty = newQty;
    clearAns();
  }

  void pressKey(String s) async {
    if (s == "C") {
      _ans = "0";
      setQty(1);
      diselectedProduct();
    } else if (s == "0") {
      if (_ans.isNotEmpty &&
          _ans[_ans.length - 1] == "0" &&
          double.parse(_ans) == 0 &&
          !_ans.contains(".")) {
      } else {
        _ans += "0";
      }
    } else if (s == "1" ||
        s == "2" ||
        s == "3" ||
        s == "4" ||
        s == "5" ||
        s == "6" ||
        s == "7" ||
        s == "8" ||
        s == "9") {
      if (ans == "") {
        _ans += s;
      } else if (_ans == "0") {
        _ans = s;
      } else if (double.parse(_ans) != 0 || _ans.contains(".")) {
        _ans += s;
      }
    } else if (s == "00") {
      if ((_ans == "" || double.parse(_ans) == 0) && !_ans.contains(".")) {
      } else {
        _ans += "00";
      }
    } else if (s == ".") {
      if (_ans.contains(".") || _ans.isEmpty) {
      } else {
        _ans += ".";
      }
    } else if (s == "X") {}
    notifyListeners();
  }

  final List<ProductList> _clientProducts = [
    ProductList(),
    ProductList(),
    ProductList()
  ];

  final List<bool> _clients = [false, false, false];
  final ProductList _currentProducts = ProductList();
  bool _isProductSelected = false;
  int _selectedProductIndex = 0;

  ProductList get products {
    return _currentProducts;
  }

  int get selectedProductIndex {
    return _selectedProductIndex;
  }

  bool get isProductSelected {
    return _isProductSelected;
  }

  int get productsLength {
    return _currentProducts.productsLength();
  }

  bool firstClient() {
    return _clients[0];
  }

  bool secondClient() {
    return _clients[1];
  }

  bool thirdClient() {
    return _clients[2];
  }

  void removeAtIndex() {
    if (_isProductSelected) {
      _currentProducts.removeAtIndex(_selectedProductIndex);
    } else {
      _currentProducts.removeUsingBarcode(ans, _qty);
    }
    notifyListeners();
  }

  void changeQtyAtIndex(double newQty) {
    if (_isProductSelected) {
      _currentProducts.changeQtyAtIndex(_selectedProductIndex, newQty);
      notifyListeners();
    }
  }

  void selecteProduct(int index) {
    _selectedProductIndex = index;
    _isProductSelected = true;
    notifyListeners();
  }

  void diselectedProduct() {
    _isProductSelected = false;
    notifyListeners();
  }

  void storeCurrentProductsAtClient(int index) {
    if (_currentProducts.isNotEmpty()) {
      if (_clientProducts[index].isEmpty() && !_clients[index]) {
        _clientProducts[index].copyProductsFromAnotherList(_currentProducts);
        _clients[index] = true;
        _currentProducts.clearProductsList();
      }
      notifyListeners();
    } else {
      throw Exception();
    }
  }

  void getProductsFromClientAt(int index) {
    if (_clients[index] && _currentProducts.isEmpty()) {
      _currentProducts.copyProductsFromAnotherList(_clientProducts[index]);
      _clientProducts[index].clearProductsList();
      _clients[index] = false;
      notifyListeners();
    } else {
      throw Exception();
    }
  }

  void addProduct(
    String desc,
    double qty,
    double unitPrice,
    String barcode,
    int index,
    int unitNum,
    int groupId,
    int deptId,
    String printName,
      int printerId
  ) {
    Product product = Product(
      productDesc: desc,
      printName: printName,
      quantity: qty,
      price: unitPrice,
      barcode: barcode,
      id: index,
      unitNum: unitNum,
      groupId: groupId,
      deptId: deptId,
      printerId: printerId
    );
    int _index = _currentProducts.products.indexOf(product);
    print("**********************");
    print(index);
    print("**********************");

    if (_index == -1) {
      _currentProducts.addProduct(product);
    } else {
      if (_currentProducts.products[_index].barcode != "-2") {
        _currentProducts.changeQtyAtIndex(
            _index, _currentProducts.products[_index].quantity + qty);
      } else {
        _currentProducts.products[_index].price += product.unitPrice;
      }
    }

    notifyListeners();
  }

  void addBonus(double value, {bool isPercentage = false}) {
    if (total == 0) {
      throw Exception();
    }
    if (isPercentage) {
      _currentProducts.addBonusPercentage(value);
      Product foundProduct = _currentProducts.products.firstWhere(
          (element) => element.isBonus,
          orElse: () => Product(
              productDesc: "productDesc",
              quantity: 0,
              price: 0,
              barcode: "0",
              id: -3,
              unitNum: 0,
              groupId: 0,
              deptId: 0,
              printName: "0"));
      print(foundProduct);
      if (foundProduct.id == -3) {
        _currentProducts.addProduct(
          Product(
            productDesc: "Bonus $value %",
            quantity: 1,
            price: value,
            isBonus: true,
            barcode: "-1",
            id: -1,
            unitNum: -1,
            groupId: -1,
            deptId: -1,
            printName: "",
          ),
        );
      } else {
        int index = _currentProducts.products.indexOf(foundProduct);
        _currentProducts.products[index] = Product(
          productDesc: "Bonus ${foundProduct.price + value} %",
          quantity: 1,
          price: foundProduct.price + value,
          isBonus: true,
          barcode: "-1",
          id: -1,
          unitNum: -1,
          groupId: -1,
          deptId: -1,
          printName: "",
        );
      }
    } else {
      _currentProducts.addBonus(value);
      _currentProducts.addProduct(
        Product(
          productDesc: "Bonus",
          quantity: 1,
          price: value,
          isBonus: true,
          barcode: "-1",
          id: -1,
          unitNum: -1,
          groupId: -1,
          deptId: -1,
          printName: "",
        ),
      );
    }

    notifyListeners();
  }

  void addDiscount(double value, {bool isPercentage = false}) {
    if (total == 0) {
      throw Exception();
    }
    if (isPercentage) {
      _currentProducts.addDiscountPercentage(value);
      _currentProducts.addProduct(
        Product(
          productDesc: "Discount $value %",
          quantity: 1,
          price: value,
          isDiscount: true,
          barcode: "-1",
          id: -1,
          unitNum: -1,
          groupId: -1,
          deptId: -1,
          printName: "",
        ),
      );
    } else {
      _currentProducts.addDiscount(value);
      _currentProducts.addProduct(
        Product(
          productDesc: "Discount",
          quantity: 1,
          price: value,
          isDiscount: true,
          barcode: "-1",
          id: -1,
          unitNum: -1,
          groupId: -1,
          deptId: -1,
          printName: "",
        ),
      );
    }
    notifyListeners();
  }
}
