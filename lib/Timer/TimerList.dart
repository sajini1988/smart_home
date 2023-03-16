import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home/Singleton.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/HouseSettings/OperatorSettings/deleteRoomModelClass.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:smart_home/Timer/TimerDB.dart';
import 'package:smart_home/Timer/GlobalEditTimerListdata.dart';
import 'package:smart_home/Timer/EditTimer_Popup.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;

import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/Timer/RGBTimer.dart';

class TimerList extends StatefulWidget{
  @override
  _TimerListState createState() => _TimerListState();
}

class _TimerListState extends State<TimerList>{

  var s=Singleton();
  GlobalService _globalService = GlobalService();
  GlobalEdittimer _globalServiceEditTimer = GlobalEdittimer();
  String hname,hnum,rname,rnum,username;
  DBHelper dbHelper;

  String imgs = "disconnected";
  String imgn = "nonet";
  String options1="No_net";
  List result=[];
  Future<List>rooms;
  List<DeleteRoom>userdefinedrooms;
  List<DropdownMenuItem<int>> _menuItems;
  int _value=0;

  bool circularindicator=false;


  @override
  void initState(){
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );


    FNC.DartNotificationCenter.unregisterChannel(channel: 'deleteSuccess');
    FNC.DartNotificationCenter.registerChannel(channel: 'deleteSuccess');
    FNC.DartNotificationCenter.subscribe(channel: 'deleteSuccess', onNotification: (options) {
      gettimerdata();
      }, observer: null);

    FNC.DartNotificationCenter.unregisterChannel(channel: 'deleteError');
    FNC.DartNotificationCenter.registerChannel(channel: 'deleteError');
    FNC.DartNotificationCenter.subscribe(channel: 'deleteError', onNotification: (options) {
      gettimerdata();
    }, observer: null);

    FNC.DartNotificationCenter.unregisterChannel(channel: 'updateSuccess');
    FNC.DartNotificationCenter.registerChannel(channel: 'updateSuccess');
    FNC.DartNotificationCenter.subscribe(channel: 'updateSuccess', onNotification: (options) {
     gettimerdata();
    }, observer: null);

    FNC.DartNotificationCenter.unregisterChannel(channel: 'updateFailure');
    FNC.DartNotificationCenter.registerChannel(channel: 'updateFailure');
    FNC.DartNotificationCenter.subscribe(channel: 'updateFailure', onNotification: (options) {
      gettimerdata();
    }, observer: null);

    FNC.DartNotificationCenter.unregisterChannel(channel: 'timerlistupdate');
    FNC.DartNotificationCenter.registerChannel(channel: 'timerlistupdate');
    FNC.DartNotificationCenter.subscribe(channel: 'timerlistupdate', onNotification: (options) {
      recieveddata();
    }, observer: null);

    hname=_globalService.hname;
    hnum=_globalService.hnum;
    rname=_globalService.rname;
    rnum=_globalService.rnum;
    _value=int.parse(rnum);

