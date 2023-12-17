import 'dart:convert';
import 'dart:ui';

import '../extensions/color.dart';

abstract class IDay {
  Future<bool> insertDay(Day day);

  Future<bool> insertOrUpdateDay(Day day);

  Future<bool> updateDog(Day day);

  Future<bool> deleteDay(Day day);

  Future<List<Day>> getAllDays();
}

class Day {
  String title;
  int? id;
  Color color;
  DateTime startDate;

  Day(this.title, this.color, this.startDate, [this.id]);

  @override
  String toString() {
    return 'Day{title: $title, color: $color, startDate: $startDate}';
  }

  updateWith(Day day) {
    id = day.id;
    color = day.color;
    startDate = day.startDate;
    title = day.title;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Day && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      json['title'],
      parseColor(json['color']),
      DateTime.parse(json['startDate']),
      json['id'],
    );
  }

  factory Day.fromJSONString(String jsonStr) {
    return Day.fromJson(jsonDecode(jsonStr));
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "color": color.toHex(),
      "startDate": startDate.toString(),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "id": id,
      "color": color.toHex(),
      "startDate": startDate.toString(),
    };
  }

  String toJSONString() {
    return jsonEncode(toJson());
  }
}
