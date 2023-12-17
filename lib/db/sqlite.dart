import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../extensions/color.dart';
import '../logger/logger.dart';
import 'day.dart';

class SqlliteDB implements IDay {
  static const _databaseName = "day.db";
  static const _tableName = "days";
  static const _databaseVersion = 1;

  // 单例对象
  static SqlliteDB? instance;

  static SqlliteDB getInstance() {
    instance ??= SqlliteDB._init();
    return instance!;
  }

  // 私有构造函数
  SqlliteDB._init() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  // 数据库连接
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    // 当数据库首次创建时，创建你的表
    await db.execute(
        'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, color TEXT, startDate TEXT)');
  }

  @override
  Future<bool> insertDay(Day day) async {
    final db = await database;
    final insertNum = await db.insert(
      _tableName,
      day.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return insertNum != 0;
  }

  @override
  Future<bool> insertOrUpdateDay(Day day) async {
    final db = await database;
    final id = day.id;
    int insertNum;
    if (id != null) {
      logger.i('update $day');
      insertNum = await db.update(_tableName, day.toMap(),
          where: 'id = ?', whereArgs: [day.id]);
    } else {
      logger.i('insert $day');
      insertNum = await db.insert(
        _tableName,
        day.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    return insertNum != 0;
  }

  @override
  Future<bool> updateDog(Day day) async {
    final db = await database;
    final insertNum = await db
        .update(_tableName, day.toMap(), where: 'id = ?', whereArgs: [day.id]);
    return insertNum != 0;
  }

  @override
  Future<bool> deleteDay(Day day) async {
    final db = await database;
    final insertNum = await db.delete(_tableName,
        where: 'id = ? or title = ?', whereArgs: [day.id, day.title]);
    return insertNum != 0;
  }

  @override
  Future<List<Day>> getAllDays() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(
        maps.length,
        (i) => Day(
            maps[i]['title'] as String,
            parseColor(maps[i]['color'] as String),
            DateTime.parse(maps[i]['startDate'] as String),
            maps[i]['id'] as int));
  }
}
