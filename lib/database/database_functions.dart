import "package:image_picker/image_picker.dart";
import "package:magicposbeta/components/general_report.dart";
import "package:magicposbeta/modules/product_lisit.dart";
import "package:magicposbeta/modules/product.dart";
import "package:magicposbeta/providers/products_table_provider.dart";
import "../components/my_dialog.dart";
import "../components/reverse_string.dart";
import "../screens_data/constants.dart";
import "./initialize_database.dart";
import "package:flutter/material.dart";

Future<String> initialId(String tableName, {String suffix = ""}) async {
  String id;
  PosData data = PosData();
  List<Map> response = await data.readData(
      "SELECT id$suffix FROM $tableName ORDER BY id$suffix DESC LIMIT 1");
  if (response.isEmpty) {
    id = "1";
  } else {
    id = "${response[0]['id$suffix'] + 1}";
  }

  return id;
}

Future<List<Map>> getDepts() async {
  PosData db = PosData();

  List<Map> depts = await db.readData("SELECT * FROM dept");
  return depts;
}

Future<void> updateDepartmentsAndGroups(Map mpGroups, Map mpDepts) async {
  PosData db = PosData();

  mpGroups.forEach((key, value) async {
    List<Map> groups =
        await db.readData("SELECT * FROM `groups`  WHERE id_group=$key");
    Map currentGroup = groups[0];

    double soldQtyOne = currentGroup["sold_quantity_one"] + value[0];
    double soldQtyTwo = currentGroup["sold_quantity_two"] + value[0];
    double salesOne = currentGroup["total_sells_price_one"] + value[1];
    double salesTwo = currentGroup["total_sells_price_two"] + value[1];

    await db.changeData(
        "UPDATE 'groups' SET 'sold_quantity_one'=$soldQtyOne, 'sold_quantity_two'=$soldQtyTwo, 'total_sells_price_one'=$salesOne, 'total_sells_price_two'=$salesTwo WHERE id_group=${currentGroup["id_group"]}");
  });

  mpDepts.forEach((key, value) async {
    List<Map> departments = await db
        .readData("SELECT * FROM `departments`  WHERE id_department=$key");
    Map currentDepartment = departments[0];

    double soldQtyOne = currentDepartment["sold_quantity_one"] + value[0];
    double soldQtyTwo = currentDepartment["sold_quantity_two"] + value[0];
    double salesOne = currentDepartment["total_sells_price_one"] + value[1];
    double salesTwo = currentDepartment["total_sells_price_two"] + value[1];
    double cashSalesOne =
        currentDepartment["cash_total_sells_price_one"] + value[1];
    double cashSalesTwo =
        currentDepartment["cash_total_sells_price_two"] + value[1];

    await db.changeData(
        "UPDATE 'departments' SET 'sold_quantity_one'=$soldQtyOne, 'sold_quantity_two'=$soldQtyTwo, 'total_sells_price_one'=$salesOne, 'total_sells_price_two'=$salesTwo, 'cash_total_sells_price_one'=$cashSalesOne, 'cash_total_sells_price_two'=$cashSalesTwo WHERE id_department=${currentDepartment["id_department"]}");
  });
}

Future<void> updateSingleUnit(List value) async {
  int unitNum = value[1];
  PosData db = PosData();
  List<Map> unitOneProducts = await db
      .readData("SELECT * FROM 'unit_$unitNum' WHERE id_$unitNum=${value[2]}");
  double currentQty =
      unitOneProducts[0]["current_quantity_$unitNum"] - value[0];
  double soldQtyOne =
      unitOneProducts[0]["sold_quantity_one_$unitNum"] + value[0];
  double soldQtyTwo =
      unitOneProducts[0]["sold_quantity_two_$unitNum"] + value[0];
  double salesOne =
      unitOneProducts[0]["total_sells_price_one_$unitNum"] + value[3];
  double salesTwo =
      unitOneProducts[0]["total_sells_price_two_$unitNum"] + value[3];

  await db.changeData(
      "UPDATE 'unit_$unitNum' SET 'current_quantity_$unitNum'=$currentQty, 'sold_quantity_one_$unitNum'=$soldQtyOne, 'sold_quantity_two_$unitNum'=$soldQtyTwo, 'total_sells_price_one_$unitNum'=$salesOne, 'total_sells_price_two_$unitNum'=$salesTwo WHERE id_$unitNum=${value[2]}");
}

