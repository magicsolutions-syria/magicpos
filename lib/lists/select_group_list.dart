import 'dart:async';

import 'package:flutter/material.dart';
import 'package:magicposbeta/components/bottom_button.dart';
import 'package:magicposbeta/components/choises_list.dart';
import 'package:magicposbeta/components/my_dialog.dart';
import 'package:magicposbeta/components/not_availble_widget.dart';
import 'package:magicposbeta/components/operator_button.dart';
import 'package:magicposbeta/components/waiting_widget.dart';
import 'package:magicposbeta/theme/custom_colors.dart';
import 'package:magicposbeta/database/functions/groups_functions.dart';
import 'package:magicposbeta/database/functions/sections_functions.dart';
import 'package:magicposbeta/database/initialize_database.dart';

class SelectGroupList extends StatelessWidget {
  final int pivot;
  final String departmentField;
  final String groupField;
  final int defaultValue;
  SelectGroupList({super.key,this.pivot=1,  this.departmentField = "selected_department",  this.groupField = "selected_group",  this.defaultValue = 0});

  final FocusNode _node = FocusNode();
  List<int> selectedDepartments = [];
  Map<int, List<int>> selectedGroups = {};

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _node.unfocus();
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
                height: 622,
                child: Column(
                  children: [
                    SizedBox(
                      height: 572,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: FutureBuilder(
                            future: SectionsFunctions.getDepartmentList("",printerCondition: defaultValue==-1?"printer_id=-1 OR printer_id=$pivot":""),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const WaitingWidget();
                              } else if (!snapshot.hasData ||
                                  snapshot.data == null) {
                                return const NotAvailableWidget();
                              } else {
                                print(defaultValue);
                                return ListView.separated(
                                    itemBuilder: (context, index) {
                                      snapshot.data![index]
                                                  [departmentField] ==
                                              pivot
                                          ? selectedDepartments.add(snapshot
                                              .data![index]["id_department"])
                                          : null;
                                      selectedGroups.addAll({
                                        snapshot.data![index]["id_department"]:
                                            []
                                      });

                                      return FutureBuilder(
                                          future: GroupsFunctions.getGroupsList(
                                              departmentId:
                                                  snapshot.data![index]
                                                      ["id_department"],
                                              departmentName: "",
                                              groupName: '',
                                          printerCondition: defaultValue==-1?"`groups`.printer_id=-1 OR `groups`.printer_id=$pivot":""),
                                          builder: (context, snapshot1) {
                                            if (snapshot1.connectionState ==
                                                ConnectionState.waiting) {
                                              return const WaitingWidget();
                                            } else if (!snapshot1.hasData ||
                                                snapshot1.data == null ||
                                                snapshot1.data!.isEmpty) {
                                              return const SizedBox();
                                            } else {
                                              print(snapshot1.data);
                                              StreamController controller =
                                                  StreamController();
                                              List<StreamController>
                                                  controllers = List.generate(
                                                      snapshot1.data!.length,
                                                      (index) =>
                                                          StreamController());
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 20,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        StreamBuilder(
                                                            initialData: snapshot
                                                                            .data![
                                                                        index][
                                                                    departmentField] ==
                                                                pivot,
                                                            stream: controller
                                                                .stream,
                                                            builder: (context,
                                                                snapshotSelect) {
                                                              return Checkbox(
                                                                  value:
                                                                      snapshotSelect
                                                                          .data,
                                                                  onChanged:
                                                                      (value) {
                                                                    if (value!) {
                                                                      if(!selectedDepartments.contains(snapshot.data![index]
                                                                      [
                                                                      "id_department"])){
                                                                        selectedDepartments.add(snapshot.data![index]
                                                                            [
                                                                            "id_department"]);
                                                                      }
                                                                      selectedGroups[
                                                                          snapshot.data![index]
                                                                              [
                                                                              "id_department"]] = List.generate(
                                                                          snapshot1
                                                                              .data!
                                                                              .length,
                                                                          (index) =>
                                                                              snapshot1.data![index]["id_group"]);

                                                                      for (var element
                                                                          in controllers) {
                                                                        element.add(
                                                                            true);
                                                                      }

                                                                    } else {
                                                                      selectedDepartments.removeWhere((e)=>e==
                                                                          snapshot.data![index]
                                                                              [
                                                                              "id_department"]);
                                                                      selectedGroups[
                                                                          snapshot.data![index]
                                                                              [
                                                                              "id_department"]] = [];

                                                                      for (var element
                                                                          in controllers) {
                                                                        element.add(
                                                                            false);
                                                                      }
                                                                    }
                                                                    controller.add(
                                                                        value);
                                                                  });
                                                            }),
                                                        Text(
                                                          snapshot.data![index]
                                                              ["section_name"],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 20),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 52 *
                                                        snapshot1.data!.length
                                                            .toDouble(),
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 50,
                                                        vertical: 10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                    child: ListView.separated(
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemBuilder:
                                                            (context, index1) {
                                                          snapshot1.data![index1]
                                                                      [
                                                                      groupField] ==
                                                                  pivot
                                                              ? selectedGroups[snapshot
                                                                              .data![
                                                                          index]
                                                                      [
                                                                      "id_department"]]!
                                                                  .add(snapshot1
                                                                              .data![
                                                                          index1]
                                                                      [
                                                                      "id_group"])
                                                              : null;

                                                          return Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              StreamBuilder(
                                                                  initialData:
                                                                      snapshot1.data![index1]
                                                                              [
                                                                              groupField] ==
                                                                          pivot,
                                                                  stream: controllers[
                                                                          index1]
                                                                      .stream,
                                                                  builder: (context,
                                                                      snapshotSelect) {
                                                                    return Checkbox(
                                                                      value: snapshotSelect
                                                                          .data,
                                                                      onChanged:
                                                                          (value) {
                                                                        if (value!) {
                                                                          if(!selectedGroups[snapshot.data![index]["id_department"]]!.contains(snapshot1.data![index1]["id_group"])){
                                                                            selectedGroups[snapshot.data![index]["id_department"]]!.add(snapshot1.data![index1]["id_group"]);
                                                                          }
                                                                        } else {
                                                                          selectedGroups[snapshot.data![index]["id_department"]]!.remove(snapshot1.data![index1]
                                                                              [
                                                                              "id_group"]);
                                                                        }
                                                                        controllers[index1]
                                                                            .add(value);
                                                                        if (selectedGroups[snapshot.data![index]["id_department"]]!.length ==
                                                                            snapshot1.data!.length) {
                                                                          print("#########rrr576ri6jtutyntru57######ur6j##########");

                                                                          print(selectedDepartments);

                                                                          if(!selectedDepartments.contains(snapshot.data![index]["id_department"])){
                                                                            selectedDepartments.add(snapshot.data![index]["id_department"]);
                                                                          }
                                                                          controller
                                                                              .add(true);
                                                                          print(selectedDepartments);
                                                                          print("#########rrr576ri6jtutyntru57######ur6j##########");


                                                                        } else {
                                                                          selectedDepartments.remove(snapshot.data![index]
                                                                              [
                                                                              "id_department"]);
                                                                          controller
                                                                              .add(false);
                                                                        }
                                                                      },
                                                                    );
                                                                  }),
                                                              Text(
                                                                snapshot1.data![
                                                                        index1][
                                                                    "group_name"],
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            20),
                                                              )
                                                            ],
                                                          );
                                                        },
                                                        separatorBuilder:
                                                            (context, index) {
                                                          return const Divider(
                                                            height: 0,
                                                            thickness: 1,
                                                          );
                                                        },
                                                        itemCount: snapshot1
                                                            .data!.length),
                                                  ),
                                                ],
                                              );
                                            }
                                          });
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(
                                        height: 5,
                                      );
                                    },
                                    itemCount: snapshot.data!.length);
                              }
                            }),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BottomButton(
                            height: 50,
                            leftRadius: 12,
                            title: "حفظ",
                            color: Theme.of(context).primaryColor,
                            onTap: () async {
                              print("888888888888888888888888888888888888");
                              print(selectedGroups);
                              print(selectedDepartments);
                              print("888888888888888888888888888888888888");

                              PosData data = PosData();
                              String printerCondition = defaultValue==-1?"printer_id=-1 OR printer_id=$pivot":"";
                              String sql = printerCondition==""?"UPDATE departments SET $departmentField=$defaultValue ":"UPDATE departments SET $departmentField=$defaultValue WHERE $printerCondition";
                              await data.changeData(sql);
                              printerCondition = defaultValue==-1?"`groups`.printer_id=-1 OR `groups`.printer_id=$pivot":"";
                              sql = printerCondition==""?"UPDATE `groups` SET $groupField=$defaultValue ":"UPDATE `groups` SET $groupField=$defaultValue WHERE $printerCondition";
                              await data.changeData(
                                  sql);




                              Navigator.pop(context);
                              String condition1 = "";
                              String condition2 = "";
                              for (int i = 0;
                                  i < selectedDepartments.length;
                                  i++) {
                                condition1 += i == 0 ? "" : " OR ";
                                condition1 += " id_department =${selectedDepartments[i]} ";
                                condition2 += i == 0 ? "" : " OR ";
                                condition2 += " section_number =${selectedDepartments[i]} ";
                                selectedGroups.remove(selectedDepartments[i]);
                              }
                              if (condition1 != "") {
                                print(condition1);
                                await data.changeData(
                                    "UPDATE departments SET $departmentField=$pivot WHERE $condition1");
                              }

                              if (condition2 != "") {
                                print(condition2);
                                await data.changeData(
                                    "UPDATE `groups` SET $groupField=$pivot WHERE $condition2");
                              }
                              String condition3 = "";
                              selectedGroups.forEach((key, value) {
                                value.forEach((element) {
                                  condition3 += "OR id_group =$element ";
                                });
                              });
                              if (condition3 != "") {
                                print(condition3.substring(2));
                                await data.changeData(
                                    "UPDATE `groups` SET $groupField=$pivot WHERE${condition3.substring(2)}");
                              }

                              List<Map> res =
                                  await data.readData('SELECT * FROM `groups`');
                              print(res);
                              MyDialog.showAnimateWarningDialog(
                                  context: context,
                                  isWarning: false,
                                  title: "تم حفظ المجموعات المختارة");
                            },
                            width: 462),
                        BottomButton(
                            height: 50,
                            rightRadius: 12,
                            title: "إلغاء",
                            color: Theme.of(context).cancelButtonColor,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            width: 462),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
//todo refactor thiiiiis