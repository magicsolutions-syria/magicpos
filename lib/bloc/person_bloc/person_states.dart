abstract class PersonStates {}

class InitialPersonState extends PersonStates {}

class LoadingPersonState extends PersonStates {}

class SuccessPersonState extends PersonStates {}

class FailurePersonState extends PersonStates {
  String error;
  FailurePersonState({required this.error});
}
class CompletedOperationState extends PersonStates {
  String phrase;
  CompletedOperationState({required this.phrase});
}
