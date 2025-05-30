import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/bloc/in_out_product_bloc/in_out_product_bloc.dart';
import 'package:magicposbeta/theme/custom_colors.dart';
import 'package:magicposbeta/theme/locale/locale.dart';

import '../lists/in_out_product_list.dart';
import 'edited_drop_down_menu.dart';
import 'operator_button.dart';

class FirstInOutRow extends StatelessWidget {
  const FirstInOutRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: EditedDropDownMenu<String>(
            width: 181.56,
            enabled: false,
            inputDecorationTheme: const InputDecorationTheme(
                fillColor: Colors.white,
                filled: true,
                border: InputBorder.none),
            dropdownMenuEntries:
                [""].map<EditedDropdownMenuEntry<String>>((String item) {
              return EditedDropdownMenuEntry<String>(
                value: item,
                label: item,
                style: const ButtonStyle(
                  textStyle: MaterialStatePropertyAll(
                    TextStyle(fontSize: 21),
                  ),
                ),
              );
            }).toList(),
            focusNode: FocusNode(), onChanged: (String value) {  },
          ),
        ),
        SizedBox(
          height: 45,
          width: 1,
          child: Center(
            child: Container(
              height: 25,
              width: 1,
              color: Theme.of(context).dividerSecondaryColor,
            ),
          ),
        ),
        const SizedBox(
          width: 253.2,
        ),
        SizedBox(
          height: 45,
          width: 1,
          child: Center(
            child: Container(
              height: 25,
              width: 1,
              color: Theme.of(context).dividerSecondaryColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: EditedDropDownMenu<String>(
            width: 233.2,
            enabled: false,
            inputDecorationTheme: const InputDecorationTheme(
                fillColor: Colors.white,
                filled: true,
                border: InputBorder.none),
            dropdownMenuEntries:
                [""].map<EditedDropdownMenuEntry<String>>((String item) {
              return EditedDropdownMenuEntry<String>(
                value: item,
                label: item,
                style: const ButtonStyle(
                  textStyle: MaterialStatePropertyAll(
                    TextStyle(fontSize: 21),
                  ),
                ),
              );
            }).toList(),
            focusNode: FocusNode(), onChanged: (String value) {  },
          ),
        ),
        SizedBox(
          height: 45,
          width: 1,
          child: Center(
            child: Container(
              height: 25,
              width: 1,
              color: Theme.of(context).dividerSecondaryColor,
            ),
          ),
        ),
        const SizedBox(
          width: 202.56,
        ),
        SizedBox(
          height: 45,
          width: 1,
          child: Center(
            child: Container(
              height: 25,
              width: 1,
              color: Theme.of(context).dividerSecondaryColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SizedBox(
            width: 313.48,
            height: 40,
            child: Center(
              child: BlocBuilder<InOutProductCubit, InOutProductStates>(
                builder: (BuildContext context, state) {
                  return OperatorButton(
                      onPressed: () async {
                        Map productItem = {};
                        await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) =>
                              InOutProductList(onDoubleTap: (Map item) {
                            productItem = item;
                          }),
                        );
                        if (productItem.isNotEmpty) {
                          context
                              .read<InOutProductCubit>()
                              .addProductToList(productItem);
                        }
                      },
                      textColor: Colors.white,
                      text: ButtonsNames.chooseProduct,
                      height: 40,
                      fontSize: 20,
                      width: 200,
                      color: Theme.of(context).primaryColor,
                      enable: true);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
