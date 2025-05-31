import 'package:flutter/material.dart';
import 'package:magicposbeta/complex_components/check_boxes/check_boxes_widget.dart';
import 'package:magicposbeta/components/choises_list.dart';
import 'package:magicposbeta/components/operator_button.dart';
import 'package:magicposbeta/theme/custom_colors.dart';
import 'package:magicposbeta/modules/pair.dart';
import '../../components/general_report.dart';
import '../../components/printer_helper_functions.dart';
import '../../modules/custom_exception.dart';

class MaterialInventory extends ReportsScreen {
  static const String route = "/material-inventory-screen";

  const MaterialInventory({super.key});
  @override
  ReportsScreenState report() {
    return _MaterialInventoryState();
  }
}

class _MaterialInventoryState extends ReportsScreenState {

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
        .readData("SELECT * FROM reports WHERE report_name = 'inventory'");
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
  Widget listview(bool s,int qtyComma,int priceComma) {
    double totalInQuantity = 0;
    double totalOutQuantity = 0;
    double totalBalanceQuantity = 0;
    return  Column(
      children: List.generate(data.length+4, (index) {
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
              SizedBox(
                height: 20,
                width: 0.5 * getWidth(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 0.115 * getWidth(context),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Product Name",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Container(
                      width: 0.061 * getWidth(context),
                      alignment: Alignment.centerRight,
                      child: const Text(
                        "In",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Container(
                      width: 0.061 * getWidth(context),

                      alignment: Alignment.centerRight,
                      child: const Text(
                        "Out",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Container(
                      width: 0.063 * getWidth(context),

                      alignment: Alignment.centerRight,
                      child: const Text(
                        "Balance",
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
              )
            ],
          );
        }
        if (index == data.length + 1 || index == data.length + 3) {
          return const Text(
            "----------------------------------------------------------------------------",
            style: TextStyle(fontSize: 18),
          );
        }
        if (index == data.length + 2) {

          return SizedBox(
            height: 25,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: 0.115 * MediaQuery.of(context).size.width,
                    color: Colors.white30,
                    alignment: Alignment.centerLeft,
                    height: 40,
                    child: const Text(
                      "Total",
                      style: TextStyle(fontSize: 18),
                    )),
                Container(
                  width: 0.06 * MediaQuery.of(context).size.width,
                  color: Colors.white30,
                  alignment: Alignment.centerRight,
                  height: 40,
                  child: Text(
                    totalInQuantity.toStringAsFixed(qtyComma),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  width: 0.06 * MediaQuery.of(context).size.width,
                  color: Colors.white30,
                  height: 40,
                  alignment: Alignment.centerRight,
                  child: Text(
                    totalOutQuantity.toStringAsFixed(qtyComma),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  width: 0.06 * MediaQuery.of(context).size.width,
                  color: Colors.white30,
                  height: 40,
                  alignment: Alignment.centerRight,
                  child: Text(
                    totalBalanceQuantity.toStringAsFixed(qtyComma),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          );
        }
        totalInQuantity += data[index - 1]["Out_quantity_$prefix"];
        totalOutQuantity += data[index - 1]["In_quantity_$prefix"];
        totalBalanceQuantity += data[index - 1]["current_quantity_$prefix"];

        return SizedBox(
          height: 25,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: 0.115 * MediaQuery.of(context).size.width,
                  color: Colors.white30,
                  alignment: Alignment.centerLeft,
                  height: 40,
                  child: Text(
                    data[index - 1]["ar_name"],
                    style: const TextStyle(fontSize: 18),
                  )),
              Container(
                width: 0.06 * MediaQuery.of(context).size.width,
                color: Colors.white30,
                alignment: Alignment.centerRight,
                height: 40,
                child: Text(
                  data[index - 1]["In_quantity_$prefix"].toStringAsFixed(qtyComma),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Container(
                width: 0.06 * MediaQuery.of(context).size.width,
                color: Colors.white30,
                height: 40,
                alignment: Alignment.centerRight,
                child: Text(
                  data[index - 1]["Out_quantity_$prefix"].toStringAsFixed(qtyComma),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Container(
                width: 0.06 * MediaQuery.of(context).size.width,
                color: Colors.white30,
                height: 40,
                alignment: Alignment.centerRight,
                child: Text(
                  data[index - 1]["current_quantity_$prefix"].toStringAsFixed(qtyComma),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        );
      }),
    );

  }

  @override
  Widget checkBoxes() {
    return const CheckBoxes();
  }

  @override
  String report(List<Map> data, String type , String titlePrefix,int reportType,int qytComma,int priceComma){
    String report ="";
    double totalInQ = 0;
    double totalOutQ = 0;
    double totalCurQ = 0;

    int re = type == "X" ? xRepNum : zRepNum;
    report = "\n\n\n\n${PrinterHelperFunctions.line}"
        "${PrinterHelperFunctions.putTextInSpaces(type, 2,position: 2)}${PrinterHelperFunctions.putTextInSpaces(titlePrefix+reportTitle, 42,position: 1)}${"0000".substring(re.toString().length)}$re\n${PrinterHelperFunctions.line}$date                             $hour\nUserName\n${PrinterHelperFunctions.line}${PrinterHelperFunctions.putTextInSpaces("Name", 21,position: 2)}${PrinterHelperFunctions.putTextInSpaces("In", 9,)}${PrinterHelperFunctions.putTextInSpaces("Out", 9)}${PrinterHelperFunctions.putTextInSpaces("Balance", 9)}\n${PrinterHelperFunctions.line}";
    for (int i=0;i<data.length;i++) {
      if(checkBoxesList[i]){
        report +=
        "${PrinterHelperFunctions.putTextInSpaces(data[i]["Print_Name"].toString(),21,position: 2)}${PrinterHelperFunctions.putTextInSpaces(data[i]["In_quantity_$prefix"].toStringAsFixed(qytComma), 9 ,)}${PrinterHelperFunctions.putTextInSpaces(data[i]["Out_quantity_$prefix"].toStringAsFixed(qytComma),9,)}${PrinterHelperFunctions.putTextInSpaces(data[i]["current_quantity_$prefix"].toStringAsFixed(qytComma),9,)}\n";
        totalInQ +=data[i]["In_quantity_$prefix"];
        totalOutQ +=data[i]["Out_quantity_$prefix"];
        totalCurQ +=data[i]["current_quantity_$prefix"];
      }
    }
    report += PrinterHelperFunctions.line;
    report +=
    "${PrinterHelperFunctions.putTextInSpaces("Total", 21,position: 2)}${PrinterHelperFunctions.putTextInSpaces(totalInQ.toStringAsFixed(qytComma), 9)}${PrinterHelperFunctions.putTextInSpaces(totalOutQ.toStringAsFixed(qytComma), 9)}${PrinterHelperFunctions.putTextInSpaces(totalCurQ.toStringAsFixed(qytComma), 9)}\n";

    report += PrinterHelperFunctions.line;
    if(totalInQ == 0&&totalOutQ == 0)
    {
      throw CustomException("لا يمكن طباعة تقرير فارغ");
    }
    return report;
  }




  @override
  Text title() {
    return Text(
      "جرد المواد",
      style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).secondaryTextColor),
    );
  }

  @override
  Future<void> zero1() async {
  }

  @override
  Future<void> zero2() async {
  }

  @override
  Future<void> x2RepoNum() async {
    x2RepNum++;
    await db.changeData(
        "UPDATE 'reports' SET X2 = $x2RepNum WHERE report_name = 'inventory'");
  }

  @override
  Future<void> xRepoNum() async {
    xRepNum++;
    await db.changeData(
        "UPDATE 'reports' SET X = $xRepNum WHERE report_name = 'inventory'");
  }

  @override
  Future<void> z2RepoNum() async {
    z2RepNum++;
    await db.changeData(
        "UPDATE 'reports' SET Z2 = $z2RepNum WHERE report_name = 'inventory'");
  }

  @override
  Future<void> zRepoNum() async {
    zRepNum++;
    await db.changeData(
        "UPDATE 'reports' SET Z = $zRepNum WHERE report_name = 'inventory'");
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
    Pair<String,Pair<int,int>> p13 = Pair(" Material Inventory", Pair(0,0));
    return [p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13];
  }
}
