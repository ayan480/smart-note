import 'package:flutter_test/flutter_test.dart';
import 'package:smart_note/core/error/failures.dart';

void main() {
  group('Failures', () {
    test('DatabaseFailure should have correct message', () {
      const failure = DatabaseFailure('Database error');
      expect(failure.message, 'Database error');
    });

    test('NetworkFailure should have correct message', () {
      const failure = NetworkFailure('Network error');
      expect(failure.message, 'Network error');
    });

    test('PermissionFailure should have correct message', () {
      const failure = PermissionFailure('Permission denied');
      expect(failure.message, 'Permission denied');
    });

    test('FileFailure should have correct message', () {
      const failure = FileFailure('File not found');
      expect(failure.message, 'File not found');
    });

    test('AIFailure should have correct message', () {
      const failure = AIFailure('AI service error');
      expect(failure.message, 'AI service error');
    });

    test('VoiceFailure should have correct message', () {
      const failure = VoiceFailure('Voice recognition error');
      expect(failure.message, 'Voice recognition error');
    });

    test('ValidationFailure should have correct message', () {
      const failure = ValidationFailure('Validation error');
      expect(failure.message, 'Validation error');
    });

    test('Failures with same message should be equal', () {
      const failure1 = DatabaseFailure('Error');
      const failure2 = DatabaseFailure('Error');
      expect(failure1, equals(failure2));
    });

    test('Failures with different messages should not be equal', () {
      const failure1 = DatabaseFailure('Error 1');
      const failure2 = DatabaseFailure('Error 2');
      expect(failure1, isNot(equals(failure2)));
    });

    test('Different failure types should not be equal', () {
      const failure1 = DatabaseFailure('Error');
      const failure2 = NetworkFailure('Error');
      expect(failure1, isNot(equals(failure2)));
    });
  });
}
