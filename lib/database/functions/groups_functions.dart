import 'package:flutter/src/widgets/editable_text.dart';
import 'package:magicposbeta/database/functions/product_functions.dart';
import 'package:magicposbeta/database/functions/sections_functions.dart';
import 'package:magicposbeta/modules/custom_exception.dart';
import 'package:magicposbeta/modules/products_classes/info_department.dart';

import '../../components/reverse_string.dart';
import '../../modules/products_classes/info_group.dart';
import '../initialize_database.dart';

class GroupsFunctions {
  static const String tableName = "`groups`";

  //fields
  static const String idF = "id_group";
  static const String nameF = "group_name";
  static const String printerIdF = "printer_id";
  static const String department = "section_number";
  static const String sells2F = "total_sells_price_two";
  static const String sells1F = "total_sells_price_one";
  static const String qty2F = "sold_quantity_two";
  static const String qty1F = "sold_quantity_one";
  static const String productQtyF = "products_QTY";
  static const String selectedF = "selected_group";
  static const String printNameF = "Print_Name_group";
  static final PosData _data = PosData();

  static Future<List<Map>> getGroupsList(
      {required InfoGroup group,
      bool sameGroup = false,
      printerCondition = ""}) async {
    try {
      String condition = "";
      String groupNameCondition = sameGroup
          ? "group_name='${group.name}'"
          : "group_name LIKE '%${group.name}%'";
      String departmentCondition = group.department.id != -1
          ? "WHERE section_number=${group.department.id}'"
          : "";
      if (group.name != "") {
        condition = "$departmentCondition AND $groupNameCondition";
      } else if (printerCondition != "") {
        condition = "$departmentCondition AND ($printerCondition)";
      } else {
        condition = departmentCondition;
      }
      return await _data.readData(
          "SELECT `groups`.*,departments.section_name FROM `groups` JOIN departments ON departments.id_department=`groups`.section_number $condition ORDER BY group_name");
    } catch (e) {
      throw CustomException(e.toString());
    }
  }

  static Future<int> addGroup({
    required String groupName,
    String departmentName = "",
    int departmentId = -1,
  }) async {
    if (departmentName == "" && departmentId == -1) {
      throw Exception("يرجى تحديد قسم من قائمة الأقسام");
    }
    List<Map> response0 =
        await SectionsFunctions.getDepartmentList(departmentName);
    if (response0.isEmpty) {
      await SectionsFunctions.addSection(departmentName);
    }
    if (groupName != "") {
      List<Map> response = await getGroupsList(
          group: InfoGroup(
              department:
                  InfoDepartment(id: departmentId, name: departmentName),
              name: groupName),
          sameGroup: true);
      if (response.isEmpty) {
        int id = 0;
        if (departmentId == -1 && departmentName == "") {
          id = 0;
        } else if (departmentName != "" && departmentId == -1) {
          List<Map> res =
              await SectionsFunctions.getDepartmentList(departmentName);
          id = res[0]["id_department"];
        } else {
          id = departmentId;
        }
        String printName = reversArString(groupName);
        await _data.changeData(
            "UPDATE departments SET selected_department=0 WHERE id_department=$id");
        return await _data.insertData(
            "INSERT INTO `groups` (group_name,section_number,Print_Name_group)VALUES('$groupName',$id,'$printName')");
      } else {
        throw Exception("هذه المجموعة موجودة\nمسبقاً");
      }
    } else {
      throw Exception("حقل المجموعة لا يمكن أن يكون فارغاً");
    }
  }

  static Future<bool> deleteGroup({
    required String groupName,
    String departmentName = "",
    int departmentId = -1,
  }) async {
    /*  if (groupName != "") {
      List<Map> response = await getGroupsList(group: group, sameGroup: true);
      if (response[0]['products_QTY'] > 0) {
        throw Exception("لا يمكنك حذف هذه المجموعة فهي\nتحتوي مواد مرتبطة بها");
      }
      if (response[0]['sold_quantity_one'] > 0 ||
          response[0]['sold_quantity_two'] > 0) {
        throw Exception(
            "لا يمكنك حذف هذه المجموعة عليك تصفير\n التقارير المرتبطة بها أولاً");
      }
      int id = 0;
      if (departmentId == -1 && departmentName == "") {
        id = 0;
      } else if (departmentName != "" && departmentId == -1) {
        id = response[0]["section_number"];
      } else {
        id = departmentId;
      }
      await SectionsFunctions.checkSelectedUnselected(departmentName, id);
      _data.deleteData(
          "DELETE FROM `groups` WHERE group_name='$groupName' AND section_number=$id");
      return true;
    } else {
      throw CustomException("يجب تحديد مجموعة\nأولاًً");
    }*/
    return false;
  }

  static Future<int> addProductToGroup(
      String groupName, int departmentId) async {
    /*  List<Map> response = await getGroupsList(group: group, sameGroup: true);
    int id = response[0]["id_group"];
    await _data.changeData(
        "UPDATE `groups` set products_QTY=${response[0]["products_QTY"] + 1} WHERE id_group=$id");
    return id;*/
    return 0;
  }

  static Future<int> initializeGroup(InfoGroup group) async {
    /*
    List<Map> response = await getGroupsList(group: group, sameGroup: true);
    if (response.isEmpty) {
      await addGroup(group: group);
    }
    return addProductToGroup(group: group);*/
    return 0;
  }

