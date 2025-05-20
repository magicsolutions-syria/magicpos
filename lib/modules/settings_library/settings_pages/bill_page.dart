import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:magicposbeta/components/my_dialog.dart';
import 'package:magicposbeta/components/operator_button.dart';
import 'package:magicposbeta/theme/custom_colors.dart';
import 'package:magicposbeta/database/shared_preferences_functions.dart';

import '../../../components/waiting_widget.dart';
import '../../../database/database_functions.dart';
import '../../printer.dart';

class BillPage extends StatelessWidget {
  BillPage({super.key});
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  final TextEditingController headerController = TextEditingController();
  final TextEditingController tailController = TextEditingController();

  StreamController imageController = StreamController();
  StreamController typeController = StreamController();
  String imagePath = "";
  String headerType = "header";
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20, right: 26),
                child: MaterialButton(
                  onPressed: () async {
                    imageController.add(await pickImage());
                  },
                  minWidth: 240,
                  height: 240,
                  padding: EdgeInsets.zero,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(width: 1.5)),
                  child: FutureBuilder(
                    future: SharedPreferencesFunctions.getBillLogo(),
                    builder: (BuildContext context,
                        AsyncSnapshot<String> snapshot1) {
                      if (snapshot1.connectionState ==
                          ConnectionState.waiting) {
                        return const WaitingWidget();
                      } else {
                        return StreamBuilder(
                            initialData: snapshot1.data,
                            stream: imageController.stream,
                            builder: (context, snapshot) {
                              if ((snapshot.connectionState ==
                                          ConnectionState.waiting &&
                                      !snapshot.hasData) ||
                                  !snapshot.hasData) {
                                return const WaitingWidget();
                              } else {
                                imagePath = snapshot.data;
                                if (snapshot.data == "") {
                                  return const Center(
                                    child: Text(
                                      "إضافة صورة",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 29),
                                    ),
                                  );
                                } else {
                                  return Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      width: 240,
                                      height: 240,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: FileImage(File(imagePath)),
                                              fit: BoxFit.fill),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 190, bottom: 170),
                                        child: MaterialButton(
                                          onPressed: () {
                                            imagePath = "";
                                            imageController.add("");
                                          },
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              bottomRight: Radius.circular(15),
                                            ),
                                          ),
                                          padding: EdgeInsets.zero,
                                          color:
                                              Theme.of(context).closeImageColor,
                                          minWidth: 40,
                                          height: 20,
                                          child: Center(
                                            child: Icon(
                                              color:
                                                  Theme.of(context).fieldsColor,
                                              Icons.close,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }
                            });
                      }
                    },
                  ),
                )),
            FutureBuilder(
              future: SharedPreferencesFunctions.getHeaderType(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot1) {
                if (snapshot1.connectionState == ConnectionState.waiting) {
                  return const WaitingWidget();
                } else {
                  return StreamBuilder(
                      initialData: snapshot1.data,
                      stream: typeController.stream,
                      builder: (context, snapshot) {
                        headerType = snapshot.data;
                        return Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 180),
                              child: Radio(
                                value: "logo",
                                groupValue: headerType,
                                onChanged: (value) {
                                  typeController.add(value);
                                },
                              ),
                            ),
                            Container(
                              color:
                                  Theme.of(context).colorScheme.outlineVariant,
                              width: 4,
                              height: 200,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 180),
                              child: Radio(
                                value: "header",
                                groupValue: headerType,
                                onChanged: (value) {
                                  typeController.add(value);
                                },
                              ),
                            ),
                          ],
                        );
                      });
                }
              },
            ),
            FutureBuilder(
                future: SharedPreferencesFunctions.getBillHeader(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const WaitingWidget();
                  } else {
                    headerController.text = snapshot.data!;
                    return SizedBox(
                      width: 540,
                      height: 300,
                      child: Center(
                        child: Scrollbar(
                          thumbVisibility: true,
                          controller: _scrollController,
                          interactive: true,
                          thickness: 15,
                          radius: const Radius.circular(10),
                          child: TextField(
                            scrollController: _scrollController,
                            minLines: 4,
                            maxLines: 4,
                            maxLength: 48 * 4,
                            controller: headerController,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                                counter: const SizedBox(),
                                hintText: "رأس الفاتورة",
                                hintStyle: const TextStyle(fontSize: 23),
                                hintTextDirection: TextDirection.rtl,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(width: 1.5),
                                    borderRadius: BorderRadius.circular(10)),
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(width: 1.5),
                                    borderRadius: BorderRadius.circular(10)),
                                fillColor: Colors.white,
                                filled: true),
                          ),
                        ),
                      ),
                    );
                  }
                }),
          ],
        ),
        const Divider(
          height: 0,
          thickness: 4,
          endIndent: 100,
          indent: 100,
        ),
        FutureBuilder(
            future: SharedPreferencesFunctions.getBillFooter(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const WaitingWidget();
              } else {
                tailController.text = snapshot.data!;
                return SizedBox(
                  width: 540,
                  height: 200,
                  child: Center(
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: _scrollController2,
                      interactive: true,
                      thickness: 15,
                      radius: const Radius.circular(10),
                      child: TextField(
                        scrollController: _scrollController2,
                        minLines: 2,
                        maxLines: 2,
                        maxLength: 48 * 2,
                        controller: tailController,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                            counter: const SizedBox(),
                            hintText: "ذيل الفاتورة",
                            hintStyle: const TextStyle(fontSize: 23),
                            hintTextDirection: TextDirection.rtl,
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(width: 1.5),
                                borderRadius: BorderRadius.circular(10)),
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(width: 1.5),
                                borderRadius: BorderRadius.circular(10)),
                            fillColor: Colors.white,
                            filled: true),
                      ),
                    ),
                  ),
                );
              }
            }),
        OperatorButton(
            onPressed: () async {
              if(headerType=="logo"){
                await Printer.createCopy(imagePath);
              }
              await SharedPreferencesFunctions.setBillDecoration(
                  imagePath: imagePath,
                  headerType: headerType,
                  tailText: tailController.text,
                  headerText: headerController.text);
              MyDialog.showAnimateWarningDialog(
                  context: context, isWarning: false, title: "تم الحفظ");
            },
            text: "حفظ",
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            enable: true),
      ],
    );
  }
}
