import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magicposbeta/theme/app_formatters.dart';

import 'general_text_field.dart';

class ChooseNumberField extends StatelessWidget {
  ChooseNumberField(
      {super.key,
      required this.maxNumber,
      required this.title,
      this.minNumber = 1,
      this.enableEditing = false,
      required this.onChanged,
      required int initialValue,
      TextEditingController ?controller}) {
    this.controller=controller??TextEditingController();
    this.controller.text =
        AppFormatters.leftZerosFormat(initialValue, digitsNumber: 2);
  }

  final int maxNumber;
  final int minNumber;
  final String title;
  final bool enableEditing;
  final Function(int number) onChanged;
  late final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    controller.addListener((){
      onChanged(int.parse(controller.text));
    });
    return GeneralTextField(
      width: 130,
      prefix: MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            int index = int.parse(controller.text);
            index--;
            if (index >= minNumber) {
              controller.text =
                  AppFormatters.leftZerosFormat(index, digitsNumber: 2);
            }
          },
          minWidth: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: const Text(
            "-",
            style: TextStyle(fontSize: 24),
          )),
      suffix: MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            int index = int.parse(controller.text);
            index++;
            if (index <= maxNumber) {
              controller.text =
                  AppFormatters.leftZerosFormat(index, digitsNumber: 2);
            }
          },
          minWidth: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            "+",
            style: TextStyle(fontSize: 24),
          )),
      title: title,
      readOnly: !enableEditing,
      onlyNumber: AppFormatters.numbersIntFormat(),
      inputType: TextInputType.number,
      controller: controller,
      onChangeFunc: (s) {

      },
    );
  }
}
