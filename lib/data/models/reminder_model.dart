import 'package:floor/floor.dart';
import '../../domain/entities/reminder.dart';

@Entity(tableName: 'reminders')
class ReminderModel {
  @PrimaryKey()
  final String id;

  final String noteId;
  final int reminderTime;
  final String priority; // Stored as string enum
  final String interval; // Stored as string enum
  final int isCompleted;
  final int createdAt;

  const ReminderModel({
    required this.id,
    required this.noteId,
    required this.reminderTime,
    required this.priority,
    required this.interval,
    this.isCompleted = 0,
    required this.createdAt,
  });

  /// Convert domain entity to data model
  factory ReminderModel.fromEntity(Reminder reminder) {
    return ReminderModel(
      id: reminder.id,
      noteId: reminder.noteId,
      reminderTime: reminder.reminderTime.millisecondsSinceEpoch,
      priority: reminder.priority.name,
      interval: reminder.interval.name,
      isCompleted: reminder.isCompleted ? 1 : 0,
      createdAt: reminder.createdAt.millisecondsSinceEpoch,
    );
  }

  /// Convert data model to domain entity
  Reminder toEntity() {
    return Reminder(
      id: id,
      noteId: noteId,
      reminderTime: DateTime.fromMillisecondsSinceEpoch(reminderTime),
      priority: ReminderPriority.values.firstWhere((e) => e.name == priority),
      interval: ReminderInterval.values.firstWhere((e) => e.name == interval),
      isCompleted: isCompleted == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
    );
  }
}
