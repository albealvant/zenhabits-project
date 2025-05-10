import 'package:floor/floor.dart';

@Entity(tableName: 'users')
class User {
  @PrimaryKey(autoGenerate: true)
  final int userId;

  final String name;
  final String email;
  final String passwordHash;

  User(this.userId, this.name, this.email, this.passwordHash);
}