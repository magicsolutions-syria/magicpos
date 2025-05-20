import 'package:flutter/material.dart';
import 'package:magicposbeta/theme/locale/locale.dart';
import '../../../bloc/user_bloc/user_bloc.dart';
import '../../../components/check_box_text.dart';

class ReportsPage extends StatelessWidget {
   const ReportsPage({
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
                title:CheckBoxesNames.clientsReport ,
                value:  BlocProvider.of<UserCubit>(context).user.reports.clients,
                width: 218,
                onChanged: (value) {
                   BlocProvider.of<UserCubit>(context).user.reports.clients = !value;

                },
              ),
              CheckBoxText(
                title: CheckBoxesNames.suppliersReport,
                value:  BlocProvider.of<UserCubit>(context).user.reports.suppliers,
                width: 218,
                onChanged: (value) {
                   BlocProvider.of<UserCubit>(context).user.reports.suppliers = !value;

                },
              ),
              CheckBoxText(
                title: CheckBoxesNames.departmentsReport,
                value:  BlocProvider.of<UserCubit>(context).user.reports.departments,
                width: 218,
                onChanged: (value) {
                   BlocProvider.of<UserCubit>(context).user.reports.departments = !value;

                },
              ),
              CheckBoxText(
                title: CheckBoxesNames.groupsReport,
                value:  BlocProvider.of<UserCubit>(context).user.reports.groups,
                width: 218,
                onChanged: (value) {
                   BlocProvider.of<UserCubit>(context).user.reports.groups = !value;

                },
              ),
              CheckBoxText(
                title:CheckBoxesNames.productsReport ,
                value:  BlocProvider.of<UserCubit>(context).user.reports.products,
                width: 218,
                onChanged: (value) {
                   BlocProvider.of<UserCubit>(context).user.reports.products = !value;

                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CheckBoxText(
                title: CheckBoxesNames.functionsReport,
                value:  BlocProvider.of<UserCubit>(context).user.reports.functions,
                width: 218,
                onChanged: (value) {
                   BlocProvider.of<UserCubit>(context).user.reports.functions = !value;

                },
              ),
              CheckBoxText(
                title: CheckBoxesNames.usersReport,
                value:  BlocProvider.of<UserCubit>(context).user.reports.users,
                width: 218,
                onChanged: (value) {
                   BlocProvider.of<UserCubit>(context).user.reports.users = !value;

                },
              ),
              CheckBoxText(
                title:CheckBoxesNames.cashReport ,
                value:  BlocProvider.of<UserCubit>(context).user.reports.cash,
                width: 218,
                onChanged: (value) {
                   BlocProvider.of<UserCubit>(context).user.reports.cash = !value;

                },
              ),
              CheckBoxText(
                title: CheckBoxesNames.deptsReport,
                value:  BlocProvider.of<UserCubit>(context).user.reports.depts,
                width: 218,
                onChanged: (value) {
                   BlocProvider.of<UserCubit>(context).user.reports.depts = !value;

                },
              ),
              CheckBoxText(
                title:CheckBoxesNames.inventoryReport ,
                value:  BlocProvider.of<UserCubit>(context).user.reports.inventory,
                width: 218,
                onChanged: (value) {
                   BlocProvider.of<UserCubit>(context).user.reports.inventory = !value;

                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