Future<Map<int,List<Product>>> updateProductUnit(ProductList productList) async {
  PosData db = PosData();
  List<Product> ls = productList.products;

  print("*****************");
  print(ls);
  print("*****************");

  Map<int, List> mpGroup = {};
  Map<int, List> mpDepartment = {};

  // 0 => qty
  // 1 => price

  Map<int,List<Product>> mpPrinters={-1:[]};



  Map<int, List> mpUnit1 = {};
  Map<int, List> mpUnit2 = {};
  Map<int, List> mpUnit3 = {};

  List<Product> depts = [];


  for (int i = 0; i < ls.length; i++) {
    Product element = ls[i];

    if (element.isNotProduct) {
      continue;
    }
    if (mpDepartment.containsKey(element.deptId)) {
      (mpDepartment[element.deptId] as List)[0] += element.quantity;
      (mpDepartment[element.deptId] as List)[1] +=
          element.calcTotalPrice().toInt();
    } else {
      mpDepartment[element.deptId] = [
        element.quantity,
        element.calcTotalPrice().toInt()
      ];
    }
    if (mpPrinters.containsKey(element.printerId)) {
      if(mpPrinters[element.printerId]!.where((element1) => element1.id==element.id).isEmpty)
        {
          mpPrinters[element.printerId]!.add(element);
        }
      else{
        mpPrinters[element.printerId]!.where((element1) => element1.id==element.id).forEach((element1) {element1.changeQty(element1.quantity + element.quantity); });
      }
    } else {
      mpPrinters[element.printerId] = [element];
    }

    if (element.barcode == "-2") {
      depts.add(element);
      continue;
    }
    if (mpGroup.containsKey(element.groupId)) {
      (mpGroup[element.groupId] as List)[0] += element.quantity;
      (mpGroup[element.groupId] as List)[1] += element.calcTotalPrice().toInt();
    } else {
      mpGroup[element.groupId] = [
        element.quantity,
        element.calcTotalPrice().toInt()
      ];
    }

    switch (element.unitNum) {
      case 1:
        if (mpUnit1.containsKey(element.id)) {
          (mpUnit1[element.id] as List)[0] += element.quantity;
          (mpUnit1[element.id] as List)[1] += element.calcTotalPrice().toInt();
        } else {
          mpUnit1[element.id] = [
            element.quantity,
            element.calcTotalPrice().toInt()
          ];
        }
        break;
      case 2:
        if (mpUnit2.containsKey(element.id)) {
          (mpUnit2[element.id] as List)[0] += element.quantity;
          (mpUnit2[element.id] as List)[1] += element.calcTotalPrice().toInt();
        } else {
          mpUnit2[element.id] = [
            element.quantity,
            element.calcTotalPrice().toInt()
          ];
        }
        break;
      case 3:
        if (mpUnit3.containsKey(element.id)) {
          (mpUnit3[element.id] as List)[0] += element.quantity;
          (mpUnit3[element.id] as List)[1] += element.calcTotalPrice().toInt();
        } else {
          mpUnit3[element.id] = [
            element.quantity,
            element.calcTotalPrice().toInt()
          ];
        }
        break;
    }
  }


  for (int i = 0; i < depts.length; i++) {
    updateDept(depts[i]);
  }

  mpUnit1.forEach((key, value) {
    updateSingleUnit([
      value[0],
      1,
      key,
      value[1],
    ]);
  });

  mpUnit2.forEach((key, value) {
    updateSingleUnit([
      value[0],
      1,
      key,
      value[1],
    ]);
  });

  mpUnit3.forEach((key, value) {
    updateSingleUnit([
      value[0],
      1,
      key,
      value[1],
    ]);
  });

  await updateDepartmentsAndGroups(mpGroup, mpDepartment);

  return mpPrinters;
}

