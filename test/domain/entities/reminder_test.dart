import 'package:flutter_test/flutter_test.dart';
import 'package:smart_note/domain/entities/reminder.dart';

void main() {
  group('Reminder Entity', () {
    final testReminder = Reminder(
      id: '1',
      noteId: 'note1',
      reminderTime: DateTime(2024, 12, 31, 10, 0),
      priority: ReminderPriority.high,
      interval: ReminderInterval.oneHour,
      isCompleted: false,
      createdAt: DateTime(2024, 1, 1),
    );

    test('should create a Reminder instance with all properties', () {
      expect(testReminder.id, '1');
      expect(testReminder.noteId, 'note1');
      expect(testReminder.reminderTime, DateTime(2024, 12, 31, 10, 0));
      expect(testReminder.priority, ReminderPriority.high);
      expect(testReminder.interval, ReminderInterval.oneHour);
      expect(testReminder.isCompleted, false);
    });

    test('should support value equality', () {
      final reminder1 = Reminder(
        id: '1',
        noteId: 'note1',
        reminderTime: DateTime(2024, 12, 31),
        priority: ReminderPriority.medium,
        interval: ReminderInterval.fiveMinutes,
        createdAt: DateTime(2024, 1, 1),
      );

      final reminder2 = Reminder(
        id: '1',
        noteId: 'note1',
        reminderTime: DateTime(2024, 12, 31),
        priority: ReminderPriority.medium,
        interval: ReminderInterval.fiveMinutes,
        createdAt: DateTime(2024, 1, 1),
      );

      expect(reminder1, equals(reminder2));
    });

    test('copyWith should create a new instance with updated values', () {
      final updatedReminder = testReminder.copyWith(
        priority: ReminderPriority.urgent,
        isCompleted: true,
      );

      expect(updatedReminder.priority, ReminderPriority.urgent);
      expect(updatedReminder.isCompleted, true);
      expect(updatedReminder.noteId, testReminder.noteId);
      expect(updatedReminder.interval, testReminder.interval);
    });

    test('should have all priority levels', () {
      expect(ReminderPriority.values.length, 4);
      expect(ReminderPriority.values, contains(ReminderPriority.low));
      expect(ReminderPriority.values, contains(ReminderPriority.medium));
      expect(ReminderPriority.values, contains(ReminderPriority.high));
      expect(ReminderPriority.values, contains(ReminderPriority.urgent));
    });

    test('should have all interval options', () {
      expect(ReminderInterval.values.length, 5);
      expect(ReminderInterval.values, contains(ReminderInterval.fiveMinutes));
      expect(
        ReminderInterval.values,
        contains(ReminderInterval.fifteenMinutes),
      );
      expect(ReminderInterval.values, contains(ReminderInterval.thirtyMinutes));
      expect(ReminderInterval.values, contains(ReminderInterval.oneHour));
      expect(ReminderInterval.values, contains(ReminderInterval.oneDay));
    });
  });
}
