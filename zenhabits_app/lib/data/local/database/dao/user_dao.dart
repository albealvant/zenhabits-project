import 'package:floor/floor.dart';
import 'package:zenhabits_app/data/local/database/entities/user_entity.dart';


@dao
abstract class UserDao {
  @insert
  Future<void> insertUser(User user);

  @update
  Future<void> updateUsuario(User user);

  @Query('SELECT username FROM usuarios WHERE idUsuario = :id')
  Future<User?> findUserById(int id);

  @Query('SELECT username FROM usuarios')
  Future<List<User>> findAllUsers();

  @delete
  Future<void> deleteUser(User user);
}