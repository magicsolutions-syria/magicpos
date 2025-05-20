import 'package:flutter/material.dart';
import 'package:magicposbeta/theme/custom_colors.dart';

import './operator_button.dart';

class MyDialog {
  static const double _fontSize = 24;
  static const double _width = 400;
  static const double _height = 300;
  static const int _duration = 1000;

  static void emptyFunc() {}

  static void showAnimateWarningDialog({
    required BuildContext context,
    required bool isWarning,
    required String title,
    void Function() onStart = emptyFunc,
    void Function() onEnd = emptyFunc,
    void Function() onTap = emptyFunc,
    double hieght = _height,
    double width = _width,
  }) {
    print(onStart);
    onStart();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            onEnd();
            Navigator.pop(context);
          });
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: SizedBox(
                width: width,
                height: hieght,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: hieght - 50,
                        width: width,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Theme.of(context).fieldsColor,
                            borderRadius: BorderRadius.circular(40)),
                        child: Center(
                          child: Text(
                            title,
                            style: const TextStyle(fontSize: _fontSize),
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(context).fieldsColor,
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: isWarning
                              ? Theme.of(context).warningColor
                              : Theme.of(context).okColor,
                          child: Icon(
                            isWarning
                                ? Icons.priority_high_outlined
                                : Icons.check,
                            color: Theme.of(context).fieldsColor,
                            size: 80,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  static void showWarningDialog(
      {required BuildContext context,
      required bool isWarning,
      required String title,
      void Function() onTap = emptyFunc,
      double hieght = _height,
      double width = _width}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: SizedBox(
                width: width,
                height: hieght,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: hieght - 50,
                        width: width,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Theme.of(context).fieldsColor,
                            borderRadius: BorderRadius.circular(40)),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(fontSize: _fontSize),
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                            OperatorButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  onTap();
                                },
                                text: "موافق",
                                color: Theme.of(context).okColor,
                                enable: true),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(context).fieldsColor,
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: isWarning
                              ? Theme.of(context).warningColor
                              : Theme.of(context).okColor,
                          child: Icon(
                            isWarning
                                ? Icons.priority_high_outlined
                                : Icons.check,
                            color: Theme.of(context).fieldsColor,
                            size: 80,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  static Future<void> showWarningOperatorDialog(
      {required BuildContext context,
      required bool isWarning,
      double width = _width,
      double height = _height,
      required String title,
      required void Function() onTap,
      void Function() onCancel = emptyFunc,
      String okButtonName = "موافق"}) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: SizedBox(
                width: width,
                height: height,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: height - 50,
                        width: width,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: Theme.of(context).fieldsColor,
                            borderRadius: BorderRadius.circular(40)),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 60,
                            ),
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(fontSize: _fontSize),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                OperatorButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      onCancel();
                                    },
                                    text: "إلغاء",
                                    color: Theme.of(context).deleteButtonColor,
                                    enable: true),
                                OperatorButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      onTap();
                                    },
                                    text: okButtonName,
                                    color: Theme.of(context).okColor,
                                    enable: true),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(context).fieldsColor,
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: isWarning
                              ? Theme.of(context).warningColor
                              : Theme.of(context).okColor,
                          child: Icon(
                            isWarning
                                ? Icons.priority_high_outlined
                                : Icons.close,
                            color: Theme.of(context).fieldsColor,
                            size: 80,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  static void showAnimateWrongDialog(
      {required BuildContext context,
      required String title,
      void Function() onTap = emptyFunc,
      double height = _height,
      double width = _width,
      int duration = _duration}) {
    bool isPop = false;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (context.mounted && !isPop) {
              Navigator.pop(context);
              isPop = true;
            }
          });
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: SizedBox(
                width: width,
                height: height,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: height - 50,
                        width: width,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Theme.of(context).fieldsColor,
                            borderRadius: BorderRadius.circular(40)),
                        child: Center(
                          child: Text(
                            title,
                            style: const TextStyle(fontSize: _fontSize),
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(context).fieldsColor,
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Theme.of(context).deleteButtonColor,
                          child: Icon(
                            Icons.close,
                            color: Theme.of(context).fieldsColor,
                            size: 80,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
