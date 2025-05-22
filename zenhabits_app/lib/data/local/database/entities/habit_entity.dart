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
  final int habitId;

  final String name;
  final String description;
  final String frequency;
  final bool completed;
  final DateTime startDate;
  final DateTime endDate;
  final int userId;

  Habit({required this.habitId, required this.name, required this.description, required this.frequency, required this.completed, required this.startDate, required this.endDate, required this.userId});
}