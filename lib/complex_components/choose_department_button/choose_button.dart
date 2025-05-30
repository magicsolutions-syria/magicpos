import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/components/operator_button.dart';
import 'package:magicposbeta/components/text_view.dart';

import '../../lists/section_list/sections_list.dart';
import 'choose_department_bloc/choose_department_cubit.dart';
import 'choose_department_bloc/choose_department_states.dart';


class ChooseButton extends StatelessWidget {
  ChooseButton({
    super.key,
    this.width = 425,
    this.fieldWidth = 292,
    this.height = 50,
    required this.initialValue,
    required this.onTap,
  }) ;

  final double width;
  final double height;
  final double fieldWidth;
  String initialValue = "";
  Function(String value) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: BlocProvider(
          create: (BuildContext context) {
            return ChooseDepartmentCubit(
                () => InitialChooseDepartmentState(value: initialValue));
          },
          child: BlocBuilder<ChooseDepartmentCubit, ChooseDepartmentStates>(
            builder: (BuildContext context, state) {
              if (state is InitialChooseDepartmentState) {
                return Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextView(
                        hieght: height,
                        width: fieldWidth,
                        fontSize: 22,
                        title: "",
                        value: state.value,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    OperatorButton(
                        height: height,
                        width: width - 40 - fieldWidth,
                        fontSize: 22,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SectionsList(
                                    value: initialValue,
                                    onDoubleTap: (value) {
                                      onTap(value);
                                      context.read<ChooseDepartmentCubit>().changeValue(value);
                                    });
                              });
                        },
                        text: 'اختيار قسم',
                        color: Theme.of(context).primaryColor,
                        enable: true),
                    const SizedBox(
                      width: 15,
                    ),
                  ],
                );
              }
              return SizedBox();
            },
          ),
        ));
  }
}
