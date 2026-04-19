# Smart Note App - Test Suite

This directory contains comprehensive unit tests for the Smart Note application following BLoC pattern and clean architecture.

## Test Structure

```
test/
├── core/
│   ├── error/
│   │   └── failures_test.dart          # Tests for failure classes
│   └── usecases/
│       └── usecase_test.dart           # Tests for base use case
├── domain/
│   ├── entities/
│   │   ├── note_test.dart              # Tests for Note entity
│   │   ├── reminder_test.dart          # Tests for Reminder entity
│   │   └── ai_suggestion_test.dart     # Tests for AISuggestion entity
│   └── usecases/
│       └── note/
│           ├── create_note_test.dart   # Tests for CreateNote use case
│           ├── get_all_notes_test.dart # Tests for GetAllNotes use case
│           ├── update_note_test.dart   # Tests for UpdateNote use case
│           └── delete_note_test.dart   # Tests for DeleteNote use case
├── data/
│   ├── models/
│   │   ├── note_model_test.dart        # Tests for NoteModel
│   │   └── reminder_model_test.dart    # Tests for ReminderModel
│   └── repositories/
│       └── note_repository_impl_test.dart # Tests for NoteRepositoryImpl
├── presentation/
│   ├── bloc/
│   │   └── note_bloc_test.dart         # Tests for NoteBloc
│   └── widgets/
│       └── note_card_test.dart         # Tests for NoteCard widget
└── helpers/
    └── test_helper.dart                # Test helper utilities
```

## Running Tests

### Run all tests
```bash
flutter test
```

### Run tests with coverage
```bash
flutter test --coverage
```

### Run specific test file
```bash
flutter test test/domain/entities/note_test.dart
```

### Run tests in a directory
```bash
flutter test test/domain/
```

### Generate coverage report (requires lcov)
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Test Coverage

The test suite covers:

### Domain Layer (100% coverage target)
- ✅ Entities (Note, Reminder, AISuggestion, Attachment)
- ✅ Use Cases (Create, Read, Update, Delete operations)
- ✅ Repository Interfaces

### Data Layer (100% coverage target)
- ✅ Models (NoteModel, ReminderModel)
- ✅ Repository Implementations
- ✅ Data source operations

### Presentation Layer (100% coverage target)
- ✅ BLoC (Events, States, Business Logic)
- ✅ Widgets (NoteCard)

### Core Layer (100% coverage target)
- ✅ Failures
- ✅ Use Cases base class

## Test Dependencies

- `flutter_test`: Flutter testing framework
- `mockito`: Mocking library for unit tests
- `bloc_test`: Testing utilities for BLoC
- `build_runner`: Code generation for mocks

## Generating Mocks

Before running tests, generate mock classes:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Test Conventions

1. **Naming**: Test files should end with `_test.dart`
2. **Structure**: Use `group()` to organize related tests
3. **AAA Pattern**: Arrange, Act, Assert
4. **Mocking**: Use Mockito for mocking dependencies
5. **BLoC Testing**: Use `bloc_test` package for BLoC tests

## Example Test

```dart
test('should create a note through the repository', () async {
  // Arrange
  when(mockNoteRepository.createNote(any))
      .thenAnswer((_) async => Right(testNote));

  // Act
  final result = await usecase(CreateNoteParams(note: testNote));

  // Assert
  expect(result, Right(testNote));
  verify(mockNoteRepository.createNote(testNote));
  verifyNoMoreInteractions(mockNoteRepository);
});
```

## Continuous Integration

Tests should be run automatically on:
- Every commit
- Pull requests
- Before deployment

## Future Test Additions

- Integration tests for complete user flows
- Widget tests for all pages
- Golden tests for UI consistency
- Performance tests
- E2E tests using Flutter Driver or Patrol
