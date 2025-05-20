import 'dart:math';

import 'package:flutter/material.dart';
import 'package:magicposbeta/theme/custom_colors.dart';
import 'package:magicposbeta/database/database_functions.dart';
import 'package:magicposbeta/database/functions/groups_functions.dart';
import 'package:magicposbeta/database/functions/product_functions.dart';

import '../modules/product.dart';

class GroupProvider with ChangeNotifier {
  int _index = 0;
  List _groups = [];
  List<Product> _products = [];

  int get index {
    return _index;
  }

  List<Product> get products {
    return _products;
  }

  List get currentGroup {

    List firstList = _groups.sublist((index - 1) * 16, min(_groups.length, index * 16));
    print(_groups);
    return List.generate(firstList.length, (index) => {
      "department": firstList[index][_index == 1 ? "department" : "group_name"],
      "Print_Name": firstList[index][_index == 1 ? "Print_Name" : "group_name"],
      "id": index,
      "txt": "${firstList[index][_index == 1 ? "name" : "group_name"]}",
      "color": MyCustomColors.primaryColor,
      "fontSize": 22.0,
      "onPressed": () async {
        if (_index > 1) {
          List<Map> productsList = await ProductFunctions.getProductList(searchText: "", searchType: "", secondCondition: "group_name = '${firstList[index]["group_name"]}'");
          _products = [];
          productsList.forEach((element) {
            _products.add(Product.fromDataMap(element));
          });

          notifyListeners();
        }
      },
    });
  }

  int getLength() {
    return _groups.length;
  }

  void setGroups(List groups) {
    _groups = groups;

  }

  void increaseIndex() {
    _index++;
    notifyListeners();
  }

  void decreaseIndex() {
    _index--;
    notifyListeners();
  }
}