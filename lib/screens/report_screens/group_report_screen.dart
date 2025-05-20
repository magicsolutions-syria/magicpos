import 'package:flutter/material.dart';
import 'package:magicposbeta/theme/custom_colors.dart';

import '../../components/check_boxes.dart';
import '../../components/custom_drop_down_menu.dart';
import '../../components/general_report.dart';
import '../../modules/pair.dart';

class GroupReport extends ReportsScreen {
  static const String route = "/Group-report-screen";

  const GroupReport({super.key});
  @override
  ReportsScreenState report() {
    return _GroupReportState();
  }
}

class _GroupReportState extends ReportsScreenState {
  @override
  void initState() {
    departmentController = TextEditingController();
    super.initState();
  }
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

  Future<void> getNum() async {
    data =
        await db.readData("SELECT * FROM reports WHERE report_name = 'groups'");
    xRepNum = data[0]["X"];
    x2RepNum = data[0]["X2"];
    zRepNum = data[0]["Z"];
    z2RepNum = data[0]["Z2"];
  }

  @override
  Future<void> getData() async {
    super.getData();
    departmentsNames = ["كل الأقسام"];
    data = await db.readData("SELECT section_name FROM departments");
    for(Map d in data){
      departmentsNames.add(d["section_name"]);
    }
    String condition = "";
    if((departmentController.text!=""&&departmentController.text!="كل الأقسام")){
      condition = "WHERE section_name='${departmentController.text}'";
    }

    await getNum();
    data = await db.readData("SELECT `groups`.*,departments.section_name FROM `groups` JOIN departments ON departments.id_department=section_number ${condition==""?"":condition}");


  }

  @override
  bool hasOptions() {
    return true;
  }




  @override
  Text title() {
    return Text(
      "تقرير المجموعات",
      style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).secondaryTextColor),
    );
  }
  @override
  Widget checkBoxes() {
    return const CheckBoxes();
  }

  @override
  Future<void> zero1() async {
    await db.changeData(
        "UPDATE 'groups' SET sold_quantity_one = 0,total_sells_price_one = 0.0");
  }

  @override
  Future<void> zero2() async {
    await db.changeData(
        "UPDATE 'groups' SET sold_quantity_two = 0 ,total_sells_price_two = 0.0 ");
  }

  @override
  Future<void> x2RepoNum() async {
    x2RepNum++;
    await db.changeData(
        "UPDATE 'reports' SET X2 = $x2RepNum WHERE report_name = 'groups'");
  }

  @override
  Future<void> xRepoNum() async {
    xRepNum++;
    await db.changeData(
        "UPDATE 'reports' SET X = $xRepNum WHERE report_name = 'groups'");
  }

  @override
  Future<void> z2RepoNum() async {
    z2RepNum++;
    await db.changeData(
        "UPDATE 'reports' SET Z2 = $z2RepNum WHERE report_name = 'groups'");
  }

  @override
  Future<void> zRepoNum() async {
    zRepNum++;
    await db.changeData(
        "UPDATE 'reports' SET Z = $zRepNum WHERE report_name = 'groups'");
  }


  @override
  Widget drop(Function notify) {
    return CustomDropDownMenu(title: " : اختيار القسم", data: departmentsNames, controller: departmentController, width: 150,fontSize: 15, notify: notify,);
  }
  @override
  List<Pair<String, Pair<int,int>>> getColumns() {
    Pair<String,Pair<int,int>> p1 = Pair("Name", Pair(22,2));
    Pair<String,Pair<int,int>> p2 = Pair("QTY", Pair(9,0));
    Pair<String,Pair<int,int>> p3 = Pair("Amount", Pair(17,0));
    Pair<String,Pair<int,int>> p4 = Pair("Print_Name_group", Pair(22,2));
    Pair<String,Pair<int,int>> p5 = Pair("sold_quantity_one",Pair(9,0) );
    Pair<String,Pair<int,int>> p6 = Pair("total_sells_price_one", Pair(17,0));
    Pair<String,Pair<int,int>> p7 = Pair("sold_quantity_two",Pair(9,0) );
    Pair<String,Pair<int,int>> p8 = Pair("total_sells_price_two", Pair(17,0));
    Pair<String,Pair<int,int>> p9 = Pair("sold_quantity_one",Pair(9,0) );
    Pair<String,Pair<int,int>> p10 = Pair("total_sells_price_one", Pair(17,0));
    Pair<String,Pair<int,int>> p11 = Pair("sold_quantity_two",Pair(9,0) );
    Pair<String,Pair<int,int>> p12 = Pair("total_sells_price_two", Pair(17,0));
    Pair<String,Pair<int,int>> p13 = Pair("group_name", Pair(17,0));
    Pair<String,Pair<int,int>> p14 = Pair(" Groups Report", Pair(0,0));
    return [p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14];
  }
}
