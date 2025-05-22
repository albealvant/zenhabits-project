import 'package:zenhabits_app/data/local/model/habit_model.dart';
import 'package:zenhabits_app/data/local/repositories/habits_repository.dart';
import 'package:zenhabits_app/domain/model/habit.dart';

class InsertHabitUseCase {
  final HabitRepository repository;

  InsertHabitUseCase({required this.repository});

  Future<void> call(Habit habit) async {
    try {
      await repository.insertHabit(habit as HabitModel);
    } catch (e) {
      throw Exception('Error al insertar el hábito: ${e.toString()}');
    }
  }
}