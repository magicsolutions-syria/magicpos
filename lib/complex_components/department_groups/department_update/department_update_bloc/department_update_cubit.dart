import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/database/functions/Sections_functions.dart';
import 'package:magicposbeta/modules/user.dart';
import 'department_update_states.dart';

class DepartmentUpdateCubit extends Cubit<DepartmentUpdateStates> {
  DepartmentUpdateCubit(Function() initialDepartmentUpdateState, this.user)
      : super(initialDepartmentUpdateState());
  late final User user;
  String oldName = "";
  String newName = "";

  bool permission() {
    return user.product.department.update;
  }

  Future<void> update() async {
    emit(LoadingDepartmentState());
    try {
      await SectionsFunctions.updateDepartmentName(
          oldName: oldName, newName: newName);
      oldName="";
      newName="";
      emit(DepartmentOperationCompleteState());
    } catch (e) {
      emit(FailureDepartmentState(error: e.toString()));
    }
  }

  void updateOldName(String text) {
    oldName = text;
    emit(ChangedValueState());
  }
}
