import 'package:floor/floor.dart';
import 'package:zenhabits_app/data/local/database/entities/user_entity.dart';

@Entity(
  tableName: 'habits',
  foreignKeys: [
    ForeignKey(
      childColumns: ['userId'],
      parentColumns: ['userId'],
      entity: User,
      onDelete: ForeignKeyAction.cascade,
    )
  ],
)
class Habit {
  @PrimaryKey(autoGenerate: true)
  final int? habitId;

  final String name;
  final String description;
  final String frecuency;
  final int userId;

  Habit({this.habitId, required this.name, required this.description, required this.frecuency, required this.userId});
}