import 'package:flutter/material.dart';
import 'package:magicposbeta/bloc/product_bloc/product_bloc.dart';
import 'package:magicposbeta/components/big_text_field.dart';
import 'package:magicposbeta/theme/custom_colors.dart';
import 'package:magicposbeta/theme/locale/locale.dart';

import '../../../components/text_view.dart';
import '../../complex_components/add_picture_box/add_picture_widget.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                value: BlocProvider.of<ProductCardCubit>(context)
                    .product
                    .unit1
                    .currentQTY
                    .toString(),
              ),
              TextView(
                title: FieldsNames.unitTwo,
                value: BlocProvider.of<ProductCardCubit>(context)
                    .product
                    .unit2
                    .currentQTY
                    .toString(),
              ),
              TextView(
                title: FieldsNames.unitThree,
                value: BlocProvider.of<ProductCardCubit>(context)
                    .product
                    .unit3
                    .currentQTY
                    .toString(),
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
            BigTextField(
                minLines: 7,
                maxLines: 9,
                maxLength: 700,
                controller: TextEditingController(
                    text: context.read<ProductCardCubit>().product.description),
                height: 190,
                width: 650,
                onChanged: (text) {
                  context.read<ProductCardCubit>().updateDescription(text);
                },
                title: FieldsPhrases.addDescriptionForProductHere)
          ],
        ),
        AddPictureWidget(
          initialPath: context.read<ProductCardCubit>().product.imagePath,
          onChanged: (String path) {
            context.read<ProductCardCubit>().product.imagePath = path;
          },
        ),
      ],
    );
  }
}
