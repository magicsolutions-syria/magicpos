
import 'package:flutter/material.dart';
import 'package:magicposbeta/theme/locale/locale.dart';

import '../bloc/shared_bloc/shared_bloc.dart';
import '../templates/start_app_template.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController userName = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StartAppTemplate(
        userName: userName,
        password: password,
        onPressed: () async {
          await context.read<SharedCubit>().signUpUser(
                password: password.text,
                userName: userName.text,
              );

        },
        title: DiversePhrases.signUp,
        buttonName: DiversePhrases.createAccount);
  }
}
// finish refactor