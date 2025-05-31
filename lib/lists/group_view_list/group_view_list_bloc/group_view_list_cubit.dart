import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/components/choises_list.dart';
import 'package:magicposbeta/database/functions/groups_functions.dart';
import 'package:magicposbeta/modules/department.dart';
import 'package:magicposbeta/modules/group.dart';
import '../../../database/functions/Sections_functions.dart';
import '../../../database/initialize_database.dart';
import 'group_view_list_states.dart';

class GroupViewListCubit extends Cubit<GroupViewListStates> {
  GroupViewListCubit(Function() InitialGroupListState,
      {required this.pivot,
      required this.departmentField,
      required this.groupField,
      required this.defaultValue})
      : super(InitialGroupListState()) {
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
      print(departmentResponse);
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
        groupResponse.forEach((group) {
          newDepartment.addGroup(
              id: group["id_group"],
              name: group["group_name"],
              isSelected: pivot == group[groupField]);
        });
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
      PosData data = PosData();
      String printerCondition =
          defaultValue == -1 ? "printer_id=-1 OR printer_id=$pivot" : "";
      String sql = printerCondition == ""
          ? "UPDATE departments SET $departmentField=$defaultValue "
          : "UPDATE departments SET $departmentField=$defaultValue WHERE $printerCondition";
      await data.changeData(sql);
      printerCondition = defaultValue == -1
          ? "`groups`.printer_id=-1 OR `groups`.printer_id=$pivot"
          : "";
      sql = printerCondition == ""
          ? "UPDATE `groups` SET $groupField=$defaultValue "
          : "UPDATE `groups` SET $groupField=$defaultValue WHERE $printerCondition";
      await data.changeData(sql);

      String condition1 = "";
      String condition2 = "";
      List<Department> selectedDepartments =
          departments.where((e) => e.isSelected).toList();
      List<Department> othersDepartment = departments;

      for (int i = 0; i < selectedDepartments.length; i++) {
        condition1 += i == 0 ? "" : " OR ";
        condition1 += " id_department =${selectedDepartments[i].id} ";
        condition2 += i == 0 ? "" : " OR ";
        condition2 += " section_number =${selectedDepartments[i].id} ";
        othersDepartment.remove(selectedDepartments[i]);
      }

      if (condition1 != "") {
        await data.changeData(
            "UPDATE departments SET $departmentField=$pivot WHERE $condition1");
      }

      if (condition2 != "") {
        await data.changeData(
            "UPDATE `groups` SET $groupField=$pivot WHERE $condition2");
      }
      String condition3 = "";

      for (int i = 0; i < othersDepartment.length; i++) {
        List<Group>selectedGroups=othersDepartment[i].groups.where((e)=>e.isSelected).toList();
        selectedGroups.forEach((element) {
          condition3 += "OR id_group =${element.id} ";
        });
      }
      if (condition3 != "") {
        print(condition3.substring(2));
        await data.changeData(
            "UPDATE `groups` SET $groupField=$pivot WHERE${condition3.substring(2)}");
      }

      emit(CompletedOperationState());
    } catch (e) {
      emit(FailureGroupViewListState(error: e.toString()));
    }
  }

  Future<void> updateDepartmentFilter(String text) async {
    print("554444444444444444444444444444444444444444444444444");
    print(text);
    departmentFilter = text;
    await getListData();
  }

  Future<void> updateGroupFilter(String text) async {
    print("554444444444444444444444444444444444444444444444444");
    print(text);
    groupFilter = text;
    await getListData();
  }
}
