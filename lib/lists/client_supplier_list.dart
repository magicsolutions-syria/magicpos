import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/bloc/shared_bloc/shared_cubit.dart';
import 'package:magicposbeta/screens/suppliers_card.dart';
import '../../database/functions/person_functions.dart';
import '../../screens/person_card.dart';
import '../../theme/locale/search_types.dart';
import '../components/general_list.dart';

class ClientSupplierList extends StatelessWidget {
  ClientSupplierList({super.key, required this.onDoubleTap});

  final TextEditingController personTypeController = TextEditingController();
  final Function(Map item, String type) onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return GeneralList(
      secondaryController: personTypeController,
      searchTypes: SearchTypes.searchTypesPerson(),
      secondaryDropDown: const [
        "الموردون",
        "الزبائن",
      ],
      commas: [
        BlocProvider.of<SharedCubit>(context).settings.priceComma,
        -1,
        -1,
        -1
      ],
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
              personTypeController.text == "الزبائن" ? "clients" : "suppliers",
          searchType: text,
          searchText: cont,
        );
      },
      onDoubleTap: (item) {
        onDoubleTap(item, personTypeController.text);
      },
      dataNames: const [
        "Balance",
        "Barcode",
        "Name_Arabic",
        "id",
      ],
      addPage: SuppliersCard.route,
      columnsRatios: const [
        .35,
        .25,
        .25,
        .15,
      ],
      isRcPd: true,
    );
  }
}
