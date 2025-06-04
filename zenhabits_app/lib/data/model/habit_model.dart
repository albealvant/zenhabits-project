class HabitModel {
  final int? habitId;
  final String name;
  final String? description;
  final String frequency;
  final bool completed;
  final DateTime startDate;
  final DateTime endDate;
  final int userId;

  HabitModel({
    this.habitId,
    required this.name,
    this.description,
    required this.frequency,
    required this.completed,
    required this.startDate,
    required this.endDate,
    required this.userId,
  });

  factory HabitModel.fromJson(Map<String, dynamic> data) => HabitModel(
    habitId: data["habit_id"], 
    name: data["name"], 
    description: data["description"],
    frequency: data["frequency"], 
    completed: data["completed"], 
    startDate: DateTime.fromMillisecondsSinceEpoch(data["start_date"]), 
    endDate: DateTime.fromMillisecondsSinceEpoch(data["end_date"]), 
    userId: data["user_id"]
  );

  Map<String, dynamic> toJson() => {
    "habit_id": habitId,
    "name": name,
    "description": description ?? "",
    "frequency": frequency,
    "completed": completed,
    "start_date": startDate.millisecondsSinceEpoch,
    "end_date": endDate.millisecondsSinceEpoch,
    "user_id": userId,
  };
}