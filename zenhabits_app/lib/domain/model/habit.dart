class Habit {
  int? habitId;
  final String name;
  final String? description;
  final String frequency;
  final bool completed;
  final DateTime startDate;
  final DateTime endDate;
  final int userId;

  Habit({
    this.habitId,
    required this.name,
    this.description,
    required this.frequency,
    required this.completed,
    required this.startDate,
    required this.endDate,
    required this.userId,
  });
}
