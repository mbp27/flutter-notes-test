import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutternotestest/helpers/colors.dart';
import 'package:flutternotestest/logic/blocs/login/login_bloc.dart';
import 'package:flutternotestest/presentation/screens/loading/loading_screen.dart';
import 'package:formz/formz.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocListener<LoginBloc, LoginState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == FormzStatus.submissionInProgress) {
            Navigator.of(context).pushNamed(LoadingScreen.routeName);
          }
          if (state.status == FormzStatus.submissionSuccess) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Success login!'),
                  duration: Duration(seconds: 2),
                ),
              );
          }
          if (state.status == FormzStatus.submissionFailure) {
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  content: Text('${state.error}'),
                  duration: const Duration(seconds: 3),
                ),
              );
          }
        },
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BlocBuilder<LoginBloc, LoginState>(
                        buildWhen: (previous, current) =>
                            previous.emailField != current.emailField,
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r"[a-zA-Z0-9@.]")),
                              ],
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(11.0),
                                labelText: 'Email',
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  color: MyColors.pallete,
                                ),
                              ),
                              onChanged: (value) => context
                                  .read<LoginBloc>()
                                  .add(LoginEmailChanged(value)),
                              validator: (value) => state.emailField.error,
                            ),
                          );
                        },
                      ),
                      BlocBuilder<LoginBloc, LoginState>(
                        buildWhen: (previous, current) =>
                            previous.passwordField != current.passwordField,
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(11.0),
                                labelText: 'Password',
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: MyColors.pallete,
                                ),
                              ),
                              onChanged: (value) {
                                context
                                    .read<LoginBloc>()
                                    .add(LoginPasswordChanged(value));
                              },
                              validator: (value) => state.passwordField.error,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 36.0),
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return OutlinedButton(
                            onPressed: state.saveButtonActive
                                ? () => context
                                    .read<LoginBloc>()
                                    .add(LoginFormSubmitted())
                                : null,
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              side: BorderSide(
                                color: state.saveButtonActive
                                    ? MyColors.pallete
                                    : Colors.grey,
                              ),
                            ),
                            child: const Text('LOGIN'),
                          );
                        },
                      ),
                      const SizedBox(height: 36.0),
                      const Text(
                        'App Ver 1.0.0 - MBP',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                padding: const EdgeInsets.only(bottom: 50),
                color: MyColors.pallete,
                height: MediaQuery.of(context).size.height * 0.2,
                alignment: Alignment.center,
              ),
            ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: RotatedBox(
                quarterTurns: 2,
                child: ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 50),
                    color: MyColors.pallete,
                    height: MediaQuery.of(context).size.height * 0.2,
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
      size.width * 0.02,
      size.height,
      size.width * 0.06,
      size.height * 0.8,
    );
    path.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.25,
      size.width * 0.5,
      size.height * 0.4,
    );
    path.quadraticBezierTo(
      size.width * 0.96,
      size.height * 0.5,
      size.width,
      0,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
