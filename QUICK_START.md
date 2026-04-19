# Quick Start Guide - Smart Note AI App

## Prerequisites

- Flutter SDK 3.10.7 or higher
- Dart SDK 3.10.7 or higher
- Android Studio / VS Code with Flutter extensions
- iOS: Xcode (for iOS development)
- Android: Android SDK

## Installation

### 1. Clone or Navigate to Project
```bash
cd smart_note
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Generate Database Code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate:
- `lib/data/datasources/local/database/app_database.g.dart`

### 4. Run the App
```bash
# Run on connected device/emulator
flutter run

# Run on specific device
flutter devices  # List available devices
flutter run -d <device-id>

# Run in debug mode
flutter run --debug

# Run in release mode
flutter run --release
```

## Project Structure Quick Reference

```
lib/
├── main.dart                      # App entry point
├── injection_container.dart       # Dependency injection setup
├── core/                          # Core utilities
├── domain/                        # Business logic (entities, use cases)
├── data/                          # Data layer (models, repositories, database)
└── presentation/                  # UI (BLoC, pages, widgets)
```

## Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/domain/entities/note_test.dart

# Run with coverage
flutter test --coverage

# View coverage report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Common Commands

### Development
```bash
# Hot reload (r in terminal while app is running)
# Hot restart (R in terminal while app is running)

# Clean build
flutter clean
flutter pub get

# Check for issues
flutter doctor
flutter analyze

# Format code
flutter format lib/

# Update dependencies
flutter pub upgrade
```

### Building

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Check app size
flutter build apk --analyze-size
```

## Troubleshooting

### Issue: Build runner fails
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: Database not found
Make sure you've run the build_runner command to generate database code.

### Issue: Dependencies conflict
```bash
flutter pub upgrade --major-versions
```

### Issue: iOS build fails
```bash
cd ios
pod install
cd ..
flutter clean
flutter run
```

## Development Workflow

### 1. Create a New Feature

#### Step 1: Define Entity (Domain Layer)
```dart
// lib/domain/entities/my_entity.dart
class MyEntity extends Equatable {
  final String id;
  final String name;
  
  const MyEntity({required this.id, required this.name});
  
  @override
  List<Object> get props => [id, name];
}
```

#### Step 2: Create Repository Interface (Domain Layer)
```dart
// lib/domain/repositories/my_repository.dart
abstract class MyRepository {
  Future<Either<Failure, MyEntity>> getEntity(String id);
}
```

#### Step 3: Create Use Case (Domain Layer)
```dart
// lib/domain/usecases/get_my_entity.dart
class GetMyEntity implements UseCase<MyEntity, String> {
  final MyRepository repository;
  
  GetMyEntity(this.repository);
  
  @override
  Future<Either<Failure, MyEntity>> call(String id) {
    return repository.getEntity(id);
  }
}
```

#### Step 4: Create Model (Data Layer)
```dart
// lib/data/models/my_model.dart
@Entity(tableName: 'my_table')
class MyModel {
  @PrimaryKey()
  final String id;
  final String name;
  
  const MyModel({required this.id, required this.name});
  
  factory MyModel.fromEntity(MyEntity entity) {
    return MyModel(id: entity.id, name: entity.name);
  }
  
  MyEntity toEntity() {
    return MyEntity(id: id, name: name);
  }
}
```

#### Step 5: Create DAO (Data Layer)
```dart
// lib/data/datasources/local/daos/my_dao.dart
@dao
abstract class MyDao {
  @Query('SELECT * FROM my_table WHERE id = :id')
  Future<MyModel?> getById(String id);
  
  @insert
  Future<void> insert(MyModel model);
}
```

#### Step 6: Implement Repository (Data Layer)
```dart
// lib/data/repositories/my_repository_impl.dart
class MyRepositoryImpl implements MyRepository {
  final MyDao dao;
  
  MyRepositoryImpl({required this.dao});
  
  @override
  Future<Either<Failure, MyEntity>> getEntity(String id) async {
    try {
      final model = await dao.getById(id);
      if (model == null) {
        return Left(DatabaseFailure('Not found'));
      }
      return Right(model.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
```

#### Step 7: Create BLoC (Presentation Layer)
```dart
// lib/presentation/bloc/my/my_bloc.dart
class MyBloc extends Bloc<MyEvent, MyState> {
  final GetMyEntity getMyEntity;
  
  MyBloc({required this.getMyEntity}) : super(MyInitial()) {
    on<LoadMyEntity>(_onLoad);
  }
  
  Future<void> _onLoad(LoadMyEntity event, Emitter<MyState> emit) async {
    emit(MyLoading());
    final result = await getMyEntity(event.id);
    result.fold(
      (failure) => emit(MyError(failure.message)),
      (entity) => emit(MyLoaded(entity)),
    );
  }
}
```

#### Step 8: Register Dependencies
```dart
// lib/injection_container.dart
// Add to init() function:
sl.registerFactory(() => MyBloc(getMyEntity: sl()));
sl.registerLazySingleton(() => GetMyEntity(sl()));
sl.registerLazySingleton<MyRepository>(() => MyRepositoryImpl(dao: sl()));
sl.registerLazySingleton(() => database.myDao);
```

#### Step 9: Create UI
```dart
// lib/presentation/pages/my_page.dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MyBloc>()..add(LoadMyEntity('id')),
      child: BlocBuilder<MyBloc, MyState>(
        builder: (context, state) {
          if (state is MyLoading) {
            return CircularProgressIndicator();
          } else if (state is MyLoaded) {
            return Text(state.entity.name);
          } else if (state is MyError) {
            return Text(state.message);
          }
          return Container();
        },
      ),
    );
  }
}
```

#### Step 10: Write Tests
```dart
// test/domain/usecases/get_my_entity_test.dart
void main() {
  late GetMyEntity usecase;
  late MockMyRepository mockRepository;
  
  setUp(() {
    mockRepository = MockMyRepository();
    usecase = GetMyEntity(mockRepository);
  });
  
  test('should get entity from repository', () async {
    // arrange
    final entity = MyEntity(id: '1', name: 'Test');
    when(mockRepository.getEntity(any))
        .thenAnswer((_) async => Right(entity));
    
    // act
    final result = await usecase('1');
    
    // assert
    expect(result, Right(entity));
    verify(mockRepository.getEntity('1'));
  });
}
```

## Best Practices

1. **Always write tests** for new features
2. **Follow clean architecture** layers strictly
3. **Use BLoC pattern** for state management
4. **Handle errors** with Either type
5. **Keep entities immutable** with copyWith
6. **Use dependency injection** for all dependencies
7. **Format code** before committing
8. **Run tests** before pushing

## Useful Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [BLoC Library](https://bloclibrary.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Floor Documentation](https://pinchbv.github.io/floor/)
- [Dartz (Functional Programming)](https://pub.dev/packages/dartz)

## Getting Help

1. Check the `IMPLEMENTATION_SUMMARY.md` for architecture details
2. Review existing code for patterns
3. Check test files for usage examples
4. Read inline code documentation

## Next Steps

1. ✅ Set up project
2. ✅ Run tests to verify setup
3. 🚀 Start implementing features
4. 📝 Write tests for new features
5. 🎨 Customize UI
6. 🔧 Add AI integration
7. 🎤 Implement voice features
8. ⏰ Add reminders
9. 🚀 Deploy to stores

Happy coding! 🎉
