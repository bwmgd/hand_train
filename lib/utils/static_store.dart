import 'package:camera/camera.dart';
import 'package:my_flutter_app/db/dao.dart';
import 'package:my_flutter_app/entity/classifier.dart';
import 'package:my_flutter_app/entity/history.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../db/database.dart';

/// 一些初始化的全局变量
class Store {
  static String appVersion="";
  static List<CameraDescription> cameraList=[];
  static Classifier? classifier;
}

/// 封装SharedPreferences为单例模式
class Storage {
  static const String _keyGestureIds = "GestureIds";

  /// 静态私有实例对象
  static final Storage _instance = Storage._init();

  /// 工厂构造函数 返回实例对象
  factory Storage() => _instance;

  /// SharedPreferences对象
  static SharedPreferences? _storage;

  /// 命名构造函数 用于初始化SharedPreferences实例对象
  Storage._init() {
    _initStorage();
  }

  //之所以这个没有写在 _init中，是因为SharedPreferences.getInstance是一个异步的方法 需要用await接收它的值
  _initStorage() async {
    // 若_不存在 则创建SharedPreferences实例
    _storage ??= await SharedPreferences.getInstance();
  }

  Future<void> setGestureIds(List<int> gestureIds) async {
    await _initStorage();
    _storage?.setStringList(
        _keyGestureIds, gestureIds.map((e) => e.toString()).toList());
  }

  Future<List<int>> getGestureIds() async {
    await _initStorage();
    return (_storage?.getStringList(_keyGestureIds) ?? [])
        .map((e) => int.parse(e))
        .toList();
  }

  /// 清空存储 并总是返回true
  Future<bool> clear() async {
    await _initStorage();
    _storage!.clear();
    return true;
  }
}

/// 封装数据库为单例模式
class DataBase {
  static late HistoryDao historyDao;
  static late InfoDao infoDao;

  static Future<void> init() async {
    /// dao层初始化
    await $FloorAppDatabase
        .databaseBuilder('database.db')
        .build()
        .then((value) {
      historyDao = value.historyDao;
      infoDao = value.infoDao;
    });
  }

  static Future<void> deleteAllInfoById(HistoryEntity history) async {
    infoDao.deleteAllInfoById(history.id!);
    historyDao.deleteHistory(history);
  }

  static Future<void> clear() async {
    infoDao.clearInfo();
    historyDao.clearHistory();
  }
}
