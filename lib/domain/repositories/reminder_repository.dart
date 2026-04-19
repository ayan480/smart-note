import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/reminder.dart';

/// Repository interface for Reminder operations
abstract class ReminderRepository {
  /// Create a new reminder
  Future<Either<Failure, Reminder>> createReminder(Reminder reminder);

  /// Get a reminder by ID
  Future<Either<Failure, Reminder>> getReminderById(String id);

  /// Get reminder by note ID
  Future<Either<Failure, Reminder?>> getReminderByNoteId(String noteId);

  /// Get all reminders
  Future<Either<Failure, List<Reminder>>> getAllReminders();

  /// Get pending reminders
  Future<Either<Failure, List<Reminder>>> getPendingReminders();

  /// Update a reminder
  Future<Either<Failure, Reminder>> updateReminder(Reminder reminder);

  /// Delete a reminder
  Future<Either<Failure, void>> deleteReminder(String id);

  /// Mark reminder as completed
  Future<Either<Failure, Reminder>> completeReminder(String id);

  /// Schedule notification for reminder
  Future<Either<Failure, void>> scheduleNotification(Reminder reminder);

  /// Cancel notification for reminder
  Future<Either<Failure, void>> cancelNotification(String reminderId);
}
