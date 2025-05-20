import 'package:flutter/material.dart';
import 'package:magicposbeta/theme/custom_colors.dart';

class ScreensTemplate extends StatelessWidget {
  ScreensTemplate({super.key, required this.child, this.appBar});
  final FocusNode _node = FocusNode();
  final Widget child;

  final PreferredSizeWidget? appBar;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        _node.unfocus();
      },
      child: KeyboardListener(
        focusNode: _node,
        child: Scaffold(
          appBar: appBar,
          body: SingleChildScrollView(
            child: Container(
              height: appBar == null ? 684 : 610,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 35),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.6),
                  border: Border.all(width: 1),
                  color: Theme.of(context).fieldsColor),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
