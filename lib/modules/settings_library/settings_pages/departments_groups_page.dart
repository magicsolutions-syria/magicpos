import 'package:flutter/material.dart';
import 'package:magicposbeta/components/general_text_field.dart';
import 'package:magicposbeta/components/my_dialog.dart';
import 'package:magicposbeta/components/operator_button.dart';
import 'package:magicposbeta/components/settings_title.dart';
import 'package:magicposbeta/components/small_hint_text.dart';
import 'package:magicposbeta/theme/custom_colors.dart';
import 'package:magicposbeta/database/depts_functions.dart';
import 'package:magicposbeta/database/functions/groups_functions.dart';
import 'package:magicposbeta/database/functions/sections_functions.dart';
import 'package:magicposbeta/modules/product_library/lists/group_list/groups_list.dart';
import 'package:magicposbeta/modules/product_library/lists/section_list/sections_list.dart';
import 'package:magicposbeta/modules/settings_library/lists/select_group_list.dart';
import 'package:magicposbeta/screens_data/constants.dart';

import '../../../components/choose_number_field.dart';

class DepartmentsGroupsPage extends StatelessWidget {
  DepartmentsGroupsPage({super.key});

  final TextEditingController deptNumber = TextEditingController(text: "01");
  final TextEditingController deptName = TextEditingController();
  final TextEditingController deptSection = TextEditingController();

  final TextEditingController groupOld = TextEditingController();
  final TextEditingController groupNew = TextEditingController();
  final TextEditingController groupSectionOld = TextEditingController();
  final TextEditingController groupSectionNew = TextEditingController();
  final TextEditingController departmentOld = TextEditingController();
  final TextEditingController departmentNew = TextEditingController();

  @override
  Widget build(BuildContext context) {
    deptNumber.addListener(() async {
      List<Map> response =
          await DeptsFunctions.getDept(int.parse(deptNumber.text));
      deptName.text = response[0]["desc"];
      deptSection.text = response[0]["section_name"];
    });
    groupSectionOld.addListener(() {
      groupSectionNew.text = groupSectionOld.text;
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 135,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  OperatorButton(
                    onPressed: () async {
                      try {
                        await DeptsFunctions.deptUpdate(
                            id: int.parse(deptNumber.text).toString(),
                            name: deptName.text,
                            section: deptSection.text);
                        if (context.mounted) {
                          MyDialog.showWarningDialog(
                              context: context,
                              isWarning: false,
                              title: "تم حفظ إعدادات زر القسم");
                        }
                      } catch (e) {
                        if (context.mounted) {
                          MyDialog.showWarningDialog(
                            context: context,
                            isWarning: true,
                            title: e.toString().substring(11),
                          );
                        }
                      }
                    },
                    text: "حفظ",
                    color: Theme.of(context).primaryColor,
                    enable: true,
                    textColor: Colors.white,
                  ),
                  const Spacer(),
                  const SmallHintText(title: "(اختر رقماً بين 1-16)"),
                  const SizedBox(
                    width: 10,
                  ),
                  ChooseNumberField(
                    controller: deptNumber,
                    maxNumber: 16,
                    title: ' : رقم زر القسم',
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GeneralTextField(
                    width: 350,
                    prefix: IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => SectionsList(
                                  value: deptSection.text,
                                  onDoubleTap: (String value) {
                                    deptSection.text = value;
                                  },
                                ));
                      },
                      icon: const Icon(Icons.list),
                      iconSize: 25,
                    ),
                    readOnly: true,
                    title: " : الربط مع القسم",
                    controller: deptSection,
                  ),
                  const Spacer(),
                  GeneralTextField(
                    width: 350,
                    title: " : الاسم",
                    controller: deptName,
                  ),
                ],
              ),
            ],
          ),
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
              text: "اختيار مجموعات العرض",
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
            const SettingsTitle(title: "مجموعات العرض"),
          ],
        ),
        const Divider(
          height: 0,
          thickness: 4,
        ),
        Row(
          children: [
            SizedBox(
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 500,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OperatorButton(
                          text: "حفظ",
                          textColor: Colors.white,
                          onPressed: () {
                            MyDialog.showWarningOperatorDialog(
                                context: context,
                                isWarning: true,
                                title: "هل أنت متأكد أنك تريد تعديل القسم",
                                onTap: () async {
                                  try {
                                    await SectionsFunctions
                                        .updateDepartmentName(
                                            oldName: departmentOld.text,
                                            newName: departmentNew.text);
                                    if (context.mounted) {
                                      MyDialog.showWarningDialog(
                                          context: context,
                                          isWarning: false,
                                          title: "تم تعديل القسم");
                                    }

                                    if (groupSectionNew.text ==
                                        departmentOld.text) {
                                      groupSectionNew.text = departmentNew.text;
                                    }
                                    if (deptSection.text ==
                                        departmentOld.text) {
                                      deptSection.text = departmentNew.text;
                                    }
                                    departmentOld.text = "";
                                  } catch (e) {
                                    if (context.mounted) {
                                      MyDialog.showWarningDialog(
                                          context: context,
                                          isWarning: true,
                                          title: e.toString().substring(11));
                                    }
                                  }
                                });
                          },
                          color: Theme.of(context).primaryColor,
                          enable: currentUserss.product.department.update,
                        ),
                        const SettingsTitle(title: "تعديل قسم")
                      ],
                    ),
                  ),
                  GeneralTextField(
                    width: 350,
                    prefix: IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => SectionsList(
                                  value: departmentOld.text,
                                  onDoubleTap: (String value) {
                                    departmentOld.text = value;
                                  },
                                ));
                      },
                      icon: const Icon(Icons.list),
                      iconSize: 25,
                    ),
                    readOnly: true,
                    title: " : الاسم القديم",
                    controller: departmentOld,
                  ),
                  GeneralTextField(
                    width: 350,
                    title: " : الاسم الجديد",
                    controller: departmentNew,
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                ],
              ),
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
                                title: "هل أنت متأكد أنك تريد تعديل المجموعة",
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
                                    departmentOld.text = "";
                                  } catch (e) {
                                    if (context.mounted) {
                                      MyDialog.showWarningDialog(
                                          context: context,
                                          isWarning: true,
                                          title: e.toString().substring(11));
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
                                      groupSectionOld.text = groupValue ?? "";
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
                                   value: groupSectionNew.text, onDoubleTap: (String value) { groupSectionNew.text=value; },));
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
