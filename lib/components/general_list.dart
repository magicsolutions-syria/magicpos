import 'dart:async';

import 'package:flutter/material.dart';
import 'package:magicposbeta/components/not_availble_widget.dart';

import 'package:magicposbeta/components/waiting_widget.dart';
import 'package:magicposbeta/theme/custom_colors.dart';
import 'package:magicposbeta/providers/products_table_provider.dart';


import '../screens/person_card.dart';
import 'custom_drop_down_menu.dart';
import 'general_text_field.dart';
import 'general_list_row.dart';

class GeneralList extends StatelessWidget {
  static List<String> func() {
    return [""];
  }

  static void voidFunc() {}

  String formatText(dynamic text,int comma){
    if(comma==-1) {
      return text.toString();
    } else{
      return ProductsTableProvider.formatPriceText(text.toDouble(), comma);
    }
  }

  GeneralList({
    super.key,
    required this.secondaryController,
    required this.searchTypes,
    required this.secondaryDropDown,
    required this.secondaryDropDownName,
    required this.columnsNames,
    required this.getData,
    required this.onDoubleTap,
    required this.dataNames,
    this.columnsRatios,
    required this.addPage,
    this.enableAddButton = true,
    this.dataNamesFunction = func,
    this.exitFunction = voidFunc,
    this.isRcPd = false,
    this.commas = const [-1, -1, -1, -1, -1, -1, -1, -1, -1],
  });
  final FocusNode _node = FocusNode();
  final StreamController _streamController = StreamController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController secondaryController;
  final List<String> searchTypes;
  final List<String> secondaryDropDown;
  final String secondaryDropDownName;
  final List<String> columnsNames;
  late List<String> dataNames;
  final List<double>? columnsRatios;
  final Function(Map item) onDoubleTap;
  final Future<List<Map>> Function(String searchType, String text) getData;
  final double _width = 1000;
  final double _hieght = 540;
  late String addPage;
  final bool enableAddButton;
  final List<String> Function() dataNamesFunction;
  final VoidCallback exitFunction;
  final bool isRcPd;
  final List<int> commas;

