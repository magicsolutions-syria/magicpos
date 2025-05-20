import 'dart:async';

import 'package:flutter/material.dart';
import 'package:magicposbeta/components/settings_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens_data/constants.dart';

class RadioText extends StatelessWidget {
  RadioText(
      {super.key,
      required this.title,
      required this.values,
      required this.names,
      required this.hieght,
      required String initialValue,
      required this.width,
      required this.sharePrefernekeyName}) {
    groupValue = initialValue;
  }

  final StreamController streamController = StreamController();
  final List<String> values;
  final List<String> names;
  String groupValue = "";
  final String title;
  final double hieght;
  final double width;
  final String sharePrefernekeyName;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        initialData: true,
        stream: streamController.stream,
        builder: (context, snapshot) {
          return SizedBox(
            height: hieght,
            width: width,
            child: Column(
              children: [
                SettingsTitle(title: title),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        RadioMenuButton(
                            value: values[index],
                            groupValue: groupValue,
                            onChanged: (value) async {
                              groupValue = value!;
                              SharedPreferences data =
                                  await SharedPreferences.getInstance();
                              data.setString(sharePrefernekeyName, value);
                              streamController.add(value);
                            },
                            child: const SizedBox(
                              width: 0,
                            )),
                        Text(
                          names[index],
                          style: const TextStyle(fontSize: 24),
                        ),
                        Spacer(),
                      ],
                    );
                  },
                  itemCount: values.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 15,
                    );
                  },
                )
              ],
            ),
          );
        });
  }
}
