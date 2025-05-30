abstract class DeptStates {}

class InitialDeptState extends DeptStates {}

class LoadingDeptState extends DeptStates {}
class DeptOperationCompleteState extends DeptStates {}

class ChangedDeptState extends DeptStates {}

class FailureDeptState extends DeptStates {
  String error;
  FailureDeptState({required this.error});
}

