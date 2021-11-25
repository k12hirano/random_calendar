import 'package:flutter/material.dart';

class Plan {
  int id;
  String title;
  DateTime datetime;
  int year;
  int month;
  int hour;
  int minute;
  String place;
  String memo;

  Plan({
    this.id,
    this.title,
    this.datetime,
    this.year,
    this.month,
    this.hour,
    this.minute,
    this.place,
    this.memo
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dateTime': datetime.toUtc().toIso8601String(),
      'year': year,
      'month': month,
      'hour': hour,
      'minute': minute,
      'place': place,
      'memo': memo
    };
  }
}