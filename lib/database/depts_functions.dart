import '../components/reverse_string.dart';
import 'functions/sections_functions.dart';
import 'initialize_database.dart';

class DeptsFunctions {
  static Future<void> deptUpdate(
      {required int id,
      required String name,
      required String section}) async {
    List<Map> response = await SectionsFunctions.getDepartmentList(section,sameDepartment: true);

    int idDepartment = response[0]["id_department"];
    PosData data = PosData();
    String printName = name == "" ? "dept$id" : reversArString(name);
    await data.changeData(
        "UPDATE dept SET name='$name' ,Print_Name='$printName' ,department =$idDepartment WHERE id_dept=$id");
  }

  static Future<List<Map>> getDept(int id) async {
    PosData data = PosData();
    List<Map> response = await data.readData(
        "SELECT * FROM `dept` JOIN departments ON `department`=`id_department` WHERE id_dept=$id");
    print(response);
    return response;
  }

  static Future<List<Map>> getDeptList(int id, String name) async {
    PosData data = PosData();
    List<Map> response = await data.readData(
        "SELECT * FROM `dept` JOIN departments ON `department`=`id_department` WHERE NOT(id_dept=$id) AND name='$name' ");
    print(response);
    return response;
  }
}
