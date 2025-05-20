import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/modules/custom_exception.dart';
import 'package:magicposbeta/modules/general_settings.dart';
import 'package:magicposbeta/modules/user.dart';
import 'package:magicposbeta/theme/locale/errors.dart';
import '../../database/database_functions.dart';
import '../../database/users_functions.dart';
import '../../modules/printer.dart';
import 'shared_states.dart';

class SharedCubit extends Cubit<SharedStates> {
  SharedCubit(Function() InitialUserState) : super(InitialUserState());
  User currentUser = User.emptyInstance();
  late GeneralSettings settings;

  Future<void> logInUser(
      {required String password, required String userName}) async {
    try {
      emit(LoadingSharedState());
      if (userName.isEmpty) {
        throw CustomException(ErrorsCodes.emptyUser);
      }
      if (password.isEmpty) {
        throw CustomException(ErrorsCodes.emptyPassword);
      }

      currentUser = await UsersFunctions.verifyUser(userName, password);
      settings = await GeneralSettings.getSettings();
      Printer.linkPrinters();

      emit(SuccessSharedState());
    } catch (e) {
      emit(FailureSharedState(error: e.toString()));
    }
  }

  Future<void> signUpUser({required String password, required userName}) async {
    try {
      emit(LoadingSharedState());
      if (password.isEmpty) {
        throw CustomException();
      }
      if (userName.isEmpty) {
        throw CustomException();
      }
      await initialTablesData();
      currentUser = await UsersFunctions.addMangerUser(
          name: userName, password: password);
      settings = await GeneralSettings.getSettings();
      Printer.linkPrinters();
      emit(SuccessSharedState());
    } catch (e) {
      emit(FailureSharedState(error: e.toString()));
    }
  }
}
