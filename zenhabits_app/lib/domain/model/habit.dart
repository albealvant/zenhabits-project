class Habit {
  final String name;
  final String? description;
  final String frequency;
  final bool completed;
  final DateTime startDate;
  final DateTime endDate;
  final int userId;

  Habit({
    required this.name,
    this.description,
    required this.frequency,
    required this.completed,
    required this.startDate,
    required this.endDate,
    required this.userId,
  });
}
