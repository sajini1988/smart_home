//import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

String databaseex = "timer.db";
class TimerDBProvider {

  static String tdbname;

  // make this a singleton class
  TimerDBProvider._privateConstructor();

  static final TimerDBProvider db = TimerDBProvider._privateConstructor();
  static Database _tdatabase;

  Future<Database> get databasetimer async {
    print("enter database");
    print(_tdatabase);
    if (_tdatabase != null) {
      return _tdatabase;
    }
    _tdatabase = await initDB();
    // print("here1");
    return _tdatabase;
  }


  initDB() async {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      tdbname = tdbname.replaceAll(' ','');
      String path = join(documentsDirectory.path, tdbname + databaseex);
      print("database_path");
      print(path);
      return await openDatabase(path, version: 1, onOpen: (db) {
      }
    );
  }

  openDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, tdbname + databaseex);

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      // onConfigure: (Database db) async {
      // await db.execute('PRAGMA foreign_keys=ON');
      // },
    );
  }

  close() async {
    print("close method");
    print(_tdatabase);

    if (_tdatabase != null) {
      var dbClient = await databasetimer;
      dbClient.close();
      _tdatabase = null;
      print("after $_tdatabase");
    }
    else if (_tdatabase == null) {
      print("its already null");
    }
  }

  Future<List>getdatacyclic(String roomno) async {

    var db = await databasetimer;
    List <Map> result=[];
    try{
      result = await db.rawQuery("""SELECT * FROM CyclicTable  WHERE ea = ?""", ['$roomno']);
    }
    catch(e){
      print("Exception in retrieving = $e");
    }

    return result.toList();
  }

  Future<List>getdetailsoftimer(String roomno) async {

    // List<Map> maps1 = await dbClient.query('MasterTable', columns: ['a', 'b','eb']);
    // List<Map> maps = await dbClient.query('SwitchBoardTable', columns: ['a','b','eb']);
    //
    // //Combine's the switch board and master table data into one list.
    // List<Map> smlist = [...maps,...maps1];

    print("enter details");

    final db = await databasetimer;
    List <Map> result=[];
    try{
    List<Map> result1 = await db.rawQuery("""SELECT * FROM TimerTable WHERE ea = ?""", ['$roomno']);
     List<Map> result2 = await db.rawQuery("""SELECT * FROM CyclicTable  WHERE ea = ?""", ['$roomno']);
     //List<Map> result1 = await db.rawQuery("""SELECT * FROM TimerTable""", );
     result = [...result1,...result2];

    }
    catch(e){
      print("Exception in retrieving = $e");
    }

    return result.toList();
  }




}