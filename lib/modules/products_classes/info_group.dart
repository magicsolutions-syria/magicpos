import 'package:magicposbeta/modules/products_classes/info_department.dart';
import 'package:magicposbeta/modules/products_classes/abs_group.dart';

class InfoGroup extends AbsGroup {
  final InfoDepartment department;

  InfoGroup({
    required this.department,
    super.id = -1,
    required super.name,
  });

  static InfoGroup emptyInstance() {
    return InfoGroup(
        id: 0, name: "", department: InfoDepartment.emptyInstance());
  }

  static fullInstance(
      {required int id,
      required String name,
      required InfoDepartment department}) {
    String nameV = "";
    if (name == "") {
      throw Exception("حقل المجموعة لا يمكن أن يكون فارغاً");
    } else {
      nameV = name;
    }
    return InfoGroup(id: id, department: department, name: name);
  }
}
