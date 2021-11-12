class Plan {
  String title;
  DateTime datetime;
  int year;
  int month;
  int place;
  String memo;

  Plan({
    this.title,
    this.datetime,
    this.year,
    this.month,
    this.place,
    this.memo
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'dateTime': datetime.toUtc().toIso8601String(),
      'year': year,
      'month': month,
      'place': place,
      'memo': memo
    };
  }
}