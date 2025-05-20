import 'dart:async';

import 'package:flutter/material.dart';
import 'package:magicposbeta/theme/custom_colors.dart';
import 'package:magicposbeta/modules/settings_library/settings_pages/bill_page.dart';
import 'package:magicposbeta/modules/settings_library/settings_pages/printers_page.dart';

import '../components/list_view_button.dart';
import '../components/waiting_widget.dart';
import '../modules/settings_library/settings_pages/departments_groups_page.dart';
import '../modules/settings_library/settings_pages/general_settings_page.dart';
import '../screens_data/constants.dart';

class SettingsScreen extends StatelessWidget {
  static const String route = "/settings_screen";

  SettingsScreen({super.key});
  final FocusNode _node = FocusNode();
  final PageController _pageController = PageController(initialPage: 3);
  final StreamController streamPageController = StreamController();

  @override
  Widget build(BuildContext context) {
    _pageController.addListener(() {
      streamPageController.add(_pageController.page!.round());
    });
    return GestureDetector(
      onTap: () async {
        _node.unfocus();
      },
      child: KeyboardListener(
        focusNode: _node,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              height: 690,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.6),
                  border: Border.all(width: 1),
                  color: Theme.of(context).fieldsColor),
              child: StreamBuilder(
                  initialData: 3,
                  stream: streamPageController.stream,
                  builder: (context, snapshot) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 640,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 80, left: 80, top: 40, bottom: 20),
                            child: PageView(
                                controller: _pageController,
                                children: [
                                  const PrintersPage(),
                                  BillPage(),
                                  DepartmentsGroupsPage(),
                                  const GeneralSettingsPage(),
                                ]),
                          ),
                        ),
                        const Divider(
                          height: 0,
                        ),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: settingsPages.length,
                            itemBuilder: (context, index) {
                              return ListViewButton(
                                currentIndex: snapshot.data,
                                buttonIndex: index,
                                title: settingsPages[index],
                                controller: _pageController,
                                length: settingsPages.length,
                                radius: 30.6,
                                totalWidth: 1342, onPressed: () {  },
                              );
                            },
                          ),
                        )
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
