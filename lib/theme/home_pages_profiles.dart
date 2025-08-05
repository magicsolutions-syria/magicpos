import 'package:flutter/material.dart';
import 'package:magicposbeta/modules/page_profile.dart';
import 'package:magicposbeta/screens/screens.dart';

class HomePagesProfiles {
  static const PageProfile settings = PageProfile(
      arName: "الإعدادات",
      enName: "Settings",
      icon: Icons.settings,
      route: SettingsScreen.route);
  static const PageProfile products = PageProfile(
      arName: "المواد",
      enName: "Products",
      icon: Icons.widgets,
      route: ProductCard.route);
  static const PageProfile pos = PageProfile(
      arName: "نقطة البيع",
      enName: "POS",
      icon: Icons.screenshot_monitor,
      route: PosScreen.route);
  static const PageProfile restaurant = PageProfile(
      arName: "المطعم",
      enName: "Restaurant",
      icon: Icons.fastfood_rounded,
      route: ResturantScreen.route);
  static const PageProfile clients = PageProfile(
      arName: "الزبائن",
      enName: "Clients",
      icon: Icons.supervisor_account,
      route: ClientsCard.route);
  static const PageProfile suppliers = PageProfile(
      arName: "الموردون",
      enName: "Suppliers",
      icon: Icons.group_add_rounded,
      route: SuppliersCard.route);
  static const PageProfile users = PageProfile(
      arName: "المستخدمون",
      enName: "Users",
      icon: Icons.person,
      route: UserCard.route);
  static const PageProfile reports = PageProfile(
      arName: "التقارير",
      enName: "Reports",
      icon: Icons.contact_page_outlined,
      route: ReportsNavigatorScreen.route);
  static const PageProfile manual = PageProfile(
      arName: "دليل الاستخدام",
      enName: "Manual",
      icon: Icons.menu_book_rounded,
      route: "/");
  static const PageProfile inOut = PageProfile(
      arName: "إدخال/إخراج",
      enName: "Input/Output",
      icon: Icons.compare_arrows_rounded,
      route: InOutScreen.route);
}
