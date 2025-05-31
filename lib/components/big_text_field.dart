import 'package:flutter/material.dart';

class BigTextField extends StatelessWidget {
  const BigTextField(
      {super.key,
      required this.minLines,
      required this.maxLines,
      required this.maxLength,
      required this.controller,
      required this.height,
      required this.width,
      required this.onChanged,
      required this.title});

  final int minLines;
  final int maxLines;
  final int maxLength;
  final TextEditingController controller;
  final double height;
  final double width;
  final Function(String text) onChanged;
  final String title;

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: Scrollbar(
          thumbVisibility: true,
          controller: scrollController,
          interactive: true,
          thickness: 15,
          radius: const Radius.circular(10),
          child: TextField(
            scrollController: scrollController,
            minLines: minLines,
            maxLines: maxLines,
            maxLength:maxLength,
            controller: controller,
            textDirection: TextDirection.rtl,
            style: const TextStyle(fontSize: 18),
            onChanged: (text) {
              onChanged(text);
            },
            decoration: InputDecoration(
                counter: const SizedBox(),
                hintText: title,
                hintStyle: const TextStyle(fontSize: 23),
                hintTextDirection: TextDirection.rtl,
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1.5),
                    borderRadius: BorderRadius.circular(10)),
                border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1.5),
                    borderRadius: BorderRadius.circular(10)),
                fillColor: Colors.white,
                filled: true),
          ),
        ),
      ),
    );
  }
}
