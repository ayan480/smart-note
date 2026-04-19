// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  NoteDao? _noteDaoInstance;

  ReminderDao? _reminderDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `notes` (`id` TEXT NOT NULL, `title` TEXT NOT NULL, `content` TEXT NOT NULL, `createdAt` INTEGER NOT NULL, `updatedAt` INTEGER NOT NULL, `backgroundColor` TEXT, `backgroundImagePath` TEXT, `attachmentIds` TEXT NOT NULL, `reminderId` TEXT, `isPinned` INTEGER NOT NULL, `isArchived` INTEGER NOT NULL, `tags` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `reminders` (`id` TEXT NOT NULL, `noteId` TEXT NOT NULL, `reminderTime` INTEGER NOT NULL, `priority` TEXT NOT NULL, `interval` TEXT NOT NULL, `isCompleted` INTEGER NOT NULL, `createdAt` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  NoteDao get noteDao {
    return _noteDaoInstance ??= _$NoteDao(database, changeListener);
  }

  @override
  ReminderDao get reminderDao {
    return _reminderDaoInstance ??= _$ReminderDao(database, changeListener);
  }
}

class _$NoteDao extends NoteDao {
  _$NoteDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _noteModelInsertionAdapter = InsertionAdapter(
            database,
            'notes',
            (NoteModel item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'content': item.content,
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt,
                  'backgroundColor': item.backgroundColor,
                  'backgroundImagePath': item.backgroundImagePath,
                  'attachmentIds': item.attachmentIds,
                  'reminderId': item.reminderId,
                  'isPinned': item.isPinned,
                  'isArchived': item.isArchived,
                  'tags': item.tags
                }),
        _noteModelUpdateAdapter = UpdateAdapter(
            database,
            'notes',
            ['id'],
            (NoteModel item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'content': item.content,
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt,
                  'backgroundColor': item.backgroundColor,
                  'backgroundImagePath': item.backgroundImagePath,
                  'attachmentIds': item.attachmentIds,
                  'reminderId': item.reminderId,
                  'isPinned': item.isPinned,
                  'isArchived': item.isArchived,
                  'tags': item.tags
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<NoteModel> _noteModelInsertionAdapter;

  final UpdateAdapter<NoteModel> _noteModelUpdateAdapter;

  @override
  Future<List<NoteModel>> getAllNotes() async {
    return _queryAdapter.queryList(
        'SELECT * FROM notes WHERE isArchived = 0 ORDER BY isPinned DESC, updatedAt DESC',
        mapper: (Map<String, Object?> row) => NoteModel(
            id: row['id'] as String,
            title: row['title'] as String,
            content: row['content'] as String,
            createdAt: row['createdAt'] as int,
            updatedAt: row['updatedAt'] as int,
            backgroundColor: row['backgroundColor'] as String?,
            backgroundImagePath: row['backgroundImagePath'] as String?,
            attachmentIds: row['attachmentIds'] as String,
            reminderId: row['reminderId'] as String?,
            isPinned: row['isPinned'] as int,
            isArchived: row['isArchived'] as int,
            tags: row['tags'] as String));
  }

  @override
  Future<NoteModel?> getNoteById(String id) async {
    return _queryAdapter.query('SELECT * FROM notes WHERE id = ?1',
        mapper: (Map<String, Object?> row) => NoteModel(
            id: row['id'] as String,
            title: row['title'] as String,
            content: row['content'] as String,
            createdAt: row['createdAt'] as int,
            updatedAt: row['updatedAt'] as int,
            backgroundColor: row['backgroundColor'] as String?,
            backgroundImagePath: row['backgroundImagePath'] as String?,
            attachmentIds: row['attachmentIds'] as String,
            reminderId: row['reminderId'] as String?,
            isPinned: row['isPinned'] as int,
            isArchived: row['isArchived'] as int,
            tags: row['tags'] as String),
        arguments: [id]);
  }

  @override
  Future<List<NoteModel>> getPinnedNotes() async {
    return _queryAdapter.queryList(
        'SELECT * FROM notes WHERE isPinned = 1 AND isArchived = 0 ORDER BY updatedAt DESC',
        mapper: (Map<String, Object?> row) => NoteModel(
            id: row['id'] as String,
            title: row['title'] as String,
            content: row['content'] as String,
            createdAt: row['createdAt'] as int,
            updatedAt: row['updatedAt'] as int,
            backgroundColor: row['backgroundColor'] as String?,
            backgroundImagePath: row['backgroundImagePath'] as String?,
            attachmentIds: row['attachmentIds'] as String,
            reminderId: row['reminderId'] as String?,
            isPinned: row['isPinned'] as int,
            isArchived: row['isArchived'] as int,
            tags: row['tags'] as String));
  }

  @override
  Future<List<NoteModel>> getArchivedNotes() async {
    return _queryAdapter.queryList(
        'SELECT * FROM notes WHERE isArchived = 1 ORDER BY updatedAt DESC',
        mapper: (Map<String, Object?> row) => NoteModel(
            id: row['id'] as String,
            title: row['title'] as String,
            content: row['content'] as String,
            createdAt: row['createdAt'] as int,
            updatedAt: row['updatedAt'] as int,
            backgroundColor: row['backgroundColor'] as String?,
            backgroundImagePath: row['backgroundImagePath'] as String?,
            attachmentIds: row['attachmentIds'] as String,
            reminderId: row['reminderId'] as String?,
            isPinned: row['isPinned'] as int,
            isArchived: row['isArchived'] as int,
            tags: row['tags'] as String));
  }

  @override
  Future<List<NoteModel>> searchNotes(String query) async {
    return _queryAdapter.queryList(
        'SELECT * FROM notes WHERE (title LIKE ?1 OR content LIKE ?1) AND isArchived = 0',
        mapper: (Map<String, Object?> row) => NoteModel(id: row['id'] as String, title: row['title'] as String, content: row['content'] as String, createdAt: row['createdAt'] as int, updatedAt: row['updatedAt'] as int, backgroundColor: row['backgroundColor'] as String?, backgroundImagePath: row['backgroundImagePath'] as String?, attachmentIds: row['attachmentIds'] as String, reminderId: row['reminderId'] as String?, isPinned: row['isPinned'] as int, isArchived: row['isArchived'] as int, tags: row['tags'] as String),
        arguments: [query]);
  }

  @override
  Future<void> deleteNote(String id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM notes WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> deleteAllNotes() async {
    await _queryAdapter.queryNoReturn('DELETE FROM notes');
  }

  @override
  Future<void> insertNote(NoteModel note) async {
    await _noteModelInsertionAdapter.insert(note, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    await _noteModelUpdateAdapter.update(note, OnConflictStrategy.abort);
  }
}

class _$ReminderDao extends ReminderDao {
  _$ReminderDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _reminderModelInsertionAdapter = InsertionAdapter(
            database,
            'reminders',
            (ReminderModel item) => <String, Object?>{
                  'id': item.id,
                  'noteId': item.noteId,
                  'reminderTime': item.reminderTime,
                  'priority': item.priority,
                  'interval': item.interval,
                  'isCompleted': item.isCompleted,
                  'createdAt': item.createdAt
                }),
        _reminderModelUpdateAdapter = UpdateAdapter(
            database,
            'reminders',
            ['id'],
            (ReminderModel item) => <String, Object?>{
                  'id': item.id,
                  'noteId': item.noteId,
                  'reminderTime': item.reminderTime,
                  'priority': item.priority,
                  'interval': item.interval,
                  'isCompleted': item.isCompleted,
                  'createdAt': item.createdAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ReminderModel> _reminderModelInsertionAdapter;

  final UpdateAdapter<ReminderModel> _reminderModelUpdateAdapter;

  @override
  Future<List<ReminderModel>> getAllReminders() async {
    return _queryAdapter.queryList(
        'SELECT * FROM reminders ORDER BY reminderTime ASC',
        mapper: (Map<String, Object?> row) => ReminderModel(
            id: row['id'] as String,
            noteId: row['noteId'] as String,
            reminderTime: row['reminderTime'] as int,
            priority: row['priority'] as String,
            interval: row['interval'] as String,
            isCompleted: row['isCompleted'] as int,
            createdAt: row['createdAt'] as int));
  }

  @override
  Future<ReminderModel?> getReminderById(String id) async {
    return _queryAdapter.query('SELECT * FROM reminders WHERE id = ?1',
        mapper: (Map<String, Object?> row) => ReminderModel(
            id: row['id'] as String,
            noteId: row['noteId'] as String,
            reminderTime: row['reminderTime'] as int,
            priority: row['priority'] as String,
            interval: row['interval'] as String,
            isCompleted: row['isCompleted'] as int,
            createdAt: row['createdAt'] as int),
        arguments: [id]);
  }

  @override
  Future<ReminderModel?> getReminderByNoteId(String noteId) async {
    return _queryAdapter.query('SELECT * FROM reminders WHERE noteId = ?1',
        mapper: (Map<String, Object?> row) => ReminderModel(
            id: row['id'] as String,
            noteId: row['noteId'] as String,
            reminderTime: row['reminderTime'] as int,
            priority: row['priority'] as String,
            interval: row['interval'] as String,
            isCompleted: row['isCompleted'] as int,
            createdAt: row['createdAt'] as int),
        arguments: [noteId]);
  }

  @override
  Future<List<ReminderModel>> getPendingReminders() async {
    return _queryAdapter.queryList(
        'SELECT * FROM reminders WHERE isCompleted = 0 ORDER BY reminderTime ASC',
        mapper: (Map<String, Object?> row) => ReminderModel(
            id: row['id'] as String,
            noteId: row['noteId'] as String,
            reminderTime: row['reminderTime'] as int,
            priority: row['priority'] as String,
            interval: row['interval'] as String,
            isCompleted: row['isCompleted'] as int,
            createdAt: row['createdAt'] as int));
  }

  @override
  Future<void> deleteReminder(String id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM reminders WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> deleteRemindersByNoteId(String noteId) async {
    await _queryAdapter.queryNoReturn('DELETE FROM reminders WHERE noteId = ?1',
        arguments: [noteId]);
  }

  @override
  Future<void> insertReminder(ReminderModel reminder) async {
    await _reminderModelInsertionAdapter.insert(
        reminder, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateReminder(ReminderModel reminder) async {
    await _reminderModelUpdateAdapter.update(
        reminder, OnConflictStrategy.abort);
  }
}
