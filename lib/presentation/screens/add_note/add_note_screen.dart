import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutternotestest/data/models/note.dart';
import 'package:flutternotestest/helpers/assets.gen.dart';
import 'package:flutternotestest/helpers/colors.dart';
import 'package:flutternotestest/logic/blocs/add_note/add_note_bloc.dart';
import 'package:flutternotestest/logic/blocs/note_list/note_list_bloc.dart';
import 'package:flutternotestest/presentation/screens/loading/loading_screen.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

class AddNoteScreenArguments {
  final Note? note;

  AddNoteScreenArguments({
    this.note,
  });
}

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({
    Key? key,
    this.note,
  }) : super(key: key);

  final Note? note;

  static const String routeName = '/add_note';

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  @override
  Widget build(BuildContext context) {
    final title = widget.note != null ? 'Update' : 'Add';

    return Scaffold(
      appBar: AppBar(title: Text('$title Note')),
      body: BlocConsumer<AddNoteBloc, AddNoteState>(
        listenWhen: (previous, current) =>
            previous.status != current.status ||
            previous.loadState != current.loadState,
        listener: (context, state) {
          if (state.status == FormzStatus.submissionInProgress) {
            Navigator.of(context).pushNamed(LoadingScreen.routeName);
          }
          if (state.status == FormzStatus.submissionSuccess) {
            context.read<NoteListBloc>().add(NoteListLoad());
            Navigator.of(context)
              ..pop()
              ..pop();
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  content: Text('Success $title Note!'),
                  duration: const Duration(seconds: 3),
                ),
              );
          }
          if (state.status == FormzStatus.submissionFailure ||
              state.loadState == AddNoteLoadState.failure) {
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
          if (state.loadState == AddNoteLoadState.success) {
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      const SizedBox(height: 16.0),
                      BlocBuilder<AddNoteBloc, AddNoteState>(
                        buildWhen: (previous, current) =>
                            previous.titleField != current.titleField,
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: TextFormField(
                              initialValue: state.titleField.value,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(11.0),
                                labelText: 'Title',
                              ),
                              onChanged: (value) => context
                                  .read<AddNoteBloc>()
                                  .add(AddNoteTitleChanged(value)),
                              validator: (value) => state.titleField.error,
                            ),
                          );
                        },
                      ),
                      BlocBuilder<AddNoteBloc, AddNoteState>(
                        buildWhen: (previous, current) =>
                            previous.descriptionField !=
                            current.descriptionField,
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: TextFormField(
                              initialValue: state.descriptionField.value,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: TextInputAction.newline,
                              maxLines: 10,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(11.0),
                                labelText: 'Description',
                                alignLabelWithHint: true,
                              ),
                              onChanged: (value) => context
                                  .read<AddNoteBloc>()
                                  .add(AddNoteDescriptionChanged(value)),
                              validator: (value) =>
                                  state.descriptionField.error,
                            ),
                          );
                        },
                      ),
                      BlocBuilder<AddNoteBloc, AddNoteState>(
                        buildWhen: (previous, current) =>
                            previous.file != current.file,
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: TextFormField(
                              readOnly: true,
                              controller: TextEditingController()
                                ..text = p.basename(state.file ?? ''),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(11.0),
                                labelText: 'File',
                                prefixIcon: Icon(Icons.attachment),
                              ),
                              onTap: () async {
                                final result =
                                    await FilePicker.platform.pickFiles();
                                if (result != null) {
                                  final files = result.files;
                                  if (files.isNotEmpty) {
                                    final filePath = files.single.path;
                                    if (filePath != null) {
                                      if (!mounted) return;
                                      context
                                          .read<AddNoteBloc>()
                                          .add(AddNoteFileChanged(filePath));
                                    }
                                  }
                                }
                              },
                            ),
                          );
                        },
                      ),
                      BlocBuilder<AddNoteBloc, AddNoteState>(
                        buildWhen: (previous, current) =>
                            previous.reminder != current.reminder,
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Atur Pengingat',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                CupertinoSwitch(
                                  value: state.reminder,
                                  onChanged: (value) => context
                                      .read<AddNoteBloc>()
                                      .add(AddNoteReminderChanged(value)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      BlocBuilder<AddNoteBloc, AddNoteState>(
                        buildWhen: (previous, current) =>
                            previous.reminder != current.reminder ||
                            previous.reminderTimeField !=
                                current.reminderTimeField,
                        builder: (context, state) {
                          return Visibility(
                            visible: state.reminder,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              child: TextFormField(
                                readOnly: true,
                                controller: TextEditingController()
                                  ..text = state.reminderTimeField.value != null
                                      ? DateFormat('dd/MM/yyyy HH:mm').format(
                                          state.reminderTimeField.value!)
                                      : '',
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                textInputAction: TextInputAction.done,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.all(11.0),
                                  labelText: 'Reminder Time',
                                ),
                                onTap: () async {
                                  final selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        state.reminderTimeField.value ??
                                            DateTime.now()
                                                .add(const Duration(days: 1)),
                                    firstDate: DateTime.now(),
                                    lastDate:
                                        DateTime(DateTime.now().year + 100),
                                  );
                                  if (selectedDate != null) {
                                    final selectedTime = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay(
                                          hour: selectedDate.hour,
                                          minute: selectedDate.minute),
                                    );
                                    if (selectedTime != null) {
                                      if (!mounted) return;
                                      context
                                          .read<AddNoteBloc>()
                                          .add(AddNoteReminderTimeChanged(
                                            DateTime(
                                              selectedDate.year,
                                              selectedDate.month,
                                              selectedDate.day,
                                              selectedTime.hour,
                                              selectedTime.minute,
                                            ),
                                          ));
                                    }
                                  }
                                },
                                validator: (value) =>
                                    state.reminderTimeField.error,
                              ),
                            ),
                          );
                        },
                      ),
                      BlocBuilder<AddNoteBloc, AddNoteState>(
                        buildWhen: (previous, current) =>
                            previous.reminder != current.reminder ||
                            previous.reminderIntervalField !=
                                current.reminderIntervalField,
                        builder: (context, state) {
                          return Visibility(
                            visible: state.reminder,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              child: DropdownButtonFormField<ReminderInterval>(
                                value: state.reminderIntervalField.value,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.all(11.0),
                                  labelText: 'Reminder Interval',
                                ),
                                items: ReminderInterval.values
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e.title),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) => context
                                    .read<AddNoteBloc>()
                                    .add(AddNoteReminderIntervalChanged(value)),
                                validator: (value) =>
                                    state.reminderIntervalField.error,
                              ),
                            ),
                          );
                        },
                      ),
                      BlocBuilder<AddNoteBloc, AddNoteState>(
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
                                            context.read<AddNoteBloc>().add(
                                                AddNoteFormSubmitted(
                                                    note: widget.note));
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
          } else if (state.loadState == AddNoteLoadState.failure) {
            return GestureDetector(
              onTap: () => context
                  .read<AddNoteBloc>()
                  .add(AddNoteInitial(note: widget.note)),
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
