import 'package:zenhabits_app/data/local/model/habit_model.dart';
import 'package:zenhabits_app/data/local/repositories/habits_repository.dart';
import 'package:zenhabits_app/domain/model/habit.dart';

class DeleteHabitUsecase {
  final HabitRepository repository;

  DeleteHabitUsecase ({required this.repository});

  Future<void> call(Habit habit) async {
    try {
      await repository.deleteHabit(habit as HabitModel);
    } catch (e) {
      throw Exception('Error al eliminar el hábito: ${e.toString()}');
    }
  }
}