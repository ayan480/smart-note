import 'package:mockito/mockito.dart';
import 'package:smart_note/data/datasources/local/daos/note_dao.dart';
import 'package:smart_note/data/datasources/local/daos/reminder_dao.dart';

class MockNoteDao extends Mock implements NoteDao {}

class MockReminderDao extends Mock implements ReminderDao {}
