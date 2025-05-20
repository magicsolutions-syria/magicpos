import 'package:flutter/material.dart';
import 'package:magicposbeta/theme/custom_colors.dart';

import '../../components/general_report.dart';
import '../../components/printer_helper_functions.dart';
import '../../modules/pair.dart';

class CashReport extends ReportsScreen {
  static const String route = "/cash-report-screen";

  const CashReport({super.key});
  @override
  ReportsScreenState report() {
    return _CashReportState();
  }
}

class _CashReportState extends ReportsScreenState {
  double totalMoney1 = 0;
  double totalMoney2 = 0;
  late List<Map> money;
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
        await db.readData("SELECT * FROM reports WHERE report_name = 'cash'");
    xRepNum = data[0]["X"];
    x2RepNum = data[0]["X2"];
    zRepNum = data[0]["Z"];
    z2RepNum = data[0]["Z2"];
  }

  Future<double> getTotalMoney(String field, String field2) async {
    double totalMoney = 0;
    money = await db.readData(
        "SELECT cash_total_sells_price_one,cash_total_sells_price_two FROM departments");
    for (var element in money) {
      totalMoney += element[field];
    }
    money = await db.readData("SELECT cash_amount_1,cash_amount_2 FROM dept");
    for (var element in money) {
      totalMoney += element[field2];
    }
    return totalMoney;
  }

  @override
  Future<void> getData() async {
super.getData();
    data = await db.readData("SELECT * FROM functions_keys");
    totalMoney1 =
        await getTotalMoney("cash_total_sells_price_one", "cash_amount_1");

    totalMoney2 =
        await getTotalMoney("cash_total_sells_price_two", "cash_amount_2");
  }

  @override
  bool hasOptions() {
    return true;
  }

  @override
  Widget listview(bool s,int qtyComma,int priceComma) {
    double netMoney1 = totalMoney1;
    double netMoney2 = totalMoney2;

    netMoney1 += data[7]["cash_amount_1"];
    netMoney1 += data[9]["cash_amount_1"];
    netMoney1 -= data[8]["cash_amount_1"];
    netMoney1 -= data[10]["cash_amount_1"];

    netMoney2 += data[7]["cash_amount_2"];
    netMoney2 += data[9]["cash_amount_2"];
    netMoney2 -= data[8]["cash_amount_2"];
    netMoney2 -= data[10]["cash_amount_2"];

    double inDrawer1 = data[0]["cash_amount_1"] +
        data[6]["cash_amount_1"] -
        data[5]["cash_amount_1"];
    double inDrawer2 = data[0]["cash_amount_2"] +
        data[6]["cash_amount_2"] -
        data[5]["cash_amount_2"];

    return SingleChildScrollView(
      child: Column(children: [
      Column(
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
                width: 0.05 * MediaQuery.of(context).size.width,
                color: Colors.white30,
                alignment: Alignment.centerLeft,
                height: 40,
                child: Text(
                  columns[columns.length-1].first!=" Clients Report"&&columns[columns.length-1].first!=" Suppliers Report"?"X\\Z":"X",
                  style: const TextStyle(fontSize: 18),
                )),
            Container(
              width: 0.192 * MediaQuery.of(context).size.width,
              color: Colors.white30,
              alignment: Alignment.center,
              height: 40,
              child: Text(
                "${columns[columns.length-1].first!=" Clients Report"&&columns[columns.length-1].first!=" Suppliers Report"?s ? "        Daily" : "Collective":""} ${columns[columns.length-1].first}",
                style: const TextStyle(fontSize: 18),
              ),
            ),
            Container(
              width: 0.05 * MediaQuery.of(context).size.width,
              color: Colors.white30,
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
      ],
    ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 20,
              width: 0.15 * getWidth(context),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Gross Sale ",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              height: 20,
              width: 0.14 * getWidth(context),
              alignment: Alignment.centerRight,
              child: Text(
                s ? totalMoney1.toString() : totalMoney2.toString(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 20,
              width: 0.15 * getWidth(context),
              alignment: Alignment.centerLeft,
              child: const Text(
                " -% ",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              height: 20,
              width: 0.14 * getWidth(context),
              alignment: Alignment.centerRight,
              child: Text(
                s
                    ? data[10]["cash_amount_1"].toString()
                    : data[10]["cash_amount_2"].toString(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 20,
              width: 0.15 * getWidth(context),
              alignment: Alignment.centerLeft,
              child: const Text(
                " - ",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              height: 20,
              width: 0.14 * getWidth(context),
              alignment: Alignment.centerRight,
              child: Text(
                s
                    ? data[8]["cash_amount_1"].toString()
                    : data[8]["cash_amount_2"].toString(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 20,
              width: 0.15 * getWidth(context),
              alignment: Alignment.centerLeft,
              child: const Text(
                " +% ",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              height: 20,
              width: 0.14 * getWidth(context),
              alignment: Alignment.centerRight,
              child: Text(
                s
                    ? data[9]["cash_amount_1"].toString()
                    : data[9]["cash_amount_2"].toString(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 20,
              width: 0.15 * getWidth(context),
              alignment: Alignment.centerLeft,
              child: const Text(
                " + ",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              height: 20,
              width: 0.14 * getWidth(context),
              alignment: Alignment.centerRight,
              child: Text(
                s
                    ? data[7]["cash_amount_1"].toString()
                    : data[7]["cash_amount_2"].toString(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
        Container(
          height: 20,
          alignment: Alignment.centerLeft,
          child: const Text(
            "-----------------------------${PrinterHelperFunctions.line}",
            style: TextStyle(fontSize: 18),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 20,
              width: 0.15 * getWidth(context),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Net Sale ",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              height: 20,
              width: 0.14 * getWidth(context),
              alignment: Alignment.centerRight,
              child: Text(
                s ? netMoney1.toString() : netMoney2.toString(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
        Container(
          height: 20,
          alignment: Alignment.centerLeft,
          child: const Text(
            "-----------------------------${PrinterHelperFunctions.line}",
            style: TextStyle(fontSize: 18),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 22,
              width: 0.15 * getWidth(context),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Cash ",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              height: 20,
              width: 0.14 * getWidth(context),
              alignment: Alignment.centerRight,
              child: Text(
                s
                    ? data[0]["cash_amount_1"].toString()
                    : data[0]["cash_amount_2"].toString(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 22,
              width: 0.15 * getWidth(context),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Visa1 ",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              height: 20,
              width: 0.14 * getWidth(context),
              alignment: Alignment.centerRight,
              child: Text(
                s
                    ? data[2]["cash_amount_1"].toString()
                    : data[2]["cash_amount_2"].toString(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 22,
              width: 0.15 * getWidth(context),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Visa2 ",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              height: 20,
              width: 0.14 * getWidth(context),
              alignment: Alignment.centerRight,
              child: Text(
                s
                    ? data[3]["cash_amount_1"].toString()
                    : data[3]["cash_amount_2"].toString(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 22,
              width: 0.15 * getWidth(context),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Charge ",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              height: 20,
              width: 0.14 * getWidth(context),
              alignment: Alignment.centerRight,
              child: Text(
                s
                    ? data[1]["cash_amount_1"].toString()
                    : data[1]["cash_amount_2"].toString(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 22,
              width: 0.15 * getWidth(context),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Check ",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              height: 20,
              width: 0.14 * getWidth(context),
              alignment: Alignment.centerRight,
              child: Text(
                s
                    ? data[4]["cash_amount_1"].toString()
                    : data[4]["cash_amount_2"].toString(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
        Container(
          height: 20,
          alignment: Alignment.centerLeft,
          child: const Text(
            "-----------------------------${PrinterHelperFunctions.line}",
            style: TextStyle(fontSize: 18),
          ),
        ),
        Container(
          height: 22,
          width: 0.29 * MediaQuery.of(context).size.width,
          alignment: Alignment.centerLeft,
          child: const Text(
            "Cash In Drawer",
            style: TextStyle(fontSize: 18),
          ),
        ),
        Container(
          height: 20,
          alignment: Alignment.centerLeft,
          child: const Text(
            "-----------------------------${PrinterHelperFunctions.line}",
            style: TextStyle(fontSize: 18),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 22,
              width: 0.15 * getWidth(context),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Cash ",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              height: 20,
              width: 0.14 * getWidth(context),
              alignment: Alignment.centerRight,
              child: Text(
                s
                    ? data[0]["cash_amount_1"].toString()
                    : data[0]["cash_amount_2"].toString(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 22,
              width: 0.15 * getWidth(context),
              alignment: Alignment.centerLeft,
              child: const Text(
                "RC ",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              height: 20,
              width: 0.14 * getWidth(context),
              alignment: Alignment.centerRight,
              child: Text(
                s
                    ? data[6]["cash_amount_1"].toString()
                    : data[6]["cash_amount_2"].toString(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 22,
              width: 0.15 * getWidth(context),
              alignment: Alignment.centerLeft,
              child: const Text(
                "PD ",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              height: 20,
              width: 0.14 * getWidth(context),
              alignment: Alignment.centerRight,
              child: Text(
                s
                    ? data[5]["cash_amount_1"].toString()
                    : data[5]["cash_amount_2"].toString(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
        Container(
          height: 20,
          alignment: Alignment.centerLeft,
          child: const Text(
            "-----------------------------${PrinterHelperFunctions.line}",
            style: TextStyle(fontSize: 18),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 22,
              width: 0.15 * getWidth(context),
              alignment: Alignment.centerLeft,
              child: const Text(
                "In Drawer ",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              height: 20,
              width: 0.14 * getWidth(context),
              alignment: Alignment.centerRight,
              child: Text(
                s ? inDrawer1.toString() : inDrawer2.toString(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
      ]),
    );
  }

  @override
  String report(List<Map> data, String type,String titlePrefix,int reportType,int qtyComma,int priceComma) {
    int re = xRepNum;
    switch(reportType){
      case 0:
        break;
      case 1:
        re = x2RepNum;
        break;
      case 2:
        re = zRepNum;
        break;
      default:
        re = z2RepNum;
        break;
    }
    String prefix = "1";
    if(reportType==4 || reportType==1){
      prefix = "2";
    }
    String r = "\n\n\n\n${PrinterHelperFunctions.line}";
    r +=
        "${PrinterHelperFunctions.putTextInSpaces(type, 2,position: 2)}${PrinterHelperFunctions.putTextInSpaces("$titlePrefix Cash Report", 42,position: 1)}${"0000".substring(re.toString().length)}$re\n${PrinterHelperFunctions.line}$date                             $hour\nUserName\n${PrinterHelperFunctions.line}";
    r +=
        "Gross Sale${PrinterHelperFunctions.putTextInSpaces(!(reportType==4 || reportType==1)?totalMoney1.toString():totalMoney2.toString(), 38)}\n";
    r +=
        "-%${PrinterHelperFunctions.putTextInSpaces(data[10]["cash_amount_$prefix"].toString(), 46)}\n";
    !(reportType==4 || reportType==1)?totalMoney1 -= data[10]["cash_amount_$prefix"]:totalMoney2 -= data[10]["cash_amount_$prefix"];
    r +=
        "-${PrinterHelperFunctions.putTextInSpaces(data[8]["cash_amount_$prefix"].toString(), 47)}\n";
    !(reportType==4 || reportType==1)?totalMoney1 -= data[8]["cash_amount_$prefix"]:totalMoney2 -= data[8]["cash_amount_$prefix"];
    r +=
        "+%${PrinterHelperFunctions.putTextInSpaces(data[9]["cash_amount_$prefix"].toString(), 46)}\n";
    !(reportType==4 || reportType==1)?totalMoney1 += data[9]["cash_amount_$prefix"]:totalMoney2 += data[9]["cash_amount_$prefix"];
    r +=
        "+${PrinterHelperFunctions.putTextInSpaces(data[7]["cash_amount_$prefix"].toString(), 47)}\n";
    !(reportType==4 || reportType==1)?totalMoney1 += data[7]["cash_amount_$prefix"]:totalMoney2 += data[7]["cash_amount_$prefix"];
    r += PrinterHelperFunctions.line;
    r +=
        "Net Sale${PrinterHelperFunctions.putTextInSpaces(!(reportType==4 || reportType==1)?totalMoney1.toString():totalMoney2.toString(), 40)}\n";
    r += PrinterHelperFunctions.line;
    r +=
        "Cash${PrinterHelperFunctions.putTextInSpaces(data[0]["cash_amount_$prefix"].toString(), 44)}\n";
    r +=
        "Visa1${PrinterHelperFunctions.putTextInSpaces(data[2]["cash_amount_$prefix"].toString(), 43)}\n";
    r +=
        "Visa2${PrinterHelperFunctions.putTextInSpaces(data[3]["cash_amount_$prefix"].toString(), 43)}\n";
    r +=
        "Charge${PrinterHelperFunctions.putTextInSpaces(data[1]["cash_amount_$prefix"].toString(), 42)}\n";
    r +=
        "Check${PrinterHelperFunctions.putTextInSpaces(data[10]["cash_amount_$prefix"].toString(), 43)}\n";
    r += PrinterHelperFunctions.line;
    r +=
        "${PrinterHelperFunctions.putTextInSpaces("Cash In Drawer", 48,position: 1)}\n${PrinterHelperFunctions.line}";
    r +=
      "Cash${PrinterHelperFunctions.putTextInSpaces(data[0]["cash_amount_$prefix"].toString(), 44)}\n";
    !(reportType==4 || reportType==1)?totalMoney1 = data[0]["cash_amount_$prefix"]:totalMoney2 = data[0]["cash_amount_$prefix"];
    r +=
        "RC${PrinterHelperFunctions.putTextInSpaces(data[6]["cash_amount_$prefix"].toString(), 46)}\n";
    !(reportType==4 || reportType==1)?totalMoney1 += data[6]["cash_amount_$prefix"]:totalMoney2 += data[6]["cash_amount_$prefix"];
    r +=
        "PD${PrinterHelperFunctions.putTextInSpaces(data[5]["cash_amount_$prefix"].toString(), 46)}\n";
    !(reportType==4 || reportType==1)?totalMoney1 -= data[5]["cash_amount_$prefix"]:totalMoney2 -= data[5]["cash_amount_$prefix"];
    r += PrinterHelperFunctions.line;
    r +=
        "In Drawer${PrinterHelperFunctions.putTextInSpaces(!(reportType==4 || reportType==1)?totalMoney1.toString():totalMoney2.toString(), 39)}\n";
    r += PrinterHelperFunctions.line;
    return r;
  }


  @override
  Text title() {
    return Text(
      "تقرير حركة ال Cash",
      style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).secondaryTextColor),
    );
  }

  @override
  Future<void> zero1() async {
    await db.changeData("UPDATE 'functions_keys' SET cash_amount_1 = 0.0");
    await db.changeData("UPDATE 'departments' SET cash_total_sells_price_one = 0.0");
    await db.changeData("UPDATE 'dept' SET cash_amount_1 = 0.0");
  }

  @override
  Future<void> zero2() async {
    await db.changeData("UPDATE 'functions_keys' SET cash_amount_2 = 0.0");
    await db.changeData("UPDATE 'departments' SET cash_total_sells_price_two = 0.0");
    await db.changeData("UPDATE 'dept' SET cash_amount_2 = 0.0");
  }

  @override
  Future<void> x2RepoNum() async {
    x2RepNum++;
    await db.changeData(
        "UPDATE 'reports' SET X2 = $x2RepNum WHERE report_name = 'cash'");
  }

  @override
  Future<void> xRepoNum() async {
    xRepNum++;
    await db.changeData(
        "UPDATE 'reports' SET X = $xRepNum WHERE report_name = 'cash'");
  }

  @override
  Future<void> z2RepoNum() async {
    z2RepNum++;
    await db.changeData(
        "UPDATE 'reports' SET Z2 = $z2RepNum WHERE report_name = 'cash'");
  }

  @override
  Future<void> zRepoNum() async {
    zRepNum++;
    await db.changeData(
        "UPDATE 'reports' SET Z = $zRepNum WHERE report_name = 'cash'");
  }


  @override
  List<Pair<String,Pair<int,int>>> getColumns() {
    return [Pair("",Pair(0,0)),Pair("Cash Report",Pair(0,0))];
  }
}
