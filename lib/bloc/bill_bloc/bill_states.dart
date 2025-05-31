abstract class BillStates {}

class InitialBillState extends BillStates {}

class LoadingBillState extends BillStates {}
class ChangedHeaderState extends BillStates {}
class FailureBillState extends BillStates {
  final String error;
  FailureBillState(this.error);
}
class SuccessBillState extends BillStates {}


