import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_note/domain/usecases/note/delete_note.dart';
import '../../../mocks/mock_repositories.dart';

void main() {
  late DeleteNote usecase;
  late MockNoteRepository mockNoteRepository;

  setUp(() {
    mockNoteRepository = MockNoteRepository();
    usecase = DeleteNote(mockNoteRepository);
  });

  const testNoteId = '1';

  test('should delete a note through the repository', () async {
    // arrange
    when(
      mockNoteRepository.deleteNote(any),
    ).thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase(const DeleteNoteParams(id: testNoteId));

    // assert
    expect(result, const Right(null));
    verify(mockNoteRepository.deleteNote(testNoteId));
    verifyNoMoreInteractions(mockNoteRepository);
  });
}
