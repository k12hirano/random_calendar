class Plan {
  int id;
  String title;
  int year;
  int month;
  int day;
  int time;
  int code;
  int place;
  String memo;

  Plan({
    this.id,
    this.title,
    this.year,
    this.month,
    this.day,
    this.time,
    this.code,
    this.place,
    this.memo
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'year': year,
      'month': month,
      'day': day,
      'time': time,
      'code': code,
      'place': place,
      'memo': memo
    };
  }
}