import 'package:path/path.dart';
import 'package:random_calendar/plan.dart';
import 'package:random_calendar/space.dart';
import 'package:sqflite/sqflite.dart';
import 'package:random_calendar/event.dart';

class DB {

  final databaseName = 'PassStorage.db';
  final databaseVersion = 1;
  final String eventtable = 'event';
  final String _id = 'id';
  final String _title = 'title';
  final String _mode = 'mode';
  final String _count = 'count';
  final String _year = 'year';
  final String _month = 'month';
  final String _enrollment = 'enrollment';

  final String plantable = 'plan';
  final String __id = 'id';
  final String __title = 'title';
  final String __datetime = 'datetime';
  final String __year = 'year';
  final String __month = 'month';
  final String __time = 'time';
  final String __place = 'place';
  final String __memo = 'memo';

  final String ___id = 'id';
  final String spacetable = 'space';
  final String ___datetime = 'datetime';
  final String ___mode = 'mode';
  final String ___count = 'count';

  Database database1;

  Future<Database> get database async{
    if (database1 != null) return database1;
    database1 = await initdb();
    return database1;
  }
  Future<Database> initdb() async {
    String path = join(await getDatabasesPath(), 'event.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: createTable,
    );
  }
  Future<void> createTable(Database db, int version) async {
    await db.execute('CREATE TABLE event(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, mode INTEGER, count INTEGER, year INTEGER, month INTEGER, enrollment TEXT)');
    await db.execute('CREATE TABLE plan(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, datetime TEXT, year INTEGER, month INTEGER, time INTEGER, place TEXT, memo TEXT)');
    await db.execute('CREATE TABLE space(id INTEGER PRIMARY KEY AUTOINCREMENT, datetime TEXT, mode INTEGER, count INTEGER)');
    // await db.execute('CREATE TABLE link()'); 予定複数日程選択の時の紐付けよう、予定用データベース、idで紐付けして他日程を取得、登録は日程と予定に一対一で紐付け
  }

  Future<List<Event>> getEvents() async {
    final db = await database;
    if (database1 == null){
    database1 = await initdb();}
    var maps = await db.query(
      eventtable,
      orderBy: '$_enrollment DESC',
    );
    if (maps.isEmpty) return [];
    return maps.map((map) => fromMap(map)).toList();
  }
  Future<List<Plan>> getPlans() async {
    final db = await database;
    if (database1 == null){
      database1 = await initdb();}
    var maps = await db.query(
      plantable,
      orderBy: '$__datetime ASC',
    );
    if (maps.isEmpty) return [];
    return maps.map((map) => fromMapPlan(map)).toList();
  }
  Future<List<Plan>> getDayPlan(String year, String month, String day) async {
    final db=await database;
    if(database1 ==null) {
      database1 =await initdb();}
    var maps = await db.query(
      plantable,
      orderBy: '$__datetime ASC',
      where: '$__datetime LIKE ?',
      whereArgs: ['${year+'-'+month+'-'+day}%']
    );
    if(maps.isEmpty) return [];
    return maps.map((map) => fromMapPlan(map)).toList();
  }

  Future<List<List<Plan>>> getPlan() async {
    List<List<Plan>> _plan=[];
    for(var i=2021;i<2023;i++){
      for(var t=1;t<13;t++){
        for(var u=1;u<32;u++){
          var kari =  await getDayPlan(i.toString(), t.toString(), u.toString());
          if(kari.length>0){
          _plan.add(kari);}
        }
      }
    }
    return _plan;
  }
  Future<List<Plan>> getPlansMonth(int year, int month) async {
    final db = await database;
    if (database1 == null){
      database1 = await initdb();}
    var maps = await db.query(
        plantable,
        orderBy: '$__datetime DESC',
        where: '$__year = ? OR $__month = ?',
        whereArgs: [year, month]
    );
    if (maps.isEmpty) return [];
    return maps.map((map) => fromMapPlan(map)).toList();
  }


  Future<List<Space>> getSpaces() async {
    final db = await database;
    if (database1 == null){
      database1 = await initdb();}
    var maps = await db.query(
      spacetable,
      orderBy: '$___datetime DESC',
    );
    if (maps.isEmpty) return [];
    return maps.map((map) => fromMapSpace(map)).toList();
  }

