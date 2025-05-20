import 'package:flutter/material.dart';
import 'package:magicposbeta/theme/custom_colors.dart';

class TextView extends StatelessWidget {
  const TextView(
      {super.key,
      required this.title,
      required this.value,
      this.width = 150,
      this.hieght = 50,
      this.fontSize = 22,
      this.withSpacer = false,
      this.valueColor = Colors.black,
      this.bold = true});
  final double fontSize;
  final String title;
  final String value;
  final double width;
  final double hieght;
  final bool withSpacer;
  final Color valueColor;

  final bool bold;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        withSpacer ? const Spacer() : const SizedBox(),
        Container(
          width: width,
          height: hieght,
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(fontSize: fontSize, color: valueColor),
            ),
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
