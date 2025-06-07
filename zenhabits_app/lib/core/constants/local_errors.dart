class LocalErrors {
  static String insertHabit(String name) => "Error inserting habit $name";
  static String updateHabit(String name) => "Error updating habit $name";
  static String deleteHabit(String e) => "Error deleting habit: $e";
  static String fetchHabits(int userId, String e) => "Failed to fetch habits for userId $userId: $e";
  static String getHbits(String e) => "Error al obtener los hábitos: $e";
  static const fetchUser = "Error fetching user";
  static const deleteUser = "Error deleting user";
  static String insertUser(String name, String e) => "Error inserting user $name: $e";
  static const updateUser = "Error updating user";
  static const getUser = "Error getting user";
}