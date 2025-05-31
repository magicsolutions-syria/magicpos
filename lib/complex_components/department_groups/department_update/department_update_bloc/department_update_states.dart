abstract class DepartmentUpdateStates {}

class InitialDepartmentState extends DepartmentUpdateStates {}

class LoadingDepartmentState extends DepartmentUpdateStates {}
class ChangedValueState extends DepartmentUpdateStates{}
class DepartmentOperationCompleteState extends DepartmentUpdateStates {}


class FailureDepartmentState extends DepartmentUpdateStates {
  String error;
  FailureDepartmentState({required this.error});
}

