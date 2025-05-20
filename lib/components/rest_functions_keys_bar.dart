import "dart:math";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

class RestFunctionsKeysBar extends StatefulWidget {
  const RestFunctionsKeysBar({
    super.key,
    required this.widgets,
  });

  final List widgets;

  @override
  State<RestFunctionsKeysBar> createState() => _RestFunctionsKeysBarState();
}

class _RestFunctionsKeysBarState extends State<RestFunctionsKeysBar> {


  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return GridView.builder(
      padding: EdgeInsets.zero,
      itemCount: widget.widgets.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 59 / 41,
      ),
      itemBuilder: (context, index) => MaterialButton(
        shape: Border(
          top: index < 2 ? const BorderSide() : BorderSide.none,
          left: index % 2 == 0 ? const BorderSide() : BorderSide.none,
          bottom: const BorderSide(),
          right: const BorderSide(),
        ),
        onPressed: widget.widgets[index]["onPressed"],
        onLongPress: widget.widgets[index]["onLongPress"],
        color: widget.widgets[index]["color"],
        child: Text(
          widget.widgets[index]["txt"],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: widget.widgets[index]["fontSize"],
          ),
        ),
      ),
    );
  }
}
