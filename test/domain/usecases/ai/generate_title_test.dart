import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_note/core/error/failures.dart';
import 'package:smart_note/data/repositories/ai_repository_impl.dart';
import 'package:smart_note/domain/usecases/ai/generate_title.dart';

@GenerateMocks([AIRepositoryImpl])
import 'generate_title_test.mocks.dart';

void main() {
  late GenerateTitle usecase;
  late MockAIRepositoryImpl mockRepository;

  setUp(() {
    mockRepository = MockAIRepositoryImpl();
    usecase = GenerateTitle(mockRepository);
  });

  const testContent =
      'This is a test note about Flutter development and BLoC pattern';
  const testTitle = 'Flutter Development and BLoC Pattern';

  test('should generate title from repository', () async {
    // arrange
    when(
      mockRepository.generateTitle(any),
    ).thenAnswer((_) async => const Right(testTitle));

    // act
    final result = await usecase(
      const GenerateTitleParams(content: testContent),
    );

    // assert
    expect(result, const Right(testTitle));
    verify(mockRepository.generateTitle(testContent));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ValidationFailure when content is empty', () async {
    // act
    final result = await usecase(const GenerateTitleParams(content: ''));

    // assert
    expect(result, const Left(ValidationFailure('Content is empty')));
    verifyNever(mockRepository.generateTitle(any));
  });

  test('should return ValidationFailure when content is whitespace', () async {
    // act
    final result = await usecase(const GenerateTitleParams(content: '   '));

    // assert
    expect(result, const Left(ValidationFailure('Content is empty')));
    verifyNever(mockRepository.generateTitle(any));
  });

  test('should return AIFailure when repository fails', () async {
    // arrange
    when(
      mockRepository.generateTitle(any),
    ).thenAnswer((_) async => const Left(AIFailure('API error')));

    // act
    final result = await usecase(
      const GenerateTitleParams(content: testContent),
    );

    // assert
    expect(result, const Left(AIFailure('API error')));
    verify(mockRepository.generateTitle(testContent));
  });

  test('should handle long content', () async {
    // arrange
    final longContent = 'a' * 1000;
    when(
      mockRepository.generateTitle(any),
    ).thenAnswer((_) async => const Right(testTitle));

    // act
    final result = await usecase(GenerateTitleParams(content: longContent));

    // assert
    expect(result, const Right(testTitle));
    verify(mockRepository.generateTitle(longContent));
  });
}
