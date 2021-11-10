class Space {
  int id;
  int year;
  int month;
  int day;
  int time;
  int mode;
  int count;

  Space({
    this.id,
    this.year,
    this.month,
    this.day,
    this.time,
    this.mode,
    this.count,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'year': year,
      'month': month,
      'day': day,
      'time': time,
      'mode': mode,
      'count': count
    };
  }
}