import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bottom_bar_state.dart';

class BottomBarCubit extends Cubit<BottomBarState> {
  BottomBarCubit() : super(const BottomBarState());

  void onItemTapped(int index) {
    emit(state.copyWith(
      selectedIndex: index,
    ));
  }

  void increase(){
    emit(state.copyWith(
      displayNumber: state.displayNumber + 1,
    ));
  }
}