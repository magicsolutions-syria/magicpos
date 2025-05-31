import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/theme/custom_colors.dart';
import 'package:magicposbeta/theme/locale/locale.dart';
import 'add_picture_bloc/add_picture_cubit.dart';
import 'add_picture_bloc/add_picture_states.dart';

class AddPictureWidget extends StatelessWidget {
  const AddPictureWidget(
      {super.key, this.initialPath = "", required this.onChanged,});

  final String initialPath;
  final Function(String path) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20, right: 26),
        child: BlocProvider<AddPictureCubit>(
          create: (BuildContext context) {
            return AddPictureCubit(
                () => InitialAddPictureState(picturePath: initialPath));
          },
          child: BlocBuilder<AddPictureCubit, AddPictureStates>(
            builder: (BuildContext context, state) {
              return MaterialButton(
                onPressed: () async {
                  String value =
                      await context.read<AddPictureCubit>().pickImage();
                  onChanged(value);
                },
                minWidth: 240,
                height: 220,
                padding: EdgeInsets.zero,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(width: 1.5),),
                child: Builder(builder: (context) {
                  if (state is InitialAddPictureState) {
                    if (state.picturePath == "") {
                      return Center(
                        child: Text(
                          ButtonsNames.addPicture,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 29),
                        ),
                      );
                    } else {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: 240,
                          height: 220,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(File(state.picturePath)),
                                  fit: BoxFit.fill),
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 190, bottom: 150),
                            child: MaterialButton(
                              onPressed: () {
                                String value = context
                                    .read<AddPictureCubit>()
                                    .removePicture();
                                onChanged(value);
                              },
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                              padding: EdgeInsets.zero,
                              color: Theme.of(context).closeImageColor,
                              minWidth: 50,
                              height: 50,
                              child: Center(
                                child: Icon(
                                  color: Theme.of(context).fieldsColor,
                                  Icons.close,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  } else {
                    return const SizedBox();
                  }
                }),
              );
            },
          ),
        ));
  }
}
