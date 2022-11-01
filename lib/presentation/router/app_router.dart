import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutternotestest/data/repositories/auth_repository.dart';
import 'package:flutternotestest/data/repositories/note_repository.dart';
import 'package:flutternotestest/logic/blocs/add_note/add_note_bloc.dart';
import 'package:flutternotestest/logic/blocs/login/login_bloc.dart';
import 'package:flutternotestest/logic/blocs/main/main_bloc.dart';
import 'package:flutternotestest/logic/blocs/note_delete/note_delete_bloc.dart';
import 'package:flutternotestest/logic/blocs/note_detail/note_detail_bloc.dart';
import 'package:flutternotestest/logic/blocs/update_profile/update_profile_bloc.dart';
import 'package:flutternotestest/presentation/screens/add_note/add_note_screen.dart';
import 'package:flutternotestest/presentation/screens/loading/loading_screen.dart';
import 'package:flutternotestest/presentation/screens/login/login_screen.dart';
import 'package:flutternotestest/presentation/screens/main/main_screen.dart';
import 'package:flutternotestest/presentation/screens/not_found/not_found_screen.dart';
import 'package:flutternotestest/presentation/screens/note_detail/note_detail_screen.dart';
import 'package:flutternotestest/presentation/screens/update_profile/update_profile_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case LoadingScreen.routeName:
        return PageRouteBuilder(
          opaque: false,
          fullscreenDialog: true,
          pageBuilder: (context, _, __) => const LoadingScreen(),
        );
      case LoginScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(
              authRepository: context.read<AuthRepository>(),
            ),
            child: const LoginScreen(),
          ),
        );
      case MainScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => BlocProvider<MainBloc>.value(
            value: context.read<MainBloc>()
              ..add(const MainTabChanged(tab: MainTab.home)),
            child: const MainScreen(),
          ),
        );
      case UpdateProfileScreen.routeName:
        final arguments = routeSettings.arguments;
        if (arguments is! UpdateProfileScreenArguments) {
          throw 'Please using arguments';
        }
        return MaterialPageRoute(
          builder: (context) => BlocProvider<UpdateProfileBloc>(
            create: (context) => UpdateProfileBloc(
              authRepository: context.read<AuthRepository>(),
            )..add(UpdateProfileInitial(user: arguments.user)),
            child: UpdateProfileScreen(user: arguments.user),
          ),
        );
      case AddNoteScreen.routeName:
        final arguments = routeSettings.arguments;
        if (arguments is! AddNoteScreenArguments) {
          throw 'Please using arguments';
        }
        return MaterialPageRoute(
          builder: (context) => BlocProvider<AddNoteBloc>(
            create: (context) => AddNoteBloc(
              noteRepository: context.read<NoteRepository>(),
            )..add(AddNoteInitial(note: arguments.note)),
            child: AddNoteScreen(note: arguments.note),
          ),
        );
      case NoteDetailScreen.routeName:
        final arguments = routeSettings.arguments;
        if (arguments is! NoteDetailScreenArguments) {
          throw 'Please using arguments';
        }
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider<NoteDetailBloc>(
                create: (context) => NoteDetailBloc(
                  noteRepository: context.read<NoteRepository>(),
                )..add(NoteDetailLoad(note: arguments.note)),
              ),
              BlocProvider<NoteDeleteBloc>(
                create: (context) => NoteDeleteBloc(
                  noteRepository: context.read<NoteRepository>(),
                ),
              ),
            ],
            child: NoteDetailScreen(note: arguments.note),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const NotFoundScreen(),
        );
    }
  }
}
