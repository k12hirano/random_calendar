class Space {
  int id;
  DateTime datetime;
  int mode;
  int count;

  Space({
    this.id,
    this.datetime,
    this.mode,
    this.count,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateTime': datetime.toUtc().toIso8601String(),
      'mode': mode,
      'count': count
    };
  }
}