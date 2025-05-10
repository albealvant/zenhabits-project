class UsuarioModel {
  final int? idUsuario;
  final String nombre;
  final String email;
  final String passwordHash;

  UsuarioModel({
    this.idUsuario,
    required this.nombre,
    required this.email,
    required this.passwordHash,
  });
}