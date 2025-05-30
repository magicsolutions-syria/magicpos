import 'package:flutter/material.dart';
import '../../../bloc/user_bloc/user_bloc.dart';
import '../../../components/check_box_text.dart';

class PayKeysPage extends StatelessWidget {
  const PayKeysPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CheckBoxText(
                title: '+',
                value: BlocProvider.of<UserCubit>(context).user.payKeys.plus,
                width: 130,
                onChanged: (value) {
                  BlocProvider.of<UserCubit>(context).user.payKeys.plus =
                      !value;
                },
              ),
              CheckBoxText(
                title: '+%',
                value: BlocProvider.of<UserCubit>(context).user.payKeys.plusPer,
                width: 130,
                onChanged: (value) {
                  BlocProvider.of<UserCubit>(context).user.payKeys.plusPer =
                      !value;
                },
              ),
              CheckBoxText(
                title: '-',
                value: BlocProvider.of<UserCubit>(context).user.payKeys.minus,
                width: 130,
                onChanged: (value) {
                  BlocProvider.of<UserCubit>(context).user.payKeys.minus =
                      !value;
                },
              ),
              CheckBoxText(
                title: '-%',
                value:
                    BlocProvider.of<UserCubit>(context).user.payKeys.minusPer,
                width: 130,
                onChanged: (value) {
                  BlocProvider.of<UserCubit>(context).user.payKeys.minusPer =
                      !value;
                },
              ),
              CheckBoxText(
                title: 'ch',
                value: BlocProvider.of<UserCubit>(context).user.payKeys.ch,
                width: 130,
                onChanged: (value) {
                  BlocProvider.of<UserCubit>(context).user.payKeys.ch = !value;
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CheckBoxText(
                title: 'VISA2',
                value: BlocProvider.of<UserCubit>(context).user.payKeys.visa2,
                width: 130,
                onChanged: (value) {
                  BlocProvider.of<UserCubit>(context).user.payKeys.visa2 =
                      !value;
                },
              ),
              CheckBoxText(
                title: 'VISA1',
                value: BlocProvider.of<UserCubit>(context).user.payKeys.visa1,
                width: 130,
                onChanged: (value) {
                  BlocProvider.of<UserCubit>(context).user.payKeys.visa1 =
                      !value;
                },
              ),
              CheckBoxText(
                title: 'PD',
                value: BlocProvider.of<UserCubit>(context).user.payKeys.pd,
                width: 130,
                onChanged: (value) {
                  BlocProvider.of<UserCubit>(context).user.payKeys.pd = !value;
                },
              ),
              CheckBoxText(
                title: 'RC',
                value: BlocProvider.of<UserCubit>(context).user.payKeys.rc,
                width: 130,
                onChanged: (value) {
                  BlocProvider.of<UserCubit>(context).user.payKeys.rc = !value;
                },
              ),
              CheckBoxText(
                title: 'CHK',
                value: BlocProvider.of<UserCubit>(context).user.payKeys.chk,
                width: 130,
                onChanged: (value) {
                  BlocProvider.of<UserCubit>(context).user.payKeys.chk = !value;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
