import 'package:floor/floor.dart';
import 'package:zenhabits_app/data/database/entities/habit_entity.dart';

@dao
abstract class HabitDao {
  @insert
  Future<int> insertHabit(Habit habit);

  @update
  Future<void> updateHabit(Habit habit);

  @Query('SELECT * FROM habits WHERE userid = :userId')
  Future<List<Habit>> findHabitsByUsuario(int userId);

  @Query('SELECT * FROM habits')
  Future<List<Habit>> findAllHabits();
 
  @Query('DELETE FROM habits WHERE habitId = :id')
  Future<void> deleteHabitById(int id);
}