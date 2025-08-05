import 'package:flutter/material.dart';
import 'package:magicposbeta/modules/page_profile.dart';
import 'package:magicposbeta/screens/report_screens/reports_screens.dart';

class ReportsPagesProfiles {
  static const PageProfile inventory = PageProfile(
      arName:  "جرد المواد",
      enName: "Material inventory",
      icon: Icons.store,
      route: MaterialInventory.route);
  static const PageProfile products = PageProfile(
      arName:  "تقرير المواد",
      enName: "products report",
      icon: Icons.widgets,
      route: ProductReport.route);
  static const PageProfile depts = PageProfile(
      arName:  "تقرير حركة ال dept",
      enName:  "depts report",
      icon:Icons.add_shopping_cart,
      route: DeptsReport.route);
  static const PageProfile functionsKeys = PageProfile(
      arName: "تقرير حركة الازرار",
      enName:  "function keys report",
      icon: Icons.keyboard_alt_outlined,
      route: FunctionsKeysReport.route);
  static const PageProfile clients = PageProfile(
      arName: "تقرير الزبائن",
      enName: "customer report",
      icon: Icons.supervisor_account,
      route: ClientsReport.route);
  static const PageProfile suppliers = PageProfile(
      arName: "تقرير الموردين",
      enName:"suppliers report",
      icon: Icons.group_add_rounded,
      route: SuppliersReport.route);
  static const PageProfile users = PageProfile(
      arName:  "تقرير حركة المستخدمين",
      enName:"users report",
      icon: Icons.person,
      route: UsersReport.route);
  static const PageProfile departments = PageProfile(
      arName: "تقرير الاقسام",
      enName: "departments report",
      icon: Icons.shopping_cart,
      route: DepartmentReport.route);
  static const PageProfile groups = PageProfile(
      arName:  "تقرير المجموعات",
      enName:"groups report",
      icon: Icons.shopping_bag,
      route: GroupReport.route);
  static const PageProfile cash = PageProfile(
      arName:"تقرير حركة الكاش",
      enName: "cash report",
      icon: Icons.money_rounded,
      route: CashReport.route);
  static const List<PageProfile>allProfiles=[products,groups,departments,depts,inventory,users,suppliers,clients,functionsKeys,cash];
}







