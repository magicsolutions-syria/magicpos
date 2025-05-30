import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/database/functions/Sections_functions.dart';
import 'package:magicposbeta/theme/locale/locale.dart';
import '../../../modules/user.dart';
import 'section_list_states.dart';

class SectionListCubit extends Cubit<SectionListStates> {
  SectionListCubit(Function() InitialSectionListState, this.currentUser,String initialValue)
      : super(InitialSectionListState()) {
    getListData(sectionFilter: initialValue);
  }

  final User currentUser;
  String sectionName = "";
  List<Map> data = [];

  Future<void> getListData({String sectionFilter = ""}) async {
    try {
      emit(LoadingSectionListState());
      data = await SectionsFunctions.getDepartmentList(sectionFilter);
      sectionName = "";

      emit(SuccessSectionListState());


    } catch (e) {
      emit(
        FailureSectionListState(
          error: e.toString(),
        ),
      );
    }
  }

  void selectCurrentSection(int index) {
    sectionName = data[index]["section_name"];
    emit(SuccessSectionListState());
  }

  Color getColor(int index) {
    if (data[index]["section_name"] == sectionName) {
      return Colors.grey;
    } else {
      return Colors.white;
    }
  }

  Future<void> deleteSelectedSection(String filter) async {
    try {
      emit(LoadingSectionListState());
      await SectionsFunctions.deleteSection(sectionName);
      await getListData(sectionFilter: filter);
      emit(
        CompletedOperationState(
            phrase: SuccessDialogPhrases.deleteOperationComplete),
      );
    } catch (e) {
      emit(
        FailureSectionListState(
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> addSection(String section) async {
    try {
      emit(LoadingSectionListState());
      await SectionsFunctions.addSection(section);
      await getListData(sectionFilter: section);

      emit(
        CompletedOperationState(
            phrase: SuccessDialogPhrases.addOperationComplete),
      );
    } catch (e) {
      emit(
        FailureSectionListState(
          error: e.toString(),
        ),
      );
    }
  }

  deletePermission() {
    return currentUser.product.department.delete;
  }

  addPermission() {
    return currentUser.product.department.add;
  }
}
