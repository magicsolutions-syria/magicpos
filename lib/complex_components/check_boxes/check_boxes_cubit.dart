import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/general_report.dart';
import 'check_boxes_states.dart';

class CheckBoxesCubit extends Cubit<CheckBoxesStates> {
  CheckBoxesCubit(Function() initialCheckBoxesState)
      : super(initialCheckBoxesState());

  void checkBox(int index){
    checkBoxesList[index] = !checkBoxesList[index];
    emit(InitialCheckBoxesState());

  }

}
