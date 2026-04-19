import 'package:mockito/mockito.dart';
import 'package:smart_note/domain/repositories/note_repository.dart';
import 'package:smart_note/domain/repositories/ai_repository.dart';
import 'package:smart_note/domain/repositories/voice_repository.dart';
import 'package:smart_note/domain/repositories/reminder_repository.dart';

class MockNoteRepository extends Mock implements NoteRepository {}

class MockAIRepository extends Mock implements AIRepository {}

class MockVoiceRepository extends Mock implements VoiceRepository {}

class MockReminderRepository extends Mock implements ReminderRepository {}
