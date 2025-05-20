import 'package:flutter/material.dart';
import 'package:magicposbeta/theme/custom_colors.dart';

class WaitingWidget extends StatelessWidget {
  const WaitingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 50,
        height: 50,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}