Future<void> updateDept(Product p) async {
  PosData db = PosData();

  List<Map> response =
      await db.readData("SELECT * FROM 'dept' WHERE name='${p.productDesc}'");

  if (response.isEmpty) {
    return;
  }

  int newClicks1 = response[0]["clicks_1"] + 1;
  int newClicks2 = response[0]["clicks_2"] + 1;

  double newAmount1 = response[0]["amount_1"] + p.calcTotalPrice();
  double newAmount2 = response[0]["amount_2"] + p.calcTotalPrice();

  double newCashAmount1 = response[0]["cash_amount_1"] + p.calcTotalPrice();
  double newCashAmount2 = response[0]["cash_amount_2"] + p.calcTotalPrice();

  await db.changeData(
      "UPDATE 'dept' SET 'clicks_1'=$newClicks1, 'clicks_2'=$newClicks2, 'amount_1'=$newAmount1, 'amount_2'=$newAmount2, 'cash_amount_1'=$newCashAmount1, 'cash_amount_2'=$newCashAmount2 WHERE name='${p.productDesc}'");
}

Future<void> updateBonusDiscount(ProductList productList) async {
  updateFunctionsKeysValue("-", productList.discount,
      isNeg: productList.discount == 0);
  updateFunctionsKeysValue("+", productList.bonus,
      isNeg: productList.bonus == 0);
  updateFunctionsKeysValue(
      "-%", productList.calcDiscount() - productList.discount,
      isNeg: productList.discountPercentage == 0);
  updateFunctionsKeysValue("+%", productList.calcBonus() - productList.bonus,
      isNeg: productList.bonusPercentage == 0);
}

Future<void> updateAllFunctionsKeysValue(double ca, double visa1, double visa2,
    double chk, double ch, ProductList productList) async {
  await updateFunctionsKeysValue("CASH", ca, isNeg: ca <= 0);
  await updateFunctionsKeysValue("VISA1", visa1, isNeg: visa1 == 0);
  await updateFunctionsKeysValue("VISA2", visa2, isNeg: visa2 == 0);
  await updateFunctionsKeysValue("CHK", chk, isNeg: chk == 0);
  await updateFunctionsKeysValue("ch", ch, isNeg: ch == 0);
}

Future<void> updateFunctionsKeysValue(String keyName, double amount,
    {bool isNeg = false}) async {
  PosData db = PosData();

  String text = "";

  switch (keyName) {
    case "VISA1":
      text = "vi1";
      break;
    case "VISA2":
      text = "vi2";
      break;
    case "CHK":
      text = "chk";
      break;
    case "CASH":
      text = "ca";
      break;
    case "-":
      text = "minus";
      break;
    case "-%":
      text = "minus_per";
      break;
    case "+":
      text = "plus";
      break;
    case "+%":
      text = "plus_per";
      break;
    default:
      text = keyName;
      break;
  }

  List<Map> ls = await db
      .readData("SELECT * FROM 'functions_keys' WHERE key_name='$text'");

  int newClicks1 = ls[0]["clicks_1"];
  int newClicks2 = ls[0]["clicks_2"];
  if (!isNeg) {
    newClicks1++;

    newClicks2++;
  }

  double amount1 = ls[0]["amount_1"] + amount;
  double amount2 = ls[0]["amount_2"] + amount;
  double cashAmount1 = ls[0]["cash_amount_1"] + amount;
  double cashAmount2 = ls[0]["cash_amount_2"] + amount;

  await db.changeData(
      "UPDATE functions_keys SET clicks_1=$newClicks1, clicks_2=$newClicks2, amount_1=$amount1, amount_2=$amount2, cash_amount_1=$cashAmount1, cash_amount_2=$cashAmount2 WHERE key_name='$text'");
}

