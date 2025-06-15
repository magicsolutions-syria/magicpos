import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/database/functions/groups_functions.dart';
import 'package:magicposbeta/modules/department.dart';
import 'package:magicposbeta/modules/group.dart';
import '../../../database/functions/Sections_functions.dart';
import 'group_view_list_states.dart';

class GroupViewListCubit extends Cubit<GroupViewListStates> {
  GroupViewListCubit(Function() initialGroupListState,
      {required this.pivot,
      required this.departmentField,
      required this.groupField,
      required this.defaultValue})
      : super(initialGroupListState()) {
    groupFilter = "";
    departmentFilter = "";
    getListData();
  }

  final int pivot;
  final String departmentField;
  final String groupField;
  final int defaultValue;
  List<Department> departments = [];
  String groupFilter = "";
  String departmentFilter = "";

  Future<void> getListData() async {
    try {
      emit(LoadingGroupViewListState());

      List<Map> departmentResponse = await SectionsFunctions.getDepartmentList(
        departmentFilter,
        printerCondition:
            defaultValue == -1 ? "printer_id=-1 OR printer_id=$pivot" : "",
        groupFilterValue: groupFilter,
      );

      departments = [];
      for (var department in departmentResponse) {
        Department newDepartment = Department(
            id: department["id_department"],
            name: department["section_name"],
            isSelected: pivot == department[departmentField]);
        List<Map> groupResponse = await GroupsFunctions.getGroupsList(
            departmentId: newDepartment.id,
            departmentName: newDepartment.name,
            groupName: groupFilter,
            printerCondition: defaultValue == -1
                ? "`groups`.printer_id=-1 OR `groups`.printer_id=$pivot"
                : "");
        for (var group in groupResponse) {
          newDepartment.addGroup(
              id: group["id_group"],
              name: group["group_name"],
              isSelected: pivot == group[groupField]);
        }
        print(groupResponse);

        departments.add(newDepartment);
      }
      emit(SuccessGroupViewListState());
    } catch (e) {
      emit(
        FailureGroupViewListState(
          error: e.toString(),
        ),
      );
    }
  }

  void markDepartmentSelect(Department department, bool newValue) {
    departments.firstWhere((element) => element == department).isSelected =
        newValue;
    departments
        .firstWhere((element) => element == department)
        .groups
        .forEach((e) {
      e.isSelected = newValue;
    });

    emit(UpdatedValueState(department.id, -1));
  }

  void changeGroupSelect(Department department, Group group, bool value) {
    departments
        .firstWhere((element) => element == department)
        .groups
        .firstWhere((e) => e == group)
        .isSelected = value;
    if (value) {
      departments
          .firstWhere((element) => element == department)
          .checkIfSelected();
    } else {
      departments.firstWhere((element) => element == department).isSelected =
          false;
    }
    emit(UpdatedValueState(department.id, group.id));
  }

  Future<void> saveChanges() async {
    emit(LoadingGroupViewListState());
    try {
      await SectionsFunctions.changeSelectValues(
          fieldName: departmentField,
          newValue: defaultValue,
          condition:
              defaultValue == -1 ? "printer_id=-1 OR printer_id=$pivot" : "");
      await GroupsFunctions.changeSelectValues(
          fieldName: groupField,
          newValue: defaultValue,
          condition: defaultValue == -1
              ? "`groups`.printer_id=-1 OR `groups`.printer_id=$pivot"
              : "");
      String condition1 = Department.getSelectId(departments);
      String condition2 = "";
      for (var department in departments) {
        condition2 += Group.getSelectId(department.groups);
      }

      if (condition1 != "") {
        await SectionsFunctions.changeSelectValues(
            fieldName: departmentField,
            newValue: pivot,
            condition: "id_department IN($condition1)");
      }
      if (condition2 != "") {
        await GroupsFunctions.changeSelectValues(
            fieldName: groupField,
            newValue: pivot,
            condition: "id_group IN(${condition2.substring(1)})");
      }

      emit(CompletedOperationState());
    } catch (e) {
      emit(FailureGroupViewListState(error: e.toString()));
    }
  }

  Future<void> updateDepartmentFilter(String text) async {
    departmentFilter = text;
    await getListData();
  }

  Future<void> updateGroupFilter(String text) async {
    groupFilter = text;
    await getListData();
  }
}
