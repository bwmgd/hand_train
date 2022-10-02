import 'package:floor/floor.dart';

import '../entity/history.dart';

@dao
abstract class HistoryDao {
  @Query("select * from history")
  Future<List<HistoryEntity>> getAllHistory();

  @insert
  Future<int> insertHistory(HistoryEntity history);

  @delete
  Future<void> deleteHistory(HistoryEntity history);

  @Query("delete from history")
  Future<void> clearHistory();
}

@dao
abstract class InfoDao {
  @Query("select * from history_info where history_id = :id")
  Future<List<InfoEntity>> getAllInfoById(int id);

  @insert
  Future<void> insertInfo(List<InfoEntity> historyInfoList);

  @Query("delete from history_info WHERE history_id = :id")
  Future<void> deleteAllInfoById(int id);

  @Query("delete from history_info")
  Future<void> clearInfo();
}
