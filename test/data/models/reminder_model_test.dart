import 'package:flutter_test/flutter_test.dart';
import 'package:smart_note/data/models/reminder_model.dart';
import 'package:smart_note/domain/entities/reminder.dart';

void main() {
  group('ReminderModel', () {
    final testReminderModel = ReminderModel(
      id: '1',
      noteId: 'note1',
      reminderTime: DateTime(2024, 12, 31, 10, 0).millisecondsSinceEpoch,
      priority: 'high',
      interval: 'oneHour',
      isCompleted: 0,
      createdAt: DateTime(2024, 1, 1).millisecondsSinceEpoch,
    );

    final testReminder = Reminder(
      id: '1',
      noteId: 'note1',
      reminderTime: DateTime(2024, 12, 31, 10, 0),
      priority: ReminderPriority.high,
      interval: ReminderInterval.oneHour,
      isCompleted: false,
      createdAt: DateTime(2024, 1, 1),
    );

    test('should convert from entity to model', () {
      final model = ReminderModel.fromEntity(testReminder);

      expect(model.id, testReminder.id);
      expect(model.noteId, testReminder.noteId);
      expect(model.priority, 'high');
      expect(model.interval, 'oneHour');
      expect(model.isCompleted, 0);
    });

    test('should convert from model to entity', () {
      final entity = testReminderModel.toEntity();

      expect(entity.id, testReminderModel.id);
      expect(entity.noteId, testReminderModel.noteId);
      expect(entity.priority, ReminderPriority.high);
      expect(entity.interval, ReminderInterval.oneHour);
      expect(entity.isCompleted, false);
    });

    test('should handle all priority levels', () {
      for (final priority in ReminderPriority.values) {
        final reminder = Reminder(
          id: '1',
          noteId: 'note1',
          reminderTime: DateTime(2024, 12, 31),
          priority: priority,
          interval: ReminderInterval.oneHour,
          createdAt: DateTime(2024, 1, 1),
        );

        final model = ReminderModel.fromEntity(reminder);
        final entity = model.toEntity();

        expect(entity.priority, priority);
      }
    });

    test('should handle all interval options', () {
      for (final interval in ReminderInterval.values) {
        final reminder = Reminder(
          id: '1',
          noteId: 'note1',
          reminderTime: DateTime(2024, 12, 31),
          priority: ReminderPriority.medium,
          interval: interval,
          createdAt: DateTime(2024, 1, 1),
        );

        final model = ReminderModel.fromEntity(reminder);
        final entity = model.toEntity();

        expect(entity.interval, interval);
      }
    });

    test('should convert completed status correctly', () {
      final completedReminder = Reminder(
        id: '1',
        noteId: 'note1',
        reminderTime: DateTime(2024, 12, 31),
        priority: ReminderPriority.low,
        interval: ReminderInterval.fiveMinutes,
        isCompleted: true,
        createdAt: DateTime(2024, 1, 1),
      );

      final model = ReminderModel.fromEntity(completedReminder);

      expect(model.isCompleted, 1);

      final entity = model.toEntity();

      expect(entity.isCompleted, true);
    });
  });
}
