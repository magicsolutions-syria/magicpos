import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magicposbeta/components/bottom_button.dart';
import 'package:magicposbeta/components/control_panel.dart';
import 'package:magicposbeta/components/custom_view_panel.dart';
import 'package:magicposbeta/components/list_view_button.dart';
import 'package:magicposbeta/components/operator_button.dart';
import 'package:magicposbeta/components/rest_functions_keys_bar.dart';
import 'package:magicposbeta/components/view_panel.dart';
import 'package:magicposbeta/database/shared_preferences_functions.dart';
import 'package:magicposbeta/providers/group_provider.dart';
import 'package:magicposbeta/screens_data/functions_keys_data.dart';
import 'package:provider/provider.dart';

import '../components/cash_view.dart';
import '../components/ch_view.dart';
import '../components/description_widget.dart';
import '../components/functions_keys_bar.dart';
import '../components/my_dialog.dart';
import '../components/pd_view.dart';
import '../components/rc_view.dart';
import '../database/database_functions.dart';
import '../database/functions/functions_keys_bar_handle_click.dart';
import '../modules/product.dart';
import '../providers/products_table_provider.dart';

class ResturantScreen extends StatelessWidget {
  const ResturantScreen({super.key});

  static String route = "/rest";

  static const platform = MethodChannel('IcodPrinter');

