part of 'main_bloc.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
}

class MainTabChanged extends MainEvent {
  final MainTab tab;

  const MainTabChanged({
    required this.tab,
  });

  @override
  List<Object> get props => [tab];
}
