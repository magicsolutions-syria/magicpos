import "package:flutter/material.dart";

import "package:magicposbeta/providers/products_table_provider.dart";
import "package:magicposbeta/theme/locale/locale.dart";

import "../database/database_functions.dart";
import "../database/functions/person_functions.dart";
import "../modules/person.dart";
import "../screens/clients_card.dart";
import "../screens/person_card.dart";
import "general_list.dart";

class PDView extends StatefulWidget {
  final double price;
  final ProductsTableProvider productVal;
  const PDView({super.key, required this.price, required this.productVal});

  @override
  State<PDView> createState() => _PDViewState();
}

class _PDViewState extends State<PDView> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GeneralList(
      secondaryController: _controller,
      searchTypes: SearchTypes.searchTypesPerson(),
      commas: [widget.productVal.priceCommas,-1,-1,-1],
      secondaryDropDown: const ["الموردون", "الزبائن"],
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
          _controller.text == "الزبائن" ? "clients" : "suppliers",
          searchType: text,
          searchText: cont,
        );
      },
      onDoubleTap: (item) async {
        updateFunctionsKeysValue("pd", widget.price);
        Person p = Person(
          item["id"],
          item["In"],
          item["Out"] + widget.price,
          item["Balance"] - widget.price,
          item["Barcode"],
          item["Name_Arabic"],
          item["Name_English"],
          item["Tel"],
          item["Whatsapp"],
          item["Email"],
        );
        PersonFunctions.updatePerson(
          p,
          _controller.text == "الزبائن" ? "clients" : "suppliers",
        );
        // TODO PRINTER YA SAEEEEEEEEEEEEEDDDDDD;
        widget.productVal.closeRcPdCh();
        widget.productVal.clearAns();
      },
      exitFunction: () {
        widget.productVal.closeRcPdCh();
        widget.productVal.clearAns();
      },
      dataNames: const [
        "Balance",
        "Barcode",
        "Name_Arabic",
        "id",
      ],
      addPage: ClientsCard.route,
      columnsRatios: const [
        .25,
        .25,
        .25,
        .25,
      ],
      isRcPd: true,
    );
  }
}
