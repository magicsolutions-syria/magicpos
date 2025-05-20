import 'package:flutter/material.dart';
import 'package:magicposbeta/theme/custom_colors.dart';

import '../../../components/default_printer_list.dart';
import '../../../components/operator_button.dart';
import '../../../components/printers_list.dart';
import '../../../components/waiting_widget.dart';
import '../../../database/initialize_database.dart';
import '../../../database/printers_database_functions.dart';
import '../lists/select_group_list.dart';

class PrintersPage extends StatelessWidget {
  const PrintersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
      SizedBox(
      height: 50,
      child: Row(
        children: [
          const Spacer(),
          SizedBox(
            height: 45,
            width: 1,
            child: Center(
              child: Container(
                height: 25,
                width: 1,
                color: Theme.of(context).dividerSecondaryColor,
              ),
            ),
          ),
          const SizedBox(
            width: 110,
          ),
          const Text(
            "المجموعات المربوطة",
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(
            width: 119,
          ),
          SizedBox(
            height: 45,
            width: 1,
            child: Center(
              child: Container(
                height: 25,
                width: 1,
                color: Theme.of(context).dividerSecondaryColor,
              ),
            ),
          ),
          const SizedBox(
            width: 100,
          ),
          const Text(
            "عرض ورقة الطباعة",
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(
            width: 120,
          ),
          SizedBox(
            height: 45,
            width: 1,
            child: Center(
              child: Container(
                height: 25,
                width: 1,
                color: Theme.of(context).dividerSecondaryColor,
              ),
            ),
          ),
          const SizedBox(
            width: 90,
          ),
          const Text(
            "رقم المدخل     ",
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(
            width: 89,
          )
        ],
      ),
    ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(
            indent: 10,
            thickness: 4,
            endIndent: 15,
            height: 4,
          ),
        ),
        Expanded(
          child: FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const WaitingWidget();
                }
                return ListView.separated(
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext context, index) {
                    String name = snapshot.data![index]["name"].toString().endsWith("005")?"${snapshot.data![index]["name"].toString().substring(0,snapshot.data![index]["name"].toString().length-1)}3":snapshot.data![index]["name"].toString();
                    return Row(
                      children: [
                        IconButton(onPressed: (){
                          deletePrinter(snapshot.data![index]["id"]);
                        }, icon: const Icon(Icons.delete)),
                        const SizedBox(
                          width: 25,
                        ),
                        SizedBox(
                          height: 45,
                          width: 1,
                          child: Center(
                            child: Container(
                              height: 25,
                              width: 1,
                              color: Theme.of(context)
                                  .dividerSecondaryColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 95.0),
                          child: OperatorButton(onPressed: () {
                                showDialog(context: context, builder:
                                (context){
                                  return SelectGroupList(departmentField: "printer_id",groupField: "printer_id",pivot: snapshot.data![index]
                                  ["id"],defaultValue: -1,);
                                });
                          }, text: 'عرض المجموعات', color: Theme.of(context).primaryColor, enable: true,textColor: Colors.white ,fontSize: 25,width: 220,height: 50  ,)
                        ),
                        SizedBox(
                          height: 45,
                          width: 1,
                          child: Center(
                            child: Container(
                              height: 25,
                              width: 1,
                              color: Theme.of(context)
                                  .dividerSecondaryColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0),
                          child: SizedBox(
                            width: 370  ,
                            height: 40,
                            child: Center(
                              child: Text(
                                snapshot.data![index]
                                ["width"].toString(),
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 45,
                          width: 1,
                          child: Center(
                            child: Container(
                              height: 25,
                              width: 1,
                              color: Theme.of(context)
                                  .dividerSecondaryColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0),
                          child: SizedBox(
                            width: 288  ,
                            height: 40,
                            child: Center(
                              child: Text(
                                name,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  itemCount: snapshot.data!.length,
                  separatorBuilder:
                      (BuildContext context, int index) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(
                        indent: 20,
                        thickness: 0,
                        endIndent: 20,
                        height: 1,
                      ),
                    );
                  },
                );
              }),
        ),
        SizedBox(height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OperatorButton(onPressed: (){
              showDialog(context: context, builder: (context){
                return PrintersList(departmentController: TextEditingController(), );
              });
            }, text: "اضافة طابعة", color: Theme.of(context).primaryColor, enable: true,textColor: Colors.white,width: 250,fontSize: 25,),
            OperatorButton(onPressed: (){
              showDialog(context: context, builder: (context){
                return DefaultPrinterList(departmentController: TextEditingController(),);
              });
            }, text: "تحديد الطابعة الرئيسة", color: Theme.of(context).primaryColor, enable: true,textColor: Colors.white,width: 250,fontSize: 25,),
          ],
        ),)
      ],
    );
  }
}



Future<List<Map>> getData()async{
  PosData db = PosData();
  List<Map> res =  await db.readData("SELECT * FROM printers");
  return res;
}