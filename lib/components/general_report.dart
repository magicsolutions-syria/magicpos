import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:magicposbeta/bloc/report_bloc/report_bloc.dart';
import 'package:magicposbeta/theme/custom_colors.dart';
import 'package:magicposbeta/modules/custom_exception.dart';
import '../database/initialize_database.dart';
import '../database/shared_preferences_functions.dart';
import '../modules/pair.dart';
import 'custom_button3.dart';
import 'my_dialog.dart';
import 'printer_helper_functions.dart';

late List<Map> data;
List<Map> zReportData = [];
List<bool> checkBoxesList= List.generate(data.length, (index) => true);

abstract class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});
  ReportsScreenState report();

  @override
  State<ReportsScreen> createState() => report();
}

abstract class ReportsScreenState extends State<ReportsScreen> {
  static const platform = MethodChannel('IcodPrinter');
  final double ratio = 2.24 / 100;
  double width = 0;
  late DateTime now;
  late String dateTime;
  late String hour;
  late String date;
  late List<Pair<String,Pair<int,int>>> columns;
  late String reportTitle;
  late int priceComma;
  late int qtyComma;
  int xRepNum = 0;
  int x2RepNum = 0;
  int zRepNum = 0;
  int z2RepNum = 0;

  final String headerFirstLine ="header first line";
  final String headerSecondLine ="header second line";
  final String headerThirdLine ="header third line";


  @override
  void initState() {
    super.initState();
  }

