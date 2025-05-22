import 'package:flutter/material.dart';
import 'package:zenhabits_app/domain/model/habit.dart';
import 'package:zenhabits_app/domain/usecases/insert_habit_usecase.dart';
import 'package:zenhabits_app/domain/usecases/delete_habit_usecase.dart';

class HabitViewModel extends ChangeNotifier {
  final InsertHabitUseCase insertHabitUsecase;
  final DeleteHabitUsecase deleteHabitUsecase;

  final ValueNotifier<List<Habit>> habitos = ValueNotifier<List<Habit>>([]);

  HabitViewModel({
    required this.insertHabitUsecase,
    required this.deleteHabitUsecase,
  });

  Future<void> crearHabito(Habit habit) async {
    try {
      await insertHabitUsecase(habit);
    } catch (e) {
      throw Exception ('Error al crear hábito: $e');
    }
  }

  Future<void> eliminarHabito(int id) async {
    try {
      await deleteHabitUsecase(id as Habit); //FIXME: Corregir usecase
    } catch (e) {
      throw Exception ('Error al eliminar hábito: $e');
    }
  }
}
