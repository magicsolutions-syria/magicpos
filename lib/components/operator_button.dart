import 'package:flutter/material.dart';

class OperatorButton extends StatelessWidget {
  const OperatorButton(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.color,
      required this.enable,
      this.fontSize = 28,
      this.width = 130,
      this.height = 60,
      this.textColor = Colors.black,
      this.rotate = 0});
  final String text;
  final double fontSize;
  final Color color;
  final bool enable;
  final VoidCallback onPressed;
  final double width;
  final Color textColor;
  final double height;
  final double rotate;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: color,
      padding: EdgeInsets.zero,
      disabledColor: Theme.of(context).disabledColor,
      onPressed: enable ? onPressed : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          15,
        ),
      ),
      minWidth: width,
      height: height,
      child: Transform.rotate(
        angle: rotate,
        child: Text(
          text,
          style: TextStyle(
              fontSize: fontSize, color: enable ? textColor : Colors.grey),
        ),
      ),
    );
  }
}
