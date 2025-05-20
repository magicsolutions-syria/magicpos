import 'package:flutter/material.dart';
import 'package:magicposbeta/theme/custom_colors.dart';

class ListViewButton extends StatelessWidget {
  const ListViewButton(
      {super.key,
      required this.currentIndex,
      required this.totalWidth,
      this.height = 40,
      required this.buttonIndex,
      required this.title,
      required this.controller,
      this.radius = 20,
      required this.length, required this.onPressed});
  final int buttonIndex;
  final int currentIndex;
  final String title;
  final PageController controller;
  final int length;
  final double totalWidth;
  final double height;
  final double radius;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        onPressed();
        controller.jumpToPage(buttonIndex);
      },
      minWidth: totalWidth / length,
      height: 40,
      color: buttonIndex == currentIndex
          ? Theme.of(context).primaryColor
          : Theme.of(context).fieldsColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight:
                  Radius.circular(buttonIndex == (length - 1) ? radius : 0),
              bottomLeft: Radius.circular(buttonIndex == 0 ? radius : 0))),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 24,
            color: buttonIndex == currentIndex
                ? Theme.of(context).secondaryTextColor
                : Theme.of(context).iconsTextsColors),
      ),
    );
  }
}
