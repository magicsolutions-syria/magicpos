
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/bloc/bill_bloc/bill_cubit.dart';
import 'package:magicposbeta/bloc/bill_bloc/bill_states.dart';
import 'package:magicposbeta/bloc/shared_bloc/shared_cubit.dart';
import 'package:magicposbeta/complex_components/add_picture_box/add_picture_widget.dart';
import 'package:magicposbeta/components/big_text_field.dart';
import 'package:magicposbeta/components/my_dialog.dart';
import 'package:magicposbeta/components/operator_button.dart';
import 'package:magicposbeta/theme/app_profile.dart';
import 'package:magicposbeta/theme/locale/locale.dart';


class BillPage extends StatelessWidget {
  BillPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return BillCubit(() => InitialBillState(), context);
      },
      child: BlocConsumer<BillCubit, BillStates>(
        builder: (BuildContext context, BillStates state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AddPictureWidget(
                    onChanged: (path) {
                      context.read<BillCubit>().imagePath = path;
                    },
                    initialPath:
                        context.read<SharedCubit>().settings.billLogo,
                  ),
                  BlocBuilder<BillCubit, BillStates>(
                    builder: (BuildContext context, BillStates state) {
                      return Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 180),
                            child: Radio(
                              value: RadiosValues.logo,
                              groupValue: context.read<BillCubit>().headerType,
                              onChanged: (value) {
                                context
                                    .read<BillCubit>()
                                    .updateHeaderType(value!);
                              },
                            ),
                          ),
                          Container(
                            color: Theme.of(context).colorScheme.outlineVariant,
                            width: 4,
                            height: 200,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 180),
                            child: Radio(
                              value: RadiosValues.text,
                              groupValue: context.read<BillCubit>().headerType,
                              onChanged: (value) {
                                context
                                    .read<BillCubit>()
                                    .updateHeaderType(value!);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                    buildWhen: (p, c) => c is ChangedHeaderState,
                  ),
                  BigTextField(
                    minLines: 4,
                    maxLines: 4,
                    maxLength: AppProfile.billWidth * 4,
                    controller: TextEditingController(
                        text: context.read<BillCubit>().header),
                    height: 300,
                    width: 540,
                    onChanged: (String text) {
                      context.read<BillCubit>().header = text;
                    },
                    title: SettingsNames.billHeader,
                  ),
                ],
              ),
              const Divider(
                height: 0,
                thickness: 4,
                endIndent: 100,
                indent: 100,
              ),
              BigTextField(
                minLines: 2,
                maxLines: 2,
                maxLength: AppProfile.billWidth * 2,
                controller: TextEditingController(
                    text: context.read<BillCubit>().footer),
                height: 200,
                width: 540,
                onChanged: (String text) {
                  context.read<BillCubit>().footer = text;
                },
                title: SettingsNames.billFooter,
              ),
              OperatorButton(
                  onPressed: () async {
                    context.read<BillCubit>().setBillSettings(context);
                  },
                  text: ButtonsNames.save,
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  enable: true),
            ],
          );
        },
        listener: (BuildContext context, BillStates state) {
          if (state is SuccessBillState) {
            MyDialog.showAnimateWarningDialog(
                context: context,
                isWarning: false,
                title: SuccessDialogPhrases.saveOperationComplete);
          }
          if (state is FailureBillState) {
            MyDialog.showAnimateWrongDialog(
                context: context, title: state.error);
          }
        },
        buildWhen: (p, c) => false,
      ),
    );
  }
}
