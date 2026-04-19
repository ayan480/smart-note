import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/note.dart';

/// Repository interface for Note operations
abstract class NoteRepository {
  /// Create a new note
  Future<Either<Failure, Note>> createNote(Note note);

  /// Get a note by ID
  Future<Either<Failure, Note>> getNoteById(String id);

  /// Get all notes
  Future<Either<Failure, List<Note>>> getAllNotes();

  /// Get pinned notes
  Future<Either<Failure, List<Note>>> getPinnedNotes();

  /// Get archived notes
  Future<Either<Failure, List<Note>>> getArchivedNotes();

  /// Update a note
  Future<Either<Failure, Note>> updateNote(Note note);

  /// Delete a note
  Future<Either<Failure, void>> deleteNote(String id);

  /// Search notes by query
  Future<Either<Failure, List<Note>>> searchNotes(String query);

  /// Pin/Unpin a note
  Future<Either<Failure, Note>> togglePinNote(String id);

  /// Archive/Unarchive a note
  Future<Either<Failure, Note>> toggleArchiveNote(String id);
}
