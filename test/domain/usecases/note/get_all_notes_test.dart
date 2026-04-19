import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_note/core/usecases/usecase.dart';
import 'package:smart_note/domain/entities/note.dart';
import 'package:smart_note/domain/usecases/note/get_all_notes.dart';
import '../../../mocks/mock_repositories.dart';

void main() {
  late GetAllNotes usecase;
  late MockNoteRepository mockNoteRepository;

  setUp(() {
    mockNoteRepository = MockNoteRepository();
    usecase = GetAllNotes(mockNoteRepository);
  });

  final testNotes = [
    Note(
      id: '1',
      title: 'Note 1',
      content: 'Content 1',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
    Note(
      id: '2',
      title: 'Note 2',
      content: 'Content 2',
      createdAt: DateTime(2024, 1, 2),
      updatedAt: DateTime(2024, 1, 2),
    ),
  ];

  test('should get all notes from the repository', () async {
    // arrange
    when(
      mockNoteRepository.getAllNotes(),
    ).thenAnswer((_) async => Right(testNotes));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, Right(testNotes));
    verify(mockNoteRepository.getAllNotes());
    verifyNoMoreInteractions(mockNoteRepository);
  });

  test('should return empty list when no notes exist', () async {
    // arrange
    when(
      mockNoteRepository.getAllNotes(),
    ).thenAnswer((_) async => const Right([]));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, const Right([]));
    verify(mockNoteRepository.getAllNotes());
  });
}