  Future<List<Event>> select(DateTime datetime) async{
    final db = await database;
    var maps = await db.query(eventtable,
        where: '$_enrollment = ?',
        whereArgs: [datetime]);
    if(maps.isEmpty) return [];
    return maps.map((map)=> fromMap(map)).toList();
  }

  Future<List<Event>> search(String keyword) async {
    final db = await database;

    var maps = (keyword != null)?await db.query(
      eventtable,
      orderBy: '$_enrollment DESC',
      where: '$_title LIKE ?',
         // +'OR $_email LIKE ?'
         // +'OR $_pass LIKE ?'
         // +'OR $_url LIKE ?'
         // +'OR $_memo LIKE ?',
      whereArgs: ['%$keyword%','%$keyword%','%$keyword%','%$keyword%','%$keyword%'],
    )
        :await db.query(
      eventtable,
      orderBy: '$_enrollment DESC',
    );

    if (maps.isEmpty) {
      return [];
    }else {
      return maps.map((map) => fromMap(map)).toList();
    }
  }

  Future insert(Event event) async {
    final db = await database;
    await db.insert(eventtable, event.toMap());
  }

  Future insertPlan(Plan plan) async {
    final db = await database;
    await db.insert(plantable, plan.toMap());
  }

  Future insertSpace(Space space) async {
    final db = await database;
    await db.insert(spacetable, space.toMap());
  }

  Future update(Event event, int id) async {
    final db = await database;
    return await db.update(
      eventtable,
      toMap(event),
      where: '$_id = ?',
      whereArgs: [id],
    );
  }

  Future updatePlan(Plan plan, int id) async {
    final db = await database;
    return await db.update(
      plantable,
      toMapPlan(plan),
      where: '$__id = ?',
      whereArgs: [id],
    );
  }

  Future updateSpace(Space space, int id) async {
    final db = await database;
    return await db.update(
      spacetable,
      toMapSpace(space),
      where: '$___id = ?',
      whereArgs: [id],
    );
  }

  Future delete(id) async {
    final db = await database;
    return await db.delete(
      eventtable,
      where: '$_id = ?',
      whereArgs: [id],
    );
  }
  Future deletePlan(int id) async {
    final db = await database;
    return await db.delete(
      plantable,
      where: '$__id = ?',
      whereArgs: [id],
    );
  }
  Future deleteSpace(int id) async {
    final db = await database;
    return await db.delete(
      spacetable,
      where: '$___id = ?',
      whereArgs: [id],
    );
  }

  Map<String, dynamic> toMap(Event event) {
    return {
      _id: event.id,
      _title: event.title,
      _mode: event.mode,
      _count: event.count,
      _year: event.year,
      _month: event.month,
      _enrollment: event.enrollment
    };
  }

  Event fromMap(Map<String, dynamic> json) {
    return Event(
        id: json[_id],
        title: json[_title],
        mode: json[_mode],
        count: json[_count],
        year: json[_year],
        month: json[_month],
        enrollment: json[_enrollment],
    );
  }

  Map<String, dynamic> toMapPlan(Plan plan) { print(plan.datetime.toUtc().toIso8601String());
    return {
      __id: plan.id,
      __title: plan.title,
      __datetime: plan.datetime.toUtc().toIso8601String(),
      __year: plan.year,
      __month: plan.month,
      __time: plan.time,
      __place: plan.place,
      __memo: plan.memo
    };

  }

  Plan fromMapPlan(Map<String, dynamic> json) {
    return Plan(
      id: json[__id],
      title: json[__title],
      datetime: DateTime.parse(json[__datetime]).toLocal(),
      year: json[__year],
      month: json[__month],
      time: json[__time],
      place: json[__place],
      memo: json[__memo],
    );
  }

  Map<String, dynamic> toMapSpace(Space space) {print(space.datetime.toUtc().toIso8601String());
    return {
      ___id: space.id,
     ___datetime: space.datetime.toUtc().toIso8601String(),
      ___mode: space.mode,
      ___count: space.count
    };
  }

  Space fromMapSpace(Map<String, dynamic> json) {
    return Space(
      id: json[___id],
      datetime: DateTime.parse(json[___datetime]).toLocal(),
      mode: json[___mode],
      count: json[___count]
    );
  }

}