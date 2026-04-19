import 'package:equatable/equatable.dart';

enum ReminderPriority { low, medium, high, urgent }

enum ReminderInterval {
  fiveMinutes,
  fifteenMinutes,
  thirtyMinutes,
  oneHour,
  oneDay,
}

/// Reminder entity for note reminders
class Reminder extends Equatable {
  final String id;
  final String noteId;
  final DateTime reminderTime;
  final ReminderPriority priority;
  final ReminderInterval interval;
  final bool isCompleted;
  final DateTime createdAt;

  const Reminder({
    required this.id,
    required this.noteId,
    required this.reminderTime,
    required this.priority,
    required this.interval,
    this.isCompleted = false,
    required this.createdAt,
  });

  Reminder copyWith({
    String? id,
    String? noteId,
    DateTime? reminderTime,
    ReminderPriority? priority,
    ReminderInterval? interval,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Reminder(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      reminderTime: reminderTime ?? this.reminderTime,
      priority: priority ?? this.priority,
      interval: interval ?? this.interval,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    noteId,
    reminderTime,
    priority,
    interval,
    isCompleted,
    createdAt,
  ];
}
