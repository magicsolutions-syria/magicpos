abstract class ProductCardListStates {}

class InitialProductCardListState extends ProductCardListStates {}

class LoadingProductCardListState extends ProductCardListStates {}

class SuccessProductCardListState extends ProductCardListStates {}

class FailureProductCardListState extends ProductCardListStates {
  String error;
  FailureProductCardListState({required this.error});
}
class CompletedOperationState extends ProductCardListStates {
  String phrase;
  CompletedOperationState({required this.phrase});
}