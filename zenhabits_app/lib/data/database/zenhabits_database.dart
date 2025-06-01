import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:zenhabits_app/data/converters/datetime_converter.dart';
import 'dao/user_dao.dart';
import 'dao/habit_dao.dart';
import 'entities/user_entity.dart';
import 'entities/habit_entity.dart';

part 'zenhabits_database.g.dart';

@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [User, Habit])
abstract class ZenhabitsDatabase extends FloorDatabase {
  UserDao get userDao;
  HabitDao get habitDao;
}