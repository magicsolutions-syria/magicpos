import "package:flutter/material.dart";
import "package:magicposbeta/bloc/shared_bloc/shared_bloc.dart";
import "package:magicposbeta/templates/start_app_template.dart";
import "package:magicposbeta/theme/locale/locale.dart";

class LogInScreen extends StatelessWidget {
  static const String route = "/log_in_screen";

  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StartAppTemplate(
        onPressed: () async {
          await context.read<SharedCubit>().logInUser();
        },
        title: DiversePhrases.logIn,
        buttonName: DiversePhrases.logIn);
  }
}
// finish refactor
