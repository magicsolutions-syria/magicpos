abstract class GroupViewListStates {}

class InitialGroupViewListState extends GroupViewListStates {}

class LoadingGroupViewListState extends GroupViewListStates {}

class SuccessGroupViewListState extends GroupViewListStates {}

class UpdatedValueState extends GroupViewListStates {
  final int idGroup;
  final int idDepartment;

  UpdatedValueState(this.idGroup, this.idDepartment);
}

class FailureGroupViewListState extends GroupViewListStates {
  String error;

  FailureGroupViewListState({required this.error});
}

class CompletedOperationState extends GroupViewListStates {
}
