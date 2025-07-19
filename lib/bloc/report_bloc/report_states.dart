abstract class ReportStates {}

class InitialReportState extends ReportStates {}

class ChangedReportState extends ReportStates {}

class SuccessReportState extends ReportStates {}

class FailureReportState extends ReportStates {
  String error;
  FailureReportState({required this.error});
}
class CompletedOperationState extends ReportStates {
  String phrase;
  CompletedOperationState({required this.phrase});
}
