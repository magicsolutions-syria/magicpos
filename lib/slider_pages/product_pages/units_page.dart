import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magicposbeta/bloc/product_bloc/product_bloc.dart';

import 'package:magicposbeta/theme/app_formatters.dart';

import '../../../components/custom_drop_down_menu.dart';
import '../../../components/general_text_field.dart';
import '../../../modules/product_unit.dart';
import '../../../modules/product_unit_expanded.dart';
import '../../../theme/locale/locale.dart';
class UnitsPage extends StatelessWidget {
  const UnitsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ProductUnit unit1 = context.read<ProductCardCubit>().product.unit1;
    ProductUnitExpanded unit2 = context.read<ProductCardCubit>().product.unit2;
    ProductUnitExpanded unit3 = context.read<ProductCardCubit>().product.unit3;

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
              controller: TextEditingController(text: unit3.name),
              title: FieldsNames.unitThree,
              data: BlocProvider.of<ProductCardCubit>(context).names_3,
              notify: () {},
              onChanged: (String value) {
                BlocProvider.of<ProductCardCubit>(context).product.unit3.name =
                    value;
              },
            ),
            const SizedBox(
              height: 17,
            ),
            GeneralTextField(
              width: 220,
              title: FieldsNames.piecesQTY,
              onChangeFunc: (text) {
                BlocProvider.of<ProductCardCubit>(context)
                    .product
                    .unit3
                    .updatePiecesQTY(text);
              },
              controller: TextEditingController(text: unit3.piecesQTYText()),
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
              controller: TextEditingController(text: unit3.barcode),
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
              controller: TextEditingController(text: unit2.name),
              title: FieldsNames.unitTwo,
              data: BlocProvider.of<ProductCardCubit>(context).names_2,
              notify: () {},
              onChanged: (String value) {
                BlocProvider.of<ProductCardCubit>(context).product.unit2.name =
                    value;
              },
            ),
            const SizedBox(
              height: 17,
            ),
            GeneralTextField(
              width: 220,
              title: FieldsNames.piecesQTY,
              onChangeFunc: (text) {
                BlocProvider.of<ProductCardCubit>(context)
                    .product
                    .unit2
                    .updatePiecesQTY(text);
              },
              controller: TextEditingController(text: unit2.piecesQTYText()),
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
              controller: TextEditingController(text:unit2.barcode),
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
              controller: TextEditingController(text: unit1.name),
              title: FieldsNames.unitOne,
              data: BlocProvider.of<ProductCardCubit>(context).names_1,
              notify: () {},
              onChanged: (String value) {
                BlocProvider.of<ProductCardCubit>(context).product.unit1.name =
                    value;
              },
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
              controller: TextEditingController(text: unit1.barcode),
              inputType: const TextInputType.numberWithOptions(),
              onlyNumber: AppFormatters.numbersIntFormat(),
            )
          ],
        ),
      ],
    );
  }
}
