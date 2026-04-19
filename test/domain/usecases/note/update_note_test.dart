import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_note/domain/entities/note.dart';
import 'package:smart_note/domain/usecases/note/update_note.dart';
import '../../../mocks/mock_repositories.dart';

void main() {
  late UpdateNote usecase;
  late MockNoteRepository mockNoteRepository;

  setUp(() {
    mockNoteRepository = MockNoteRepository();
    usecase = UpdateNote(mockNoteRepository);
  });

  final testNote = Note(
    id: '1',
    title: 'Updated Note',
    content: 'Updated Content',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 2),
  );

  test('should update a note through the repository', () async {
    // arrange
    when(
      mockNoteRepository.updateNote(any),
    ).thenAnswer((_) async => Right(testNote));

    // act
    final result = await usecase(UpdateNoteParams(note: testNote));

    // assert
    expect(result, Right(testNote));
    verify(mockNoteRepository.updateNote(testNote));
    verifyNoMoreInteractions(mockNoteRepository);
  });
}
