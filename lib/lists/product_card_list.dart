import 'package:flutter/material.dart';
import 'package:magicposbeta/lists/product_list/product_list.dart';
import 'package:magicposbeta/theme/locale/locale.dart';
import '../../screens/product_card.dart';
import '../modules/products_classes/info_product.dart';

class ProductCardList extends StatelessWidget {
  const ProductCardList({super.key, required this.onDoubleTap});

  final Function(InfoProduct item) onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return ProductList(
      columnsNames: ListsColumnsNames.productListNames(),
      onDoubleTap: (item) {
        onDoubleTap(item);
      },
      columnsRatios: const [0.25, 0.3, 0.3, 0.15],
      enableAddButton: false,
      columnsData: (InfoProduct product) {
        return [
          product.id.toString(),
          product.arName,
          product.enName,
          product.unit1.barcode
        ];
      },
      enableDropDown: false,
    );
  }
}
