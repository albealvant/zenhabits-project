class LocalLogMessages {
  static String habitInserted(String name, int id) =>
      "Habit created: $name with ID $id";
  static String habitUpdated(String name) => "Habit updated: $name";
  static String habitDeleted(int id) => "Habit deleted with ID $id";
  static String upsertError(String name, Object e) =>
      "Error during upsert of habit $name: $e";

  static String fetchedHabits(int userId, int count) =>
      "Fetched $count habits for userId $userId";
  static const deleteHabit = "Error deleting habit";

  static String userInserted(String name) => "User inserted: $name";
  static String userUpdated(String name) => "User updated: $name";
  static String userDeleted(String name) => "User deleted: $name";
  static String userFound(String name) => "User found: $name";
  static String userNotFound(String name) => "User not found: $name";
}