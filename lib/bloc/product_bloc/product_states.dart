abstract class ProductCardStates {}

class InitialProductCardState extends ProductCardStates {}

class LoadingProductCardState extends ProductCardStates {}

class SuccessProductCardState extends ProductCardStates {}
class ChangedValueState extends ProductCardStates {}

class FailureProductCardState extends ProductCardStates {
  String error;
  FailureProductCardState({required this.error});
}
class CompletedOperationState extends ProductCardStates {
  String phrase;
  CompletedOperationState({required this.phrase});
}
