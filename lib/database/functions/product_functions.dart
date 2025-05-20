import 'package:magicposbeta/database/database_functions.dart';
import 'package:magicposbeta/theme/custom_exception.dart';
import 'package:magicposbeta/theme/locale/errors.dart';
import 'package:magicposbeta/theme/locale/search_types.dart';

import '../../components/reverse_string.dart';
import '../../modules/info_product.dart';
import '../initialize_database.dart';
import 'product_unit_functions.dart';
import 'sections_functions.dart';
import 'groups_functions.dart';

class ProductFunctions {
  static Future<String> initialProductId() async {
    return await initialId("products");
  }

  static Future<List<Map>> getProductList(
      {required String searchText,
      required String searchType,
      String secondCondition = ""}) async {
    PosData data = PosData();
    String columnName = "";
    switch (searchType) {
      case (SearchTypes.arName):
        {
          columnName = "ar_name";
          break;
        }
      case (SearchTypes.enName):
        {
          columnName = "en_name";
          break;
        }
      case (SearchTypes.code1):
        {
          columnName = "code_1";
          break;
        }
      case (SearchTypes.code2):
        {
          columnName = "code_2";
          break;
        }
      case (SearchTypes.code3):
        {
          columnName = "code_3";
          break;
        }
      default:
        {
          columnName = "ar_name";
          break;
        }
    }
    String condition = "";
    if (searchText != "" && secondCondition != "") {
      condition = "WHERE $columnName LIKE '%$searchText%' AND $secondCondition";
    } else if (searchText != "" && secondCondition == "") {
      condition = "WHERE $columnName LIKE '%$searchText%'";
    } else if (searchText == "" && secondCondition != "") {
      condition = "WHERE $secondCondition";
    }

    return await data.readData(
        "SELECT * FROM products JOIN departments ON id_department=`department` JOIN `groups` ON id_group=`group` JOIN unit_1 ON unit_one_id=id_1 JOIN unit_2 ON unit_two_id=id_2 JOIN unit_3 ON unit_three_id=id_3 $condition ORDER BY $columnName");
  }

  static Future<void> addProduct(InfoProduct item) async {
    try {
      PosData data = PosData();
      await _checkUniqueFields(item);
      int id_1 = await ProductUnitFunctions.initializeUnit(item.unit1);
      int id_2 = await ProductUnitFunctions.initializeUnitExpanded(item.unit2);
      int id_3 = await ProductUnitFunctions.initializeUnitExpanded(item.unit3);
      int departmentId =
          await SectionsFunctions.initializeDepartment(item.departmentName);
      int idGroup = await GroupsFunctions.initializeGroup(
          groupName: item.groupName, departmentId: departmentId);
      String images = item.imagePath;
      String desc = item.description;
      String ar = item.arName;
      String en = item.enName;
      double min = item.minQty;
      double max = item.maxQty;
      int type = item.productType;
      String printName = reversArString(ar);

      await data.insertData(
          "INSERT INTO products (Print_Name,image_dir,description,ar_name,en_name,department,`group`,min_amount,max_amount,product_type,unit_one_id,unit_two_id,unit_three_id) VALUES ('$printName','$images','$desc','$ar','$en',$departmentId,$idGroup,$min,$max,$type,$id_1,$id_2,$id_3)");
    } catch (e) {
      throw CustomException(e.toString());
    }
  }

