import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zenhabits_app/data/model/habit_model.dart';
import 'package:zenhabits_app/data/model/user_model.dart';

class RemoteHabitsDataSource {
  final String baseUrl;

  RemoteHabitsDataSource({required this.baseUrl}); //http://localhost:3000/load

  Future<List<HabitModel>> fetchUserHabits(UserModel user) async {
    final endpoint = Uri.parse("$baseUrl/load");

    final response = await http.post(
      endpoint,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["habits"] is! List) {
        throw Exception("Formato inválido: 'habits' no es una lista");
      }
      return (data["habits"] as List)
          .map((h) => HabitModel.fromJson(h))
          .toList();
    } else {
      throw Exception("Error al cargar hábitos: ${response.statusCode}");
    }
  }

  Future<void> upsertUserHabits(List<HabitModel> habitsList) async {
    final endpoint = Uri.parse("$baseUrl/save");
    final body = jsonEncode(habitsList.map((h) => h.toJson()).toList());
    final response = await http.post(endpoint, headers: {"Content-Type":"application/json"}, body: body);

    if (response.statusCode!=200) {
      throw Exception("Error al actualizar los hábitos del servidor: ${response.statusCode}");
    }
  }
}