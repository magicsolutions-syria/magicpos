import 'package:flutter/material.dart';

class SettingsTitle extends StatelessWidget {
  const SettingsTitle({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueGrey),
    );
  }
}