  static Future<int> increaseQtyAndSells({
    required String groupName,
    required int departmentId,
    required double qty1,
    required double sells1,
    required double qty2,
    required double sells2,
  }) async {
    /* int id = 0;
    List<Map> response = await getGroupsList(group: group, sameGroup: true);
    if (response.isEmpty) {
      id = await addGroup(groupName: groupName, departmentId: departmentId);
    } else {
      id = response[0]['id_group'];
    }
    double newQty1 = response[0]["sold_quantity_one"] + qty1;
    double newQty2 = response[0]["sold_quantity_two"] + qty2;
    double newSells1 = response[0]["total_sells_price_one"] + sells1;
    double newSells2 = response[0]["total_sells_price_two"] + sells2;
    double newProductQty = response[0]["products_QTY"] + 1;

    return await _data.changeData(
        "UPDATE `groups` SET products_QTY=$newProductQty,sold_quantity_one=$newQty1, sold_quantity_two=$newQty2,total_sells_price_one=$newSells1,total_sells_price_two=$newSells2 WHERE id_group=$id");
  */
    return 0;
  }

  static Future<void> decreaseQtyAndSells({
    required String groupName,
    required int departmentId,
    required double qty1,
    required double sells1,
    required double qty2,
    required double sells2,
  }) async {
    /*
    int id = 0;
    List<Map> response = await getGroupsList(group: group, sameGroup: true);

    id = response[0]['id_group'];

    double newQty1 = response[0]["sold_quantity_one"] - qty1;
    double newQty2 = response[0]["sold_quantity_two"] - qty2;
    double newSells1 = response[0]["total_sells_price_one"] - sells1;
    double newSells2 = response[0]["total_sells_price_two"] - sells2;
    double newProductQty = response[0]["products_QTY"] - 1;
    await _data.changeData(
        "UPDATE `groups` SET products_QTY=$newProductQty,sold_quantity_one=$newQty1, sold_quantity_two=$newQty2,total_sells_price_one=$newSells1,total_sells_price_two=$newSells2 WHERE id_group=$id");
 */
  }

//todo when add group and section is not exist
  static Future<int> transferQtySells({
    required String groupNameNew,
    required int departmentIdNew,
    required departmentIdOld,
    required String groupNameOld,
    required double qty1,
    required double sells1,
    required double qty2,
    required double sells2,
  }) async {
    /*
    if (groupNameNew == groupNameOld && departmentIdNew == departmentIdOld) {
      List<Map> response = await getGroupsList(group: group, sameGroup: true);
      return response[0]['id_group'];
    }

    decreaseQtyAndSells(
        groupName: groupNameOld,
        departmentId: departmentIdOld,
        qty1: qty1,
        sells1: sells1,
        qty2: qty2,
        sells2: sells2);
    return increaseQtyAndSells(
        groupName: groupNameNew,
        departmentId: departmentIdNew,
        qty1: qty1,
        sells1: sells1,
        qty2: qty2,
        sells2: sells2);*/
    return 0;
  }

  static Future<void> updateGroup({
    required InfoGroup oldGroup,
    required InfoGroup newGroup,
  }) async {
    /*
    if (oldGroup.name == "") {
      throw CustomException("يرجى تحديد مجموعة من قائمة المجموعات");
    }
    if (newGroup.name == "") {
      if (oldGroup.department == newGroup.department) {
        return;
      }
      newGroup.setName(oldGroup.name);
    }
    List<Map> response = await getGroupsList(group: newGroup, sameGroup: true);
    if (response.isEmpty) {
      List<Map> response =
          await SectionsFunctions.getDepartmentList(newGroup.department);
      int index = response[0]["id_department"];
      String printName = reversArString(newGroup.name);

      await _data.changeData(
          "UPDATE `groups` SET section_number=$index ,group_name ='${newGroup.name}' , Print_Name_group='$printName' WHERE group_name='${oldGroup.name}' ");

      await SectionsFunctions.checkSelectedUnselected(
        oldGroup.department,
      );
      await SectionsFunctions.checkSelectedUnselected(
        newGroup.department,
      );
      await SectionsFunctions.transferQtySells(
          oldDepartment: oldGroup.department,
          newDepartment: newGroup.department);

      await ProductFunctions.updateProductDepartmentByGroup(index, oldGroup.id);
    } else {
      throw Exception("هذه المجموعة موجودة\nمسبقاً");
    }*/
  }

  static Future<List<Map>> getSelectedUnSelectedGroups(
      bool selected, String departmentName, int id) async {
    String condition = "";
    if (departmentName != "") {
      condition = " AND section_name='$departmentName'";
    } else if (id != -1) {
      condition = "  AND  section_number=$id";
    }

    return await _data.readData(
        "SELECT * FROM `groups` JOIN departments ON (`groups`.section_number=`departments`.id_department) WHERE `selected_group`=${selected ? 1 : 0} $condition ORDER BY group_name");
  }

  static Future<void> changeSelectValues(
      {required String fieldName,
      required int newValue,
      required String condition}) async {
    String currentCondition = "";
    if (condition != "") {
      currentCondition = "WHERE $condition";
    }
    await _data.changeData(
        "UPDATE `groups` SET $fieldName=$newValue $currentCondition");
  }
}
