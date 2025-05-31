import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/components/bottom_button.dart';
import 'package:magicposbeta/components/choises_list.dart';
import 'package:magicposbeta/components/general_text_field.dart';
import 'package:magicposbeta/components/my_dialog.dart';
import 'package:magicposbeta/components/not_availble_widget.dart';
import 'package:magicposbeta/components/operator_button.dart';
import 'package:magicposbeta/components/waiting_widget.dart';
import 'package:magicposbeta/lists/group_view_list/group_view_list_bloc/group_view_list_cubit.dart';
import 'package:magicposbeta/lists/group_view_list/group_view_list_bloc/group_view_list_states.dart';
import 'package:magicposbeta/modules/department.dart';
import 'package:magicposbeta/theme/custom_colors.dart';
import 'package:magicposbeta/database/functions/groups_functions.dart';
import 'package:magicposbeta/database/functions/sections_functions.dart';
import 'package:magicposbeta/database/initialize_database.dart';
import 'package:magicposbeta/theme/locale/locale.dart';

import '../../modules/group.dart';

class GroupViewList extends StatefulWidget {
  final int pivot;
  final String departmentField;
  final String groupField;
  final int defaultValue;

  GroupViewList(
      {super.key,
      this.pivot = 1,
      this.departmentField = "selected_department",
      this.groupField = "selected_group",
      this.defaultValue = 0});

  @override
  State<GroupViewList> createState() => _GroupViewListState();
}

class _GroupViewListState extends State<GroupViewList> {
  final FocusNode _node = FocusNode();

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
                child: BlocProvider<GroupViewListCubit>(
                  create: (BuildContext context) {
                    return GroupViewListCubit(() => InitialGroupViewListState(),
                        pivot: widget.pivot,
                        departmentField: widget.departmentField,
                        groupField: widget.groupField,
                        defaultValue: widget.defaultValue);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      BlocBuilder<GroupViewListCubit, GroupViewListStates>(
                        builder:
                            (BuildContext context, GroupViewListStates state) {
                          return Padding(
                            padding: const EdgeInsets.only(left:50,right: 47),
                            child: Column(
                              children: [
                                GeneralTextField(
                                  width: 250,
                                  fontSize: 16,
                                  height: 55,
                                  withSpacer: true,
                                  title: FieldsNames.departmentName,
                                  controller: TextEditingController(text: context.read<GroupViewListCubit>().departmentFilter),
                                  onChangeFunc: (text) {
                                    context
                                        .read<GroupViewListCubit>()
                                        .updateDepartmentFilter(text);
                                  },
                                  prefix: const Icon(Icons.search),
                                ),
                                GeneralTextField(
                                  width: 250,
                                  height: 55,
                                  fontSize: 16,
                                  withSpacer: true,
                                  title: FieldsNames.groupName,
                                  controller: TextEditingController(text: context.read<GroupViewListCubit>().groupFilter),
                                  onChangeFunc: (text) {
                                    context
                                        .read<GroupViewListCubit>()
                                        .updateGroupFilter(text);
                                  },
                                  prefix: const Icon(Icons.search),
                                )
                              ],
                            ),
                          );
                        },
                        buildWhen: (p,c)=>false,
                      ),
                      SizedBox(
                        height: 452,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: BlocConsumer<GroupViewListCubit,
                              GroupViewListStates>(
                            builder: (context, state) {
                              if (state is LoadingGroupViewListState) {
                                return const WaitingWidget();
                              }
                              return ListView.separated(
                                  itemBuilder: (context, index) {
                                    Department department = context
                                        .read<GroupViewListCubit>()
                                        .departments[index];
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              BlocBuilder<GroupViewListCubit,
                                                  GroupViewListStates>(
                                                builder: (BuildContext context,
                                                    state) {
                                                  return Checkbox(
                                                      value:
                                                          department.isSelected,
                                                      onChanged: (value) {
                                                        context
                                                            .read<
                                                                GroupViewListCubit>()
                                                            .markDepartmentSelect(
                                                                department,
                                                                value!);
                                                      });
                                                },
                                                buildWhen: (p, c) {
                                                  if (c is UpdatedValueState) {
                                                    return c.idDepartment ==
                                                        department.id;
                                                  }
                                                  return false;
                                                },
                                              ),
                                              Text(
                                                department.name,
                                                style: const TextStyle(
                                                    fontSize: 20),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 52 *
                                              (department.groups.length
                                                  .toDouble()),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 50, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: ListView.separated(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder:
                                                  (context, groupIndex) {
                                                Group group = department
                                                    .groups[groupIndex];

                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    BlocBuilder<
                                                        GroupViewListCubit,
                                                        GroupViewListStates>(
                                                      builder: (context,
                                                          snapshotSelect) {
                                                        return Checkbox(
                                                          value:
                                                              group.isSelected,
                                                          onChanged: (value) {
                                                            context
                                                                .read<
                                                                    GroupViewListCubit>()
                                                                .changeGroupSelect(
                                                                    department,
                                                                    group,
                                                                    value!);
                                                          },
                                                        );
                                                      },
                                                      buildWhen: (p, c) {
                                                        if (c
                                                            is UpdatedValueState) {
                                                          return c.idDepartment ==
                                                                  department
                                                                      .id &&
                                                              (c.idGroup ==
                                                                      -1 ||
                                                                  c.idGroup ==
                                                                      group.id);
                                                        }
                                                        return false;
                                                      },
                                                    ),
                                                    Text(
                                                      group.name,
                                                      style: const TextStyle(
                                                          fontSize: 20),
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
                                              itemCount:
                                                  department.groups.length),
                                        ),
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      height: 5,
                                    );
                                  },
                                  itemCount: context
                                      .read<GroupViewListCubit>()
                                      .departments
                                      .length);
                            },
                            listener: (BuildContext context,
                                GroupViewListStates state) {
                              if (state is CompletedOperationState) {
                                Navigator.pop(context);

                                MyDialog.showAnimateWarningDialog(
                                    context: context,
                                    isWarning: false,
                                    title: SuccessDialogPhrases
                                        .saveSelectedGroups);
                              } else if (state is FailureGroupViewListState) {
                                MyDialog.showAnimateWrongDialog(
                                  context: context,
                                  title: state.error,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      BlocBuilder<GroupViewListCubit, GroupViewListStates>(
                        builder: (BuildContext context, state) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              BottomButton(
                                  height: 50,
                                  leftRadius: 12,
                                  title: ButtonsNames.save,
                                  color: Theme.of(context).primaryColor,
                                  onTap: () async {
                                    context
                                        .read<GroupViewListCubit>()
                                        .saveChanges();
                                  },
                                  width: 462),
                              BottomButton(
                                  height: 50,
                                  rightRadius: 12,
                                  title: ButtonsNames.cancelButton,
                                  color: Theme.of(context).cancelButtonColor,
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  width: 462),
                            ],
                          );
                        },
                        buildWhen: (p, c) => false,
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
//todo refactor thiiiiis
