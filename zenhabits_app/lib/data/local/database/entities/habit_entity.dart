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
  final String? description;
  final String frequency;
  final bool completed;
  final DateTime startDate;
  final DateTime endDate;
  final int userId;

  Habit(this.habitId, this.name, this.description, this.frequency, this.completed, this.startDate, this.endDate, this.userId);
}