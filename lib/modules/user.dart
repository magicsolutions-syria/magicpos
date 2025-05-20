import 'package:equatable/equatable.dart';
import 'package:magicposbeta/database/users_functions.dart';
import 'package:magicposbeta/modules/users_library/permissions_classes/client_permission.dart';
import 'package:magicposbeta/modules/users_library/permissions_classes/supplier_permission.dart';
import 'package:magicposbeta/screens_data/constants.dart';

import 'users_library/permissions_classes/operation_key_permission.dart';
import 'users_library/permissions_classes/pay_key_permission.dart';
import 'users_library/permissions_classes/product_permission.dart';
import 'users_library/permissions_classes/reports_permission.dart';
import 'users_library/permissions_classes/total_product_perrmission.dart';

class User implements Equatable {
  int id;
  String arName = "";
  String enName = "";
  String password = "";
  String jobTitle = "";
  String email = "";
  String phone = "";
  String printName = "";
  TotalProductPermission product = TotalProductPermission();
  ClientPermission clients = ClientPermission();
  SupplierPermission suppliers = SupplierPermission();
  OperationKeysPermission operationKeys = OperationKeysPermission();
  PayKeyPermission payKeys = PayKeyPermission();
  ReportsPermission reports = ReportsPermission();

  User(
      {this.id = -1,
      this.arName = "",
      this.enName = "",
      this.password = "",
      this.phone = "",
      this.jobTitle = "",
      this.email = "",
      this.printName = "",
      TotalProductPermission? product,
      ClientPermission? clients,
      OperationKeysPermission? operationKeys,
      PayKeyPermission? payKeys,
      ReportsPermission? reports,
      SupplierPermission? suppliers}) {
    this.payKeys = payKeys ?? PayKeyPermission();
    this.operationKeys = operationKeys ?? OperationKeysPermission();
    this.reports = reports ?? ReportsPermission();
    this.product = product ?? TotalProductPermission();
    this.clients = clients ?? ClientPermission();
    this.suppliers = suppliers ?? SupplierPermission();
  }

  static Future<User> instanceFromMap(Map map) async {
    Map<String, dynamic> item =
        await UsersFunctions.getUserPermissions(map["id_user"]);
    print(item["products"]);
    return User(
      id: map["id_user"],
      arName: map["ar_name"],
      enName: map["en_name"],
      password: map["password"],
      phone: map["mobile"],
      email: map["email"],
      jobTitle: map["jop_title_name"],
      product: item["products"],
      clients: item["clients"],
      suppliers: item["suppliers"],
      payKeys: item["payKeys"],
      operationKeys: item["operationKeys"],
      reports: item["reports"],
      printName: map["Print_Name"],
    );
  }

  List<int> getPermissions() {
    return product.getPermissions() +
        clients.getPermissions() +
        suppliers.getPermissions() +
        payKeys.getPermissions() +
        operationKeys.getPermissions() +
        reports.getPermissions();
  }

  void givePermission({String? job}) {
    String text = job ?? jobTitle;
    switch (text) {
      case "مدير":
        {
          reports.tickAllTrue();
          payKeys.tickAllTrue();
          operationKeys.tickAllTrue();
          suppliers.tickAllTrue();
          clients.tickAllTrue();
          product.tickAllTrue();

          break;
        }
      case "محاسب":
        {
          reports.tickAllTrue();
          payKeys.tickAllFalse();
          operationKeys.tickAllFalse();
          suppliers.tickAllFalse();
          clients.tickAllFalse();
          product.tickAllFalse();
          break;
        }
      case "كاشير":
        {
          payKeys.tickAllTrue();
          operationKeys.tickAllTrue();
          suppliers.tickAllFalse();
          clients.tickAllFalse();
          product.tickAllFalse();
          reports.tickAllFalse();
          operationKeys.RF = false;
          operationKeys.allCancel = false;
          break;
        }
      case "كاشير إرجاع":
        {
          payKeys.tickAllTrue();
          operationKeys.tickAllTrue();
          suppliers.tickAllFalse();
          clients.tickAllFalse();
          product.tickAllFalse();
          reports.tickAllFalse();
          break;
        }
      case "أمين مستودع":
        {
          product.tickAllTrue();
          payKeys.tickAllFalse();
          operationKeys.tickAllFalse();
          suppliers.tickAllFalse();
          clients.tickAllFalse();
          reports.tickAllFalse();
          break;
        }
      default:
        {
          break;
        }
    }
  }

  bool isManger() {
    return jobTitle == jopTitleData.first;
  }

  static User emptyInstance() {
    return User();
  }

  @override
  List<Object?> get props => [
        arName,
        enName,
        email,
        password,
        jobTitle,
        phone,
        payKeys,
        product,
        reports,
        operationKeys,
        suppliers,
        clients
      ];

  @override
  bool? get stringify => true;
}
