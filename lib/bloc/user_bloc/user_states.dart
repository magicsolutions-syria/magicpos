
abstract class UserStates {}

class InitialUserState extends UserStates {}

class LoadingUserState extends UserStates {}

class SuccessUserState extends UserStates {}

class FailureUserState extends UserStates {
  String error;
  FailureUserState({required this.error});
}
class CompletedOperationState extends UserStates {
  String phrase;
  CompletedOperationState({required this.phrase});
}
