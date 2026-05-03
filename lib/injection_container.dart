import 'package:get_it/get_it.dart';
import 'data/datasources/local/database/app_database.dart';
import 'data/datasources/local/voice_service.dart';
import 'data/datasources/remote/ai_service.dart';
import 'data/repositories/ai_repository_impl.dart';
import 'data/repositories/note_repository_impl.dart';
import 'data/repositories/voice_repository_impl.dart';
import 'domain/repositories/ai_repository.dart';
import 'domain/repositories/note_repository.dart';
import 'domain/repositories/voice_repository.dart';
import 'domain/usecases/ai/analyze_writing.dart';
import 'domain/usecases/ai/apply_smart_formatting.dart';
import 'domain/usecases/ai/correct_grammar.dart';
import 'domain/usecases/ai/extract_action_items.dart';
import 'domain/usecases/ai/find_related_notes.dart';
import 'domain/usecases/ai/generate_insights.dart';
import 'domain/usecases/ai/generate_meeting_notes.dart';
import 'domain/usecases/ai/generate_tags.dart';
import 'domain/usecases/ai/generate_title.dart';
import 'domain/usecases/ai/get_text_completion.dart';
import 'domain/usecases/ai/semantic_search.dart';
import 'domain/usecases/ai/suggest_reminders.dart';
import 'domain/usecases/ai/summarize_content.dart';
import 'domain/usecases/note/create_note.dart';
import 'domain/usecases/note/delete_note.dart';
import 'domain/usecases/note/get_all_notes.dart';
import 'domain/usecases/note/update_note.dart';
import 'domain/usecases/voice/start_recording.dart';
import 'domain/usecases/voice/start_voice_input.dart';
import 'domain/usecases/voice/stop_recording.dart';
import 'domain/usecases/voice/stop_voice_input.dart';
import 'presentation/bloc/ai/ai_bloc.dart';
import 'presentation/bloc/note/note_bloc.dart';
import 'presentation/bloc/voice/voice_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoCs
  sl.registerFactory(
    () => NoteBloc(
      getAllNotes: sl(),
      createNote: sl(),
      updateNote: sl(),
      deleteNote: sl(),
      noteRepository: sl(),
    ),
  );

  sl.registerFactory(
    () => AIBloc(
      generateTitle: sl(),
      generateTags: sl(),
      getTextCompletion: sl(),
      extractActionItems: sl(),
      summarizeContent: sl(),
      analyzeWriting: sl(),
      suggestReminders: sl(),
      findRelatedNotes: sl(),
      generateInsights: sl(),
      correctGrammar: sl(),
      applySmartFormatting: sl(),
      generateMeetingNotes: sl(),
      semanticSearch: sl(),
    ),
  );

  sl.registerFactory(
    () => VoiceBloc(
      startVoiceInput: sl(),
      stopVoiceInput: sl(),
      startRecording: sl(),
      stopRecording: sl(),
      voiceRepository: sl(),
    ),
  );

  // Note Use cases
  sl.registerLazySingleton(() => GetAllNotes(sl()));
  sl.registerLazySingleton(() => CreateNote(sl()));
  sl.registerLazySingleton(() => UpdateNote(sl()));
  sl.registerLazySingleton(() => DeleteNote(sl()));

  // AI Use cases
  sl.registerLazySingleton(() => GenerateTitle(sl()));
  sl.registerLazySingleton(() => GenerateTags(sl()));
  sl.registerLazySingleton(() => GetTextCompletion(sl()));
  sl.registerLazySingleton(() => ExtractActionItems(sl()));
  sl.registerLazySingleton(() => SummarizeContent(sl()));
  sl.registerLazySingleton(() => AnalyzeWriting(sl()));
  sl.registerLazySingleton(() => SuggestReminders(sl()));
  sl.registerLazySingleton(() => FindRelatedNotes(sl()));
  sl.registerLazySingleton(() => GenerateInsights(sl()));
  sl.registerLazySingleton(() => CorrectGrammar(sl()));
  sl.registerLazySingleton(() => ApplySmartFormatting(sl()));
  sl.registerLazySingleton(() => GenerateMeetingNotes(sl()));
  sl.registerLazySingleton(() => SemanticSearch(sl()));

  // Voice Use cases
  sl.registerLazySingleton(() => StartVoiceInput(sl()));
  sl.registerLazySingleton(() => StopVoiceInput(sl()));
  sl.registerLazySingleton(() => StartRecording(sl()));
  sl.registerLazySingleton(() => StopRecording(sl()));

  // Repositories
  sl.registerLazySingleton<NoteRepository>(
    () => NoteRepositoryImpl(noteDao: sl()),
  );

  sl.registerLazySingleton<AIRepository>(
    () => AIRepositoryImpl(aiService: sl()),
  );

  sl.registerLazySingleton(() => AIRepositoryImpl(aiService: sl()));

  sl.registerLazySingleton<VoiceRepository>(
    () => VoiceRepositoryImpl(voiceService: sl()),
  );

  // Services
  sl.registerLazySingleton(
    () => AIService(
      apiKey: const String.fromEnvironment('GEMINI_API_KEY', defaultValue: ''),
    ),
  );

  sl.registerLazySingleton(() => VoiceService());

  // Database
  final database = await $FloorAppDatabase
      .databaseBuilder('smart_note.db')
      .build();

  sl.registerLazySingleton(() => database);
  sl.registerLazySingleton(() => database.noteDao);
  sl.registerLazySingleton(() => database.reminderDao);
}
