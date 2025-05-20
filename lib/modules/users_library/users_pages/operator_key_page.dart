import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/bloc/user_bloc/user_bloc.dart';
import 'package:magicposbeta/theme/locale/locale.dart';

import '../../../components/check_box_text.dart';

class OperatorKeyPage extends StatelessWidget {
  const OperatorKeyPage({
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
                title: CheckBoxesNames.accessToDepts,
                value: BlocProvider.of<UserCubit>(context)
                    .user
                    .operationKeys
                    .deptAccess,
                width: 220,
                onChanged: (value) {
                  BlocProvider.of<UserCubit>(context)
                      .user
                      .operationKeys
                      .deptAccess = !value;
                },
              ),
              CheckBoxText(
                title: CheckBoxesNames.data,
                value:
                    BlocProvider.of<UserCubit>(context).user.operationKeys.data,
                width: 220,
                onChanged: (value) {
                  BlocProvider.of<UserCubit>(context).user.operationKeys.data =
                      !value;
                },
              ),
              CheckBoxText(
                title:CheckBoxesNames.print ,
                value: BlocProvider.of<UserCubit>(context)
                    .user
                    .operationKeys
                    .printer,
                width: 220,
                onChanged: (value) {
                  BlocProvider.of<UserCubit>(context)
                      .user
                      .operationKeys
                      .printer = !value;
                },
              ),
              CheckBoxText(
                title: CheckBoxesNames.openDrawer,
                value: BlocProvider.of<UserCubit>(context)
                    .user
                    .operationKeys
                    .drawer,
                width: 220,
                onChanged: (value) {
                  BlocProvider.of<UserCubit>(context)
                      .user
                      .operationKeys
                      .drawer = !value;
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CheckBoxText(
                title:CheckBoxesNames.changeQty,
                value: BlocProvider.of<UserCubit>(context)
                    .user
                    .operationKeys
                    .changeQty,
                width: 220,
                onChanged: (value) {
                  BlocProvider.of<UserCubit>(context)
                      .user
                      .operationKeys
                      .changeQty = !value;
                },
              ),
              CheckBoxText(
                title:CheckBoxesNames.rF,
                value:
                    BlocProvider.of<UserCubit>(context).user.operationKeys.RF,
                width: 220,
                onChanged: (value) {
                  BlocProvider.of<UserCubit>(context).user.operationKeys.RF =
                      !value;
                },
              ),
              CheckBoxText(
                title: CheckBoxesNames.allCancel,
                value: BlocProvider.of<UserCubit>(context)
                    .user
                    .operationKeys
                    .allCancel,
                width: 220,
                onChanged: (value) {
                  BlocProvider.of<UserCubit>(context)
                      .user
                      .operationKeys
                      .allCancel = !value;
                },
              ),
              CheckBoxText(
                title:CheckBoxesNames.changePrice,
                value: BlocProvider.of<UserCubit>(context)
                    .user
                    .operationKeys
                    .changePrice,
                width: 220,
                onChanged: (value) {
                  BlocProvider.of<UserCubit>(context)
                      .user
                      .operationKeys
                      .changePrice = !value;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
