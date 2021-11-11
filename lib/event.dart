class Event {
  int id;
  String title;
  int mode;
  int count;
  int year;
  int month;
  String enrollment;

  Event({
    this.id,
    this.title,
    this.mode,
    this.count,
    this.year,
    this.month,
    this.enrollment
});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'mode': mode,
      'count': count,
      'year': year,
      'month': month,
      'enrollment': enrollment
    };
  }
}