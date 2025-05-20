import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:magicposbeta/bloc/shared_bloc/shared_bloc.dart";
import "package:magicposbeta/screens/screens.dart";
import "package:magicposbeta/templates/main_screens_template.dart";
import "package:magicposbeta/theme/locale/locale.dart";
import "../providers/depts_provider.dart";
import "package:provider/provider.dart";
import "../components/custom_button.dart";

class HomeScreen extends StatelessWidget {
  static const String route = "/home_screen";

  const HomeScreen({super.key});

  final double ratio = 2.24 / 100;
  static const platform = MethodChannel('IcodPrinter');

  @override
  Widget build(BuildContext context) {
    bool isPos =
        context.read<SharedCubit>().settings.screenType == RadiosNames.pos;
    return MainScreensTemplate(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 380,
                height: 380,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //client

                        CustomButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              PersonCard.clientRoute,
                            );
                          },
                          icon: Icons.supervisor_account,
                          engText: "Clients",
                          arText: "الزبائن",
                        ),
                        //suppliers
                        CustomButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              PersonCard.supplierRoute,
                            );
                          },
                          icon: Icons.group_add_rounded,
                          engText: "Suppliers",
                          arText: "الموردون",
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //users

                        CustomButton(
                          nullOnPressed: !context
                              .read<SharedCubit>()
                              .currentUser
                              .isManger(),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              UserCard.route,
                            );
                          },
                          icon: Icons.person,
                          engText: "Users",
                          arText: "المستخدمون",
                        ),
                        //manual

                        CustomButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              "/",
                            );
                          },
                          icon: Icons.menu_book_rounded,
                          engText: "Manual",
                          arText: "دليل الاستخدام",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //Point Of Sale

              Consumer<DeptsProvider>(
                builder: (context, value, child) => CustomButton(
                  fontSize: 34,
                  iconSize: 100,
                  width: 380,
                  height: 380,
                  onPressed: () async {
                    value.getDeptsList();
                    Navigator.of(context).pushNamed(
                      isPos ? PosScreen.route : ResturantScreen.route,
                    );
                  },
                  icon:
                      isPos ? Icons.screenshot_monitor : Icons.fastfood_rounded,
                  engText: isPos ? "POS" : "Resturant",
                  arText: isPos ? "نقطة البيع" : "المطعم",
                ),
              ),
              SizedBox(
                width: 380,
                height: 380,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 180,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //products
                          CustomButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                ProductCard.route,
                              );
                            },
                            icon: Icons.widgets,
                            engText: "Products",
                            arText: "المواد",
                          ),
                          //reports

                          CustomButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                ReportsNavigatorScreen.route,
                              );
                            },
                            icon: Icons.contact_page_outlined,
                            engText: "Reports",
                            arText: "التقارير",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 180,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // In/Out

                          CustomButton(
                            onPressed: () async {
                              Navigator.of(context).pushNamed(
                                InOutScreen.route,
                              );
                              await platform.invokeMethod("connect");
                            },
                            icon: Icons.compare_arrows_rounded,
                            engText: "Input/Output",
                            arText: "إدخال/إخراج",
                          ),
                          //settings
                          CustomButton(
                            nullOnPressed: !context
                                .read<SharedCubit>()
                                .currentUser
                                .isManger(),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                SettingsScreen.route,
                              );
                            },
                            icon: Icons.settings,
                            engText: "Settings",
                            arText: "الإعدادات",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, StartAppScreen.route, (value) => false);
                },
                child: const Text(
                  ButtonsNames.logOut,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
