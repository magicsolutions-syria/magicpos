import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/bloc/shared_bloc/shared_cubit.dart';
import 'package:magicposbeta/components/not_availble_widget.dart';
import 'package:magicposbeta/components/waiting_widget.dart';
import 'package:magicposbeta/theme/custom_colors.dart';
import 'package:magicposbeta/theme/locale/locale.dart';
import '../../../../components/bottom_button.dart';
import '../../../../components/my_dialog.dart';
import '../../../../components/operator_button.dart';
import '../../../../components/general_text_field.dart';
import 'section_list_bloc/section_list_cubit.dart';
import 'section_list_bloc/section_list_states.dart';

class SectionsList extends StatelessWidget {
  SectionsList({
    super.key,
    required String value,
    required this.onDoubleTap,
  }) {
    _controller.text = value;
  }

  final FocusNode _node = FocusNode();

  final TextEditingController _controller = TextEditingController();
  final Function(String value) onDoubleTap;
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
                child: BlocProvider<SectionListCubit>(
                  create: (BuildContext context) {
                    return SectionListCubit(() => InitialSectionListState(),
                        context.read<SharedCubit>().currentUser,_controller.text);
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 30, right: 15, left: 15),
                        child: BlocBuilder<SectionListCubit, SectionListStates>(
                          builder: (BuildContext context, state) {
                            return Row(
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
                                    controller: _controller,
                                    onChangeFunc: (value) {
                                      context
                                          .read<SectionListCubit>()
                                          .getListData(sectionFilter: value);
                                    },
                                    inputType: TextInputType.text,
                                    onlyNumber: const []),
                                const SizedBox(
                                  width: 10,
                                ),
                                OperatorButton(
                                    onPressed: () {
                                      context
                                          .read<SectionListCubit>()
                                          .addSection(_controller.text);
                                    },
                                    height: 52,
                                    width: 130,
                                    text: ButtonsNames.addButton,
                                    color: Theme.of(context).primaryColor,
                                    enable: context
                                        .read<SectionListCubit>()
                                        .addPermission()),
                              ],
                            );
                          },
                        ),
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
                              child: BlocConsumer<SectionListCubit,
                                  SectionListStates>(
                                builder: (BuildContext context,
                                    SectionListStates state) {
                                  List<Map> data =
                                      context.read<SectionListCubit>().data;
                                  if (state is LoadingSectionListState) {
                                    return const WaitingWidget();
                                  } else if (data.isEmpty) {
                                    return const NotAvailableWidget();
                                  } else {

                                    return ListView.separated(
                                        controller: scrollController,
                                        addAutomaticKeepAlives: false,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 50),
                                            child: GestureDetector(
                                              onDoubleTap: () {
                                                onDoubleTap(data[index]
                                                    ["section_name"]);
                                                Navigator.pop(context);
                                              },
                                              onTap: () async {
                                                context
                                                    .read<SectionListCubit>()
                                                    .selectCurrentSection(
                                                        index);
                                              },
                                              child: Container(
                                                height: 50,
                                                color: context
                                                    .read<SectionListCubit>()
                                                    .getColor(index),
                                                padding: EdgeInsets.zero,
                                                width: 300,
                                                child: Center(
                                                  child: Text(
                                                    data[index]["section_name"],
                                                    style: const TextStyle(
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
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
                                    SectionListStates state) {
                                  if (state is FailureSectionListState) {
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
                          width: 462,
                          height: 40,
                          child: Row(
                            children: [
                              BlocBuilder<SectionListCubit, SectionListStates>(
                                builder: (BuildContext context,
                                    SectionListStates state) {
                                  return BottomButton(
                                    title: ButtonsNames.deleteButton,
                                    enable: context
                                        .read<SectionListCubit>()
                                        .deletePermission(),
                                    leftRadius: 12,
                                    color: Theme.of(context).deleteButtonColor,
                                    onTap: () async {
                                      MyDialog.showWarningOperatorDialog(
                                          context: context,
                                          isWarning: true,
                                          title: WarningsDialogPhrases
                                              .areYouSureOfDeleteSection,
                                          onTap: () {
                                            context
                                                .read<SectionListCubit>()
                                                .deleteSelectedSection(_controller.text);
                                          });
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
