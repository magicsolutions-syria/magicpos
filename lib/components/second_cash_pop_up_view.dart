import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magicposbeta/components/bottom_button.dart';
import 'package:magicposbeta/components/my_dialog.dart';
import 'package:magicposbeta/components/operator_button.dart';
import 'package:magicposbeta/components/printer_helper_functions.dart';
import 'package:magicposbeta/theme/custom_colors.dart';
import 'package:magicposbeta/database/database_functions.dart';
import 'package:magicposbeta/providers/products_table_provider.dart';

import '../database/functions/person_functions.dart';
import '../modules/person.dart';
import '../modules/product.dart';
import '../screens/person_card.dart';
import '../screens_data/constants.dart';
import '../theme/locale/search_types.dart';
import 'general_list.dart';
import 'general_text_field.dart';

class SecondCashPopUpView extends StatefulWidget {
  final double cashValue;
  final double totalPrice;
  final ProductsTableProvider productVal;
  final String buttonText;
  const SecondCashPopUpView({
    super.key,
    required this.cashValue,
    required this.totalPrice,
    required this.productVal,
    required this.buttonText,
  });

  @override
  State<SecondCashPopUpView> createState() => _SecondCashPopUpViewState();
}

class _SecondCashPopUpViewState extends State<SecondCashPopUpView> {
  static const platform = MethodChannel('IcodPrinter');

  late TextEditingController textEditingController1;
  late TextEditingController textEditingController2;
  late TextEditingController textEditingController3;
  late TextEditingController textEditingController4;
  late TextEditingController textEditingController5;
  late TextEditingController textEditingController7;
  late TextEditingController totalPaidController;

  double parseDouble(TextEditingController textEditingController) {
    if (textEditingController.text == "") {
      return 0;
    } else {
      return double.parse(textEditingController.text);
    }
  }

  void handleChange() {
    double ans1 = parseDouble(textEditingController1); // CASH
    double ans2 = parseDouble(textEditingController2); // should be paid
    double ans3 = parseDouble(textEditingController3); // VISA 1
    double ans4 = parseDouble(textEditingController4); // VISA 2
    double ans5 = parseDouble(textEditingController5); // CHK
    // double ans6 = parseDouble(textEditingController6); // CH

    double ans = (-ans2 + (ans1 + ans3 + ans4 + ans5));
    textEditingController7.text = (max(ans, 0)).toString();
    totalPaidController.text = (ans1 + ans3 + ans4 + ans5).toString();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (widget.buttonText == "CASH") {
      textEditingController1 =
          TextEditingController(text: widget.cashValue.toString());
    } else {
      textEditingController1 = TextEditingController(text: "0");
    }

    textEditingController2 =
        TextEditingController(text: widget.totalPrice.toString());
    if (widget.buttonText == "VISA1") {
      textEditingController3 =
          TextEditingController(text: widget.cashValue.toString());
    } else {
      textEditingController3 = TextEditingController(text: "0.0");
    }

    if (widget.buttonText == "VISA2") {
      textEditingController4 =
          TextEditingController(text: widget.cashValue.toString());
    } else {
      textEditingController4 = TextEditingController(text: "0.0");
    }

    if (widget.buttonText == "CHK") {
      textEditingController5 =
          TextEditingController(text: widget.cashValue.toString());
    } else {
      textEditingController5 = TextEditingController(text: "0.0");
    }

    textEditingController7 = TextEditingController(
        text: "${max(widget.cashValue - widget.totalPrice, 0)}");
    totalPaidController = TextEditingController(text: "0.0");
    handleChange();
  }

