import 'package:flutter/material.dart';
import 'package:magicposbeta/components/custom_drop_down_menu.dart';
import 'package:magicposbeta/components/general_text_field.dart';
import 'package:magicposbeta/theme/locale/locale.dart';
import '../../../bloc/user_bloc/user_bloc.dart';
import '../../../components/secured_text_field/secured_title_field_widget.dart';

class InformationPage extends StatelessWidget {
  InformationPage({
    super.key,
  });

 final TextEditingController password = TextEditingController();

  final TextEditingController email = TextEditingController();

  final TextEditingController phone = TextEditingController();

  final TextEditingController jopTitle = TextEditingController();

  @override
  Widget build(BuildContext context) {
    email.text = BlocProvider.of<UserCubit>(context).user.arName;
    phone.text=BlocProvider.of<UserCubit>(context).user.phone;
    jopTitle.text = BlocProvider.of<UserCubit>(context).user.jobTitle;
    jopTitle.addListener(() {
      if (jopTitle.text != context.read<UserCubit>().user.jobTitle) {
        BlocProvider.of<UserCubit>(context).givePermission(job: jopTitle.text);
        BlocProvider.of<UserCubit>(context).user.jobTitle = jopTitle.text;
      }
    });

    return Padding(
      padding: const EdgeInsets.only(right: 35, left: 35),
      child: Row(
        children: [
          SizedBox(
            width: 513.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GeneralTextField(
                    width: 350,
                    withSpacer: true,
                    title: FieldsNames.email,
                    controller: email,
                    inputType: TextInputType.emailAddress,
                    onChangeFunc: (text) {
                      context.read<UserCubit>().user.email = text;
                    }),
                CustomDropDownMenu(
                  width: 350,
                  enableFilter: false,
                  title: FieldsNames.jopTitle,
                  controller: jopTitle,
                  enableSearch: true,
                  initVal: jopTitle.text,
                  data: context.read<UserCubit>().jopTitlesNames,
                  notify: () {},
                ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width:
                462 + (BlocProvider.of<UserCubit>(context).isAddMode ? 0 : 85),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GeneralTextField(
                  width: 350,
                  withSpacer: true,
                  title: FieldsNames.mobile,
                  controller: phone,
                  onChangeFunc: (text) {
                    context.read<UserCubit>().user.phone = text;
                  },
                  inputType: TextInputType.phone,
                ),
                SecuredTitleField(
                  controller: password,
                  onChangeFunc: (text) {
                    context.read<UserCubit>().user.password = text;
                  },
                  title: context.read<UserCubit>().getPasswordTitle(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
