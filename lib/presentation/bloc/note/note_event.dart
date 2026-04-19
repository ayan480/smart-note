import 'package:equatable/equatable.dart';
import '../../../domain/entities/note.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotes extends NoteEvent {}

class LoadPinnedNotes extends NoteEvent {}

class LoadArchivedNotes extends NoteEvent {}

class CreateNoteEvent extends NoteEvent {
  final Note note;

  const CreateNoteEvent(this.note);

  @override
  List<Object> get props => [note];
}

class UpdateNoteEvent extends NoteEvent {
  final Note note;

  const UpdateNoteEvent(this.note);

  @override
  List<Object> get props => [note];
}

class DeleteNoteEvent extends NoteEvent {
  final String noteId;

  const DeleteNoteEvent(this.noteId);

  @override
  List<Object> get props => [noteId];
}

class SearchNotesEvent extends NoteEvent {
  final String query;

  const SearchNotesEvent(this.query);

  @override
  List<Object> get props => [query];
}

class TogglePinNoteEvent extends NoteEvent {
  final String noteId;

  const TogglePinNoteEvent(this.noteId);

  @override
  List<Object> get props => [noteId];
}

class ToggleArchiveNoteEvent extends NoteEvent {
  final String noteId;

  const ToggleArchiveNoteEvent(this.noteId);

  @override
  List<Object> get props => [noteId];
}
