abstract class SectionListStates {}

class InitialSectionListState extends SectionListStates {}

class LoadingSectionListState extends SectionListStates {}

class SuccessSectionListState extends SectionListStates {}

class FailureSectionListState extends SectionListStates {
  String error;
  FailureSectionListState({required this.error});
}
class CompletedOperationState extends SectionListStates {
  String phrase;
  CompletedOperationState({required this.phrase});
}