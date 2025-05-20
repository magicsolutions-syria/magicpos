import 'package:flutter/material.dart';
import 'package:magicposbeta/theme/custom_colors.dart';

class PersonBox extends StatelessWidget {
  const PersonBox({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          color: Theme.of(context).fieldsColor,
          width: 250,
          height: 28,
          child: Center(
            child: Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Text(title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textDirection: TextDirection.rtl),
      ],
    );
  }
}
