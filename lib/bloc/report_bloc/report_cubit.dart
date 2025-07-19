import 'package:flutter_bloc/flutter_bloc.dart';
import 'report_states.dart';

class ReportCubit extends Cubit<ReportStates> {
  ReportCubit(Function() InitialReportState, )
      : super(InitialReportState());

  bool s = false;

  flip() async{

    s = !s;
    emit(ChangedReportState());
  }

  String button(bool o) {
    if (o) {
      if (s) {
        return "تقرير يومي";
      } else {
        return "تقرير تجميعي";
      }
    } else {
      return "";
    }
  }
  void notifyListeners(){
    emit(ChangedReportState());
  }
}
