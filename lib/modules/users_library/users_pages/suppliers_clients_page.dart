import 'package:flutter/material.dart';
import 'package:magicposbeta/theme/locale/locale.dart';
import '../../../bloc/user_bloc/user_bloc.dart';
import '../../../components/check_box_text.dart';


class SuppliersClientsPage extends StatelessWidget {
  const SuppliersClientsPage(
      {super.key,
    });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 215,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               Text(
                DiversePhrases.clients,
                style: const TextStyle(fontSize: 26),
              ),
              CheckBoxText(
                title: CheckBoxesNames.addClient,
                value:  BlocProvider.of<UserCubit>(context).user.clients.add,
                width: 170,
                onChanged: (value) {
                   BlocProvider.of<UserCubit>(context).user.clients.add = !value;
                },
              ),
              CheckBoxText(
                title: CheckBoxesNames.updateClient,
                value:  BlocProvider.of<UserCubit>(context).user.clients.update,
                width: 170,
                onChanged: (value) {
                   BlocProvider.of<UserCubit>(context).user.clients.update = !value;
                },
              ),
              CheckBoxText(
                title: CheckBoxesNames.deleteClient,
                value:  BlocProvider.of<UserCubit>(context).user.clients.delete,
                width: 170,
                onChanged: (value) {
                   BlocProvider.of<UserCubit>(context).user.clients.delete = !value;
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 25),
          child: Container(
            width: 1,
            color: Colors.grey,
          ),
        ),
        SizedBox(
          width: 215,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
               Text(
               DiversePhrases.suppliers,
                style: const TextStyle(fontSize: 26),
              ),
              CheckBoxText(
                title:CheckBoxesNames.addSupplier ,
                value:  BlocProvider.of<UserCubit>(context).user.suppliers.add,
                width: 170,
                onChanged: (value) {
                   BlocProvider.of<UserCubit>(context).user.suppliers.add = !value;
                },
              ),
              CheckBoxText(
                title:CheckBoxesNames.updateSupplier ,
                value:  BlocProvider.of<UserCubit>(context).user.suppliers.update,
                width: 170,
                onChanged: (value) {
                   BlocProvider.of<UserCubit>(context).user.suppliers.update = !value;
                },
              ),
              CheckBoxText(
                title:CheckBoxesNames.deleteSupplier ,
                value:  BlocProvider.of<UserCubit>(context).user.suppliers.delete,
                width: 170,
                onChanged: (value) {
                   BlocProvider.of<UserCubit>(context).user.suppliers.delete = !value;
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
