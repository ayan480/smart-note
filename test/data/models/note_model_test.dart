import 'package:flutter_test/flutter_test.dart';
import 'package:smart_note/data/models/note_model.dart';
import 'package:smart_note/domain/entities/note.dart';

void main() {
  group('NoteModel', () {
    final testNoteModel = NoteModel(
      id: '1',
      title: 'Test Note',
      content: 'Test Content',
      createdAt: DateTime(2024, 1, 1).millisecondsSinceEpoch,
      updatedAt: DateTime(2024, 1, 1).millisecondsSinceEpoch,
      backgroundColor: '#FFFFFF',
      attachmentIds: 'att1,att2',
      isPinned: 1,
      isArchived: 0,
      tags: 'tag1,tag2',
    );

    final testNote = Note(
      id: '1',
      title: 'Test Note',
      content: 'Test Content',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
      backgroundColor: '#FFFFFF',
      attachmentIds: const ['att1', 'att2'],
      isPinned: true,
      isArchived: false,
      tags: const ['tag1', 'tag2'],
    );

    test('should convert from entity to model', () {
      final model = NoteModel.fromEntity(testNote);

      expect(model.id, testNote.id);
      expect(model.title, testNote.title);
      expect(model.content, testNote.content);
      expect(model.backgroundColor, testNote.backgroundColor);
      expect(model.attachmentIds, 'att1,att2');
      expect(model.isPinned, 1);
      expect(model.isArchived, 0);
      expect(model.tags, 'tag1,tag2');
    });

    test('should convert from model to entity', () {
      final entity = testNoteModel.toEntity();

      expect(entity.id, testNoteModel.id);
      expect(entity.title, testNoteModel.title);
      expect(entity.content, testNoteModel.content);
      expect(entity.backgroundColor, testNoteModel.backgroundColor);
      expect(entity.attachmentIds, ['att1', 'att2']);
      expect(entity.isPinned, true);
      expect(entity.isArchived, false);
      expect(entity.tags, ['tag1', 'tag2']);
    });

    test('should handle empty attachmentIds and tags', () {
      final model = NoteModel(
        id: '1',
        title: 'Test',
        content: 'Content',
        createdAt: DateTime(2024, 1, 1).millisecondsSinceEpoch,
        updatedAt: DateTime(2024, 1, 1).millisecondsSinceEpoch,
        attachmentIds: '',
        tags: '',
      );

      final entity = model.toEntity();

      expect(entity.attachmentIds, isEmpty);
      expect(entity.tags, isEmpty);
    });

    test('should convert boolean to int correctly', () {
      final pinnedNote = Note(
        id: '1',
        title: 'Test',
        content: 'Content',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
        isPinned: true,
        isArchived: false,
      );

      final model = NoteModel.fromEntity(pinnedNote);

      expect(model.isPinned, 1);
      expect(model.isArchived, 0);
    });

    test('should convert int to boolean correctly', () {
      final model = NoteModel(
        id: '1',
        title: 'Test',
        content: 'Content',
        createdAt: DateTime(2024, 1, 1).millisecondsSinceEpoch,
        updatedAt: DateTime(2024, 1, 1).millisecondsSinceEpoch,
        isPinned: 1,
        isArchived: 0,
      );

      final entity = model.toEntity();

      expect(entity.isPinned, true);
      expect(entity.isArchived, false);
    });

    test('should preserve datetime precision', () {
      final now = DateTime.now();
      final note = Note(
        id: '1',
        title: 'Test',
        content: 'Content',
        createdAt: now,
        updatedAt: now,
      );

      final model = NoteModel.fromEntity(note);
      final entity = model.toEntity();

      expect(
        entity.createdAt.millisecondsSinceEpoch,
        now.millisecondsSinceEpoch,
      );
      expect(
        entity.updatedAt.millisecondsSinceEpoch,
        now.millisecondsSinceEpoch,
      );
    });
  });
}
