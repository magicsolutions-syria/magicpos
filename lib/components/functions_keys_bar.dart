import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:magicposbeta/components/custom_tooltip.dart";
import "package:magicposbeta/components/general_list.dart";
import "package:magicposbeta/components/my_dialog.dart";
import "package:magicposbeta/components/operator_button.dart";
import "package:magicposbeta/database/database_functions.dart";
import "package:magicposbeta/modules/users_library/permissions_classes/operation_key_permission.dart";
import "package:magicposbeta/modules/users_library/permissions_classes/pay_key_permission.dart";
import "package:magicposbeta/modules/users_library/users_pages/pay_key_page.dart";
import "package:magicposbeta/providers/depts_provider.dart";
import "package:magicposbeta/providers/products_table_provider.dart";
import "package:magicposbeta/screens/product_card.dart";
import "package:magicposbeta/screens_data/constants.dart";
import "package:magicposbeta/theme/locale/locale.dart";
import "package:provider/provider.dart";
import "../database/functions/product_functions.dart";
import "../screens_data/functions_keys_data.dart";

class FunctionsKeysBar extends StatefulWidget {
  const FunctionsKeysBar({super.key});

  static const double borderWidth = 1;

  @override
  State<FunctionsKeysBar> createState() => _FunctionsKeysBarState();
}

class _FunctionsKeysBarState extends State<FunctionsKeysBar> {
  static const platform = MethodChannel('IcodPrinter');

  Color setButtonColor(Map e, ProductsTableProvider productsTableProvider) {
    bool isFirstClient = e["id"] == 11;
    bool isSecondClient = e["id"] == 9;
    bool isThirdClient = e["id"] == 7;

    if ((isFirstClient && !productsTableProvider.firstClient()) ||
        (isSecondClient && !productsTableProvider.secondClient()) ||
        (isThirdClient && !productsTableProvider.thirdClient())) {
      return Colors.orange;
    }

    if (e["id"] == 5) {
      return (productsTableProvider.isPrinterOn ? e["color"] : Colors.red);
    }

    return e["color"];
  }

  @override
  void initState() {
    super.initState();
    connectToPrinter();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    disconnectToPrinter();
  }

  void connectToPrinter() async {
    await platform.invokeMethod("connect");
  }
  void disconnectToPrinter() async {
    print("disconnect");
    await platform.invokeMethod("disconnect");
  }

