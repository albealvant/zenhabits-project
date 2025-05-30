import 'package:zenhabits_app/data/local/database/dao/habit_dao.dart';
import 'package:zenhabits_app/data/local/database/entities/habit_entity.dart';
import 'package:zenhabits_app/data/local/model/habit_model.dart';

class HabitRepository {
  final HabitDao habitDao;

  HabitRepository({required this.habitDao});

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
}
