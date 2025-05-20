import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LabelTextFeild extends StatelessWidget {
  final String title;
  final double width;
  final String initVal;
  final TextInputType inputType;
  final List<TextInputFormatter> onlyNumber;
  final TextEditingController controller;
  final Widget? prefix;
  final double fontSize;
  final double titleFontSize;
  final bool obscureText;
  final double radius;
  final double height;
  final bool enable;
  final Color borderColor;
  final Function onChangeFunc;
  static void _defaultFunction(String text) {}

  const LabelTextFeild({
    super.key,
    required this.width,
    required this.title,
    required this.controller,
    this.fontSize = 24,
    this.enable = false,
    this.inputType = TextInputType.text,
    this.onlyNumber = const [],
    this.prefix,
    this.initVal = "",
    this.radius = 10,
    this.borderColor = Colors.black,
    this.onChangeFunc = _defaultFunction,
    this.height = 60,
    this.titleFontSize = 27,
    this.obscureText = false,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: TextField(
                onSubmitted: (value) {
                  if (value == "") controller.text = initVal;
                },
                onChanged: (String text) => onChangeFunc(text),
                inputFormatters: onlyNumber,
                keyboardType: inputType,
                readOnly: enable,
                obscureText: obscureText,
                maxLength: 50,
                controller: controller,
                decoration: InputDecoration(
                  hintText: title,
                  hintTextDirection: TextDirection.rtl,
                  hintStyle: const TextStyle(
                    fontSize: 20,
                    color: Color(0x94000000),
                  ),
                  counter: const SizedBox(
                    height: 0.001,
                  ),
                  counterText: "",
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  prefixIcon: prefix,
                  isDense: true,
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(radius),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(radius),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
