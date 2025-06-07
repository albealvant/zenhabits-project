class RemoteLogMessages {
  static String remoteHabitsFetched(String name, int count) =>
      "Remote habits fetched for user $name: $count habits";

  static String syncRemoteHabits(String name) =>
      "Remote habits synced after fetching user $name";

  static String syncRemoteFailed(Object e) =>
      "Failed to sync remote habits: $e";

  static String remoteUpsertSuccess(int count) =>
      "Successfully upserted $count remote habits";

  static String remoteUpsertFailed(Object e) =>
      "Failed to upsert remote habits: $e";

  static String fetchingHabits(String name, String endpoint) =>
      "Fetching habits for user: $name from $endpoint";

  static const String responseStatus = "Response status:";

  static String habitsFetched(int count) =>
      "Successfully fetched $count habits";

  static String requestBody(String body) => "Request body: $body";

  static String upsertingHabits(int count, String endpoint, int? userId) =>
      "Upserting $count habits to $endpoint with user $userId";

  static const String upsertSuccess = "Habits upserted successfully";

  static String fetchFailed(int statusCode) =>
      "Failed to fetch habits. Status code: $statusCode";

  static String upsertFailed(int statusCode) =>
      "Failed to upsert habits. Status code: $statusCode";

  static String upsertError(Object e) =>
      "Failed to upsert remote habits: $e";
}