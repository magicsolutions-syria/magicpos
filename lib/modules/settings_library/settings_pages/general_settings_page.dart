import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/bloc/shared_bloc/shared_bloc.dart';
import 'package:magicposbeta/components/choose_number_field.dart';
import 'package:magicposbeta/components/operator_button.dart';
import 'package:magicposbeta/components/settings_title.dart';
import 'package:magicposbeta/components/small_hint_text.dart';
import 'package:magicposbeta/components/waiting_widget.dart';
import 'package:magicposbeta/screens_data/constants.dart';
import 'package:magicposbeta/theme/locale/locale.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:magicposbeta/database/shared_preferences_functions.dart';

import '../../../components/radio_text.dart';

class GeneralSettingsPage extends StatelessWidget {
  const GeneralSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FutureBuilder(
            future: SharedPreferencesFunctions.getCommas(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const WaitingWidget();
              } else {
                TextEditingController priceComma = TextEditingController();

                TextEditingController qtyComma = TextEditingController();
                priceComma.addListener(() async {
                  SharedPreferences data =
                      await SharedPreferences.getInstance();
                  await data.setInt(SharedPreferencesNames.priceComma,
                      int.parse(priceComma.text));
                });
                qtyComma.addListener(() async {
                  SharedPreferences data =
                      await SharedPreferences.getInstance();
                  await data.setInt(SharedPreferencesNames.qtyComma,
                      int.parse(qtyComma.text));
                });
                priceComma.text = snapshot
                    .data![SharedPreferencesNames.priceComma]!
                    .toString();
                qtyComma.text =
                    snapshot.data![SharedPreferencesNames.qtyComma]!.toString();
                return Row(
                  children: [
                    ChooseNumberField(
                        controller: priceComma,
                        maxNumber: 3,
                        minNumber: 0,
                        title: " : عرض الأسعار"),
                    const Spacer(
                      flex: 31,
                    ),
                    ChooseNumberField(
                        controller: qtyComma,
                        maxNumber: 3,
                        minNumber: 0,
                        title: " : عرض الكميات"),
                    const Spacer(
                      flex: 69,
                    ),
                    const SettingsTitle(title: "إعدادات الفواصل"),
                  ],
                );
              }
            }),
        const Divider(
          height: 0,
          thickness: 4,
        ),
        FutureBuilder(
            future: SharedPreferencesFunctions.getScaleData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const WaitingWidget();
              } else {
                TextEditingController scaleWeight = TextEditingController();
                TextEditingController scaleProductNumber =
                    TextEditingController();
                TextEditingController scaleStart = TextEditingController();
                scaleWeight.addListener(() {
                  scaleProductNumber.text =
                      (10 - int.parse(scaleWeight.text)).toString();
                });
                scaleProductNumber.addListener(() {
                  scaleWeight.text =
                      (10 - int.parse(scaleProductNumber.text)).toString();
                });
                scaleWeight.text = snapshot.data!["weight_scale"]!;
                scaleProductNumber.text =
                    snapshot.data!["product_number_scale"]!;
                scaleStart.text = snapshot.data!["start_scale"]!;

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OperatorButton(
                          onPressed: () async {
                            context.read<SharedCubit>().settings.setProductNumberScale(value:  int.parse(scaleWeight.text));
                            context.read<SharedCubit>().settings.setWeightScale(value:  int.parse(scaleProductNumber.text));
                            context.read<SharedCubit>().settings.setStartScale(value:  scaleStart.text);
                          },
                          text: ButtonsNames.save,
                          color: Theme.of(context).primaryColor,
                          enable: true,
                          textColor: Colors.white,
                        ),
                        const SettingsTitle(title: DiversePhrases.scaleSettings),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        ChooseNumberField(
                            controller: scaleWeight,
                            maxNumber: 9,
                            title:FieldsNames.weight ),
                        const Spacer(),
                        ChooseNumberField(
                            controller: scaleProductNumber,
                            maxNumber: 9,
                            title: FieldsNames.productNumber),
                        const Spacer(),
                        const SmallHintText(title: "(خانتين فقط)"),
                        const SizedBox(width: 5),
                        ChooseNumberField(
                            enableEditing: true,
                            controller: scaleStart,
                            minNumber: 0,
                            maxNumber: 99,
                            title: " : البداية"),
                      ],
                    ),
                  ],
                );
              }
            }),
        const Divider(
          height: 0,
          thickness: 4,
        ),
        Row(
          children: [
            SizedBox(
              width: 590,
              child: FutureBuilder(
                  future: SharedPreferencesFunctions.getScreen(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const WaitingWidget();
                    } else {
                      return Row(
                        children: [
                          const Spacer(
                            flex: 2,
                          ),
                          RadioText(
                            title: "شاشة البيع",
                            values: posScreenGroup,
                            names: const [
                              ": شاشة بيع مطعم",
                              ": شاشة بيع سوبر ماركت"
                            ],
                            hieght: 238,
                            width: 273,
                            initialValue: snapshot.data!,
                            sharePrefernekeyName: 'screen_type',
                          ),
                          const Spacer(
                            flex: 3,
                          ),
                        ],
                      );
                    }
                  }),
            ),
            Container(
              height: 282,
              width: 4,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            SizedBox(
              width: 590,
              child: FutureBuilder(
                  future: SharedPreferencesFunctions.getPrice(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const WaitingWidget();
                    } else {
                      return Row(
                        children: [
                          const Spacer(),
                          RadioText(
                            title: "سعر المبيع",
                            values: priceGroup,
                            names: const [
                              ": سعر الكلفة",
                              ": سعر الجملة",
                              ": سعر المستهلك"
                            ],
                            hieght: 270,
                            width: 199,
                            initialValue: snapshot.data!,
                            sharePrefernekeyName: 'price_type',
                          ),
                          const Spacer(),
                        ],
                      );
                    }
                  }),
            ),
          ],
        )
      ],
    );
  }
}