  void handleClickRest(ProductsTableProvider productVal, BuildContext context,
      String text) async {
    switch (text) {
      case "CASH":
        productVal.openRcPdCh();
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

            productVal.openRcPdCh();
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => ListView(
                children: [
                  SizedBox(
                    height: (productVal.finalPrice <= ans) ? 150 : 0,
                  ),
                  Dialog(
                    child: CashPanel(
                      totalPrice: productVal.finalPrice,
                      cashValue: ans,
                      productVal: productVal,
                      isEmpty: empty,
                      buttonText: text,
                      isRest: true,
                    ),
                  ),
                ],
              ),
            );
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
      default:
        productVal.pressKey(text);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ProductsTableProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => GroupProvider(),
        ),
      ],
      child: Scaffold(
        body: FutureBuilder(
          future: getFuncKeysBarData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            return Consumer<GroupProvider>(
              builder: (context, groupValue, child) {
                groupValue.setGroups(snapshot.data!);
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 45,
                        child: Column(
                          children: [
                            Expanded(flex:54,child: DescriptionWidget(isRest: true)),
                            Expanded(flex:46,child: CustomViewPanel()),
                          ],
                        ),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      Expanded(
                        flex: 15,
                        child: Consumer<ProductsTableProvider>(builder:
                            (context, ProductsTableProvider value, child) {
                          List ls = [];
                          if (groupValue.index == 0) {
                            for (int i = 0;
                                i < restFunctionsKeysData.length;
                                i++) {
                              Map mp = Map.from(restFunctionsKeysData[i]);
                              if (i == 5) {
                                mp["color"] = !value.isPrinterOn
                                    ? Colors.red
                                    : restFunctionsKeysData[i]["color"];
                              }
                              if (i == 7) {
                                mp["color"] = value.thirdClient()
                                    ? Colors.red
                                    : restFunctionsKeysData[i]["color"];
                              }
                              if (i == 9) {
                                mp["color"] = value.secondClient()
                                    ? Colors.red
                                    : restFunctionsKeysData[i]["color"];
                              }
                              if (i == 11) {
                                mp["color"] = value.firstClient()
                                    ? Colors.red
                                    : restFunctionsKeysData[i]["color"];
                              }
                              if (i == 8) {
                                mp["color"] = value.isRfToggled
                                    ? Colors.green
                                    : restFunctionsKeysData[i]["color"];
                              }
                              mp["onPressed"] = () =>
                                  handleClick(i, value, context, platform);
                              mp["onLongPress"] = i == 8
                                  ? () {
                                      value.holdRf();
                                    }
                                  : null;
                              ls.add(mp);
                            }
                          } else {
                            List groupLs = groupValue.currentGroup;
                            if (groupValue.index == 1) {
                              for (int i = 0; i < groupLs.length; i++) {
                                Map mp = Map.from(groupLs[i]);
                                mp["onPressed"] = () {
                                  try {
                                    value.addProduct(
                                      groupLs[i]["txt"],
                                      1,
                                      value.getAnsAsDouble(),
                                      "-2",
                                      -1,
                                      -1,
                                      -1,
                                      groupLs[i]["department"],
                                      groupLs[i]["Print_Name"],
                                      -1
                                    );
                                  } catch (e) {
                                    MyDialog.showAnimateWarningDialog(
                                      context: context,
                                      title: "سعر خاطئ",
                                      isWarning: true,
                                      onStart: () {
                                        value.openRcPdCh();
                                      },
                                      onEnd: () {
                                        value.closeRcPdCh();
                                      },
                                    );
                                  }
                                  value.pressKey("C");
                                };
                                ls.add(mp);
                              }
                            }
                            else {
                              ls = groupLs;
                            }
                          }
                          return Column(
                            children: [
                              Expanded(
                                flex: 8,
                                child: Container(
                                  color: Colors.white,
                                  child: RestFunctionsKeysBar(
                                    widgets: ls,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    MaterialButton(
                                      minWidth: 60,
                                      height: 42,
                                      disabledColor: Colors.grey[400],
                                      color: Colors.grey,
                                      onPressed: groupValue.index == 0
                                          ? null
                                          : () => groupValue.decreaseIndex(),
                                      shape: const Border(
                                        left: BorderSide(
                                          width: FunctionsKeysBar.borderWidth,
                                        ),
                                        bottom: BorderSide(
                                          width: FunctionsKeysBar.borderWidth,
                                        ),
                                        top: BorderSide(),
                                        // right: BorderSide(),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_left_rounded,
                                        size: 75,
                                      ),
                                    ),
                                    MaterialButton(
                                      minWidth: 60,
                                      height: 42,
                                      disabledColor: Colors.grey[400],
                                      color: Colors.grey,
                                      onPressed: groupValue.index - 1 ==
                                              (groupValue.getLength() / 16)
                                                  .floor()
                                          ? null
                                          : () => groupValue.increaseIndex(),
                                      shape: const Border(
                                        left: BorderSide(),
                                        right: BorderSide(
                                            width:
                                                FunctionsKeysBar.borderWidth),
                                        bottom: BorderSide(
                                          width: FunctionsKeysBar.borderWidth,
                                        ),
                                        top: BorderSide(),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_right_rounded,
                                        size: 77,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      Expanded(
                        flex: 30,
                        child: Consumer<ProductsTableProvider>(
                          builder: (BuildContext context,
                              ProductsTableProvider value, Widget? child) {
                            return Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                    ),
                                    child: ScrollbarTheme(
                                      data: const ScrollbarThemeData(
                                        mainAxisMargin: 0,
                                        thickness: MaterialStatePropertyAll(8),
                                        radius: Radius.circular(16),
                                        thumbVisibility:
                                            MaterialStatePropertyAll(true),
                                      ),
                                      child: Scrollbar(
                                        controller: scrollController,
                                        child: GridView.builder(
                                          controller: scrollController,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: 200 / 110,
                                            crossAxisCount: 3,
                                          ),
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (context, index) {
                                            List products = groupValue.products;
                                            Product item = products[index];
                                            return Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: MaterialButton(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                onPressed: () {
                                                  value.addProduct(
                                                    item.desc,
                                                    1,
                                                    item.price,
                                                    item.barcode,
                                                    item.id,
                                                    item.unitNum,
                                                    item.groupId,
                                                    item.deptId,
                                                    item.printName,
                                                    item.printerId,
                                                  );
                                                },
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  item.desc,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount: groupValue.products.length,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: BottomButton(
                                        onTap: () {
                                          handleClickRest(
                                              value, context, "CASH");
                                        },
                                        title: "CASH",
                                        color: Colors.grey,
                                        enable: true,
                                        width: 158,
                                        height: 65,
                                        leftRadius: 16,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: BottomButton(
                                        onTap: () {
                                          handleClickRest(value, context, "PD");
                                        },
                                        title: "PD",
                                        color: Colors.grey,
                                        enable: true,
                                        width: 158,
                                        height: 65,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: BottomButton(
                                        onTap: () {
                                          handleClickRest(value, context, "RC");
                                        },
                                        title: "RC",
                                        color: Colors.grey,
                                        enable: true,
                                        width: 158,
                                        height: 65,
                                        rightRadius: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
