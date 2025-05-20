
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'general_report.dart';

class CheckBoxes extends StatelessWidget{
  const CheckBoxes({super.key});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return CheckBoxProvider();
      },
      child: Column(
        children: List.generate(data.length +4, (index) {
          if(index !=0 && index<data.length+1) {
            return Consumer<CheckBoxProvider>(
              builder: (BuildContext context, CheckBoxProvider value, Widget? child) {
                return SizedBox(height: 25,child: IconButton(onPressed: (){
                  value.checkBox(index-1);
                }, icon: Icon(!checkBoxesList[index-1]?Icons.check_box_outline_blank:Icons.check_box_outlined,size: 24,)));
              },
            );
          }
          if(index ==0){
            return const SizedBox(width: 0,height: 25*6.4,);
          }
          return const SizedBox(width: 0,height: 28,);
        }),
      ),
    );
  }



}

class CheckBoxProvider extends ChangeNotifier{
  checkBox(int index){
    checkBoxesList[index] = !checkBoxesList[index];
    notifyListeners();
  }
}
