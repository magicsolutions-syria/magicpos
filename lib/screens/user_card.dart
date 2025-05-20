import 'package:flutter/material.dart';
import 'package:magicposbeta/bloc/user_bloc/user_bloc.dart';
import 'package:magicposbeta/components/my_dialog.dart';
import 'package:magicposbeta/screens/home_screen.dart';
import 'package:magicposbeta/theme/custom_colors.dart';

import 'package:magicposbeta/theme/locale/locale.dart';

import '../components/general_text_field.dart';
import '../components/lists/user_list.dart';
import '../components/operator_button.dart';

import '../components/page_slider/page_slider_widget.dart';
import '../components/waiting_widget.dart';
import '../modules/users_library/users_pages/users_pages.dart';
import '../screens_data/constants.dart';
import '../templates/screens_template.dart';
import '../theme/app_formatters.dart';

class UserCard extends StatelessWidget {
  static const String route = "${HomeScreen.route}/user-card";

  UserCard({
    super.key,
  });

  TextEditingController arName = TextEditingController();
  TextEditingController enName = TextEditingController();

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
                   await BlocProvider.of<UserCubit>(context).initialUser(userItem);
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
              arName.text = context.read<UserCubit>().user.arName;
              enName.text = context.read<UserCubit>().user.enName;

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
                        AppFormatters.idFormat(
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
                          controller: enName,
                          onChangeFunc: (text) {
                            context.read<UserCubit>().user.enName = text;
                          }),
                      const Spacer(),
                      GeneralTextField(
                          title: FieldsNames.arabicName,
                          width: 350,
                          inputType: TextInputType.name,
                          onlyNumber: const [],
                          controller: arName,
                          onChangeFunc: (text) {
                            context.read<UserCubit>().user.arName = text;
                          }),
                    ],
                  ),
                  PageSliderWidget(
                    pagesData: {
                      PagesNames.reports:   const ReportsPage(),
                      PagesNames.products:   const ProductsPage(),
                      PagesNames.suppliersClients:   const SuppliersClientsPage(),
                      PagesNames.payKey:   const PayKeysPage(),
                      PagesNames.operationKey:   const OperatorKeyPage(),
                      PagesNames.information:  InformationPage(),
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
                              if(context.read<UserCubit>().isChanged()) {
                                MyDialog.showWarningOperatorDialog(
                                  context: context,
                                  isWarning: true,
                                  title: WarningsDialogPhrases
                                      .doYouWantCancelOperation,
                                  onTap: () {
                                    Navigator.pop(context);
                                  });
                              }
                              else{
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
