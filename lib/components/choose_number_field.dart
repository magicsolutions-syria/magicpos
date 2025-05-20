import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'general_text_field.dart';

class ChooseNumberField extends StatelessWidget {
  const ChooseNumberField(
      {super.key,
      required this.controller,
      required this.maxNumber,
      required this.title,
      this.minNumber = 1,
      this.enableEditing = false});
  final TextEditingController controller;
  final int maxNumber;
  final int minNumber;
  final String title;
  final bool enableEditing;
  @override
  Widget build(BuildContext context) {
    return GeneralTextField(
      width: 130,
      initVal: (int.parse(controller.text) < 10 ? "0" : "") + controller.text,
      prefix: MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            int index = int.parse(controller.text);
            index--;
            if (index >= minNumber) {
              controller.text = (index < 10 ? "0" : "") + index.toString();
            }
          },
          minWidth: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Text(
            "-",
            style: TextStyle(fontSize: 24),
          )),
      suffix: MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            int index = int.parse(controller.text);
            index++;
            if (index <= maxNumber) {
              controller.text = (index < 10 ? "0" : "") + index.toString();
            }
          },
          minWidth: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Text(
            "+",
            style: TextStyle(fontSize: 24),
          )),
      title: title,
      readOnly: !enableEditing,
      onlyNumber: [
        FilteringTextInputFormatter.allow(
          RegExp(r'^(?:[1-9]?[0-9])$'),
        ),
      ],
      inputType: TextInputType.number,
      controller: controller,
    );
  }
}
