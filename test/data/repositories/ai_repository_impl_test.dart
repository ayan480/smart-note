import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_note/core/error/failures.dart';
import 'package:smart_note/data/datasources/remote/ai_service.dart';
import 'package:smart_note/data/repositories/ai_repository_impl.dart';

@GenerateMocks([AIService])
import 'ai_repository_impl_test.mocks.dart';

void main() {
  late AIRepositoryImpl repository;
  late MockAIService mockAIService;

  setUp(() {
    mockAIService = MockAIService();
    repository = AIRepositoryImpl(aiService: mockAIService);
  });

  group('generateTitle', () {
    const testContent = 'This is a test note about Flutter development';
    const testTitle = 'Flutter Development Notes';

    test('should return title when AI service succeeds', () async {
      // arrange
      when(mockAIService.generateTitle(any)).thenAnswer((_) async => testTitle);

      // act
      final result = await repository.generateTitle(testContent);

      // assert
      expect(result, const Right(testTitle));
      verify(mockAIService.generateTitle(testContent));
    });

    test('should return ValidationFailure when content is empty', () async {
      // act
      final result = await repository.generateTitle('');

      // assert
      expect(result, const Left(ValidationFailure('Content is empty')));
      verifyNever(mockAIService.generateTitle(any));
    });

    test('should return AIFailure when AI service throws exception', () async {
      // arrange
      when(mockAIService.generateTitle(any)).thenThrow(Exception('API error'));

      // act
      final result = await repository.generateTitle(testContent);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<AIFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });

  group('generateTags', () {
    const testContent = 'Flutter BLoC pattern implementation';
    const existingTags = ['flutter', 'mobile'];
    const generatedTags = ['flutter', 'bloc', 'architecture'];

    test('should return tags when AI service succeeds', () async {
      // arrange
      when(
        mockAIService.generateTags(any, any),
      ).thenAnswer((_) async => generatedTags);

      // act
      final result = await repository.generateTags(testContent, existingTags);

      // assert
      expect(result, const Right(generatedTags));
      verify(mockAIService.generateTags(testContent, existingTags));
    });

    test('should return ValidationFailure when content is empty', () async {
      // act
      final result = await repository.generateTags('', existingTags);

      // assert
      expect(result, const Left(ValidationFailure('Content is empty')));
    });
  });

  group('extractActionItems', () {
    const testContent = 'TODO: Implement feature\nCall John tomorrow';
    final testActionItems = [
      {'task': 'Implement feature', 'priority': 'high', 'deadline': 'none'},
      {'task': 'Call John', 'priority': 'medium', 'deadline': 'tomorrow'},
    ];

    test('should return action items when AI service succeeds', () async {
      // arrange
      when(
        mockAIService.extractActionItems(any),
      ).thenAnswer((_) async => testActionItems);

      // act
      final result = await repository.extractActionItems(testContent);

      // assert
      expect(result, Right(testActionItems));
      verify(mockAIService.extractActionItems(testContent));
    });

    test('should return ValidationFailure when content is empty', () async {
      // act
      final result = await repository.extractActionItems('');

      // assert
      expect(result, const Left(ValidationFailure('Content is empty')));
    });
  });

  group('summarizeContent', () {
    const testContent = 'Long content that needs to be summarized...';
    const testSummary = 'Brief summary of the content';

    test('should return summary when AI service succeeds', () async {
      // arrange
      when(
        mockAIService.summarizeContent(any),
      ).thenAnswer((_) async => testSummary);

      // act
      final result = await repository.summarizeContent(testContent);

      // assert
      expect(result, const Right(testSummary));
      verify(mockAIService.summarizeContent(testContent));
    });

    test('should return ValidationFailure when content is empty', () async {
      // act
      final result = await repository.summarizeContent('');

      // assert
      expect(result, const Left(ValidationFailure('Content is empty')));
    });
  });

  group('analyzeWriting', () {
    const testContent = 'This is a test content for analysis';
    final testAnalysis = {
      'grammar': ['issue1'],
      'style': ['suggestion1'],
      'readability': 7,
      'assessment': 'Good writing',
    };

    test('should return analysis when AI service succeeds', () async {
      // arrange
      when(
        mockAIService.analyzeWriting(any),
      ).thenAnswer((_) async => testAnalysis);

      // act
      final result = await repository.analyzeWriting(testContent);

      // assert
      expect(result, Right(testAnalysis));
      verify(mockAIService.analyzeWriting(testContent));
    });
  });

  group('correctGrammarAndSpelling', () {
    const testContent = 'This is a test with erors';
    const correctedContent = 'This is a test with errors';

    test('should return corrected text when AI service succeeds', () async {
      // arrange
      when(
        mockAIService.correctGrammarAndSpelling(any),
      ).thenAnswer((_) async => correctedContent);

      // act
      final result = await repository.correctGrammarAndSpelling(testContent);

      // assert
      expect(result, const Right(correctedContent));
      verify(mockAIService.correctGrammarAndSpelling(testContent));
    });
  });

  group('applySmartFormatting', () {
    const testContent = 'unformatted content';
    const formattedContent = '# Formatted Content\n\nWell structured text';

    test('should return formatted text when AI service succeeds', () async {
      // arrange
      when(
        mockAIService.applySmartFormatting(any),
      ).thenAnswer((_) async => formattedContent);

      // act
      final result = await repository.applySmartFormatting(testContent);

      // assert
      expect(result, const Right(formattedContent));
      verify(mockAIService.applySmartFormatting(testContent));
    });
  });
}
