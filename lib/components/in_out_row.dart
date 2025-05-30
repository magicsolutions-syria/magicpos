import 'package:flutter/material.dart';
import 'package:magicposbeta/bloc/in_out_product_bloc/in_out_product_bloc.dart';
import 'package:magicposbeta/bloc/shared_bloc/shared_cubit.dart';
import 'package:magicposbeta/theme/app_formatters.dart';
import 'package:magicposbeta/theme/custom_colors.dart';
import 'package:magicposbeta/modules/in_out_product.dart';
import 'edited_drop_down_menu.dart';

class InOutRow extends StatelessWidget {
  InOutRow(
    this.index, {
    super.key,
  });

  final TextEditingController _qty = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _unit = TextEditingController();
  final int index;

  final FocusNode _node = FocusNode();
  final FocusNode _node1 = FocusNode();

  @override
  Widget build(BuildContext context) {
    InOutProduct product = context.read<InOutProductCubit>().products[index];
    int priceComma = BlocProvider.of<SharedCubit>(context).settings.priceComma;
    _qty.text=product.qty.toString();
    _price.text=product.price.toString();
    _unit.text=product.name;


    _price.addListener(() async {
     context.read<InOutProductCubit>().changeProductPrice(index,_price.text );
    });

    if (index == 0 ) {
      _node.requestFocus();
    } else {
      _node.unfocus();
    }
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: EditedDropDownMenu<String>(
            width: 181.56,
            textStyle: const TextStyle(
              fontSize: 21,
            ),
            searchCallback: (entries, String query) {
              if (query.isEmpty) {
                return null;
              }
              final int index = entries.indexWhere(
                  (EditedDropdownMenuEntry<String> entry) =>
                      entry.label == query);

              return index != -1 ? index : null;
            },
            menuHeight: 200,
            inputDecorationTheme: const InputDecorationTheme(
                fillColor: Colors.white,
                filled: true,
                border: InputBorder.none),
            menuStyle: const MenuStyle(
              padding: WidgetStatePropertyAll(EdgeInsets.zero),
            ),
            initialSelection: product.names.first,
            onSelected: (value) {
               context.read<InOutProductCubit>().changeProductName(index, _unit.text);
              _price.text=context.read<InOutProductCubit>().products[index].initialPrices().toString();

            },
            controller: _unit,
            dropdownMenuEntries: product.names
                .map<EditedDropdownMenuEntry<String>>((String item) {
              return EditedDropdownMenuEntry<String>(
                value: item,
                label: item,
                style: const ButtonStyle(
                  textStyle: WidgetStatePropertyAll(
                    TextStyle(fontSize: 21),
                  ),
                ),
              );
            }).toList(),
            focusNode: FocusNode(), onChanged: (String value) {  },
          ),
        ),
        SizedBox(
          height: 45,
          width: 1,
          child: Center(
            child: Container(
              height: 25,
              width: 1,
              color: Theme.of(context).dividerSecondaryColor,
            ),
          ),
        ),
        BlocBuilder<InOutProductCubit,InOutProductStates>(
          builder: (BuildContext context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SizedBox(
                width: 233.2,
                height: 40,
                child: Center(
                  child: Text(
                    AppFormatters.formatPriceText(
                        product.currentTotalPrice, priceComma),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            );
          },
          buildWhen: (previous,current){
            if(current is ChangedProductDataState){
              return true;
            }
            return false;
          },
        ),
        SizedBox(
          height: 45,
          width: 1,
          child: Center(
            child: Container(
              height: 25,
              width: 1,
              color: Theme.of(context).dividerSecondaryColor,
            ),
          ),
        ),
        BlocBuilder<InOutProductCubit,InOutProductStates>(
          builder: (BuildContext context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: EditedDropDownMenu<String>(
                inputFormat: AppFormatters.numbersDoubleFormat(),
                keyBoardType: TextInputType.number,
                width: 233.2,
                requestFocusOnTap: true,
                enableSearch: false,
                textStyle: const TextStyle(fontSize: 21),
                searchCallback: (entries, String query) {
                  if (query.isEmpty) {
                    return null;
                  }
                  final int index = entries.indexWhere(
                          (EditedDropdownMenuEntry<String> entry) =>
                      entry.label == query);

                  return index != -1 ? index : null;
                },
                menuHeight: 200,
                inputDecorationTheme: const InputDecorationTheme(
                    fillColor: Colors.white,
                    filled: true,
                    border: InputBorder.none),
                menuStyle: const MenuStyle(
                  padding: WidgetStatePropertyAll(EdgeInsets.zero),
                ),
                initialSelection:
                AppFormatters.formatPriceText(product.price, priceComma),
                onSelected: (value) {
                  _price.text = value.toString();
                },
                controller: _price,
                dropdownMenuEntries: List.generate(product.priceGroupList().length,
                        (index) => product.priceGroupList()[index].toString())
                    .map<EditedDropdownMenuEntry<String>>((String item) {
                  return EditedDropdownMenuEntry<String>(
                    value: AppFormatters.formatPriceText(
                        double.parse(item), priceComma),
                    label: AppFormatters.formatPriceText(
                        double.parse(item), priceComma),
                    style: const ButtonStyle(
                      textStyle: WidgetStatePropertyAll(
                        TextStyle(fontSize: 21),
                      ),
                    ),
                  );
                }).toList(),
                focusNode: _node1, onChanged: (String value) {  },
              ),
            );
          },
          buildWhen: (previous,current){
            if(current is ChangedProductDataState){
              return true;
            }
            return false;
          },

        ),
        SizedBox(
          height: 45,
          width: 1,
          child: Center(
            child: Container(
              height: 25,
              width: 1,
              color: Theme.of(context).dividerSecondaryColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SizedBox(
              width: 182.56,
              child: TextField(
                controller: _qty,
                onChanged: (value) {
                  context.read<InOutProductCubit>().changeProductQty(index,value);
                  _price.text= context.read<InOutProductCubit>().products[index].price.toString();

                },
                inputFormatters: AppFormatters.numbersDoubleFormat(),
                keyboardType: TextInputType.number,
                focusNode: _node,
                decoration: const InputDecoration(border: InputBorder.none),
              )),
        ),
        SizedBox(
          height: 45,
          width: 1,
          child: Center(
            child: Container(
              height: 25,
              width: 1,
              color: Theme.of(context).dividerSecondaryColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SizedBox(
            width: 313.48,
            height: 40,
            child: Row(
              children: [
                const Spacer(),
                Text(
                  context.read<InOutProductCubit>().products[index].name,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(fontSize: 20),
                ),
                const Spacer(),
                MaterialButton(
                  onPressed: () {
                    context.read<InOutProductCubit>().removeProduct(index);
                  },
                  padding: EdgeInsets.zero,
                  color: const Color(0xFFFA7EA1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  minWidth: 34,
                  height: 34,
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
