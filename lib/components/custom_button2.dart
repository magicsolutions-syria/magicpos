import "package:flutter/material.dart";

class CustomButton2 extends StatelessWidget {
  final double ratio = 0.12;
  final VoidCallback onPressed;
  final IconData icon;
  final String engText;
  final String arText;
  final bool nullOnPressed;
  const CustomButton2(
      {super.key,
      required this.onPressed,
      required this.icon,
      required this.engText,
      required this.arText,
      required this.nullOnPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (1.08 * ratio + 0.045) * MediaQuery.of(context).size.width,
      height: (2.1 * ratio) * MediaQuery.of(context).size.height,
      child: ElevatedButton(
        onPressed: !nullOnPressed ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.6),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.6),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.blue,
                  size: 40,
                ),
                Text(
                  '$engText\n$arText',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
