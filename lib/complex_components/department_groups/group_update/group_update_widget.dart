import 'package:flutter/material.dart';
import 'package:magicposbeta/bloc/shared_bloc/shared_cubit.dart';
import 'package:magicposbeta/complex_components/department_groups/group_update/group_update_bloc/group_update_bloc.dart';
import 'package:magicposbeta/theme/locale/locale.dart';
import '../../../components/general_text_field.dart';
import '../../../components/my_dialog.dart';
import '../../../components/operator_button.dart';
import '../../../components/settings_title.dart';
import '../../../components/waiting_widget.dart';
import '../../../lists/group_list/groups_list.dart';
import '../../../lists/section_list/sections_list.dart';

class GroupUpdateWidget extends StatelessWidget {
  const GroupUpdateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GroupUpdateCubit>(
      create: (BuildContext context) {
        return GroupUpdateCubit(
            () => InitialGroupState(), context.read<SharedCubit>().currentUser);
      },
      child: BlocConsumer<GroupUpdateCubit, GroupUpdateStates>(
        builder: (context, state) {
          if (state is LoadingGroupState) {
            return const WaitingWidget();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OperatorButton(
                    text: ButtonsNames.save,
                    textColor: Colors.white,
                    onPressed: () {
                      MyDialog.showWarningOperatorDialog(
                          context: context,
                          isWarning: true,
                          title: WarningsDialogPhrases.areYouSureOfUpdateGroup,
                          onTap: () async {
                            await context.read<GroupUpdateCubit>().update();
                          });
                    },
                    color: Theme.of(context).primaryColor,
                    enable: context.read<GroupUpdateCubit>().permission(),
                  ),
                  const SettingsTitle(title: SettingsNames.updateGroup)
                ],
              ),
              GeneralTextField(
                width: 350,
                prefix: IconButton(
                  onPressed: () async {
                    String groupVal = context.read<GroupUpdateCubit>().oldGroup;
                    String departmentVal =
                        context.read<GroupUpdateCubit>().newDepartment;
                    await showDialog(
                        context: context,
                        builder: (context) => GroupsList(
                              groupValue: groupVal,
                              departmentValue: departmentVal,
                              onDoubleTap: (
                                  {required String departmentValue,
                                  required String groupValue}) {
                                groupVal = groupValue;
                                departmentVal = departmentValue;
                              },
                            ));
                    if (context.mounted) {
                      context.read<GroupUpdateCubit>().updateGroup(
                          group: groupVal, department: departmentVal);
                    }
                  },
                  icon: const Icon(Icons.list),
                  iconSize: 25,
                ),
                readOnly: true,
                withSpacer: true,
                title: FieldsNames.oldName,
                controller: TextEditingController(
                    text: context.read<GroupUpdateCubit>().oldGroup),
              ),
              GeneralTextField(
                width: 350,
                withSpacer: true,
                title: FieldsNames.newName,
                onChangeFunc: (value) {
                  context.read<GroupUpdateCubit>().newGroup = value;
                },
                controller: TextEditingController(
                    text: context.read<GroupUpdateCubit>().newGroup),
              ),
              GeneralTextField(
                width: 350,
                prefix: IconButton(
                  onPressed: () async {
                    String departmentVal =
                        context.read<GroupUpdateCubit>().newDepartment;
                    await showDialog(
                        context: context,
                        builder: (context) => SectionsList(
                              value: departmentVal,
                              onDoubleTap: (String value) {
                                departmentVal = value;
                              },
                            ));
                    if (context.mounted) {
                      context
                          .read<GroupUpdateCubit>()
                          .updateDepartment(departmentVal);
                    }
                  },
                  icon: const Icon(Icons.list),
                  iconSize: 25,
                ),
                readOnly: true,
                withSpacer: true,
                title: FieldsNames.departmentName,
                controller: TextEditingController(
                    text: context.read<GroupUpdateCubit>().newDepartment),
              ),
            ],
          );
        },
        listener: (BuildContext context, state) {
          if (state is GroupOperationCompleteState) {
            MyDialog.showWarningDialog(
                context: context,
                isWarning: false,
                title: SuccessDialogPhrases.updateOperationComplete);
          }
          if (state is FailureGroupState) {
            MyDialog.showWarningDialog(
              context: context,
              isWarning: true,
              title: state.error,
            );
          }
        },
      ),
    );
  }
}
