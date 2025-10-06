import 'package:bloc/bloc.dart';

import 'display_state.dart';

class DisplayCubit extends Cubit<DisplayState> {
  DisplayCubit() : super(DisplayState(DisplayItem.list));

  void toggleDisplay() {
    if (state.displayItem == DisplayItem.list) {
      emit(DisplayState(DisplayItem.grid));
    } else {
      emit(DisplayState(DisplayItem.list));
    }
  }
}
