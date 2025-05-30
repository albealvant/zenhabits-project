import 'package:zenhabits_app/data/local/model/habit_model.dart';
import 'package:zenhabits_app/data/local/repositories/habits_repository.dart';
import 'package:zenhabits_app/domain/model/habit.dart';

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

  Future<int> call(Habit habit) async {
    try {
      final habitModel = _toHabitModel(habit);
      return await repository.insertHabit(habitModel);
    } catch (e) {
      throw Exception('Error al insertar el hábito: ${e.toString()}');
    }
  }
}