  void handleClick(int id, ProductsTableProvider productsTableProvider,
      BuildContext context) async {
    switch (id) {
      case 0:
        print("hatem");
        if (!productsTableProvider.isProductSelected) {
          MyDialog.showAnimateWarningDialog(
              context: context, isWarning: true, title: "الراجاء اختيار مادة");
        } else {
          try {
            double amount = productsTableProvider.getAnsAsDouble();
            productsTableProvider.changeProductPriceAtIndex(amount);
            productsTableProvider.pressKey("C");
          } catch (e) {
            MyDialog.showAnimateWarningDialog(
                context: context, isWarning: true, title: "السعر غير مناسب");
          }
        }
        break;
      case 1:
        productsTableProvider.openRcPdCh();
        ScrollController _scrollController = ScrollController();
        TextEditingController controller = TextEditingController();
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width * .54,
              height: MediaQuery.of(context).size.height * .5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: _scrollController,
                      interactive: true,
                      thickness: 15,
                      radius: const Radius.circular(10),
                      child: TextField(
                        scrollController: _scrollController,
                        minLines: 4,
                        maxLines: 9,
                        controller: controller,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(fontSize: 23),
                        decoration: InputDecoration(
                          hintText: "  أضف نصا للطباعة",
                          hintStyle: const TextStyle(fontSize: 23),
                          hintTextDirection: TextDirection.rtl,
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1.5),
                              borderRadius: BorderRadius.circular(10)),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1.5),
                              borderRadius: BorderRadius.circular(10)),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OperatorButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          productsTableProvider.closeRcPdCh();
                          await platform.invokeMethod(
                              "printText", controller.text);
                        },
                        text: "طباعة",
                        color: Colors.blue,
                        enable: true,
                      ),
                      OperatorButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          productsTableProvider.closeRcPdCh();
                        },
                        text: "إلغاء",
                        color: Colors.greenAccent,
                        enable: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
        break;
      case 2:
        TextEditingController controller = TextEditingController();
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => GeneralList(
            secondaryController: controller,
            searchTypes: SearchTypes.searchTypesUser(),
            secondaryDropDown: const [
              "الوحدة الأولى",
              "الوحدة الثانية",
              "الوحدة الثالثة",
            ],
            secondaryDropDownName: 'اختيار الوحدة',
            columnsNames: const [
              "الكمية",
              "سعر المستهلك",
              "الاسم بالعربي",
            ],
            getData: (searchType, text) async {
              String secondCondition = "";
              print(controller.text);
              switch (controller.text) {
                case "الوحدة الأولى":
                case "":
                  secondCondition = "unit_one_id>0";
                  break;
                case "الوحدة الثانية":
                  secondCondition = "unit_two_id>0";
                  break;
                case "الوحدة الثالثة":
                  secondCondition = "unit_three_id>0";
                  break;
              }
              List<Map> res = await ProductFunctions.getProductList(
                  searchText: text,
                  searchType: searchType,
                  secondCondition: secondCondition);
              return res;
            },
            onDoubleTap: (item) {},
            dataNames: const [
              "current_quantity_1",
              "piece_price_1",
              "ar_name",
            ],
            columnsRatios: const [0.33333, 0.33333, 0.3333],
            addPage: ProductCard.route,
            enableAddButton: false,
            commas: [
              productsTableProvider.qtyCommas,
              productsTableProvider.priceCommas,
              -1,
              -1
            ],
            dataNamesFunction: () {
              return [
                "current_quantity_${controller.text == "الوحدة الأولى" || controller.text == "" ? 1 : (controller.text == "الوحدة الثانية") ? 2 : 3}",
                "piece_price_${controller.text == "الوحدة الأولى" || controller.text == "" ? 1 : (controller.text == "الوحدة الثانية") ? 2 : 3}",
                "ar_name",
              ];
            },
          ),
        );
        break;
      case 3:
        await platform.invokeMethod("openCash");
        break;
      case 4:
        TextEditingController controller = TextEditingController();
        productsTableProvider.openRcPdCh();
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => GeneralList(
            secondaryController: controller,
            searchTypes: SearchTypes.searchTypesUser(),
            secondaryDropDown: const [
              "الوحدة الأولى",
              "الوحدة الثانية",
              "الوحدة الثالثة",
            ],
            secondaryDropDownName: 'اختيار الوحدة',
            columnsNames: const [
              "الباركود",
              "الاسم بالإنكليزي",
              "الاسم بالعربي",
              "الرقم",
            ],
            getData: (searchType, text) async {
              String secondCondition = "";
              print(controller.text);
              switch (controller.text) {
                case "الوحدة الأولى":
                case "":
                  secondCondition = "unit_one_id>0";
                  break;
                case "الوحدة الثانية":
                  secondCondition = "unit_two_id>0";
                  break;
                case "الوحدة الثالثة":
                  secondCondition = "unit_three_id>0";
                  break;
              }
              List<Map> res = await ProductFunctions.getProductList(
                  searchText: text,
                  searchType: searchType,
                  secondCondition: secondCondition);
              return res;
            },
            onDoubleTap: (item) {
              String barcode = "";

              switch (controller.text) {
                case "الوحدة الأولى":
                case "":
                  barcode = item["code_1"];
                  break;
                case "الوحدة الثانية":
                  barcode = item["code_2"];
                  break;
                case "الوحدة الثالثة":
                  barcode = item["code_3"];
                  break;
              }
              print(item);
              enterFunction(
                barcode,
                productsTableProvider.addProduct,
                context,
                1,
                productsTableProvider,
                priceType: productsTableProvider.priceType,
              );
              productsTableProvider.closeRcPdCh();
            },
            dataNames: const [
              "code_1",
              "en_name",
              "ar_name",
              "id",
            ],
            columnsRatios: const [0.25, 0.3, 0.3, 0.15],
            addPage: ProductCard.route,
            exitFunction: () {
              productsTableProvider.closeRcPdCh();
            },
            commas: [-1, -1, -1, -1],
          ),
        );
        break;
      case 5:
        productsTableProvider.togglePrinter();
        if (productsTableProvider.isPrinterOn) {
          try {
            await platform.invokeMethod("connect");
          } catch (e) {
            print("hatem");
          }
        } else {
          try {
            await platform.invokeMethod("disconnect");
          } catch (e) {
            print("hatem");
          }
        }
        break;
      case 6:
        if (productsTableProvider.products.isEmpty()) {
          MyDialog.showAnimateWarningDialog(
            context: context,
            title: "قائمة المواد فارغة",
            isWarning: true,
            onStart: () {
              productsTableProvider.openRcPdCh();
            },
            onEnd: () {
              productsTableProvider.closeRcPdCh();
            },
          );
        } else {
          updateFunctionsKeysValue(
              "ac", productsTableProvider.products.totalPrice);
          productsTableProvider.clearAll();
          productsTableProvider.diselectedProduct();
        }
        break;
      case 7:
        productsTableProvider.diselectedProduct();
        if (!productsTableProvider.thirdClient()) {
          try {
            productsTableProvider.storeCurrentProductsAtClient(2);
          } catch (e) {
            MyDialog.showAnimateWarningDialog(
              context: context,
              title: "يرجى ادخال بعض المواد",
              isWarning: true,
              onStart: () {
                productsTableProvider.openRcPdCh();
              },
              onEnd: () {
                productsTableProvider.closeRcPdCh();
              },
            );
          }
        } else {
          try {
            productsTableProvider.getProductsFromClientAt(2);
          } catch (e) {
            MyDialog.showAnimateWarningDialog(
              context: context,
              title: "يجب أن تكون قائمة المواد فارغة",
              isWarning: true,
              onStart: () {
                productsTableProvider.openRcPdCh();
              },
              onEnd: () {
                productsTableProvider.closeRcPdCh();
              },
            );
          }
        }
        productsTableProvider.pressKey("C");
        break;
      case 8:
        try {
          if (productsTableProvider.isRfToggled) {
            productsTableProvider.dHoldRf();
          } else {
            updateFunctionsKeysValue(
                "rf",
                productsTableProvider.products
                    .getProductAtIndex(
                        productsTableProvider.selectedProductIndex)
                    .calcTotalPrice());
            productsTableProvider.removeAtIndex();
          }
        } catch (e) {
          MyDialog.showAnimateWarningDialog(
            context: context,
            title: "يرجى تحديد مادة",
            isWarning: true,
            onStart: () {
              productsTableProvider.openRcPdCh();
            },
            onEnd: () {
              productsTableProvider.closeRcPdCh();
            },
          );
        }
        productsTableProvider.diselectedProduct();
        productsTableProvider.pressKey("C");
        break;
      case 9:
        productsTableProvider.diselectedProduct();
        if (!productsTableProvider.secondClient()) {
          try {
            productsTableProvider.storeCurrentProductsAtClient(1);
          } catch (e) {
            MyDialog.showAnimateWarningDialog(
              context: context,
              title: "يرجى ادخال بعض المواد",
              isWarning: true,
              onStart: () {
                productsTableProvider.openRcPdCh();
              },
              onEnd: () {
                productsTableProvider.closeRcPdCh();
              },
            );
          }
        } else {
          try {
            productsTableProvider.getProductsFromClientAt(1);
          } catch (e) {
            MyDialog.showAnimateWarningDialog(
              context: context,
              title: "يجب أن تكون قائمة المواد فارغة",
              isWarning: true,
              onStart: () {
                productsTableProvider.openRcPdCh();
              },
              onEnd: () {
                productsTableProvider.closeRcPdCh();
              },
            );
          }
        }
        productsTableProvider.pressKey("C");
        break;
      case 10:
        if (productsTableProvider.isProductSelected) {
          try {
            productsTableProvider.changeQtyAtIndex(double.parse(
                productsTableProvider.getAnsAsDouble().toStringAsFixed(2)));
            productsTableProvider.pressKey("C");
          } catch (e) {
            MyDialog.showAnimateWarningDialog(
              context: context,
              title: "كمية خاطئة",
              isWarning: true,
              onStart: () {
                productsTableProvider.openRcPdCh();
              },
              onEnd: () {
                productsTableProvider.closeRcPdCh();
              },
            );
            productsTableProvider.pressKey("C");
          }
        } else {
          MyDialog.showAnimateWarningDialog(
            context: context,
            title: "يرجى تحديد مادة",
            isWarning: true,
            onStart: () {
              productsTableProvider.openRcPdCh();
            },
            onEnd: () {
              productsTableProvider.closeRcPdCh();
            },
          );
          productsTableProvider.pressKey("C");
        }
        break;
      case 11:
        productsTableProvider.diselectedProduct();
        if (!productsTableProvider.firstClient()) {
          try {
            productsTableProvider.storeCurrentProductsAtClient(0);
          } catch (e) {
            MyDialog.showAnimateWarningDialog(
              context: context,
              title: "يرجى ادخال بعض المواد",
              isWarning: true,
              onStart: () {
                productsTableProvider.openRcPdCh();
              },
              onEnd: () {
                productsTableProvider.closeRcPdCh();
              },
            );
          }
        } else {
          try {
            productsTableProvider.getProductsFromClientAt(0);
          } catch (e) {
            MyDialog.showAnimateWarningDialog(
              context: context,
              title: "يجب أن تكون قائمة المواد فارغة",
              isWarning: true,
              onStart: () {
                productsTableProvider.openRcPdCh();
              },
              onEnd: () {
                productsTableProvider.closeRcPdCh();
              },
            );
          }
        }
        productsTableProvider.pressKey("C");
        break;
      case 12:
        try {
          double ans = productsTableProvider.getAnsAsDouble();
          productsTableProvider.addBonus(ans);
        } catch (e) {
          MyDialog.showAnimateWarningDialog(
            context: context,
            title: "قيمة خاطئة",
            isWarning: true,
            onStart: () {
              productsTableProvider.openRcPdCh();
            },
            onEnd: () {
              productsTableProvider.closeRcPdCh();
            },
          );
        }
        productsTableProvider.pressKey("C");
        break;
      case 13:
        try {
          double ans = productsTableProvider.getAnsAsDouble();
          if (ans > 0.0 && ans <= 100.0) {
            productsTableProvider.addBonus(ans, isPercentage: true);
          } else {
            MyDialog.showAnimateWarningDialog(
              context: context,
              title: "قيمة خاطئة",
              isWarning: true,
              onStart: () {
                productsTableProvider.openRcPdCh();
              },
              onEnd: () {
                productsTableProvider.closeRcPdCh();
              },
            );
          }
        } catch (e) {
          MyDialog.showAnimateWarningDialog(
            context: context,
            title: "قيمة خاطئة",
            isWarning: true,
            onStart: () {
              productsTableProvider.openRcPdCh();
            },
            onEnd: () {
              productsTableProvider.closeRcPdCh();
            },
          );
        }
        productsTableProvider.pressKey("C");
        break;
      case 14:
        try {
          double ans = productsTableProvider.getAnsAsDouble();
          productsTableProvider.addDiscount(ans);
        } catch (e) {
          MyDialog.showAnimateWarningDialog(
            context: context,
            title: "قيمة خاطئة",
            isWarning: true,
            onStart: () {
              productsTableProvider.openRcPdCh();
            },
            onEnd: () {
              productsTableProvider.closeRcPdCh();
            },
          );
        }
        productsTableProvider.pressKey("C");
        break;
      case 15:
        try {
          double ans = productsTableProvider.getAnsAsDouble();
          if (ans > 0.0 && ans <= 100.0) {
            productsTableProvider.addDiscount(ans, isPercentage: true);
          } else {
            MyDialog.showAnimateWarningDialog(
              context: context,
              title: "قيمة خاطئة",
              isWarning: true,
              onStart: () {
                productsTableProvider.openRcPdCh();
              },
              onEnd: () {
                productsTableProvider.closeRcPdCh();
              },
            );
          }
        } catch (e) {
          MyDialog.showAnimateWarningDialog(
            context: context,
            title: "قيمة خاطئة",
            isWarning: true,
            onStart: () {
              productsTableProvider.openRcPdCh();
            },
            onEnd: () {
              productsTableProvider.closeRcPdCh();
            },
          );
        }
        productsTableProvider.pressKey("C");
        break;
      case 16:
        break;
      case 17:
        break;
      default:
        productsTableProvider.diselectedProduct();
        productsTableProvider.pressKey("C");
    }
  }

  bool handlePermission(id) {
    OperationKeysPermission opPerm = currentUserss.operationKeys;
    PayKeyPermission pkPerm = currentUserss.payKeys;

    switch (id) {
      case 0:
        return opPerm.changePrice;
      case 1:
        return opPerm.data;
      case 3:
        return opPerm.drawer;
      case 5:
        return opPerm.printer;
      case 6:
        return opPerm.allCancel;
      case 8:
        return opPerm.RF;
      case 10:
        return opPerm.changeQty;
      case 12:
        return pkPerm.plus;
      case 13:
        return pkPerm.plusPer;
      case 14:
        return pkPerm.minus;
      case 15:
        return pkPerm.minusPer;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsTableProvider>(
      builder: (context, productsTableProvider, child) =>
          Consumer<DeptsProvider>(builder: (context, value, child) {
        if (!value.isDepts) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: functionKeysData.map(
              (e) {
                return Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: MaterialButton(
                          disabledColor: Colors.grey[400],
                          color: e[0]["id"] == 8 &&
                                  productsTableProvider.isRfToggled
                              ? Colors.green
                              : e[0]["color"],
                          onLongPress:
                              e[0]["id"] == 8 && handlePermission(e[0]["id"])
                                  ? () {
                                      productsTableProvider.holdRf();
                                    }
                                  : null,
                          onPressed: e[0]["id"] == 16
                              ? null
                              : (handlePermission(e[0]["id"])
                                  ? () {
                                      handleClick(e[0]["id"],
                                          productsTableProvider, context);
                                    }
                                  : null),
                          shape: Border(
                            left: const BorderSide(
                              width: FunctionsKeysBar.borderWidth,
                            ),
                            right: const BorderSide(),
                            top: e == functionKeysData[0]
                                ? const BorderSide(
                                    width: FunctionsKeysBar.borderWidth,
                                  )
                                : BorderSide.none,
                            bottom: e ==
                                    functionKeysData[
                                        functionKeysData.length - 1]
                                ? const BorderSide(
                                    width: FunctionsKeysBar.borderWidth,
                                  )
                                : const BorderSide(),
                          ),
                          child: (e[0].containsKey("icon"))
                              ? Icon(
                                  e[0]["icon"],
                                  size: 50,
                                )
                              : Text(
                                  e[0]["txt"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: e[0]["fontSize"],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      Expanded(
                        child: MaterialButton(
                          disabledColor: Colors.grey[400],
                          color: setButtonColor(e[1], productsTableProvider),
                          onPressed: e[1]["id"] == 17
                              ? () {
                                  value.toggleTrue();
                                  productsTableProvider.diselectedProduct();
                                }
                              : (handlePermission(e[1]["id"])
                                  ? () {
                                      handleClick(e[1]["id"],
                                          productsTableProvider, context);
                                    }
                                  : null),
                          shape: Border(
                            right: const BorderSide(
                              width: FunctionsKeysBar.borderWidth,
                            ),
                            top: e == functionKeysData[0]
                                ? const BorderSide(
                                    width: FunctionsKeysBar.borderWidth,
                                  )
                                : BorderSide.none,
                            bottom: e ==
                                    functionKeysData[
                                        functionKeysData.length - 1]
                                ? const BorderSide(
                                    width: FunctionsKeysBar.borderWidth,
                                  )
                                : const BorderSide(),
                          ),
                          child: e[1].containsKey("icon")
                              ? Icon(
                                  e[1]["icon"],
                                  size: 50,
                                )
                              : Text(
                                  e[1]["txt"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: e[1]["fontSize"],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),
          );
        } else {
          // isDept
          List<Widget> children = [];
          for (int i = 0; i < value.depts.length; i += 2) {
            children.add(
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: MaterialButton(
                        disabledColor: Colors.grey[400],
                        color: Colors.lightBlue,
                        onPressed: currentUserss.operationKeys.deptAccess
                            ? () {
                                try {
                                  productsTableProvider.addProduct(
                                    value.depts[i]["name"],
                                    1,
                                    productsTableProvider.getAnsAsDouble(),
                                    "-2",
                                    -1,
                                    -1,
                                    -1,
                                    value.depts[i]["department"],
                                    value.depts[i]["Print_Name"],
                                    -1
                                  );
                                } catch (e) {
                                  MyDialog.showAnimateWarningDialog(
                                    context: context,
                                    title: "سعر خاطئ",
                                    isWarning: true,
                                    onStart: () {
                                      productsTableProvider.openRcPdCh();
                                    },
                                    onEnd: () {
                                      productsTableProvider.closeRcPdCh();
                                    },
                                  );
                                }
                                productsTableProvider.pressKey("C");
                              }
                            : null,
                        shape: Border(
                          left: const BorderSide(
                            width: FunctionsKeysBar.borderWidth,
                          ),
                          // right: const BorderSide(),
                          top: i == 0
                              ? const BorderSide(
                                  width: FunctionsKeysBar.borderWidth,
                                )
                              : BorderSide.none,
                          bottom: const BorderSide(),
                        ),
                        child: Text(
                          value.depts[i]["name"],
                          style: const TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: MaterialButton(
                        disabledColor: Colors.grey[400],
                        color: Colors.lightBlue,
                        onPressed: currentUserss.operationKeys.deptAccess
                            ? () {
                                try {
                                  productsTableProvider.addProduct(
                                    value.depts[i + 1]["name"],
                                    1,
                                    productsTableProvider.getAnsAsDouble(),
                                    "-2",
                                    -1,
                                    -1,
                                    -1,
                                    value.depts[i + 1]["department"],
                                    value.depts[i + 1]["Print_Name"],
                                    -1
                                  );
                                } catch (e) {
                                  MyDialog.showAnimateWarningDialog(
                                    context: context,
                                    title: "سعر خاطئ",
                                    isWarning: true,
                                    onStart: () {
                                      productsTableProvider.openRcPdCh();
                                    },
                                    onEnd: () {
                                      productsTableProvider.closeRcPdCh();
                                    },
                                  );
                                }
                                productsTableProvider.pressKey("C");
                              }
                            : null,
                        shape: Border(
                          right: const BorderSide(
                            width: FunctionsKeysBar.borderWidth,
                          ),
                          left: const BorderSide(),
                          top: i == 0
                              ? const BorderSide(
                                  width: FunctionsKeysBar.borderWidth,
                                )
                              : BorderSide.none,
                          bottom: const BorderSide(),
                        ),
                        child: Text(
                          value.depts[i + 1]["name"],
                          style: const TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          children.add(
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: MaterialButton(
                      disabledColor: Colors.grey[400],
                      color: Colors.grey,
                      onPressed: () {
                        value.toggleFalse();
                      },
                      shape: const Border(
                        left: BorderSide(
                          width: FunctionsKeysBar.borderWidth,
                        ),
                        bottom: BorderSide(
                          width: FunctionsKeysBar.borderWidth,
                        ),
                        // right: BorderSide(),
                      ),
                      child: Icon(
                        functionKeysData[functionKeysData.length - 1][0]
                            ["icon"],
                        size: 50,
                      ),
                    ),
                  ),
                  Expanded(
                    child: MaterialButton(
                      disabledColor: Colors.grey[400],
                      color: Colors.grey,
                      onPressed: null,
                      shape: const Border(
                        left: BorderSide(),
                        right: BorderSide(width: FunctionsKeysBar.borderWidth),
                        bottom: BorderSide(
                          width: FunctionsKeysBar.borderWidth,
                        ),
                      ),
                      child: Icon(
                          functionKeysData[functionKeysData.length - 1][1]
                              ["icon"],
                          size: 50),
                    ),
                  ),
                ],
              ),
            ),
          );

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: children,
          );
        }
      }),
    );
  }
}
