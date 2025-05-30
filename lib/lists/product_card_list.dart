import 'package:flutter/material.dart';
import 'package:magicposbeta/theme/locale/locale.dart';
import '../../database/functions/product_functions.dart';
import '../../screens/product_card.dart';
import '../components/general_list.dart';

class ProductCardList extends StatelessWidget {
  const ProductCardList({super.key, required this.onDoubleTap});

  final Function(Map item) onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return GeneralList(
      secondaryController: TextEditingController(),
      searchTypes: SearchTypes.searchTypesProduct(),
      secondaryDropDown: const [],
      secondaryDropDownName: DiversePhrases.chooseUnit,
      columnsNames:ListsColumnsNames.productListNames(),
      commas: const [-1, -1, -1, -1],
      getData: (searchType, text) async {
        return await ProductFunctions.getProductList(
            searchText: text, searchType: searchType);
      },
      onDoubleTap: (item) {
        onDoubleTap(item);
      },
      dataNames: const [
        "code_1",
        "en_name",
        "ar_name",
        "id",
      ],
      columnsRatios: const [0.25, 0.3, 0.3, 0.15],
      addPage: ProductCard.route,
      enableAddButton: false,
    );
  }
}
