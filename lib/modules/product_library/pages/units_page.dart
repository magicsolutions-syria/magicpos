import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magicposbeta/bloc/product_bloc/product_bloc.dart';

import 'package:magicposbeta/theme/app_formatters.dart';

import '../../../components/custom_drop_down_menu.dart';
import '../../../components/general_text_field.dart';
import '../../../theme/locale/locale.dart';
import '../../product_unit.dart';
import '../../product_unit_expanded.dart';

class UnitsPage extends StatelessWidget {
   UnitsPage({
    super.key,
  });

  final List<TextEditingController> unit1Info =
      List.generate(2, (index) => TextEditingController());

  final List<TextEditingController> unit2Info =
      List.generate(3, (index) => TextEditingController());

  final List<TextEditingController> unit3Info =
      List.generate(3, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    ProductUnit unit1 = context.read<ProductCardCubit>().product.unit1;
    ProductUnitExpanded unit2 = context.read<ProductCardCubit>().product.unit2;
    ProductUnitExpanded unit3 = context.read<ProductCardCubit>().product.unit3;
    unit1Info[0].text = unit1.name;
    unit1Info[1].text = unit1.barcode;
    unit2Info[0].text = unit2.name;
    unit2Info[1].text = unit2.piecesQTYText();
    unit2Info[2].text = unit2.barcode;
    unit3Info[0].text = unit3.name;
    unit3Info[1].text = unit3.piecesQTYText();
    unit3Info[2].text = unit3.barcode;

    unit1Info[0].addListener(() {
      BlocProvider.of<ProductCardCubit>(context).product.unit1.name =
          unit1Info[0].text;
    });
    unit2Info[0].addListener(() {
      BlocProvider.of<ProductCardCubit>(context).product.unit2.name =
          unit2Info[0].text;
    });
    unit3Info[0].addListener(() {
      BlocProvider.of<ProductCardCubit>(context).product.unit3.name =
          unit3Info[0].text;
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDropDownMenu(
              enableSearch: true,
              width: 220,
              controller: unit3Info[0],
              title: FieldsNames.unitThree,
              data: BlocProvider.of<ProductCardCubit>(context).names_3,
              initVal: unit3Info[0].text,
              notify: () {},
            ),
            const SizedBox(
              height: 17,
            ),
            GeneralTextField(
              initVal: "0",
              width: 220,
              title: FieldsNames.piecesQTY,
              onChangeFunc: (text) {
                BlocProvider.of<ProductCardCubit>(context)
                    .product
                    .unit3
                    .updatePiecesQTY(text);
              },
              controller: unit3Info[1],
              inputType: const TextInputType.numberWithOptions(),
              onlyNumber: AppFormatters.numbersDoubleFormat(),
            ),
            const SizedBox(
              height: 17,
            ),
            GeneralTextField(
              width: 220,
              title: FieldsNames.barcode,
              onChangeFunc: (text) {
                BlocProvider.of<ProductCardCubit>(context)
                    .product
                    .unit3
                    .barcode = text;
              },
              controller: unit3Info[2],
              inputType: const TextInputType.numberWithOptions(),
              onlyNumber: AppFormatters.numbersIntFormat(),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDropDownMenu(
              enableSearch: true,
              width: 220,
              controller: unit2Info[0],
              title: FieldsNames.unitTwo,
              data: BlocProvider.of<ProductCardCubit>(context).names_2,
              initVal: unit2Info[0].text,
              notify: () {},
            ),
            const SizedBox(
              height: 17,
            ),
            GeneralTextField(
              initVal: "0",
              width: 220,
              title: FieldsNames.piecesQTY,
              onChangeFunc: (text) {
                BlocProvider.of<ProductCardCubit>(context)
                    .product
                    .unit2
                    .updatePiecesQTY(text);
              },
              controller: unit2Info[1],
              inputType: const TextInputType.numberWithOptions(),
              onlyNumber: AppFormatters.numbersDoubleFormat(),
            ),
            const SizedBox(
              height: 17,
            ),
            GeneralTextField(
              width: 220,
              title: FieldsNames.barcode,
              onChangeFunc: (text) {
                BlocProvider.of<ProductCardCubit>(context)
                    .product
                    .unit2
                    .barcode = text;
              },
              controller: unit2Info[2],
              inputType: const TextInputType.numberWithOptions(),
              onlyNumber: AppFormatters.numbersIntFormat(),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDropDownMenu(
              enableSearch: true,
              width: 220,
              controller: unit1Info[0],
              title: FieldsNames.unitOne,
              data: BlocProvider.of<ProductCardCubit>(context).names_1,
              initVal: unit1Info[0].text,
              notify: () {},
            ),
            const SizedBox(
              height: 17,
            ),
            GeneralTextField(
              width: 220,
              title: FieldsNames.barcode,
              onChangeFunc: (text) {
                BlocProvider.of<ProductCardCubit>(context)
                    .product
                    .unit1
                    .barcode = text;
              },
              controller: unit1Info[1],
              inputType: const TextInputType.numberWithOptions(),
              onlyNumber: AppFormatters.numbersIntFormat(),
            )
          ],
        ),
      ],
    );
  }
}
