import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/modules/user.dart';
import '../../../../database/depts_functions.dart';
import 'dept_states.dart';

class DeptCubit extends Cubit<DeptStates> {
  DeptCubit(Function() initialDeptState) : super(initialDeptState()) {
    getDeptData(1);
  }

  int deptNumber = 1;
  String deptName = "";

  String deptSection = "";

  Future<void> getDeptData(int number) async {
    try {
      deptNumber = number;
      List<Map> response = await DeptsFunctions.getDept(number);
      deptName = response[0]["name"];
      deptSection = response[0]["section_name"];
      emit(ChangedDeptState());
    } catch (e) {
      emit(FailureDeptState(error: e.toString()));
    }
  }

  Future<void> saveDeptSettings() async {
    emit(LoadingDeptState());
    try {
      await DeptsFunctions.deptUpdate(
          id: deptNumber, name: deptName, section: deptSection);
      emit(DeptOperationCompleteState());
    } catch (e) {
      emit(FailureDeptState(error: e.toString()));
    }
  }

  void updateDeptName(value) {
    deptName = value;
    emit(ChangedDeptState());
  }

  void updateDeptSection(String value) {
    deptSection = value;
    emit(ChangedDeptState());
  }
}
