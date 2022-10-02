import 'package:floor/floor.dart';

@Entity(tableName: "history")
class HistoryEntity {
  @PrimaryKey(autoGenerate: true)
  int? id;
  int date;
  int totalTime;
  int gestureId;

  HistoryEntity(this.id, this.date, this.totalTime, this.gestureId);
}

@Entity(tableName: "history_info", foreignKeys: [
  ForeignKey(
    childColumns: ['history_id'],
    parentColumns: ['id'],
    entity: HistoryEntity,
  )
])
class InfoEntity {
  @PrimaryKey(autoGenerate: true)
  int? id;
  @ColumnInfo(name: 'history_id')
  int historyId;
  int gestureId;
  int totalTime;
  int trainTime;
  int ratingId;

  InfoEntity(this.id, this.historyId, this.gestureId, this.totalTime,
      this.trainTime, this.ratingId);
}
