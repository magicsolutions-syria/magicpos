
import 'package:magicposbeta/modules/products_classes/abs_department.dart';

import 'view_select_group.dart';

class ViewSelectDepartment extends AbsDepartment {
  bool isSelected = false;
  List<ViewSelectGroup>groups=[];


  ViewSelectDepartment({
    required super.id,
    required super.name,
    required this.isSelected,
  });

  static String getSelectId(List<ViewSelectDepartment> departments) {
    String value="";
    for (var department in departments) {
      if(department.isSelected) {
        value+=", ${department.id}";
      }
    }
    if(value.isEmpty)return value;
    return value.substring(1);
  }

  static ViewSelectGroup emptyInstance() {
    return ViewSelectGroup(id: 0, name: "", isSelected: false);
  }

  void addGroup(
      {required int id, required String name, required bool isSelected}) {
    ViewSelectGroup  newGroup = ViewSelectGroup(id: id, name: name, isSelected: isSelected);
    groups.add(newGroup);
  }

  void checkIfSelected() {
    bool check = true;
    for (var e in groups) {
      check = check && e.isSelected;
      if(!check)return;
    }
    if(check){isSelected=true;}
    else {
      isSelected=false;
    }
  }



}
