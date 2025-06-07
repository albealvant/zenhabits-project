import 'package:zenhabits_app/core/utils/logger.dart';
import 'package:zenhabits_app/data/model/habit_model.dart';
import 'package:zenhabits_app/data/model/user_model.dart';
import 'package:zenhabits_app/data/repositories/habits_repository.dart';
import 'package:zenhabits_app/domain/model/habit.dart';
import 'package:zenhabits_app/domain/model/user.dart';

class InsertHabitUseCase {
  final HabitRepository repository;

  InsertHabitUseCase({required this.repository});
  
  HabitModel _toHabitModel(Habit habit) {
    return HabitModel(
      habitId: null,
      name: habit.name,
      description: habit.description,
      frequency: habit.frequency,
      completed: habit.completed,
      startDate: habit.startDate,
      endDate: habit.endDate,
      userId: habit.userId,
    );
  }

  UserModel _toUserModel(User user) {
    return UserModel(
      userId: user.userId,
      name: user.name,
      email: user.email,
      passwordHash: user.password,
    );
  }

  Future<int> call(Habit habit, User currentUser) async {
    try {
      final habitModel = _toHabitModel(habit);
      final result = await repository.insertHabit(habitModel);
      logger.i("Habit created successfully");
      try {
        final habitsList = await repository.getHabitsByUser(habit.userId);
        await repository.upsertRemoteHabits(habitsList, _toUserModel(currentUser));
        logger.i("Habit upserted successfully");
      } catch (ex) {
        logger.e("Error upserting remote habit: $ex");
      }
      return result;
    } catch (e) {
      logger.e("Error inserting habit");
      throw Exception('Error al insertar el hábito: ${e.toString()}');
    }
  }
}