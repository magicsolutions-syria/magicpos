import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:magicposbeta/bloc/shared_bloc/shared_bloc.dart";
import "package:magicposbeta/screens/screens.dart";
import "package:magicposbeta/templates/main_screens_template.dart";
import "package:magicposbeta/theme/locale/locale.dart";
import "package:magicposbeta/theme/pages_profiles.dart";
import "../components/custom_button.dart";

class HomeScreen extends StatelessWidget {
  static const String route = "/home_screen";

  const HomeScreen({super.key});

  final double ratio = 2.24 / 100;
  static const platform = MethodChannel('IcodPrinter');

  @override
  Widget build(BuildContext context) {
    bool isPos =
        context.read<SharedCubit>().settings.screenType == RadiosValues.pos;
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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //client

                        CustomButton(
                          profile: PagesProfiles.clients,
                        ),
                        //suppliers
                        CustomButton(
                          profile: PagesProfiles.suppliers,
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
                          profile: PagesProfiles.users,
                        ),
                        //manual

                        const CustomButton(
                          profile: PagesProfiles.manual,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //Point Of Sale

              CustomButton(
                fontSize: 34,
                iconSize: 100,
                width: 380,
                height: 380,
                profile: isPos ? PagesProfiles.pos : PagesProfiles.restaurant,
              ),
              SizedBox(
                width: 380,
                height: 380,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      height: 180,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //products
                          CustomButton(
                            profile: PagesProfiles.products,
                          ),
                          //reports

                          CustomButton(
                            profile: PagesProfiles.reports,
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

                          const CustomButton(
                            profile: PagesProfiles.inOut,
                          ),
                          //settings
                          CustomButton(
                              nullOnPressed: !context
                                  .read<SharedCubit>()
                                  .currentUser
                                  .isManger(),
                              profile: PagesProfiles.settings),
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
// finish refactor
