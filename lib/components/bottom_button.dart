import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  const BottomButton(
      {super.key,
      this.leftRadius = 0,
      this.rightRadius = 0,
      this.height = 100,
      required this.title,
      required this.color,
      required this.onTap,
      required this.width,
      this.enable = true});
  final String title;
  final Color color;
  final void Function() onTap;
  final double leftRadius;
  final double rightRadius;
  final double width;
  final double height;
  final bool enable;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: enable
          ? () {
              onTap();
            }
          : null,
      color: color,
      minWidth: width / 2,
      height: height,
      shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(leftRadius),
              bottomRight: Radius.circular(rightRadius))),
      child: Text(
        title,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}
