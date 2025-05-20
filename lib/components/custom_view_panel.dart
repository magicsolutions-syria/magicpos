import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:flutter_barcode_listener/flutter_barcode_listener.dart";
import "package:magicposbeta/components/my_dialog.dart";
import "package:magicposbeta/components/rest_control_panel.dart";
import "package:magicposbeta/theme/custom_colors.dart";
import "package:magicposbeta/database/database_functions.dart";
import "package:magicposbeta/providers/products_table_provider.dart";
import "package:provider/provider.dart";
import "package:magicposbeta/database/initialize_database.dart";

class CustomViewPanel extends StatelessWidget {
  const CustomViewPanel({super.key});

  static double fontSize = 15;
  static int flexSize = 25;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: RestControlPanel()),
        // SizedBox(width: 8),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: const Border(
                top: BorderSide(),
                right: BorderSide(),
                bottom: BorderSide(),
              ),
            ),
            padding: const EdgeInsets.all(
              10.6,
            ),
            child: Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: flexSize,
                              child: Container(
                                color: Theme.of(context).fieldsColor,
                                padding: const EdgeInsets.all(10.6),
                                child: Consumer<ProductsTableProvider>(
                                  builder: (context, value, child) => Text(
                                    value.total
                                        .toStringAsFixed(value.priceCommas),
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 8,
                              child: Text(
                                textAlign: TextAlign.start,
                                ": الإجمالي",
                                style: TextStyle(
                                  color: Theme.of(context).fieldsColor,
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: flexSize,
                              child: Container(
                                color: Theme.of(context).fieldsColor,
                                padding: const EdgeInsets.all(10.6),
                                child: Consumer<ProductsTableProvider>(
                                  builder: (context, value, child) => Text(
                                    value.bonus
                                        .toStringAsFixed(value.priceCommas),
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 8,
                              child: Text(
                                textAlign: TextAlign.start,
                                ": الإضافات",
                                style: TextStyle(
                                  color: Theme.of(context).fieldsColor,
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: flexSize,
                              child: Container(
                                color: Theme.of(context).fieldsColor,
                                padding: const EdgeInsets.all(10.6),
                                child: Consumer<ProductsTableProvider>(
                                  builder: (context, value, child) => Text(
                                    value.discount
                                        .toStringAsFixed(value.priceCommas),
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 8,
                              child: Text(
                                textAlign: TextAlign.start,
                                ": الحسومات",
                                style: TextStyle(
                                  color: Theme.of(context).fieldsColor,
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: flexSize,
                              child: Container(
                                color: Theme.of(context).fieldsColor,
                                padding: const EdgeInsets.all(10.6),
                                child: Consumer<ProductsTableProvider>(
                                  builder: (context, value, child) => Text(
                                    value.finalPrice
                                        .toStringAsFixed(value.priceCommas),
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 8,
                              child: Text(
                                textAlign: TextAlign.start,
                                ": الصافي",
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).fieldsColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 1),
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Theme.of(context).fieldsColor,
                      width: double.infinity,
                      padding: const EdgeInsets.all(6.6),
                      child: Consumer<ProductsTableProvider>(
                          builder: (context, value, child) {
                        if (!value.isRcPdChOpened) {
                          return BarcodeKeyboardListener(
                            bufferDuration: const Duration(milliseconds: 200),
                            onBarcodeScanned: (barcode) {
                              if (value.isRfToggled) {
                                for (int i = 0; i < barcode.length; i++) {
                                  value.pressKey(barcode[i]);
                                }
                                try {
                                  value.removeAtIndex();
                                } catch (e) {
                                  MyDialog.showAnimateWarningDialog(
                                    context: context,
                                    title: "باركود خاطئ",
                                    isWarning: true,
                                    onStart: () {
                                      print("sssssssssssssssssssssss");
                                      value.openRcPdCh();
                                    },
                                    onEnd: () {
                                      value.closeRcPdCh();
                                    },
                                  );
                                }
                                value.pressKey("C");
                              } else {
                                enterFunction(
                                  barcode,
                                  value.addProduct,
                                  context,
                                  value.qty,
                                  value,
                                  priceType: value.priceType,
                                );
                                value.setQty(1);
                              }
                            },
                            child: Text(
                              value.ans,
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                fontSize: 36,
                              ),
                            ),
                          );
                        }
                        return Text(
                          value.ans,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            fontSize: 36,
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
