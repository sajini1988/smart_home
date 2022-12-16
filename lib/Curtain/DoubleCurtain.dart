import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/Singleton.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:smart_home/Curtain/CurtainLayout.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:smart_home/GlobalService.dart';

class DoubleCurtain extends StatefulWidget {
  DoubleCurtain({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<DoubleCurtain> {

  GlobalService _globalService = GlobalService();

  var s = Singleton();
  Image open=Image.asset('images/Curtain/open.png');
  Image open01=Image.asset('images/Curtain/open01.png');

  Image close=Image.asset('images/Curtain/close.png');
  Image close01=Image.asset('images/Curtain/close01.png');

  Image stop=Image.asset('images/Curtain/stop.png');
  Image stop01=Image.asset('images/Curtain/stop01.png');

  bool sheerchangeopen=false;
  bool sheerchangeclose=false;
  bool sheerchangestop=false;

  bool curtainchangeopen=false;
  bool curtainchangeclose=false;
  bool curtainchangestop=false;

  bool bothopen   = false;
  bool bothclose  = false;
  bool bothstop   = false;

  bool sheeropen  = false;
  bool sheerclose = false;
  bool shherstop  = false;

  bool sheerlabel = false;
  bool bothlabel  = false;

  String devicename ="name";
  String hnamedcur,hnumdcur,rnumdcur,dnumdcur,rnamedcur,groupIddcur,dnumsheer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );

    FNC.DartNotificationCenter.unregisterChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'MasterNotification', onNotification: (options) {
      print('CurdNotified: $options');
      curResponce(options);

    }, observer: null);

    hnamedcur=hnamec;
    hnumdcur=hnumc;
    rnamedcur=rnamec;
    dnumdcur=dnumc;
    rnumdcur=rnumc;
    groupIddcur=groupIdc;
    dnumsheer=devinumsh;

    if(dnumsheer.contains("0000")){

       bothopen   = false;
       bothclose  = false;
       bothstop   = false;

       sheeropen  = false;
       sheerclose = false;
       shherstop  = false;

       sheerlabel = false;
       bothlabel  = false;
    }
    else{

      bothopen   = true;
      bothclose  = true;
      bothstop   = true;

      sheeropen  = true;
      sheerclose = true;
      shherstop  = true;

      sheerlabel = true;
      bothlabel  = true;
    }
   // print("curname is $hname_dcur,$hnum_dcur,$rnum_dcur,$dnum_dcur,$rname_dcur,$GroupId_dcur,$dnum_sheer");
    curDetails();
  }
  curDetails(){
    details();
  }
  details()async{

    DBHelper dbHelper;
    dbHelper = DBHelper();
   // print("name is $hname_dcur,$hnum_dcur,$rnum_dcur,$dnum_dcur,$rname_dcur,$GroupId_dcur,$dnum_sheer");

    List result=await dbHelper.getLocalDateHName(hnamedcur);
    String userAdmin=result[0]['lg'];


    List curdata = await DBProvider.db.DataFromMTRNumAndHNumGroupIdDetails1WithDN(rnumdcur, hnumdcur, hnamedcur, groupIddcur, dnumdcur);
    devicename = curdata[0]['ec'];

    _globalService.devicenameset=devicename;

    setState(() {
      devicename=devicename;
    });

    socketsend();
  }

  socketsend(){

    if(s.socketconnected == true) {
      sendDataCur(senddata: "920", castType: "01" , devinum: dnumdcur);
      Timer(Duration(seconds:1), () {
        sendDataCur(senddata: "920", castType: "01" , devinum: dnumsheer);
      });
    }
    else{
      s.checkindevice(hnamedcur, hnumdcur);
    }

  }

