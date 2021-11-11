class Space {
  DateTime datetime;
  int mode;
  int count;

  Space({
    this.datetime,
    this.mode,
    this.count,
  });

  Map<String, dynamic> toMap() {
    return {
      'dateTime': datetime,
      'mode': mode,
      'count': count
    };
  }
}