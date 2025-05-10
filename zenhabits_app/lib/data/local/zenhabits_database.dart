import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import '../local/database/dao/user_dao.dart';
import '../local/database/dao/habit_dao.dart';
import '../local/database/entities/user_entity.dart';
import '../local/database/entities/habit_entity.dart';

part 'zenhabits_database.g.dart';

@Database(version: 1, entities: [User, Habit])
abstract class ZenhabitsDatabase extends FloorDatabase {
  UserDao get userDao;
  HabitDao get habitDao;
}