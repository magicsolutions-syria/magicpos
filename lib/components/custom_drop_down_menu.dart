import 'package:flutter/material.dart';
import 'package:magicposbeta/components/edited_drop_down_menu.dart';

class CustomDropDownMenu extends StatelessWidget {
  final String title;
  final String initVal;

  final double scaleY;
  final double width;
  final TextEditingController controller;
  final bool enable;
  final bool enableSearch;
  final List<String> data;
  final double fontSize;
  final bool enableFilter;
  final Function notify;

  const CustomDropDownMenu(
      {super.key,
      this.width = 220,
      required this.title,
      this.initVal = "",
      this.enableSearch = false,
      this.enable = true,
      this.enableFilter = true,
      this.scaleY = 1,
      required this.data,
      required this.controller,
      this.fontSize = 24, required this.notify});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scaleY: scaleY,
          child: EditedDropDownMenu<String>(
            width: width,
            enabled: enable,
            enableFilter: enableSearch && enableFilter,
            requestFocusOnTap: enableSearch,
            enableSearch: enableSearch,
            textStyle: const TextStyle(fontSize: 21),
            searchCallback: (entries, String query) {
              if (query.isEmpty) {
                return null;
              }
              final int index = entries.indexWhere(
                  (EditedDropdownMenuEntry<String> entry) =>
                      entry.label == query);

              return index != -1 ? index : null;
            },
            menuHeight: 200,
            inputDecorationTheme: InputDecorationTheme(
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            menuStyle: const MenuStyle(
              padding: MaterialStatePropertyAll(EdgeInsets.zero),
            ),
            initialSelection: initVal,
            onSelected: (value) {
              controller.text = value!;
              notify();
            },
            controller: controller,
            dropdownMenuEntries:
                data.map<EditedDropdownMenuEntry<String>>((String item) {
              return EditedDropdownMenuEntry<String>(
                value: item,
                label: item,
                style: const ButtonStyle(
                  textStyle: MaterialStatePropertyAll(
                    TextStyle(fontSize: 21),
                  ),
                ),
              );
            }).toList(), focusNode: FocusNode(),
          ),
        ),
        Text(
          title,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w400),
        )
      ],
    );
  }
}