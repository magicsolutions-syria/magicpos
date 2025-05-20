import 'initialize_database.dart';

PosData db = PosData();

Future<void> deletePrinter(int id)async{
  await db.deleteData("DELETE FROM 'printers' WHERE id=$id");
}

Future<void> addPrinter(String width,String name)async{

  print("INSERT INTO 'printers' ('width','name') VALUES ('$width' , '$name')");
  await db.insertData(
      "INSERT INTO 'printers' ('width','name') VALUES ('$width' , '$name')");
}
Future<List<String>> getAllPrinters()async{
  List<Map> res =   await db.readData("SELECT * FROM printers");
  List<String> finalRes = [];
  for (Map element in res) {
    finalRes.add(element["name"]);
  }
  return finalRes;
}

Future<String> findPrinterById(int printerId)async{
  if(printerId==-1){
    return "";
  }
  List<Map> res = await db.readData("SELECT * FROM printers WHERE id=$printerId");
  String printerName = res[0]["name"];
  return printerName;
}

Future<int> findPrinterByName(String printerName)async{
  List<Map> res = await db.readData("SELECT * FROM printers WHERE name='$printerName'");
  int printerId = res[0]["id"];
  return printerId;
}