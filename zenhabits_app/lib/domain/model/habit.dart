class Habit {
  final String nombre;
  final String? descripcion;
  final String frecuencia;
  final int idUsuario;

  Habit({
    required this.nombre,
    this.descripcion,
    required this.frecuencia,
    required this.idUsuario,
  });
}
