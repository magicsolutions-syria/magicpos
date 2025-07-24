import 'package:flutter/material.dart';
import 'package:magicposbeta/modules/page_profile.dart';
import 'package:magicposbeta/theme/custom_colors.dart';
import 'package:magicposbeta/theme/reports_pages_profiles.dart';

import '../components/custom_button.dart';

import 'package:flutter/services.dart';

import 'home_screen.dart';

void disconnect(MethodChannel platform) async {
  try {
    await platform.invokeMethod("disconnect");
  } catch (e) {
    print("disconnect error");
  }
}

class ReportsNavigatorScreen extends StatefulWidget {
  static const String route = "${HomeScreen.route}/reports_screen";

  const ReportsNavigatorScreen({super.key});

  @override
  State<ReportsNavigatorScreen> createState() => _ReportsNavigatorScreenState();
}

class _ReportsNavigatorScreenState extends State<ReportsNavigatorScreen> {
  static const platform = MethodChannel('IcodPrinter');
  final double ratio = 2.24 / 100;

  final List<PageProfile> firstRow =
      ReportsPagesProfiles.allProfiles.sublist(0, 5);

  final List<PageProfile> secondRow =
      ReportsPagesProfiles.allProfiles.sublist(5);

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    try {
      platform.invokeMethod("connect");
    } catch (e) {
      print("connect error");
    }
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();
    try {
      await platform.invokeMethod("disconnect");
    } catch (e) {
      print("disconnect error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
          margin: EdgeInsets.all(ratio * MediaQuery.of(context).size.width),
          padding: EdgeInsets.only(
            left: 0.5 * (ratio + 0.015) * MediaQuery.of(context).size.width,
            right: 0.5 * (ratio + 0.015) * MediaQuery.of(context).size.width,
            bottom: ratio * MediaQuery.of(context).size.width,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: Theme.of(context).scaffoldBackgroundColor, width: 0),
            borderRadius: BorderRadius.circular(
              ratio * MediaQuery.of(context).size.width,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 500,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                        Container(
                          width: 500,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 500,
                          height: 200,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(85),
                            ),
                          ),
                        ),
                        Container(
                          width: 253.7,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(200),
                              bottomRight: Radius.circular(200),
                            ),
                            border: Border.all(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                width: 0.0001),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.account_circle_outlined,
                                size: 90,
                                color: Colors.blue,
                              ),
                              Text(
                                "report",
                                style: TextStyle(
                                  fontSize: 34,
                                  color: Theme.of(context).iconsTextsColors,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 500,
                          height: 200,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(85),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: firstRow
                      .map(
                        (e) => CustomButton(
                          width: (1.08 * ratio + 0.045) *
                              MediaQuery.of(context).size.width,
                          height: (2.1 * ratio) *
                              MediaQuery.of(context).size.height,
                          profile: e,
                        ),
                      )
                      .toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: secondRow
                      .map(
                        (e) => CustomButton(
                          width: (1.08 * ratio + 0.045) *
                              MediaQuery.of(context).size.width,
                          height: (2.1 * ratio) *
                              MediaQuery.of(context).size.height,
                          profile: e,
                        ),
                      )
                      .toList(),
                )
              ],
            ),
          )),
    ));
  }
}
