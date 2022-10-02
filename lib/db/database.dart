import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../entity/history.dart';
import 'dao.dart';

part 'database.g.dart';

@Database(version: 1, entities: [HistoryEntity, InfoEntity])
abstract class AppDatabase extends FloorDatabase {
  HistoryDao get historyDao;

  InfoDao get infoDao;
}