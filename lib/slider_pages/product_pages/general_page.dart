import 'package:flutter/material.dart';
import 'package:magicposbeta/modules/info_product.dart';
import 'package:magicposbeta/bloc/product_bloc/product_bloc.dart';
import '../../../components/custom_drop_down_menu.dart';
import '../../../components/general_text_field.dart';
import '../../../theme/app_formatters.dart';
import '../../../theme/locale/locale.dart';
import '../../lists/group_list/groups_list.dart';
import '../../lists/section_list/sections_list.dart';

class GeneralPage extends StatelessWidget {
  const GeneralPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    InfoProduct prod = context.read<ProductCardCubit>().product;

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 70, right: 70),
      child: Column(
        children: [
          BlocBuilder<ProductCardCubit, ProductCardStates>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GeneralTextField(
                      prefix: IconButton(
                        onPressed: () async {
                          String groupVal = prod.groupName;
                          String departmentVal = prod.departmentName;
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) => GroupsList(
                              groupValue: groupVal,
                              departmentValue: departmentVal,
                              onDoubleTap: (
                                  {String? departmentValue,
                                  String? groupValue}) {
                                departmentVal =
                                    departmentValue ?? prod.departmentName;
                                groupVal = groupValue ?? prod.groupName;
                              },
                            ),
                          );
                          if (context.mounted) {
                            context.read<ProductCardCubit>().updateGroupName(
                                group: groupVal, department: departmentVal);
                          }
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
                      controller: TextEditingController(
                          text: context
                              .read<ProductCardCubit>()
                              .product
                              .groupName),
                      inputType: TextInputType.text,
                      onlyNumber: const []),
                  GeneralTextField(
                      prefix: IconButton(
                        onPressed: () async {
                          String departmentVal = prod.departmentName;
                          await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SectionsList(
                                  value: departmentVal,
                                  onDoubleTap: (String value) {
                                    departmentVal = value;
                                  },
                                );
                              });
                          if (context.mounted) {
                            BlocProvider.of<ProductCardCubit>(context)
                                .updateDepartmentName(departmentVal);
                          }
                        },
                        icon: const Icon(Icons.list),
                        iconSize: 25,
                      ),
                      onChangeFunc: (text) {
                        BlocProvider.of<ProductCardCubit>(context)
                            .product
                            .departmentName = text;
                      },
                      width: 350,
                      title: FieldsNames.departmentName,
                      controller: TextEditingController(
                          text: context
                              .read<ProductCardCubit>()
                              .product
                              .departmentName),
                      inputType: TextInputType.text,
                      onlyNumber: const []),
                ],
              );
            },
            buildWhen: (p, c) => c is ChangedValueState,
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomDropDownMenu(
                controller: TextEditingController(text: prod.productTypeName),
                width: 190,
                title: FieldsNames.productType,
                initVal: DiversePhrases.productTypes()[0],
                data: DiversePhrases.productTypes(),
                notify: () {},
                onChanged: (String value) {
                  context
                      .read<ProductCardCubit>()
                      .product
                      .updateProductType(value);
                },
              ),
              GeneralTextField(
                width: 150,
                title: FieldsNames.maxAmount,
                onChangeFunc: (text) {
                  BlocProvider.of<ProductCardCubit>(context)
                      .product
                      .updateMaxAmount(text);
                },
                controller: TextEditingController(text: prod.maxQTYText()),
                inputType: const TextInputType.numberWithOptions(),
                onlyNumber: AppFormatters.numbersIntFormat(),
              ),
              GeneralTextField(
                width: 150,
                title: FieldsNames.minAmount,
                onChangeFunc: (text) {
                  BlocProvider.of<ProductCardCubit>(context)
                      .product
                      .updateMinAmount(text);
                },
                controller: TextEditingController(text: prod.minQTYText()),
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
