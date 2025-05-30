import 'package:flutter/material.dart';
import 'package:magicposbeta/components/custom_drop_down_menu.dart';
import 'package:magicposbeta/database/initialize_database.dart';
import '../modules/printer.dart';

class PrintersList extends StatelessWidget {
  PrintersList({
    super.key,
    required this.departmentController,
  });
  final TextEditingController departmentController;
  final TextEditingController widthController = TextEditingController();



  @override
  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 300,
      child: SizedBox(
        width: 462,
        height: 622,
        child: Column(
          children: [
            Padding(
              padding:
              const EdgeInsets.only(top: 30, right: 15, left: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomDropDownMenu(title: "   :   طريقة الوصل  ", data: const [
                    "usb"
                  ], controller: departmentController,initVal: "usb",notify: (){}, onChanged: (String value) {  },),
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                height: 300,
                width: 465,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: FutureBuilder(future: Printer.getUsbDevices(), builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { if(snapshot.connectionState == ConnectionState.waiting){
                return const CircularProgressIndicator();}
                  if(snapshot.connectionState == ConnectionState.done){
                    return ListView.separated(itemCount:snapshot.data.length,itemBuilder: (context,index){
                      if(snapshot.data[index]!=""){
                            return GestureDetector(
                              onDoubleTap: () async {
                                Navigator.pop(context);
                                PosData db = PosData();
                                print("###############################");
                                print(snapshot.data);
                                print("###############################");
                                await db.insertData(
                                    "INSERT INTO 'printers' ('width','name') VALUES ('${widthController.text}' , '${snapshot.data[index]}')");
                              },
                              child: SizedBox(
                                height: 60,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                        width: 250,
                                        child: Center(
                                            child: Text(snapshot.data[index]))),
                                    CustomDropDownMenu(
                                      title: "",
                                      data: const ["80", "58"],
                                      controller: widthController,
                                      initVal: "80",
                                      width: 100,
                                      fontSize: 20,
                                      scaleY: 0.7,
                                      notify: (){}, onChanged: (String value) {  },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        }, separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },);
                  }
                  return const SizedBox(height: 0,);
                },

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
