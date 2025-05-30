import 'package:flutter/material.dart';
import 'package:zenhabits_app/domain/model/habit.dart';
import 'package:zenhabits_app/domain/usecases/insert_habit_usecase.dart';
import 'package:zenhabits_app/domain/usecases/delete_habit_usecase.dart';
import 'package:zenhabits_app/domain/usecases/get_habits_usecase.dart';
import 'package:zenhabits_app/domain/usecases/update_habit_usecase.dart';

class HabitViewModel extends ChangeNotifier {
  final InsertHabitUseCase insertHabitUsecase;
  final UpdateHabitUseCase updateHabitUseCase;
  final DeleteHabitUsecase deleteHabitUsecase;
  final GetHabitsUseCase getHabitsUsecase;

  final ValueNotifier<List<Habit>> habitos = ValueNotifier<List<Habit>>([]);

  HabitViewModel({
    required this.insertHabitUsecase,
    required this.updateHabitUseCase,
    required this.deleteHabitUsecase,
    required this.getHabitsUsecase,
  });

  Future<void> getHabits(int userId) async {
    final fetchedHabits = await getHabitsUsecase(userId);
    habitos.value = fetchedHabits;
  }

  Future<void> createHabit(Habit habit) async {
    try {
      final id = await insertHabitUsecase(habit);
      habit.habitId = id;
      habitos.value = [...habitos.value, habit];
    } catch (e) {
      throw Exception ('Error al crear hábito: $e');
    }
  }

    Future<void> updateHabit(Habit habit) async {
      try {
        await updateHabitUseCase(habit);
      } catch (e) {
        throw Exception ('Error al eliminar hábito: $e');
      }
    }

  Future<void> deleteHabit(Habit habit) async {
    try {
      await deleteHabitUsecase.call(habit);
    } catch (e) {
      throw Exception ('Error al eliminar hábito: $e');
    }
  }
}
