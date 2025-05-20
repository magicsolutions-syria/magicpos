import 'package:flutter/material.dart';
import 'package:magicposbeta/theme/custom_colors.dart';

import '../../components/check_boxes.dart';
import '../../components/choises_list.dart';
import '../../components/general_report.dart';
import '../../components/operator_button.dart';
import '../../database/initialize_database.dart';
import '../../modules/pair.dart';

class ProductReport extends ReportsScreen {
  static const String route = "/Product-report-screen";

  const ProductReport({super.key});
  @override
  ReportsScreenState report() {
    return _ProductReportState();
  }
}

class _ProductReportState extends ReportsScreenState {

  @override
  bool button1() {
    return false;
  }

  @override
  bool button2() {
    return false;
  }

  @override
  bool button3() {
    return false;
  }

  @override
  bool button4() {
    return false;
  }

  List departments = [];
  List groups = [];
  @override
  Widget drop(Function notify) {
    return OperatorButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return ChoicesList(
                func: (List l1, List l2) {
                  departments = l2;
                  groups = l1;
                },
                controller: departmentController,
                notify: notify,
              );
            });
      },
      text: "تحديد الخيارات",
      color: Theme.of(context).scaffoldBackgroundColor,
      enable: true,
      fontSize: 18,
    );
  }

  Future<void> getNum() async {
    data = await db
        .readData("SELECT * FROM reports WHERE report_name = 'products'");
    xRepNum = data[0]["X"];
    x2RepNum = data[0]["X2"];
    zRepNum = data[0]["Z"];
    z2RepNum = data[0]["Z2"];
  }

  String prefix = "1";
  String unitName = "unit_one";
  @override
  Future<void> getData() async {
super.getData();
    departmentsNames = ["الوحدة الأولى", "الوحدة الثانية", "الوحدة الثالثة"];

    switch (departmentController.text) {
      case "الوحدة الثانية":
        prefix = "2";
        unitName = "unit_two";
        break;
      case "الوحدة الثالثة":
        prefix = "3";
        unitName = "unit_three";
        break;
      default:
        prefix = "1";
        unitName = "unit_one";
        break;
    }
    await getNum();

    String condition = getCondition();

    // print(condition);
    String sql = condition == ""
        ? """
    SELECT * FROM 'products' 
    JOIN unit_$prefix ON unit_$prefix.id_$prefix = products.${unitName}_id WHERE id_$prefix>0 ORDER BY ar_name
    """
        : """
    SELECT * FROM 'products' 
    JOIN unit_$prefix ON unit_$prefix.id_$prefix = products.${unitName}_id WHERE id_$prefix>0 AND ($condition) ORDER BY ar_name
    """;
    data = await db.readData(sql);

  }

  String getCondition() {
    String condition = "";
    if ((departments.isEmpty && groups.isEmpty)) {
      return '';
    }
    if (departments.isNotEmpty?(departments[0] == -1 && departments.length == 1):(groups[0] == -1 && groups.length == 1)) {

      return "";
    }
    for (int i in departments) {
      condition += condition == '' ? "department=$i" : " OR department=$i";
    }
    for (int i in groups) {
      condition += condition == '' ? "`group`=$i" : " OR `group`=$i";
    }
    return condition;
  }

  @override
  bool hasOptions() {
    return true;
  }


  @override
  Widget checkBoxes() {
    return const CheckBoxes();
  }

  @override
  Future<void> zData() async {
    zReportData = [];
    PosData db = PosData();
    data = await db.readData("SELECT * FROM products JOIN unit_1 ON unit_one_id=id_1 JOIN unit_2 ON unit_two_id=id_2 JOIN unit_3 ON unit_three_id=id_3 ORDER BY ar_name");
    for(Map m in data){
      Map newM = {"Print_Name":m["Print_Name"],"sold_quantity_one_1":(m["pieces_quantity_3"] * m['sold_quantity_one_3'])+(m['sold_quantity_one_2'] * m['pieces_quantity_2'])+m['sold_quantity_one_1'],"sold_quantity_two_1":(m["pieces_quantity_3"] * m['sold_quantity_two_3'])+(m['sold_quantity_two_2'] * m['pieces_quantity_2'])+m['sold_quantity_two_1'],"total_sells_price_one_1":m["total_sells_price_one_1"]+m["total_sells_price_one_2"]+m["total_sells_price_one_3"],"total_sells_price_two_1":m["total_sells_price_two_1"]+m["total_sells_price_two_2"]+m["total_sells_price_two_3"]};
      zReportData.add(newM);
    }
  }



  @override
  Text title() {
    return Text(
      "تقرير المواد",
      style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).secondaryTextColor),
    );
  }

  @override
  Future<void> zero1() async {
    await db.changeData(
        "UPDATE 'unit_1' SET sold_quantity_one_1 = 0,total_sells_price_one_1 = 0.0");
    await db.changeData(
        "UPDATE 'unit_2' SET sold_quantity_one_2 = 0,total_sells_price_one_2 = 0.0");
    await db.changeData(
        "UPDATE 'unit_3' SET sold_quantity_one_3 = 0,total_sells_price_one_3 = 0.0");
  }

  @override
  Future<void> zero2() async {
    await db.changeData(
        "UPDATE 'unit_1' SET sold_quantity_two_1 = 0,total_sells_price_two_1 = 0.0");
    await db.changeData(
        "UPDATE 'unit_2' SET sold_quantity_two_2 = 0,total_sells_price_two_2 = 0.0");
    await db.changeData(
        "UPDATE 'unit_3' SET sold_quantity_two_3 = 0,total_sells_price_two_3 = 0.0");
  }

  @override
  Future<void> x2RepoNum() async {
    x2RepNum++;
    await db.changeData(
        "UPDATE 'reports' SET X2 = $x2RepNum WHERE report_name = 'products'");
  }

  @override
  Future<void> xRepoNum() async {
    xRepNum++;
    await db.changeData(
        "UPDATE 'reports' SET X = $xRepNum WHERE report_name = 'products'");
  }

  @override
  Future<void> z2RepoNum() async {
    z2RepNum++;
    await db.changeData(
        "UPDATE 'reports' SET Z2 = $z2RepNum WHERE report_name = 'products'");
  }

  @override
  Future<void> zRepoNum() async {
    zRepNum++;
    await db.changeData(
        "UPDATE 'reports' SET Z = $zRepNum WHERE report_name = 'products'");
  }



  @override
  List<Pair<String,Pair<int,int>>> getColumns() {
    Pair<String,Pair<int,int>> p1 = Pair("Name", Pair(22,2));
    Pair<String,Pair<int,int>> p2 = Pair("QTY", Pair(9,0));
    Pair<String,Pair<int,int>> p3 = Pair("Amount", Pair(17,0));
    Pair<String,Pair<int,int>> p4 = Pair("Print_Name", Pair(22,2));
    Pair<String,Pair<int,int>> p5 = Pair("sold_quantity_one_$prefix",Pair(9,0) );
    Pair<String,Pair<int,int>> p6 = Pair("total_sells_price_one_$prefix", Pair(17,0));
    Pair<String,Pair<int,int>> p7 = Pair("sold_quantity_two_$prefix",Pair(9,0) );
    Pair<String,Pair<int,int>> p8 = Pair("total_sells_price_two_$prefix", Pair(17,0));
    Pair<String,Pair<int,int>> p9 = Pair("sold_quantity_one_1",Pair(9,0) );
    Pair<String,Pair<int,int>> p10 = Pair("total_sells_price_one_1", Pair(17,0));
    Pair<String,Pair<int,int>> p11 = Pair("sold_quantity_two_1",Pair(9,0) );
    Pair<String,Pair<int,int>> p12 = Pair("total_sells_price_two_1", Pair(17,0));
    Pair<String,Pair<int,int>> p13 = Pair("ar_name", Pair(22,2));
    Pair<String,Pair<int,int>> p14 = Pair(" Product Report", Pair(0,0));
    return [p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14];
  }
}
