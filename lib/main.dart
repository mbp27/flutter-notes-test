import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutternotestest/data/repositories/auth_repository.dart';
import 'package:flutternotestest/data/repositories/note_repository.dart';
import 'package:flutternotestest/helpers/colors.dart';
import 'package:flutternotestest/logic/blocs/auth/auth_bloc.dart';
import 'package:flutternotestest/logic/blocs/logout/logout_bloc.dart';
import 'package:flutternotestest/logic/blocs/main/main_bloc.dart';
import 'package:flutternotestest/logic/blocs/note_list/note_list_bloc.dart';
import 'package:flutternotestest/logic/blocs/notification/notification_bloc.dart';
import 'package:flutternotestest/presentation/router/app_router.dart';
import 'package:flutternotestest/presentation/screens/loading/loading_screen.dart';
import 'package:flutternotestest/presentation/screens/login/login_screen.dart';
import 'package:flutternotestest/presentation/screens/main/main_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

NotificationBloc _notificationBloc = NotificationBloc();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  await _notificationBloc.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()?.restartApp();
  }

  static NavigatorState? navigator(BuildContext context) {
    return context.findAncestorStateOfType<_MyAppState>()?.navigator;
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UniqueKey _key = UniqueKey();
  final navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get navigator => navigatorKey.currentState!;

  void restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthRepository>(
            create: (context) => AuthRepository(),
          ),
          RepositoryProvider<NoteRepository>(
            create: (context) => NoteRepository(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<NotificationBloc>.value(value: _notificationBloc),
            BlocProvider<AuthBloc>(
              lazy: false,
              create: (context) => AuthBloc(
                authRepository: context.read<AuthRepository>(),
              ),
            ),
            BlocProvider<LogoutBloc>(
              create: (context) => LogoutBloc(
                authRepository: context.read<AuthRepository>(),
              ),
            ),
            BlocProvider<MainBloc>(create: (context) => MainBloc()),
            BlocProvider<NoteListBloc>(
              create: (context) => NoteListBloc(
                noteRepository: context.read<NoteRepository>(),
              )..add(NoteListLoad()),
            ),
          ],
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: MaterialApp(
              navigatorKey: navigatorKey,
              title: 'Flutter Notes Test',
              theme: ThemeData(primarySwatch: MyColors.pallete),
              home: Container(color: MyColors.pallete),
              onGenerateRoute: AppRouter().onGenerateRoute,
              builder: (context, child) => MultiBlocListener(
                listeners: [
                  BlocListener<AuthBloc, AuthState>(
                    listenWhen: (previous, current) =>
                        previous.status != current.status ||
                        previous.refreshTime != current.refreshTime,
                    listener: (context, state) async {
                      if (state.status == AuthStatus.authenticated) {
                        Navigator.of(navigator.context).pushNamedAndRemoveUntil(
                          MainScreen.routeName,
                          (route) => false,
                        );
                      } else {
                        Navigator.of(navigator.context).pushNamedAndRemoveUntil(
                          LoginScreen.routeName,
                          (route) => false,
                        );
                      }
                    },
                  ),
                  BlocListener<LogoutBloc, LogoutState>(
                    listener: (context, state) {
                      if (state is LogoutStartedInProgress) {
                        Navigator.of(navigator.context)
                            .pushNamed(LoadingScreen.routeName);
                      }
                      if (state is LogoutStartedSuccess) {
                        Navigator.of(navigator.context).pop();
                      }
                      if (state is LogoutStartedFailure) {
                        Navigator.of(navigator.context).pop();
                        ScaffoldMessenger.of(navigator.context)
                          ..clearSnackBars()
                          ..showSnackBar(
                            SnackBar(
                              content: Text('${state.error}'),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                      }
                    },
                  ),
                ],
                child: child!,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
