import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:smart_home/Moods/MoodDBModelClass.dart';

class MDBHelper{

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
    String path = join(documentDirectory.path, 'moodsettings1.db');
    print(path);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE mood_db1(id INTEGER PRIMARY KEY AUTOINCREMENT,hn TEXT,hna TEXT,rn TEXT,rna TEXT,'
            'stno TEXT,stna TEXT,dt TEXT,dna,dno TEXT,OnOff TEXT,dd TEXT,ea TEXT,eb TEXT,ec TEXT,ed TEXT,'
            'ee TEXT,ef TEXT,eg TEXT,eh TEXT,ei TEXT,ej TEXT)');


  }

  Future<int> getCountHNumandRNumWithSetNumDnum(String hname,String hnum,String rnum,String setnum,String dnum,String username) async {

   // print("$hnum$rnum$setnum$dnum$username");

    var dbClient = await db;
    var x = await dbClient.rawQuery(
       'SELECT COUNT (*) from mood_db1 WHERE hn = ? AND hna = ? AND rn = ? AND stno = ? AND dno = ? AND ed = ?', ['$hnum','$hname','$rnum','$setnum','$dnum','$username']);
    int count = Sqflite.firstIntValue(x);

    return count;
  }

  Future<List> getMooddataRooms(String hname, String hnum,String rnum,String setnum,String eadata, String username) async {
    print("Get students");
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT * FROM mood_db1 WHERE hna = ? AND hn = ? AND rn = ? AND stno = ? AND ea = ? AND ed = ?', ['$hname','$hnum','$rnum','$setnum','$eadata','$username']);
    print("SELECT * FROM mood_db1 WHERE hna = ? AND hn = ? AND rn = ? AND stno = ? AND ea = ? AND ed = ?', ['$hname','$hnum','$rnum','$setnum','$eadata','$username']");

    return result.toList();
  }


  Future<List> getMooddata(String hname,String hnum,String rnum,String setnum,String dnum,String username) async {

    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT * FROM mood_db1 WHERE hna = ? AND hn = ? AND rn = ? AND stno = ? AND dno = ? AND ed = ?', ['$hname','$hnum','$rnum','$setnum','$dnum','$username']);
    return result.toList();
  }

  Future<List> getcountofmoods(String hname,String hnum,String rnum,String setnum,String username) async {

    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT * FROM mood_db1 WHERE hna = ? AND hn = ? AND rn = ? AND stno = ? AND ed = ?', ['$hname','$hnum','$rnum','$setnum','$username']);

    return result.toList();
  }

  Future<List> getFromUserDataHNumDNameWithDevice(String hname,String hnum,String rnum,String setnum,String modelname,String username) async {

    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT * FROM mood_db1 WHERE hna = ? AND hn = ? AND rn = ? AND stno = ? AND ed = ? AND dna = ?', ['$hname','$hnum','$rnum','$setnum','$username','$modelname']);

    return result.toList();
  }

  Future<int> update(MoodDBData moods) async {

    String hname = moods.hname;
    String hnum = moods.hnum;
    String rnum = moods.rnum;
    String rname = moods.rname;
    String stno = moods.moodstno;
    String stname = moods.moodstname;
    String devicetype = moods.devicetype;
    String devicemodel = moods.devicemodel;
    String devicenum = moods.devicenum;
    String onOffnum = moods.onoffnum;
    String devicedata = moods.devicedata;
    String _adata = moods.aEdata;
    String _bdata= moods.bEdata;
    String _cdata = moods.cEdata;
    String _ddata = moods.dEdata;
    String _edata = moods.eEdata;
    String _fdata = moods.fEdata;
    String _gdata = moods.gEdata;
    String _hdata = moods.hEdata;
    String _idata = moods.iEdata;
    String _jdata = moods.jEdata;

    print("$hname,$hnum,$rnum,$rname,$stno,$stname,$devicetype,$devicemodel,$devicenum,$onOffnum,$devicedata,$_adata,$_bdata,$_cdata,$_ddata,$_edata,$_fdata,$_gdata,$_hdata,$_idata,$_jdata");
    print("enter update");
    var dbClient = await db;
    int res = await dbClient.rawUpdate(
        'UPDATE mood_db1 SET  hn = ?, hna = ?, rn = ?, rna = ?, stno = ?, stna = ?, dt = ?, dna = ?, dno = ?, OnOff = ?, dd = ?, ea = ?, eb = ? , ec = ?, ed= ?, ee = ?, ef = ?,eg = ?,eh = ?,ei = ?,ej = ? WHERE hn=? AND rn =? AND stno =? AND dno = ? AND ed = ?',['$hnum','$hname',
    '$rnum','$rname','$stno','$stname','$devicetype','$devicemodel','$devicenum','$onOffnum','$devicedata','$_adata','$_bdata','$_cdata','$_ddata','$_edata','$_fdata','$_gdata', '$_hdata', '$_idata', '$_jdata','$hnum','$rnum','$stno','$devicenum','$_ddata']);

    print("UPDATE mood_db1 SET  hn = ?, hna = ?, rn = ?, rna = ?, stno = ?, stna = ?, dt = ?, dna = ?, dno = ?, OnOff = ?, dd = ?, ea = ?, eb = ? , ec = ?, ed= ?, ee = ?, ef = ?,eg = ?,eh = ?,ei = ?,ej = ? WHERE hn=? AND rn =? AND stno =? AND dno = ? AND ed = ?',['$hnum','$hname','$rnum','$rname','$stno','$stname','$devicetype','$devicemodel','$devicenum','$onOffnum','$devicedata','$_adata','$_bdata','$_cdata','$_ddata','$_edata','$_fdata','$_gdata', '$_hdata', '$_idata', '$_jdata','$hnum','$rnum','$stno','$devicenum','$_ddata']");

    print(" Update $res");
    //dbClient.close();
    return res;

  }


  Future<MoodDBData> add(MoodDBData moods) async {

    print(moods);
    var dbClient = await db;
    var i = await dbClient.rawInsert(
        "INSERT INTO mood_db1 (hn,hna,rn,rna,stno,stna,dt,dna,dno,OnOff,dd,ea,eb,ec,ed,ee,ef,eg,eh,ei,ej)"
            ' VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)', [
      moods.hnum,
      moods.hname,
      moods.rnum,
      moods.rname,
      moods.moodstno,
      moods.moodstname,
      moods.devicetype,
      moods.devicemodel,
      moods.devicenum,
      moods.onoffnum,
      moods.devicedata,
      moods.aEdata,
      moods.bEdata,
      moods.cEdata,
      moods.dEdata,
      moods.eEdata,
      moods.fEdata,
      moods.gEdata,
      moods.hEdata,
      moods.iEdata,
      moods.jEdata
    ]);
    return moods;
  }


  Future<int> deleteallfromDatabase(int roomnumber,String hnum,String hname,String stno) async {

    var dbClient = await db;
    int res = await dbClient.rawDelete('DELETE FROM mood_db1 WHERE hn = ? AND hna = ? AND stno = ? AND rn = ?',['$hnum','$hname','$stno','$roomnumber']);
    print("DELETE FROM mood_db1 WHERE hn = ? AND hna = ? AND stno = ? AND rn = ?',['$hnum','$hname','$stno','$roomnumber']");
    return res;
  }

  Future<int> deletefromDatabase(int roomnumber,String hnum,String hname,String stno,String dvnum) async {

    var dbClient = await db;
    int res = await dbClient.rawDelete('DELETE FROM mood_db1 WHERE hn = ? AND hna = ? AND stno = ? AND rn = ? AND dno = ?',['$hnum','$hname','$stno','$roomnumber','$dvnum']);
    print("DELETE FROM mood_db1 WHERE hn = ? AND hna = ? AND stno = ? AND rn = ? AND dno=?',['$hnum','$hname','$stno','$roomnumber','$dvnum]");
    return res;
  }




}