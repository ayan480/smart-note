import 'package:flutter_test/flutter_test.dart';
import 'package:smart_note/domain/entities/ai_suggestion.dart';

void main() {
  group('AISuggestion Entity', () {
    final testSuggestion = AISuggestion(
      id: '1',
      content: 'Consider adding more details',
      type: SuggestionType.completion,
      confidence: 0.85,
      createdAt: DateTime(2024, 1, 1),
    );

    test('should create an AISuggestion instance with all properties', () {
      expect(testSuggestion.id, '1');
      expect(testSuggestion.content, 'Consider adding more details');
      expect(testSuggestion.type, SuggestionType.completion);
      expect(testSuggestion.confidence, 0.85);
      expect(testSuggestion.createdAt, DateTime(2024, 1, 1));
    });

    test('should support value equality', () {
      final suggestion1 = AISuggestion(
        id: '1',
        content: 'Test',
        type: SuggestionType.correction,
        confidence: 0.9,
        createdAt: DateTime(2024, 1, 1),
      );

      final suggestion2 = AISuggestion(
        id: '1',
        content: 'Test',
        type: SuggestionType.correction,
        confidence: 0.9,
        createdAt: DateTime(2024, 1, 1),
      );

      expect(suggestion1, equals(suggestion2));
    });

    test('should have all suggestion types', () {
      expect(SuggestionType.values.length, 5);
      expect(SuggestionType.values, contains(SuggestionType.completion));
      expect(SuggestionType.values, contains(SuggestionType.correction));
      expect(SuggestionType.values, contains(SuggestionType.formatting));
      expect(SuggestionType.values, contains(SuggestionType.related));
      expect(SuggestionType.values, contains(SuggestionType.action));
    });

    test('confidence should be between 0 and 1', () {
      expect(testSuggestion.confidence, greaterThanOrEqualTo(0.0));
      expect(testSuggestion.confidence, lessThanOrEqualTo(1.0));
    });
  });
}
