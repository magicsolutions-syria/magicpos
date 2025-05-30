import 'package:flutter_bloc/flutter_bloc.dart';

import 'radio_text_states.dart';

class RadioTextCubit extends Cubit<RadioTextStates> {
  RadioTextCubit(Function() initialRadioTextState)
      : super(initialRadioTextState());

  void changeValue(String s) {
    emit(InitialRadioTextState(groupValue: s));
  }

}
