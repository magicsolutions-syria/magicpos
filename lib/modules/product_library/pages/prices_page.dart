import 'package:flutter/material.dart';
import 'package:magicposbeta/bloc/product_bloc/product_bloc.dart';

import 'package:magicposbeta/modules/product_unit.dart';
import 'package:magicposbeta/modules/product_unit_expanded.dart';
import 'package:magicposbeta/theme/app_formatters.dart';
import 'package:magicposbeta/theme/locale/diverse_phrases.dart';
import 'package:magicposbeta/theme/locale/fields_names.dart';

import '../../../components/general_text_field.dart';

class PricesPage extends StatelessWidget {
   PricesPage({
    super.key,
  });

  final List<TextEditingController> prices1 =
      List.generate(3, (index) => TextEditingController());

  final List<TextEditingController> prices2 =
      List.generate(3, (index) => TextEditingController());

  final List<TextEditingController> prices3 =
      List.generate(3, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    ProductUnit unit1 = context.read<ProductCardCubit>().product.unit1;
    ProductUnitExpanded unit2 = context.read<ProductCardCubit>().product.unit2;
    ProductUnitExpanded unit3 = context.read<ProductCardCubit>().product.unit3;
    prices1[0].text = unit1.costPriceText();
    prices1[1].text = unit1.groupPriceText();
    prices1[2].text = unit1.piecePriceText();
    prices2[0].text = unit2.costPriceText();
    prices2[1].text = unit2.groupPriceText();
    prices2[2].text = unit2.piecePriceText();
    prices3[0].text = unit3.costPriceText();
    prices3[1].text = unit3.groupPriceText();
    prices3[2].text = unit3.piecePriceText();

    return Row(
      children: [
        const Spacer(),
        SizedBox(
          width: 860,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    context
                        .read<ProductCardCubit>()
                        .product
                        .unit3
                        .getViewName(DiversePhrases.unitThree),
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  GeneralTextField(
                    initVal: "0",
                    width: 240,
                    title: "",
                    onChangeFunc: (text) {
                      BlocProvider.of<ProductCardCubit>(context)
                          .product
                          .unit3
                          .updateCostPrice(text);
                    },
                    controller: prices3[0],
                    inputType: const TextInputType.numberWithOptions(),
                    onlyNumber: AppFormatters.numbersDoubleFormat(),
                  ),
                  GeneralTextField(
                    width: 240,
                    title: "",
                    onChangeFunc: (text) {
                      BlocProvider.of<ProductCardCubit>(context)
                          .product
                          .unit3
                          .updateGroupPrice(text);
                    },
                    controller: prices3[1],
                    initVal: "0",
                    inputType: const TextInputType.numberWithOptions(),
                    onlyNumber: AppFormatters.numbersDoubleFormat(),
                  ),
                  GeneralTextField(
                    initVal: "0",
                    width: 240,
                    title: "",
                    onChangeFunc: (text) {
                      BlocProvider.of<ProductCardCubit>(context)
                          .product
                          .unit3
                          .updatePiecePrice(text);
                    },
                    controller: prices3[2],
                    inputType: const TextInputType.numberWithOptions(),
                    onlyNumber: AppFormatters.numbersDoubleFormat(),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    context
                        .read<ProductCardCubit>()
                        .product
                        .unit2
                        .getViewName(DiversePhrases.unitTwo),
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  GeneralTextField(
                    initVal: "0",
                    width: 240,
                    title: "",
                    onChangeFunc: (text) {
                      BlocProvider.of<ProductCardCubit>(context)
                          .product
                          .unit2
                          .updateCostPrice(text);
                    },
                    controller: prices2[0],
                    inputType: const TextInputType.numberWithOptions(),
                    onlyNumber: AppFormatters.numbersDoubleFormat(),
                  ),
                  GeneralTextField(
                    initVal: "0",
                    width: 240,
                    title: "",
                    onChangeFunc: (text) {
                      BlocProvider.of<ProductCardCubit>(context)
                          .product
                          .unit2
                          .updateGroupPrice(text);
                    },
                    controller: prices2[1],
                    inputType: const TextInputType.numberWithOptions(),
                    onlyNumber: AppFormatters.numbersDoubleFormat(),
                  ),
                  GeneralTextField(
                    initVal: "0",
                    width: 240,
                    title: "",
                    onChangeFunc: (text) {
                      BlocProvider.of<ProductCardCubit>(context)
                          .product
                          .unit2
                          .updatePiecePrice(text);
                    },
                    controller: prices2[2],
                    inputType: const TextInputType.numberWithOptions(),
                    onlyNumber: AppFormatters.numbersDoubleFormat(),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    context
                        .read<ProductCardCubit>()
                        .product
                        .unit1
                        .getViewName(DiversePhrases.unitOne),
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  GeneralTextField(
                    initVal: "0",
                    width: 240,
                    title: "",
                    onChangeFunc: (text) {
                      BlocProvider.of<ProductCardCubit>(context)
                          .product
                          .unit1
                          .updateCostPrice(text);
                    },
                    controller: prices1[0],
                    inputType: const TextInputType.numberWithOptions(),
                    onlyNumber: AppFormatters.numbersDoubleFormat(),
                  ),
                  GeneralTextField(
                    initVal: "0",
                    width: 240,
                    title: "",
                    onChangeFunc: (text) {
                      BlocProvider.of<ProductCardCubit>(context)
                          .product
                          .unit1
                          .updateGroupPrice(text);
                    },
                    controller: prices1[1],
                    inputType: const TextInputType.numberWithOptions(),
                    onlyNumber: AppFormatters.numbersDoubleFormat(),
                  ),
                  GeneralTextField(
                    initVal: "0",
                    width: 240,
                    title: "",
                    onChangeFunc: (text) {
                      BlocProvider.of<ProductCardCubit>(context)
                          .product
                          .unit1
                          .updatePiecePrice(text);
                    },
                    controller: prices1[2],
                    inputType: const TextInputType.numberWithOptions(),
                    onlyNumber: AppFormatters.numbersDoubleFormat(),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                FieldsNames.costPrice,
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
              ),
              Text(
                FieldsNames.groupPrice,
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
              ),
              Text(
                FieldsNames.piecePrice,
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
