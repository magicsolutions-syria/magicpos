import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/components/add_picture_box/add_picture_bloc/add_picture_cubit.dart';
import 'package:magicposbeta/theme/custom_colors.dart';
import 'package:magicposbeta/theme/locale/locale.dart';
import 'add_picture_bloc/add_picture_states.dart';

class AddPictureWidget extends StatelessWidget {
  const AddPictureWidget(
      {super.key, required this.controller, this.initialPath = ""});

  final TextEditingController controller;
  final String initialPath;

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
                  controller.text =
                      await context.read<AddPictureCubit>().pickImage();
                },
                minWidth: 240,
                padding: EdgeInsets.zero,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(width: 1.5)),
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
                                  image: FileImage(File(controller.text)),
                                  fit: BoxFit.fill),
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 190, bottom: 150),
                            child: MaterialButton(
                              onPressed: () {
                                controller.text = context
                                    .read<AddPictureCubit>()
                                    .removePicture();
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
