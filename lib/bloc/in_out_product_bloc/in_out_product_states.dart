abstract class InOutProductStates {}

class InitialInOutProductState extends InOutProductStates {}

class LoadingInOutProductState extends InOutProductStates {}

class ChangedProductDataState extends InOutProductStates {
  final double qty;
  final double price;

  ChangedProductDataState({required this.qty, required this.price});
}


class SuccessInOutProductState extends InOutProductStates {}

class FailureInOutProductState extends InOutProductStates {
  String error;
  FailureInOutProductState({required this.error});
}
class CompletedOperationState extends InOutProductStates {
  String phrase;
  CompletedOperationState({required this.phrase});
}
