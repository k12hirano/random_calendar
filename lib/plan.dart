class Plan {
  int id;
  String title;
  DateTime datetime;
  int year;
  int month;
  int time;
  String place;
  String memo;

  Plan({
    this.id,
    this.title,
    this.datetime,
    this.year,
    this.month,
    this.time,
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
      'time': time,
      'place': place,
      'memo': memo
    };
  }
}