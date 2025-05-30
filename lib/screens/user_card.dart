import 'package:flutter/material.dart';
import 'package:magicposbeta/bloc/user_bloc/user_bloc.dart';
import 'package:magicposbeta/components/my_dialog.dart';
import 'package:magicposbeta/screens/home_screen.dart';
import 'package:magicposbeta/theme/custom_colors.dart';
import 'package:magicposbeta/theme/locale/locale.dart';
import '../complex_components/page_slider/page_slider_widget.dart';
import '../components/general_text_field.dart';
import '../components/operator_button.dart';
import '../components/waiting_widget.dart';
import '../lists/user_list.dart';
import '../slider_pages/users_pages/users_pages.dart';
import '../templates/screens_template.dart';
import '../theme/app_formatters.dart';

class UserCard extends StatelessWidget {
  static const String route = "${HomeScreen.route}/user-card";

  const UserCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return UserCubit(() => InitialUserState());
      },
      child: ScreensTemplate(
        appBar: AppBar(
          leading: BlocBuilder<UserCubit, UserStates>(
            builder: (context, state) {
              return IconButton(
                onPressed: () async {
                  Map userItem = {};
                  await showDialog(
                      context: context,
                      builder: (context) => UserList(
                            onDoubleTap: (item) {
                              userItem = item;
                            },
                          ));
                  if (userItem.isNotEmpty && context.mounted) {
                    await BlocProvider.of<UserCubit>(context)
                        .initialUser(userItem);
                  }
                },
                iconSize: 42,
                icon: const Icon(Icons.list),
              );
            },
          ),
        ),
        child: BlocConsumer<UserCubit, UserStates>(
          builder: (BuildContext context, UserStates state) {
            if (state is InitialUserState || state is LoadingUserState) {
              return const WaitingWidget();
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 200,
                    height: 46,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor),
                    child: Center(
                      child: Text(
                        AppFormatters.leftZerosFormat(
                            context.read<UserCubit>().user.id),
                        style: const TextStyle(fontSize: 27),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 23,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 70,
                      ),
                      GeneralTextField(
                          title: FieldsNames.englishName,
                          width: 350,
                          inputType: TextInputType.name,
                          controller: TextEditingController(
                              text: context.read<UserCubit>().user.enName),
                          onChangeFunc: (text) {
                            context.read<UserCubit>().user.enName = text;
                          }),
                      const Spacer(),
                      GeneralTextField(
                          title: FieldsNames.arabicName,
                          width: 350,
                          inputType: TextInputType.name,
                          onlyNumber: const [],
                          controller: TextEditingController(
                              text: context.read<UserCubit>().user.arName),
                          onChangeFunc: (text) {
                            context.read<UserCubit>().user.arName = text;
                          }),
                    ],
                  ),
                  PageSliderWidget(
                    pagesData: {
                      SliderPagesNames.reports: const ReportsPage(),
                      SliderPagesNames.products: const ProductsPage(),
                      SliderPagesNames.suppliersClients:
                          const SuppliersClientsPage(),
                      SliderPagesNames.payKey: const PayKeysPage(),
                      SliderPagesNames.operationKey: const OperatorKeyPage(),
                      SliderPagesNames.information: const InformationPage(),
                    },
                    width: 1400,
                    height: 318,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 230),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OperatorButton(
                            width: 180,
                            onPressed: () =>
                                context.read<UserCubit>().addUser(),
                            text: ButtonsNames.addButton,
                            color: Theme.of(context).primaryColor,
                            enable: context.read<UserCubit>().isAddMode),
                        OperatorButton(
                          width: 180,
                          onPressed: () async {
                            MyDialog.showWarningOperatorDialog(
                              context: context,
                              isWarning: true,
                              title:
                                  WarningsDialogPhrases.areYouSureOfUpdateUser,
                              onTap: () async {
                                await context.read<UserCubit>().updateUser();
                              },
                            );
                          },
                          text: ButtonsNames.updateButton,
                          color: Theme.of(context).primaryColor,
                          enable: !context.read<UserCubit>().isAddMode,
                        ),
                        OperatorButton(
                          width: 180,
                          onPressed: () async {
                            MyDialog.showWarningOperatorDialog(
                              context: context,
                              isWarning: true,
                              title:
                                  WarningsDialogPhrases.areYouSureOfDeleteUser,
                              onTap: () async {
                                await context.read<UserCubit>().deleteUser();
                              },
                            );
                          },
                          text: ButtonsNames.deleteButton,
                          color: Theme.of(context).deleteButtonColor,
                          enable: !context.read<UserCubit>().isAddMode,
                        ),
                        OperatorButton(
                            width: 180,
                            onPressed: () {
                              if (context.read<UserCubit>().isChanged()) {
                                MyDialog.showWarningOperatorDialog(
                                    context: context,
                                    isWarning: true,
                                    title: WarningsDialogPhrases
                                        .doYouWantCancelOperation,
                                    onTap: () {
                                      Navigator.pop(context);
                                    });
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            text: ButtonsNames.cancelButton,
                            color: Theme.of(context).cancelButtonColor,
                            enable: true)
                      ],
                    ),
                  )
                ],
              );
            }
          },
          listener: (BuildContext context, UserStates state) {
            if (state is FailureUserState) {
              MyDialog.showAnimateWrongDialog(
                context: context,
                title: state.error.toString(),
              );
            }
            if (state is CompletedOperationState) {
              MyDialog.showWarningDialog(
                  context: context, isWarning: false, title: state.phrase);
            }
          },
        ),
      ),
    );
  }
}
// finish refactor
