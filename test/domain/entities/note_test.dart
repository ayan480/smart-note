import 'package:flutter_test/flutter_test.dart';
import 'package:smart_note/domain/entities/note.dart';

void main() {
  group('Note Entity', () {
    final testNote = Note(
      id: '1',
      title: 'Test Note',
      content: 'Test Content',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
      backgroundColor: '#FFFFFF',
      attachmentIds: const ['att1', 'att2'],
      isPinned: false,
      isArchived: false,
      tags: const ['tag1', 'tag2'],
    );

    test('should create a Note instance with all properties', () {
      expect(testNote.id, '1');
      expect(testNote.title, 'Test Note');
      expect(testNote.content, 'Test Content');
      expect(testNote.backgroundColor, '#FFFFFF');
      expect(testNote.attachmentIds, ['att1', 'att2']);
      expect(testNote.isPinned, false);
      expect(testNote.isArchived, false);
      expect(testNote.tags, ['tag1', 'tag2']);
    });

    test('should support value equality', () {
      final note1 = Note(
        id: '1',
        title: 'Test',
        content: 'Content',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final note2 = Note(
        id: '1',
        title: 'Test',
        content: 'Content',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      expect(note1, equals(note2));
    });

    test('copyWith should create a new instance with updated values', () {
      final updatedNote = testNote.copyWith(
        title: 'Updated Title',
        isPinned: true,
      );

      expect(updatedNote.title, 'Updated Title');
      expect(updatedNote.isPinned, true);
      expect(updatedNote.content, testNote.content);
      expect(updatedNote.id, testNote.id);
    });

    test(
      'copyWith should keep original values when no parameters provided',
      () {
        final copiedNote = testNote.copyWith();

        expect(copiedNote, equals(testNote));
      },
    );

    test('should handle empty lists for attachmentIds and tags', () {
      final note = Note(
        id: '1',
        title: 'Test',
        content: 'Content',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      expect(note.attachmentIds, isEmpty);
      expect(note.tags, isEmpty);
    });
  });
}
