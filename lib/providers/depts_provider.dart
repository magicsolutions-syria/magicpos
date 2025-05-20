import 'package:flutter/material.dart';
import "../database/database_functions.dart";

class DeptsProvider with ChangeNotifier {
  bool _isDepts = false;
  List<Map> _depts = [];

  bool get isDepts {
    return _isDepts;
  }

  List<Map> get depts {
    return _depts;
  }

  void getDeptsList() async {
    List<Map> newDepts = await getDepts();
    print("*******");
    print(newDepts);
    print("********");
    _depts = [...newDepts];
    notifyListeners();
  }

  void toggleTrue() {
    _isDepts = true;
    notifyListeners();
  }

  void toggleFalse() {
    _isDepts = false;
    notifyListeners();
  }
  DeptsProvider(){
    getDeptsList();
  }
}
