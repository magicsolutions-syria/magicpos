import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/modules/user.dart';
import '../../../../database/functions/groups_functions.dart';
import 'group_update_states.dart';

class GroupUpdateCubit extends Cubit<GroupUpdateStates> {
  GroupUpdateCubit(Function() initialDepartmentUpdateState, this.user)
      : super(initialDepartmentUpdateState());
  late final User user;
  String oldGroup = "";
  String oldDepartment = "";
  String newGroup = "";
  String newDepartment = "";

  bool permission() {
    return user.product.group.update;
  }

  Future<void> update() async {
    emit(LoadingGroupState());
    try {
      await GroupsFunctions.updateGroup(
          oldName:oldGroup,
          newName:newGroup,
          sectionOld: oldDepartment,
          sectionNew: newDepartment);
       oldGroup = "";
       oldDepartment = "";
       newGroup = "";
       newDepartment = "";
      emit(GroupOperationCompleteState());
    } catch (e) {
      emit(FailureGroupState(error: e.toString()));
    }
  }

  void updateGroup({required String group, required String department}) {
    oldDepartment=department;
    newDepartment=department;
    oldGroup=group;
    emit(ChangedValueState());

  }

  void updateDepartment(String departmentVal) {
    newDepartment=departmentVal;
    emit(ChangedValueState());
  }
}
