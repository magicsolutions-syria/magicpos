import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "../components/control_panel.dart";
import "../components/view_panel.dart";
import "../providers/products_table_provider.dart";
import "package:provider/provider.dart";
import "../components/description_widget.dart";
import "../components/functions_keys_bar.dart";

class PosScreen extends StatelessWidget {
  const PosScreen({super.key});
  static const String route = "/pos-screen";

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ProductsTableProvider(),
        ),
      ],
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              const Expanded(
                flex: 45,
                child: DescriptionWidget(),
              ),
              const Spacer(
                flex: 1,
              ),
              const Expanded(
                flex: 15,
                child: FunctionsKeysBar(),
              ),
              const Spacer(
                flex: 1,
              ),
              Expanded(
                flex: 30,
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 340, child: ViewPanel()),
                    SizedBox(height: 340, child: ControlPanel()),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
