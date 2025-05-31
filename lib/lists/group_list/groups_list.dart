import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/components/not_availble_widget.dart';
import '../../complex_components/choose_department_button/choose_button.dart';
import 'group_list_bloc/group_list_cubit.dart';
import 'package:magicposbeta/theme/custom_colors.dart';
import 'package:magicposbeta/theme/locale/locale.dart';
import '../../../../bloc/shared_bloc/shared_cubit.dart';
import '../../../../components/bottom_button.dart';
import '../../../../components/my_dialog.dart';
import '../../../../components/operator_button.dart';
import '../../../../components/general_text_field.dart';
import '../../../../components/waiting_widget.dart';
import 'group_list_bloc/group_list_states.dart';

class GroupsList extends StatelessWidget {
  GroupsList({
    super.key,
    required String groupValue,
    required String departmentValue,
    required this.onDoubleTap,
  }) {
    _groupController.text = groupValue;
    _department = departmentValue;
  }

  final FocusNode _node = FocusNode();

  final TextEditingController _groupController = TextEditingController();
  String _department = "";
  final Function({required String groupValue,required String departmentValue}) onDoubleTap;

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _node.unfocus();
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: KeyboardListener(
            focusNode: _node,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 300,
              child: SizedBox(
                width: 462,
                height: 622,
                child: BlocProvider<GroupListCubit>(
                  create: (BuildContext context) {
                    return GroupListCubit(() => InitialGroupListState(),
                        context.read<SharedCubit>().currentUser,groupFilter:_groupController.text,sectionFilter:_department);
                  },
                  child: Column(
                    children: [
                      BlocBuilder<GroupListCubit, GroupListStates>(
                        builder: (BuildContext context, state) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 30, right: 15, left: 15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GeneralTextField(
                                        fontSize: 19.4,
                                        width: 292,
                                        title: "",
                                        prefix: const Icon(
                                          Icons.search,
                                          size: 20,
                                        ),
                                        controller: _groupController,
                                        onChangeFunc: (value) {
                                          context
                                              .read<GroupListCubit>()
                                              .getListData(
                                                  groupFilter: value,
                                                  departmentFilter:
                                                      _department);
                                        },
                                        inputType: TextInputType.text,
                                        onlyNumber: const []),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    OperatorButton(
                                        onPressed: () async {
                                          context
                                              .read<GroupListCubit>()
                                              .addGroup(
                                                  group: _groupController.text,
                                                  department: _department);
                                        },
                                        height: 52,
                                        width: 130,
                                        text: ButtonsNames.addButton,
                                        color: Theme.of(context).primaryColor,
                                        enable: context
                                            .read<GroupListCubit>()
                                            .addPermission())
                                  ],
                                ),
                              ),
                              ChooseButton(
                                  width: 462,
                                  fieldWidth: 292,
                                  initialValue:_department,
                                  onTap: (String value) {
                                    context.read<GroupListCubit>().getListData(
                                        groupFilter: _groupController.text,
                                        departmentFilter: value);
                                  }),
                            ],
                          );
                        },
                      ),
                      Expanded(
                        flex: 7,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 300,
                          width: 465,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Theme(
                            data: ThemeData(
                              scrollbarTheme: ScrollbarThemeData(
                                thumbColor: MaterialStatePropertyAll(
                                  Theme.of(context).disabledColor,
                                ),
                              ),
                            ),
                            child: Scrollbar(
                              controller: scrollController,
                              trackVisibility: true,
                              thickness: 15,
                              thumbVisibility: true,
                              radius: const Radius.circular(5),
                              child:
                                  BlocConsumer<GroupListCubit, GroupListStates>(
                                builder: (BuildContext context,
                                    GroupListStates state) {
                                  List<Map> data =
                                      context.read<GroupListCubit>().data;
                                  if (state is LoadingGroupListState) {
                                    return const WaitingWidget();
                                  } else if (data.isEmpty) {
                                    return const NotAvailableWidget();
                                  } else {

                                    return ListView.separated(
                                        controller: scrollController,
                                        addAutomaticKeepAlives: false,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 50),
                                              child: GestureDetector(
                                                onDoubleTap: () {
                                                  onDoubleTap(
                                                      groupValue: data[index]
                                                          ["group_name"],
                                                      departmentValue:
                                                          data[index]
                                                              ["section_name"]);
                                                  Navigator.pop(context);
                                                },
                                                onTap: () {
                                                  context
                                                      .read<GroupListCubit>()
                                                      .selectCurrentGroup(
                                                          index);
                                                },
                                                child: Container(
                                                  height: 50,
                                                  color: context
                                                      .read<GroupListCubit>()
                                                      .getColor(index),
                                                  padding: EdgeInsets.zero,
                                                  width: 300,
                                                  child: Center(
                                                    child: Text(
                                                      data[index]["group_name"],
                                                      style: const TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                                ),
                                              ));
                                        },
                                        separatorBuilder: (context, index) {
                                          return const Divider(
                                            indent: 50,
                                            thickness: 0,
                                            endIndent: 50,
                                            height: 1,
                                          );
                                        },
                                        itemCount: data.length);
                                  }
                                },
                                listener: (BuildContext context,
                                    GroupListStates state) {
                                  if (state is FailureGroupListState) {
                                    MyDialog.showAnimateWrongDialog(
                                      context: context,
                                      title: state.error.toString(),
                                    );
                                  }
                                  if (state is CompletedOperationState) {
                                    MyDialog.showWarningDialog(
                                        context: context,
                                        isWarning: false,
                                        title: state.phrase);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: 465,
                          height: 40,
                          child: Row(
                            children: [
                              BlocBuilder<GroupListCubit, GroupListStates>(
                                builder: (BuildContext context,
                                    GroupListStates state) {
                                  return BottomButton(
                                    title:ButtonsNames.deleteButton,
                                    enable: context
                                        .read<GroupListCubit>()
                                        .deletePermission(),
                                    leftRadius: 12,
                                    color: Theme.of(context).deleteButtonColor,
                                    onTap: () async {
                                      MyDialog.showWarningOperatorDialog(
                                        height: 300,
                                        context: context,
                                        isWarning: true,
                                        title: WarningsDialogPhrases
                                            .areYouSureOfDeleteGroup,
                                        onTap: () async {
                                          await context
                                              .read<GroupListCubit>()
                                              .deleteSelectedGroup(groupFilter: _groupController.text, sectionFilter: _department);
                                        },
                                      );
                                    },
                                    width: 462,
                                  );
                                },
                              ),
                              BottomButton(
                                rightRadius: 12,
                                title: ButtonsNames.cancelButton,
                                color: Theme.of(context).cancelButtonColor,
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                width: 462,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
