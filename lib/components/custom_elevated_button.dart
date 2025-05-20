import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final MaterialPropertyResolver<Color> buttonColor;
  final String buttonText;
  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.buttonColor,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        minimumSize: const Size(200, 100),
        backgroundColor: MaterialStateColor.resolveWith(
          buttonColor,
        ),
      ),
      child: Text(buttonText,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )),
    );
  }
}
