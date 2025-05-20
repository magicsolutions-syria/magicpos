import 'dart:async';
import 'package:flutter/material.dart';
import 'package:magicposbeta/bloc/product_bloc/product_bloc.dart';
import 'package:magicposbeta/components/add_picture_box/add_picture_widget.dart';
import 'package:magicposbeta/theme/custom_colors.dart';
import 'package:magicposbeta/theme/locale/locale.dart';

import '../../../components/text_view.dart';

class DetailsPage extends StatelessWidget {
   DetailsPage({
    super.key,
  });

  String qty1 = "";

  String qty2 = "";

  String qty3 = "";

  final TextEditingController imageController = TextEditingController();

  final TextEditingController description = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    qty1 = BlocProvider.of<ProductCardCubit>(context)
        .product
        .unit1
        .currentQTY
        .toString();
    qty2 = BlocProvider.of<ProductCardCubit>(context)
        .product
        .unit2
        .currentQTY
        .toString();
    qty3 = BlocProvider.of<ProductCardCubit>(context)
        .product
        .unit3
        .currentQTY
        .toString();
    description.text = context.read<ProductCardCubit>().product.description;
    description.addListener(() {
      context.read<ProductCardCubit>().product.description = description.text;
    });
    imageController.addListener(() {
      context.read<ProductCardCubit>().product.imagePath = imageController.text;
    });

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 26, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DiversePhrases.currentQTY,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              TextView(
                title: FieldsNames.unitOne,
                value: qty1,
              ),
              TextView(
                title: FieldsNames.unitTwo,
                value: qty2,
              ),
              TextView(
                title: FieldsNames.unitThree,
                value: qty3,
              )
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 45.0),
              child: Text(
                DiversePhrases.productDescription,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 650,
              height: 190,
              child: Padding(
                padding: const EdgeInsets.only(right: 45, left: 55),
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _scrollController,
                  interactive: true,
                  thickness: 15,
                  radius: const Radius.circular(10),
                  child: TextField(
                    scrollController: _scrollController,
                    minLines: 7,
                    maxLines: 9,
                    onChanged: (text) {
                      context.read<ProductCardCubit>().updateDescription(text);
                    },
                    controller: description,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(fontSize: 23),
                    decoration: InputDecoration(
                        hintText: FieldsPhrases.addDescriptionForProductHere,
                        hintStyle: const TextStyle(fontSize: 23),
                        hintTextDirection: TextDirection.rtl,
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 1.5),
                            borderRadius: BorderRadius.circular(10)),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(width: 1.5),
                            borderRadius: BorderRadius.circular(10)),
                        fillColor: Theme.of(context).fieldsColor,
                        filled: true),
                  ),
                ),
              ),
            ),
          ],
        ),
        AddPictureWidget(
          controller: imageController,
          initialPath: context.read<ProductCardCubit>().product.imagePath,
        ),
      ],
    );
  }
}
