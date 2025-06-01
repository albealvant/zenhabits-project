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
    habitId: data["habitId"], 
    name: data["name"], 
    frequency: data["frequency"], 
    completed: data["completed"], 
    startDate: DateTime.fromMillisecondsSinceEpoch(data["startDate"]), 
    endDate: DateTime.fromMillisecondsSinceEpoch(data["endDate"]), 
    userId: data["userId"]
  );

  Map<String, dynamic> toJson() => {
    "habitId": habitId,
    "name": name,
    "description": description,
    "frequency": frequency,
    "completed": completed,
    "startDate": startDate.millisecondsSinceEpoch,
    "endDate": endDate.millisecondsSinceEpoch,
    "userId": userId,
  };
}