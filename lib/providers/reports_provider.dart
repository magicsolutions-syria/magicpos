import 'package:flutter/cupertino.dart';

class Pro extends ChangeNotifier {
  bool s = false;

  flip() async{

    s = !s;
    notifyListeners();
  }


  String button(bool o) {
    if (o) {
      if (s) {
        return "تقرير يومي";
      } else {
        return "تقرير تجميعي";
      }
    } else {
      return "";
    }
  }
}
