import '../components/reverse_string.dart';
import 'functions/sections_functions.dart';
import 'initialize_database.dart';

class DeptsFunctions {
  static Future<void> deptUpdate(
      {required String id,
      required String name,
      required String section}) async {
    if (id == "") {
      throw Exception("يرجى تحديد  أولاً dept");
    }
    int _id = int.parse(id);
    List<Map> res = await getDeptList(_id, name);
    List<Map> response = await SectionsFunctions.getDepartmentList(section);
    int idDepartment = response[0]["id_department"];
    PosData data = PosData();
    String printName = name == "" ? "dept$id" : reversArString(name);
    await data.changeData(
        "UPDATE dept SET name='$name' ,Print_Name='$printName' ,department =$idDepartment WHERE id=$_id");
  }

  static Future<List<Map>> getDept(int id) async {
    PosData data = PosData();
    List<Map> response = await data.readData(
        "SELECT * FROM `dept` JOIN departments ON `department`=`id_department` WHERE id=$id");
    print(response);
    return response;
  }

  static Future<List<Map>> getDeptList(int id, String name) async {
    PosData data = PosData();
    List<Map> response = await data.readData(
        "SELECT * FROM `dept` JOIN departments ON `department`=`id_department` WHERE NOT(id=$id) AND name='$name' ");
    print(response);
    return response;
  }
}
