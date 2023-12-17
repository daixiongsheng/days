import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'day.dart';

@HiveType(typeId: 0)
class DayModel extends HiveObject {
  @HiveField(0)
  late String title;
  @HiveField(3)
  late int id;
  @HiveField(2)
  late Color color;
  @HiveField(1)
  late DateTime startDate;

  Day toDay() {
    return Day(title, color, startDate, id);
  }

  DayModel.formDay(Day day) {
    id = day.id!;
    title = day.title;
    color = day.color;
    startDate = day.startDate;
  }
}

int _id = 0;

class HiveDB implements IDay {
  static const _tableName = "days";
  static const _key = "id";

  // 单例对象
  static HiveDB? instance;

  static HiveDB getInstance() {
    instance ??= HiveDB._init();
    return instance!;
  }

  // 私有构造函数
  HiveDB._init() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  // 数据库连接
  static Box? _database;

  Future<Box> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Box> _initDatabase() async {
    await Hive.initFlutter();
    return await Hive.openBox(_tableName);
  }

  @override
  Future<bool> deleteDay(Day day) async {
    final db = await database;
    _deleteId(day.id!);
    db.delete(day.id);
    return true;
  }

  Future<List<int>> get _ids async {
    final db = await database;
    final ids = db.get(_key);
    return ids != null
        ? List.generate(ids.length, (index) => ids[index] as int)
        : [];
  }

  @override
  Future<List<Day>> getAllDays() async {
    final db = await database;
    List<Day> days = [];
    for (final id in await _ids) {
      final data = db.get(id);
      if (data != null) {
        days.add(Day.fromJSONString(data.toString()));
      }
    }
    return days;
  }

  void _adId(int id) async {
    final db = await database;
    final ids = await _ids;
    ids.add(id);
    db.put(_key, ids);
  }

  void _deleteId(int id) async {
    final db = await database;
    final ids = await _ids;
    db.put(_key, ids.where((e) => e != id).toList());
  }

  @override
  Future<bool> insertDay(Day day) async {
    final db = await database;
    final id = _id++;
    day.id = id;
    _adId(id);
    db.put(id, day.toJSONString());
    return true;
  }

  @override
  Future<bool> insertOrUpdateDay(Day day) async {
    final id = day.id;
    if (id != null) {
      return updateDog(day);
    } else {
      return insertDay(day);
    }
  }

  @override
  Future<bool> updateDog(Day day) async {
    final db = await database;
    db.put(day.id, day.toJSONString());
    return true;
  }
}
