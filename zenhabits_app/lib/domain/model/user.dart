class User {
  final int? userId;
  final String name;
  final String email;
  final String password;

  User({
    this.userId,
    required this.name,
    required this.email,
    required this.password,
  });
}