abstract class DepartmentUpdateStates {}

class InitialDeptState extends DepartmentUpdateStates {}

class LoadingDepartmentState extends DepartmentUpdateStates {}
class DepartmentOperationCompleteState extends DepartmentUpdateStates {}


class FailureDepartmentState extends DepartmentUpdateStates {
  String error;
  FailureDepartmentState({required this.error});
}

