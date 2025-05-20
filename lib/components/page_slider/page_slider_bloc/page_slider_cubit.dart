import 'package:flutter_bloc/flutter_bloc.dart';
import 'page_slider_states.dart';

class PageSliderCubit extends Cubit<PageSliderStates> {
  PageSliderCubit(Function() InitialPageSliderState)
      : super(InitialPageSliderState());

  void changeIndex(int value) {
    emit(InitialPageSliderState(index: value));
  }
}
