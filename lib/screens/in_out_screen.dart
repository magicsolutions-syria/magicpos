import 'package:flutter/material.dart';
import 'package:magicposbeta/bloc/shared_bloc/shared_cubit.dart';
import 'package:magicposbeta/components/custom_drop_down_menu.dart';
import 'package:magicposbeta/components/first_in_out_row.dart';
import 'package:magicposbeta/components/general_text_field.dart';
import 'package:magicposbeta/components/my_dialog.dart';
import 'package:magicposbeta/components/operator_button.dart';
import 'package:magicposbeta/components/text_view.dart';
import 'package:magicposbeta/components/waiting_widget.dart';
import 'package:magicposbeta/screens/home_screen.dart';
import 'package:magicposbeta/theme/app_formatters.dart';
import 'package:magicposbeta/theme/custom_colors.dart';
import 'package:magicposbeta/modules/in_out_product.dart';
import 'package:magicposbeta/theme/locale/locale.dart';
import '../bloc/in_out_product_bloc/in_out_product_bloc.dart';
import '../components/general_list_row.dart';
import '../components/in_out_row.dart';
import '../lists/client_supplier_list.dart';
import '../templates/screens_template.dart';

class InOutScreen extends StatelessWidget {
  static const String route = "${HomeScreen.route}/in_out_screen";

  InOutScreen({super.key});

  TextEditingController inOutController = TextEditingController(text: "إدخال");
  TextEditingController supplierController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return InOutProductCubit(
            () => InitialInOutProductState(), context.read<SharedCubit>().currentUser);
      },
      child: ScreensTemplate(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BlocBuilder<InOutProductCubit, InOutProductStates>(
              builder: (BuildContext context, InOutProductStates state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextView(
                      title: FieldsNames.totalQty,
                      value: AppFormatters.formatPriceText(
                          context.read<InOutProductCubit>().totalQty,
                          context.read<SharedCubit>().settings.qtyComma),
                    ),
                    TextView(
                      title: FieldsNames.totalPrice,
                      value: AppFormatters.formatPriceText(
                          context.read<InOutProductCubit>().totalPrice,
                          context.read<SharedCubit>().settings.priceComma),
                    ),
                    GeneralTextField(
                      width: 330,
                      initVal: "",
                      title: FieldsNames.supplier,
                      controller: supplierController,
                      readOnly: true,
                      prefix: IconButton(
                        onPressed: () async {
                          Map person = {};
                          String personType = "";
                          await showDialog(
                            context: context,
                            builder: (context) => ClientSupplierList(
                              onDoubleTap: (Map item, String type) {
                                person = item;
                                type = personType;
                              },
                            ),
                          );
                          if (person.isNotEmpty) {
                            context
                                .read<InOutProductCubit>()
                                .initialPerson(person, personType);
                            supplierController.text =
                                context.read<InOutProductCubit>().person.arName;
                          }
                        },
                        icon: const Icon(Icons.list),
                        iconSize: 25,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
                height: 455,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                decoration: BoxDecoration(
                  color: Theme.of(context).fieldsColor,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 1248,
                      child: GeneralListRow(
                        ratios: const [0.16, 0.2, 0.2, 0.16, 0.28],
                        width: 1266,
                        thick: 1,
                        columns: [
                          "اسم المادة",
                          "الكمية",
                          "السعر",
                          "السعر الإجمالي",
                          "الوحدة"
                        ].reversed.toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(
                      thickness: 4,
                      height: 1,
                    ),
                    const FirstInOutRow(),
                    const SizedBox(
                      height: 5,
                    ),
                    BlocBuilder<InOutProductCubit, InOutProductStates>(
                      builder: (BuildContext context, state) {
                        if (context
                            .read<InOutProductCubit>()
                            .products
                            .isNotEmpty) {
                          return const Divider(
                            indent: 20,
                            thickness: 0,
                            endIndent: 20,
                            height: 1,
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                    Expanded(
                      child: ScrollbarTheme(
                        data: const ScrollbarThemeData(
                          thumbColor: WidgetStatePropertyAll(Colors.grey),
                        ),
                        child: Scrollbar(
                          trackVisibility: true,
                          controller: _scrollController,
                          thickness: 15,
                          thumbVisibility: true,
                          radius: const Radius.circular(5),
                          child: BlocConsumer<InOutProductCubit,
                              InOutProductStates>(
                            builder: (BuildContext context, state) {
                              if (state is LoadingInOutProductState) {
                                return const WaitingWidget();
                              } else {
                                List<InOutProduct> data =
                                    context.read<InOutProductCubit>().products;
                                return ListView.separated(
                                    padding: EdgeInsets.zero,
                                    controller: _scrollController,
                                    itemBuilder: (BuildContext context, index) {
                                      return Container(
                                        height: 50,
                                        color: Colors.transparent,
                                        padding: EdgeInsets.zero,
                                        child: InOutRow(
                                          index,
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const Divider(
                                        indent: 20,
                                        thickness: 0,
                                        endIndent: 20,
                                        height: 1,
                                      );
                                    },
                                    itemCount: data.length);
                              }
                            },
                            listener: (BuildContext context, Object? state) {
                              if (state is FailureInOutProductState) {
                                MyDialog.showAnimateWrongDialog(
                                  context: context,
                                  title: state.error.toString(),
                                );
                              }
                              if (state is CompletedOperationState) {
                                MyDialog.showWarningDialog(
                                    context: context,
                                    isWarning: false,
                                    title: state.phrase);
                              }
                            },
                            buildWhen: (previous, current) {
                              if (current is SuccessInOutProductState) {
                                return true;
                              } else {
                                return false;
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 270.0),
              child: BlocBuilder<InOutProductCubit, InOutProductStates>(
                builder: (BuildContext context, InOutProductStates state) {
                  inOutController.addListener(() {
                    context.read<InOutProductCubit>().operationType =
                        inOutController.text;
                  });
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OperatorButton(
                          onPressed: () async {
                            context.read<InOutProductCubit>().executeOperation(
                                context.read<SharedCubit>().settings.priceComma,
                                context.read<SharedCubit>().settings.qtyComma);
                          },
                          text: ButtonsNames.execute,
                          color: Theme.of(context).primaryColor,
                          enable: true),
                      OperatorButton(
                          onPressed: () {
                            if (context
                                .read<InOutProductCubit>()
                                .products
                                .isNotEmpty) {
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
                          enable: true),
                      CustomDropDownMenu(
                        initVal: SearchTypes.inOperation,
                        title: FieldsNames.inOut,
                        data: context.read<InOutProductCubit>().operations(),
                        enable:
                            context.read<InOutProductCubit>().enableDropDown(),
                        controller: inOutController,
                        notify: () {}, onChanged: (String value) {  },
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
