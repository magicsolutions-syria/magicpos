import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magicposbeta/modules/person.dart';
import 'package:magicposbeta/theme/custom_exception.dart';
import 'package:magicposbeta/theme/locale/locale.dart';

import '../../database/functions/person_functions.dart';
import '../../modules/user.dart';
import 'person_states.dart';

class PersonCubit extends Cubit<PersonStates> {
  PersonCubit(Function() InitialPersonState, this.tableName, this.currentUser)
      : super(InitialPersonState()) {
    initialCard();
  }

  Person person = Person.emptyInstance();
  Person constPerson = Person.emptyInstance();
final User currentUser;
  bool isAddMode = true;
  final String tableName;

  Future<void> initialCard() async {

    try {
      isAddMode=true;
      person = Person.emptyInstance();
      constPerson=person;

      String id = await PersonFunctions.initialPersonId(tableName);

      person.id = int.parse(id);

      emit(SuccessPersonState());
    } catch (e) {
      emit(
        FailurePersonState(
          error: e.toString(),
        ),
      );
    }
  }



  bool deletePermission() {
    if(tableName==DiversePhrases.clients) {
      return !isAddMode && currentUser.clients.delete;
    }
    else{
      return !isAddMode && currentUser.suppliers.delete;
    }
  }

  bool updatePermission() {
    if(tableName==DiversePhrases.clients) {
      return !isAddMode && currentUser.clients.update;
    }
    else{
      return !isAddMode && currentUser.suppliers.update;
    }
  }

  bool addPermission() {
    if(tableName==DiversePhrases.clients) {
      return isAddMode && currentUser.clients.add;
    }
    else{
      return isAddMode && currentUser.suppliers.add;
    }
  }

  addPerson() async {
    emit(LoadingPersonState());
    try {
      if (person.arName == "") {
        throw CustomException(ErrorsCodes.emptyArName);
      }
      if (person.barcode == "") {
        throw CustomException(ErrorsCodes.emptyBarcode);
      }
      await PersonFunctions.addPerson(person,tableName);
      await initialCard();

      emit(CompletedOperationState(
          phrase: SuccessDialogPhrases.addOperationComplete));
    } catch (e) {
      emit(FailurePersonState(error: e.toString()));
    }
  }

  updatePerson() async {
    emit(LoadingPersonState());
    try {
      if (person.arName == "") {
        throw CustomException(ErrorsCodes.emptyArName);
      }
      if (person.barcode == "") {
        throw CustomException(ErrorsCodes.emptyBarcode);
      }
      await PersonFunctions.updatePerson(person,tableName);
      constPerson=person;
      emit(CompletedOperationState(
          phrase: SuccessDialogPhrases.updateOperationComplete));
    } catch (e) {
      emit(FailurePersonState(error: e.toString()));
    }
  }

  deletePerson() async {
    emit(LoadingPersonState());
    try {
      if(person.balance!=0){
        throw CustomException(ErrorsCodes.notZeroBalanceAccount);
      }
      await PersonFunctions.deletePerson(person,tableName);
      await initialCard();
      emit(CompletedOperationState(
          phrase: SuccessDialogPhrases.deleteOperationComplete));
    } catch (e) {
      emit(FailurePersonState(error: e.toString()));
    }
  }

  void initialPerson(Map item) {
    emit(LoadingPersonState());
    person = Person.instanceFromMap(item);
    constPerson=person;
    isAddMode = false;
    emit(SuccessPersonState());
  }

  void checkType() {
    if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(person.tel) && person.tel != "") {
      throw CustomException("الرجاء التأكد من رقم الهاتف");
    }
    if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(person.whatsNum) &&
        person.whatsNum != "") {
      throw CustomException("الرجاء التأكد من رقم الوتساب");
    }
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(person.email) &&
        person.email != "") {
      throw CustomException("الرجاء التأكد من الإيميل");
    }
    if (!RegExp(r'(^[0-9]*$)').hasMatch(person.barcode)) {
      throw CustomException("الرجاء التأكد من الباركود");
    }
  }

  bool isChanged() {
    return !(constPerson==person);
  }

}
