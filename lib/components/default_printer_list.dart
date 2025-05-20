import 'package:flutter/material.dart';
import 'package:magicposbeta/components/custom_drop_down_menu.dart';
import 'package:magicposbeta/database/initialize_database.dart';
import 'package:magicposbeta/database/printers_database_functions.dart';
import 'package:magicposbeta/database/shared_preferences_functions.dart';

class DefaultPrinterList extends StatelessWidget {
  DefaultPrinterList({
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
                  ], controller: departmentController,initVal: "usb",notify: (){},),
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
                child: FutureBuilder(future: getAllPrinters(), builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { if(snapshot.connectionState == ConnectionState.waiting){
                  return const CircularProgressIndicator();}
                if(snapshot.connectionState == ConnectionState.done){
                  return ListView.separated(itemCount:snapshot.data.length,itemBuilder: (context,index){
                    if(snapshot.data[index]!=""){
                      return GestureDetector(
                        onDoubleTap: () async {
                          Navigator.pop(context);
                          int printerId = await findPrinterByName(snapshot.data[index]);
                          SharedPreferencesFunctions.setDefaultPrinter(printerId: printerId);
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
                                notify: (){},
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox(height: 0,);
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
