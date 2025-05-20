import 'package:magicposbeta/components/reverse_string.dart';
import 'package:magicposbeta/database/database_functions.dart';

import '../../modules/custom_exception.dart';
import '../../modules/person.dart';
import '../../theme/locale/locale.dart';
import '../initialize_database.dart';

class PersonFunctions {
  static Future<void> checkExist(Person p, String personType) async {
    bool arNameUnique = await _fieldIsUnique(
        field: p.arName,
        id: p.id,
        searchType: SearchTypes.arName,
        personType: personType);
    if (!arNameUnique) {
      throw CustomException(ErrorsCodes.arNameIsNotUnique);
    }
    bool enNameUnique = await _fieldIsUnique(
        field: p.enName,
        id: p.id,
        searchType: SearchTypes.enName,
        personType: personType);

    if (!enNameUnique) {
      throw CustomException(ErrorsCodes.enNameIsNotUnique);
    }
    bool telNumUnique = await _fieldIsUnique(
        field: p.tel,
        id: p.id,
        searchType: SearchTypes.telNum,
        personType: personType);

    if (!telNumUnique) {
      throw CustomException(ErrorsCodes.telIsNotUnique);
    }
    bool whatsappNumUnique = await _fieldIsUnique(
        field: p.whatsNum,
        id: p.id,
        searchType: SearchTypes.whatsappNum,
        personType: personType);

    if (!whatsappNumUnique) {
      throw CustomException(ErrorsCodes.whatsAppIsNotUnique);
    }
    bool emailUnique = await _fieldIsUnique(
        field: p.email,
        id: p.id,
        searchType: SearchTypes.email,
        personType: personType);

    if (!emailUnique) {
      throw CustomException(ErrorsCodes.emailIsNotUnique);
    }
    bool barcodeUnique = await _fieldIsUnique(
        field: p.barcode,
        id: p.id,
        searchType: SearchTypes.code,
        personType: personType);

    if (!barcodeUnique) {
      throw CustomException(ErrorsCodes.barcodeIsNotUnique);
    }
  }

  Future<Person> getPersonById(int id) async {
    PosData db = PosData();
    if (id == -1) {
      return Person.emptyInstance();
    }
    List<Map> ans = await db.readData("SELECT * FROM clients WHERE id = $id");

    if (ans.isEmpty) {
      return Person.emptyInstance();
    }
    Person p = Person(
        ans[0]["id"],
        ans[0]["In"],
        ans[0]["Out"],
        ans[0]["Balance"],
        ans[0]["Barcode"],
        ans[0]["Name_Arabic"],
        ans[0]["Name_English"],
        ans[0]["Tel"],
        ans[0]["Whatsapp"],
        ans[0]["Email"]);
    return p;
  }

  static Future<void> addPerson(Person p, String personType) async {
    try {
      String printName = reversArString(p.arName);
      PosData db = PosData();
      await checkExist(p, personType);
      await db.insertData(
          "INSERT INTO $personType (Barcode,'In','Out','Balance','Name_Arabic','Print_Arabic_Name','Name_English','Tel','Whatsapp','Email') VALUES (${p.barcode},${p.inBalance},${p.outBalance},${p.balance},'${p.arName}','$printName','${p.enName}','${p.tel}','${p.whatsNum}','${p.email}')");
    } catch (e) {
      throw CustomException(e.toString());
    }
  }

  static Future<void> updatePerson(Person p, String personType) async {
    try {
      PosData db = PosData();
      await checkExist(p, personType);
      String printName = reversArString(p.arName);
      await db.changeData(
          "UPDATE $personType SET Barcode=${p.barcode},Name_Arabic='${p.arName}','Print_Arabic_Name'='$printName',Name_English='${p.enName}',Tel='${p.tel}',Whatsapp='${p.whatsNum}',Email='${p.email}','In'=${p.inBalance},'Out'=${p.outBalance},'Balance'=${p.balance} WHERE id=${p.id}");
    } catch (e) {
      throw CustomException(e.toString());
    }
  }

  static Future<void> deletePerson(Person p, String personType) async {
    PosData db = PosData();
    await db.deleteData("DELETE FROM $personType WHERE id=${p.id}");
  }

  static Future<List<Map>> getPersonList(
      {required String personType,
      required String searchType,
      required String searchText,
      String secondCondition = ""}) async {
    PosData db = PosData();
    String searchColumn;
    switch (searchType) {
      case SearchTypes.arName:
        searchColumn = "Name_Arabic";
        break;
      case SearchTypes.enName:
        searchColumn = "Name_English";
        break;
      case SearchTypes.code:
        searchColumn = "Barcode";
        break;
      case SearchTypes.email:
        searchColumn = "Email";
        break;
      case SearchTypes.whatsappNum:
        searchColumn = "Whatsapp";
        break;
      case SearchTypes.telNum:
        searchColumn = "Tel";
        break;
      default:
        searchColumn = "Name_Arabic";
        break;
    }
    if (secondCondition.isNotEmpty) {
      secondCondition = " AND $secondCondition";
    }
    return await db.readData(
        "SELECT * FROM $personType WHERE $searchColumn LIKE '%$searchText%' $secondCondition");
  }

  static Future<void> addToAccount(
      {required String name,
      required double amount,
      required String type}) async {
    PosData data = PosData();
    List<Map> response = await getPersonList(
        personType: type, searchType: SearchTypes.arName, searchText: name);
    double inAmount = response[0]["In"] + amount;
    double balance = response[0]["Balance"] + amount;
    await data.changeData(
        "UPDATE $type SET `In` = '$inAmount' , `Balance` = $balance WHERE id = ${response[0]["id"]} ");
  }

 static Future<void> withDrawFromAccount(
      {required String name,
      required double amount,
      required String type}) async {
    PosData data = PosData();
    List<Map> response = await getPersonList(
        personType: type, searchType: SearchTypes.arName, searchText: name);
    double outAmount = response[0]["Out"] + amount;
    double balance = response[0]["Balance"] - amount;
    await data.changeData(
        "UPDATE $type SET `Out`=$outAmount ,`Balance`=$balance WHERE id=${response[0]["id"]} ");
  }

  static Future<String> initialPersonId(String tableName) async {
   var d=await getPersonList(personType: tableName, searchType: "", searchText: "searchText");
   PosData db = PosData();

   print("***********************************");
   print(await db.readData(
       "SELECT * FROM suppliers "));
   print(await db.readData(
       "SELECT * FROM clients "));
    return initialId(tableName);
  }

  static Future<bool> _fieldIsUnique(
      {required String field,
      required int id,
      required String searchType,
      required String personType}) async {
    if (field == "") return true;
    List<Map> response = await getPersonList(
        secondCondition: " (id>$id OR id<$id )",
        personType: personType,
        searchType: searchType,
        searchText: field);
    return response.isEmpty;
  }

}
