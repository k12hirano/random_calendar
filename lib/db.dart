import 'package:path/path.dart';
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
  }

  /*Future<List<Item>> getItems() async {
    final db = await database;
    if (database1 == null){
    database1 = await initdb();}
    var maps = await db.query(
      itemtable,
      orderBy: '$_id DESC',
    );
    if (maps.isEmpty) return [];
    return maps.map((map) => fromMap(map)).toList();
  }*/

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

  Future update(Event event, int id) async {
    final db = await database;
    return await db.update(
      eventtable,
      toMap(event),
      where: '$_id = ?',
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

}