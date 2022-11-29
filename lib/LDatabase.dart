
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_home/LDatabaseModelClass.dart';

String textvalue2,txt;

class DBHelper {

  List<Student> students = [];
  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'localdb.db');
    print(path);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute(
        'CREATE TABLE localdb (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, lb TEXT, lc TEXT'
            ', ld TEXT, le TEXT, lf TEXT, lg TEXT, lh TEXT, li TEXT, lj TEXT, lk TEXT, ll TEXT'
            ', lm TEXT, ln TEXT, lo TEXT, lp TEXT, lq TEXT, lr TEXT, ls TEXT, lt TEXT, lu TEXT'
            ', lv TEXT, lw TEXT, lx TEXT, ly TEXT, lz TEXT)');
  }

  Future<Student> add(Student student) async {
    var dbClient = await db;
    var i = await dbClient.rawInsert(
        "INSERT INTO localdb (name,lb,lc,ld,le,lf,lg,lh,li)"
            ' VALUES (?,?,?,?,?,?,?,?,?)', [
      student.name,
      student.lb,
      student.lc,
      student.ld,
      student.le,
      student.lf,
      student.lg,
      student.lh,
      student.li
    ]);
    print("inserted data $i");
    print(student.name);
    print(student.lb);
    print(student.lc);
    print(student.ld);
    print(student.le);
    print(student.lf);
    print(student.lg);

    return student;
  }

  Future<List<Student>> getStudents() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(
        'localdb', columns: ['id', 'name', 'lb']);
    List<Student> students = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        students.add(Student.fromMap(maps[i]));
      }
    }
    return students;
  }

  Future<List> getStudentstest() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM localdb');

    print(result);

    return result.toList();
  }

  Future<List> getStudents1(String hname, String hnum) async {
    print("Get students");
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT * FROM localdb where name = ?', [hname]);
    return result.toList();
  }

  Future<List> getall() async {
    print("Get students");
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM localdb');

    print(result);

    return result.toList();
  }

  Future<int> delete(String id) async {
    var dbClient = await db;
    return await dbClient.delete(
      'localdb',
      where: 'name = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }




  Future<int> getCounthname(txt) async {
    //database connection
    Database db = await this.db;
    var x = await db.rawQuery(
        'SELECT COUNT (*) from localdb WHERE name = ?', ['$txt']);
    int count = Sqflite.firstIntValue(x);
    print("countdata");
    print("multiple data count method");
    print(count);
    return count;
  }

  Future<int> getNumCountLocal() async {
    //database connection
    var db = await this.db;
    var x = await db.rawQuery('SELECT COUNT (*) from localdb ');
    int getNumCount = Sqflite.firstIntValue(x);
    print("GetNumCount");
    print(getNumCount);
    return getNumCount;
  }

  Future<List> getLocalDateHName(String hname) async {
    //database connection
    var db = await this.db;
    var x = await db.rawQuery(
        'SELECT * from localdb WHERE name = ?', ['$hname']);
    return x.toList();
  }

  Future<int>updatelocalTablePassword(String hname,String username,String password)async{

    var dbClient = await this.db;
    int res = await dbClient.rawUpdate(
        'UPDATE localdb SET le = ? WHERE name = ? AND ld = ?',['$password','$hname','$username']);
    return res;

  }
  Future<int>updatelocalTableip(String hname,String ip,String port)async{

    var dbClient = await this.db;
    int res = await dbClient.rawUpdate(
        'UPDATE localdb SET lc = ?, li = ? WHERE name = ?',['$ip','$port','$hname']);
    return res;
  }

}
