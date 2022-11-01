import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutternotestest/data/models/note.dart';
import 'package:flutternotestest/helpers/colors.dart';
import 'package:flutternotestest/logic/blocs/note_delete/note_delete_bloc.dart';
import 'package:flutternotestest/logic/blocs/note_detail/note_detail_bloc.dart';
import 'package:flutternotestest/logic/blocs/note_list/note_list_bloc.dart';
import 'package:flutternotestest/presentation/screens/add_note/add_note_screen.dart';
import 'package:flutternotestest/presentation/screens/loading/loading_screen.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;

class NoteDetailScreenArguments {
  final Note note;

  NoteDetailScreenArguments({
    required this.note,
  });
}

class NoteDetailScreen extends StatefulWidget {
  const NoteDetailScreen({
    Key? key,
    required this.note,
  }) : super(key: key);

  final Note note;

  static const String routeName = '/note_detail';

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: MyColors.pallete,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.1),
            foregroundColor: MyColors.pallete,
            child: const BackButton(),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () async {
                final confirm = await showDialog<bool?>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete'),
                    content: const Text('Are you sure?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (confirm != null && confirm == true) {
                  if (!mounted) return;
                  context
                      .read<NoteDeleteBloc>()
                      .add(NoteDeleteStarted(note: widget.note));
                }
              },
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.1),
                foregroundColor: MyColors.pallete,
                child: const Icon(Icons.delete),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => Navigator.of(context)
                  .pushNamed(
                    AddNoteScreen.routeName,
                    arguments: AddNoteScreenArguments(note: widget.note),
                  )
                  .then((value) => context
                      .read<NoteDetailBloc>()
                      .add(NoteDetailLoad(note: widget.note))),
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.1),
                foregroundColor: MyColors.pallete,
                child: const Icon(Icons.edit),
              ),
            ),
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<NoteDetailBloc, NoteDetailState>(
            listener: (context, state) {
              if (state is NoteDetailLoadFailure) {
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      duration: const Duration(seconds: 3),
                    ),
                  );
              }
            },
          ),
          BlocListener<NoteDeleteBloc, NoteDeleteState>(
            listener: (context, state) {
              if (state is NoteDeleteStartedInProgress) {
                Navigator.of(context).pushNamed(LoadingScreen.routeName);
              }
              if (state is NoteDeleteStartedSuccess) {
                context.read<NoteListBloc>().add(NoteListLoad());
                Navigator.of(context)
                  ..pop()
                  ..pop();
              }
              if (state is NoteDeleteStartedFailure) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      duration: const Duration(seconds: 3),
                    ),
                  );
              }
            },
          ),
        ],
        child: BlocBuilder<NoteDetailBloc, NoteDetailState>(
          builder: (context, state) {
            if (state is NoteDetailLoadSuccess) {
              final file = state.note.file;
              final reminderTime = state.note.reminderTime;
              final reminderInterval = state.note.reminderInterval;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (reminderTime != null && reminderInterval != null)
                        Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (file != null && file.isNotEmpty)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          final result =
                                              await OpenFilex.open(file);
                                          if (result.type == ResultType.error) {
                                            if (!mounted) return;
                                            ScaffoldMessenger.of(context)
                                              ..clearSnackBars()
                                              ..showSnackBar(
                                                SnackBar(
                                                  content: Text(result.message),
                                                  duration: const Duration(
                                                    seconds: 3,
                                                  ),
                                                ),
                                              );
                                          }
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.attachment,
                                                size: 18.0),
                                            const SizedBox(width: 4.0),
                                            Text(
                                              p.basename(file),
                                              style: const TextStyle(
                                                color: MyColors.pallete,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4.0),
                                    ],
                                  ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.calendar_month,
                                        size: 18.0),
                                    const SizedBox(width: 4.0),
                                    Text(DateFormat('dd/MM/yyyy HH:mm')
                                        .format(reminderTime)),
                                  ],
                                ),
                                const SizedBox(height: 4.0),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.timer, size: 18.0),
                                    const SizedBox(width: 4.0),
                                    Text(reminderInterval.title),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                          ],
                        ),
                      SelectableText(
                        '${state.note.title}',
                        style: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      SelectableText(
                        '${state.note.description}',
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is NoteDetailLoadFailure) {
              return GestureDetector(
                onTap: () => context
                    .read<NoteDetailBloc>()
                    .add(NoteDetailLoad(note: widget.note)),
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
      ),
    );
  }
}
