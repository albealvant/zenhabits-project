import 'package:flutter/material.dart';
import 'package:zenhabits_app/core/utils/logger.dart';
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
    logger.i("Fetching habits for user ID: $userId");
    try {
      final fetchedHabits = await getHabitsUsecase(userId);
      habitos.value = fetchedHabits;
      logger.i("Fetched ${fetchedHabits.length} habits");
    } catch (e) {
      logger.e("Error fetching habits: $e");
    }   
  }

  Future<void> createHabit(Habit habit) async {
    try {
      final id = await insertHabitUsecase(habit);
      habit.habitId = id;
      logger.i("Habit created with ID: $id");
      await getHabits(habit.userId);
    } catch (e) {
      logger.e("Error creating habit: $e");
      throw Exception('No se pudo crear el hábito: $e');
    }
  }

  Future<void> updateHabit(Habit habit) async {
    try {
      logger.i("Habit updated: ${habit.habitId}");
      await updateHabitUseCase(habit);
    } catch (e) {
      logger.e("Error updating habit: $e");
      throw Exception ('No se pudo actualizar el hábito: $e');
    }
  }

  Future<void> deleteHabit(Habit habit) async {
    try {
      await deleteHabitUsecase.call(habit);
      habitos.value = habitos.value.where((h) => h.habitId != habit.habitId).toList();
      logger.i("Habit deleted: ${habit.habitId}");
    } catch (e) {
      logger.e("Error deleting habit: $e");
      throw Exception ('No se pudo eliminar el hábito: $e');
    }
  }
}