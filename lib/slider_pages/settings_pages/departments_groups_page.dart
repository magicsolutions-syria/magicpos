import 'package:flutter/material.dart';
import 'package:magicposbeta/complex_components/department_groups/group_update/group_update_widget.dart';
import 'package:magicposbeta/components/operator_button.dart';
import 'package:magicposbeta/components/settings_title.dart';
import 'package:magicposbeta/theme/custom_colors.dart';
import 'package:magicposbeta/theme/locale/locale.dart';
import '../../complex_components/department_groups/department_update/department_update_widget.dart';
import '../../complex_components/department_groups/depts_settings/depts_setting_widget.dart';
import '../../lists/group_view_list/group_view_list.dart';

class DepartmentsGroupsPage extends StatelessWidget {
  const DepartmentsGroupsPage({super.key});


  @override
  Widget build(BuildContext context) {


    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(
          height: 135,
          child:DeptsSettingWidget(),
        ),
        const Divider(
          height: 0,
          thickness: 4,
        ),
        Row(
          children: [
            OperatorButton(
              width: 300,
              color: Theme.of(context).selectedColor,
              text:SettingsNames.chooseGroupsToView,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return GroupViewList();
                    });
              },
              enable: true,
            ),
            const Spacer(),
            const SettingsTitle(title:SettingsNames.groupsToView),
          ],
        ),
        const Divider(
          height: 0,
          thickness: 4,
        ),
        Row(
          children: [
            const SizedBox(
              height: 300,
              child:DepartmentUpdateWidget(),
            ),
            const Spacer(),
            Container(
              height: 250,
              width: 4,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            const Spacer(),
            const SizedBox(
              height: 300,
              width: 500,

              child:GroupUpdateWidget(),
            ),
          ],
        ),
      ],
    );
  }
}
