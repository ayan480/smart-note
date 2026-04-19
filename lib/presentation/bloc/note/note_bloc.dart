import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/usecases/note/create_note.dart';
import '../../../domain/usecases/note/delete_note.dart';
import '../../../domain/usecases/note/get_all_notes.dart';
import '../../../domain/usecases/note/update_note.dart';
import '../../../domain/repositories/note_repository.dart';
import 'note_event.dart';
import 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final GetAllNotes getAllNotes;
  final CreateNote createNote;
  final UpdateNote updateNote;
  final DeleteNote deleteNote;
  final NoteRepository noteRepository;

  NoteBloc({
    required this.getAllNotes,
    required this.createNote,
    required this.updateNote,
    required this.deleteNote,
    required this.noteRepository,
  }) : super(NoteInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<LoadPinnedNotes>(_onLoadPinnedNotes);
    on<LoadArchivedNotes>(_onLoadArchivedNotes);
    on<CreateNoteEvent>(_onCreateNote);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<DeleteNoteEvent>(_onDeleteNote);
    on<SearchNotesEvent>(_onSearchNotes);
    on<TogglePinNoteEvent>(_onTogglePinNote);
    on<ToggleArchiveNoteEvent>(_onToggleArchiveNote);
  }

  Future<void> _onLoadNotes(LoadNotes event, Emitter<NoteState> emit) async {
    emit(NoteLoading());
    final result = await getAllNotes(NoParams());
    result.fold(
      (failure) => emit(NoteError(failure.message)),
      (notes) => emit(NotesLoaded(notes)),
    );
  }

  Future<void> _onLoadPinnedNotes(
    LoadPinnedNotes event,
    Emitter<NoteState> emit,
  ) async {
    emit(NoteLoading());
    final result = await noteRepository.getPinnedNotes();
    result.fold(
      (failure) => emit(NoteError(failure.message)),
      (notes) => emit(NotesLoaded(notes)),
    );
  }

  Future<void> _onLoadArchivedNotes(
    LoadArchivedNotes event,
    Emitter<NoteState> emit,
  ) async {
    emit(NoteLoading());
    final result = await noteRepository.getArchivedNotes();
    result.fold(
      (failure) => emit(NoteError(failure.message)),
      (notes) => emit(NotesLoaded(notes)),
    );
  }

  Future<void> _onCreateNote(
    CreateNoteEvent event,
    Emitter<NoteState> emit,
  ) async {
    emit(NoteLoading());
    final result = await createNote(CreateNoteParams(note: event.note));
    result.fold((failure) => emit(NoteError(failure.message)), (note) {
      emit(NoteOperationSuccess('Note created successfully', note: note));
      add(LoadNotes());
    });
  }

  Future<void> _onUpdateNote(
    UpdateNoteEvent event,
    Emitter<NoteState> emit,
  ) async {
    final result = await updateNote(UpdateNoteParams(note: event.note));
    result.fold((failure) => emit(NoteError(failure.message)), (note) {
      emit(NoteOperationSuccess('Note updated successfully', note: note));
      add(LoadNotes());
    });
  }

  Future<void> _onDeleteNote(
    DeleteNoteEvent event,
    Emitter<NoteState> emit,
  ) async {
    final result = await deleteNote(DeleteNoteParams(id: event.noteId));
    result.fold((failure) => emit(NoteError(failure.message)), (_) {
      emit(const NoteOperationSuccess('Note deleted successfully'));
      add(LoadNotes());
    });
  }

  Future<void> _onSearchNotes(
    SearchNotesEvent event,
    Emitter<NoteState> emit,
  ) async {
    emit(NoteLoading());
    final result = await noteRepository.searchNotes(event.query);
    result.fold(
      (failure) => emit(NoteError(failure.message)),
      (notes) => emit(NotesLoaded(notes)),
    );
  }

  Future<void> _onTogglePinNote(
    TogglePinNoteEvent event,
    Emitter<NoteState> emit,
  ) async {
    final result = await noteRepository.togglePinNote(event.noteId);
    result.fold((failure) => emit(NoteError(failure.message)), (note) {
      emit(
        NoteOperationSuccess(
          'Note ${note.isPinned ? "pinned" : "unpinned"}',
          note: note,
        ),
      );
      add(LoadNotes());
    });
  }

  Future<void> _onToggleArchiveNote(
    ToggleArchiveNoteEvent event,
    Emitter<NoteState> emit,
  ) async {
    final result = await noteRepository.toggleArchiveNote(event.noteId);
    result.fold((failure) => emit(NoteError(failure.message)), (note) {
      emit(
        NoteOperationSuccess(
          'Note ${note.isArchived ? "archived" : "unarchived"}',
          note: note,
        ),
      );
      add(LoadNotes());
    });
  }
}
