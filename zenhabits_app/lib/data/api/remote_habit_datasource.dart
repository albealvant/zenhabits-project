import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zenhabits_app/data/model/habit_model.dart';
import 'package:zenhabits_app/data/model/user_model.dart';
import 'package:zenhabits_app/core/utils/logger.dart';

class RemoteHabitsDataSource {
  final String baseUrl;

  RemoteHabitsDataSource({required this.baseUrl}); //http://localhost:3000

  Future<List<HabitModel>> fetchUserHabits(UserModel user) async {
    final endpoint = Uri.parse("$baseUrl/load");
    logger.i("Fetching habits for user: ${user.name} from $endpoint");

    final response = await http.post(
      endpoint,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );

    logger.d("Response status: ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["habits"] is! List) {
        logger.e("Invalid format: 'habits' is not a list");
        throw Exception("Formato inválido: 'habits' no es una lista");
      }

      logger.i("Successfully fetched ${data["habits"].length} habits");
      return (data["habits"] as List)
          .map((h) => HabitModel.fromJson(h))
          .toList();
    } else {
      logger.e("Failed to fetch habits. Status code: ${response.statusCode}");
      throw Exception("Error al cargar hábitos: ${response.statusCode}");
    }
  }

  Future<void> upsertUserHabits(List<HabitModel> habitsList, UserModel user) async {
    final endpoint = Uri.parse("$baseUrl/save");

    final payload = {
      "user": user.toJson(),
      "habits": habitsList.map((h) => h.toJson()).toList(),
    };

    final body = jsonEncode(payload);
    logger.i("Request body: $body");
    logger.i("Upserting ${habitsList.length} habits to $endpoint with user ${user.userId}");

    try {
      final response = await http.post(
        endpoint,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      logger.d("Response status: ${response.statusCode}");
      if (response.statusCode != 200) {
        logger.e("Failed to upsert habits. Status code: ${response.statusCode}");
        throw Exception("Error al actualizar los hábitos del servidor: ${response.statusCode}");
      }

      logger.i("Habits upserted successfully");
    } catch (e) {
      logger.e("Error upserting habits: $e", e);
    }
  }
}