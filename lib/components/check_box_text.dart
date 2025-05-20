import 'dart:async';

import 'package:flutter/material.dart';

class CheckBoxText extends StatelessWidget {
  CheckBoxText(
      {super.key,
      required this.title,
      required this.value,
      required this.width,
      required this.onChanged});

  final String title;
  bool value;
  final double width;
  final Function(bool value) onChanged;
  final StreamController streamController = StreamController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          StreamBuilder(
              stream: streamController.stream,
              builder: (context, snapshot) {
                return Checkbox(
                    value: value,
                    onChanged: (v) {
                      onChanged(v!);
                      value = !value;
                      streamController.add(value);
                    });
              }),
          const SizedBox(
            width: 5,
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