  void sendDataCur({String senddata, String castType, String devinum}) {

    String cast1 = castType;
    String gI = groupIddcur;
    String c = devinum.padLeft(4, '0');
    String rN = rnumdcur.padLeft(2, '0');
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

  curResponce(String notification) {
    print("Cur $notification");

    String devcur = dnumdcur.padLeft(4, '0');
    String devcursh = dnumsheer.padLeft(4,'0');
    String rdev = notification.substring(4, 8);

    if (rdev.contains(devcur)) {

      String state = notification.substring(8,10);
      if(state.contains("01")){

        setState(() {
          curtainchangeopen=true;
          curtainchangestop=false;
          curtainchangeclose=false;
        });

      }
      else if(state.contains("02")){
        setState(() {
          curtainchangeopen=false;
          curtainchangestop=false;
          curtainchangeclose=true;
        });
      }
      else if(state.contains("03")){
        setState(() {
          curtainchangeopen=false;
          curtainchangestop=true;
          curtainchangeclose=false;
        });
      }

    }
    else if (rdev.contains(devcursh)) {

      String state = notification.substring(8,10);
      if(state.contains("01")){

        setState(() {
          sheerchangeopen=true;
          sheerchangestop=false;
          sheerchangeclose=false;
        });

      }
      else if(state.contains("02")){
        setState(() {
          sheerchangeopen=false;
          sheerchangestop=false;
          sheerchangeclose=true;
        });
      }
      else if(state.contains("03")){
        setState(() {
          sheerchangeopen=false;
          sheerchangestop=true;
          sheerchangeclose=false;
        });
      }

    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column   (
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child:
                        Text(devicename, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontStyle: FontStyle.normal), maxLines: 2,
                        ),
                        )
                      ),
                ],
              ),
              Padding(padding: const EdgeInsets.all(10.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child:Visibility(
                      visible: bothlabel,
                      child: Text("Both")

                      ),
                  ),
                ],
              ),
              Padding(padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Transform.scale(
                      scale: 2.0,
                      child:Visibility(
                        visible: bothopen,
                        child: IconButton(
                            iconSize: MediaQuery.of(context).size.width/10,
                            icon: Image.asset('images/Curtain/open.png',
                            fit: BoxFit.cover),
                            onPressed: () {
                              sendDataCur(senddata: "105", castType: "01", devinum: dnumsheer);
                              Timer(Duration(seconds:1), () {
                                sendDataCur(senddata: "101", castType: "01", devinum: dnumdcur);
                              });
                            }),
                      ),
                    ),
                    Transform.scale(
                      scale: 2.0,
                      child:Visibility(
                        visible: bothstop,
                        child: IconButton(
                            iconSize: MediaQuery.of(context).size.width/10,
                            icon: Image.asset('images/Curtain/stop.png',
                            fit: BoxFit.cover),
                            onPressed: () {
                              sendDataCur(senddata: "107", castType: "01",devinum: dnumsheer);
                              Timer(Duration(seconds:1), () {
                                sendDataCur(senddata: "103", castType: "01", devinum: dnumdcur);
                              });
                              },
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 2.0,
                      child:Visibility(
                        visible: bothclose,
                        child: IconButton(
                          icon: Image.asset(
                            'images/Curtain/close.png',
                            fit: BoxFit.cover),
                            onPressed: () {
                              sendDataCur(senddata: "106", castType: "01",devinum: dnumsheer);
                              Timer(Duration(seconds:1), () {
                                sendDataCur(senddata: "102", castType: "01", devinum: dnumdcur);
                              });
                            },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child:Visibility(
                        visible: sheerlabel,
                        child: Text("Sheer")
                    )
                  ),
                ],
              ),
              Padding(padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Transform.scale(
                      scale: 2.0,
                      child:Visibility(
                        visible:sheeropen ,
                        child: IconButton(
                            iconSize: MediaQuery.of(context).size.width/10,
                            icon: sheerchangeopen?open01:open,
                            splashRadius: 0.1,
                            splashColor:Colors.transparent ,
                            onPressed: () {
                              sendDataCur(senddata: "105", castType: "01",devinum: dnumsheer);
                            }
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 2.0,
                      child:Visibility(
                        visible: shherstop,
                        child: IconButton(
                            iconSize: MediaQuery.of(context).size.width/10,
                            icon: sheerchangestop?stop01:stop,
                            splashRadius: 0.1,
                            splashColor:Colors.transparent ,
                            onPressed: () {
                              sendDataCur(senddata: "107", castType: "01",devinum: dnumsheer);
                            }
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 2.0,
                      child:Visibility(
                        visible: sheerclose,
                        child: IconButton(
                            iconSize: MediaQuery.of(context).size.width/10,
                            icon: sheerchangeclose?close01:close,
                            splashRadius: 0.1,
                            splashColor:Colors.transparent ,
                            onPressed: () {
                              sendDataCur(senddata: "106", castType: "01",devinum: dnumsheer);
                            }
                        ),
                      ),
                    ),
                  ],

                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Curtain")
                ],
              ),
              Padding(padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Transform.scale(
                      scale: 2.0,
                      child: IconButton(
                          iconSize: MediaQuery.of(context).size.width/10,
                          icon: curtainchangeopen?open01:open,
                          splashRadius: 0.1,
                          splashColor:Colors.transparent ,
                          onPressed: () {
                            sendDataCur(senddata: "101", castType: "01",devinum: dnumdcur);
                          }
                      ),
                    ),
                    Transform.scale(
                      scale: 2.0,
                      child: IconButton(
                          iconSize: MediaQuery.of(context).size.width/10,
                          icon: curtainchangestop?stop01:stop,
                          splashRadius: 0.1,
                          splashColor:Colors.transparent ,
                          onPressed: () {
                            sendDataCur(senddata: "103", castType: "01",devinum: dnumdcur);
                          }

                      ),
                    ),
                    Transform.scale(
                      scale: 2.0,
                      child: IconButton(
                          iconSize: MediaQuery.of(context).size.width/10,
                          icon: curtainchangeclose?close01:close,
                          splashRadius: 0.1,
                          splashColor:Colors.transparent ,
                          onPressed: () {
                            sendDataCur(senddata: "102", castType: "01",devinum: dnumdcur);
                          }
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
