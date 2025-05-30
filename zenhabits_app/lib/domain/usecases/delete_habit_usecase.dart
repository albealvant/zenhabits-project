import 'package:zenhabits_app/data/local/model/habit_model.dart';
import 'package:zenhabits_app/data/local/repositories/habits_repository.dart';
import 'package:zenhabits_app/domain/model/habit.dart';

class DeleteHabitUsecase {
  final HabitRepository repository;

  DeleteHabitUsecase ({required this.repository});

    HabitModel _toHabitModel(Habit habit) {
      return HabitModel(
        habitId: habit.habitId,
        name: habit.name,
        description: habit.description,
        frequency: habit.frequency,
        completed: habit.completed,
        startDate: habit.startDate,
        endDate: habit.endDate,
        userId: habit.userId,
      );
    }

  Future<void> call(Habit habit) async {
    try {
      final habitModel = _toHabitModel(habit);
      await repository.deleteHabit(habitModel);
    } catch (e) {
      throw Exception('Error al eliminar el hábito: ${e.toString()}');
    }
  }
}