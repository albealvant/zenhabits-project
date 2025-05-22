import 'package:zenhabits_app/data/local/model/habit_model.dart';
import 'package:zenhabits_app/data/local/repositories/habits_repository.dart';
import 'package:zenhabits_app/domain/model/habit.dart';

class GetHabitsUseCase {
  final HabitRepository repository;

  GetHabitsUseCase({required this.repository});

  Future<List<HabitModel>> call(int userId) async { //FIXME: Deberia devolver Habit de daomain, hacer merge de data-local-layer para poder corregirlo
    try {
      final habits = await repository.getHabitsByUser(userId);
      return habits; 
    } catch (e) {
      throw Exception('Error al obtener los hábitos: ${e.toString()}');
    }
  }
}