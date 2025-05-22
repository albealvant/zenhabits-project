class UserModel {
  final int? idUsuario;
  final String nombre;
  final String email;
  final String passwordHash;

  UserModel({
    this.idUsuario,
    required this.nombre,
    required this.email,
    required this.passwordHash,
  });
}