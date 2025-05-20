import 'package:flutter_bloc/flutter_bloc.dart';
import '../../database/users_functions.dart';
import 'start_app_states.dart';

class StartAppCubit extends Cubit<StartAppStates> {
  StartAppCubit(Function() InitialSharedState) : super(InitialSharedState()) {
    initialApp();
  }

  Future<void> initialApp() async {
    try {
      emit(InitialStartAppState());
      List<Map> response =
          await UsersFunctions.getUsersList(searchText: '', searchType: '');
      if (response.isEmpty) {
        emit(StartAppSignUpState());
      } else {
        emit(StartAppLogInState());
      }
    } catch (e) {
      emit(FailureStartAppState());
    }
  }
}
