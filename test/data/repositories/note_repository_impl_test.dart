import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_note/core/error/failures.dart';
import 'package:smart_note/data/models/note_model.dart';
import 'package:smart_note/data/repositories/note_repository_impl.dart';
import 'package:smart_note/domain/entities/note.dart';
import '../../mocks/mock_daos.dart';

void main() {
  late NoteRepositoryImpl repository;
  late MockNoteDao mockNoteDao;

  setUp(() {
    mockNoteDao = MockNoteDao();
    repository = NoteRepositoryImpl(noteDao: mockNoteDao);
  });

  group('createNote', () {
    final testNote = Note(
      id: '1',
      title: 'Test Note',
      content: 'Test Content',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );

    test('should create note successfully', () async {
      // arrange
      when(mockNoteDao.insertNote(any)).thenAnswer((_) async => {});

      // act
      final result = await repository.createNote(testNote);

      // assert
      expect(result, Right(testNote));
      verify(mockNoteDao.insertNote(any));
    });

    test('should return DatabaseFailure when creation fails', () async {
      // arrange
      when(mockNoteDao.insertNote(any)).thenThrow(Exception('Database error'));

      // act
      final result = await repository.createNote(testNote);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<DatabaseFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });

  group('getNoteById', () {
    const testId = '1';
    final testNoteModel = NoteModel(
      id: testId,
      title: 'Test Note',
      content: 'Test Content',
      createdAt: DateTime(2024, 1, 1).millisecondsSinceEpoch,
      updatedAt: DateTime(2024, 1, 1).millisecondsSinceEpoch,
    );

    test('should return note when found', () async {
      // arrange
      when(
        mockNoteDao.getNoteById(testId),
      ).thenAnswer((_) async => testNoteModel);

      // act
      final result = await repository.getNoteById(testId);

      // assert
      expect(result.isRight(), true);
      result.fold((_) => fail('Should return note'), (note) {
        expect(note.id, testId);
        expect(note.title, 'Test Note');
      });
      verify(mockNoteDao.getNoteById(testId));
    });

    test('should return DatabaseFailure when note not found', () async {
      // arrange
      when(mockNoteDao.getNoteById(testId)).thenAnswer((_) async => null);

      // act
      final result = await repository.getNoteById(testId);

      // assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<DatabaseFailure>());
        expect(failure.message, 'Note not found');
      }, (_) => fail('Should return failure'));
    });
  });

  group('getAllNotes', () {
    final testNoteModels = [
      NoteModel(
        id: '1',
        title: 'Note 1',
        content: 'Content 1',
        createdAt: DateTime(2024, 1, 1).millisecondsSinceEpoch,
        updatedAt: DateTime(2024, 1, 1).millisecondsSinceEpoch,
      ),
      NoteModel(
        id: '2',
        title: 'Note 2',
        content: 'Content 2',
        createdAt: DateTime(2024, 1, 2).millisecondsSinceEpoch,
        updatedAt: DateTime(2024, 1, 2).millisecondsSinceEpoch,
      ),
    ];

    test('should return all notes', () async {
      // arrange
      when(mockNoteDao.getAllNotes()).thenAnswer((_) async => testNoteModels);

      // act
      final result = await repository.getAllNotes();

      // assert
      expect(result.isRight(), true);
      result.fold((_) => fail('Should return notes'), (notes) {
        expect(notes.length, 2);
        expect(notes[0].id, '1');
        expect(notes[1].id, '2');
      });
      verify(mockNoteDao.getAllNotes());
    });

    test('should return empty list when no notes exist', () async {
      // arrange
      when(mockNoteDao.getAllNotes()).thenAnswer((_) async => []);

      // act
      final result = await repository.getAllNotes();

      // assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return empty list'),
        (notes) => expect(notes, isEmpty),
      );
    });
  });

  group('updateNote', () {
    final testNote = Note(
      id: '1',
      title: 'Updated Note',
      content: 'Updated Content',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 2),
    );

    test('should update note successfully', () async {
      // arrange
      when(mockNoteDao.updateNote(any)).thenAnswer((_) async => {});

      // act
      final result = await repository.updateNote(testNote);

      // assert
      expect(result, Right(testNote));
      verify(mockNoteDao.updateNote(any));
    });

    test('should return DatabaseFailure when update fails', () async {
      // arrange
      when(mockNoteDao.updateNote(any)).thenThrow(Exception('Update failed'));

      // act
      final result = await repository.updateNote(testNote);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<DatabaseFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });

  group('deleteNote', () {
    const testId = '1';

    test('should delete note successfully', () async {
      // arrange
      when(mockNoteDao.deleteNote(testId)).thenAnswer((_) async => {});

      // act
      final result = await repository.deleteNote(testId);

      // assert
      expect(result, const Right(null));
      verify(mockNoteDao.deleteNote(testId));
    });

    test('should return DatabaseFailure when deletion fails', () async {
      // arrange
      when(
        mockNoteDao.deleteNote(testId),
      ).thenThrow(Exception('Delete failed'));

      // act
      final result = await repository.deleteNote(testId);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<DatabaseFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });

  group('searchNotes', () {
    const query = 'test';
    final testNoteModels = [
      NoteModel(
        id: '1',
        title: 'Test Note',
        content: 'Content',
        createdAt: DateTime(2024, 1, 1).millisecondsSinceEpoch,
        updatedAt: DateTime(2024, 1, 1).millisecondsSinceEpoch,
      ),
    ];

    test('should search notes with query', () async {
      // arrange
      when(
        mockNoteDao.searchNotes('%$query%'),
      ).thenAnswer((_) async => testNoteModels);

      // act
      final result = await repository.searchNotes(query);

      // assert
      expect(result.isRight(), true);
      result.fold((_) => fail('Should return notes'), (notes) {
        expect(notes.length, 1);
        expect(notes[0].title, 'Test Note');
      });
      verify(mockNoteDao.searchNotes('%$query%'));
    });
  });

  group('togglePinNote', () {
    const testId = '1';
    final testNoteModel = NoteModel(
      id: testId,
      title: 'Test Note',
      content: 'Content',
      createdAt: DateTime(2024, 1, 1).millisecondsSinceEpoch,
      updatedAt: DateTime(2024, 1, 1).millisecondsSinceEpoch,
      isPinned: 0,
    );

    test('should toggle pin status', () async {
      // arrange
      when(
        mockNoteDao.getNoteById(testId),
      ).thenAnswer((_) async => testNoteModel);
      when(mockNoteDao.updateNote(any)).thenAnswer((_) async => {});

      // act
      final result = await repository.togglePinNote(testId);

      // assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return note'),
        (note) => expect(note.isPinned, true),
      );
      verify(mockNoteDao.getNoteById(testId));
      verify(mockNoteDao.updateNote(any));
    });
  });

  group('toggleArchiveNote', () {
    const testId = '1';
    final testNoteModel = NoteModel(
      id: testId,
      title: 'Test Note',
      content: 'Content',
      createdAt: DateTime(2024, 1, 1).millisecondsSinceEpoch,
      updatedAt: DateTime(2024, 1, 1).millisecondsSinceEpoch,
      isArchived: 0,
    );

    test('should toggle archive status', () async {
      // arrange
      when(
        mockNoteDao.getNoteById(testId),
      ).thenAnswer((_) async => testNoteModel);
      when(mockNoteDao.updateNote(any)).thenAnswer((_) async => {});

      // act
      final result = await repository.toggleArchiveNote(testId);

      // assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return note'),
        (note) => expect(note.isArchived, true),
      );
      verify(mockNoteDao.getNoteById(testId));
      verify(mockNoteDao.updateNote(any));
    });
  });
}