  static Future<bool> updateProduct(InfoProduct item) async {
    try {
      await _checkUniqueFields(item);
      List<Map> response = await getProductList(
          searchText: "", searchType: "", secondCondition: " id=${item.id}");
      PosData data = PosData();
      double soldQTYOne = response[0]['sold_quantity_one_1'] +
          response[0]['sold_quantity_one_2'] +
          response[0]['sold_quantity_one_3'];
      double soldQTYTwo = response[0]['sold_quantity_two_1'] +
          response[0]['sold_quantity_two_2'] +
          response[0]['sold_quantity_two_3'];
      double totalSellsPriceOne = response[0]['total_sells_price_one_1'] +
          response[0]['total_sells_price_one_2'] +
          response[0]['total_sells_price_one_3'];
      double totalSellsPriceTwo = response[0]['total_sells_price_two_1'] +
          response[0]['total_sells_price_two_2'] +
          response[0]['total_sells_price_two_3'];
      await ProductUnitFunctions.updateUnit(
          item: item.unit1, id: response[0]['id_1']);
      int id_1 = response[0]['id_1'];
      int id_2 = 0;
      if (response[0]['id_2'] == 0) {
        id_2 = await ProductUnitFunctions.initializeUnitExpanded(item.unit2);
      } else {
        await ProductUnitFunctions.updateUnitExpanded(
            item: item.unit2, id: response[0]['id_2']);
        id_2 = response[0]['id_2'];
      }
      int id_3 = 0;
      if (response[0]['id_3'] == 0) {
        id_3 = await ProductUnitFunctions.initializeUnitExpanded(item.unit3);
      } else {
        await ProductUnitFunctions.updateUnitExpanded(
            item: item.unit3, id: response[0]['id_3']);
        id_3 = response[0]['id_3'];
      }
      int idDepartment = await SectionsFunctions.transferQtySells(
          nameNew: item.departmentName,
          nameOld: response[0]["section_name"],
          qty1: soldQTYOne,
          sells1: totalSellsPriceOne,
          qty2: soldQTYTwo,
          sells2: totalSellsPriceTwo);
      int idGroup = await GroupsFunctions.transferQtySells(
          groupNameNew: item.groupName,
          departmentIdNew: idDepartment,
          departmentIdOld: response[0]["id_department"],
          groupNameOld: response[0]["group_name"],
          qty1: soldQTYOne,
          sells1: totalSellsPriceOne,
          qty2: soldQTYTwo,
          sells2: totalSellsPriceTwo);
      int id = item.id;
      String images = item.imagePath;
      String desc = item.description;
      String ar = item.arName;
      String en = item.enName;
      double minA = item.minQty;
      double maxA = item.maxQty;
      int type = item.productType;
      String printName = reversArString(ar);

      await data.changeData(
          "UPDATE products SET image_dir='$images',product_type=$type,max_amount=$maxA,min_amount=$minA,`group`=$idGroup,department=$idDepartment,en_name='$en',ar_name='$ar',description='$desc',unit_one_id=$id_1,unit_two_id=$id_2,unit_three_id=$id_3,Print_Name='$printName'   WHERE id=$id ");
      return true;
    } catch (e) {
      throw CustomException(e.toString());
    }
  }

  static Future<bool> deleteProduct(int id) async {
    PosData data = PosData();

    List<Map> response = await getProductList(
        searchText: "", searchType: "", secondCondition: "id=$id");
    if (response[0]['current_quantity_3'] != 0 ||
        response[0]['current_quantity_2'] != 0 ||
        response[0]['current_quantity_1'] != 0) {
      throw CustomException(ErrorsCodes.notEmptyQtyProduct);
    } else if (response[0]['sold_quantity_one_3'] != 0 ||
        response[0]['sold_quantity_two_3'] != 0 ||
        response[0]['sold_quantity_one_2'] != 0 ||
        response[0]['sold_quantity_two_2'] != 0 ||
        response[0]['sold_quantity_one_1'] != 0 ||
        response[0]['sold_quantity_two_1'] != 0) {
      throw CustomException(
          ErrorsCodes.notEmptySellsProduct);
    } else {
      await data
          .deleteData("DELETE FROM products WHERE id=${response[0]['id']}");
      ProductUnitFunctions.deleteUnit(
          id: response[0]['unit_one_id'], suffix: "_1");
      ProductUnitFunctions.deleteUnit(
          id: response[0]['unit_two_id'], suffix: "_2");
      ProductUnitFunctions.deleteUnit(
          id: response[0]['unit_three_id'], suffix: "_3");
      return true;
    }
  }

