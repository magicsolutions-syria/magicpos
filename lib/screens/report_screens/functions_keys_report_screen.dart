import 'package:flutter/material.dart';
import 'package:magicposbeta/theme/custom_colors.dart';

import '../../components/general_report.dart';
import '../../modules/pair.dart';
import '../../screens_data/constants.dart';

class FunctionsKeysReport extends ReportsScreen {
  static const String route = "/functions-key-report-screen";

  const FunctionsKeysReport({super.key});
  @override
  ReportsScreenState report() {
    return _GroupReportState();
  }
}

class _GroupReportState extends ReportsScreenState {
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
    data = await db
        .readData("SELECT * FROM reports WHERE report_name = 'functions'");
    xRepNum = data[0]["X"];
    x2RepNum = data[0]["X2"];
    zRepNum = data[0]["Z"];
    z2RepNum = data[0]["Z2"];
  }

  @override
  Future<void> getData() async {
super.getData();
    await getNum();
    data = await db.readData("SELECT * FROM 'functions_keys'");
  }

  @override
  bool hasOptions() {
    return true;
  }

  @override
  Widget listview(bool s,int qtyComma,int priceComma) {
    return SizedBox(
      width: getWidth(context),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: data.length + 4,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              children: [
                SizedBox(
                  height: 20,
                  width: getWidth(context),
                  child: const Text(
                    "-----------------------------------------------------------------------------",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 22,
                  width: getWidth(context),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width: 0.03 * MediaQuery.of(context).size.width,
                          color: Colors.white30 ,
                          alignment: Alignment.centerLeft,
                          height: 40,
                          child: Text(
                            columns[columns.length-1].first!=" Clients Report"&&columns[columns.length-1].first!=" Suppliers Report"?"X\\Z":"X",
                            style: const TextStyle(fontSize: 18),
                          )),
                      Container(
                        width: 0.232 * MediaQuery.of(context).size.width,
                        color: Colors.white30 ,
                        alignment: Alignment.center,
                        height: 40,
                        child: Text(
                          "${columns[columns.length-1].first!=" Clients Report"&&columns[columns.length-1].first!=" Suppliers Report"?s ? "        Daily" : "Collective":""} ${columns[columns.length-1].first}",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      Container(
                        width: 0.03 * MediaQuery.of(context).size.width,
                        color: Colors.white30 ,
                        height: 40,
                        alignment: Alignment.centerRight,
                        child: const Text(
                          "xxxx",
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                  width: getWidth(context),
                  child: const Text(
                    "-----------------------------------------------------------------------------",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 25,
                  width: getWidth(context),
                  child: Text(
                    "$date                                               $hour",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 20,
                  width: getWidth(context),
                  child: const Text(
                    "UserName",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 20,
                  width: getWidth(context),
                  child: const Text(
                    "-----------------------------------------------------------------------------",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 20,
                  width: 0.5 * getWidth(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: (columns[1].second.second !=2?0.15:0.042) * MediaQuery.of(context).size.width,
                        alignment: Alignment.centerLeft,
                        child:  Text(
                          columns[0].first,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      Container(
                        width:(columns[1].second.second !=2?0.042* MediaQuery.of(context).size.width:0.15* MediaQuery.of(context).size.width) ,
                        alignment:columns[1].second.second ==2? Alignment.centerLeft:Alignment.centerRight,
                        child:  Text(
                          columns[1].first,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      Container(
                        width: 0.104 * getWidth(context),
                        alignment: Alignment.centerRight,
                        child:  Text(
                          columns[2].first,
                          style: const TextStyle(fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                  width: getWidth(context),
                  child: const Text(
                    "-----------------------------------------------------------------------------",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              ],
            );
          }
          if (index == data.length + 1 ) {
            return const Text(
              "-----------------------------------------------------------------------------",
              style: TextStyle(fontSize: 18),
            );
          }
          if (index == data.length + 2 || index == data.length + 3) {
            return const SizedBox(width: 0,height: 0,);
          }
          return SizedBox(
            height: 25,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: 0.15 * MediaQuery.of(context).size.width,
                    color: Colors.white30,
                    alignment: Alignment.centerLeft,
                    height: 40,
                    child: Text(
                      data[index - 1]["key_name"],
                      style: const TextStyle(fontSize: 18),
                    )),
                Container(
                  width: 0.04 * MediaQuery.of(context).size.width,
                  color: Colors.white30,
                  alignment: Alignment.centerRight,
                  height: 40,
                  child: Text(
                    s
                        ? data[index - 1]["clicks_1"].toString()
                        : data[index - 1]["clicks_2"].toString(),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  width: 0.1 * MediaQuery.of(context).size.width,
                  color: Colors.white30,
                  height: 40,
                  alignment: Alignment.centerRight,
                  child: Text(
                    s
                        ? data[index - 1]["amount_1"].toStringAsFixed(priceComma)
                        : data[index - 1]["amount_2"].toStringAsFixed(priceComma),
                    style: const TextStyle(fontSize: 18),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  String report(List<Map> data, String type, String titlePrefix, int reportType,int qtyComma,int priceComma) {
    String report = super.report(data, type, titlePrefix, reportType,qtyComma,priceComma);
    return report.substring(0,report.length-98);
  }

  @override
  Text title() {
    return Text(
      "تقرير حركة الأزرار",
      style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).secondaryTextColor),
    );
  }

  @override
  Future<void> zero1() async {
    await db
        .changeData("UPDATE 'functions_keys' SET clicks_1 = 0,amount_1 = 0.0");
  }

  @override
  Future<void> zero2() async {
    await db.changeData(
        "UPDATE 'functions_keys' SET clicks_2 = 0 ,amount_2 = 0.0 ");
  }

  @override
  Future<void> x2RepoNum() async {
    x2RepNum++;
    await db.changeData(
        "UPDATE 'reports' SET X2 = $x2RepNum WHERE report_name = 'functions'");
  }

  @override
  Future<void> xRepoNum() async {
    xRepNum++;
    await db.changeData(
        "UPDATE 'reports' SET X = $xRepNum WHERE report_name = 'functions'");
  }

  @override
  Future<void> z2RepoNum() async {
    z2RepNum++;
    await db.changeData(
        "UPDATE 'reports' SET Z2 = $z2RepNum WHERE report_name = 'functions'");
  }

  @override
  Future<void> zRepoNum() async {
    zRepNum++;
    await db.changeData(
        "UPDATE 'reports' SET Z = $zRepNum WHERE report_name = 'functions'");
  }



  @override
  List<Pair<String, Pair<int,int>>> getColumns() {
    Pair<String,Pair<int,int>> p1 = Pair("Name", Pair(22,2));
    Pair<String,Pair<int,int>> p2 = Pair("Clicks", Pair(9,0));
    Pair<String,Pair<int,int>> p3 = Pair("Amount", Pair(17,0));
    Pair<String,Pair<int,int>> p4 = Pair("key_name", Pair(22,2));
    Pair<String,Pair<int,int>> p5 = Pair("clicks_1",Pair(9,0) );
    Pair<String,Pair<int,int>> p6 = Pair("amount_1", Pair(17,0));
    Pair<String,Pair<int,int>> p7 = Pair(" Function Keys Report", Pair(0,0));
    return [p1,p2,p3,p4,p5,p6,p7];
  }
}
