import 'package:flutter/material.dart';

import '../modules/user.dart';



const List<String> reportsNamesData = [
  "clients",
  "suppliers",
  "departments",
  "groups",
  "products",
  "functions",
  "users",
  "cash",
  "dept",
  "inventory"
];

const List<String> keysNamesData = [
  "ca",
  "ch",
  "vi1",
  "vi2",
  "chk",
  "pd",
  "rc",
  "plus",
  "minus",
  "plus_per",
  "minus_per",
  "rf",
  "ac",
];
const List<String> permissionsData = [
  "change_price",
  "all_cancel",
  "RF",
  "plus",
  "plus_per",
  "minus",
  "minus_per",
  "add_supplier",
  "update_supplier",
  "delete_supplier",
  "add_client",
  "update_client",
  "delete_client",
  "add_product",
  "update_product",
  "delete_product",
  "add_department",
  "update_department",
  "delete_department",
  "add_group",
  "update_group",
  "delete_group",
  "clients",
  "suppliers",
  "departments",
  "groups",
  "products",
  "functions",
  "users",
  "cash",
  "dept",
  "inventory",
  "change_qty",
  "data",
  "print",
  "drawer",
  "dept_access",
  "visa1",
  "visa2",
  "ch",
  "chk",
  "rc",
  "pd",
  "in_product",
  "out_product"
];

const List productStates = [
  {"text": "نقص في المستودع", "color": Colors.redAccent},
  {"text": "ضمن الحد المطلوب", "color": Colors.green},
  {"text": "زيادة في المستودع", "color": Colors.yellowAccent},
  {"text": "", "color": Colors.white}
];

const List<String> jopTitleData = [
  "مدير",
  "محاسب",
  "كاشير",
  "كاشير إرجاع",
  "أمين مستودع",
];
const List<String> settingsPages = [
  "الطابعات",
  "الفاتورة",
  "مجموعات و أقسام",
  "عام",
];
const List<String> posScreenGroup = ["restaurant", "POS"];
const List<String> priceGroup = ["cost", "group", "piece"];
User currentUserss = User();
