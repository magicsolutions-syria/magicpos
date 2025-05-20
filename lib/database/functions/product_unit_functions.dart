import 'package:magicposbeta/database/initialize_database.dart';
import 'package:magicposbeta/modules/product_unit.dart';
import 'package:magicposbeta/modules/product_unit_expanded.dart';

import '../../components/reverse_string.dart';
import 'product_functions.dart';

class ProductUnitFunctions {
  static Future<List<String>> _namesData(String suffix) async {
    PosData data = PosData();
   List<Map> response= await data
        .readData("SELECT names FROM units_names$suffix ORDER BY names ");
    return   List.generate(response.length, (index) => response[index]["names"]);
  }

  static Future<void> addUnitName(
      {required String name, required String suffix}) async {
    PosData data = PosData();
    List<Map> res = await data
        .readData("SELECT * FROM units_names$suffix WHERE names='$name'");
    if (res.isEmpty) {
      await data
          .insertData("INSERT INTO units_names$suffix (names)VALUES('$name')");
    }
  }

  static Future<int> addUnit(ProductUnit item) async {
    PosData data = PosData();
    double cost = item.costPrice;
    double group = item.groupPrice;
    double piece = item.piecePrice;
    String code = item.barcode;
    String name = item.name;
    String suffix = item.suffix;
    String printName = reversArString(name);

    return await data.insertData(
        "INSERT INTO unit$suffix (Print_Name$suffix,name$suffix,cost_price$suffix,group_price$suffix,piece_price$suffix,code$suffix)VALUES('$printName','$name',$cost,$group,$piece,'$code')");
  }

  static Future<int> initializeUnit(ProductUnit item) async {
    if (item.name != "") {
      await addUnitName(name: item.name, suffix: item.suffix);
    }
    return addUnit(item);
  }

  static Future<int> updateUnit(
      {required ProductUnit item, required int id}) async {
    PosData data = PosData();
    double cost = item.costPrice;
    double group = item.groupPrice;
    double piece = item.piecePrice;
    String code = item.barcode;
    String name = item.name;
    String suffix = item.suffix;
    String printName = reversArString(name);
    return await data.changeData(
        "UPDATE  unit$suffix SET name$suffix ='$name' ,Print_Name$suffix='$printName' , cost_price$suffix =$cost , group_price$suffix =$group , piece_price$suffix = $piece , code$suffix = '$code' WHERE id$suffix=$id ");
  }

  static Future<int> addUnitExpanded(ProductUnitExpanded item) async {
    PosData data = PosData();
    double cost = item.costPrice;
    double group = item.groupPrice;
    double piece = item.piecePrice;
    double pieceQTY = item.piecesQTY;
    String code = item.barcode;
    String name = item.name;
    String suffix = item.suffix;
    String printName = reversArString(name);

    return await data.insertData(
        "INSERT INTO unit$suffix (Print_Name$suffix,name$suffix,cost_price$suffix,group_price$suffix,piece_price$suffix,code$suffix,pieces_quantity$suffix)VALUES('$printName','$name',$cost,$group,$piece,'$code',$pieceQTY)");
  }

  static Future<int> initializeUnitExpanded(ProductUnitExpanded item) {
    if (item.barcode != "") {
      addUnitName(name: item.name, suffix: item.suffix);
      return addUnitExpanded(item);
    }
    return Future(() => 0);
  }

  static Future<void> deleteUnit(
      {required int id, required String suffix}) async {
    PosData data = PosData();
    if (id == 0) return;
    await data.deleteData("DELETE FROM unit$suffix WHERE id$suffix=$id");
  }

  static Future<int> updateUnitExpanded(
      {required ProductUnitExpanded item, required int id}) async {
    PosData data = PosData();
    String suffix = item.suffix;

    if (item.barcode == "") {
      deleteUnit(id: id, suffix: suffix);
      return Future(() => 0);
    }

    double cost = item.costPrice;
    double group = item.groupPrice;
    double piece = item.piecePrice;
    String code = item.barcode;
    String name = item.name;
    double pieceQTY = item.piecesQTY;
    await addUnitName(name: name, suffix: suffix);
    String printName = reversArString(name);

    return await data.changeData(
        "UPDATE unit$suffix SET name$suffix ='$name' ,Print_Name$suffix='$printName' , cost_price$suffix =$cost , group_price$suffix =$group , piece_price$suffix = $piece , code$suffix = '$code' ,pieces_quantity$suffix = $pieceQTY WHERE id$suffix=$id ");
  }
  static Future<bool> barcodeIsUnique({
    required String barcode,
    required int id,
  }) async {
    if (barcode == "") return true;
    List<Map> response = await ProductFunctions.getProductList(
        searchText: "",
        searchType: "",
        secondCondition:
        " (code_1='$barcode' OR code_2='$barcode' OR code_3='$barcode') AND (id>$id OR id<$id )  ");
    return response.isEmpty;
  }

  static Future<List<String>>namesData1() async {
    return await _namesData("_1");
  }
  static Future<List<String>>namesData2() async {
    return await _namesData("_2");
  }
  static Future<List<String>>namesData3() async {
    return await _namesData("_3");
  }

}
