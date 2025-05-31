abstract class GroupUpdateStates {}

class InitialGroupState extends GroupUpdateStates {}

class LoadingGroupState extends GroupUpdateStates {}
class GroupOperationCompleteState extends GroupUpdateStates {}
class ChangedValueState extends GroupUpdateStates {}


class FailureGroupState extends GroupUpdateStates {
  String error;
  FailureGroupState({required this.error});
}

