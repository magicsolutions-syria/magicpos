import 'package:flutter/src/widgets/editable_text.dart';
import 'package:magicposbeta/database/functions/groups_functions.dart';
import 'package:magicposbeta/database/initialize_database.dart';

import '../../components/reverse_string.dart';

class SectionsFunctions {
  static Future<int> addProductToDepartment(String name) async {
    PosData data = PosData();
    List<Map> response = await getDepartmentList(name);
    int id = response[0]["id_department"];

    await data.changeData(
        "UPDATE departments set products_QTY=${response[0]["products_QTY"] + 1} WHERE id_department=$id");
    return id;
  }

  static Future<List<Map>> getDepartmentList(String name, {String printerCondition = "",bool sameDepartment=false}) async {
    PosData data = PosData();
    String condition = "";
    if (name != "") {
      if(sameDepartment){
        condition="WHERE section_name='$name'";
      }
      else {
        condition = "WHERE section_name LIKE '%$name%'";
      }
    }
    if(printerCondition !=""){
      condition = "WHERE $printerCondition";
    }

    return await data.readData(
        "SELECT * FROM departments $condition ORDER BY section_name ");
  }

  static Future<int> addSection(
    String name,
  ) async {
    PosData data = PosData();
    if (name != "") {
      List<Map> response0 = await data
          .readData("SELECT * FROM departments WHERE section_name='$name'");
      if (response0.isEmpty) {
        String printName = reversArString(name);
        return await data.insertData(
            "INSERT INTO departments (section_name,Print_Name_department)VALUES('$name','$printName')");
      } else {
        throw Exception("هذا القسم موجود\nمسبقاً");
      }
    } else {
      throw Exception("حقل القسم لا يمكن ان\nيكون فارغاً");
    }
  }

  static Future<bool> deleteSection(
    String name,
  ) async {
    PosData data = PosData();
    if (name == "") {
      throw Exception("يجب تحديد قسم أولاً");
    } else if (name == "متفرقات") {
      throw Exception("لا يمكنك حذف\nهذا القسم");
    } else {
      List<Map> response = await getDepartmentList(name);
      List<Map> response0 = await GroupsFunctions.getGroupsList(
          groupName: "", departmentId: response[0]["id_department"]);
      List<Map> response1 = await data.readData(
          "SELECT * FROM dept WHERE department=${response[0]['id_department']}");
      if (response1.isNotEmpty) {
        throw Exception("لا يمكنك حذف هذا القسم فهو\nيحتوي depts مرتبطة به");
      }
      if (response0.isNotEmpty) {
        throw Exception("لا يمكنك حذف هذا القسم فهو\nيحتوي مجموعات مرتبطة به");
      } else if (response[0]["sold_quantity_one"] > 0 ||
          response[0]["sold_quantity_two"] > 0) {
        throw Exception(
            "لا يمكنك حذف هذا القسم عليك تصفير\nالتقارير المرتبطة به أولاً");
      } else {
        data.deleteData(
            "DELETE FROM departments WHERE id_department=${response[0]['id_department']}");
        return true;
      }
    }
  }

  static Future<int> initializeDepartment(String name) async {
    List<Map> response = await getDepartmentList(name);
    if (response.isEmpty) {
      await addSection(name);
    }
    return addProductToDepartment(name);
  }

  static Future<int> increaseQtyAndSells(
      {required String name,
      required double qty1,
      required double sells1,
      required double qty2,
      required double sells2,
      required double productQTY}) async {
    PosData data = PosData();
    int id = 0;
    List<Map> response = await getDepartmentList(name);
    if (response.isEmpty) {
      id = await addSection(name);
    } else {
      id = response[0]['id_department'];
    }
    double newQty1 = response[0]["sold_quantity_one"] + qty1;
    double newQty2 = response[0]["sold_quantity_two"] + qty2;
    double newSells1 = response[0]["total_sells_price_one"] + sells1;
    double newSells2 = response[0]["total_sells_price_two"] + sells2;
    double newProductQty = response[0]["products_QTY"] + productQTY;
    return await data.changeData(
        "UPDATE departments SET products_QTY=$newProductQty,sold_quantity_one=$newQty1, sold_quantity_two=$newQty2,total_sells_price_one=$newSells1,total_sells_price_two=$newSells2 WHERE id_department=$id");
  }

  static Future<void> decreaseQtyAndSells(
      {required String name,
      required double qty1,
      required double sells1,
      required double qty2,
      required double sells2,
      required double productQTY}) async {
    PosData data = PosData();
    int id = 0;
    List<Map> response = await getDepartmentList(name);

    id = response[0]['id_department'];

    double newQty1 = response[0]["sold_quantity_one"] - qty1;
    double newQty2 = response[0]["sold_quantity_two"] - qty2;
    double newSells1 = response[0]["total_sells_price_one"] - sells1;
    double newSells2 = response[0]["total_sells_price_two"] - sells2;
    double newProductQty = response[0]["products_QTY"] - productQTY;
    await data.changeData(
        "UPDATE departments SET products_QTY=$newProductQty,sold_quantity_one=$newQty1, sold_quantity_two=$newQty2,total_sells_price_one=$newSells1,total_sells_price_two=$newSells2 WHERE id_department=$id");
  }

  static Future<int> transferQtySells(
      {required String nameNew,
      required String nameOld,
      required double qty1,
      required double sells1,
      required double qty2,
      required double sells2,
      double productQTY = 1}) async {
    if (nameNew == nameOld) {
      return initializeDepartment(nameNew);
    }
    decreaseQtyAndSells(
        name: nameOld,
        qty1: qty1,
        sells1: sells1,
        qty2: qty2,
        sells2: sells2,
        productQTY: productQTY);
    return increaseQtyAndSells(
        name: nameNew,
        qty1: qty1,
        sells1: sells1,
        qty2: qty2,
        sells2: sells2,
        productQTY: productQTY);
  }

  static updateDepartmentName(
      {required String oldName, required String newName}) async {
    if (oldName == "") {
      throw Exception("يرجى اختيار قسم أولاً");
    }
    if (newName == "") {
      throw Exception("لم يتم تحديد اسم جديد للقسم");
    }
    if (oldName == "متفرقات") {
      throw Exception("لا يمكنك تعديل هذا القسم");
    }
    if (newName != oldName) {
      PosData data = PosData();
      List<Map> response0 = await data
          .readData("SELECT * FROM departments WHERE section_name='$newName' ");
      if (response0.isEmpty) {
        await data.changeData(
            "UPDATE `departments` SET section_name='$newName',Print_Name_department='${reversArString(newName)}' WHERE section_name='$oldName'");
      } else {
        throw Exception("هذا القسم موجود\nمسبقاً");
      }
    }
  }

  static checkSelectedUnselected(String sectionName, int id) async {
    PosData data = PosData();
    String condition =
        sectionName == "" ? "id_department=$id" : "section_name=$sectionName";
    List<Map> checkSelect = await GroupsFunctions.getSelectedUnSelectedGroups(
        false, sectionName, id);
    await data.changeData(
        "UPDATE departments SET selected_department=${checkSelect.isEmpty} WHERE $condition");
  }
}
