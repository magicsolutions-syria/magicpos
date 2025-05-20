import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:magicposbeta/database/functions/person_functions.dart";

import "package:magicposbeta/providers/products_table_provider.dart";
import "package:magicposbeta/theme/locale/locale.dart";

import "../database/database_functions.dart";
import "../modules/person.dart";
import "../screens/person_card.dart";
import "general_list.dart";

class CHView extends StatefulWidget {
  final ProductsTableProvider productVal;
  const CHView({super.key, required this.productVal});

  @override
  State<CHView> createState() => _CHViewState();
}

class _CHViewState extends State<CHView> {
  static const platform = MethodChannel('IcodPrinter');
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
        updateFunctionsKeysValue("ch", widget.productVal.finalPrice);
        Person p = Person(
          item["id"],
          item["In"],
          item["Out"] + widget.productVal.finalPrice,
          item["Balance"] - widget.productVal.finalPrice,
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
        updateProductUnit(widget.productVal.products);
        updateBonusDiscount(widget.productVal.products);

        String printerText =
            widget.productVal.printerText(widget.productVal.finalPrice,widget.productVal.products.products);
        widget.productVal.clearAns();

        updateFunctionsKeysValue(
          "ch",
          widget.productVal.finalPrice,
        );
        widget.productVal.closeRcPdCh();
        widget.productVal.clearAll();

        Navigator.of(context).pop();
        await platform.invokeMethod("printText", printerText);

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
        .25,
        .25,
        .25,
        .25,
      ],
      isRcPd: true,
    );
  }
}
