import 'package:flutter/material.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/Bell/bell.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/Singleton.dart';
import 'package:smart_home/GlobalService.dart';

class BellIViewState extends StatefulWidget {

  @override
  _BellIViewState createState() => _BellIViewState();

}

class _BellIViewState extends State<BellIViewState> {

  GlobalService _globalService = GlobalService();

  var s=Singleton();

  String hnameBell,hnumBell,rnumBell,dnumBell,rnameBell,groupIdBell,dtypeBell;
  String devicename="name";
  String status="OFF";
  Color colorBoth;
  Color colorOn=Colors.green,colorOff=Colors.red;

  @override
  void initState() {

    super.initState();

    colorBoth=colorOff;

    FNC.DartNotificationCenter.unregisterChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'MasterNotification', onNotification: (options) {
      print('BellNotified: $options');
      bellResponce(options);
    }, observer: null);
    // TODO: implement initState

    hnameBell = hnameB;
    hnumBell = hnumB;
    rnumBell = rnumB;
    dnumBell = dnumB;
    rnameBell = rnameB;
    groupIdBell = groupIdB;
    dtypeBell = dtypeB;

    bellDetails();
  }

  bellResponce(String notification) {
    print("Cur $Notification");
    String cDev = dnumBell.padLeft(4, '0');
    String rDev = notification.substring(4, 8);

    if (cDev==(rDev)) {
      String state = notification.substring(8,10);
      if(state==("01")){
        setState(() {
          status="ON";
          colorBoth=colorOn;
        });
      }
      else if(state==("02")){
        setState(() {
          status="OFF";
          colorBoth=colorOff;
        });
      }


    }
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

  bellDetails(){
    details();
  }

  void details()async{

    DBHelper dbHelper;
    dbHelper = DBHelper();

    List result = await dbHelper.getLocalDateHName(hnameBell);
    String userAdmin = result[0]['lg'];
    print(userAdmin);

    List bellData = await DBProvider.db.DataFromMTRNumAndHNumGroupIdDetails1WithDN(rnumBell, hnumBell, hnameBell, groupIdBell, dnumBell);
    devicename = bellData[0]['ec'];
    _globalService.devicenameset=devicename;

    setState(() {
      devicename=devicename;
    });

    socketsend();
  }

  socketsend(){

    if(s.socketconnected == true){
      sendDataBell(senddata: "920",castType: "01");
    }
    else{
      s.checkindevice(hnameBell,hnumBell);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Expanded(
                    child: IconButton(
                      iconSize: MediaQuery.of(context).size.width/10,
                      splashRadius: 0.1,
                      splashColor:Colors.transparent,
                      icon:Image.asset('images/switchicons/all_on.png'),
                      onPressed: () {
                        sendDataBell(senddata: "201",castType: "01");
                      },
                    ),
                  ),
                  Expanded(
                  child:Center(
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        devicename,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ),
                  ),
                  Expanded(
                    child: IconButton(
                      iconSize: MediaQuery.of(context).size.width/10,
                      splashRadius: 0.1,
                      splashColor:Colors.transparent,
                      icon:Image.asset('images/switchicons/all_off.png'),
                      onPressed: () {
                        sendDataBell(senddata: "301",castType: "01");
                      },
                    ),
                  ),

                ],
              ),

              Row(

                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Expanded(
                    child:Center(
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          status,
                          style: TextStyle(
                              color: colorBoth,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal
                          ),
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ),

                ],

              ),
              Row(

                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Expanded(
                    child: IconButton(
                      iconSize: MediaQuery.of(context).size.width/10,
                      splashRadius: 0.1,
                      splashColor:Colors.transparent,
                      icon:Image.asset('images/gridicons/bell02.png'),
                      onPressed: () {
                        sendDataBell(senddata: "101",castType: "01");
                      },
                    ),
                  ),

                  ],

              ),

              Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width/25),),
              Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width/25),),

            ],
          ),
        ),
      ),
    );
  }

  void sendDataBell({String senddata, String castType}) {

    String cast1 = castType;
    String gI = groupIdBell;
    String c = dnumBell.padLeft(4, '0');
    String rN = rnumBell.padLeft(2, '0');
    String chr = senddata;
    String cE = "000000000000000";

    String a="0";
    String sData = '*' + a + cast1 + gI + c + rN + chr + cE + '#';
    print("Sending String is : $sData"); // input is : *001000000102920000000000000000# output is : 003300010100FFFFFFFFA120F001B3

    if(s.socketconnected == true){
      s.socket1(sData);
    }
    else{

    }

  }







}