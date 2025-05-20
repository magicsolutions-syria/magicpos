import 'dart:math';

import 'package:flutter/material.dart';

class CustomToolTip extends StatelessWidget {
  CustomToolTip({
    super.key,
    required this.child,
    required this.text,
    double startVerLimit = 0,
    double endVerLimit = 0,
    double startHorLimit = 0,
    double endHorLimit = 0,
  }) {
    setLimits(startVerLimit, endVerLimit, startHorLimit, endHorLimit);
  }
  final OverlayPortalController controller = OverlayPortalController();
  final Widget child;
  final String text;
  double _startVerLimit = 0;
  double _endVerLimit = 0;
  double _startHorLimit = 0;
  double _endHorLimit = 0;
  void setLimits(double lvs, double lve, double lhs, double lhe) {
    _startHorLimit = min(lhs, lhe);
    _endHorLimit = max(lhs, lhe);
    _startVerLimit = min(lvs, lve);
    _endVerLimit = max(lvs, lve);
  }

  double _OverLayMarginHor = 0;
  double _OverLayMarginVer = 0;
  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: controller,
      overlayChildBuilder: (BuildContext context) {
        if (_OverLayMarginHor == 0 && _OverLayMarginVer == 0) {
          return const SizedBox(
            height: 0,
            width: 0,
          );
        }
        return Positioned(
          left: _OverLayMarginVer,
          top: _OverLayMarginHor,
          child: Container(
            padding: const EdgeInsets.all(5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: const Color(0xFFC4C4C4),
                borderRadius: BorderRadius.circular(8)),
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      },
      child: GestureDetector(
        trackpadScrollCausesScale: true,
        onTapDown: (t) async {
          _OverLayMarginHor = t.globalPosition.dy;
          _OverLayMarginVer = t.globalPosition.dx;

          if (_endVerLimit == 0) {
            _endVerLimit = MediaQuery.of(context).size.width;
          }
          if (_endHorLimit == 0) {
            _endHorLimit = MediaQuery.of(context).size.height;
          }

          if (_OverLayMarginVer <= _endVerLimit &&
              _OverLayMarginVer >= _startVerLimit &&
              _OverLayMarginHor <= _endHorLimit &&
              _OverLayMarginHor >= _startHorLimit) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              controller.show();
              await Future.delayed(const Duration(milliseconds: 1000), () {
                while (controller.isShowing) {
                  controller.toggle();
                }
              });
            });
          }
        },
        child: child,
      ),
    );
  }
}
