import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../datasources/local/daos/note_dao.dart';
import '../models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteDao noteDao;

  NoteRepositoryImpl({required this.noteDao});

  @override
  Future<Either<Failure, Note>> createNote(Note note) async {
    try {
      final noteModel = NoteModel.fromEntity(note);
      await noteDao.insertNote(noteModel);
      return Right(note);
    } catch (e) {
      return Left(DatabaseFailure('Failed to create note: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Note>> getNoteById(String id) async {
    try {
      final noteModel = await noteDao.getNoteById(id);
      if (noteModel == null) {
        return Left(DatabaseFailure('Note not found'));
      }
      return Right(noteModel.toEntity());
    } catch (e) {
      return Left(DatabaseFailure('Failed to get note: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getAllNotes() async {
    try {
      final noteModels = await noteDao.getAllNotes();
      final notes = noteModels.map((model) => model.toEntity()).toList();
      return Right(notes);
    } catch (e) {
      return Left(DatabaseFailure('Failed to get notes: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getPinnedNotes() async {
    try {
      final noteModels = await noteDao.getPinnedNotes();
      final notes = noteModels.map((model) => model.toEntity()).toList();
      return Right(notes);
    } catch (e) {
      return Left(
        DatabaseFailure('Failed to get pinned notes: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getArchivedNotes() async {
    try {
      final noteModels = await noteDao.getArchivedNotes();
      final notes = noteModels.map((model) => model.toEntity()).toList();
      return Right(notes);
    } catch (e) {
      return Left(
        DatabaseFailure('Failed to get archived notes: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Note>> updateNote(Note note) async {
    try {
      final noteModel = NoteModel.fromEntity(note);
      await noteDao.updateNote(noteModel);
      return Right(note);
    } catch (e) {
      return Left(DatabaseFailure('Failed to update note: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNote(String id) async {
    try {
      await noteDao.deleteNote(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Failed to delete note: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> searchNotes(String query) async {
    try {
      final searchQuery = '%$query%';
      final noteModels = await noteDao.searchNotes(searchQuery);
      final notes = noteModels.map((model) => model.toEntity()).toList();
      return Right(notes);
    } catch (e) {
      return Left(DatabaseFailure('Failed to search notes: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Note>> togglePinNote(String id) async {
    try {
      final noteModel = await noteDao.getNoteById(id);
      if (noteModel == null) {
        return Left(DatabaseFailure('Note not found'));
      }
      final note = noteModel.toEntity();
      final updatedNote = note.copyWith(
        isPinned: !note.isPinned,
        updatedAt: DateTime.now(),
      );
      await noteDao.updateNote(NoteModel.fromEntity(updatedNote));
      return Right(updatedNote);
    } catch (e) {
      return Left(DatabaseFailure('Failed to toggle pin: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Note>> toggleArchiveNote(String id) async {
    try {
      final noteModel = await noteDao.getNoteById(id);
      if (noteModel == null) {
        return Left(DatabaseFailure('Note not found'));
      }
      final note = noteModel.toEntity();
      final updatedNote = note.copyWith(
        isArchived: !note.isArchived,
        updatedAt: DateTime.now(),
      );
      await noteDao.updateNote(NoteModel.fromEntity(updatedNote));
      return Right(updatedNote);
    } catch (e) {
      return Left(DatabaseFailure('Failed to toggle archive: ${e.toString()}'));
    }
  }
}
