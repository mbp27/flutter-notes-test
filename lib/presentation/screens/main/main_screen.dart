import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutternotestest/data/models/note.dart';
import 'package:flutternotestest/data/models/push_notification.dart';
import 'package:flutternotestest/logic/blocs/main/main_bloc.dart';
import 'package:flutternotestest/logic/blocs/notification/notification_bloc.dart';
import 'package:flutternotestest/presentation/screens/account/account_screen.dart';
import 'package:flutternotestest/presentation/screens/home/home_screen.dart';
import 'package:flutternotestest/presentation/screens/note_detail/note_detail_screen.dart';

import 'components/custom_bottom_navigation_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  static const String routeName = '/main';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PageController _mainPageController;

  List<Widget> tabs = const [
    HomeScreen(),
    AccountScreen(),
  ];

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    _mainPageController = PageController(initialPage: MainTab.home.index);
  }

  @override
  void dispose() {
    _mainPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is NotificationIndexed) {
            SchedulerBinding.instance.addPostFrameCallback((_) async {
              if (ModalRoute.of(context)?.isFirst ?? false) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
              final typeId = state.notification.typeId;
              if (typeId == null) return;
              if (state.notification.type == PushNotificationType.note) {
                Navigator.of(context).pushNamed(
                  NoteDetailScreen.routeName,
                  arguments: NoteDetailScreenArguments(
                    note: Note(id: int.tryParse(typeId)),
                  ),
                );
              }
            });
          } else if (state is NotificationFailureState) {
            debugPrint('Notification failure : ${state.errorMessage}');
          }
        },
        child: BlocConsumer<MainBloc, MainState>(
          listenWhen: (previous, current) => previous.tab != current.tab,
          listener: (context, state) {
            _mainPageController.jumpToPage(state.tab.index);
          },
          builder: (context, state) {
            return PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _mainPageController,
              onPageChanged: (_) {},
              children: tabs,
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onItemTapped: (index) async {
          switch (index) {
            default:
              context
                  .read<MainBloc>()
                  .add(MainTabChanged(tab: MainTab.values[index]));
          }
        },
      ),
    );
  }
}
