import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:magicposbeta/components/custom_drop_down_menu.dart';
import 'package:magicposbeta/theme/custom_colors.dart';
import 'package:magicposbeta/database/functions/groups_functions.dart';
import 'package:magicposbeta/database/functions/sections_functions.dart';
import 'package:magicposbeta/database/initialize_database.dart';
import 'package:magicposbeta/modules/custom_exception.dart';
import 'package:provider/provider.dart';

import '../../../components/bottom_button.dart';
import '../../../components/my_dialog.dart';
import '../modules/pair.dart';

int n = 1;
List<int> groups = [];

class ChoicesList extends StatefulWidget {
  final void Function(List, List) func;
  final TextEditingController controller;
  final Function notify;
  const ChoicesList({
    super.key,
    required this.func,
    required this.controller,
    required this.notify,
  });

  @override
  State<ChoicesList> createState() => _ChoicesListState();
}

class _ChoicesListState extends State<ChoicesList> {
  final FocusNode _node = FocusNode();

  Model provider = Model();
  late List<Map> departmentsList;
  Future<List<Map>> getDepartmentsList() async {
    PosData db = PosData();
    departmentsList = await db.readData("SELECT * FROM departments");
    List<Map> res = await SectionsFunctions.getDepartmentList('');
    return res;
  }

