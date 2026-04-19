import 'package:get_it/get_it.dart';
import 'data/datasources/local/database/app_database.dart';
import 'data/repositories/note_repository_impl.dart';
import 'domain/repositories/note_repository.dart';
import 'domain/usecases/note/create_note.dart';
import 'domain/usecases/note/delete_note.dart';
import 'domain/usecases/note/get_all_notes.dart';
import 'domain/usecases/note/update_note.dart';
import 'presentation/bloc/note/note_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC
  sl.registerFactory(
    () => NoteBloc(
      getAllNotes: sl(),
      createNote: sl(),
      updateNote: sl(),
      deleteNote: sl(),
      noteRepository: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllNotes(sl()));
  sl.registerLazySingleton(() => CreateNote(sl()));
  sl.registerLazySingleton(() => UpdateNote(sl()));
  sl.registerLazySingleton(() => DeleteNote(sl()));

  // Repository
  sl.registerLazySingleton<NoteRepository>(
    () => NoteRepositoryImpl(noteDao: sl()),
  );

  // Database
  final database = await $FloorAppDatabase
      .databaseBuilder('smart_note.db')
      .build();

  sl.registerLazySingleton(() => database);
  sl.registerLazySingleton(() => database.noteDao);
  sl.registerLazySingleton(() => database.reminderDao);
}
