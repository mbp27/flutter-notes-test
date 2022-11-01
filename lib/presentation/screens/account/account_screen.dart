import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutternotestest/helpers/assets.gen.dart';
import 'package:flutternotestest/helpers/colors.dart';
import 'package:flutternotestest/logic/blocs/auth/auth_bloc.dart';
import 'package:flutternotestest/logic/blocs/logout/logout_bloc.dart';
import 'package:flutternotestest/presentation/screens/update_profile/update_profile_screen.dart';
import 'package:intl/intl.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc authBloc) => authBloc.state.user);

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 30.0,
              horizontal: 30.0,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: MyColors.pallete,
              boxShadow: [
                BoxShadow(
                  blurRadius: 10.0,
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 5.0,
                  offset: const Offset(0, 0),
                ),
              ],
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(80.0),
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UserPhoto(path: user.profilePicture),
                  const SizedBox(height: 10.0),
                  Text(
                    user.fullname,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: MyColors.pallete,
                    foregroundColor: Colors.white,
                    child: Icon(Icons.email_outlined),
                  ),
                  title: const Text('Email'),
                  subtitle: Text('${user.email}'),
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: MyColors.pallete,
                    foregroundColor: Colors.white,
                    child: Icon(Icons.male_outlined),
                  ),
                  title: const Text('Gender'),
                  subtitle: Text('${user.gender?.name.toUpperCase()}'),
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: MyColors.pallete,
                    foregroundColor: Colors.white,
                    child: Icon(Icons.email_outlined),
                  ),
                  title: const Text('Date of Birth'),
                  subtitle: Text(
                    DateFormat.yMMMMd().format(
                      user.dateOfBirth ?? DateTime(1999, 1, 1),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pushNamed(
                          UpdateProfileScreen.routeName,
                          arguments: UpdateProfileScreenArguments(user: user),
                        ),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          side: const BorderSide(color: MyColors.pallete),
                        ),
                        child: const Text('UPDATE'),
                      ),
                      OutlinedButton(
                        onPressed: () async {
                          final confirm = await showDialog<bool?>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Logout'),
                              content: const Text(
                                'It will remove all notes! Are you sure?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Logout'),
                                ),
                              ],
                            ),
                          );
                          if (confirm != null && confirm == true) {
                            if (!mounted) return;
                            context.read<LogoutBloc>().add(LogoutStarted());
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          side: const BorderSide(color: Colors.red),
                        ),
                        child: const Text('LOGOUT'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserPhoto extends StatelessWidget {
  const UserPhoto({
    Key? key,
    this.path,
  }) : super(key: key);

  final String? path;

  @override
  Widget build(BuildContext context) {
    final image = path;

    return Container(
      height: 100.0,
      width: 100.0,
      decoration: BoxDecoration(
        border: Border.all(
          width: 3.0,
          color: Colors.white,
        ),
        shape: BoxShape.circle,
        image: DecorationImage(
          image: image != null && image.isNotEmpty
              ? FileImage(File(image))
              : Assets.images.user.provider(),
        ),
      ),
    );
  }
}
