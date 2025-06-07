import 'package:floor/floor.dart';
import 'package:zenhabits_app/data/database/entities/user_entity.dart';


@dao
abstract class UserDao {
  @insert
  Future<void> insertUser(User user);

  @update
  Future<void> updateUsuario(User user);

  @Query('SELECT * FROM users WHERE name = :name')
  Future<User?> findUserByName(String name);

  @Query('SELECT name FROM users')
  Future<List<User>> findAllUsers();

  @delete
  Future<void> deleteUser(User user);
}