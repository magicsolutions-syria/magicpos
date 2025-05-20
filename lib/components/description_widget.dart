import "package:flutter/material.dart";
import "package:magicposbeta/providers/products_table_provider.dart";
import "package:provider/provider.dart";

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({super.key, this.isRest = false});
  final bool isRest;

  @override
  Widget build(BuildContext context) {
    double paddingg=isRest?4:8;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(10.6),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(), bottom: BorderSide(), left: BorderSide()),
                  color: Colors.grey,
                ),
                child: const Center(
                  child: Text(
                    "N",
                    style: TextStyle(
                      fontSize: 21,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(10.6),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(), bottom: BorderSide(), left: BorderSide()),
                  color: Colors.grey,
                ),
                child: const Center(
                  child: Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 21,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(10.6),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(), bottom: BorderSide(), left: BorderSide()),
                  color: Colors.grey,
                ),
                child: const Center(
                  child: Text(
                    "Qty",
                    style: TextStyle(
                      fontSize: 21,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(10.6),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(), bottom: BorderSide(), left: BorderSide()),
                  color: Colors.grey,
                ),
                child: const Center(
                  child: Text(
                    "Unit Price",
                    style: TextStyle(
                      fontSize: 21,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(10.6),
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: Colors.grey,
                ),
                child: const Center(
                  child: Text(
                    "Total Price",
                    style: TextStyle(
                      fontSize: 21,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Consumer<ProductsTableProvider>(
              builder: (context, value, child) => Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(right: BorderSide(width: .5)),
                ),
                child: Table(
                  border: TableBorder.all(
                    width: 0.5,
                  ),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(4),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(2),
                    4: FlexColumnWidth(2),
                  },
                  children: [
                    ...List.generate(
                      value.productsLength,
                      (index) => TableRow(
                        decoration: (value.isProductSelected &&
                                index == value.selectedProductIndex)
                            ? const BoxDecoration(
                                color: Colors.lightBlue,
                              )
                            : const BoxDecoration(
                                color: Colors.white,
                              ),

                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding:  EdgeInsets.all(
                                paddingg,
                              ),
                              child: Center(
                                child: Text(
                                  (index + 1).toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: GestureDetector(
                              onTap: () {
                                value.selecteProduct(index);
                              },
                              child: Padding(
                                padding:  EdgeInsets.all(paddingg),
                                child: Text(
                                  value.products
                                      .getProductAtIndex(index)
                                      .desc
                                      .toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding:  EdgeInsets.all(paddingg),
                              child: Center(
                                child: Text(
                                  value.products
                                      .getProductAtIndex(index)
                                      .qty.toStringAsFixed(value.qtyCommas),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding:  EdgeInsets.all(paddingg),
                              child: Text(
                                value.products
                                    .getProductAtIndex(index)
                                    .unitPrice.toStringAsFixed(value.priceCommas),
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding:  EdgeInsets.all(paddingg),
                              child: Text(
                                (value.products
                                            .getProductAtIndex(index)
                                            .unitPrice *
                                        value.products
                                            .getProductAtIndex(index)
                                            .qty)
                                    .toStringAsFixed(value.priceCommas),
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...List.generate(
                      18 - value.productsLength >= 0
                          ? 18 - value.productsLength
                          : 0,
                      (index) => TableRow(
                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding:  EdgeInsets.all(
                                paddingg,
                              ),
                              child: Center(
                                child: Text(
                                  (index + value.productsLength + 1).toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                           TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.all(paddingg),
                              child: Text(""),
                            ),
                          ),
                           TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.all(paddingg),
                              child: Text(""),
                            ),
                          ),
                           TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.all(paddingg),
                              child: Text(""),
                            ),
                          ),
                           TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.all(paddingg),
                              child: Text(""),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        isRest ? const SizedBox(height: 10) : const SizedBox(),
      ],
    );
  }
}
