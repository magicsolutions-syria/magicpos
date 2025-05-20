import 'package:flutter/material.dart';

import 'package:magicposbeta/modules/info_product.dart';
import 'package:magicposbeta/screens_data/constants.dart';

import 'package:magicposbeta/bloc/product_bloc/product_bloc.dart';
import '../../../components/custom_drop_down_menu.dart';
import '../../../components/general_text_field.dart';
import '../../../theme/app_formatters.dart';
import '../../../theme/locale/locale.dart';
import '../lists/group_list/groups_list.dart';
import '../lists/section_list/sections_list.dart';

class GeneralPage extends StatelessWidget {
  GeneralPage({
    super.key,
  });

  final TextEditingController department = TextEditingController();

  final TextEditingController group = TextEditingController();

  final TextEditingController productType = TextEditingController();

  final TextEditingController minAmount = TextEditingController();

  final TextEditingController maxAmount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    InfoProduct prod = context.read<ProductCardCubit>().product;

    department.text = prod.departmentName;
    group.text = prod.groupName;
    productType.text = prod.productTypeName;
    minAmount.text = prod.minQTYText();
    maxAmount.text = prod.maxQTYText();
    productType.addListener(() {
      context
          .read<ProductCardCubit>()
          .product
          .updateProductType(productType.text);
    });
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 70, right: 70),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GeneralTextField(
                  prefix: IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return GroupsList(
                              groupValue: group.text,
                              departmentValue: department.text,
                              onDoubleTap: (
                                  {String? departmentValue,
                                  String? groupValue}) {
                                department.text = departmentValue ?? "";
                                group.text = groupValue ?? "";
                              },
                            );
                          });
                    },
                    icon: const Icon(Icons.list),
                    iconSize: 25,
                  ),
                  width: 350,
                  title: FieldsNames.groupName,
                  onChangeFunc: (text) {
                    BlocProvider.of<ProductCardCubit>(context)
                        .product
                        .groupName = text;
                  },
                  controller: group,
                  inputType: TextInputType.text,
                  onlyNumber: const []),
              GeneralTextField(
                  prefix: IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SectionsList(
                              value: department.text,
                              onDoubleTap: (String value) {
                                department.text = value ;
                              },
                            );
                          });
                    },
                    icon: const Icon(Icons.list),
                    iconSize: 25,
                  ),
                  width: 350,
                  title: FieldsNames.departmentName,
                  controller: department,
                  inputType: TextInputType.text,
                  onlyNumber: const []),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomDropDownMenu(
                controller: productType,
                width: 190,
                title: FieldsNames.productType,
                initVal: DiversePhrases.productTypes()[0],
                data: DiversePhrases.productTypes(),
                notify: () {},
              ),
              GeneralTextField(
                initVal: "0",
                width: 150,
                title: FieldsNames.maxAmount,
                onChangeFunc: (text) {
                  BlocProvider.of<ProductCardCubit>(context)
                      .product
                      .updateMaxAmount(text);
                },
                controller: maxAmount,
                inputType: const TextInputType.numberWithOptions(),
                onlyNumber: AppFormatters.numbersIntFormat(),
              ),
              GeneralTextField(
                initVal: "0",
                width: 150,
                title: FieldsNames.minAmount,
                onChangeFunc: (text) {
                  BlocProvider.of<ProductCardCubit>(context)
                      .product
                      .updateMinAmount(text);
                },
                controller: minAmount,
                inputType: const TextInputType.numberWithOptions(),
                onlyNumber: AppFormatters.numbersIntFormat(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
