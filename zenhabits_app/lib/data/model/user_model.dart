class UserModel {
  final int? userId;
  final String name;
  final String email;
  final String passwordHash;

  UserModel({
    this.userId,
    required this.name,
    required this.email,
    required this.passwordHash,
  });

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "name": name,
    "email": email,
    "password": passwordHash,
  };
}