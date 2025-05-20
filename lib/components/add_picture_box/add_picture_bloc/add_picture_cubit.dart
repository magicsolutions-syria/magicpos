import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'add_picture_states.dart';

class AddPictureCubit extends Cubit<AddPictureStates> {
  AddPictureCubit(InitialAddPictureState) : super(InitialAddPictureState());

  Future<String> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (img == null) return "";
    emit(InitialAddPictureState(picturePath: img.path));
    return img.path;
  }

  String removePicture() {
    emit(InitialAddPictureState(picturePath: ""));
    return "";
  }
}
