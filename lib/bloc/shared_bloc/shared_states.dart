
abstract class SharedStates {}

class InitialSharedState extends SharedStates {}

class LoadingSharedState extends SharedStates {}

class SuccessSharedState extends SharedStates {}

class FailureSharedState extends SharedStates {
  String error;
  FailureSharedState({required this.error});
}

