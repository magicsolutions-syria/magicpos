import 'package:flutter/material.dart';
import 'package:magicposbeta/theme/locale/errors.dart';

class NotAvailableWidget extends StatelessWidget {
  const NotAvailableWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: const Center(
        child: Text(
          ErrorsCodes.emptyData,
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
