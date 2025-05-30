import 'dart:async';
import 'package:flutter/material.dart';
import 'package:magicposbeta/components/settings_title.dart';
import '../../bloc/in_out_product_bloc/in_out_product_bloc.dart';
import 'radio_text_cubit.dart';
import 'radio_text_states.dart';

class RadioText extends StatelessWidget {
  RadioText(
      {super.key,
      required this.title,
      required this.values,
      required this.names,
      required this.hieght,
      required this.initialValue,
      required this.width,
      required this.onChanged});

  final StreamController streamController = StreamController();
  final List<String> values;
  final List<String> names;
  final String initialValue;

  final String title;
  final double hieght;
  final double width;
  final Function(String value) onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RadioTextCubit>(
      create: (BuildContext context) {
        return RadioTextCubit(
            () => InitialRadioTextState(groupValue: initialValue));
      },
      child: SizedBox(
        height: hieght,
        width: width,
        child: Column(
          children: [
            SettingsTitle(title: title),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    BlocBuilder<RadioTextCubit, RadioTextStates>(
                        builder: (context, state) {
                      if (state is InitialRadioTextState) {
                        return RadioMenuButton(
                          value: values[index],
                          groupValue: state.groupValue,
                          onChanged: (value) async {
                            onChanged(value!);
                            context.read<RadioTextCubit>().changeValue(value);
                          },
                          child: const SizedBox(
                            width: 0,
                          ),
                        );
                      }
                      return Container();
                    }),
                    Text(
                      names[index],
                      style: const TextStyle(fontSize: 24),
                    ),
                    const Spacer(),
                  ],
                );
              },
              itemCount: values.length,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 15,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
// finish refactor