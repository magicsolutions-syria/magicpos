import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/modules/products_classes/info_department.dart';
import 'package:magicposbeta/modules/products_classes/info_group.dart';
import 'package:magicposbeta/modules/user.dart';
import '../../../../database/functions/groups_functions.dart';
import 'group_update_states.dart';

class GroupUpdateCubit extends Cubit<GroupUpdateStates> {
  GroupUpdateCubit(Function() initialDepartmentUpdateState, this.user)
      : super(initialDepartmentUpdateState());
  late final User user;
  InfoGroup oldGroup = InfoGroup.emptyInstance();
  InfoDepartment oldDepartment = InfoDepartment.emptyInstance();
  InfoGroup newGroup = InfoGroup.emptyInstance();
  InfoDepartment newDepartment = InfoDepartment.emptyInstance();

  bool permission() {
    return user.product.group.update;
  }

  Future<void> update() async {
    emit(LoadingGroupState());
    try {
      await GroupsFunctions.updateGroup(
        oldGroup: oldGroup,
        newGroup: newGroup,
      );
      oldGroup = InfoGroup.emptyInstance();
      oldDepartment = InfoDepartment.emptyInstance();
      newGroup = InfoGroup.emptyInstance();
      newDepartment = InfoDepartment.emptyInstance();

      emit(GroupOperationCompleteState());
    } catch (e) {
      emit(FailureGroupState(error: e.toString()));
    }
  }

  void updateGroup({required String group, required String department}) {
    oldDepartment.setName(department);
    newDepartment.setName(department);
    oldGroup.setName(group);
    emit(ChangedValueState());
  }

  void updateDepartment(String departmentVal) {
    newDepartment.setName(departmentVal);
    emit(ChangedValueState());
  }
}
