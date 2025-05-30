import 'package:flutter/material.dart';
import 'package:magicposbeta/components/general_text_field.dart';
import 'package:magicposbeta/components/my_dialog.dart';
import 'package:magicposbeta/components/operator_button.dart';
import 'package:magicposbeta/components/settings_title.dart';
import 'package:magicposbeta/theme/custom_colors.dart';
import 'package:magicposbeta/database/functions/groups_functions.dart';
import 'package:magicposbeta/lists/select_group_list.dart';
import 'package:magicposbeta/screens_data/constants.dart';
import 'package:magicposbeta/theme/locale/locale.dart';
import '../../complex_components/department_groups/department_update/department_update_widget.dart';
import '../../complex_components/department_groups/depts_settings/depts_setting_widget.dart';
import '../../lists/group_list/groups_list.dart';
import '../../lists/section_list/sections_list.dart';

class DepartmentsGroupsPage extends StatelessWidget {
  DepartmentsGroupsPage({super.key});

  final TextEditingController groupOld = TextEditingController();
  final TextEditingController groupNew = TextEditingController();
  final TextEditingController groupSectionOld = TextEditingController();
  final TextEditingController groupSectionNew = TextEditingController();
  @override
  Widget build(BuildContext context) {
    groupSectionOld.addListener(() {
      groupSectionNew.text = groupSectionOld.text;
    });

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
                      return SelectGroupList();
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
            SizedBox(
              height: 300,
              child: SizedBox(
                width: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OperatorButton(
                          text: "حفظ",
                          textColor: Colors.white,
                          onPressed: () {
                            MyDialog.showWarningOperatorDialog(
                                context: context,
                                isWarning: true,
                                title:
                                    "هل أنت متأكد أنك تريد تعديل المجموعة",
                                onTap: () async {
                                  try {
                                    Navigator.pop(context);

                                    await GroupsFunctions.updateGroup(
                                        oldName: groupOld.text,
                                        newName: groupNew.text,
                                        sectionOld: groupSectionOld.text,
                                        sectionNew: groupSectionNew.text);
                                    if (context.mounted) {
                                      MyDialog.showWarningDialog(
                                          context: context,
                                          isWarning: false,
                                          title: "تم تعديل المجموعة");
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      MyDialog.showWarningDialog(
                                          context: context,
                                          isWarning: true,
                                          title:
                                              e.toString().substring(11));
                                    }
                                  }
                                });
                          },
                          color: Theme.of(context).primaryColor,
                          enable: currentUserss.product.department.update,
                        ),
                        const SettingsTitle(title: "تعديل مجموعة")
                      ],
                    ),
                    GeneralTextField(
                      width: 350,
                      prefix: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => GroupsList(
                                    groupValue: groupOld.text,
                                    departmentValue: groupSectionOld.text,
                                    onDoubleTap: (
                                        {String? departmentValue,
                                        String? groupValue}) {
                                      groupOld.text = departmentValue ?? "";
                                      groupSectionOld.text =
                                          groupValue ?? "";
                                    },
                                  ));
                        },
                        icon: const Icon(Icons.list),
                        iconSize: 25,
                      ),
                      readOnly: true,
                      withSpacer: true,
                      title: " : الاسم القديم",
                      controller: groupOld,
                    ),
                    GeneralTextField(
                      width: 350,
                      withSpacer: true,
                      title: " : الاسم الجديد",
                      controller: groupNew,
                    ),
                    GeneralTextField(
                      width: 350,
                      prefix: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => SectionsList(
                                    value: groupSectionNew.text,
                                    onDoubleTap: (String value) {
                                      groupSectionNew.text = value;
                                    },
                                  ));
                        },
                        icon: const Icon(Icons.list),
                        iconSize: 25,
                      ),
                      readOnly: true,
                      withSpacer: true,
                      title: " : القسم",
                      controller: groupSectionNew,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
