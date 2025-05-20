import 'package:flutter/material.dart';
import 'package:magicposbeta/bloc/shared_bloc/shared_bloc.dart';
import 'package:magicposbeta/components/lists/person_info_list.dart';
import 'package:magicposbeta/components/person_box.dart';
import 'package:magicposbeta/components/waiting_widget.dart';
import 'package:magicposbeta/screens/home_screen.dart';
import 'package:magicposbeta/theme/app_formatters.dart';
import 'package:magicposbeta/theme/custom_colors.dart';
import 'package:magicposbeta/theme/locale/locale.dart';

import '../bloc/person_bloc/person_bloc.dart';
import '../components/my_dialog.dart';
import '../components/operator_button.dart';
import '../components/general_text_field.dart';

import '../templates/screens_template.dart';

class PersonCard extends StatelessWidget {
  static const String clientRoute = "${HomeScreen.route}/client_card";
  static const String supplierRoute = "${HomeScreen.route}/supplier_card";

  PersonCard(
      {super.key,
      required this.tableName,
      required this.color,
      required this.title,
      required this.icon,
      required this.fractionDigits});

  final String tableName;
  final Color color;
  final String title;
  final IconData icon;
  final int fractionDigits;

  TextEditingController arName = TextEditingController();
  TextEditingController enName = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController barcode = TextEditingController();
  TextEditingController phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PersonCubit>(
      create: (BuildContext context) {
        return PersonCubit(() => InitialPersonState(), tableName,
            context.read<SharedCubit>().currentUser);
      },
      child: ScreensTemplate(
        appBar: AppBar(
          leading: BlocBuilder<PersonCubit, PersonStates>(
            builder: (context, state) {
              return IconButton(
                onPressed: () async {
                  Map personItem = {};
                  await showDialog(
                      context: context,
                      builder: (context) => PersonInfoList(
                            onDoubleTap: (item) {
                              personItem = item;
                            },
                            tableName: tableName,
                          ));
                  if (personItem.isNotEmpty && context.mounted) {
                    BlocProvider.of<PersonCubit>(context)
                        .initialPerson(personItem);
                  }
                },
                iconSize: 42,
                icon: const Icon(Icons.list),
              );
            },
          ),
        ),
        child: BlocConsumer<PersonCubit, PersonStates>(
          builder: (BuildContext context, PersonStates state) {
            if (state is InitialPersonState || state is LoadingPersonState) {
              return const WaitingWidget();
            } else {
              arName.text = context.read<PersonCubit>().person.arName;
              enName.text = context.read<PersonCubit>().person.enName;
              mobile.text = context.read<PersonCubit>().person.whatsNum;
              phone.text = context.read<PersonCubit>().person.tel;
              email.text = context.read<PersonCubit>().person.email;
              barcode.text = context.read<PersonCubit>().person.barcode;
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 425,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(1000)),
                                height: 160,
                                width: 160,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      icon,
                                      size: 80,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      title,
                                      style: const TextStyle(
                                        fontSize: 29,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(20.6),
                                  border: Border.all(
                                      color:
                                          Theme.of(context).secondaryTextColor,
                                      width: 2),
                                ),
                                padding: const EdgeInsets.all(8),
                                height: 200,
                                width: 400,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    PersonBox(
                                      title: FieldsNames.inBalance,
                                      value: context
                                          .read<PersonCubit>()
                                          .person
                                          .inBalance
                                          .toString(),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(1.0),
                                      child: Divider(
                                        height: 0,
                                        thickness: 2,
                                      ),
                                    ),
                                    PersonBox(
                                      title: FieldsNames.outBalance,
                                      value: context
                                          .read<PersonCubit>()
                                          .person
                                          .outBalance
                                          .toString(),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Divider(
                                        height: 0,
                                        thickness: 2,
                                      ),
                                    ),
                                    PersonBox(
                                      title: FieldsNames.balance,
                                      value: context
                                          .read<PersonCubit>()
                                          .person
                                          .balance
                                          .toString(),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 150),
                                child: Container(
                                  width: 200,
                                  height: 46,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context).primaryColor),
                                  child: Center(
                                    child: Text(
                                      AppFormatters.idFormat(context
                                          .read<PersonCubit>()
                                          .person
                                          .id),
                                      style: const TextStyle(fontSize: 27),
                                    ),
                                  ),
                                ),
                              ),
                              GeneralTextField(
                                title: FieldsNames.arabicName,
                                width: 350,
                                height: 45,
                                inputType: TextInputType.text,
                                onlyNumber: const [],
                                controller: arName,
                                onChangeFunc: (text) {
                                  context.read<PersonCubit>().person.arName =
                                      text;
                                },
                              ),
                              GeneralTextField(
                                title: FieldsNames.englishName,
                                width: 350,
                                height: 45,
                                inputType: TextInputType.text,
                                onlyNumber: const [],
                                controller: enName,
                                onChangeFunc: (text) {
                                  context.read<PersonCubit>().person.enName =
                                      text;
                                },
                              ),
                              GeneralTextField(
                                title: FieldsNames.tel,
                                width: 350,
                                height: 45,
                                inputType: TextInputType.phone,
                                onlyNumber: AppFormatters.numbersIntFormat(),
                                controller: phone,
                                onChangeFunc: (text) {
                                  context.read<PersonCubit>().person.tel = text;
                                },
                              ),
                              GeneralTextField(
                                title: FieldsNames.email,
                                width: 350,
                                height: 45,
                                inputType: TextInputType.emailAddress,
                                onlyNumber: const [],
                                controller: email,
                                onChangeFunc: (text) {
                                  context.read<PersonCubit>().person.email =
                                      text;
                                },
                              ),
                              GeneralTextField(
                                title: FieldsNames.whatsAppNumber,
                                width: 350,
                                height: 45,
                                inputType: TextInputType.phone,
                                onlyNumber: AppFormatters.numbersIntFormat(),
                                controller: mobile,
                                onChangeFunc: (text) {
                                  context.read<PersonCubit>().person.whatsNum =
                                      text;
                                },
                              ),
                              GeneralTextField(
                                title: FieldsNames.barcode,
                                width: 350,
                                height: 45,
                                inputType: TextInputType.number,
                                onlyNumber: AppFormatters.numbersIntFormat(),
                                controller: barcode,
                                onChangeFunc: (text) {
                                  context.read<PersonCubit>().person.barcode =
                                      text;
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 100),
                            child: OperatorButton(
                                width: 180,
                                onPressed: () {},
                                text: ButtonsNames.whatsAppButton,
                                color: Theme.of(context).whatsAppButtonColor,
                                enable: context
                                    .read<PersonCubit>()
                                    .addPermission()),
                          ),
                          OperatorButton(
                              width: 180,
                              onPressed: () =>
                                  context.read<PersonCubit>().addPerson(),
                              text: ButtonsNames.addButton,
                              color: Theme.of(context).primaryColor,
                              enable:
                                  context.read<PersonCubit>().addPermission()),
                          OperatorButton(
                            width: 180,
                            onPressed: () async {
                              MyDialog.showWarningOperatorDialog(
                                context: context,
                                isWarning: true,
                                title: WarningsDialogPhrases
                                    .areYouSureOfUpdateAccount,
                                onTap: () async {
                                  await context
                                      .read<PersonCubit>()
                                      .updatePerson();
                                },
                              );
                            },
                            text: ButtonsNames.updateButton,
                            color: Theme.of(context).primaryColor,
                            enable:
                                context.read<PersonCubit>().updatePermission(),
                          ),
                          OperatorButton(
                              width: 180,
                              onPressed: () async {
                                MyDialog.showWarningOperatorDialog(
                                  context: context,
                                  isWarning: true,
                                  title: WarningsDialogPhrases
                                      .areYouSureOfDeleteAccount,
                                  onTap: () async {
                                    await context
                                        .read<PersonCubit>()
                                        .deletePerson();
                                  },
                                );
                              },
                              text: ButtonsNames.deleteButton,
                              color: Theme.of(context).deleteButtonColor,
                              enable: context
                                  .read<PersonCubit>()
                                  .deletePermission()),
                          OperatorButton(
                              width: 180,
                              onPressed: () {
                                if (context.read<PersonCubit>().isChanged()) {
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
                ),
              );
            }
          },
          listener: (BuildContext context, PersonStates state) {
            if (state is FailurePersonState) {
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