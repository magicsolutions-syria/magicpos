import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/database/functions/groups_functions.dart';
import 'package:magicposbeta/theme/locale/locale.dart';
import '../../../modules/user.dart';
import 'group_list_states.dart';

class GroupListCubit extends Cubit<GroupListStates> {
  GroupListCubit(Function() InitialGroupListState, this.currentUser,{String groupFilter="",String sectionFilter=""})
      : super(InitialGroupListState()) {
    getListData();
  }

  final User currentUser;
  String groupName = "";
  String departmentName = "";
  List<Map> data = [];

  Future<void> getListData(
      {String groupFilter = "", String departmentFilter = ""}) async {
    try {
      emit(LoadingGroupListState());
      data = await GroupsFunctions.getGroupsList(
          groupName: groupFilter, departmentName: departmentFilter);
      groupName="";
      departmentName="";
      emit(SuccessGroupListState());
    } catch (e) {
      emit(
        FailureGroupListState(
          error: e.toString(),
        ),
      );
    }
  }

  void selectCurrentGroup(int index) {
    groupName = data[index]["group_name"];
    departmentName = data[index]["section_name"];
    emit(SuccessGroupListState());
  }

  Color getColor(int index) {
    if (data[index]["group_name"] == groupName) {
      return Colors.grey;
    } else {
      return Colors.white;
    }
  }

  Future<void> deleteSelectedGroup({required String groupFilter,required String sectionFilter}) async {
    try {
      emit(LoadingGroupListState());
      await GroupsFunctions.deleteGroup(
          groupName: groupName,
          departmentName: departmentName,
         );
      await getListData(groupFilter: groupFilter,departmentFilter: sectionFilter);
      emit(
        CompletedOperationState(
            phrase: SuccessDialogPhrases.deleteOperationComplete),
      );
    } catch (e) {
      emit(
        FailureGroupListState(
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> addGroup(
      {required String group, required String department}) async {
    try {
      emit(LoadingGroupListState());
      await GroupsFunctions.addGroup(
        groupName: group,
        departmentName: department,
      );
      await getListData(groupFilter: group,departmentFilter: department);

      emit(
        CompletedOperationState(
            phrase: SuccessDialogPhrases.addOperationComplete),
      );
    } catch (e) {
      emit(
        FailureGroupListState(
          error: e.toString(),
        ),
      );
    }
  }

  deletePermission() {
    return currentUser.product.group.delete;
  }

  addPermission() {
    return currentUser.product.group.add;
  }
}
