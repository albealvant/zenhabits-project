import 'package:zenhabits_app/core/constants/local_errors.dart';
import 'package:zenhabits_app/core/constants/local_messages.dart';
import 'package:zenhabits_app/core/utils/logger.dart';
import 'package:zenhabits_app/data/model/habit_model.dart';
import 'package:zenhabits_app/data/model/user_model.dart';
import 'package:zenhabits_app/data/repositories/habits_repository.dart';
import 'package:zenhabits_app/domain/model/habit.dart';
import 'package:zenhabits_app/domain/model/user.dart';

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

  UserModel _toUserModel(User user) {
    return UserModel(
      userId: user.userId,
      name: user.name,
      email: user.email,
      passwordHash: user.password,
    );
  }

  Future<void> call(Habit habit, User user) async {
    try {
      final habitModel = _toHabitModel(habit);
      await repository.updateHabit(habitModel);
      final habitsList = await repository.getHabitsByUser(habit.userId);
      logger.i(LocalLogMessages.habitUpdated(habit.name));
      try { //Para sincronizar la lista actualizada con el servidor de forma asíncrona y no bloqueante
        Future(() => repository.upsertRemoteHabits(habitsList, _toUserModel(user)));
      } catch (ex) {
        logger.e("Error sync with the server");
        throw Exception('Error al sincronizar con el servidor: ${ex.toString()}');
      }
    } catch (e) {
      logger.e(LocalErrors.updateHabit(habit.name));
      throw Exception(LocalErrors.updateHabit(habit.name) + e.toString());
    }
  }
}