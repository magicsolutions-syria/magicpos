import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GeneralTextField extends StatelessWidget {
  final String title;
  final double width;
  final String initVal;
  final TextInputType inputType;
  final List<TextInputFormatter> onlyNumber;
  final TextEditingController controller;
  final Widget? prefix;
  final Widget? suffix;
  final double fontSize;
  final double titleFontSize;
  final bool secure;
  final double radius;
  final double height;
  final bool readOnly;
  final Color borderColor;
  final Function(String s) onChangeFunc;

  static void _defaultFunction(String text) {}
  final bool withSpacer;

  const GeneralTextField({
    super.key,
    required this.width,
    required this.title,
    required this.controller,
    this.fontSize = 24,
    this.readOnly = false,
    this.inputType = TextInputType.text,
    this.onlyNumber = const [],
    this.prefix,
    this.suffix,
    this.initVal = "",
    this.radius = 10,
    this.borderColor = Colors.black,
    this.onChangeFunc = _defaultFunction,
    this.height = 60,
    this.withSpacer = false,
    this.titleFontSize = 27,
    this.secure = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: width,
          height: height,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onSubmitted: (value) {
                    if (value == "") controller.text = initVal;
                  },
                  onChanged: (String text) {
                    print("555555555555555555555555555555555555555555000000000000000000000000000000000000");
                    onChangeFunc(text);},
                  inputFormatters: onlyNumber,
                  keyboardType: inputType,
                  readOnly: readOnly,
                  maxLength: 50,
                  obscureText: secure,
                  controller: controller,
                  style: TextStyle(
                    fontSize: fontSize,
                  ),
                  decoration: InputDecoration(
                    counter: const SizedBox(
                      height: 0.001,
                    ),
                    counterText: "",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    hintText: "",
                    prefixIcon: prefix,
                    suffixIcon: suffix,
                    alignLabelWithHint: true,
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
            ],
          ),
        ),
        Text(
          title,
          style: TextStyle(fontSize: titleFontSize),
        ),
        withSpacer ? const Spacer()
            : const SizedBox(
                width: 0,
                height: 0,
              )
      ],
    );
  }
}
