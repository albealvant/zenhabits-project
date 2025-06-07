import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zenhabits_app/data/model/habit_model.dart';
import 'package:zenhabits_app/data/model/user_model.dart';
import 'package:zenhabits_app/core/utils/logger.dart';
import 'package:zenhabits_app/core/constants/remote_errors.dart';
import 'package:zenhabits_app/core/constants/remote_log_messages.dart';

class RemoteHabitsDataSource {
  final String baseUrl;

  RemoteHabitsDataSource({required this.baseUrl});

  Future<List<HabitModel>> fetchUserHabits(UserModel user) async {
    final endpoint = Uri.parse("$baseUrl/load");
    logger.i(RemoteLogMessages.fetchingHabits(user.name, endpoint.toString()));

    final response = await http.post(
      endpoint,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );

    logger.d("${RemoteLogMessages.responseStatus} ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["habits"] is! List) {
        logger.e(RemoteErrors.invalidHabitsFormat);
        throw Exception(RemoteErrors.invalidHabitsFormat);
      }

      logger.i(RemoteLogMessages.habitsFetched(data["habits"].length));
      return (data["habits"] as List)
          .map((h) => HabitModel.fromJson(h))
          .toList();
    } else {
      logger.e(RemoteLogMessages.fetchFailed(response.statusCode));
      throw Exception(RemoteErrors.fetchHabitsFailed(response.statusCode));
    }
  }

  Future<void> upsertUserHabits(List<HabitModel> habitsList, UserModel user) async {
    final endpoint = Uri.parse("$baseUrl/save");

    final payload = {
      "user": user.toJson(),
      "habits": habitsList.map((h) => h.toJson()).toList(),
    };

    final body = jsonEncode(payload);
    logger.i(RemoteLogMessages.requestBody(body));
    logger.i(RemoteLogMessages.upsertingHabits(habitsList.length, endpoint.toString(), user.userId));

    try {
      final response = await http.post(
        endpoint,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      logger.d("${RemoteLogMessages.responseStatus} ${response.statusCode}");
      if (response.statusCode != 200) {
        logger.e(RemoteLogMessages.upsertFailed(response.statusCode));
        throw Exception(RemoteErrors.upsertHabitsFailed(response.statusCode));
      }

      logger.i(RemoteLogMessages.upsertSuccess);
    } catch (e) {
      logger.e(RemoteLogMessages.upsertError(e), e);
    }
  }
}