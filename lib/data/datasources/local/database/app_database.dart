import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import '../../../models/note_model.dart';
import '../../../models/reminder_model.dart';
import '../daos/note_dao.dart';
import '../daos/reminder_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [NoteModel, ReminderModel])
abstract class AppDatabase extends FloorDatabase {
  NoteDao get noteDao;
  ReminderDao get reminderDao;
}