  @override
  Widget build(BuildContext context) {
    double _fontSize = 20;
    double _spaceHeight = 6;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SizedBox(
            width: 433.3,
            // height: 481, //TODO
            // height: ,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GeneralTextField(
                  withSpacer: true,
                  width: 270,
                  titleFontSize: _fontSize,
                  title: " : المدفوع نقدا",
                  controller: textEditingController1,
                  onChangeFunc: (String text) => handleChange(),
                ),
                SizedBox(
                  height: _spaceHeight,
                ),
                GeneralTextField(
                    withSpacer: true,
                    title: " : VISA 1",
                    titleFontSize: _fontSize,
                    controller: textEditingController3,
                    readOnly: !currentUserss.payKeys.visa1,
                    onChangeFunc: (String text) => handleChange(),
                    width: 270),
                SizedBox(
                  height: _spaceHeight,
                ),
                GeneralTextField(
                  withSpacer: true,
                  titleFontSize: _fontSize,
                  title: " : VISA 2",
                  width: 270,
                  readOnly: !currentUserss.payKeys.visa2,
                  controller: textEditingController4,
                  onChangeFunc: (String text) => handleChange(),
                ),
                SizedBox(
                  height: _spaceHeight,
                ),
                GeneralTextField(
                  withSpacer: true,
                  title: " : CHK",
                  readOnly: !currentUserss.payKeys.chk,
                  width: 270,
                  titleFontSize: _fontSize,
                  controller: textEditingController5,
                  onChangeFunc: (String text) => handleChange(),
                ),
                SizedBox(
                  height: _spaceHeight,
                ),
                OperatorButton(
                  onPressed: () {
                    final TextEditingController _controller =
                        TextEditingController();
                    showDialog(
                        context: context,
                        builder: (context) => GeneralList(
                              secondaryController: _controller,
                              searchTypes: SearchTypes.searchTypesPerson(),
                              secondaryDropDown: const ["الموردون", "الزبائن"],
                              secondaryDropDownName: "زبائن/موردون",
                              columnsNames: const [
                                "الرصيد",
                                "الباركود",
                                "الاسم بالعربي",
                                "الرقم",
                              ],
                              getData: (text, cont) async {
                                return PersonFunctions.getPersonList(
                                  personType:
                                  _controller.text == "الزبائن" ? "clients" : "suppliers",
                                  searchType: text,
                                  searchText: cont,
                                );
                              },
                              onDoubleTap: (item) async {
                                double ans1 =
                                    parseDouble(textEditingController1); // CASH
                                double ans3 = parseDouble(
                                    textEditingController3); // VISA 1
                                double ans4 = parseDouble(
                                    textEditingController4); // VISA 2
                                double ans5 =
                                    parseDouble(textEditingController5); // CHK
                                // double ans6 = parseDouble(textEditingController6); // CH
                                double ans7 =
                                    parseDouble(textEditingController7);

                                Person p = Person(
                                  item["id"],
                                  item["In"],
                                  item["Out"] + (-ans7),
                                  item["Balance"] - (-ans7),
                                  item["Barcode"],
                                  item["Name_Arabic"],
                                  item["Name_English"],
                                  item["Tel"],
                                  item["Whatsapp"],
                                  item["Email"],
                                );
                                PersonFunctions.updatePerson(
                                  p,
                                  _controller.text == "الزبائن"
                                      ? "clients"
                                      : "suppliers",
                                );
                                Map<int,List<Product>> mp = await updateProductUnit(widget.productVal.products);

                                updateAllFunctionsKeysValue(
                                  ans1,
                                  ans3,
                                  ans4,
                                  ans5,
                                  -ans7,
                                  widget.productVal.products,
                                );
                                String printerText = widget.productVal
                                    .printerText(widget.productVal.finalPrice, widget.productVal.products.products);
                                widget.productVal.clearAns();

                                widget.productVal.clearAll();
                                widget.productVal.closeRcPdCh();

                                Navigator.of(context).pop();
                                PrinterHelperFunctions.print(widget.productVal, context, printerText, mp);
                              },
                              exitFunction: () {
                                widget.productVal.closeRcPdCh();
                                widget.productVal.clearAns();
                              },
                              dataNames: const [
                                "Balance",
                                "Barcode",
                                "Name_Arabic",
                                "id",
                              ],
                              addPage: PersonCard.clientRoute,
                              columnsRatios: const [
                                .25,
                                .25,
                                .25,
                                .25,
                              ],
                              isRcPd: true,
                            ));
                  },
                  text: "الباقي على الذمة",
                  color: Theme.of(context).primaryColor,
                  enable: currentUserss.payKeys.ch &&
                      double.parse(textEditingController2.text) >
                          double.parse(totalPaidController.text),
                  width: 270,
                  height: 40,
                ),
                SizedBox(
                  height: _spaceHeight,
                ),
                const Divider(
                  indent: 20,
                  endIndent: 20,
                ),
                SizedBox(
                  height: _spaceHeight,
                ),
                GeneralTextField(
                  withSpacer: true,
                  width: 270,
                  titleFontSize: _fontSize,
                  title: " : اجمالي المدفوعات",
                  readOnly: true,
                  controller: totalPaidController,
                ),
                SizedBox(
                  height: _spaceHeight,
                ),
                GeneralTextField(
                  withSpacer: true,
                  width: 270,
                  titleFontSize: _fontSize,
                  title: " : المبلغ الواجب دفعه",
                  readOnly: true,
                  controller: textEditingController2,
                ),
                SizedBox(
                  height: _spaceHeight,
                ),
                GeneralTextField(
                  withSpacer: true,
                  width: 270,
                  titleFontSize: _fontSize,
                  title: " : المبلغ الواجب إعادته",
                  controller: textEditingController7,
                  readOnly: true,
                ),
                SizedBox(
                  height: _spaceHeight,
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            BottomButton(
              height: 55,
              title: "موافق",
              color: Theme.of(context).cancelButtonColor,
              onTap: () async {
                double ans1 = parseDouble(textEditingController1); // CASH
                double ans2 =
                parseDouble(textEditingController2); // should be paid
                double ans3 = parseDouble(textEditingController3); // VISA 1
                double ans4 = parseDouble(textEditingController4); // VISA 2
                double ans5 = parseDouble(textEditingController5); // CHK
                // double ans6 = parseDouble(textEditingController6); // CH
                double ans6 = 0;
                double ans7 = (-ans2 + (ans1 + ans3 + ans4 + ans5));
                if (ans7 >= 0) {


                  updateAllFunctionsKeysValue(ans1 - ans7, ans3, ans4, ans5,
                      ans6, widget.productVal.products);
                  updateBonusDiscount(widget.productVal.products);
                  String printerText = widget.productVal
                      .printerText(widget.productVal.finalPrice, widget.productVal.products.products);
                  widget.productVal.clearAll();
                  widget.productVal.clearAns();

                  widget.productVal.closeRcPdCh();

                  Navigator.of(context).pop();
                  await platform.invokeMethod("printText", printerText);
                } else {
                  MyDialog.showAnimateWarningDialog(
                    context: context,
                    title: "أكمل العملية",
                    isWarning: true,
                    onStart: () {
                      widget.productVal.openRcPdCh();
                    },
                    onEnd: () {
                      widget.productVal.closeRcPdCh();
                    },
                  );
                }
              },
              width: MediaQuery.of(context).size.width * 0.3466,
              leftRadius: 20,
            ),
            BottomButton(
              height: 55,
              title: "إلغاء",
              color: Theme.of(context).deleteButtonColor,
              onTap: () {
                widget.productVal.closeRcPdCh();
                Navigator.of(context).pop();
              },
              width: MediaQuery.of(context).size.width * 0.3466,
              rightRadius: 20,
            ),
          ],
        ),
      ],
    );
  }
}
