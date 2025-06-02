import 'package:zenhabits_app/core/utils/logger.dart';
import 'package:zenhabits_app/data/repositories/habits_repository.dart';
import 'package:zenhabits_app/domain/model/habit.dart';

class GetHabitsUseCase {
  final HabitRepository repository;

  GetHabitsUseCase({required this.repository});

  Future<List<Habit>> call(int userId) async {
    try {
      final habits = await repository.getHabitsByUser(userId);
      return habits.map((h) => Habit(
        habitId: h.habitId,
        name: h.name,
        description: h.description,
        frequency: h.frequency,
        completed: h.completed,
        startDate: h.startDate,
        endDate: h.endDate,
        userId: h.userId,
      )).toList();
    } catch (e) {
      logger.e("Error getting user habits");
      throw Exception('Error al obtener los hábitos: ${e.toString()}');
    }
  }
}