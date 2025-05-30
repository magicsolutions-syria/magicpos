import 'package:flutter/material.dart';
import 'package:magicposbeta/components/custom_drop_down_menu.dart';
import 'package:magicposbeta/components/general_text_field.dart';
import 'package:magicposbeta/theme/locale/locale.dart';
import '../../../bloc/user_bloc/user_bloc.dart';
import '../../complex_components/secured_text_field/secured_title_field_widget.dart';

class InformationPage extends StatelessWidget {
  const InformationPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                    controller: TextEditingController(
                        text: BlocProvider.of<UserCubit>(context).user.email),
                    inputType: TextInputType.emailAddress,
                    onChangeFunc: (text) {
                      context.read<UserCubit>().user.email = text;
                    }),
                CustomDropDownMenu(
                  width: 350,
                  enableFilter: false,
                  title: FieldsNames.jopTitle,
                  controller: TextEditingController(
                      text: BlocProvider.of<UserCubit>(context).user.jobTitle),
                  enableSearch: true,
                  data: context.read<UserCubit>().jopTitlesNames,
                  notify: () {},
                  onChanged: (String value) {
                    BlocProvider.of<UserCubit>(context)
                        .givePermission(job: value);
                  },
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
                  controller: TextEditingController(
                      text: BlocProvider.of<UserCubit>(context).user.phone),
                  onChangeFunc: (text) {
                    context.read<UserCubit>().user.phone = text;
                  },
                  inputType: TextInputType.phone,
                ),
                SecuredTitleField(
                  controller: TextEditingController(),
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
