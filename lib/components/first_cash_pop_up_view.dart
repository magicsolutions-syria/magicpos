import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magicposbeta/components/bottom_button.dart';
import 'package:magicposbeta/components/general_text_field.dart';
import 'package:magicposbeta/components/my_dialog.dart';
import 'package:magicposbeta/components/printer_helper_functions.dart';
import 'package:magicposbeta/database/database_functions.dart';
import 'package:magicposbeta/providers/products_table_provider.dart';

import '../modules/product.dart';

class FirstCashPopUpView extends StatefulWidget {
  final double cashValue;
  final double totalPrice;
  final ProductsTableProvider productVal;
  final String buttonText;
  const FirstCashPopUpView({
    super.key,
    required this.cashValue,
    required this.totalPrice,
    required this.productVal,
    required this.buttonText,
  });

  @override
  State<FirstCashPopUpView> createState() => _FirstCashPopUpViewState();
}

class _FirstCashPopUpViewState extends State<FirstCashPopUpView> {
  static const platform = MethodChannel('IcodPrinter');

  late TextEditingController textEditingController1;
  late TextEditingController textEditingController2;
  late TextEditingController textEditingController3;

  @override
  void initState() {
    super.initState();
    textEditingController1 =
        TextEditingController(text: widget.cashValue.toString());
    textEditingController2 =
        TextEditingController(text: widget.totalPrice.toString());
    textEditingController3 =
        TextEditingController(text: "${widget.cashValue - widget.totalPrice}");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SizedBox(
            width: 433.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GeneralTextField(
                  withSpacer: true,
                  titleFontSize: 20,
                  title: widget.buttonText == "CASH"
                      ? " : المدفوع نقدا"
                      : ":${widget.buttonText}",
                  controller: textEditingController1,
                  onChangeFunc: (String text) {
                    if (text != "") {
                      textEditingController3.text =
                          (-widget.totalPrice + double.parse(text)).toString();
                      setState(() {});
                    } else {
                      textEditingController3.text =
                          (-widget.totalPrice).toString();
                    }
                  },
                  width: 270,
                ),
                const SizedBox(
                  height: 6,
                ),
                GeneralTextField(
                    withSpacer: true,
                    titleFontSize: 20,
                    title: " : المبلغ الواجب دفعه",
                    readOnly: true,
                    controller: textEditingController2,
                    width: 270),
                const SizedBox(
                  height: 6,
                ),
                GeneralTextField(
                  withSpacer: true,
                  titleFontSize: 20,
                  title: " : المبلغ الواجب إعادته",
                  readOnly: true,
                  controller: textEditingController3,
                  width: 270,
                )
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BottomButton(
              title: "موافق",
              height: 55,
              color: Colors.green,
              onTap: () async {
                if (double.parse(textEditingController3.text) >= 0.0) {
                  String printerText = widget.productVal
                      .printerText(widget.productVal.finalPrice, widget.productVal.products.products);
                  widget.productVal.clearAns();

                  Map<int,List<Product>> mp = await updateProductUnit(widget.productVal.products);
                  updateFunctionsKeysValue(
                      widget.buttonText, widget.productVal.finalPrice);
                  updateBonusDiscount(widget.productVal.products);
                  widget.productVal.clearAll();
                  widget.productVal.closeRcPdCh();

                  Navigator.of(context).pop();
                  PrinterHelperFunctions.print(widget.productVal, context, printerText, mp);
                } else {
                  MyDialog.showAnimateWarningDialog(
                    context: context,
                    isWarning: true,
                    title: "أكمل العملية",
                    onStart: () {
                      widget.productVal.openRcPdCh();
                    },
                    onEnd: () {
                      widget.productVal.closeRcPdCh();
                    },
                  );
                  // showCustomDialog(context, "أكمل العملية");
                }
              },
              width: MediaQuery.of(context).size.width * .3466,
              leftRadius: 20,
            ),
            BottomButton(
              title: "إلغاء",
              height: 55,
              color: Colors.red,
              onTap: () {
                widget.productVal.closeRcPdCh();
                Navigator.of(context).pop();
              },
              width: MediaQuery.of(context).size.width * .3466,
              rightRadius: 20,
            ),
          ],
        ),
      ],
    );
  }
}
