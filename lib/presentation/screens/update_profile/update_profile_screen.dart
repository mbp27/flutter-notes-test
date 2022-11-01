import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutternotestest/data/models/user.dart';
import 'package:flutternotestest/helpers/assets.gen.dart';
import 'package:flutternotestest/helpers/colors.dart';
import 'package:flutternotestest/helpers/utils.dart';
import 'package:flutternotestest/logic/blocs/auth/auth_bloc.dart';
import 'package:flutternotestest/logic/blocs/update_profile/update_profile_bloc.dart';
import 'package:flutternotestest/presentation/screens/loading/loading_screen.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UpdateProfileScreenArguments {
  final User user;

  UpdateProfileScreenArguments({
    required this.user,
  });
}

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  static const String routeName = '/update_profile';

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc authBloc) => authBloc.state.user);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Update Profile'),
      ),
      body: BlocConsumer<UpdateProfileBloc, UpdateProfileState>(
        listenWhen: (previous, current) =>
            previous.status != current.status ||
            previous.loadState != current.loadState,
        listener: (context, state) {
          if (state.status == FormzStatus.submissionInProgress) {
            Navigator.of(context).pushNamed(LoadingScreen.routeName);
          }
          if (state.status == FormzStatus.submissionSuccess) {
            context.read<AuthBloc>().add(AuthUserChanges(user: state.user));
            Navigator.of(context)
              ..pop()
              ..pop();
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Success update profile!'),
                  duration: Duration(seconds: 2),
                ),
              );
          }
          if (state.status == FormzStatus.submissionFailure ||
              state.loadState == UpdateProfileLoadState.failure) {
            if (state.status == FormzStatus.submissionFailure) {
              FocusManager.instance.primaryFocus?.unfocus();
              Navigator.of(context).pop();
            }
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
        buildWhen: (previous, current) =>
            previous.loadState != current.loadState,
        builder: (context, state) {
          if (state.loadState == UpdateProfileLoadState.success) {
            return Column(
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
                        color: Colors.black.withOpacity(0.4),
                        spreadRadius: 5.0,
                        offset: const Offset(0, 0),
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(80.0),
                    ),
                  ),
                  child: SafeArea(
                    child: BlocBuilder<UpdateProfileBloc, UpdateProfileState>(
                      buildWhen: (previous, current) =>
                          previous.photo != current.photo,
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: () async {
                            final source =
                                await showModalBottomSheet<ImageSource?>(
                              context: context,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              builder: (ctx) => SafeArea(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          const Expanded(
                                            child: Text(
                                              'Profile picture',
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              context.read<UpdateProfileBloc>().add(
                                                  const UpdateProfilePhotoChanged(
                                                      ''));
                                            },
                                            child: const Icon(
                                              Icons.delete,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16.0),
                                      Wrap(
                                        spacing: 16.0,
                                        runSpacing: 16.0,
                                        children: [
                                          GestureDetector(
                                            onTap: () => Navigator.of(context)
                                                .pop(ImageSource.camera),
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.black12,
                                                    ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.camera_alt,
                                                    color: MyColors.pallete,
                                                  ),
                                                ),
                                                const SizedBox(height: 8.0),
                                                const Text('Camera'),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => Navigator.of(context)
                                                .pop(ImageSource.gallery),
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.black12,
                                                    ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.photo,
                                                    color: MyColors.pallete,
                                                  ),
                                                ),
                                                const SizedBox(height: 8.0),
                                                const Text('Gallery'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                            if (source != null) {
                              final file = await MyUtils.pickImage(source);
                              if (file != null) {
                                final croppedFile = await MyUtils.cropImage(
                                  filePath: file.path,
                                  toolbarTitle: 'Crop Image',
                                );
                                if (croppedFile != null) {
                                  if (!mounted) return;
                                  context.read<UpdateProfileBloc>().add(
                                      UpdateProfilePhotoChanged(
                                          croppedFile.path));
                                }
                              }
                            }
                          },
                          child: Stack(
                            children: [
                              UserPhoto(path: state.photo),
                              const Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 16.0,
                                  backgroundColor: Colors.black,
                                  child: FittedBox(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.camera_alt),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      const SizedBox(height: 16.0),
                      BlocBuilder<UpdateProfileBloc, UpdateProfileState>(
                        buildWhen: (previous, current) =>
                            previous.firstNameField != current.firstNameField,
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: TextFormField(
                              initialValue: state.firstNameField.value,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r"[a-zA-Z.,]+|\s")),
                              ],
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(11.0),
                                labelText: 'First Name',
                              ),
                              onChanged: (value) => context
                                  .read<UpdateProfileBloc>()
                                  .add(UpdateProfileFirstNameChanged(value)),
                              validator: (value) => state.firstNameField.error,
                            ),
                          );
                        },
                      ),
                      BlocBuilder<UpdateProfileBloc, UpdateProfileState>(
                        buildWhen: (previous, current) =>
                            previous.lastNameField != current.lastNameField,
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: TextFormField(
                              initialValue: state.lastNameField.value,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r"[a-zA-Z.,]+|\s")),
                              ],
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(11.0),
                                labelText: 'Last Name',
                              ),
                              onChanged: (value) => context
                                  .read<UpdateProfileBloc>()
                                  .add(UpdateProfileLastNameChanged(value)),
                              validator: (value) => state.lastNameField.error,
                            ),
                          );
                        },
                      ),
                      BlocBuilder<UpdateProfileBloc, UpdateProfileState>(
                        buildWhen: (previous, current) =>
                            previous.genderField != current.genderField,
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: DropdownButtonFormField<Gender>(
                              value: state.genderField.value,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(11.0),
                                labelText: 'Gender',
                              ),
                              items: Gender.values
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.name.toUpperCase()),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) => context
                                  .read<UpdateProfileBloc>()
                                  .add(UpdateProfileGenderChanged(value)),
                              validator: (value) => state.genderField.error,
                            ),
                          );
                        },
                      ),
                      BlocBuilder<UpdateProfileBloc, UpdateProfileState>(
                        buildWhen: (previous, current) =>
                            previous.dateOfBirthField !=
                            current.dateOfBirthField,
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: TextFormField(
                              readOnly: true,
                              controller: TextEditingController()
                                ..text = state.dateOfBirthField.value != null
                                    ? DateFormat.yMMMMd()
                                        .format(state.dateOfBirthField.value!)
                                    : '',
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(11.0),
                                labelText: 'Date Of Birth',
                              ),
                              onTap: () async {
                                final selectedDateTime = await showDatePicker(
                                  context: context,
                                  initialDate: state.dateOfBirthField.value ??
                                      DateTime.now(),
                                  firstDate: DateTime(1900, 1, 1),
                                  lastDate: DateTime.now(),
                                );
                                if (selectedDateTime != null) {
                                  if (!mounted) return;
                                  context.read<UpdateProfileBloc>().add(
                                      UpdateProfileDateOfBirthChanged(
                                          selectedDateTime));
                                }
                              },
                              validator: (value) =>
                                  state.dateOfBirthField.error,
                            ),
                          );
                        },
                      ),
                      BlocBuilder<UpdateProfileBloc, UpdateProfileState>(
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                OutlinedButton(
                                  onPressed: state.saveButtonActive
                                      ? () async {
                                          final confirm =
                                              await showDialog<bool?>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Save'),
                                              content:
                                                  const Text('Are you sure?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                  child: const Text('Save'),
                                                ),
                                              ],
                                            ),
                                          );
                                          if (confirm != null &&
                                              confirm == true) {
                                            if (!mounted) return;
                                            context
                                                .read<UpdateProfileBloc>()
                                                .add(UpdateProfileFormSubmitted(
                                                    user: user));
                                          }
                                        }
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
                                  child: const Text('SAVE'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state.loadState == UpdateProfileLoadState.failure) {
            return GestureDetector(
              onTap: () => context
                  .read<UpdateProfileBloc>()
                  .add(UpdateProfileInitial(user: user)),
              child: const Center(
                child: Icon(
                  Icons.refresh,
                  size: 40.0,
                ),
              ),
            );
          } else {
            return Center(
              child: Platform.isIOS
                  ? const CupertinoActivityIndicator()
                  : const CircularProgressIndicator(),
            );
          }
        },
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
