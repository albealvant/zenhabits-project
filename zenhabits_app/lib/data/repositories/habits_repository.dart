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
    final habits = await remoteDataSource.fetchUserHabits(user);
    await upsertHabits(habits);
  }

  Future<void> upsertRemoteHabits(List<HabitModel> habits) async {
    await remoteDataSource.upsertUserHabits(habits);
  }

  Future<int> insertHabit(HabitModel habit) async {
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
    return await habitDao.insertHabit(habitEntity);
  }

  Future<void> updateHabit(HabitModel habit) async {
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
  }

  Future<List<HabitModel>> getHabitsByUser(int userId) async {
    final habitEntities = await habitDao.findHabitsByUsuario(userId);
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
  }

  Future<void> deleteHabit(HabitModel habit) async {
    if (habit.habitId != null) {
      await habitDao.deleteHabitById(habit.habitId!);
    } else {
      throw Exception("El hábito no tiene un ID válido para eliminarse.");
    }
  }

  Future<void> upsertHabits(List<HabitModel> habits) async {
    for (final habit in habits) {
      if (habit.habitId != null) {
        await updateHabit(habit);
      } else {
        await insertHabit(habit);
      }
    }
  }
}