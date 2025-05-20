import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magicposbeta/database/functions/product_functions.dart';
import '../../components/general_list.dart';
import '../../components/my_dialog.dart';
import '../../components/operator_button.dart';
import '../../providers/products_table_provider.dart';
import '../../screens/product_card.dart';
import '../../screens_data/constants.dart';
import '../../theme/locale/search_types.dart';
import '../database_functions.dart';
import 'groups_functions.dart';

Future<List> getFuncKeysBarData() async {
  List list1 = await GroupsFunctions.getSelectedUnSelectedGroups(true, "", -1);
  List list2 = await getDepts();

  return list2 + list1;
}

void handleClick(int id, ProductsTableProvider productsTableProvider,
    BuildContext context, MethodChannel platform) async {
  switch (id) {
    case 0:
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
          commas: [
            productsTableProvider.qtyCommas,
            productsTableProvider.priceCommas,
            -1,
            -1
          ],
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
                  .getProductAtIndex(productsTableProvider.selectedProductIndex)
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
