import "package:flutter/material.dart";
import "package:magicposbeta/bloc/shared_bloc/shared_bloc.dart";
import "package:magicposbeta/components/label_text_feild.dart";
import "package:magicposbeta/components/my_dialog.dart";
import "package:magicposbeta/components/operator_button.dart";
import "package:magicposbeta/components/secured_text_field/secured_field_widget.dart";
import "package:magicposbeta/components/waiting_widget.dart";
import "package:magicposbeta/screens/home_screen.dart";
import "package:magicposbeta/templates/main_screens_template.dart";
import "package:magicposbeta/theme/locale/locale.dart";


class StartAppTemplate extends StatelessWidget {
  static const String route = "/log_in_screen";

  const StartAppTemplate({super.key, required this.userName, required this.password, required this.onPressed, required this.title, required this.buttonName});

  final TextEditingController userName ;
  final TextEditingController password ;
  final Function()onPressed;
  final String title;
  final String buttonName;

  @override
  Widget build(BuildContext context) {
    return MainScreensTemplate(
      child: Center(
        child: SizedBox(
          height: 380,
          width: 464,
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 480,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 36,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 1.4,
                          wordSpacing: 2),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    LabelTextFeild(
                      width: 340,
                      height: 70,
                      title:DiversePhrases.userName,
                      controller: userName,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SecuredField(
                      controller: password,
                      title: DiversePhrases.password,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlocConsumer<SharedCubit, SharedStates>(
                      builder: (BuildContext context, state) {
                        if (state is LoadingSharedState) {
                          return const WaitingWidget();
                        } else {
                          return OperatorButton(
                              onPressed: () async {
                                onPressed();
                              },
                              text: buttonName,
                              width: 170,
                              height: 45,
                              fontSize: 20,
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              enable: true);
                        }
                      },
                      listener: (BuildContext context, Object? state) {
                        if (state is FailureSharedState) {
                          MyDialog.showWarningDialog(
                              context: context,
                              isWarning: true,
                              title: state.error);
                        }
                        if(state is SuccessSharedState){
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const Spacer(
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