  static Future<void> increaseProductQty(
      {required String id,
      required String qty1,
      required String qty2,
      required String qty3}) async {
    PosData data = PosData();
    int _id = int.parse(id);
    List<Map> response = await getProductList(
        searchText: "", searchType: "", secondCondition: " id=$_id");
    double newQty1 = response[0]["current_quantity_1"] +
        double.parse(qty1 == "" ? "0" : qty1);
    double newQty2 = response[0]["current_quantity_2"] +
        double.parse(qty2 == "" ? "0" : qty2);
    double newQty3 = response[0]["current_quantity_3"] +
        double.parse(qty3 == "" ? "0" : qty3);
    double newInQty1 =
        response[0]["In_quantity_1"] + double.parse(qty1 == "" ? "0" : qty1);
    double newInQty2 =
        response[0]["In_quantity_2"] + double.parse(qty2 == "" ? "0" : qty2);
    double newInQty3 =
        response[0]["In_quantity_3"] + double.parse(qty3 == "" ? "0" : qty3);
    await data.changeData(
        "UPDATE unit_1 SET current_quantity_1=$newQty1 , In_quantity_1=$newInQty1 WHERE id_1=${response[0]['unit_one_id']}");
    if (response[0]['unit_two_id'] != 0) {
      await data.changeData(
          "UPDATE unit_2 SET current_quantity_2=$newQty2 , In_quantity_2=$newInQty2 WHERE id_2=${response[0]['unit_two_id']}");
    }
    if (response[0]['unit_three_id'] != 0) {
      await data.changeData(
          "UPDATE unit_3 SET current_quantity_3=$newQty3 , In_quantity_3=$newInQty3 WHERE id_3=${response[0]['unit_three_id']}");
    }
  }

  static Future<void> decreaseProductQty(
      {required String id,
      required String qty1,
      required String qty2,
      required String qty3}) async {
    PosData data = PosData();
    int _id = int.parse(id);
    List<Map> response = await getProductList(
        searchText: "", searchType: "", secondCondition: " id=$_id");
    double newQty1 = response[0]["current_quantity_1"] -
        double.parse(qty1 == "" ? "0" : qty1);
    double newQty2 = response[0]["current_quantity_2"] -
        double.parse(qty2 == "" ? "0" : qty2);
    double newQty3 = response[0]["current_quantity_3"] -
        double.parse(qty3 == "" ? "0" : qty3);
    double newOutQty1 =
        response[0]["Out_quantity_1"] + double.parse(qty1 == "" ? "0" : qty1);
    double newOutQty2 =
        response[0]["Out_quantity_2"] + double.parse(qty2 == "" ? "0" : qty2);
    double newOutQty3 =
        response[0]["Out_quantity_3"] + double.parse(qty3 == "" ? "0" : qty3);
    await data.changeData(
        "UPDATE unit_1 SET current_quantity_1=$newQty1 , Out_quantity_1=$newOutQty1  WHERE id_1=${response[0]['unit_one_id']}");
    if (response[0]['unit_two_id'] != 0) {
      await data.changeData(
          "UPDATE unit_2 SET current_quantity_2=$newQty2  , Out_quantity_2=$newOutQty2 WHERE id_2=${response[0]['unit_two_id']}");
    }
    if (response[0]['unit_three_id'] != 0) {
      await data.changeData(
          "UPDATE unit_3 SET current_quantity_3=$newQty3 , Out_quantity_3=$newOutQty3 WHERE id_3=${response[0]['unit_three_id']}");
    }
  }

  static Future<bool> _nameIsUnique(
      {required String name,
      required int id,
      required String searchType}) async {
    if (name == "") return true;
    List<Map> response = await ProductFunctions.getProductList(
        searchText: name,
        searchType: searchType,
        secondCondition: " (id>$id OR id<$id )");
    return response.isEmpty;
  }

  static Future<void> _checkUniqueFields(InfoProduct item) async {
    bool isArNameUnique = await _nameIsUnique(
        name: item.arName, id: item.id, searchType: SearchTypes.arName);
    if (!isArNameUnique) {
      throw CustomException(ErrorsCodes.arNameIsNotUnique);
    }
    bool isEnNameUnique = await _nameIsUnique(
        name: item.enName, id: item.id, searchType: SearchTypes.enName);
    if (!isEnNameUnique) {
      throw CustomException(ErrorsCodes.enNameIsNotUnique);
    }
    bool isCode1Unique = await ProductUnitFunctions.barcodeIsUnique(
        barcode: item.unit1.barcode, id: item.id);
    if (!isCode1Unique) {
      throw CustomException(ErrorsCodes.code1IsNotUnique);
    }
    bool isCode2Unique = await ProductUnitFunctions.barcodeIsUnique(
        barcode: item.unit2.barcode, id: item.id);
    if (!isCode2Unique) {
      throw CustomException(ErrorsCodes.code2IsNotUnique);
    }
    bool isCode3Unique = await ProductUnitFunctions.barcodeIsUnique(
        barcode: item.unit3.barcode, id: item.id);
    if (!isCode3Unique) {
      throw CustomException(ErrorsCodes.code3IsNotUnique);
    }
    return;
  }
}
