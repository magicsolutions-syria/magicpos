import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/theme/locale/locale.dart';
import '../../bloc/shared_bloc/shared_cubit.dart';
import '../../database/functions/product_functions.dart';
import '../../screens/product_card.dart';
import '../components/general_list.dart';

class InOutProductList extends StatelessWidget {
  const InOutProductList({super.key, required this.onDoubleTap});

  final Function(Map item) onDoubleTap;

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return GeneralList(
      secondaryController: controller,
      searchTypes: SearchTypes.searchTypesUser(),
      secondaryDropDown: const [
        "كل المواد",
        "المواد اللازمة",
        "المواد ضمن الحد",
        "المواد الفائضة"
      ],
      secondaryDropDownName: 'اختيار المواد',
      columnsNames: const [
        "الباركود",
        "الكمية",
        "الاسم بالعربي",
        "الرقم",
      ],
      getData: (searchType, text) async {
        String secondConition = "";
        switch (controller.text) {
          case "كل المواد":
            {
              secondConition = "";
              break;
            }
          case "المواد اللازمة":
            {
              secondConition =
                  "min_amount > (current_quantity_1+current_quantity_2*pieces_quantity_2+current_quantity_3*pieces_quantity_3) ";
              break;
            }
          case "المواد ضمن الحد":
            {
              secondConition =
                  "min_amount <= (current_quantity_1+current_quantity_2*pieces_quantity_2+current_quantity_3*pieces_quantity_3) AND ((current_quantity_1+current_quantity_2*pieces_quantity_2+current_quantity_3*pieces_quantity_3)<=max_amount OR max_amount=0 ) ";

              break;
            }
          case "المواد الفائضة":
            {
              secondConition =
                  "max_amount < (current_quantity_1+current_quantity_2*pieces_quantity_2+current_quantity_3*pieces_quantity_3) AND max_amount > 0 ";
            }
        }
        return await ProductFunctions.getProductList(
            searchText: text,
            searchType: searchType,
            secondCondition: secondConition);
      },
      onDoubleTap: (item) {
        onDoubleTap(item);
      },
      dataNames: const [
        "code_1",
        "current_quantity_1",
        "ar_name",
        "id",
      ],
      commas: [
        -1,
        BlocProvider.of<SharedCubit>(context).settings.qtyComma,
        -1,
        -1
      ],
      columnsRatios: const [0.25, 0.3, 0.3, 0.15],
      addPage: ProductCard.route,
    );
  }
}
