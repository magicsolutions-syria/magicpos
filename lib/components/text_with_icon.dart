import 'package:flutter/material.dart';

class TextWithIcon extends StatelessWidget {
  const TextWithIcon({super.key, required this.title, required this.icon});
  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
          ),
        ),
      ],
    );
  }
}