    getrooms();
    gettimerdata();
  }

  gettimerdata()async {
    rnum = rnum.padLeft(2, '0');

    if(s.socketconnected==true){
      s.socket1('\$125&');
      setState(() {
        circularindicator=true;
        circularindicator=true;
      });
    }
    else if(s.socketconnected == false){
      setState(() {
        circularindicator=false;
      });
      fluttertoast("Not Connected");
    }
  }

  recieveddata(){

    TimerDBProvider.db.close();

    Timer(Duration(seconds: 3
    ), () async {

        circularindicator=false;
        TimerDBProvider.tdbname = hname;

        List result1 = await TimerDBProvider.db.getdetailsoftimer(rnum);

        result = result1;
        print("result is $result");

        setState(() {
          result=result;
        });

      }
    );


  }

  Future<List> functiongetlist() async {
    rooms = rooms;
    return rooms;
  }

  getrooms()async{

    rooms=DBProvider.db.comlist();
    functiongetlist().then((List value) {
      userdefinedrooms=[];
      if(value.length>0){
        userdefinedrooms.add(DeleteRoom(rnumber: 0, rname: "Select Room"));
        for (int i = 0; i < value.length; i++) {
          userdefinedrooms.add(DeleteRoom(rnumber: value[i]['a'], rname: value[i]['b']));
        }
      }
      for(int i=0;i<userdefinedrooms.length;i++){
        //print(userdefinedrooms[i].rnumber);
       // print(userdefinedrooms[i].rname);
      }

      _menuItems = List.generate(userdefinedrooms.length, (i) => DropdownMenuItem(
          value: userdefinedrooms[i].rnumber,
          child: Center(
            child:Padding(
              padding: const EdgeInsets.all(0.0),
              child: Text("${userdefinedrooms[i].rname}-${userdefinedrooms[i].rnumber.toString()}",style: TextStyle(
              color: Colors.black,
             // backgroundColor: Color.fromRGBO(66, 130, 208, 1),
                )
              ),
            )
          )
      )
      );
      setState(() {
        _menuItems=_menuItems;

      });
    });

  }
  SingleChildScrollView dataBody() {
    return SingleChildScrollView( // horizontal scroll widget
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView( // vertical scroll widget
            scrollDirection: Axis.vertical,
            child: DataTable(
              //headingRowColor: MaterialStateColor.resolveWith((states) => Colors.),
              headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(66, 130, 208, 1)),
              columnSpacing: 0,
              border: TableBorder.all(
                width: 1.0,color:Colors.black,
              ),
              dividerThickness:1,
              columns: [
                DataColumn(
                    label:Center(child: Text('No  '))
                ),
                //  DataColumn(label: _verticalDivider),

                DataColumn(
                  label: Center(child: Text('  DeviceName  ')),
                ),
                //  DataColumn(label: _verticalDivider),

                DataColumn(
                  label: Center(child: Text('  Switch  ')),
                ),
                //DataColumn(label: _verticalDivider),

                DataColumn(
                  label: Center(child: Text('  OTime  ')),
                ),
                //DataColumn(label: _verticalDivider),

                DataColumn(
                  label: Center(child: Text('  OffTime  ')),
                ),
                // DataColumn(label: _verticalDivider),

                DataColumn(
                  label: Center(child: Text('  Type  ')),
                ),
                //DataColumn(label: _verticalDivider),

                DataColumn(
                  label: Center(child: Text('  DevType  ')),
                ),

                DataColumn(
                  label: Center(child: Text('  Devno  ')),
                ),
                // DataColumn(label: _verticalDivider),

                DataColumn(
                  label: Center(child: Text('  User  ')),
                ),

                DataColumn(
                  label: Center(child: Text('  Rno  ')),
                ),

                DataColumn(
                  label: Center(child: Text('  Delete  ')),
                ),

                DataColumn(
                  label: Center(child: Text('  Edit  ')),
                ),
                // DataColumn(label: _verticalDivider),
              ].toList(),
                rows: List.generate(result.length, (index) {

                  String type="";

                 // ((weeknumber.toString()).length) == 1 ? ("0" +
                     // weeknumber.toString()) : weeknumber.toString();
                  String t3=(result[index]["t3"].toString().length)==1?(result[index]["t3"].toString()):"0";
                  String t4=(result[index]["t4"].toString().length)==1?(result[index]["t4"].toString()):"0";

                  print("t3$t3");
                  print("T4$t4");

                  if(t3=="0" && t4=="0"){
                    type="Cyclic";
                  }
                  else{
                    if(t3 == "1"){
                      type="Days";
                    }else if(t4 == "1"){
                      type="Date";
                    }
                  }

                  print("type $type");


                  int slno = index+1;
                  String no = slno.toString();
                  String devicename = result[index]["eb"];
                  String switchno = result[index]["swno"].toString();
                  String username = result[index]["ec"];
                  String deviceID = result[index]["f"];
                  String dvno = result[index]["d"].toString();
                  String devtype= result[index]["dn"];
                  String devtypenum = result[index]["c"];
                  String roomno = result[index]["ea"];

                  String fromTime,toTime,d1,d2,d3,d4,d5,d6,d7,days,date,ds,dso,wd,ontime,offtime;
                  if(type == "Cyclic"){

                    fromTime = result[index]["st"];
                    toTime = result[index]["et"];

                    days="0";
                    date=result[index]["opd"];

                    ds = result[index]["ds1"];
                    dso = result[index]["ds2"];
                    wd="0";

                    ontime=result[index]["oni"];
                    offtime=result[index]["ofi"];

                  }
                  else if(type == "Days" || type == "Date"){

                    fromTime = result[index]["b"];
                    toTime = result[index]["bo"];

                    d1=result[index]["d1"].toString();
                    d2=result[index]["d2"].toString();
                    d3=result[index]["d3"].toString();
                    d4=result[index]["d4"].toString();
                    d5=result[index]["d5"].toString();
                    d6=result[index]["d6"].toString();
                    d7=result[index]["d7"].toString();

                    days=d1+","+d2+","+d3+","+d4+","+d5+","+d6+","+d7;
                    date=result[index]["a"];

                    ds = result[index]["ds"];
                    dso = result[index]["dso"];
                    wd=result[index]["wd"].toString();

                  }


                  return DataRow(cells: [
                    DataCell(Container(child: Center(child: Text(no)))),
                    DataCell(Container(child: Center(child: Text(devicename)))),
                    DataCell(Container(child: Center(child: Text(switchno)))),
                    DataCell(Container(child: Center(child: Text(fromTime)))),
                    DataCell(Container(child: Center(child: Text(toTime)))),
                    DataCell(Container(child: Center(child: Text(type)))),
                    DataCell(Container(child: Center(child: Text(devtype)))),
                    DataCell(Container(child: Center(child: Text(dvno)))),
                    DataCell(Container(child: Center(child: Text(username)))),
                    DataCell(Container(child: Center(child: Text(roomno)))),
                    DataCell(
                      IconButton(icon: Icon(Icons.delete,color:Color.fromRGBO(66, 130, 208, 1)),
                        onPressed: () {

                          String t3=(result[index]["t3"].toString().length)==1?(result[index]["t3"].toString()):"0";
                          String t4=(result[index]["t4"].toString().length)==1?(result[index]["t4"].toString()):"0";

                          print("t3$t3");
                          print("T4$t4");

                          if(t3=="0" && t4=="0"){
                            type="Cyclic";
                          }
                          else{
                            if(t3 == "1"){
                              type="Days";
                            }else if(t4 == "1"){
                              type="Date";
                            }
                          }

                          print(type);

                          if(type == "Cyclic"){

                            String fromTimecyc = result[index]["st"];
                            String toTimecyc = result[index]["et"];
                            String switchnocyc = result[index]["swno"].toString();
                            String dvnocyc = result[index]["d"].toString();

                            String send = '['+fromTimecyc+','+toTimecyc+','+dvnocyc+','+switchnocyc+'\$';
                            print(send);

                            if(s.socketconnected == true){
                              showAlertDialogdeletetimer(context, send);
                            }
                            else{
                              fluttertoast("Socket not connected");
                            }

                          }
                          else{

                            String fromTimerep = result[index]["b"];
                            String toTimerep = result[index]["bo"];
                            String switchnorep = result[index]["swno"].toString();
                            String dvnorep = result[index]["d"].toString();

                            String send = '['+fromTimerep+','+toTimerep+','+dvnorep+','+switchnorep+'@';
                            print(send);

                            if(s.socketconnected == true){
                              showAlertDialogdeletetimer(context, send);
                            }
                            else{
                              fluttertoast("Socket not connected");
                            }

                          }
                        },
                      ),
                    ),
                    DataCell(
                      IconButton(icon: Icon(Icons.edit,color: Color.fromRGBO(66, 130, 208, 1),),
                        onPressed: () {


                          _globalServiceEditTimer.roomnoset=rnum;
                          _globalServiceEditTimer.operatedTypeset=type;
                          _globalServiceEditTimer.dvnumset=dvno;
                          _globalServiceEditTimer.devicetypeset=devtype;
                          _globalServiceEditTimer.devicetypenumset=devtypenum;
                          _globalServiceEditTimer.switchnumberset=switchno;
                          _globalServiceEditTimer.repeatweeklyset=wd;
                          _globalServiceEditTimer.devicenameset=devicename;
                          _globalServiceEditTimer.userset=username;
                          _globalServiceEditTimer.hnameset=hname;
                          _globalServiceEditTimer.hnumset=hnum;
                          _globalServiceEditTimer.deviceIDset=deviceID;
                          _globalServiceEditTimer.ondataset=ds;
                          _globalServiceEditTimer.offdataset=dso;
                          _globalServiceEditTimer.fromtimeset=fromTime;
                          _globalServiceEditTimer.totimeset=toTime;
                          _globalServiceEditTimer.dayssuset=days;
                          _globalServiceEditTimer.dateset=date;
                          _globalServiceEditTimer.ontimeset=ontime;
                          _globalServiceEditTimer.offtimeset=offtime;

                          showDialog(
                            barrierColor: Colors.black26,
                            context: context,
                            builder: (context) {
                              return EditTimerPage();
                            },
                          );


                          // AlertDialog alert = AlertDialog(
                          //
                          //     elevation:0,
                          //     titlePadding: EdgeInsets.zero,
                          //     contentPadding: EdgeInsets.zero,
                          //     clipBehavior:Clip.antiAliasWithSaveLayer,
                          //     insetPadding: EdgeInsets.all(25.0),
                          //     shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),
                          //
                          //     title: Text(""),
                          //     content: Container(
                          //       width: MediaQuery.of(context).size.width,
                          //       color: Colors.white,
                          //       child:EditTimerPage(),
                          //     ),
                          //     backgroundColor: Colors.white,
                          //     actions: [
                          //
                          //     ],
                          //   );
                          //   showDialog(context: context, builder: (BuildContext context){
                          //       return alert;
                          //     }
                          //   );

                            },
                          ),
                        ),
                  ]
                  );
                }).toList(),
            )
        ));
  }

  showAlertDialogdeletetimer(BuildContext context,String data) {

    // Create button
    Widget yesButton = TextButton(
      child: Text("Yes"),
      onPressed: () {

        Navigator.of(context,rootNavigator: true).pop();
        if(s.socketconnected==true){
          s.socket1(data);
        }
        else{
          fluttertoast("Socket not Connected");
        }

      },
    );

    Widget noButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context,rootNavigator: true).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("Do you want to Delete the timer Selected "),
      actions: [
        yesButton,
        noButton
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(onWillPop: () async {
      return Navigator.canPop(context);
      }, child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 40,
          backgroundColor: Color.fromRGBO(66, 130, 208, 1),
          title: Text('Timer List',style:TextStyle(fontSize: 18)),
          actions: <Widget>[
          ],
        ),
        backgroundColor: Colors.white10,
        body: Center(
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

              Expanded(


                flex:1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    MaterialButton(
                      padding: EdgeInsets.all(8.0),
                      textColor: Colors.white,
                      // splashColor: Colors.greenAccent,
                      elevation: 8.0,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('images/Moods/save_button.png'),
                              fit: BoxFit.cover),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("DELETE ALL"),
                        ),
                      ),
                      // ),
                      onPressed: () {

                        showAlertDialogdeleteAll(context);
                      },
                    ),
                  ],
                )
              ),
              Expanded(
                flex:1,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                            DropdownButton<int>(
                              hint: Text(rname,style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                            items: _menuItems,
                            value: _value,
                            onChanged: (value){
                              _value=value;
                              rnum=value.toString();
                              print(rnum);
                              gettimerdata();
                            },
                          ),
                        //)
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Visibility(
                    visible: circularindicator,
                      child:Center(child: CircularProgressIndicator()
                      )
                  ),
                ),
                Expanded(
                  flex:6,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 5),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        Expanded(
                          child:Padding(padding: const EdgeInsets.all(0.0),
                            child: Container(
                                child: dataBody(),
                              ),
                          ),
                        ),

                      ]
                    ),
                  )
                ),
                Expanded(
                  flex:1,
                  child: Container(),
                )
              ],
            ),
          ),
        ),

      )
    );
  }

  fluttertoast(String message){

    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
    );

  }

  showAlertDialogdeleteAll(BuildContext context){

    // Create button
    Widget yesButton = TextButton(
      child: Text("Yes",style: TextStyle(color: Color.fromRGBO(66, 130, 208, 1)),),
      onPressed: () {
            Navigator.pop(context);
            String rN = rnum.padLeft(2,'0');
            String send = "["+rN+"&";
            s.socket1(send);
        },
    );

    Widget noButton = TextButton(
      child: Text("No",style: TextStyle(color: Colors.red),),
      onPressed: () {
          Navigator.pop(context);
        },
    );


    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("Do u want to Delete All the Timers of Room Selected??"),
      actions: [

        noButton,
        yesButton

      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,

      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}