void enterFunction(String barString, Function func, BuildContext context,
    double qty, ProductsTableProvider productVal, {required String priceType}) async {
  bool isScale = false;
  PosData db = PosData();
  if (barString.length > 1 && barString.substring(0, 2) == productVal.scaleStart) {
    String newBarcode = barString.substring(2, int.parse(productVal.productNumberScale));
    qty = double.parse(barString.substring(int.parse(productVal.productNumberScale) + 2));
    barString = newBarcode;
    isScale = true;
  }
  List<Map> response01 =
      await db.readData("SELECT * FROM unit_1 WHERE code_1='$barString'");
  List<Map> response02 =
      await db.readData("SELECT * FROM unit_2 WHERE code_2='$barString'");
  List<Map> response03 =
      await db.readData("SELECT * FROM unit_3 WHERE code_3='$barString'");
  Map finalResult = {};

  List<Map> response04 = [];

  int index = 0;

  if (response01.isNotEmpty) {
    finalResult = response01.first;
    if (finalResult.isNotEmpty) {
      response04 = await db.readData(
          "SELECT * FROM products WHERE unit_one_id='${finalResult["id_1"]}'");

      index = 1;

    }
  } else if (response02.isNotEmpty) {
    finalResult = response02.first;
    if (finalResult.isNotEmpty) {
      response04 = await db.readData(
          "SELECT * FROM products WHERE unit_two_id='${finalResult["id_2"]}'");
      index = 2;
    }
  } else if (response03.isNotEmpty) {
    finalResult = response03.first;
    if (finalResult.isNotEmpty) {
      response04 = await db.readData(
          "SELECT * FROM products WHERE unit_three_id='${finalResult["id_3"]}'");
      index = 3;
    }
  }
  int printerId = -1;
  List<Map> res = await db.readData("SELECT printer_id FROM `groups` WHERE `id_group`=${response04[0]["group"]}");
  printerId = res[0]["printer_id"];
  if (finalResult.isNotEmpty && barString != "") {
    if (isScale && response04[0]["product_type"] != 1) {
      throw Exception("");
    } else if (!isScale && response04[0]["product_type"] == 1) {
      throw Exception("");
    }
    func(
      response04[0]["ar_name"],
      double.parse(qty.toStringAsFixed(2)),
      finalResult["${priceType}_price_$index"],
      barString,
      finalResult["id_$index"],
      index,
      response04[0]["group"],
      response04[0]["department"],
      response04[0]["Print_Name"],
      printerId
    );
  } else {
    if (context.mounted) {
      MyDialog.showAnimateWarningDialog(
        context: context,
        isWarning: true,
        onStart: () {
          productVal.openRcPdCh();
        },
        onEnd: () {
          productVal.closeRcPdCh();
        },
        title: "باركود خاطئ",
        hieght: 400,
        width: 500,
      );
    }
  }
}

Future<void> initialTablesData() async {
  PosData db = PosData();

  List<Map> response = await db.readData("SELECT * FROM 'dept'");

  if (response.isNotEmpty) {

    return;
  }

  for (int i = 0; i < keysNamesData.length; i++) {
    await db.insertData(
        "INSERT INTO 'functions_keys'('key_name') VALUES('${keysNamesData[i]}')");
  }
  for (int i = 0; i < reportsNamesData.length; i++) {
    await db.insertData(
        "INSERT INTO 'reports'('report_name') VALUES('${reportsNamesData[i]}')");
  }
  for (int i = 0; i < permissionsData.length; i++) {
    await db.insertData(
        "INSERT INTO 'permissions'('permission_name') VALUES('${permissionsData[i]}')");
  }
  for (int i = 0; i < jopTitleData.length; i++) {
    await db.insertData(
        "INSERT INTO 'jop_titles' ('jop_title_name') VALUES('${jopTitleData[i]}')");
  }

  for (int i = 1; i < 17; i++) {
    await db.insertData(
        "INSERT INTO 'dept'('name', 'Print_Name')VALUES('dept$i', 'dept$i')");
  }
  await db.insertData(
      "INSERT INTO unit_2 (id_2,name_2,cost_price_2,group_price_2,piece_price_2,code_2,pieces_quantity_2)VALUES(0,'',0,0,0,'',0)");
  await db.insertData(
      "INSERT INTO unit_3 (id_3,name_3,cost_price_3,group_price_3,piece_price_3,code_3,pieces_quantity_3)VALUES(0,'',0,0,0,'',0)");

  await db.insertData(
      "INSERT INTO departments (id_department,section_name,Print_Name_department)VALUES(0,'متفرقات','${reversArString('متفرقات')}')");
}

Future<String> pickImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? img = await picker.pickImage(
    source: ImageSource.gallery, // alternatively, use ImageSource.gallery
  );
  if (img == null) return "";
  return img.path;
}




