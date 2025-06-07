class RemoteErrors {
  static const String invalidHabitsFormat =
      "Formato inválido: 'habits' no es una lista";

  static String fetchHabitsFailed(int statusCode) =>
      "Error al cargar hábitos: $statusCode";

  static String upsertHabitsFailed(int statusCode) =>
      "Error al actualizar los hábitos del servidor: $statusCode";
}