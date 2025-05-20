import 'package:flutter_bloc/flutter_bloc.dart';
import 'secured_text_field_states.dart';

class SecuredTextFieldCubit extends Cubit<SecuredTextFieldStates> {
  SecuredTextFieldCubit(Function() InitialSecuredTextFieldState)
      : super(InitialSecuredTextFieldState());
  void changeVisible(bool visible) {
    emit(InitialSecuredTextFieldState(invisible: !visible));
  }
}