  double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width-20;
  }
  List<Pair<String,Pair<int,int>>> getColumns();

  PosData db = PosData();

  Future<void> getData()async {
    Map<String ,int> floatingPoint = await SharedPreferencesFunctions.getCommas();
    priceComma = floatingPoint[SharedPreferencesNames.priceComma]??1;
    qtyComma = floatingPoint[SharedPreferencesNames.qtyComma]??1;
  }

  String report(List<Map> data, String type , String titlePrefix,int reportType,int qtyComma,int priceComma){
    String report ="";
    double totalMoney = 0;
    double totalQTY = 0;

    Pair<String,Pair<int,int>> firstCol = columns[3];
    Pair<String,Pair<int,int>> secondCol;
    Pair<String,Pair<int,int>> thirdCol;
    switch(reportType){
      case 0:
        secondCol = columns[4];
        thirdCol = columns[5];
        break;
      case 1:
        secondCol = columns[6];
        thirdCol = columns[7];
        break;
      case 2:
        secondCol = columns[8];
        thirdCol = columns[9];
        break;
      default:
        secondCol = columns[10];
        thirdCol = columns[11];
        break;
    }
    int re = type == "X" ? xRepNum : zRepNum;
    report = "${PrinterHelperFunctions.putTextInSpaces(headerFirstLine, 48,position: 1)}\n${PrinterHelperFunctions.putTextInSpaces(headerSecondLine, 48,position: 1)}\n${PrinterHelperFunctions.putTextInSpaces(headerThirdLine, 48,position: 1)}\n${PrinterHelperFunctions.line}"
        "${PrinterHelperFunctions.putTextInSpaces(type, 2,position: 2)}${PrinterHelperFunctions.putTextInSpaces(titlePrefix+reportTitle, 42,position: 1)}${"0000".substring(re.toString().length)}$re\n${PrinterHelperFunctions.line}$date                             $hour\nUserName\n${PrinterHelperFunctions.line}${PrinterHelperFunctions.putTextInSpaces(columns[0].first, columns[0].second.first,position: columns[0].second.second)}${PrinterHelperFunctions.putTextInSpaces(columns[1].first, columns[1].second.first,position: columns[1].second.second)}${PrinterHelperFunctions.putTextInSpaces(columns[2].first, columns[2].second.first,position: columns[2].second.second)}\n${PrinterHelperFunctions.line}";
    for (int i=0;i<data.length;i++) {
      if(checkBoxesList[i]){
        report +=
        "${PrinterHelperFunctions.putTextInSpaces(data[i][firstCol.first].toString(), firstCol.second.first,position: firstCol.second.second)}${PrinterHelperFunctions.putTextInSpaces(secondCol.second.second==2||columns[1].first=="Clicks"?data[i][secondCol.first].toString():data[i][secondCol.first].toStringAsFixed(qtyComma), secondCol.second.first , position: secondCol.second.second )}${PrinterHelperFunctions.putTextInSpaces(data[i][thirdCol.first].toString(),thirdCol.second.first,position: thirdCol.second.second)}\n";
        totalMoney += data[i][thirdCol.first];
        try{
          totalQTY += data[i][secondCol.first];
        }catch(e){
          debugPrint(e.toString());
        }
      }
    }
    report += PrinterHelperFunctions.line;
    debugPrint((totalQTY==0).toString());
    report +=
    "${PrinterHelperFunctions.putTextInSpaces("Total", 22,position: 2)}${PrinterHelperFunctions.putTextInSpaces(totalQTY!=0&&columns[1].first!="Clicks"?totalQTY.toStringAsFixed(qtyComma):" ", 9)}${PrinterHelperFunctions.putTextInSpaces(totalMoney.toString(), 17)}\n";

    report += PrinterHelperFunctions.line;
    if(totalMoney == 0)
    {
      throw CustomException("لا يمكن طباعة تقرير فارغ");
    }
    return report;
  }


  Widget listview(bool s,int qtyComma,int priceComma) {
    double totalMoney = 0;
    double totalQTY = 0;
    String firstCol = columns[columns.length-1].first==" Clients Report"||columns[columns.length-1].first==" Suppliers Report"?"Name_Arabic":columns[s?6:4].first;

    String secondCol = columns[s?7:5].first;
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
          if (index == data.length + 1 || index == data.length + 3) {
            return const Text(
              "-----------------------------------------------------------------------------",
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
                      width: 0.15 * MediaQuery.of(context).size.width,
                      color: Colors.white30,
                      alignment: Alignment.centerLeft,
                      height: 40,
                      child: const Text(
                        "Total",
                        style: TextStyle(fontSize: 18),
                      )),
                  Container(
                    width: 0.042 * MediaQuery.of(context).size.width,
                    color: Colors.white30,
                    alignment: Alignment.centerRight,
                    height: 40,
                    child: Text(
                      columns[1].second.second!=2&&columns[1].first!="Clicks"?totalQTY.toStringAsFixed(qtyComma):" ",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  Container(
                    width: 0.103 * MediaQuery.of(context).size.width,
                    color: Colors.white30,
                    height: 40,
                    alignment: Alignment.centerRight,
                    child: Text(
                      totalMoney.toStringAsFixed(priceComma),
                      style: const TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
            );
          }
          try{
            totalQTY += data[index - 1][firstCol];
          }catch(e){
            debugPrint(e.toString());
          }
          totalMoney += data[index - 1][secondCol];
          return SizedBox(
            height: 25,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: (columns[1].second.second !=2?0.15:0.042) * MediaQuery.of(context).size.width,
                    color: Colors.white30,
                    alignment: Alignment.centerLeft,
                    height: 40,
                    child: Text(
                      data[index - 1][columns[columns.length-2].first].toString(),
                      style: const TextStyle(fontSize: 18),
                    )),
                Container(
                  width:(columns[1].second.second !=2?0.042* MediaQuery.of(context).size.width:0.15* MediaQuery.of(context).size.width) ,
                  color: Colors.white30,
                  alignment:columns[1].second.second ==2? Alignment.centerLeft:Alignment.centerRight,
                  height: 40,
                  child: Text(
                    columns[4].second.second==2||columns[1].first=="Clicks"?data[index-1][firstCol].toString():data[index-1][firstCol].toStringAsFixed(qtyComma),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  width: 0.103 * MediaQuery.of(context).size.width,
                  color: Colors.white30,
                  height: 40,
                  alignment: Alignment.centerRight,
                  child: Text( data[index - 1][secondCol].toStringAsFixed(priceComma),
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
  Widget checkBoxes(){
    return const SizedBox(width: 0,);
  }

  bool button1();

  bool button2();

  bool button3();

  bool button4();

  bool hasOptions();

  Text title();

  Future<void> xRepoNum();
  Future<void> zRepoNum();
  Future<void> x2RepoNum();
  Future<void> z2RepoNum();
  List<String> departmentsNames = [];
  TextEditingController departmentController = TextEditingController();
  onPressedZ2() {
    MyDialog.showWarningOperatorDialog(
        context: context,
        isWarning: true,
        title: "هل انت متأكد من انك تريد تصفير التقرير التجميعي",
        onTap: () async{
          await zData();
          try{

            String text = report(zReportData, "Z2", "Collective", 4,qtyComma,priceComma);
            _print(text);
            zero2();
            setState(() {
              zRepoNum();
            });
            if (mounted) {
              Navigator.of(context).pop();
            }
          }catch(e){
            if(mounted) {
              MyDialog.showAnimateWrongDialog(context: context, title: e.toString());
            }
          }
        },
        onCancel: () {});
  }

  onPressedZ1() {
    MyDialog.showWarningOperatorDialog(
        context: context,
        isWarning: true,
        title: "هل انت متأكد من انك تريد تصفير التقرير اليومي",
        onTap: () async{
          await zData();

          try{

            String text = report(zReportData, "Z", "Daily", 2,qtyComma,priceComma);
            _print(text);
            zero1();
            setState(() {
              zRepoNum();
            });
            if(mounted){
              Navigator.of(context).pop();
            }
          }catch(e){
            if(mounted){
              MyDialog.showAnimateWrongDialog(
                  context: context, title: e.toString());
            }
          }
        },
        onCancel: () {});
  }

  Future<void> zero1();

  Future<void> zero2();
  Future<void> zData()async {
    zReportData = data;
  }
  Widget drop(Function notify){
    return const SizedBox(width: 0,height: 0,);
  }

  _print(String text) async {
    try{
      await platform.invokeMethod("printText", text);
    }catch(e){
      debugPrint("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(  
      create: (BuildContext context) {
        return ReportCubit(() => InitialReportState());
      },
      child: Scaffold(
          appBar: AppBar(
            title: title(),
          ),
          body: Center(
              child: Container(
            height: 0.91 * MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(ratio * MediaQuery.of(context).size.width),
            padding: EdgeInsets.symmetric(
              vertical: ratio * MediaQuery.of(context).size.width,
              horizontal:
                  0.5 * (ratio + 0.015) * MediaQuery.of(context).size.width,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).fieldsColor,
              borderRadius: BorderRadius.circular(
                ratio * MediaQuery.of(context).size.width,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BlocBuilder<ReportCubit, ReportStates>(
                  builder: (BuildContext context, value) {
                    return FutureBuilder(
                    future: getData(),
                    builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                    return SizedBox(
                      width: 0.33 * MediaQuery.of(context).size.width,
                      child: const Center(
                      child: CircularProgressIndicator()),
                    );
                    } else if (snapshot.connectionState ==
                    ConnectionState.done) {
                      columns = getColumns();
                      reportTitle = columns[columns.length-1].first;
                      now = DateTime.now();
                      dateTime =
                          DateFormat('dd/MM/yyyy').format(now);
                      hour = DateFormat(' HH:mm:ss').format(now);
                      date = dateTime;
                      checkBoxesList= List.generate(data.length, (index) => true);

                      return Column(
                        children: [
                          SizedBox(
                            height: 0.075 * MediaQuery.of(context).size.height,
                            width: 0.33 * MediaQuery.of(context).size.width,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  MaterialButton(
                                    onPressed: hasOptions()
                                        ? () {
                                      context.read<ReportCubit>().flip();
                                    }
                                        : null,
                                    color: Theme.of(context).primaryColor,
                                    child: Text(
                                      context.read<ReportCubit>().button(hasOptions()),
                                      style: TextStyle(
                                          color: Theme.of(context).fieldsColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),

                                  ),drop(context.read<ReportCubit>().notifyListeners)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 0.36 * MediaQuery.of(context).size.width,
                            height: 0.64 * MediaQuery.of(context).size.height,

                            child:Scrollbar(
                                thickness: 15,
                                thumbVisibility: true,
                                trackVisibility: true,
                                interactive: true,
                                child: SingleChildScrollView(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [

                                      SizedBox(width: 0.02*MediaQuery.of(context).size.width,child: checkBoxes()),
                                        SizedBox(width: 0.3*MediaQuery.of(context).size.width,child: listview(context.read<ReportCubit>().s,qtyComma,priceComma)),

                                    ],
                                  ),
                                )),
                          ),
                        ],
                      );
                    }

                    return Container();
                    });
                  },
                ),
                SizedBox(
                  width: 0.4 * MediaQuery.of(context).size.width,
                  height: 0.8 * MediaQuery.of(context).size.height,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomButton3(
                            width: 200,
                            height: 200,
                            onPressed: () {
                              try{
                                String text = '';
                                text = report(data, "X", "Daily", 0,qtyComma,priceComma);
                                xRepoNum();
                                _print(text);
                              }catch(e){
                                MyDialog.showAnimateWrongDialog(context: context, title: e.toString());
                              }
                              setState(() {});
                            },
                            icon: Icons.print,
                            engText: "Print daily report",
                            arText: "طباعة التقرير اليومي",
                            nullOnPressed: button1(),
                          ),
                          CustomButton3(
                            width: 200,
                            height: 200,
                            onPressed: () {
                              try{
                                String text =
                                    report(data, "X2", "Collective", 1,qtyComma,priceComma);
                                _print(text);
                                x2RepoNum();
                              }catch(e){
                                MyDialog.showAnimateWrongDialog(context: context, title: e.toString());
                              }
                            },
                            icon: Icons.print,
                            engText: "Print collective report",
                            arText: "طباعة التقرير التجميعي",
                            nullOnPressed: button2(),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomButton3(
                            width: 200,
                            height: 200,
                            onPressed: onPressedZ1,
                            icon: Icons.text_snippet_outlined,
                            engText: "Clear daily data",
                            arText: "تصفير التقرير اليومي",
                            nullOnPressed: button3(),
                          ),
                          CustomButton3(
                            width: 200,
                            height: 200,
                            onPressed: onPressedZ2,
                            icon: Icons.text_snippet_outlined,
                            engText: "Clear collective data",
                            arText: "تصفير التقرير التجميعي",
                            nullOnPressed: button4(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ))),
    );
  }
}


