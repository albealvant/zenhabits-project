import 'package:zenhabits_app/core/utils/logger.dart';
import 'package:zenhabits_app/data/model/habit_model.dart';
import 'package:zenhabits_app/data/repositories/habits_repository.dart';
import 'package:zenhabits_app/domain/model/habit.dart';

class UpdateHabitUseCase {
  final HabitRepository repository;

  UpdateHabitUseCase({required this.repository});
  
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
      await repository.updateHabit(habitModel);
      final habitsList = await repository.getHabitsByUser(habit.userId);
      logger.i("Habit successfully updated");
      try { //Para sincronizar la lista actualizada con el servidor de forma asíncrona y no bloqueante
        Future(() => repository.upsertRemoteHabits(habitsList));
      } catch (ex) {
        logger.e("Error sync with the server");
        throw Exception('Error al sincronizar con el servidor: ${ex.toString()}');
      }
    } catch (e) {
      logger.e("Error updating habit");
      throw Exception('Error al actualizar el hábito: ${e.toString()}');
    }
  }
}