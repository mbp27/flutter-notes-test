import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutternotestest/data/models/note.dart';
import 'package:flutternotestest/helpers/colors.dart';
import 'package:flutternotestest/logic/blocs/note_list/note_list_bloc.dart';
import 'package:flutternotestest/presentation/screens/add_note/add_note_screen.dart';
import 'package:flutternotestest/presentation/screens/note_detail/note_detail_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NoteListBloc>().add(NoteListLoad());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: MyColors.pallete,
        title: const Text('Notes'),
      ),
      body: BlocConsumer<NoteListBloc, NoteListState>(
        listener: (context, state) {
          if (state is NoteListLoadFailure) {
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
        builder: (context, state) {
          if (state is NoteListLoadSuccess) {
            if (state.notes.isNotEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 2));
                  if (!mounted) return;
                  context.read<NoteListBloc>().add(NoteListLoad());
                },
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16.0),
                  itemCount: state.notes.length,
                  itemBuilder: (context, index) {
                    final reminderTime = state.notes[index].reminderTime;
                    final reminderInterval =
                        state.notes[index].reminderInterval;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed(
                          NoteDetailScreen.routeName,
                          arguments: NoteDetailScreenArguments(
                            note: state.notes[index],
                          ),
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          tileColor: MyColors
                              .list[Random().nextInt(MyColors.list.length)],
                          style: ListTileStyle.list,
                          title: Text(
                            '${state.notes[index].title}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle:
                              reminderTime != null && reminderInterval != null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.calendar_month,
                                              color: Colors.black,
                                              size: 18.0,
                                            ),
                                            const SizedBox(width: 2.0),
                                            Text(
                                              DateFormat('dd/MM/yyyy HH:mm')
                                                  .format(reminderTime),
                                              style: const TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.timer,
                                              color: Colors.black,
                                              size: 18.0,
                                            ),
                                            const SizedBox(width: 2.0),
                                            Text(
                                              reminderInterval.title,
                                              style: const TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : null,
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return const Center(
                child: Text(
                  'Empty note',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
          } else if (state is NoteListLoadFailure) {
            return GestureDetector(
              onTap: () => context.read<NoteListBloc>().add(NoteListLoad()),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(
          AddNoteScreen.routeName,
          arguments: AddNoteScreenArguments(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
