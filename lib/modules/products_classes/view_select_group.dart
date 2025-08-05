import 'package:magicposbeta/modules/products_classes/abs_group.dart';

class ViewSelectGroup extends AbsGroup {
  bool isSelected = false;

  ViewSelectGroup({
    required super.id,
    required super.name,
    required this.isSelected,
  });

  static String getSelectId(List<ViewSelectGroup> groups) {
    String value = "";
    for (var group in groups) {
      if (group.isSelected) {
        value += ", ${group.id}";
      }
    }
    return value;
  }

  static ViewSelectGroup emptyInstance() {
    return ViewSelectGroup(id: 0, name: "", isSelected: false);
  }
}
