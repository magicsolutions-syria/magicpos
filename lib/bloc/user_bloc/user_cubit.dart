import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/database/users_functions.dart';
import 'package:magicposbeta/modules/user.dart';
import 'package:magicposbeta/theme/custom_exception.dart';
import 'package:magicposbeta/theme/locale/locale.dart';
import 'user_states.dart';

class UserCubit extends Cubit<UserStates> {
  UserCubit(Function() InitialUserState) : super(InitialUserState()) {
    initialCard();
  }

  User user = User.emptyInstance();
  User constUser = User.emptyInstance();

  bool isAddMode = true;

  List<String> jopTitlesNames = [];

  Future<void> initialCard() async {
    try {
      isAddMode = true;
      user = User.emptyInstance();
      jopTitlesNames = await UsersFunctions.getJopTitleList();
      String id = await UsersFunctions.initialUserId();
      user.id = int.parse(id);
      constUser = user;

      emit(SuccessUserState());
    } catch (e) {
      emit(
        FailureUserState(
          error: e.toString(),
        ),
      );
    }
  }

  addUser() async {
    emit(LoadingUserState());
    try {
      if (user.arName == "") {
        throw CustomException(ErrorsCodes.emptyArName);
      }
      if (user.enName == "") {
        throw CustomException(ErrorsCodes.emptyEnName);
      }
      if (user.password == "") {
        throw CustomException(ErrorsCodes.emptyPassword);
      }

      await UsersFunctions.addUser(user: user);
      await initialCard();
      emit(CompletedOperationState(
          phrase: SuccessDialogPhrases.addOperationComplete));
    } catch (e) {
      emit(FailureUserState(error: e.toString()));
    }
  }

  updateUser() async {
    emit(LoadingUserState());
    try {
      if (user.arName == "") {
        throw CustomException(ErrorsCodes.emptyArName);
      }
      if (user.enName == "") {
        throw CustomException(ErrorsCodes.emptyEnName);
      }

      await UsersFunctions.updateUser(user);
      constUser = user;
      emit(CompletedOperationState(
          phrase: SuccessDialogPhrases.updateOperationComplete));
    } catch (e) {
      emit(FailureUserState(error: e.toString()));
    }
  }

  deleteUser() async {
    emit(LoadingUserState());
    try {
      await UsersFunctions.deleteUser(user);
      await initialCard();
      emit(CompletedOperationState(
          phrase: SuccessDialogPhrases.deleteOperationComplete));
    } catch (e) {
      emit(FailureUserState(error: e.toString()));
    }
  }

  Future<void> initialUser(Map item) async {
    emit(LoadingUserState());
    user = await User.instanceFromMap(item);
    constUser = user;
    isAddMode = false;
    emit(SuccessUserState());
  }

  void givePermission({required String job}) {
    user.jobTitle = job;

    user.givePermission(job: job);
  }

  String getPasswordTitle() {
    if (isAddMode) {
      return FieldsNames.password;
    } else {
      return FieldsNames.newPassword;
    }
  }

  bool isChanged() {
    return !(constUser == user);
  }
}
