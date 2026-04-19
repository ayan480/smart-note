import 'package:equatable/equatable.dart';
import '../../../domain/entities/note.dart';

abstract class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object?> get props => [];
}

class NoteInitial extends NoteState {}

class NoteLoading extends NoteState {}

class NotesLoaded extends NoteState {
  final List<Note> notes;

  const NotesLoaded(this.notes);

  @override
  List<Object> get props => [notes];
}

class NoteOperationSuccess extends NoteState {
  final String message;
  final Note? note;

  const NoteOperationSuccess(this.message, {this.note});

  @override
  List<Object?> get props => [message, note];
}

class NoteError extends NoteState {
  final String message;

  const NoteError(this.message);

  @override
  List<Object> get props => [message];
}
