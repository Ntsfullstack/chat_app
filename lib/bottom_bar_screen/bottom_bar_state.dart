part of 'bottom_bar_cubit.dart';

class BottomBarState extends Equatable {
  final int selectedIndex;
  final int displayNumber;

  const BottomBarState({
    this.selectedIndex = 0,
    this.displayNumber = 0,
  });

  @override
  List<Object?> get props => [
    selectedIndex,
    displayNumber,
  ];

  BottomBarState copyWith({
    int? selectedIndex,
    int? displayNumber,
  }) {
    return BottomBarState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      displayNumber: displayNumber ?? this.displayNumber,
    );
  }
}