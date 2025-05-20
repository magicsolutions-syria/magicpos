import 'package:flutter/material.dart';
import 'package:magicposbeta/components/first_cash_pop_up_view.dart';
import 'package:magicposbeta/components/second_cash_pop_up_view.dart';
import 'package:magicposbeta/providers/products_table_provider.dart';

class CashPanel extends StatelessWidget {
  final double totalPrice;
  final double cashValue;
  final ProductsTableProvider productVal;
  final bool isEmpty;
  final String buttonText;
  final bool isRest;
  const CashPanel({
    super.key,
    required this.totalPrice,
    required this.cashValue,
    required this.productVal,
    this.isEmpty = false,
    required this.buttonText,
    this.isRest = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      width: MediaQuery.of(context).size.width * 0.3466,
      height: (totalPrice <= cashValue && !isRest)
          ? MediaQuery.of(context).size.height * .385
          : MediaQuery.of(context).size.height * .88,
      padding: const EdgeInsets.only(top: 30),
      //padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: (totalPrice <= cashValue && !isRest)
          ? FirstCashPopUpView(
              cashValue: cashValue,
              totalPrice: totalPrice,
              productVal: productVal,
              buttonText: buttonText,
            )
          : SecondCashPopUpView(
              cashValue: cashValue,
              totalPrice: totalPrice,
              productVal: productVal,
              buttonText: buttonText,
            ),
    );
  }
}
