import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/complex_components/check_boxes/check_boxes_cubit.dart';
import 'package:magicposbeta/complex_components/check_boxes/check_boxes_states.dart';

import '../../components/general_report.dart';

class CheckBoxes extends StatelessWidget {
  const CheckBoxes({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CheckBoxesCubit>(
      create: (BuildContext context) {
     return   CheckBoxesCubit(
                () => InitialCheckBoxesState());
      },
      child: Column(
        children: List.generate(data.length + 4, (index) {
          if (index != 0 && index < data.length + 1) {
            return BlocBuilder<CheckBoxesCubit, CheckBoxesStates>(
              builder: (BuildContext context,  state) {
                return SizedBox(height: 25, child: IconButton(onPressed: () {
                  context.read<CheckBoxesCubit>().checkBox(index - 1);
                }, icon: Icon(!checkBoxesList[index - 1] ? Icons
                    .check_box_outline_blank : Icons.check_box_outlined,
                  size: 24,)));
              },

            );

          }
          if(index ==0){
          return const SizedBox(width: 0,height: 23*4.9,);
          }
          return const SizedBox(width: 0,height: 28
          ,
          );
        }),
      ),
    );
  }


}



