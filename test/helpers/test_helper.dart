import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_note/presentation/bloc/note/note_bloc.dart';

/// Helper function to wrap widgets with necessary providers for testing
Widget makeTestableWidget({required Widget child, required NoteBloc noteBloc}) {
  return BlocProvider<NoteBloc>(
    create: (_) => noteBloc,
    child: MaterialApp(home: child),
  );
}
