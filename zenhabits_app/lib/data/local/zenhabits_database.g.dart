// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zenhabits_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $ZenhabitsDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $ZenhabitsDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $ZenhabitsDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<ZenhabitsDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorZenhabitsDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $ZenhabitsDatabaseBuilderContract databaseBuilder(String name) =>
      _$ZenhabitsDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $ZenhabitsDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$ZenhabitsDatabaseBuilder(null);
}

class _$ZenhabitsDatabaseBuilder implements $ZenhabitsDatabaseBuilderContract {
  _$ZenhabitsDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $ZenhabitsDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $ZenhabitsDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<ZenhabitsDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$ZenhabitsDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$ZenhabitsDatabase extends ZenhabitsDatabase {
  _$ZenhabitsDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao? _userDaoInstance;

  HabitDao? _habitDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `users` (`userId` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `email` TEXT NOT NULL, `passwordHash` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `habits` (`habitId` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT, `frequency` TEXT NOT NULL, `completed` INTEGER NOT NULL, `startDate` INTEGER NOT NULL, `endDate` INTEGER NOT NULL, `userId` INTEGER NOT NULL, FOREIGN KEY (`userId`) REFERENCES `users` (`userId`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE UNIQUE INDEX `index_users_name` ON `users` (`name`)');
        await database.execute(
            'CREATE UNIQUE INDEX `index_users_email` ON `users` (`email`)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  HabitDao get habitDao {
    return _habitDaoInstance ??= _$HabitDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'users',
            (User item) => <String, Object?>{
                  'userId': item.userId,
                  'name': item.name,
                  'email': item.email,
                  'passwordHash': item.passwordHash
                }),
        _userUpdateAdapter = UpdateAdapter(
            database,
            'users',
            ['userId'],
            (User item) => <String, Object?>{
                  'userId': item.userId,
                  'name': item.name,
                  'email': item.email,
                  'passwordHash': item.passwordHash
                }),
        _userDeletionAdapter = DeletionAdapter(
            database,
            'users',
            ['userId'],
            (User item) => <String, Object?>{
                  'userId': item.userId,
                  'name': item.name,
                  'email': item.email,
                  'passwordHash': item.passwordHash
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  final UpdateAdapter<User> _userUpdateAdapter;

  final DeletionAdapter<User> _userDeletionAdapter;

  @override
  Future<User?> findUserById(int id) async {
    return _queryAdapter.query(
        'SELECT username FROM usuarios WHERE idUsuario = ?1',
        mapper: (Map<String, Object?> row) => User(
            row['userId'] as int?,
            row['name'] as String,
            row['email'] as String,
            row['passwordHash'] as String),
        arguments: [id]);
  }

  @override
  Future<List<User>> findAllUsers() async {
    return _queryAdapter.queryList('SELECT username FROM usuarios',
        mapper: (Map<String, Object?> row) => User(
            row['userId'] as int?,
            row['name'] as String,
            row['email'] as String,
            row['passwordHash'] as String));
  }

  @override
  Future<void> insertUser(User user) async {
    await _userInsertionAdapter.insert(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUsuario(User user) async {
    await _userUpdateAdapter.update(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteUser(User user) async {
    await _userDeletionAdapter.delete(user);
  }
}

class _$HabitDao extends HabitDao {
  _$HabitDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _habitInsertionAdapter = InsertionAdapter(
            database,
            'habits',
            (Habit item) => <String, Object?>{
                  'habitId': item.habitId,
                  'name': item.name,
                  'description': item.description,
                  'frequency': item.frequency,
                  'completed': item.completed ? 1 : 0,
                  'startDate': _dateTimeConverter.encode(item.startDate),
                  'endDate': _dateTimeConverter.encode(item.endDate),
                  'userId': item.userId
                }),
        _habitUpdateAdapter = UpdateAdapter(
            database,
            'habits',
            ['habitId'],
            (Habit item) => <String, Object?>{
                  'habitId': item.habitId,
                  'name': item.name,
                  'description': item.description,
                  'frequency': item.frequency,
                  'completed': item.completed ? 1 : 0,
                  'startDate': _dateTimeConverter.encode(item.startDate),
                  'endDate': _dateTimeConverter.encode(item.endDate),
                  'userId': item.userId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Habit> _habitInsertionAdapter;

  final UpdateAdapter<Habit> _habitUpdateAdapter;

  @override
  Future<List<Habit>> findHabitsByUsuario(int userId) async {
    return _queryAdapter.queryList('SELECT * FROM habits WHERE userid = ?1',
        mapper: (Map<String, Object?> row) => Habit(
            row['habitId'] as int?,
            row['name'] as String,
            row['description'] as String?,
            row['frequency'] as String,
            (row['completed'] as int) != 0,
            _dateTimeConverter.decode(row['startDate'] as int),
            _dateTimeConverter.decode(row['endDate'] as int),
            row['userId'] as int),
        arguments: [userId]);
  }

  @override
  Future<List<Habit>> findAllHabits() async {
    return _queryAdapter.queryList('SELECT * FROM habits',
        mapper: (Map<String, Object?> row) => Habit(
            row['habitId'] as int?,
            row['name'] as String,
            row['description'] as String?,
            row['frequency'] as String,
            (row['completed'] as int) != 0,
            _dateTimeConverter.decode(row['startDate'] as int),
            _dateTimeConverter.decode(row['endDate'] as int),
            row['userId'] as int));
  }

  @override
  Future<void> deleteHabitById(int id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM habits WHERE habitId = ?1',
        arguments: [id]);
  }

  @override
  Future<int> insertHabit(Habit habit) {
    return _habitInsertionAdapter.insertAndReturnId(
        habit, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    await _habitUpdateAdapter.update(habit, OnConflictStrategy.abort);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
