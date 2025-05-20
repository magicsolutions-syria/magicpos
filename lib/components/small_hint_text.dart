import 'package:flutter/material.dart';

class SmallHintText extends StatelessWidget {
  const SmallHintText({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, color: Colors.grey),
    );
  }
}
