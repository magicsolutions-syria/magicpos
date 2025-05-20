import 'package:flutter/material.dart';
import 'package:magicposbeta/theme/custom_colors.dart';

import '../../components/general_report.dart';
import '../../modules/pair.dart';
import '../../screens_data/constants.dart';

class ClientsReport extends ReportsScreen {
  static const String route = "/clients-reports-screen";

  const ClientsReport({super.key});

  @override
  ReportsScreenState report() {
    return _ClientsReportState();
  }
}

class _ClientsReportState extends ReportsScreenState {


  Future<void> getNum() async {
    data = await db
        .readData("SELECT * FROM 'reports' WHERE report_name = 'clients'");
    xRepNum = data[0]["X"];
  }

  @override
  Future<void> getData() async {
super.getData();
    await getNum();
    data = await db.readData("SELECT * FROM 'clients' ORDER BY Name_Arabic");
  }




  @override
  bool button1() {
    return false;
  }

  @override
  bool button2() {
    return true;
  }

  @override
  bool button3() {
    return true;
  }

  @override
  bool button4() {
    return true;
  }

  @override
  Text title() {
    return Text(
      "تقرير الزبائن",
      style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).secondaryTextColor),
    );
  }


  @override
  bool hasOptions() {
    return false;
  }

  @override
  Future<void> zero1() async {}

  @override
  Future<void> zero2() async {}

  @override
  Future<void> x2RepoNum() async {
    xRepNum++;
    await db.changeData(
        "UPDATE 'reports' SET X2 = $xRepNum WHERE report_name = 'clients'");
  }

  @override
  Future<void> xRepoNum() async {
    xRepNum++;
    await db.changeData(
        "UPDATE 'reports' SET X = $xRepNum WHERE report_name = 'clients'");
  }

  @override
  Future<void> z2RepoNum() async {
    // TODO: implement z2RepoNum
  }

  @override
  Future<void> zRepoNum() async {
    // TODO: implement zRepoNum
  }



  @override
  List<Pair<String,Pair<int,int>>> getColumns() {
    Pair<String,Pair<int,int>> p1 = Pair("ID", Pair(7,2));
    Pair<String,Pair<int,int>> p2 = Pair("Name", Pair(22,2));
    Pair<String,Pair<int,int>> p3 = Pair("Balance", Pair(19,0));
    Pair<String,Pair<int,int>> p4 = Pair("id", Pair(7,2));
    Pair<String,Pair<int,int>> p5 = Pair("Print_Arabic_Name",Pair(22,2) );
    Pair<String,Pair<int,int>> p6 = Pair("Balance", Pair(19,0));
    Pair<String,Pair<int,int>> p7 = Pair("id", Pair(19,0));
    Pair<String,Pair<int,int>> p8 = Pair(" Clients Report", Pair(0,0));
    return [p1,p2,p3,p4,p5,p6,p7,p8];
  }
}
