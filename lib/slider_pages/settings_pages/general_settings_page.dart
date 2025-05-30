import 'package:flutter/material.dart';
import 'package:magicposbeta/bloc/shared_bloc/shared_bloc.dart';
import 'package:magicposbeta/components/choose_number_field.dart';
import 'package:magicposbeta/components/settings_title.dart';
import 'package:magicposbeta/components/small_hint_text.dart';
import 'package:magicposbeta/theme/locale/locale.dart';

import '../../complex_components/radio_text/radio_text_widget.dart';

class GeneralSettingsPage extends StatelessWidget {
  const GeneralSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ChooseNumberField(
              maxNumber: 3,
              minNumber: 0,
              title: FieldsNames.pricesWidth,
              onChanged: (int number) {
                context
                    .read<SharedCubit>()
                    .settings
                    .setPriceComma(value: number);
              },
              initialValue: context.read<SharedCubit>().settings.priceComma,
            ),
            const Spacer(
              flex: 35,
            ),
            ChooseNumberField(
              maxNumber: 3,
              minNumber: 0,
              title: FieldsNames.qtyWidth,
              onChanged: (int number) async {
                await context
                    .read<SharedCubit>()
                    .settings
                    .setQtyComma(value: number);
              },
              initialValue: context.read<SharedCubit>().settings.qtyComma,
            ),
            const Spacer(
              flex: 65,
            ),
            const SettingsTitle(title: SettingsNames.commas),
          ],
        ),
        const Divider(
          height: 0,
          thickness: 4,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [

            const SettingsTitle(title: DiversePhrases.scaleSettings),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ChooseNumberField(
                  maxNumber: 9,
                  title: FieldsNames.weight,
                  onChanged: (int number) {
                    context
                        .read<SharedCubit>()
                        .settings
                        .setWeightScale(value: number);
                  },
                  initialValue:
                      context.read<SharedCubit>().settings.weightScale,
                ),
                ChooseNumberField(
                  maxNumber: 9,
                  title: FieldsNames.productNumber,
                  onChanged: (int number) {
                    context
                        .read<SharedCubit>()
                        .settings
                        .setProductNumberScale(value: number);
                  },
                  initialValue:
                      context.read<SharedCubit>().settings.productNumberScale,
                ),
                Row(
                  children: [
                    const SmallHintText(title: SettingsNames.onlyTwo),
                    const SizedBox(width: 5),
                    ChooseNumberField(
                      enableEditing: true,
                      minNumber: 0,
                      maxNumber: 99,
                      title: FieldsNames.start,
                      onChanged: (int number) {
                        context
                            .read<SharedCubit>()
                            .settings
                            .setStartScale(value: number.toString());
                      },
                      initialValue: int.parse(
                          context.read<SharedCubit>().settings.startScale),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const Divider(
          height: 0,
          thickness: 4,
        ),
        Row(
          children: [
            SizedBox(
              width: 590,
              child: Center(
                child: RadioText(
                  title: SettingsNames.sellScreen,
                  values: RadiosValues.posScreenGroup(),
                  names: RadiosNames.sellScreenGroup,
                  hieght: 238,
                  width: 273,
                  initialValue: context.read<SharedCubit>().settings.screenType,
                  onChanged: (String value) {
                    context
                        .read<SharedCubit>()
                        .settings
                        .setScreenType(value: value);
                  },
                ),
              ),
            ),
            Container(
              height: 282,
              width: 4,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            SizedBox(
                width: 590,
                child: Center(
                  child: RadioText(
                    title: SettingsNames.sellPrice,
                    values: RadiosValues.priceGroup(),
                    names: RadiosNames.sellPriceGroup,
                    hieght: 270,
                    width: 199,
                    initialValue:
                        context.read<SharedCubit>().settings.priceType,
                    onChanged: (String value) {
                      context
                          .read<SharedCubit>()
                          .settings
                          .setPriceType(value: value);
                    },
                  ),
                )),
          ],
        )
      ],
    );
  }
}
// finish refactor
