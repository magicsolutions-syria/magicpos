import 'package:flutter/material.dart';
import 'package:magicposbeta/theme/locale/locale.dart';

import '../../../bloc/user_bloc/user_bloc.dart';
import '../../../components/check_box_text.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({
    super.key,

  });

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 360,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               Text(
               DiversePhrases.products,
                style: const TextStyle(fontSize: 26),
              ),
              Row(
                children: [
                  CheckBoxText(
                    title: CheckBoxesNames.addProduct,
                    value:  BlocProvider.of<UserCubit>(context).user.product.product.add,
                    width: 170,
                    onChanged: (value) {
                       BlocProvider.of<UserCubit>(context).user.product.product.add = !value;
                    },
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  CheckBoxText(
                    title:CheckBoxesNames.inProduct ,
                    value: BlocProvider.of<UserCubit>(context).user.product.inProduct,
                    width: 170,
                    onChanged: (value) {
                      BlocProvider.of<UserCubit>(context).user.product.inProduct = !value;
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  CheckBoxText(
                    title:CheckBoxesNames.updateProduct,
                    value:  BlocProvider.of<UserCubit>(context).user.product.product.update,
                    width: 170,
                    onChanged: (value) {
                       BlocProvider.of<UserCubit>(context).user.product.product.update = !value;
                    },
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  CheckBoxText(
                    title:CheckBoxesNames.outProduct ,
                    value: BlocProvider.of<UserCubit>(context).user.product.outProduct,
                    width: 170,
                    onChanged: (value) {
                      BlocProvider.of<UserCubit>(context).user.product.outProduct = !value;
                    },
                  ),
                ],
              ),
              CheckBoxText(
                title: CheckBoxesNames.deleteProduct,
                value:  BlocProvider.of<UserCubit>(context).user.product.product.delete,
                width: 170,
                onChanged: (value) {
                   BlocProvider.of<UserCubit>(context).user.product.product.delete = !value;
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
    DiversePhrases.groups ,
                style: const TextStyle(fontSize: 26),
              ),
              CheckBoxText(
                title:CheckBoxesNames.addGroup ,
                value: BlocProvider.of<UserCubit>(context).user.product.group.add,
                width: 191,
                onChanged: (value) {
                  BlocProvider.of<UserCubit>(context).user.product.group.add = !value;
                },
              ),
              CheckBoxText(
                title: CheckBoxesNames.updateGroup,
                value: BlocProvider.of<UserCubit>(context).user.product.group.update,
                width: 191,
                onChanged: (value) {
                  BlocProvider.of<UserCubit>(context).user.product.group.update = !value;
                },
              ),
              CheckBoxText(
                title:CheckBoxesNames.deleteGroup,
                value: BlocProvider.of<UserCubit>(context).user.product.group.delete,
                width: 191,
                onChanged: (value) {
                  BlocProvider.of<UserCubit>(context).user.product.group.delete = !value;
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
                DiversePhrases.departments ,
                style: const TextStyle(fontSize: 26),
              ),
              CheckBoxText(
                title:CheckBoxesNames.addDepartment,
                value: BlocProvider.of<UserCubit>(context).user.product.department.add,
                width: 170,
                onChanged: (value) {
                  BlocProvider.of<UserCubit>(context).user.product.department.add = !value;
                },
              ),
              CheckBoxText(
                title:CheckBoxesNames.updateDepartment ,
                value: BlocProvider.of<UserCubit>(context).user.product.department.update,
                width: 170,
                onChanged: (value) {
                  BlocProvider.of<UserCubit>(context).user.product.department.update = !value;
                },
              ),
              CheckBoxText(
                title:CheckBoxesNames.deleteDepartment ,
                value: BlocProvider.of<UserCubit>(context).user.product.department.delete,
                width: 170,
                onChanged: (value) {
                  BlocProvider.of<UserCubit>(context).user.product.department.delete = !value;
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
