import 'package:zenhabits_app/core/utils/logger.dart';
import 'package:zenhabits_app/data/database/dao/habit_dao.dart';
import 'package:zenhabits_app/data/database/entities/habit_entity.dart';
import 'package:zenhabits_app/data/model/habit_model.dart';
import 'package:zenhabits_app/data/model/user_model.dart';
import 'package:zenhabits_app/data/api/remote_habit_datasource.dart';

class HabitRepository {
  final HabitDao habitDao;
  final RemoteHabitsDataSource remoteDataSource;

  HabitRepository({
    required this.habitDao,
    required this.remoteDataSource
  });

  Future<void> syncHabitsFromRemote(UserModel user) async {
    try {
      final habits = await remoteDataSource.fetchUserHabits(user);
      logger.i("Remote habits fetched for user ${user.name}: ${habits.length} habits");
      await upsertHabits(habits);
    } catch (e) {
      logger.e("Failed to sync remote habits: $e");
    }
  }

  Future<void> upsertRemoteHabits(List<HabitModel> habits) async {
    try {
      await remoteDataSource.upsertUserHabits(habits);
      logger.i("Successfully upserted ${habits.length} remote habits");
    } catch (e) {
      logger.e("Failed to upsert remote habits: $e");
    }
  }

  Future<int> insertHabit(HabitModel habit) async {
    try {
      final habitEntity = Habit(
        null,
        habit.name,
        habit.description ?? "",
        habit.frequency,
        habit.completed,
        habit.startDate,
        habit.endDate,
        habit.userId,
      );
      final id = await habitDao.insertHabit(habitEntity);
      logger.i("Habit inserted: ${habit.name} with ID $id");
      return id;
    } catch (e) {
      logger.e("Error inserting habit ${habit.name}: $e");
      rethrow;
    }
  }

  Future<void> updateHabit(HabitModel habit) async {
    try {
      final habitEntity = Habit(
        habit.habitId,
        habit.name,
        habit.description ?? "",
        habit.frequency,
        habit.completed,
        habit.startDate,
        habit.endDate,
        habit.userId,
      );
      await habitDao.updateHabit(habitEntity);
      logger.i("Habit updated: ${habit.name}");
    } catch (e) {
      logger.e("Error updating habit ${habit.name}: $e");
    }
  }

  Future<List<HabitModel>> getHabitsByUser(int userId) async {
    try {
      final habitEntities = await habitDao.findHabitsByUsuario(userId);
      logger.i("Fetched ${habitEntities.length} habits for userId $userId");
      return habitEntities.map((habit) => HabitModel(
        habitId: habit.habitId,
        name: habit.name,
        description: habit.description,
        frequency: habit.frequency,
        completed: habit.completed,
        startDate: habit.startDate,
        endDate: habit.endDate,
        userId: habit.userId,
      )).toList();
    } catch (e) {
      logger.e("Failed to fetch habits for userId $userId: $e");
      rethrow;
    }
  }

  Future<void> deleteHabit(HabitModel habit) async {
    try {
      if (habit.habitId != null) {
        await habitDao.deleteHabitById(habit.habitId!);
        logger.i("Habit deleted with ID ${habit.habitId}");
      } else {
        throw Exception("Habit does not have a valid ID for deletion.");
      }
    } catch (e) {
      logger.e("Error deleting habit ${habit.habitId}: $e");
    }
  }

  Future<void> upsertHabits(List<HabitModel> habits) async {
    for (final habit in habits) {
      try {
        if (habit.habitId != null) {
          await updateHabit(habit);
        } else {
          await insertHabit(habit);
        }
      } catch (e) {
        logger.w("Error during upsert of habit ${habit.name}: $e");
      }
    }
  }
}