import 'package:mockito/mockito.dart';
import 'package:smart_note/domain/usecases/note/create_note.dart';
import 'package:smart_note/domain/usecases/note/get_all_notes.dart';
import 'package:smart_note/domain/usecases/note/update_note.dart';
import 'package:smart_note/domain/usecases/note/delete_note.dart';

class MockCreateNote extends Mock implements CreateNote {}

class MockGetAllNotes extends Mock implements GetAllNotes {}

class MockUpdateNote extends Mock implements UpdateNote {}

class MockDeleteNote extends Mock implements DeleteNote {}
