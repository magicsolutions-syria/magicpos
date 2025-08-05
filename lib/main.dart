import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:magicposbeta/bloc/shared_bloc/shared_bloc.dart";
import "package:magicposbeta/screens/clients_card.dart";
import "package:magicposbeta/screens/in_out_screen.dart";
import "package:magicposbeta/screens/screens.dart";
import "package:magicposbeta/screens/start_app_screen.dart";
import "package:magicposbeta/screens/product_card.dart";
import "package:magicposbeta/screens/report_screens/depts_report_screen.dart";
import "package:magicposbeta/screens/report_screens/material_inventory.dart";
import "package:magicposbeta/screens/report_screens/users_report_screen.dart";
import "package:magicposbeta/screens/resturant_screen.dart";
import "package:magicposbeta/screens/settings_screen.dart";
import "package:magicposbeta/screens/user_card.dart";

import "providers/depts_provider.dart";
import "package:provider/provider.dart";

import "screens/person_card.dart";
import 'screens/report_screens/cash_report_screen.dart';
import 'screens/report_screens/clients_report_screen.dart';
import 'screens/report_screens/departments_report.dart';
import 'screens/report_screens/suppliers_report_screen.dart';
import 'screens/report_screens/functions_keys_report_screen.dart';
import 'screens/report_screens/products_report_screen.dart';
import 'screens/report_screens/group_report_screen.dart';
import "./screens/pos_screen.dart";

import "screens/reports_navigator_screen.dart";
import "theme/home_pages_profiles.dart";

void main() async {
  runApp(const MyApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return SharedCubit(() => InitialSharedState());
      },
      child: ChangeNotifierProvider(
        create: (context) => DeptsProvider(),
        child: MaterialApp(
          home: const StartAppScreen(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: Colors.blue,
              primaryColorDark: Colors.orange,
              scaffoldBackgroundColor: const Color(0xFFF6F6F6),
              dialogBackgroundColor: const Color(0xFFF6F6F6),
              disabledColor: const Color(0xFFE0E0E0),
              appBarTheme: const AppBarTheme(color: Colors.blue)),
          initialRoute: "/",
          routes: {
            PosScreen.route: (context) => const PosScreen(),
            SuppliersCard.route: (context) => const SuppliersCard(),
            ClientsCard.route: (context) => const ClientsCard(),
            ProductCard.route: (context) => const ProductCard(),
            InOutScreen.route: (context) => InOutScreen(),
            ReportsNavigatorScreen.route: (context) =>
                const ReportsNavigatorScreen(),
            ClientsReport.route: (context) => const ClientsReport(),
            SuppliersReport.route: (context) => const SuppliersReport(),
            DepartmentReport.route: (context) => const DepartmentReport(),
            GroupReport.route: (context) => const GroupReport(),
            ProductReport.route: (context) => const ProductReport(),
            CashReport.route: (context) => const CashReport(),
            FunctionsKeysReport.route: (context) => const FunctionsKeysReport(),
            UserCard.route: (context) => const UserCard(),
            SettingsScreen.route: (context) => SettingsScreen(),
            StartAppScreen.route: (context) => const StartAppScreen(),
            ResturantScreen.route: (context) => const ResturantScreen(),
            MaterialInventory.route: (context) => const MaterialInventory(),
            UsersReport.route: (context) => const UsersReport(),
            DeptsReport.route: (context) => const DeptsReport()
          },
        ),
      ),
    );
  }
}
