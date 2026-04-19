import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_note/domain/entities/note.dart';
import 'package:smart_note/domain/usecases/note/create_note.dart';
import '../../../mocks/mock_repositories.dart';

void main() {
  late CreateNote usecase;
  late MockNoteRepository mockNoteRepository;

  setUp(() {
    mockNoteRepository = MockNoteRepository();
    usecase = CreateNote(mockNoteRepository);
  });

  final testNote = Note(
    id: '1',
    title: 'Test Note',
    content: 'Test Content',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  test('should create a note through the repository', () async {
    // arrange
    when(
      mockNoteRepository.createNote(any),
    ).thenAnswer((_) async => Right(testNote));

    // act
    final result = await usecase(CreateNoteParams(note: testNote));

    // assert
    expect(result, Right(testNote));
    verify(mockNoteRepository.createNote(testNote));
    verifyNoMoreInteractions(mockNoteRepository);
  });
}
