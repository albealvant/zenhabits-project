import 'package:floor/floor.dart';
import 'package:zenhabits_app/data/local/database/entities/habit_entity.dart';

@dao
abstract class HabitDao {
  @insert
  Future<int> insertHabit(Habit habit);

  @update
  Future<void> updateHabit(Habit habit);

  @Query('SELECT * FROM habitos WHERE idUsuario = :userId')
  Future<List<Habit>> findHabitsByUsuario(int userId);

  @Query('SELECT * FROM habitos')
  Future<List<Habit>> findAllHabits();

  @delete
  Future<void> deleteHabit(Habit habit);
}