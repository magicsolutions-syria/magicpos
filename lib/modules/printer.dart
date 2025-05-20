import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:magicposbeta/components/my_dialog.dart';
import 'package:magicposbeta/database/initialize_database.dart';
import 'package:magicposbeta/database/printers_database_functions.dart';
import 'package:magicposbeta/database/shared_preferences_functions.dart';
import 'package:magicposbeta/modules/custom_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/utils/utils.dart';

class Printer{
  static const platform = MethodChannel('IcodPrinter');
  static Future<void> defaultPrint(String text,{ withCut = true})async{
    try{
      String method = "print";
      int defaultPrinter = await SharedPreferencesFunctions.getDefaultPrinter();
      String printerName = await findPrinterById(defaultPrinter);
      String headerType = await SharedPreferencesFunctions.getHeaderType();
      String footer = await SharedPreferencesFunctions.getBillFooter();

      if (footer == "" && withCut) {
        method = "printAndCut";
      }
      if (headerType == "logo") {
        await printLogo(printerName);
      }
      if (headerType == "header") {
        String header = await SharedPreferencesFunctions.getBillHeader();
        debugPrint("header");
        await printHeader(header, printerName, false);
        debugPrint("header");
      }
      debugPrint(method);
      await platform.invokeMethod(method, [text, printerName]);
      debugPrint("printer");
      if (footer != "") {
        await printHeader(footer, printerName, withCut);
      }
    }catch(e){
      PlatformException exception = (e as PlatformException);
      String? message = exception.message;
      if(message!=null){
        message = message.substring(message.indexOf(":")+1);
      }
      debugPrint(message);
      throw CustomException(message??"");
    }
  }
  static Future<void> print(String text,String printerName, { withCut = true})async {
    if(printerName==""){
      return;
    }
    String method = withCut?"printAndCut":"print";
    try{
      await platform.invokeMethod(method, [text, printerName]);
    }catch(e){
      PlatformException exception = (e as PlatformException);
      String? message = exception.message;
      if(message!=null){
        message = message.substring(message.indexOf(":")+1);
      }
      throw CustomException(message??"");
    }
  }

  static Future<List> getUsbDevices()async{

    List list = await platform.invokeMethod("getUsbDevices");
    PosData db = PosData();
    List<Map> currentPrinters = await db.readData("SELECT * FROM printers");
    List finalList = [];
    for(Map m in currentPrinters){
      if(list.contains(m["name"])){
        for(int i =0;i<list.length;i++){
          if(list[i]==m["name"]){
            debugPrint("list.toString()llll");
            list[i] = "";
          }
        }
      }
    }
    for (var element in list) {
      if(element!=""){
        finalList.add(element);
      }
    }
    debugPrint("list.toString()");

    debugPrint(finalList.toString());
    return finalList;
  }

  static Future<void> linkPrinters() async{
    List<String> printers = await getAllPrinters();
    await platform.invokeMethod("linkPrinters",printers);
  }

  static Future<void> printLogo(String printerName)async{
    await platform.invokeMethod("printLogo",printerName);
  }

  static Future<void> createCopy(String path)async{
    await platform.invokeMethod("createCopy",path);
  }
  
  static Future<void> printHeader(String text, String printerName,bool withCut)async{
    String method = withCut?"printHeaderWithCut":"printHeader";
    await platform.invokeMethod(method,[text,printerName]);
  }

  static Future<void> connect({printerName = ""})async{

      await platform.invokeMethod("connect",printerName);

  }
  static Future<void> printQRCode(String printerName,String qrText) async {
    await platform.invokeMethod("printQRCode",[printerName,qrText]);
  }

  static Future<void> openCash() async{
    await platform.invokeMethod("openCash");
  }
  static Future<void> disconnect() async{
    await platform.invokeMethod("disconnect");
  }

}