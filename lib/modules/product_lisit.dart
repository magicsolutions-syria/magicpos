import "package:flutter/services.dart";
import "package:magicposbeta/database/database_functions.dart";

import "../modules/product.dart";

class ProductList {
  List<Product> products = [];
  double totalPrice = 0;
  double bonus = 0;
  double discount = 0;
  double finalPrice = 0;

  double bonusPercentage = 0;
  double discountPercentage = 0;

  ProductList();

  List<Product> getProducts() {
    return [...products];
  }

  int productsLength() {
    return products.length;
  }

  double calcBonus() {
    return bonus + (bonusPercentage * totalPrice / 100.0);
  }

  double calcDiscount() {
    return discount + (discountPercentage * totalPrice / 100.0);
  }

  void addBonusPercentage(double value) {
    bonusPercentage += value;
    updateFinalPrice();
  }

  void addDiscountPercentage(double value) {
    if (discountPercentage + value >= 100.0) {
      throw Exception();
    }
    discountPercentage += value;
    updateFinalPrice();
  }

  void addBonus(double value) {
    bonus += value;
    updateFinalPrice();
  }

  void addDiscount(double value) {
    double newDiscount = discount + value;
    double newFinalPrice = totalPrice +
        bonus -
        newDiscount +
        (bonusPercentage * totalPrice / 100.0) -
        (discountPercentage * totalPrice / 100.0);
    if (newFinalPrice < 0) {
      throw Exception();
    }
    discount += value;
    updateFinalPrice();
  }

  void updateFinalPrice() {
    finalPrice = totalPrice +
        bonus -
        discount +
        (bonusPercentage * totalPrice / 100.0) -
        (discountPercentage * totalPrice / 100.0);
  }

  void changeQtyAtIndex(int index, double newQty) {
    double oldPrice = products[index].calcTotalPrice();
    products[index].changeQty(newQty);
    totalPrice += products[index].calcTotalPrice() - oldPrice;
    updateFinalPrice();
  }

  void addProduct(Product product) {
    if (!product.isNotProduct) {
      totalPrice += product.calcTotalPrice();
    }
    updateFinalPrice();
    products.add(product);
  }

  Product getProductAtIndex(int index) {
    return products[index];
  }

  List findProduct(String barcode) {
    for (int i = 0; i < products.length; i++) {
      if (products[i].barcode == barcode) {
        return [i, products[i]];
      }
    }
    throw Exception();
  }

  void removeUsingBarcode(String barcode, double qty) {

    Product foundProduct = products.firstWhere((element) => (element.barcode == barcode), orElse: () => Product(productDesc: "productDesc", quantity: 0, price: 0, barcode: "-1", id: -5, unitNum: 0, groupId: 0, deptId: 0, printName: "printName"));

    if (foundProduct.id == -5) {
      throw Exception();
    }
    if (foundProduct.qty < qty) {
      throw Exception();
    }
    updateFunctionsKeysValue("rf", qty * foundProduct.price);

    int index = products.indexOf(foundProduct);

    if (foundProduct.qty == qty) {
      totalPrice -= foundProduct.calcTotalPrice();
      updateFinalPrice();
      removeAtIndex(index);
    } else {
      changeQtyAtIndex(index, foundProduct.qty - qty);
      updateFinalPrice();
    }
  }

  void removeAtIndex(int index) {
    Product removedProduct = products[index];
    if (!removedProduct.isNotProduct) {
      totalPrice -= removedProduct.calcTotalPrice();
    } else {
      if (removedProduct.isBonus) {
        if (removedProduct.desc == "Bonus") {
          bonus -= removedProduct.unitPrice;
        } else {
          bonusPercentage -= removedProduct.unitPrice;
        }
      } else {
        if (removedProduct.desc == "Discount") {
          discount -= removedProduct.unitPrice;
        } else {
          discountPercentage -= removedProduct.unitPrice;
        }
      }
    }
    products.removeAt(index);
    updateFinalPrice();
  }

  void clearProductsList() {
    products.clear();
    totalPrice = 0;
    bonus = 0;
    discount = 0;
    finalPrice = 0;
    bonusPercentage = 0;
    discountPercentage = 0;
  }

  void copyProductsFromAnotherList(ProductList p) {
    products = p.getProducts();
    totalPrice = p.totalPrice;
    bonus = p.bonus;
    discount = p.discount;
    bonusPercentage = p.bonusPercentage;
    discountPercentage = p.discountPercentage;
    finalPrice = p.finalPrice;
  }

  bool isNotEmpty() {
    return products.isNotEmpty;
  }

  bool isEmpty() {
    return products.isEmpty;
  }
}
