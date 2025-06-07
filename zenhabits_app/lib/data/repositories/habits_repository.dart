import 'package:zenhabits_app/core/constants/local_errors.dart';
import 'package:zenhabits_app/core/constants/local_messages.dart';
import 'package:zenhabits_app/core/constants/remote_log_messages.dart';
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
      logger.i(RemoteLogMessages.remoteHabitsFetched(user.name, habits.length));
      await upsertHabits(habits);
    } catch (e) {
      logger.e(RemoteLogMessages.syncRemoteFailed(e));
    }
  }

  Future<void> upsertRemoteHabits(List<HabitModel> habits, UserModel user) async {
    try {
      await remoteDataSource.upsertUserHabits(habits, user);
      logger.i(RemoteLogMessages.remoteUpsertSuccess(habits.length));
    } catch (e) {
      logger.e(RemoteLogMessages.upsertError(e));
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
      logger.i(LocalLogMessages.habitInserted(habit.name, id));
      return id;
    } catch (e) {
      logger.e(LocalErrors.insertHabit(habit.name));
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
      logger.i(LocalLogMessages.habitUpdated(habit.name));
    } catch (e) {
      logger.e(LocalErrors.updateHabit(habit.name));
    }
  }

  Future<List<HabitModel>> getHabitsByUser(int userId) async {
    try {
      final habitEntities = await habitDao.findHabitsByUsuario(userId);
      logger.i(LocalLogMessages.fetchedHabits(userId, habitEntities.length));
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
      logger.e(LocalErrors.fetchHabits(userId, e.toString()));
      rethrow;
    }
  }

  Future<void> deleteHabit(HabitModel habit) async {
    try {
      if (habit.habitId != null) {
        await habitDao.deleteHabitById(habit.habitId!);
        logger.i(LocalLogMessages.habitDeleted(habit.habitId!));
      } else {
        throw Exception(LocalLogMessages.deleteHabit);
      }
    } catch (e) {
      logger.e(LocalErrors.deleteHabit(e.toString()));
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
        logger.w(LocalLogMessages.upsertError(habit.name, e));
      }
    }
  }
}