import 'package:zenhabits_app/data/local/database/dao/habit_dao.dart';
import 'package:zenhabits_app/data/local/database/entities/habit_entity.dart';
import 'package:zenhabits_app/data/local/model/habit_model.dart';

class HabitRepository {
  final HabitDao habitDao;

  HabitRepository({required this.habitDao});

  Future<int> insertHabit(HabitModel habit) async {
    final habitEntity = Habit(
      habitId: habit.idHabito,
      name: habit.nombre,
      description: habit.descripcion ?? "",
      frecuency: habit.frecuencia,
      userId: habit.idUsuario,
    );
    return await habitDao.insertHabit(habitEntity);
  }

  Future<void> updateHabit(HabitModel habit) async {
    final habitEntity = Habit(
      habitId: habit.idHabito,
      name: habit.nombre,
      description: habit.descripcion ?? "",
      frecuency: habit.frecuencia,
      userId: habit.idUsuario,
    );
    await habitDao.updateHabit(habitEntity);
  }

  Future<List<HabitModel>> getHabitsByUser(int userId) async {
    final habitEntities = await habitDao.findHabitsByUsuario(userId);
    return habitEntities.map((habit) => HabitModel(
      idHabito: habit.habitId,
      nombre: habit.name,
      descripcion: habit.description,
      frecuencia: habit.frecuency,
      idUsuario: habit.userId,
    )).toList();
  }

  Future<void> deleteHabit(HabitModel habit) async {
    final habitEntity = Habit(
      habitId: habit.idHabito,
      name: habit.nombre,
      description: habit.descripcion ?? "",
      frecuency: habit.frecuencia,
      userId: habit.idUsuario,
    );
    await habitDao.deleteHabit(habitEntity);
  }
}
