import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/components/my_dialog.dart';
import 'package:magicposbeta/components/not_availble_widget.dart';
import 'package:magicposbeta/components/waiting_widget.dart';
import 'package:magicposbeta/lists/product_list/product_card_list_bloc/product_list_cubit.dart';
import 'package:magicposbeta/lists/product_list/product_card_list_bloc/product_list_states.dart';
import 'package:magicposbeta/screens/screens.dart';
import 'package:magicposbeta/theme/custom_colors.dart';
import 'package:magicposbeta/theme/locale/locale.dart';
import '../../components/custom_drop_down_menu.dart';
import '../../components/general_list_row.dart';
import '../../components/general_text_field.dart';
import '../../modules/info_product.dart';
import '../../theme/app_functions.dart';

class ProductList extends StatelessWidget {


  ProductList({
    super.key,
    required this.columnsNames,
    required this.onDoubleTap,
    this.columnsRatios,
    this.enableAddButton = true,
    this.exitFunction = AppFunctions.voidFunc,
    required this.columnsData,
    required this.enableDropDown,
  });

  final FocusNode _node = FocusNode();
  final ScrollController _scrollController = ScrollController();

  final List<String> columnsNames;
  final List<double>? columnsRatios;
  final Function(InfoProduct product) onDoubleTap;
  final double _width = 1000;
  final double _hieght = 540;
  final bool enableAddButton;
  final VoidCallback exitFunction;
  final List<String> Function(InfoProduct product) columnsData;
  final bool enableDropDown;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        _node.unfocus();
      },
      child: KeyboardListener(
        focusNode: _node,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 300,
              child: BlocProvider(
                create: (BuildContext context) {
                  return ProductCardListCubit(
                      () => InitialProductCardListState());
                },
                child:
                    BlocConsumer<ProductCardListCubit, ProductCardListStates>(
                  builder: (BuildContext context, ProductCardListStates state) {
                    return Stack(
                      children: [
                        SizedBox(
                          width: _width,
                          height: _hieght,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15, bottom: 15),
                                    child: SizedBox(
                                      width: _width - 88,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                            width: 250,
                                            height: 110,
                                            child: Column(
                                              children: [
                                                Text(
                                                  DiversePhrases.chooseUnit,
                                                  style: const TextStyle(
                                                      fontSize: 22),
                                                ),
                                                CustomDropDownMenu(
                                                  scaleY: 0.9,
                                                  enableSearch: false,
                                                  enable: enableDropDown,
                                                  width: 250,
                                                  title: "",
                                                  initVal: DropDownData.unit1,
                                                  controller: TextEditingController(
                                                      text: context
                                                          .read<
                                                              ProductCardListCubit>()
                                                          .dropDownText),
                                                  data: DropDownData.products,
                                                  notify: () {},
                                                  onChanged: (String value) {
                                                    context
                                                        .read<
                                                            ProductCardListCubit>()
                                                        .changeDropDown(value);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 250,
                                            height: 110,
                                            child: Column(
                                              children: [
                                                const Text(
                                                  DiversePhrases.searchBy,
                                                  style:
                                                      TextStyle(fontSize: 22),
                                                ),
                                                CustomDropDownMenu(
                                                  scaleY: 0.9,
                                                  width: 250,
                                                  title: "",
                                                  initVal: SearchTypes
                                                          .searchTypesProduct()
                                                      .first,
                                                  controller: TextEditingController(
                                                      text: context
                                                          .read<
                                                              ProductCardListCubit>()
                                                          .searchType),
                                                  data: SearchTypes
                                                      .searchTypesProduct(),
                                                  notify: () {},
                                                  onChanged: (String value) {
                                                    context
                                                        .read<
                                                            ProductCardListCubit>()
                                                        .changeSearchType(
                                                            value);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          GeneralTextField(
                                              radius: 6,
                                              height: 73,
                                              fontSize: 19.4,
                                              width: 300,
                                              title: "",
                                              prefix: const Icon(
                                                Icons.search,
                                                size: 20,
                                              ),
                                              controller: TextEditingController(
                                                  text: context
                                                      .read<
                                                          ProductCardListCubit>()
                                                      .searchText),
                                              onChangeFunc: (value) {
                                                context
                                                    .read<
                                                        ProductCardListCubit>()
                                                    .changeSearchText(value);
                                              },
                                              inputType: TextInputType.text,
                                              onlyNumber: const []),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: _hieght - 400,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        MaterialButton(
                                          height: 50,
                                          onPressed: () {
                                            exitFunction();
                                            Navigator.pop(context);
                                          },
                                          padding: EdgeInsets.zero,
                                          color: Theme.of(context).primaryColor,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(30),
                                                  bottomLeft:
                                                      Radius.circular(20)),
                                              side: BorderSide.none),
                                          child: Icon(
                                            Icons.close,
                                            size: 40,
                                            color: Theme.of(context)
                                                .secondaryTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                  height: 400,
                                  width: _width,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).fieldsColor,
                                      borderRadius: const BorderRadius.vertical(
                                          bottom: Radius.circular(30))),
                                  child: BlocBuilder<ProductCardListCubit,
                                      ProductCardListStates>(
                                    builder: (BuildContext context, state) {
                                      if (state
                                          is LoadingProductCardListState) {
                                        return const WaitingWidget();
                                      } else {
                                        return Column(
                                          children: [
                                            SizedBox(
                                              height: 50,
                                              child: GeneralListRow(
                                                ratios: columnsRatios,
                                                width: _width,
                                                thick: 1,
                                                columns: columnsNames,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            const Divider(
                                              indent: 20,
                                              thickness: 4,
                                              endIndent: 20,
                                              height: 1,
                                            ),
                                            BlocBuilder<ProductCardListCubit,
                                                    ProductCardListStates>(
                                                builder: (context, state) {
                                              if (context
                                                  .read<ProductCardListCubit>()
                                                  .products
                                                  .isEmpty) {
                                                return const NotAvailableWidget();
                                              }
                                              return Expanded(
                                                child: Theme(
                                                  data: ThemeData(
                                                    scrollbarTheme:
                                                        ScrollbarThemeData(
                                                      mainAxisMargin: 30,
                                                      thumbColor:
                                                          MaterialStatePropertyAll(
                                                        Theme.of(context)
                                                            .scaffoldBackgroundColor,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Scrollbar(
                                                    controller:
                                                        _scrollController,
                                                    trackVisibility: true,
                                                    thickness: 15,
                                                    thumbVisibility: true,
                                                    radius:
                                                        const Radius.circular(
                                                            5),
                                                    child: ListView.separated(
                                                        controller:
                                                            _scrollController,
                                                        itemBuilder:
                                                            (context, index) {
                                                          InfoProduct product = context
                                                              .read<
                                                                  ProductCardListCubit>()
                                                              .products[index];

                                                          return GestureDetector(
                                                            onDoubleTap: () {
                                                              onDoubleTap(
                                                                  product);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                              height: 50,
                                                              color: Colors
                                                                  .transparent,
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              width: _width,
                                                              child:
                                                                  GeneralListRow(
                                                                ratios:
                                                                    columnsRatios,
                                                                width: _width,
                                                                thick: 1,
                                                                columns:
                                                                    columnsData(
                                                                        product),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        separatorBuilder:
                                                            (context, index) {
                                                          return const Divider(
                                                            indent: 20,
                                                            thickness: 0,
                                                            endIndent: 20,
                                                            height: 1,
                                                          );
                                                        },
                                                        itemCount: context
                                                            .read<
                                                                ProductCardListCubit>()
                                                            .products
                                                            .length),
                                                  ),
                                                ),
                                              );
                                            }),
                                          ],
                                        );
                                      }
                                    },
                                  )),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 30,
                          bottom: 30,
                          child: MaterialButton(
                            onPressed: enableAddButton
                                ? () {
                                    Navigator.of(context).pushNamed(
                                      ProductCard.route,
                                    );
                                  }
                                : null,
                            minWidth: 60,
                            height: 60,
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1000)),
                            child: Icon(
                              enableAddButton ? Icons.add : null,
                              size: 30,
                              color: Theme.of(context).fieldsColor,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  listener:
                      (BuildContext context, ProductCardListStates state) {
                    if (state is FailureProductCardListState) {
                      print("**********************************************************************************");
                      print(state.error);
                      MyDialog.showAnimateWrongDialog(
                          context: context, title: state.error);
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