  late List<Map> groupsList;
  Future<List<Map>> getGroupsList(
      String departmentName, int departmentId) async {
    /*PosData db = PosData();
    groupsList = await db.readData("SELECT * FROM 'groups'");
   *//* List<Map> res = await GroupsFunctions.getGroupsList(
        groupName: '',
        departmentName: departmentName,
        departmentId: departmentId);*//*
    return res;*/
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _node.unfocus();
      },
      child: ChangeNotifierProvider(
        create: (BuildContext context) {
          return provider;
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: KeyboardListener(
              focusNode: _node,
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 300,
                child: SizedBox(
                  width: 462,
                  height: 550,
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 30, right: 15, left: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomDropDownMenu(
                              title: "  اختيار الوحدة",
                              data: const [
                                "الوحدة الأولى",
                                "الوحدة الثانية",
                                "الوحدة الثالثة"
                              ],
                              controller: widget.controller,
                              width: 140,
                              fontSize: 14, notify: (){}, onChanged: (String value) {  },
                            ),
                            const SizedBox(
                              width: 55,
                            ),
                            const Center(
                                child: Text(
                              "تحديد الكل",
                              style: TextStyle(fontSize: 20),
                            )),
                            const SizedBox(
                              width: 5,
                            ),
                            Consumer<Model>(
                              builder: (BuildContext context, provider,
                                  Widget? child) {
                                return IconButton(
                                    onPressed: () {
                                      provider.onPressedSelectAll();
                                    },
                                    icon: Icon(provider.selectedAll
                                        ? Icons.check_box_outlined
                                        : Icons.check_box_outline_blank));
                              },
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: FutureBuilder(
                          future: getDepartmentsList(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Map>> departmentSnapshot) {
                            if (departmentSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (departmentSnapshot.connectionState ==
                                ConnectionState.done) {
                              n = departmentSnapshot.data!.length;
                              ScrollController controller = ScrollController();

                              provider.checkDepartment = List.generate(
                                  departmentSnapshot.data!.length,
                                  (index) => Pair(
                                      true,
                                      departmentSnapshot.data![index]
                                          ["id_department"]));
                              return Scrollbar(
                                controller: controller,
                                thickness: 8,
                                thumbVisibility: true,
                                interactive: true,
                                child: ListView.builder(
                                    controller: controller,
                                    itemCount: departmentSnapshot.hasData
                                        ? departmentSnapshot.data?.length
                                        : 5,
                                    itemBuilder: (context, departmentIndex) {
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  departmentSnapshot.data?[
                                                          departmentIndex]
                                                      ["section_name"],
                                                  style: const TextStyle(
                                                      fontSize: 20),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Consumer<Model>(
                                                  builder:
                                                      (BuildContext context,
                                                          provider,
                                                          Widget? child) {
                                                    return IconButton(
                                                        onPressed: () {
                                                          provider.onPressedCheckDepartmentBox(
                                                              departmentIndex,
                                                              departmentSnapshot
                                                                          .data![
                                                                      departmentIndex]
                                                                  [
                                                                  "id_department"]);
                                                        },
                                                        icon: Icon(provider
                                                                .checkDepartment[
                                                                    departmentIndex]
                                                                .first
                                                            ? Icons
                                                                .check_box_outlined
                                                            : Icons
                                                                .check_box_outline_blank));
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          FutureBuilder(
                                              future: Future(()=>[]),
                                              builder: (BuildContext context,
                                                  groupSnapshot) {
                                                if (groupSnapshot
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }
                                                if (groupSnapshot
                                                        .connectionState ==
                                                    ConnectionState.done) {
                                                  print(
                                                      "groupsNum : ${groupSnapshot.data!.length}");
                                                  print(provider
                                                          .checkGroup.length <
                                                      departmentSnapshot
                                                          .data!.length);
                                                  if (provider
                                                          .checkGroup.length <
                                                      departmentSnapshot
                                                          .data!.length) {
                                                    print(
                                                        "=============================================");
                                                    provider.checkGroup.add(
                                                        List.generate(
                                                            groupSnapshot
                                                                .data!.length,
                                                            (index) {
                                                      print(groupSnapshot
                                                              .data![index]
                                                          ['id_group']);
                                                      return Pair(
                                                          true,
                                                          groupSnapshot
                                                                  .data![index]
                                                              ['id_group']);
                                                    }));
                                                    groups.add(groupSnapshot
                                                        .data!.length);
                                                    provider.checkGroupCounters
                                                        .add(groupSnapshot
                                                            .data!.length);
                                                  }

                                                  return SizedBox(
                                                    height: min(
                                                        groupSnapshot
                                                                .data!.length *
                                                            50,
                                                        200),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 18.0),
                                                      child: ListView.builder(
                                                          itemCount:
                                                              groupSnapshot
                                                                  .data?.length,
                                                          itemBuilder: (context,
                                                              groupIndex) {
                                                            return Column(
                                                              children: [
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        groupSnapshot.data?[groupIndex]
                                                                            [
                                                                            "group_name"],
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                20),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Consumer<
                                                                          Model>(
                                                                        builder: (BuildContext
                                                                                context,
                                                                            provider,
                                                                            Widget?
                                                                                child) {
                                                                          return IconButton(
                                                                              onPressed: () {
                                                                                provider.onPressedCheckGroupBox(departmentIndex, groupIndex, groupSnapshot.data![groupIndex]["id_group"]);
                                                                              },
                                                                              icon: Icon(provider.checkGroup[departmentIndex][groupIndex].first ? Icons.check_box_outlined : Icons.check_box_outline_blank));
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const Divider(
                                                                  height: 1,
                                                                  thickness:
                                                                      0.5,
                                                                )
                                                              ],
                                                            );
                                                          }),
                                                    ),
                                                  );
                                                }
                                                return Container();
                                              })
                                        ],
                                      );
                                    }),
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: 462,
                          height: 40,
                          child: Row(
                            children: [
                              Consumer<Model>(
                                builder: (BuildContext context, provider,
                                    Widget? child) {
                                  return BottomButton(
                                    title: "موافق",
                                    leftRadius: 12,
                                    color: Theme.of(context).primaryColor,
                                    onTap: () {
                                      List groupsIds = [];
                                      List departmentsIds = [];
                                      if (!provider.selectedAll) {
                                        for (int i = 0;
                                            i < provider.checkDepartment.length;
                                            i++) {
                                          if (provider
                                              .checkDepartment[i].first) {
                                            departmentsIds.add(provider
                                                .checkDepartment[i].second);
                                          } else {
                                            for (int j = 0;
                                                j <
                                                    provider
                                                        .checkGroup[i].length;
                                                j++) {
                                              if (provider
                                                  .checkGroup[i][j].first) {
                                                groupsIds.add(provider
                                                    .checkGroup[i][j].second);
                                              }
                                            }
                                          }
                                        }
                                      } else {
                                        departmentsIds = [-1];
                                        groupsIds = [-1];
                                      }
                                      print(departmentsIds);
                                      print(groupsIds);
                                      try {
                                        if (departmentsIds.isEmpty &&
                                            groupsIds.isEmpty) {
                                          throw CustomException(
                                              "يجب تحديد مجموعة واحدة او قسم واحد على الاقل");
                                        }
                                        widget.func(groupsIds, departmentsIds);
                                        Navigator.of(context).pop();
                                        widget.notify();
                                      } catch (e) {
                                        MyDialog.showAnimateWrongDialog(
                                            context: context,
                                            title: e.toString());
                                      }
                                    },
                                    width: 462,
                                  );
                                },
                              ),
                              BottomButton(
                                rightRadius: 12,
                                title: "إلغاء",
                                color: Theme.of(context).cancelButtonColor,
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                width: 462,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Model extends ChangeNotifier {
  bool selectedAll = true;
  List<Pair<bool, int>> checkDepartment = [];
  List<List<Pair<bool, int>>> checkGroup = [];
  int checkDepartmentCounter = n;
  List<int> checkGroupCounters = [];

  void onPressedSelectAll() {
    selectedAll = !selectedAll;

    checkDepartment = List.generate(checkDepartment.length,
        (index) => Pair<bool, int>(selectedAll, checkDepartment[index].second));

    for (int i = 0; i < checkGroup.length; i++) {
      for (int j = 0; j < checkGroup[i].length; j++) {
        checkGroup[i][j].first = selectedAll;
      }
    }
    checkGroupCounters = selectedAll
        ? List.generate(groups.length, (index) => groups[index])
        : List.filled(checkGroupCounters.length, 0);
    checkDepartmentCounter = selectedAll ? n : 0;

    notifyListeners();
  }

  void onPressedCheckDepartmentBox(int departmentIndex, int departmentId) {
    checkDepartment[departmentIndex].first =
        !checkDepartment[departmentIndex].first;

    checkDepartmentCounter += checkDepartment[departmentIndex].first ? 1 : -1;
    checkDepartment[departmentIndex].second = departmentId;

    for (int i = 0; i < checkGroup[departmentIndex].length; i++) {
      checkGroup[departmentIndex][i].first =
          checkDepartment[departmentIndex].first;
    }
    checkGroupCounters[departmentIndex] =
        checkDepartment[departmentIndex].first ? groups[departmentIndex] : 0;

    selectedAll = checkDepartmentCounter == n;

    notifyListeners();
  }

  void onPressedCheckGroupBox(
      int departmentIndex, int groupIndex, int groupId) {
    bool temp = checkDepartment[departmentIndex].first;
    checkGroup[departmentIndex][groupIndex].first =
        !checkGroup[departmentIndex][groupIndex].first;
    checkGroup[departmentIndex][groupIndex].second = groupId;

    checkGroupCounters[departmentIndex] +=
        checkGroup[departmentIndex][groupIndex].first ? 1 : -1;
    checkDepartment[departmentIndex].first =
        checkGroupCounters[departmentIndex] == groups[departmentIndex];
    if (temp ^ checkDepartment[departmentIndex].first) {
      checkDepartmentCounter += checkDepartment[departmentIndex].first ? 1 : -1;
    }
    selectedAll = checkDepartmentCounter == n;
    notifyListeners();
  }
}

void check(List l1, List l2) {
  if (l1.isEmpty && l2.isEmpty) {
    throw CustomException("fsdf");
  }
}
