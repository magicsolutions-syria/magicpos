import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:magicposbeta/components/cash_view.dart';
import 'package:magicposbeta/components/ch_view.dart';
import 'package:magicposbeta/components/my_dialog.dart';
import 'package:magicposbeta/components/pd_view.dart';
import 'package:magicposbeta/components/rc_view.dart';
import 'package:magicposbeta/modules/users_library/permissions_classes/pay_key_permission.dart';
import 'package:magicposbeta/providers/products_table_provider.dart';
import 'package:magicposbeta/screens_data/constants.dart';
import 'package:provider/provider.dart';
import "../screens_data/functions_keys_data.dart";
import "../database/database_functions.dart";

class RestControlPanel extends StatelessWidget {
  const RestControlPanel({super.key});

  static const platform = MethodChannel('IcodPrinter');

  double setFontSize(String text) {
    switch (text) {
      case "C":
        return 52;
      case "VISA1":
      case "VISA2":
        return 19.2;
      default:
        return 26;
    }
  }

  void handleClick(ProductsTableProvider productVal, BuildContext context,
      String text) async {
    switch (text) {
      case "Enter":
        if (productVal.isRfToggled) {
          try {
            productVal.removeAtIndex();
          } catch (e) {
            MyDialog.showAnimateWarningDialog(
              context: context,
              title: "يرجى ادخال باركود",
              isWarning: true,
              onStart: () {
                productVal.openRcPdCh();
              },
              onEnd: () {
                productVal.closeRcPdCh();
              },
            );
          }
        } else {
          enterFunction(
            productVal.ans,
            productVal.addProduct,
            context,
            productVal.qty,
            productVal,
            priceType: productVal.priceType,
          );
          productVal.setQty(1);
        }
        productVal.pressKey("C");
        break;
      case "X":
        if (productVal.ans.isEmpty) {
          MyDialog.showAnimateWarningDialog(
            context: context,
            title: "يرجى ادخال كمية",
            isWarning: true,
            onStart: () {
              productVal.openRcPdCh();
            },
            onEnd: () {
              productVal.closeRcPdCh();
            },
          );
          productVal.pressKey("C");
        } else {
          try {
            productVal.setQty(productVal.getAnsAsDouble());
          } catch (e) {
            MyDialog.showAnimateWarningDialog(
              context: context,
              title: "كمية خاطئة",
              isWarning: true,
              onStart: () {
                productVal.openRcPdCh();
              },
              onEnd: () {
                productVal.closeRcPdCh();
              },
            );
            productVal.pressKey("C");
          }
        }
        break;
      case "C":
        productVal.pressKey("C");
        productVal.diselectedProduct();
        productVal.setQty(1);
        break;
      case "CHK":
      case "VISA1":
      case "VISA2":
      case "CASH":
        productVal.openRcPdCh();
        // print(text);
        try {
          if (productVal.products.isEmpty()) {
            MyDialog.showAnimateWarningDialog(
              context: context,
              isWarning: true,
              title: "يرجى ادخال بعض المواد",
              onStart: () {
                productVal.openRcPdCh();
              },
              onEnd: () {
                productVal.closeRcPdCh();
              },
            );
            productVal.closeRcPdCh();
            productVal.clearAll();
          } else {
            bool empty = productVal.ans == "0";
            double ans = 0;
            if (!empty) {
              ans = productVal.getAnsAsDouble();
            }
            if (productVal.ans == "0" || ans == productVal.finalPrice) {
              String printerText = "";
              if (productVal.printerOn) {
                printerText = productVal.printerText(productVal.finalPrice, productVal.products.products);
              }

              updateProductUnit(productVal.products);
              updateFunctionsKeysValue(text, productVal.finalPrice);
              updateBonusDiscount(productVal.products);
              productVal.clearAll();
              productVal.closeRcPdCh();
              if (productVal.printerOn) {
                await platform.invokeMethod("printText", printerText);
              }
            } else {
              productVal.openRcPdCh();
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) => ListView(
                  children: [
                    const SizedBox(
                      height: 0,
                    ),
                    Dialog(
                      child: CashPanel(
                        totalPrice: productVal.finalPrice,
                        cashValue: ans,
                        productVal: productVal,
                        isEmpty: empty,
                        buttonText: text,
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          productVal.pressKey("C");
        } catch (e) {
          if (context.mounted) {
            MyDialog.showAnimateWarningDialog(
              context: context,
              title: "سعر خاطئ",
              isWarning: true,
              onStart: () {
                productVal.openRcPdCh();
              },
              onEnd: () {
                productVal.closeRcPdCh();
              },
            );
          }

          productVal.closeRcPdCh();
        }
        break;
      case "RC":
        productVal.openRcPdCh();
        try {
          double ans = productVal.getAnsAsDouble();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => RCView(
              price: ans,
              productVal: productVal,
            ),
          );
        } catch (e) {
          MyDialog.showAnimateWarningDialog(
            context: context,
            title: "Invalid Price",
            isWarning: true,
            onStart: () {
              productVal.openRcPdCh();
            },
            onEnd: () {
              productVal.closeRcPdCh();
            },
          );
          productVal.closeRcPdCh();
        }
        productVal.clearAns();
        break;
      case "PD":
        productVal.openRcPdCh();
        try {
          double ans = productVal.getAnsAsDouble();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => PDView(
              price: ans,
              productVal: productVal,
            ),
          );
        } catch (e) {
          MyDialog.showAnimateWarningDialog(
            context: context,
            title: "سعر خاطئ",
            isWarning: true,
            onStart: () {
              productVal.openRcPdCh();
            },
            onEnd: () {
              productVal.closeRcPdCh();
            },
          );
          productVal.closeRcPdCh();
        }
        productVal.pressKey("C");
        break;
      case "CH":
        try {
          if (productVal.productsLength == 0) {
            throw Exception();
          }
          productVal.openRcPdCh();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => CHView(
              productVal: productVal,
            ),
          );
        } catch (e) {
          MyDialog.showAnimateWarningDialog(
            context: context,
            title: "قائمة المواد فارغة",
            isWarning: true,
            onStart: () {
              productVal.openRcPdCh();
            },
            onEnd: () {
              productVal.closeRcPdCh();
            },
          );
          productVal.closeRcPdCh();
        }
        productVal.pressKey("C");
        break;
      default:
        productVal.pressKey(text);
        break;
    }
  }

  bool handlePermission(String id) {
    PayKeyPermission pkPerm = currentUserss.payKeys;

    switch (id) {
      case "RC":
        return pkPerm.rc;
      case "PD":
        return pkPerm.pd;
      case "CHK":
        return pkPerm.chk;
      case "CH":
        return pkPerm.ch;
      case "VISA1":
        return pkPerm.visa1;
      case "VISA2":
        return pkPerm.visa2;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(12),
        ),
        border: Border(
          left: BorderSide(),
          bottom: BorderSide(),
          // top: BorderSide(),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: restControlPanelKeys.map((e) {
          return Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: e.map((w) {
                return Expanded(
                  flex: w["flex"],
                  child: Consumer<ProductsTableProvider>(
                    builder: (context, productVal, child) => Container(
                      decoration: BoxDecoration(
                        color: w["color"],
                        border: Border(
                          top: BorderSide(),
                          right: BorderSide(),
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: w["txt"] == "0" ? Radius.circular(12) : Radius.zero,
                          topLeft: w["txt"] == "C" ? Radius.circular(12) : Radius.zero,
                        ),
                      ),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          side: BorderSide.none,
                          borderRadius: BorderRadius.only(
                            bottomLeft: w["txt"] == "0" ? Radius.circular(12) : Radius.zero,
                            topLeft: w["txt"] == "C" ? Radius.circular(12) : Radius.zero,
                          ),
                        ),
                        onPressed: handlePermission(w["txt"])
                            ? () {
                                handleClick(productVal, context, w["txt"]);
                              }
                            : null,
                        child: Text(
                          w["txt"],
                          style: TextStyle(
                            fontSize: setFontSize(w["txt"]),
                            color:
                                w["txt"] == "C" ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}
