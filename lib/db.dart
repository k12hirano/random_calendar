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
  final String _code = 'code';
  final String _enrollment = 'enrollment';

  final String plantable = 'plan';
  final String __id = 'id';
  final String __title = 'title';
  final String __year = 'year';
  final String __month = 'month';
  final String __day = 'day';
  final String __time = 'time';
  final String __code = 'code';
  final String __place = 'place';
  final String __memo = 'memo';

  final String spacetable = 'space';
  final String ___id = 'id';
  final String ___year = 'year';
  final String ___month = 'month';
  final String ___day = 'day';
  final String ___time = 'time';
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
    await db.execute('CREATE TABLE event(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, mode INTEGER, count INTEGER, year INTEGER, month INTEGER,code INTEGER, enrollment TEXT)');
    await db.execute('CREATE TABLE plan(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, year INTEGER, month INTEGER, day INTEGER, time INTEGER, code INTEGER, place TEXT, memo TEXT)');
    await db.execute('CREATE TABLE space(id INTEGER PRIMARY KEY AUTOINCREMENT, year INTEGER, month INTEGER, day INTEGER, time INTEGER, mode INTEGER, count INTEGER)');
  }

  Future<List<Event>> getEvents() async {
    final db = await database;
    if (database1 == null){
    database1 = await initdb();}
    var maps = await db.query(
      eventtable,
      orderBy: '$_id DESC',
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
      orderBy: '$_id DESC',
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
      orderBy: '$_id DESC',
    );
    if (maps.isEmpty) return [];
    return maps.map((map) => fromMapSpace(map)).toList();
  }

  Future<List<Event>> select(int id) async{
    final db = await database;
    var maps = await db.query(eventtable,
        where: '$_id = ?',
        whereArgs: [id]);
    if(maps.isEmpty) return [];
    return maps.map((map)=> fromMap(map)).toList();
  }

  Future<List<Event>> search(String keyword) async {
    final db = await database;

    var maps = (keyword != null)?await db.query(
      eventtable,
      orderBy: '$_id DESC',
      where: '$_title LIKE ?',
         // +'OR $_email LIKE ?'
         // +'OR $_pass LIKE ?'
         // +'OR $_url LIKE ?'
         // +'OR $_memo LIKE ?',
      whereArgs: ['%$keyword%','%$keyword%','%$keyword%','%$keyword%','%$keyword%'],
    )
        :await db.query(
      eventtable,
      orderBy: '$_id DESC',
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

  Future delete(int id) async {
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
      _code: event.code,
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
        code: json[_code],
        enrollment: json[_enrollment],
    );
  }

  Map<String, dynamic> toMapPlan(Plan plan) {
    return {
      __id: plan.id,
      __title: plan.title,
      __year: plan.year,
      __month: plan.month,
      __day: plan.day,
      __time: plan.time,
      __code: plan.code,
      __place: plan.place,
      __memo: plan.memo
    };
  }

  Plan fromMapPlan(Map<String, dynamic> json) {
    return Plan(
      id: json[__id],
      title: json[__title],
      year: json[__year],
      month: json[__month],
      day: json[__day],
      time: json[__time],
      code: json[__code],
      place: json[__place],
      memo: json[__memo],
    );
  }

  Map<String, dynamic> toMapSpace(Space space) {
    return {
      ___id: space.id,
      ___year: space.year,
      ___month: space.month,
      ___day: space.day,
      ___time: space.time,
      ___mode: space.mode,
      ___count: space.count
    };
  }

  Space fromMapSpace(Map<String, dynamic> json) {
    return Space(
      id: json[___id],
      year: json[___year],
      month: json[___month],
      day: json[___day],
      time: json[___time],
      mode: json[___mode],
      count: json[___count]
    );
  }

}