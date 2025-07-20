import 'package:magicposbeta/database/functions/groups_functions.dart';
import 'package:magicposbeta/database/initialize_database.dart';
import 'package:magicposbeta/theme/locale/errors.dart';

import '../../components/reverse_string.dart';
import '../../theme/custom_exception.dart';

class SectionsFunctions {
  static const String tableName = "departments";

  //fields
  static const String idF = "id_department";
  static const String nameF = "section_name";
  static const String printerIdF = "printer_id";
  static const String cash1F = "cash_total_sells_price_two";
  static const String cash2F = "cash_total_sells_price_one";
  static const String sells2F = "total_sells_price_two";
  static const String sells1F = "total_sells_price_one";
  static const String qty2F = "sold_quantity_two";
  static const String qty1F = "sold_quantity_one";
  static const String productQtyF = "products_QTY";
  static const String selectedF = "selected_department";
  static const String printNameF = "Print_Name_department";
  static const String defaultDepartmentName = "متفرقات";
  static final PosData _data = PosData();

  static Future<int> addProductToDepartment(String name) async {
    List<Map> response = await getDepartmentList(name);
    int id = response[0][idF];

    await _data.changeData(
        "UPDATE $tableName set $productQtyF=${response[0][productQtyF] + 1} WHERE $idF=$id");
    return id;
  }

  static Future<List<Map>> getDepartmentList(String name,
      {String printerCondition = "",
      bool sameDepartment = false,
      String groupFilterValue = ""}) async {
    String condition = "WHERE ";
    String joinText = "";
    if (name != "") {
      if (sameDepartment) {
        condition += "$nameF='$name'";
      } else {
        condition += "$nameF LIKE '%$name%'";
      }
    }
    if (printerCondition != "") {
      if (name != "") condition += " AND ";
      condition += printerCondition;
    }
    if (groupFilterValue != "") {
      if (name != "" || printerCondition != "") condition += " AND ";
      condition += "group_name LIKE '%$groupFilterValue%'";
      joinText = "JOIN `groups` ON($tableName.$idF=`groups`.section_number)";
    }
    if (condition == "WHERE ") condition = "";

    return await _data.readData(
        "SELECT $tableName.* FROM $tableName $joinText $condition ORDER BY $nameF ");
  }

  static Future<int> addSection(
    String name,
  ) async {
    if (name != "") {
      List<Map> response0 =
          await _data.readData("SELECT * FROM $tableName WHERE $nameF='$name'");
      if (response0.isEmpty) {
        String printName = reversArString(name);
        return await _data.insertData(
            "INSERT INTO $tableName ($nameF,$printNameF)VALUES('$name','$printName')");
      } else {
        throw CustomException(ErrorsCodes.sectionIsExistPreviously);
      }
    } else {
      throw CustomException(ErrorsCodes.selectSectionFirst);
    }
  }

  static Future<bool> deleteSection(
    String name,
  ) async {
    if (name == "") {
      throw CustomException(ErrorsCodes.selectSectionFirst);
    } else if (name == defaultDepartmentName) {
      throw CustomException(ErrorsCodes.canNotDeleteThisSection);
    } else {
      List<Map> response = await getDepartmentList(name);
      List<Map> response0 = await GroupsFunctions.getGroupsList(
          groupName: "", departmentId: response[0]["id_department"]);
      List<Map> response1 = await _data
          .readData("SELECT * FROM dept WHERE department=${response[0][idF]}");
      if (response1.isNotEmpty) {
        throw CustomException(ErrorsCodes.canNotDeleteSectionDeptsRefernce);
      }
      if (response0.isNotEmpty) {
        throw CustomException(ErrorsCodes.canNotDeleteSectionGroupsRefernce);
      } else if (response[0][qty1F] > 0 || response[0][qty2F] > 0) {
        throw CustomException(ErrorsCodes.canNotDeleteSectionReportsRefernce);
      } else {
        _data.deleteData(
            "DELETE FROM $tableName WHERE $idF=${response[0][idF]}");
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
    int id = 0;
    List<Map> response = await getDepartmentList(name, sameDepartment: true);
    if (response.isEmpty) {
      id = await addSection(name);
    } else {
      id = response[0][idF];
    }
    double newQty1 = response[0][qty1F] + qty1;
    double newQty2 = response[0][qty2F] + qty2;
    double newSells1 = response[0][sells1F] + sells1;
    double newSells2 = response[0][sells2F] + sells2;
    double newProductQty = response[0][productQtyF] + productQTY;
    return await _data.changeData(
        "UPDATE $tableName SET $productQtyF=$newProductQty,$qty1F=$newQty1, $qty2F=$newQty2,$sells1F=$newSells1,$sells2F=$newSells2 WHERE $idF=$id");
  }

  static Future<void> decreaseQtyAndSells(
      {required String name,
      required double qty1,
      required double sells1,
      required double qty2,
      required double sells2,
      required double productQTY}) async {
    int id = 0;
    List<Map> response = await getDepartmentList(name, sameDepartment: true);

    id = response[0][idF];

    double newQty1 = response[0][qty1F] - qty1;
    double newQty2 = response[0][qty2F] - qty2;
    double newSells1 = response[0][sells1F] - sells1;
    double newSells2 = response[0][sells2F] - sells2;
    double newProductQty = response[0][productQtyF] - productQTY;
    await _data.changeData(
        "UPDATE $tableName SET $productQtyF=$newProductQty,$qty1F=$newQty1, $qty2F=$newQty2,$sells1F=$newSells1,$sells2F=$newSells2 WHERE $idF=$id");
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
      throw CustomException(ErrorsCodes.selectSectionFirst);
    }
    if (newName == "") {
      throw CustomException(ErrorsCodes.didnotDetermineNewSectionName);
    }
    if (oldName == defaultDepartmentName) {
      throw CustomException(ErrorsCodes.cannotEditSection);
    }
    if (newName != oldName) {
      List<Map> response0 = await _data
          .readData("SELECT * FROM $tableName WHERE $nameF='$newName' ");
      if (response0.isEmpty) {
        await _data.changeData(
            "UPDATE `$tableName` SET $nameF='$newName',$printNameF='${reversArString(newName)}' WHERE $nameF='$oldName'");
      } else {
        throw CustomException(ErrorsCodes.sectionIsExistPreviously);
      }
    }
  }

  static checkSelectedUnselected(String sectionName, int id) async {
    String condition = sectionName == "" ? "$idF=$id" : "$nameF='$sectionName'";
    List<Map> checkSelect = await GroupsFunctions.getSelectedUnSelectedGroups(
        false, sectionName, id);
    await _data.changeData(
        "UPDATE $tableName SET $selectedF=${checkSelect.isEmpty} WHERE $condition");
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
        "UPDATE $tableName SET $fieldName=$newValue $currentCondition");
  }
}
