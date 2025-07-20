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
  //table name
  static const String tableName = "products";

  //fields names
  static const String idF = "id";
  static const String arNameF = "ar_name";
  static const String enNameF = "en_name";
  static const String printNameF = "print_name";
  static const String departmentF = "department";
  static const String groupF = "group";
  static const String imagePathF = "image_dir";
  static const String descriptionF = "description";
  static const String minAmountF = "min_amount";
  static const String maxAmountF = "max_amount";
  static const String unit1F = "unit_one_id";
  static const String unit2F = "unit_two_id";
  static const String unit3F = "unit_three_id";
  static const String productTypeF = "product_type";
  static final PosData _data = PosData();

  static Future<String> initialProductId() async {
    return await initialId(tableName);
  }

  static Future<List<InfoProduct>> _getProduct(String condition,
      {String orderType = arNameF}) async {
    List<Map> response = await _data.readData(
        "SELECT * FROM $tableName JOIN departments ON id_department=`$departmentF` JOIN `groups` ON id_group=`$groupF` JOIN unit_1 ON $unit1F=id_1 JOIN unit_2 ON $unit2F=id_2 JOIN unit_3 ON $unit3F=id_3 $condition ORDER BY $orderType");
    List<InfoProduct> products = [];
    for (var product in response) {
      products.add(InfoProduct.instanceFromMap(product));
    }
    return products;
  }

  static Future<InfoProduct> getProductById(int id) async {
    return (await _getProduct("WHERE $idF=id",orderType: idF)).first;
  }

  static Future<List<InfoProduct>> searchProductByArabicName(String arName,{int filterByUnit=1}) async {
    return await _getProduct("WHERE $arNameF LIKE '%$arName%' AND id_$filterByUnit>0", orderType: arNameF);
  }
  static Future<List<InfoProduct>> searchProductByEnglishName(String enName,{int filterByUnit=1}) async {
    return await _getProduct("WHERE $enNameF LIKE '%$enName%' AND id_$filterByUnit>0", orderType: enNameF);
  }
  static Future<List<InfoProduct>> searchProductByCode1(String code1,{int filterByUnit=1}) async {
    return await _getProduct("WHERE code_1 LIKE '%$code1%' AND id_$filterByUnit>0", orderType: "code_1");
  }
  static Future<List<InfoProduct>> searchProductByCode2(String code2,{int filterByUnit=1}) async {
    return await _getProduct("WHERE code_2 LIKE '%$code2%' AND id_$filterByUnit>0", orderType: "code_2");
  }
  static Future<List<InfoProduct>> searchProductByCode3(String code3,{int filterByUnit=1}) async {
    return await _getProduct("WHERE code_3 LIKE '%$code3%' AND id_$filterByUnit>0", orderType: "code_3");
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
          columnName = arNameF;
          break;
        }
      case (SearchTypes.enName):
        {
          columnName = enNameF;
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
          columnName = arNameF;
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
        "SELECT * FROM $tableName JOIN departments ON id_department=`$departmentF` JOIN `groups` ON id_group=`$groupF` JOIN unit_1 ON $unit1F=id_1 JOIN unit_2 ON $unit2F=id_2 JOIN unit_3 ON $unit3F=id_3 $condition ORDER BY $columnName");
  }

  static Future<void> addProduct(InfoProduct item) async {
    try {
      PosData data = PosData();
      await _checkUniqueFields(item);
      int id_1 = await ProductUnitFunctions.initializeUnit(item.unit1);
      int id_2 = await ProductUnitFunctions.initializeUnitExpanded(item.unit2);
      int id_3 = await ProductUnitFunctions.initializeUnitExpanded(item.unit3);
      int departmentId =
          await SectionsFunctions.initializeDepartment(item.department.name);
      int idGroup = await GroupsFunctions.initializeGroup(
          groupName: item.group.name, departmentId: departmentId);
      String images = item.imagePath;
      String desc = item.description;
      String ar = item.arName;
      String en = item.enName;
      double min = item.minQty;
      double max = item.maxQty;
      int type = item.productType;
      String printName = reversArString(ar);

      await data.insertData(
          "INSERT INTO $tableName ($printNameF,$imagePathF,$descriptionF,$arNameF,$enNameF,$departmentF,`$groupF`,$minAmountF,$maxAmountF,$productTypeF,$unit1F,$unit2F,$unit3F) VALUES ('$printName','$images','$desc','$ar','$en',$departmentId,$idGroup,$min,$max,$type,$id_1,$id_2,$id_3)");
    } catch (e) {
      throw CustomException(e.toString());
    }
  }

  static Future<void> updateProduct(InfoProduct item) async {
    try {
      await _checkUniqueFields(item);

      InfoProduct response = await getProductById(item.id);
      double soldQTYOne = response.totalSoldQty1();
      double soldQTYTwo = response.totalSoldQty2();
      double totalSellsPriceOne = response.totalSoldPrice1();
      double totalSellsPriceTwo = response.totalSoldPrice2();
      await ProductUnitFunctions.updateUnit(
          item: item.unit1, id: response.unit1.id);
      int id_1 = response.unit1.id;
      int id_2 = await ProductUnitFunctions.initializeUnitExpanded(item.unit2,
          responseId: response.unit2.id);
      int id_3 = await ProductUnitFunctions.initializeUnitExpanded(item.unit3,
          responseId: response.unit3.id);
      int idDepartment = await SectionsFunctions.transferQtySells(
          nameNew: item.department.name,
          nameOld: response.department.name,
          qty1: soldQTYOne,
          sells1: totalSellsPriceOne,
          qty2: soldQTYTwo,
          sells2: totalSellsPriceTwo);
      int idGroup = await GroupsFunctions.transferQtySells(
          groupNameNew: item.group.name,
          departmentIdNew: idDepartment,
          departmentIdOld: response.department.id,
          groupNameOld: response.group.name,
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

      await _data.changeData(
          "UPDATE $tableName SET $imagePathF='$images',$productTypeF=$type,$maxAmountF=$maxA,$minAmountF=$minA,`$groupF`=$idGroup,$departmentF=$idDepartment,$enNameF='$en',$arNameF='$ar',$descriptionF='$desc',$unit1F=$id_1,$unit2F=$id_2,$unit3F=$id_3,$printNameF='$printName'   WHERE $idF=$id ");
    } catch (e) {
      throw CustomException(e.toString());
    }
  }

  static Future<bool> deleteProduct(int id) async {
    PosData data = PosData();

    List<Map> response = await getProductList(
        searchText: "", searchType: "", secondCondition: "$idF=$id");
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
      throw CustomException(ErrorsCodes.notEmptySellsProduct);
    } else {
      await data
          .deleteData("DELETE FROM $tableName WHERE $idF=${response[0][idF]}");
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
        searchText: "", searchType: "", secondCondition: " $idF=$_id");
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
        searchText: "", searchType: "", secondCondition: " $idF=$_id");
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
        secondCondition: " ($idF>$id OR $idF<$id )");
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
