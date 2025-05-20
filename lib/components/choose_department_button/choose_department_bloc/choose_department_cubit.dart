import 'package:flutter_bloc/flutter_bloc.dart';

import 'choose_department_states.dart';

class ChooseDepartmentCubit extends Cubit<ChooseDepartmentStates> {
  ChooseDepartmentCubit(InitialChooseDepartmentState) : super(InitialChooseDepartmentState());

  void changeValue(String value) {
    emit(InitialChooseDepartmentState(value: value));
  }


}
