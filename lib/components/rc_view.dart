import "package:flutter/material.dart";
import "package:magicposbeta/components/general_list.dart";
import "package:magicposbeta/database/database_functions.dart";
import "package:magicposbeta/modules/person.dart";
import "package:magicposbeta/providers/products_table_provider.dart";
import "package:magicposbeta/theme/locale/locale.dart";

import "../database/functions/person_functions.dart";
import "../screens/person_card.dart";

class RCView extends StatefulWidget {
  final double price;
  final ProductsTableProvider productVal;
  const RCView({super.key, required this.price, required this.productVal});

  @override
  State<RCView> createState() => _RCViewState();
}

class _RCViewState extends State<RCView> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GeneralList(
      secondaryController: _controller,
      commas: [widget.productVal.priceCommas,-1,-1,-1,],
      searchTypes: SearchTypes.searchTypesPerson(),
      secondaryDropDown: const ["الزبائن", "الموردون"],
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
        updateFunctionsKeysValue("rc", widget.price);
        Person p = Person(
          item["id"],
          item["In"] + widget.price,
          item["Out"],
          item["Balance"] + widget.price,
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
        // TODO PRINTER YA SAEEEEEEEEEEEEEDDDDDD
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
      addPage: PersonCard.clientRoute,
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
