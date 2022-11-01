import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutternotestest/logic/blocs/main/main_bloc.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    Key? key,
    required this.onItemTapped,
  }) : super(key: key);

  final void Function(int) onItemTapped;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return BottomNavigationBar(
          iconSize: 28.0,
          unselectedFontSize: 10.0,
          selectedFontSize: 10.0,
          type: BottomNavigationBarType.fixed,
          currentIndex: state.tab.index,
          onTap: (value) => onItemTapped(value),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Account',
            ),
          ],
        );
      },
    );
  }
}
