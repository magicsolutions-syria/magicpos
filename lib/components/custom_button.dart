import "package:flutter/material.dart";

class CustomButton extends StatelessWidget {
  final double ratio = 0.12;
  final VoidCallback onPressed;
  final IconData icon;
  final String engText;
  final String arText;
  final double fontSize;
  final bool nullOnPressed;
  final double width;
  final double iconSize;
  final double height;

  const CustomButton(
      {super.key,
      required this.onPressed,
      required this.icon,
      required this.engText,
      required this.arText,
      this.fontSize = 20,
      this.iconSize = 40,
      this.height = 180,
      this.nullOnPressed = false,
      this.width = 180});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: nullOnPressed ? null : onPressed,
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
