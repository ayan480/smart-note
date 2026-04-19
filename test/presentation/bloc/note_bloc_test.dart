import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_note/core/error/failures.dart';
import 'package:smart_note/core/usecases/usecase.dart';
import 'package:smart_note/domain/entities/note.dart';
import 'package:smart_note/domain/usecases/note/create_note.dart';
import 'package:smart_note/domain/usecases/note/delete_note.dart';
import 'package:smart_note/domain/usecases/note/update_note.dart';
import 'package:smart_note/presentation/bloc/note/note_bloc.dart';
import 'package:smart_note/presentation/bloc/note/note_event.dart';
import 'package:smart_note/presentation/bloc/note/note_state.dart';
import '../../mocks/mock_usecases.dart';
import '../../mocks/mock_repositories.dart';

void main() {
  late NoteBloc bloc;
  late MockGetAllNotes mockGetAllNotes;
  late MockCreateNote mockCreateNote;
  late MockUpdateNote mockUpdateNote;
  late MockDeleteNote mockDeleteNote;
  late MockNoteRepository mockNoteRepository;

  setUp(() {
    mockGetAllNotes = MockGetAllNotes();
    mockCreateNote = MockCreateNote();
    mockUpdateNote = MockUpdateNote();
    mockDeleteNote = MockDeleteNote();
    mockNoteRepository = MockNoteRepository();

    bloc = NoteBloc(
      getAllNotes: mockGetAllNotes,
      createNote: mockCreateNote,
      updateNote: mockUpdateNote,
      deleteNote: mockDeleteNote,
      noteRepository: mockNoteRepository,
    );
  });

  tearDown(() {
    bloc.close();
  });

  final testNotes = [
    Note(
      id: '1',
      title: 'Note 1',
      content: 'Content 1',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    ),
    Note(
      id: '2',
      title: 'Note 2',
      content: 'Content 2',
      createdAt: DateTime(2024, 1, 2),
      updatedAt: DateTime(2024, 1, 2),
    ),
  ];

  final testNote = Note(
    id: '1',
    title: 'Test Note',
    content: 'Test Content',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  group('LoadNotes', () {
    blocTest<NoteBloc, NoteState>(
      'emits [NoteLoading, NotesLoaded] when LoadNotes is successful',
      build: () {
        when(
          mockGetAllNotes(any as NoParams),
        ).thenAnswer((_) async => Right(testNotes));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadNotes()),
      expect: () => [NoteLoading(), NotesLoaded(testNotes)],
      verify: (_) {
        verify(mockGetAllNotes(NoParams()));
      },
    );

    blocTest<NoteBloc, NoteState>(
      'emits [NoteLoading, NoteError] when LoadNotes fails',
      build: () {
        when(mockGetAllNotes(any as NoParams)).thenAnswer(
          (_) async => const Left(DatabaseFailure('Database error')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(LoadNotes()),
      expect: () => [NoteLoading(), const NoteError('Database error')],
    );

    blocTest<NoteBloc, NoteState>(
      'emits [NoteLoading, NotesLoaded] with empty list when no notes exist',
      build: () {
        when(
          mockGetAllNotes(any as NoParams),
        ).thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadNotes()),
      expect: () => [NoteLoading(), const NotesLoaded([])],
    );
  });

  group('CreateNoteEvent', () {
    blocTest<NoteBloc, NoteState>(
      'emits [NoteLoading, NoteOperationSuccess, NoteLoading, NotesLoaded] when note is created',
      build: () {
        when(
          mockCreateNote(any as CreateNoteParams),
        ).thenAnswer((_) async => Right(testNote));
        when(
          mockGetAllNotes(any as NoParams),
        ).thenAnswer((_) async => Right(testNotes));
        return bloc;
      },
      act: (bloc) => bloc.add(CreateNoteEvent(testNote)),
      expect: () => [
        NoteLoading(),
        NoteOperationSuccess('Note created successfully', note: testNote),
        NoteLoading(),
        NotesLoaded(testNotes),
      ],
      verify: (_) {
        verify(mockCreateNote(CreateNoteParams(note: testNote)));
        verify(mockGetAllNotes(NoParams()));
      },
    );

    blocTest<NoteBloc, NoteState>(
      'emits [NoteLoading, NoteError] when note creation fails',
      build: () {
        when(mockCreateNote(any as CreateNoteParams)).thenAnswer(
          (_) async => const Left(DatabaseFailure('Failed to create')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(CreateNoteEvent(testNote)),
      expect: () => [NoteLoading(), const NoteError('Failed to create')],
    );
  });

  group('UpdateNoteEvent', () {
    blocTest<NoteBloc, NoteState>(
      'emits [NoteOperationSuccess, NoteLoading, NotesLoaded] when note is updated',
      build: () {
        when(
          mockUpdateNote(any as UpdateNoteParams),
        ).thenAnswer((_) async => Right(testNote));
        when(
          mockGetAllNotes(any as NoParams),
        ).thenAnswer((_) async => Right(testNotes));
        return bloc;
      },
      act: (bloc) => bloc.add(UpdateNoteEvent(testNote)),
      expect: () => [
        NoteOperationSuccess('Note updated successfully', note: testNote),
        NoteLoading(),
        NotesLoaded(testNotes),
      ],
      verify: (_) {
        verify(mockUpdateNote(UpdateNoteParams(note: testNote)));
        verify(mockGetAllNotes(NoParams()));
      },
    );

    blocTest<NoteBloc, NoteState>(
      'emits [NoteError] when note update fails',
      build: () {
        when(mockUpdateNote(any as UpdateNoteParams)).thenAnswer(
          (_) async => const Left(DatabaseFailure('Failed to update')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(UpdateNoteEvent(testNote)),
      expect: () => [const NoteError('Failed to update')],
    );
  });

  group('DeleteNoteEvent', () {
    const testNoteId = '1';

    blocTest<NoteBloc, NoteState>(
      'emits [NoteOperationSuccess, NoteLoading, NotesLoaded] when note is deleted',
      build: () {
        when(
          mockDeleteNote(any as DeleteNoteParams),
        ).thenAnswer((_) async => const Right(null));
        when(
          mockGetAllNotes(any as NoParams),
        ).thenAnswer((_) async => Right(testNotes));
        return bloc;
      },
      act: (bloc) => bloc.add(const DeleteNoteEvent(testNoteId)),
      expect: () => [
        const NoteOperationSuccess('Note deleted successfully'),
        NoteLoading(),
        NotesLoaded(testNotes),
      ],
      verify: (_) {
        verify(mockDeleteNote(const DeleteNoteParams(id: testNoteId)));
        verify(mockGetAllNotes(NoParams()));
      },
    );

    blocTest<NoteBloc, NoteState>(
      'emits [NoteError] when note deletion fails',
      build: () {
        when(mockDeleteNote(any as DeleteNoteParams)).thenAnswer(
          (_) async => const Left(DatabaseFailure('Failed to delete')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const DeleteNoteEvent(testNoteId)),
      expect: () => [const NoteError('Failed to delete')],
    );
  });

  group('SearchNotesEvent', () {
    const query = 'test';

    blocTest<NoteBloc, NoteState>(
      'emits [NoteLoading, NotesLoaded] when search is successful',
      build: () {
        when(
          mockNoteRepository.searchNotes(any as String),
        ).thenAnswer((_) async => Right(testNotes));
        return bloc;
      },
      act: (bloc) => bloc.add(const SearchNotesEvent(query)),
      expect: () => [NoteLoading(), NotesLoaded(testNotes)],
      verify: (_) {
        verify(mockNoteRepository.searchNotes(query));
      },
    );

    blocTest<NoteBloc, NoteState>(
      'emits [NoteLoading, NoteError] when search fails',
      build: () {
        when(
          mockNoteRepository.searchNotes(any as String),
        ).thenAnswer((_) async => const Left(DatabaseFailure('Search failed')));
        return bloc;
      },
      act: (bloc) => bloc.add(const SearchNotesEvent(query)),
      expect: () => [NoteLoading(), const NoteError('Search failed')],
    );
  });

  group('TogglePinNoteEvent', () {
    const testNoteId = '1';
    final pinnedNote = testNote.copyWith(isPinned: true);

    blocTest<NoteBloc, NoteState>(
      'emits [NoteOperationSuccess, NoteLoading, NotesLoaded] when pin is toggled',
      build: () {
        when(
          mockNoteRepository.togglePinNote(any as String),
        ).thenAnswer((_) async => Right(pinnedNote));
        when(
          mockGetAllNotes(any as NoParams),
        ).thenAnswer((_) async => Right(testNotes));
        return bloc;
      },
      act: (bloc) => bloc.add(const TogglePinNoteEvent(testNoteId)),
      expect: () => [
        NoteOperationSuccess('Note pinned', note: pinnedNote),
        NoteLoading(),
        NotesLoaded(testNotes),
      ],
      verify: (_) {
        verify(mockNoteRepository.togglePinNote(testNoteId));
        verify(mockGetAllNotes(NoParams()));
      },
    );
  });

  group('ToggleArchiveNoteEvent', () {
    const testNoteId = '1';
    final archivedNote = testNote.copyWith(isArchived: true);

    blocTest<NoteBloc, NoteState>(
      'emits [NoteOperationSuccess, NoteLoading, NotesLoaded] when archive is toggled',
      build: () {
        when(
          mockNoteRepository.toggleArchiveNote(any as String),
        ).thenAnswer((_) async => Right(archivedNote));
        when(
          mockGetAllNotes(any as NoParams),
        ).thenAnswer((_) async => Right(testNotes));
        return bloc;
      },
      act: (bloc) => bloc.add(const ToggleArchiveNoteEvent(testNoteId)),
      expect: () => [
        NoteOperationSuccess('Note archived', note: archivedNote),
        NoteLoading(),
        NotesLoaded(testNotes),
      ],
      verify: (_) {
        verify(mockNoteRepository.toggleArchiveNote(testNoteId));
        verify(mockGetAllNotes(NoParams()));
      },
    );
  });

  group('LoadPinnedNotes', () {
    blocTest<NoteBloc, NoteState>(
      'emits [NoteLoading, NotesLoaded] when loading pinned notes',
      build: () {
        when(
          mockNoteRepository.getPinnedNotes(),
        ).thenAnswer((_) async => Right(testNotes));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadPinnedNotes()),
      expect: () => [NoteLoading(), NotesLoaded(testNotes)],
      verify: (_) {
        verify(mockNoteRepository.getPinnedNotes());
      },
    );
  });

  group('LoadArchivedNotes', () {
    blocTest<NoteBloc, NoteState>(
      'emits [NoteLoading, NotesLoaded] when loading archived notes',
      build: () {
        when(
          mockNoteRepository.getArchivedNotes(),
        ).thenAnswer((_) async => Right(testNotes));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadArchivedNotes()),
      expect: () => [NoteLoading(), NotesLoaded(testNotes)],
      verify: (_) {
        verify(mockNoteRepository.getArchivedNotes());
      },
    );
  });
}
