import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/label_text_feild.dart';
import 'secured_text_field_bloc/secured_text_field_cubit.dart';
import 'secured_text_field_bloc/secured_text_field_states.dart';

class SecuredField extends StatelessWidget {
  const SecuredField({super.key, required this.controller, required this.title, required this.onChange});
  final TextEditingController controller;
  final String title;
  final Function(String text)onChange;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (BuildContext context) {
      return SecuredTextFieldCubit(() => InitialSecuredTextFieldState());
    }, child: BlocBuilder<SecuredTextFieldCubit, SecuredTextFieldStates>(
      builder: (BuildContext context, SecuredTextFieldStates state) {
        if (state is InitialSecuredTextFieldState) {
          return LabelTextFeild(
            onChangeFunc: onChange,
            width: 340,
            height: 70,
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
            title: title,
            obscureText: state.invisible,
            controller: controller,
          );
        } else {
          return Container();
        }
      },
    ));
  }
}
