import 'package:floor/floor.dart';
import '../../../models/reminder_model.dart';

@dao
abstract class ReminderDao {
  @Query('SELECT * FROM reminders ORDER BY reminderTime ASC')
  Future<List<ReminderModel>> getAllReminders();

  @Query('SELECT * FROM reminders WHERE id = :id')
  Future<ReminderModel?> getReminderById(String id);

  @Query('SELECT * FROM reminders WHERE noteId = :noteId')
  Future<ReminderModel?> getReminderByNoteId(String noteId);

  @Query(
    'SELECT * FROM reminders WHERE isCompleted = 0 ORDER BY reminderTime ASC',
  )
  Future<List<ReminderModel>> getPendingReminders();

  @insert
  Future<void> insertReminder(ReminderModel reminder);

  @update
  Future<void> updateReminder(ReminderModel reminder);

  @Query('DELETE FROM reminders WHERE id = :id')
  Future<void> deleteReminder(String id);

  @Query('DELETE FROM reminders WHERE noteId = :noteId')
  Future<void> deleteRemindersByNoteId(String noteId);
}
