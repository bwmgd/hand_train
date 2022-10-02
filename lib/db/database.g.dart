// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
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

  HistoryDao? _historyDaoInstance;

  InfoDao? _infoDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
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
            'CREATE TABLE IF NOT EXISTS `history` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `date` INTEGER NOT NULL, `totalTime` INTEGER NOT NULL, `gestureId` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `history_info` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `history_id` INTEGER NOT NULL, `gestureId` INTEGER NOT NULL, `totalTime` INTEGER NOT NULL, `trainTime` INTEGER NOT NULL, `ratingId` INTEGER NOT NULL, FOREIGN KEY (`history_id`) REFERENCES `history` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  HistoryDao get historyDao {
    return _historyDaoInstance ??= _$HistoryDao(database, changeListener);
  }

  @override
  InfoDao get infoDao {
    return _infoDaoInstance ??= _$InfoDao(database, changeListener);
  }
}

class _$HistoryDao extends HistoryDao {
  _$HistoryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _historyEntityInsertionAdapter = InsertionAdapter(
            database,
            'history',
            (HistoryEntity item) => <String, Object?>{
                  'id': item.id,
                  'date': item.date,
                  'totalTime': item.totalTime,
                  'gestureId': item.gestureId
                }),
        _historyEntityDeletionAdapter = DeletionAdapter(
            database,
            'history',
            ['id'],
            (HistoryEntity item) => <String, Object?>{
                  'id': item.id,
                  'date': item.date,
                  'totalTime': item.totalTime,
                  'gestureId': item.gestureId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<HistoryEntity> _historyEntityInsertionAdapter;

  final DeletionAdapter<HistoryEntity> _historyEntityDeletionAdapter;

  @override
  Future<List<HistoryEntity>> getAllHistory() async {
    return _queryAdapter.queryList('select * from history',
        mapper: (Map<String, Object?> row) => HistoryEntity(
            row['id'] as int?,
            row['date'] as int,
            row['totalTime'] as int,
            row['gestureId'] as int));
  }

  @override
  Future<void> clearHistory() async {
    await _queryAdapter.queryNoReturn('delete from history');
  }

  @override
  Future<int> insertHistory(HistoryEntity history) {
    return _historyEntityInsertionAdapter.insertAndReturnId(
        history, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteHistory(HistoryEntity history) async {
    await _historyEntityDeletionAdapter.delete(history);
  }
}

class _$InfoDao extends InfoDao {
  _$InfoDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _infoEntityInsertionAdapter = InsertionAdapter(
            database,
            'history_info',
            (InfoEntity item) => <String, Object?>{
                  'id': item.id,
                  'history_id': item.historyId,
                  'gestureId': item.gestureId,
                  'totalTime': item.totalTime,
                  'trainTime': item.trainTime,
                  'ratingId': item.ratingId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<InfoEntity> _infoEntityInsertionAdapter;

  @override
  Future<List<InfoEntity>> getAllInfoById(int id) async {
    return _queryAdapter.queryList(
        'select * from history_info where history_id = ?1',
        mapper: (Map<String, Object?> row) => InfoEntity(
            row['id'] as int?,
            row['history_id'] as int,
            row['gestureId'] as int,
            row['totalTime'] as int,
            row['trainTime'] as int,
            row['ratingId'] as int),
        arguments: [id]);
  }

  @override
  Future<void> deleteAllInfoById(int id) async {
    await _queryAdapter.queryNoReturn(
        'delete from history_info WHERE history_id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> clearInfo() async {
    await _queryAdapter.queryNoReturn('delete from history_info');
  }

  @override
  Future<void> insertInfo(List<InfoEntity> historyInfoList) async {
    await _infoEntityInsertionAdapter.insertList(
        historyInfoList, OnConflictStrategy.abort);
  }
}
