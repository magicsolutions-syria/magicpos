import "package:flutter/material.dart";
import "package:magicposbeta/modules/page_profile.dart";
import "package:magicposbeta/theme/pages_profiles.dart";

class CustomButton3 extends StatelessWidget {
  final double ratio = 0.12;
  final double fontSize;
  final bool nullOnPressed;
  final double width;
  final double iconSize;
  final double height;
  final Function() onPressed;
  final String arText;
  final String engText;
  final IconData icon;

  const CustomButton3({
    super.key,
    this.fontSize = 20,
    this.iconSize = 40,
    this.height = 180,
    this.nullOnPressed = false,
    this.width = 180,
    required this.onPressed,
    required this.arText,
    required this.engText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: nullOnPressed
            ? null
            : () {
                onPressed();
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.6),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.blue,
                size: iconSize,
              ),
              Text(
                '$engText\n$arText',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
