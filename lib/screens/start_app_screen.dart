import 'package:flutter/material.dart';
import 'package:magicposbeta/screens/log_in_screen.dart';
import 'package:magicposbeta/screens/sign_up_screen.dart';
import 'package:magicposbeta/theme/locale/errors.dart';

import '../bloc/start_app_bloc/start_app_bloc.dart';

class StartAppScreen extends StatelessWidget {
  static const route = "/initial_screen";

  const StartAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return StartAppCubit(() => InitialStartAppState());
      },
      child: BlocBuilder<StartAppCubit, StartAppStates>(
          builder: (BuildContext context, StartAppStates state) {
        switch (state) {
          case InitialStartAppState _:
            {
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Image.asset(
                    "assets/images/logo-test.jpg",
                    width: 150,
                    height: 150,
                  ),
                ),
              );
            }
          case StartAppLogInState _:
            {
              return LogInScreen();
            }
          case StartAppSignUpState _:
            {
              return SignUpScreen();
            }
          default:
            {
              return const Scaffold(
                body: Text(ErrorsCodes.startAppFail),
              );
            }
        }
      }),
    );
  }
}
