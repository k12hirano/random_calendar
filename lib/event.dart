class Event {
  int id;
  String title;
  int mode;
  int count;
  DateTime datetime;
  String enrollment;

  Event({
    this.id,
    this.title,
    this.mode,
    this.count,
    this.datetime,
    this.enrollment
});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'mode': mode,
      'count': count,
      'dateTime': datetime,
      'enrollment': enrollment
    };
  }
}