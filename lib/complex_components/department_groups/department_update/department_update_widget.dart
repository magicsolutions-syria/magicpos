import 'package:flutter/material.dart';
import 'package:magicposbeta/bloc/shared_bloc/shared_cubit.dart';
import 'package:magicposbeta/theme/locale/locale.dart';

import '../../../components/general_text_field.dart';
import '../../../components/my_dialog.dart';
import '../../../components/operator_button.dart';
import '../../../components/settings_title.dart';
import '../../../components/waiting_widget.dart';
import '../../../lists/section_list/sections_list.dart';
import 'department_update_bloc/department_update_bloc.dart';

class DepartmentUpdateWidget extends StatelessWidget {
  const DepartmentUpdateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DepartmentUpdateCubit>(
      create: (BuildContext context) {
        return DepartmentUpdateCubit(
            () => InitialDeptState(), context.read<SharedCubit>().currentUser);
      },
      child: BlocConsumer<DepartmentUpdateCubit, DepartmentUpdateStates>(
        builder: (context, state) {
          if (state is LoadingDepartmentState) {
            return const WaitingWidget();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 500,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OperatorButton(
                      text: ButtonsNames.save,
                      textColor: Colors.white,
                      onPressed: () {
                        MyDialog.showWarningOperatorDialog(
                          context: context,
                          isWarning: true,
                          title:
                              WarningsDialogPhrases.areYouSureOfUpdateSection,
                          onTap: () async {
                            await context
                                .read<DepartmentUpdateCubit>()
                                .update();
                          },
                        );
                      },
                      color: Theme.of(context).primaryColor,
                      enable:
                          context.read<DepartmentUpdateCubit>().permission(),
                    ),
                    const SettingsTitle(title:SettingsNames.updateDepartment)
                  ],
                ),
              ),
              GeneralTextField(
                width: 350,
                prefix: IconButton(
                  onPressed: () async {
                    String departmentValue =
                        context.read<DepartmentUpdateCubit>().oldName;
                    await showDialog(
                        context: context,
                        builder: (context) => SectionsList(
                              value: departmentValue,
                              onDoubleTap: (String value) {
                                departmentValue = value;
                              },
                            ));
                    if (context.mounted) {
                      context.read<DepartmentUpdateCubit>().oldName =
                          departmentValue;
                    }
                  },
                  icon: const Icon(Icons.list),
                  iconSize: 25,
                ),
                readOnly: true,
                title:FieldsNames.oldName,
                controller: TextEditingController(),
              ),
              GeneralTextField(
                width: 350,
                title: FieldsNames.newName,
                controller: TextEditingController(),
                onChangeFunc: (text) {
                  context.read<DepartmentUpdateCubit>().newName = text;
                },
              ),
              const SizedBox(
                height: 60,
              ),
            ],
          );
        },
        listener: (BuildContext context, state) {
          if (state is DepartmentOperationCompleteState) {
            MyDialog.showWarningDialog(
                context: context,
                isWarning: false,
                title: SuccessDialogPhrases.updateOperationComplete);
          }
          if (state is FailureDepartmentState) {
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
