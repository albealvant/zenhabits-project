class HabitModel {
  final int? idHabito;
  final String nombre;
  final String? descripcion;
  final String frecuencia;
  final int idUsuario;

  HabitModel({
    this.idHabito,
    required this.nombre,
    this.descripcion,
    required this.frecuencia,
    required this.idUsuario,
  });
}