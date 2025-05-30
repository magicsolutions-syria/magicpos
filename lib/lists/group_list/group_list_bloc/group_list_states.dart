abstract class GroupListStates {}

class InitialGroupListState extends GroupListStates {}

class LoadingGroupListState extends GroupListStates {}

class SuccessGroupListState extends GroupListStates {}

class FailureGroupListState extends GroupListStates {
  String error;
  FailureGroupListState({required this.error});
}
class CompletedOperationState extends GroupListStates {
  String phrase;
  CompletedOperationState({required this.phrase});
}
