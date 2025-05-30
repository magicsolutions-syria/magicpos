import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/general_text_field.dart';
import 'secured_text_field_bloc/secured_text_field_cubit.dart';
import 'secured_text_field_bloc/secured_text_field_states.dart';

class SecuredTitleField extends StatelessWidget {
  const SecuredTitleField({
    super.key,
    required this.controller,
    required this.onChangeFunc,
    required this.title,
  });

  final TextEditingController controller;
  final Function(String text) onChangeFunc;
  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (BuildContext context) {
      return SecuredTextFieldCubit(() => InitialSecuredTextFieldState());
    }, child: BlocBuilder<SecuredTextFieldCubit, SecuredTextFieldStates>(
      builder: (BuildContext context, SecuredTextFieldStates state) {
        if (state is InitialSecuredTextFieldState) {
          return GeneralTextField(
              secure: state.invisible,
              prefix: IconButton(
                onPressed: () {
                  context
                      .read<SecuredTextFieldCubit>()
                      .changeVisible(state.invisible);
                },
                icon: Icon(state.invisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined),
                iconSize: 25,
              ),
              width: 350,
              withSpacer: true,
              title: title,
              controller: controller,
              inputType: TextInputType.visiblePassword,
              onChangeFunc: (text) {
                onChangeFunc(text);
              });
        } else {
          return Container();
        }
      },
    ));
  }
}
