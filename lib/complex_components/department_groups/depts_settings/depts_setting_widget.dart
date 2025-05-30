import 'package:flutter/material.dart';
import '../../../components/choose_number_field.dart';
import '../../../components/general_text_field.dart';
import '../../../components/my_dialog.dart';
import '../../../components/operator_button.dart';
import '../../../components/small_hint_text.dart';
import '../../../components/waiting_widget.dart';
import '../../../lists/section_list/sections_list.dart';
import '../../../theme/locale/locale.dart';
import 'dept_bloc/dept_bloc.dart';

class DeptsSettingWidget extends StatelessWidget {
  const DeptsSettingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocProvider<DeptCubit>(
      create: (BuildContext context) {
        return DeptCubit(() => InitialDeptState());
      },
      child: BlocConsumer<DeptCubit, DeptStates>(
        builder: (context, state) {
          if (state is LoadingDeptState) {
            return const WaitingWidget();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  OperatorButton(
                    onPressed: () {
                      context
                          .read<DeptCubit>()
                          .saveDeptSettings();
                    },
                    text: ButtonsNames.save,
                    color: Theme.of(context).primaryColor,
                    enable: true,
                    textColor: Colors.white,
                  ),
                  const Spacer(),
                  const SmallHintText(title: SettingsNames.chooseBetween1and16),
                  const SizedBox(
                    width: 10,
                  ),
                  ChooseNumberField(
                    controller: TextEditingController(),
                    maxNumber: 16,
                    title: FieldsNames.depKeyNumber,
                    onChanged: (int number) async {
                      context
                          .read<DeptCubit>()
                          .getDeptData(number);
                    },
                    initialValue:
                    context.read<DeptCubit>().deptNumber,
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
                      onPressed: () async {
                        String sectionValue = context
                            .read<DeptCubit>()
                            .deptSection;
                        await showDialog(
                            context: context,
                            builder: (context) => SectionsList(
                              value: sectionValue,
                              onDoubleTap: (String value) {
                                sectionValue = value;
                              },
                            ));
                        if (context.mounted) {
                          context
                              .read<DeptCubit>()
                              .updateDeptSection(sectionValue);
                        }
                      },
                      icon: const Icon(Icons.list),
                      iconSize: 25,
                    ),
                    readOnly: true,
                    title: FieldsNames.attachToSection,
                    controller: TextEditingController(
                        text: context
                            .read<DeptCubit>()
                            .deptSection),
                  ),
                  const Spacer(),
                  GeneralTextField(
                    width: 350,
                    title: FieldsNames.name,
                    onChangeFunc: (value) {
                      context
                          .read<DeptCubit>()
                          .updateDeptName(value);
                    },
                    controller: TextEditingController(
                        text: context
                            .read<DeptCubit>()
                            .deptName),
                  ),
                ],
              ),
            ],
          );
        },
        listener: (BuildContext context, state) {
          if (state is DeptOperationCompleteState) {
            MyDialog.showWarningDialog(
                context: context,
                isWarning: false,
                title: SuccessDialogPhrases.saveDeptSettingsComplete);
          }
          if (state is FailureDeptState) {
            MyDialog.showWarningDialog(
              context: context,
              isWarning: true,
              title: state.error,
            );
          }
        },
        buildWhen: (p, c) =>
        c is ChangedDeptState ||
            c is LoadingDeptState ||
            p is LoadingDeptState,
      ),
    );
  }
}
