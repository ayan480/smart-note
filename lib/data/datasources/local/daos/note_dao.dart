import 'package:floor/floor.dart';
import '../../../models/note_model.dart';

@dao
abstract class NoteDao {
  @Query(
    'SELECT * FROM notes WHERE isArchived = 0 ORDER BY isPinned DESC, updatedAt DESC',
  )
  Future<List<NoteModel>> getAllNotes();

  @Query('SELECT * FROM notes WHERE id = :id')
  Future<NoteModel?> getNoteById(String id);

  @Query(
    'SELECT * FROM notes WHERE isPinned = 1 AND isArchived = 0 ORDER BY updatedAt DESC',
  )
  Future<List<NoteModel>> getPinnedNotes();

  @Query('SELECT * FROM notes WHERE isArchived = 1 ORDER BY updatedAt DESC')
  Future<List<NoteModel>> getArchivedNotes();

  @Query(
    'SELECT * FROM notes WHERE (title LIKE :query OR content LIKE :query) AND isArchived = 0',
  )
  Future<List<NoteModel>> searchNotes(String query);

  @insert
  Future<void> insertNote(NoteModel note);

  @update
  Future<void> updateNote(NoteModel note);

  @Query('DELETE FROM notes WHERE id = :id')
  Future<void> deleteNote(String id);

  @Query('DELETE FROM notes')
  Future<void> deleteAllNotes();
}
