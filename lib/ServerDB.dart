import 'dart:convert';
import 'dart:io';
//import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:encrypt/encrypt.dart';

String databaseex = ".db";
class DBProvider {
  static String dbname;
  // make this a singleton class
  DBProvider._privateConstructor();
  static final DBProvider db = DBProvider._privateConstructor();
  static Database _database;
  Future<Database> get database async {
   // print("enter database");
  //  print(_database);
    if (_database != null)
    {
        return _database;
    }
    _database = await initDB();
   // print("here1");
    return _database;
  }
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbname+databaseex);
    print("database_path");
    print(path);
    return await openDatabase(path, version: 1, onOpen: (db) {

    });
  }

  openDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path,dbname+databaseex);

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
    print(_database);

    if(_database!=null){
      var dbClient = await database;
      dbClient.close();
      _database=null;
      print(_database);
    }
    else if(_database==null){

      print("its already null");

    }
  }
  Future<List>newClient() async {
    print("databasest");
    final db = await database;
    List <Map> result=[];
    try{
      result = await db.rawQuery("""SELECT * FROM ServerTable""");
    }
    catch(e){
      print("Exception in retrieving = $e");
    }

    return result.toList();
  }

  Future<List>newClient1() async {
    print("databasemt");
    final db = await database;
    List<Map>result=[];
    try {
      result = await db.rawQuery("""SELECT * FROM MasterTable""");
    }
    catch(e){
      print("Expection in retrieving = $e");
    }
    return result.toList();
  }

  Future<List>newClient2() async {
    print("databasest");
    final db = await database;
    List<Map>result = [];
    try{
      result = await db.rawQuery("""SELECT * FROM SwitchBoardTable""");
    }
    catch(e){
      print("Expection in retrieving =$e");
    }
    return result.toList();
  }

  Future<List>newClient3() async {
    print("databasesd");
    final db = await database;
    List <Map> result = await db.rawQuery("""SELECT * FROM ServerDetails""");
    print(result);
    return result.toList();
  }

  Future<int> update(String dd, String de) async {
    var dbClient = await database;
    int res = await dbClient.rawUpdate(
        'UPDATE ServerTable SET  dd = ? ,de = ? ',['$dd','$de']);
    return res;

  }

  Future<int> updatemt( String dd, String de) async {
    var dbClient = await database;
    int res = await dbClient.rawUpdate(
        'UPDATE MasterTable SET  dd = ? ,de = ? ',['$dd','$de']);
    return res;
  }

  Future<int> updatest(String dd, String de) async {
    var dbClient = await database;
    int res = await dbClient.rawUpdate(
        'UPDATE SwitchBoardTable SET  dd = ? ,de = ?',['$dd','$de']);
    return res;

  }
  Future<int> updatesd(String dd, String de) async {
    var dbClient = await database;
    int res = await dbClient.rawUpdate(
        'UPDATE ServerDetails SET  dd = ? ,de = ?',['$dd','$de']);
    return res;
  }

  Future<int>updateServerDetailsTablePassword(String username, String password)async{

    final key = Key1.fromUtf8('edisonbrosmartha');
    final iv = IV.fromUtf8('AAAAAAAAAAAAAAAA');

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(password, iv: iv);
   // String s = encrypted.base64;

    var dbClient = await database;
    int res = await dbClient.rawUpdate(
        'UPDATE ServerDetails SET  ps = ? WHERE un = ?',['$encrypted','$username']);
    return res;

  }

  Future<int> updateServerTableHNameWithAdminPass(String username, String password,String hname ) async {

    final key = Key1.fromUtf8('edisonbrosmartha');
    final iv = IV.fromUtf8('AAAAAAAAAAAAAAAA');

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(password,iv: iv);
   // String s = encrypted.base64;

    var dbClient = await database;
    int res = await dbClient.rawUpdate(
        'UPDATE ServerTable SET  dc = ? WHERE db = ? AND dd = ? ',['$encrypted','$username','$hname']);
    return res;

  }

  Future<List>getServerDetailsDataWithHNumUType(String hname,String userType)async{

    var dbClient = await database;
    var result= await dbClient.rawQuery('SELECT * FROM ServerDetails WHERE un = ?',[userType]);
    return result.toList();
  }

  Future<List>getServerDetailsDataWithId(String hname,String SlId)async{

    print("serverDetailswithid");
    var dbClient = await database;
    var result= await dbClient.rawQuery('SELECT * FROM ServerDetails WHERE _id = ?',[SlId]);
    return result.toList();
  }

  Future<List>getServerDetailsDataWithHNumUName(String hname,String username)async{

    // var dbClient = await database;
    // var result= await dbClient.rawQuery('SELECT ps FROM ServerDetails WHERE un = ?',[username]);
    // return result.toList();


    var dbClient = await database;
    List<Map> maps = await dbClient.query('ServerDetails',columns: ['ps']);

    maps.forEach((row) => print(row));
    // List students = [];
    // print("data is $maps");
    // for (int i = 0; i < maps.length; i++) {
    //     print("i $i");
    //    students.add(maps[i].values);
    // }
    // print(students.length);
    // print(students);
    // print((students[0].toString()).length);
    // print((students[1].toString()).length);

    //final encoded = utf8.encode(students[0].toString());


    //String bs4str = base64.encode(bytes);

   // final List<int> codeUnits = students[0].toString().codeUnits;
   // print(codeUnits);
   //  final Uint8List unit8List = Uint8List.fromList(codeUnits);
   //  print(unit8List);



    //final key = Key1.fromUtf8('edisonbrosmartha');
    //final iv = IV.fromUtf8('AAAAAAAAAAAAAAAA');
    //final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    // String serverResponse = String.fromCharCodes(unit8List);
    // print("Server Response: " + serverResponse);

    // Uint8List bytes = Uint8List.fromList(unit8List);
    // print(base64.encode(bytes));
    // String decrypt = encrypter.decrypt64(base64.encode(bytes), iv: iv);
    // print("decrypt:$decrypt");






    //print('bytes: $bytes');

    return maps;



  }

  Future<List>getServerDataWithHNum(String Hnum, String HName) async{

    var dbClient = await database;
    var result = await dbClient.rawQuery('SELECT * FROM ServerTable where de = ?',[Hnum]);
    return result.toList();
  }

  Future<List> comlist() async {

    var dbClient = await database;
    //Query to get the data from master and switch board table's.
    List<Map> maps1 = await dbClient.query('MasterTable', columns: ['a', 'b','eb']);
    List<Map> maps = await dbClient.query('SwitchBoardTable', columns: ['a','b','eb']);

    //Combine's the switch board and master table data into one list.
    List<Map> smlist = [...maps,...maps1];

    // print("map list: $maps");
    // print("map list1: $maps1");
    // print("list_data is $smlist ");
    // print("Last value is ${smlist.last}");


    // convert each item to a string by using JSON encoding
    final jsonList = smlist.map((item) => jsonEncode(item)).toList();

    // using toSet - toList strategy
    final uniqueJsonList = jsonList.toSet().toList();

    // convert each item back to the original form using JSON decoding
    final result = uniqueJsonList.map((item) => jsonDecode(item)).toList();


   // print("unique name is : $result");

    return result.whereType<Map>().toList();


    // got the last index id
   // print("Last value1 ${smlist.last.values.first}");

    // removed duplicate data
   // smlist = [...{...smlist}].sublist(0,smlist.last.values.first,);



   // print("list_data_1 is ${smlist.toList} ");
    // return the simple list
    //return result.toList();



  }

  Future<List> dataFromSw(String dnum) async{
    var dbClient = await database;
    List<Map> x= await dbClient.rawQuery('SELECT a,b,eb FROM SwitchBoardTable where d = ?',['$dnum']);
    print("sw is  $x");
    return x;
  }

  Future<List> dataFromMTR(String dnum) async{
    var dbClient = await database;
    List<Map> x= await dbClient.rawQuery('SELECT a,b,eb FROM MasterTable where d = ?',['$dnum']);
    print("mas is $x");
    return x;
  }

  Future<List> DataFromMTRNumAndHNumGroupIdDetails1(String RoomNum1, String housennum, String hname, String Groupid) async{
    var dbClient = await database;
    List<Map> x= await dbClient.rawQuery('SELECT * FROM MasterTable WHERE a=? AND de =? AND ea = ?',['$RoomNum1','$housennum', '$Groupid']);

    return x.toList();
  }

  Future<List> dataFromMTRNumAndHNumGroupIdDetails1User(String roomNum1, String houseNum, String hname, String groupId, String dvNum) async{
    var dbClient = await database;
    List<Map> x= await dbClient.rawQuery('SELECT * FROM MasterTable WHERE a=? AND de =? AND ea = ? AND d = ?',['$roomNum1','$houseNum', '$groupId','$dvNum']);
    return x.toList();
  }

  Future<List> DataFromMTHNumSHDeviceNum(String RoomNum1, String housennum, String hname, String Groupid, String devicename) async{
    var dbClient = await database;
    List<Map> x= await dbClient.rawQuery('SELECT * FROM MasterTable WHERE a=? AND de =? AND ea = ? AND ec = ? ',['$RoomNum1','$housennum','$Groupid','$devicename']);
    print("master count_detail SH $x");
    return x.toList();
  }

  Future<List> DataFromMTRNumAndHNumGroupIdDetails1WithDN(String RoomNum1, String housennum, String hname, String Groupid, String dnum) async{
    var dbClient = await database;
    List<Map> x= await dbClient.rawQuery('SELECT * FROM MasterTable WHERE a=? AND de =? AND ea = ? AND d = ?',['$RoomNum1','$housennum', '$Groupid', '$dnum']);
    print("master count_details dn $x");
    return x.toList();
  }


  Future<int>GetSwitchCountWithRNAndHN(int RoomNum1, String housennum, String hname) async{

    var dbClient = await database;
    var x = await dbClient.rawQuery('SELECT COUNT (*) from SwitchBoardTable WHERE a=? AND de =? ',['$RoomNum1','$housennum']);
    int count = Sqflite.firstIntValue(x);
   // print(x);
  //  print(count);
    return count;

  }
  Future<int>getSwitchCountWithRNAndHNUser(int roomNum1, String houseNum, String hname,String dvnum) async{

    var dbClient = await database;
    var x = await dbClient.rawQuery('SELECT COUNT (*) from SwitchBoardTable WHERE a=? AND de =? AND d=? ',['$roomNum1','$houseNum','$dvnum']);
    int count = Sqflite.firstIntValue(x);
    return count;

  }
  Future<int>GetNumCountServerDetails() async{

    var dbClient = await database;
    var x = await dbClient.rawQuery('SELECT COUNT (*) from ServerDetails ');
    int count = Sqflite.firstIntValue(x);
    print(count);
    return count;

  }

  Future<List> DataFromMTRNumAndHNum(int RoomNum1, String housennum, String hname) async{

    var dbClient = await database;
    List<Map> x= await dbClient.rawQuery('SELECT * FROM MasterTable WHERE a=? AND de =? ',['$RoomNum1','$housennum']);
    return x.toList();
  }

  Future<List> dataFromMTRNumAndHNumUser(int roomNum1, String houseNum, String dvno) async{

    var dbClient = await database;
    List<Map> x= await dbClient.rawQuery('SELECT * FROM MasterTable WHERE a=? AND de =? AND d=? ',['$roomNum1','$houseNum','$dvno']);
    return x.toList();
  }

  Future<List> DataFromMTRNumAndHNumGroupId(int RoomNum1, String housennum, String hname, String DeviceType,String Dnum) async{

    var dbClient = await database;
    List<Map> x= await dbClient.rawQuery('SELECT * FROM MasterTable WHERE a=? AND de =? AND e = ? AND d = ?',['$RoomNum1','$housennum', '$DeviceType','$Dnum']);
    return x.toList();

  }

  Future<int>updateServerTableHName(String ip,String port,String ssid,String hname ) async {

    print("update servertable");
    var dbClient = await database;
    int res = await dbClient.rawUpdate(
        'UPDATE ServerTable SET  i = ? , p = ?, ss= ? WHERE dd = ? ',['$ip','$port','$ssid','$hname']);
    print("update servertable $res");
    return res;

  }

  Future<int>updateServerDetailsIp(String ip,String port,String ssid,String hname,int sId) async {

    var dbClient = await database;
    int res = await dbClient.rawUpdate(
        'UPDATE ServerDetails SET  dg = ?,pn = ? WHERE _id = ? ',['$ip','$port','$sId']);
    print("update serverdetails $res");
    return res;

  }

  Future<List>getSwitchBoardDateFromRNumAndHNum(String rnum, String hnum,String hname)async{
    var dbClient = await database;

    List<Map> result = await dbClient.rawQuery('SELECT * FROM SwitchBoardTable WHERE a = ? AND de = ?',['$rnum','$hnum']);
    return result.toList();

  }

  Future<List>getSwitchBoardDateFromRNumAndHNumUser(String rnum, String hnum,String hname,String dvnum)async{
    var dbClient = await database;

    List<Map> result = await dbClient.rawQuery('SELECT * FROM SwitchBoardTable WHERE a = ? AND de = ? AND d = ? ',['$rnum','$hnum','$dvnum']);
    return result.toList();

  }


  Future<List>getServerDetailsDataWithADN(String usertype,String hname)async{

    print("serverDetailswithid");
    var dbClient = await database;
    var result= await dbClient.rawQuery('SELECT * FROM ServerDetails WHERE da = ?',[usertype]);
    print(result);
    return result.toList();
  }


  Future<List>getSwitchBoardDateFromRNumAndHNumWithDN(String rnum,  String hnum,String dnum,String hname)async{
    var dbClient = await database;
    //print("iam swbs data: ${await dbClient.rawQuery('SELECT * FROM SwitchBoardTable WHERE a = ? AND de = ? AND d= ?',['$rnum','$hnum','$dnum'])}");
    List<Map> result = await dbClient.rawQuery('SELECT * FROM SwitchBoardTable WHERE a = ? AND de = ? AND d= ?',['$rnum','$hnum','$dnum']);
    return result.toList();

  }


  //adding the username like guest,admin,user to server details table

  Future<int>addserverdetailsuser(String password,String username,String usertype)async{

    final key = Key1.fromUtf8('edisonbrosmartha');
    final iv = IV.fromUtf8('AAAAAAAAAAAAAAAA');

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(password, iv: iv);

    var dbClient = await database;
    var i = await dbClient.rawInsert(
        "INSERT INTO ServerDetails (ps,un,da)"
            'VALUES (?,?,?)',[encrypted.bytes,username,usertype]);

    print(i);

    return i;

  }


  Future<int>adduserdetailstouser(String username,String usertype)async{

    String roomno="";

    var dbClient = await database;
    var i = await dbClient.rawInsert("INSERT INTO UserTable (un,rns)"'VALUES (?,?)',[username,roomno]);

    print(i);

    return i;

  }

  Future<int>updateuserdetailstouser(String username,String setOfRooms,String setOfDevices)async{

    var dbClient = await database;
    int res = await dbClient.rawUpdate(
        'UPDATE UserTable SET  rns = ?,ea = ? WHERE un = ? ',['$setOfRooms','$setOfDevices','$username']);
    print("update usertable $res");
    return res;

  }

  Future<List>getRnumSwitchBoardData(String hnum,String hname,String deviceno)async{

    var dbClient = await database;
    //print("iam swbs data: ${await dbClient.rawQuery('SELECT * FROM SwitchBoardTable WHERE a = ? AND de = ? AND d= ?',['$rnum','$hnum','$dnum'])}");
    List<Map> result = await dbClient.rawQuery('SELECT * FROM SwitchBoardTable WHERE de = ? AND d= ?',['$hnum','$deviceno']);
    return result.toList();

  }

  Future<List>getRnumMasterTableData(String hnum,String hname,String deviceno)async{
    var dbClient = await database;
    //print("iam swbs data: ${await dbClient.rawQuery('SELECT * FROM SwitchBoardTable WHERE a = ? AND de = ? AND d= ?',['$rnum','$hnum','$dnum'])}");
    List<Map> result = await dbClient.rawQuery('SELECT * FROM MasterTable WHERE de = ? AND d= ?',['$hnum','$deviceno']);
    return result.toList();
  }

  Future<List>getUserDataWithUName(String username)async{
    var dbClient = await database;

    List<Map> result = await dbClient.rawQuery('SELECT * FROM UserTable WHERE un = ? ',['$username']);
    return result.toList();
  }

  Future<int> deleteServerDetailsUser(String uName) async {
    var dbClient = await database;
    int res = await dbClient.rawDelete('DELETE FROM ServerDetails WHERE un = ?',['$uName']);
    return res;
  }
  Future<int> deleteuserTable(String uName) async {
    var dbClient = await database;
    int res = await dbClient.rawDelete('DELETE FROM UserTable WHERE un = ?',['$uName']);
    return res;
  }

  Future<int> deleteSW(int roomnumber) async {
    var dbClient = await database;
    int res = await dbClient.rawDelete('DELETE FROM SwitchBoardTable WHERE a = ?',['$roomnumber']);
    return res;
  }
  Future<int> deleteMas(int roomnumber) async {

    var dbClient = await database;
    int res = await dbClient.rawDelete('DELETE FROM MasterTable WHERE a = ?',['$roomnumber']);
    return res;
  }

  Future<int> deleteSWdevice(int devicenumber) async {
    var dbClient = await database;
    int res = await dbClient.rawDelete('DELETE FROM SwitchBoardTable WHERE d = ?',['$devicenumber']);
    return res;
  }

  Future<int> deleteMasdevice(int devicenumber) async {
    var dbClient = await database;
    int res = await dbClient.rawDelete('DELETE FROM MasterTable WHERE d = ?',['$devicenumber']);
    return res;
  }

  Future<int>updateSwitchBoardTableRName(String hname,String hnum,String rnum, String rnameedit ) async {
    var dbClient = await database;
    int res = await dbClient.rawUpdate(
        'UPDATE SwitchBoardTable SET  b = ? WHERE a = ? ',['$rnameedit','$rnum']);
    print("update Swtable $res");
    return res;
  }

  Future<int>updateMasterTableRName(String hname,String hnum,String rnum, String rnameedit) async {
    var dbClient = await database;
    int res = await dbClient.rawUpdate(
        'UPDATE MasterTable SET  b = ? WHERE a = ? ',['$rnameedit','$rnum']);
    print("update Mastertable $res");
    return res;
  }

  Future<int>updateSWTableIcon(String hname,String hnum,String rnum, String devicenum,Map details ) async {

    print("table $details");
    String ubi1=details["bi1"];
    String ubi2=details["bi2"];
    String ubi3=details["bi3"];
    String ubi4=details["bi4"];
    String ubi5=details["bi5"];
    String ubi6=details["bi6"];
    String ubi7=details["bi7"];
    String ubi8=details["bi8"];

    var dbClient = await database;
    int res = await dbClient.rawUpdate(
        'UPDATE SwitchBoardTable SET  bi1 = ? , bi2 = ? , bi3 = ? , bi4 = ? , bi5 = ? , bi6 = ? , bi7 = ? , bi8 = ?  WHERE a = ? AND de = ? AND d = ? ',['$ubi1','$ubi2','$ubi3','$ubi4','$ubi5','$ubi6','$ubi7','$ubi8','$rnum','$hnum','$devicenum']);
    return res;
  }

}






