import 'package:flutter/material.dart';
import 'package:magicposbeta/bloc/product_bloc/product_bloc.dart';
import 'package:magicposbeta/bloc/shared_bloc/shared_cubit.dart';
import 'package:magicposbeta/components/page_slider/page_slider_widget.dart';
import 'package:magicposbeta/components/waiting_widget.dart';
import 'package:magicposbeta/screens/home_screen.dart';
import 'package:magicposbeta/theme/app_formatters.dart';
import 'package:magicposbeta/theme/custom_colors.dart';
import 'package:magicposbeta/theme/locale/locale.dart';

import '../components/lists/product_card_list.dart';
import '../components/my_dialog.dart';
import '../components/operator_button.dart';
import '../components/general_text_field.dart';
import '../modules/product_library/pages/products_pages.dart';

import '../screens_data/constants.dart';
import '../templates/screens_template.dart';

class ProductCard extends StatelessWidget {
  static const String route = "${HomeScreen.route}/product_card";

  ProductCard({super.key});

  TextEditingController arName = TextEditingController();
  TextEditingController enName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductCardCubit>(
      create: (BuildContext context) {
        return ProductCardCubit(() => InitialProductCardState(),context.read<SharedCubit>().currentUser);
      },
      child: ScreensTemplate(
        appBar: AppBar(
          leading: BlocBuilder<ProductCardCubit, ProductCardStates>(
            builder: (context, state) {
              return IconButton(
                onPressed: () async {
                  Map productItem = {};
                  await showDialog(
                      context: context,
                      builder: (context) => ProductCardList(
                            onDoubleTap: (item) {
                              productItem = item;
                            },
                          ));
                  if(productItem.isNotEmpty&&context.mounted) {
                   BlocProvider.of<ProductCardCubit>(context)
                      .initialProduct(productItem);
                  }
                },
                iconSize: 42,
                icon: const Icon(Icons.list),
              );
            },
          ),
        ),
        child: BlocConsumer<ProductCardCubit, ProductCardStates>(
          builder: (BuildContext context, ProductCardStates state) {
            if (state is InitialProductCardState ||
                state is LoadingProductCardState) {
              return const WaitingWidget();
            } else {
              arName.text = context.read<ProductCardCubit>().product.arName;
              enName.text = context.read<ProductCardCubit>().product.enName;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 200,
                    height: 46,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor),
                    child: Center(
                      child: Text(
                        AppFormatters.idFormat(
                            context.read<ProductCardCubit>().product.id),
                        style: const TextStyle(fontSize: 27),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 23,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 70,
                          ),
                          GeneralTextField(
                            title: FieldsNames.englishName,
                            width: 350,
                            inputType: TextInputType.text,
                            onlyNumber: const [],
                            controller: enName,
                            onChangeFunc: (text) {
                              context.read<ProductCardCubit>().product.enName =
                                  text;
                            },
                          ),
                          const Spacer(),
                          GeneralTextField(
                            title: FieldsNames.arabicName,
                            width: 350,
                            inputType: TextInputType.text,
                            onlyNumber: const [],
                            controller: arName,
                            onChangeFunc: (text) {
                              context.read<ProductCardCubit>().product.arName =
                                  text;
                            },
                          ),
                        ],
                      ),
                      PageSliderWidget(
                        pagesData: {
                          PagesNames.details:  DetailsPage(),
                          PagesNames.prices:  PricesPage(),
                          PagesNames.units:  UnitsPage(),
                          PagesNames.general:  GeneralPage(),
                        },
                        width: 1400,
                        height: 318,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 230),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OperatorButton(
                            width: 180,
                            onPressed: () =>
                                context.read<ProductCardCubit>().addProduct(),
                            text: ButtonsNames.addButton,
                            color: Theme.of(context).primaryColor,
                            enable: context
                                .read<ProductCardCubit>()
                                .addPermission()),
                        OperatorButton(
                          width: 180,
                          onPressed: () async {
                            MyDialog.showWarningOperatorDialog(
                              context: context,
                              isWarning: true,
                              title: WarningsDialogPhrases.areYouSureOfUpdateProduct,
                              onTap: () async {
                                await context
                                    .read<ProductCardCubit>()
                                    .updateProduct();
                              },
                            );
                          },
                          text: ButtonsNames.updateButton,
                          color: Theme.of(context).primaryColor,
                          enable: context
                              .read<ProductCardCubit>()
                              .updatePermission(),
                        ),
                        OperatorButton(
                            width: 180,
                            onPressed: () async {
                              MyDialog.showWarningOperatorDialog(
                                context: context,
                                isWarning: true,
                                title: WarningsDialogPhrases.areYouSureOfDeleteProduct,
                                onTap: () async {
                                  await context
                                      .read<ProductCardCubit>()
                                      .deleteProduct();
                                },
                              );
                            },
                            text: ButtonsNames.deleteButton,
                            color: Theme.of(context).deleteButtonColor,
                            enable: context
                                .read<ProductCardCubit>()
                                .deletePermission()),
                        OperatorButton(
                            width: 180,
                            onPressed: () {
                              if (context.read<ProductCardCubit>().isChanged()) {
                                MyDialog.showWarningOperatorDialog(
                                    context: context,
                                    isWarning: true,
                                    title: WarningsDialogPhrases
                                        .doYouWantCancelOperation,
                                    onTap: () {
                                      Navigator.pop(context);
                                    });
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            text: ButtonsNames.cancelButton,
                            color: Theme.of(context).cancelButtonColor,
                            enable: true)
                      ],
                    ),
                  )
                ],
              );
            }
          },
          listener: (BuildContext context, ProductCardStates state) {
            if (state is FailureProductCardState) {
              MyDialog.showAnimateWrongDialog(
                  context: context, title: state.error.toString(), );
            }
            if (state is CompletedOperationState) {
              MyDialog.showWarningDialog(
                  context: context, isWarning: false, title: state.phrase);
            }
          },
        ),
      ),
    );
  }
}
