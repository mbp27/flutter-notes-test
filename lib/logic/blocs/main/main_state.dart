part of 'main_bloc.dart';

enum MainTab { home, profile }

class MainState extends Equatable {
  final MainTab tab;

  const MainState({this.tab = MainTab.home});

  @override
  List<Object> get props => [tab];
}
