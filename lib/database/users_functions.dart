import 'package:magicposbeta/components/reverse_string.dart';
import 'package:magicposbeta/database/database_functions.dart';
import 'package:magicposbeta/database/initialize_database.dart';
import 'package:magicposbeta/modules/custom_exception.dart';
import 'package:magicposbeta/screens_data/constants.dart';
import '../modules/permissions_classes/permissions_classes.dart';
import '../modules/user.dart';
import '../theme/locale/search_types.dart';

class UsersFunctions {
  static Future<List<Map>> getUsersList(
      {required String searchText,
      required String searchType,
      String secondCondition = ""}) async {
    PosData data = PosData();
    String columnName = "";
    switch (searchType) {
      case (SearchTypes.arName):
        {
          columnName = "ar_name";
          break;
        }
      case (SearchTypes.enName):
        {
          columnName = "en_name";
          break;
        }
      case (SearchTypes.jopTitle):
        {
          columnName = "jop_title_name";
          break;
        }
      default:
        {
          columnName = "ar_name";
          break;
        }
    }
    String condition = "";
    if (searchText != "" && secondCondition != "") {
      condition = "WHERE $columnName LIKE '%$searchText%' AND $secondCondition";
    } else if (searchText != "" && secondCondition == "") {
      condition = "WHERE $columnName LIKE '%$searchText%'";
    } else if (searchText == "" && secondCondition != "") {
      condition = "WHERE $secondCondition";
    }
    List<Map> res = await data.readData(
        "SELECT * FROM users JOIN jop_titles ON jop_title=id $condition");
    return res;
  }

  static Future<Map<String, dynamic>> getUserPermissions(int userId) async {
    PosData data = PosData();

    List<Map> res = await data.readData(
        "SELECT permission_name FROM user_permissions JOIN permissions ON permission_id=permissions.id WHERE user_id=$userId");
    List<String> item =
        List.generate(res.length, (index) => res[index]["permission_name"]);
    print(res);

    TotalProductPermission productPermission =
        TotalProductPermission.initializeMap(item);
    PayKeyPermission payKeyPermission = PayKeyPermission.initializeMap(item);
    ClientPermission clients = ClientPermission().initializeMap(item);
    SupplierPermission suppliers = SupplierPermission().initializeMap(item);
    OperationKeysPermission keysPermission =
        OperationKeysPermission.initializeMap(item);
    ReportsPermission reportsPermission = ReportsPermission.initializeMap(item);
    return {
      "products": productPermission,
      "clients": clients,
      "suppliers": suppliers,
      "operationKeys": keysPermission,
      "payKeys": payKeyPermission,
      "reports": reportsPermission,
    };
  }

  static Future<void> addUser({required User user}) async {
    PosData data = PosData();

    await _checkUniqueFields(user);
    int index = await getJopTitleId(user.jobTitle);
    List<int> permissions = user.getPermissions();
    String printName = reversArString(user.arName);
    int user_id = await data.insertData(
        "INSERT INTO users (Print_Name,ar_name,en_name,mobile,email,password,jop_title)VALUES('$printName','${user.arName}','${user.enName}','${user.phone}','${user.email}','${user.password}',$index)");
    for (int id in permissions) {
      await data.insertData(
          "INSERT INTO user_permissions (user_id,permission_id)VALUES($user_id,${id + 1})");
    }
  }

  static Future<User> verifyUser(String name, String password) async {
    PosData data = PosData();
    if (name == "") {
      throw CustomException("اسم المستخدم لا يمكن أن يكون فارغاً");
    }
    if (password == "") {
      throw CustomException("كلمة السر لا يمكن أن تكون فارغة");
    }
    List<Map> response = await getUsersList(
        secondCondition: "ar_name='$name' AND password='$password'",
        searchText: '',
        searchType: '');
    if (response.isEmpty) {
      throw CustomException("كلمة السر أو المستخدم خاطئ");
    }

    return await User.instanceFromMap(response[0]);
  }

  static Future<List<String>> getJopTitleList() async {
    PosData data = PosData();
    List<Map> response = await data.readData("SELECT * FROM jop_titles");
    return List.generate(
        response.length, (index) => response[index]["jop_title_name"]);
  }

