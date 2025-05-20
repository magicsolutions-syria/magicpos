import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:magicposbeta/database/printers_database_functions.dart';
import 'package:magicposbeta/providers/products_table_provider.dart';

import '../database/database_functions.dart';
import '../database/shared_preferences_functions.dart';
import '../modules/printer.dart';
import '../modules/product.dart';
import 'my_dialog.dart';

class PrinterHelperFunctions{

  static String putTextInSpaces(String text,int spacesNum,{int position = 0})
  {
    String spaces = "                                                                    ".substring(0,spacesNum);
    String textInSpaces = "";
    switch(position){
      case 1:
        String leftSpaces = spaces.substring(0,spacesNum~/2);
        String leftText = text.substring(0,text.length~/2);
        String rightText = text.substring(text.length~/2);
        textInSpaces = putTextInSpaces(leftText, leftSpaces.length)+putTextInSpaces(rightText, spacesNum~/2,position: 2);

        break;
      case 2:
        textInSpaces = text.substring(0,min(text.length,spacesNum))+spaces.substring(min(text.length,spacesNum));
        break;
      default:
        textInSpaces = spaces.substring(min(text.length,spacesNum))+text.substring(0,min(text.length,spacesNum));
        break;
    }
    return textInSpaces;
  }

  static const String line = "------------------------------------------------\n";

  static Future<void> print(ProductsTableProvider productVal,BuildContext context,String printerText,Map<int,List<Product>> mp)async{

      try {
        //await Printer.defaultPrint(printerText);
      } catch (e) {
        MyDialog.showAnimateWarningDialog(
            context: context, isWarning: true, title: e.toString());
      }
      if (mp.length > 1) {
        mp.forEach((key, value) async {

          if (key != -1) {
            String kitchenBill = "";
            kitchenBill = productVal.printerText(-1, value);
            String printerName = await findPrinterById(key);
            try {
              await Printer.print(kitchenBill, printerName);
            } catch (e) {
              MyDialog.showAnimateWarningDialog(
                  context: context,
                  isWarning: true,
                  title: e.toString());
            }
          }
        });
      }
    }


}