  @override
  Widget build(BuildContext context) {

    _searchController.addListener(() async {
      _streamController.add(
          await getData(_searchController.text, _textFieldController.text));
    });
    _textFieldController.addListener(() async {
      _streamController.add(
          await getData(_searchController.text, _textFieldController.text));
    });
    secondaryController.addListener(() async {
      if (!enableAddButton) {
        dataNames = dataNamesFunction();
      }
      if (isRcPd) {
        addPage = secondaryController.text == "الزبائن"
            ? PersonCard.clientRoute
            : PersonCard.supplierRoute;
      }
      _streamController.add(
          await getData(_searchController.text, _textFieldController.text));
    });
    return GestureDetector(
      onTap: () {
        _node.unfocus();
      },
      child: KeyboardListener(
        focusNode: _node,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 300,
              child: Stack(
                children: [
                  SizedBox(
                    width: _width,
                    height: _hieght,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 15),
                              child: SizedBox(
                                width: _width - 88,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 250,
                                      height: 110,
                                      child: Column(
                                        children: [
                                          Text(
                                            secondaryDropDownName,
                                            style:
                                                const TextStyle(fontSize: 22),
                                          ),
                                          CustomDropDownMenu(
                                            scaleY: 0.9,
                                            enableSearch: false,
                                            enable:
                                                secondaryDropDown.isNotEmpty,
                                            width: 250,
                                            title: "",
                                            initVal: secondaryDropDown.isEmpty
                                                ? ""
                                                : secondaryDropDown[0],
                                            controller: secondaryController,
                                            data: secondaryDropDown,
                                            notify: (){}, onChanged: (String value) {  },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      height: 110,
                                      child: Column(
                                        children: [
                                          const Text(
                                            "البحث حسب",
                                            style: TextStyle(fontSize: 22),
                                          ),
                                          CustomDropDownMenu(
                                            scaleY: 0.9,
                                            width: 250,
                                            title: "",
                                            initVal: searchTypes[0],
                                            controller: _searchController,
                                            data: searchTypes,
                                            notify: (){}, onChanged: (String value) {  },
                                          ),
                                        ],
                                      ),
                                    ),
                                    GeneralTextField(
                                        radius: 6,
                                        height: 73,
                                        fontSize: 19.4,
                                        width: 300,
                                        title: "",
                                        prefix: const Icon(
                                          Icons.search,
                                          size: 20,
                                        ),
                                        controller: _textFieldController,
                                        inputType: TextInputType.text,
                                        onlyNumber: const []),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: _hieght - 400,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  MaterialButton(
                                    height: 50,
                                    onPressed: () {
                                      exitFunction();
                                      Navigator.pop(context);
                                    },
                                    padding: EdgeInsets.zero,
                                    color: Theme.of(context).primaryColor,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(30),
                                            bottomLeft: Radius.circular(20)),
                                        side: BorderSide.none),
                                    child: Icon(
                                      Icons.close,
                                      size: 40,
                                      color:
                                          Theme.of(context).secondaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: 400,
                          width: _width,
                          decoration: BoxDecoration(
                              color: Theme.of(context).fieldsColor,
                              borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(30))),
                          child: FutureBuilder(
                            future: getData(_searchController.text,
                                _textFieldController.text),
                            builder: (context, snapshot0) {
                              if (snapshot0.connectionState ==
                                      ConnectionState.waiting &&
                                  !snapshot0.hasData) {
                                return const WaitingWidget();
                              } else {
                                return StreamBuilder(
                                  initialData: snapshot0.data,
                                  stream: _streamController.stream,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.waiting &&
                                        !snapshot.hasData) {
                                      return const WaitingWidget();
                                    } else if (!snapshot.hasData) {
                                      return const NotAvailableWidget();
                                    } else {
                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            child: GeneralListRow(
                                              ratios: columnsRatios,
                                              width: _width,
                                              thick: 1,
                                              columns: columnsNames,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Divider(
                                            indent: 20,
                                            thickness: 4,
                                            endIndent: 20,
                                            height: 1,
                                          ),
                                          snapshot.data.isEmpty
                                              ? const NotAvailableWidget()
                                              : Expanded(
                                                  child: Theme(
                                                    data: ThemeData(
                                                      scrollbarTheme:
                                                          ScrollbarThemeData(
                                                        mainAxisMargin: 30,
                                                        thumbColor:
                                                            MaterialStatePropertyAll(
                                                          Theme.of(context)
                                                              .scaffoldBackgroundColor,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Scrollbar(
                                                      controller:
                                                          _scrollController,
                                                      trackVisibility: true,
                                                      thickness: 15,
                                                      thumbVisibility: true,
                                                      radius:
                                                          const Radius.circular(
                                                              5),
                                                      child: ListView.separated(
                                                          controller:
                                                              _scrollController,
                                                          itemBuilder:
                                                              (context, index) {
                                                            String text = "0.0";
                                                            if (isRcPd) {
                                                              if (snapshot.data[
                                                                          index]
                                                                      [
                                                                      dataNames[
                                                                          0]] >
                                                                  0) {
                                                                text =
                                                                    " له ${formatText(snapshot.data[index][dataNames[0]].abs(), commas[0])}";
                                                              } else if (snapshot
                                                                              .data[
                                                                          index]
                                                                      [
                                                                      dataNames[
                                                                          0]] <
                                                                  0) {
                                                                text =
                                                                    " عليه ${formatText(snapshot.data[index][dataNames[0]].abs(), commas[0])}";
                                                              }
                                                            }
                                                            return GestureDetector(
                                                              onDoubleTap: () {
                                                                onDoubleTap(
                                                                    snapshot.data[
                                                                        index]);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Container(
                                                                height: 50,
                                                                color: Colors
                                                                    .transparent,
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                width: _width,
                                                                child:
                                                                    GeneralListRow(
                                                                  ratios:
                                                                      columnsRatios,
                                                                  width: _width,
                                                                  thick: 1,
                                                                  columns: isRcPd
                                                                      ? [text=="0.0"?formatText(double.parse(text), commas[0]):text] +
                                                                          List.generate(
                                                                              columnsNames.length -
                                                                                  1,
                                                                              (index0) =>formatText(snapshot.data[index][dataNames[index0 + 1]], commas[index0+1]??-1)
                                                                                )
                                                                      : List.generate(
                                                                          columnsNames
                                                                              .length,
                                                                          (index0) => formatText(snapshot
                                                                              .data[index][dataNames[index0]], commas[index0]??-1)
                                                                              ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          separatorBuilder:
                                                              (context, index) {
                                                            return const Divider(
                                                              indent: 20,
                                                              thickness: 0,
                                                              endIndent: 20,
                                                              height: 1,
                                                            );
                                                          },
                                                          itemCount: snapshot
                                                              .data.length),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      );
                                    }
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 30,
                    bottom: 30,
                    child: MaterialButton(
                      onPressed: enableAddButton
                          ? () {
                              Navigator.of(context).pushNamed(
                                addPage,
                              );
                            }
                          : null,
                      minWidth: 60,
                      height: 60,
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1000)),
                      child: Icon(
                        enableAddButton ? Icons.add : null,
                        size: 30,
                        color: Theme.of(context).fieldsColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