  static Future<int> getJopTitleId(String job) async {
    PosData data = PosData();
    if (job == "") throw Exception("حقل المسمى الوظيفي لا يمكن أن يكون فارغاً");
    List<String> jopTitleNames = await getJopTitleList();
    int index = jopTitleNames.indexOf(job) + 1;
    if (index == 0) {
      index = await data.insertData(
          "INSERT INTO jop_titles (jop_title_name) VALUES ('$job')");
    }
    return index;
  }

  static Future<bool> _checkUniqueField(
      String fieldName, String check, int id) async {
    List<Map> response = await getUsersList(
        secondCondition: " $fieldName='$check' AND NOT(id_user=$id) ",
        searchText: '',
        searchType: '');
    return response.isNotEmpty;
  }

  static Future<void> _checkUniqueFields(User user) async {
    if (user.arName == "") {
      throw CustomException("حقل الاسم بالعربي لا يمكن أن يكون فارغاً");
    }

    if (await _checkUniqueField("ar_name", user.arName, user.id)) {
      throw CustomException("الاسم بالعربي موجود مسبقاً");
    }
    if (await _checkUniqueField("en_name", user.enName, user.id) &&
        user.enName != "") {
      throw CustomException("الاسم بالإنكليزي موجود مسبقاً");
    }
    if (await _checkUniqueField("mobile", user.phone, user.id) &&
        user.phone != "") {
      throw CustomException("الموبايل موجود مسبقاً");
    }
    if (await _checkUniqueField("email", user.email, user.id) &&
        user.email != "") {
      throw CustomException("الإيميل موجود مسبقاً");
    }
  }

  static Future<void> deleteUser(User user) async {
    PosData data = PosData();

    List<Map> response = await getUsersList(
        secondCondition:
            " id_user=${user.id} AND sold_quantity_one=0 AND sold_quantity_two=0 AND total_sells_price_one=0 AND total_sells_price_two=0 ", searchText: '', searchType: '');
    if (response.isEmpty) {
      throw CustomException("لا يمكنك حذف المستخدم يوجد تقارير مرتبطة به");
    }
    if (response[0]["jop_title_name"] == jopTitleData.first) {
      List<Map> response0 = await getUsersList(
          secondCondition: " jop_title_name='${jopTitleData.first}'", searchText: '', searchType: '');
      if (response0.length == 1) {
        throw CustomException("يجب وجود مستخدم على الأقل بصلاحيات مدير");
      }
    }

    await data.deleteData("DELETE FROM users WHERE id_user=${user.id}");
    await data
        .deleteData("DELETE FROM user_permissions WHERE user_id=${user.id}");
  }

  static Future<void> updateUser(User user) async {
    PosData data = PosData();
    try{
      String updatePassword = "";
      if (user.jobTitle != jopTitleData.first) {
        List<Map> response0 = await getUsersList(
            secondCondition:
            " NOT(id_user=${user.id})", searchText: jopTitleData.first, searchType: SearchTypes.jopTitle);
        if (response0.isEmpty) {
          throw CustomException("يجب وجود مستخدم على الأقل بصلاحيات مدير");
        }
      }

      await _checkUniqueFields(user);
      if (user.password != "") {
        updatePassword = ",password='${user.password}'";
      }
      int index = await getJopTitleId(user.jobTitle);
      List<int> permissions = user.getPermissions();
      String printName = reversArString(user.arName);
      await data.changeData(
          "UPDATE users SET Print_Name='$printName',ar_name='${user.arName}',en_name='${user.enName}',mobile='${user.phone}',email='${user.email}',jop_title=$index $updatePassword WHERE id_user=${user.id}");
      await data
          .deleteData("DELETE FROM user_permissions WHERE user_id=${user.id}");
      for (int id in permissions) {
        await data.insertData(
            "INSERT INTO user_permissions (user_id,permission_id)VALUES(${user.id},${id + 1})");
      }
    }
    catch(e){
      throw CustomException(e.toString());
    }
  }

  static Future<User> addMangerUser(
      {required String name, required String password}) async {
    User user = User(
        arName: name,
        printName: reversArString(name),
        password: password,
        jobTitle: jopTitleData.first);
    user.givePermission();
    await addUser(user: user);

    return await verifyUser(name, password);
  }

  static initialUserId() {
    return initialId("users",suffix: "_user");
  }
}
