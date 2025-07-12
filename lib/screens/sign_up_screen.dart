import 'package:flutter/material.dart';
import 'package:magicposbeta/theme/locale/locale.dart';

import '../bloc/shared_bloc/shared_bloc.dart';
import '../templates/start_app_template.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StartAppTemplate(
        onPressed: () async {
          await context.read<SharedCubit>().signUpUser();
        },
        title: DiversePhrases.signUp,
        buttonName: DiversePhrases.createAccount);
  }
}
// finish refactor
