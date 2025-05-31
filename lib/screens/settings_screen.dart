import 'package:flutter/material.dart';
import '../complex_components/page_slider/page_slider_widget.dart';
import '../slider_pages/settings_pages/settings_pages.dart';
import '../theme/locale/slider_pages_names.dart';

class SettingsScreen extends StatelessWidget {
  static const String route = "/settings_screen";

  SettingsScreen({super.key});

  final FocusNode _node = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        _node.unfocus();
      },
      child: KeyboardListener(
        focusNode: _node,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: PageSliderWidget(
                pagesData: Map.fromIterables(
                  [
                    SliderPagesNames.printers,
                    SliderPagesNames.bill,
                    SliderPagesNames.groupsDepartments,
                    SliderPagesNames.general
                  ],
                  List.generate(
                    4,
                    (i) => Padding(
                      padding: const EdgeInsets.all(20),
                      child: [
                        const PrintersPage(),
                        BillPage(),
                        const DepartmentsGroupsPage(),
                        const GeneralSettingsPage()
                      ].elementAt(i),
                    ),
                  ),
                ),
                width: 1342,
                height: 720,
                inHeight: 660,
                inWidth: 1342,
                buttonsWidth: 1340,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// finish refactor
