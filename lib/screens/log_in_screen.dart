import "package:flutter/material.dart";
import "package:magicposbeta/bloc/shared_bloc/shared_bloc.dart";
import "package:magicposbeta/templates/start_app_template.dart";
import "package:magicposbeta/theme/locale/locale.dart";

class LogInScreen extends StatelessWidget {
  static const String route = "/log_in_screen";

  LogInScreen({super.key});

  final TextEditingController userName = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StartAppTemplate(
        userName: userName,
        password: password,
        onPressed: () async {
          await context.read<SharedCubit>().logInUser(
                password: password.text,
                userName: userName.text,
              );
        },
        title: DiversePhrases.logIn,
        buttonName: DiversePhrases.logIn);
  }
}
// finish refactor