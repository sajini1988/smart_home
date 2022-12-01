import 'package:flutter/material.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/Singleton.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:smart_home/Curtain/CurtainLayout.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:smart_home/GlobalService.dart';

class SingleCurtain extends StatefulWidget {
  SingleCurtain({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _SingleCurtainState createState() => _SingleCurtainState();
}

class _SingleCurtainState extends State<SingleCurtain> {

  GlobalService _globalService = GlobalService();
  var s = Singleton();

  Image open=Image.asset('images/Curtain/open.png');
  Image open01=Image.asset('images/Curtain/open01.png');

  Image close=Image.asset('images/Curtain/close.png');
  Image close01=Image.asset('images/Curtain/close01.png');

  Image stop=Image.asset('images/Curtain/stop.png');
  Image stop01=Image.asset('images/Curtain/stop01.png');

  bool openChange = false;
  bool closeChange = false;
  bool stopChange = false;

  String devicename = "name";
  String hnameSCur,hnumSCur,rnumSCur,dnumSCur,rnameSCur,groupIdSCur;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FNC.DartNotificationCenter.unregisterChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'MasterNotification', onNotification: (options) {
      print('CursNotified: $options');
      curResponce(options);

    }, observer: null);

    hnameSCur=hnamec;
    hnumSCur=hnumc;
    rnameSCur=rnamec;
    dnumSCur=dnumc;
    rnumSCur=rnumc;
    groupIdSCur=groupIdc;

    curDetails();
  }

  curDetails(){
    details();
  }

  details() async {

    DBHelper dbHelper;
    dbHelper = DBHelper();

    List result=await dbHelper.getLocalDateHName(hnameSCur);
    String userAdmin=result[0]['lg'];

    List curdata = await DBProvider.db.DataFromMTRNumAndHNumGroupIdDetails1WithDN(
        rnumSCur, hnumSCur, hnameSCur, groupIdSCur, dnumSCur);
    devicename = curdata[0]['ec'];
    _globalService.devicenameset=devicename;

    setState(() {
      devicename=devicename;
    });

    socketsend();

  }

  socketsend(){

    if(s.socketconnected == true) {
      sendDataCur(senddata: "920", castType: "01");
    }
    else{
      s.checkindevice(hnameSCur,hnumSCur);
    }

  }

  void sendDataCur({String senddata, String castType}) {

    String cast1 = castType;
    String gI = groupIdSCur;
    String c = dnumSCur.padLeft(4, '0');
    String rN = rnumSCur.padLeft(2, '0');
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
    print("Cur $Notification");
    String cdev = dnumSCur.padLeft(4, '0');
    String rdev = notification.substring(4, 8);

    if (cdev.contains(rdev)) {

      String state = notification.substring(8,10);
      if(state.contains("01")){

        setState(() {
          openChange=true;
          stopChange=false;
          closeChange=false;
        });

      }
      else if(state.contains("02")){
        setState(() {
          openChange=false;
          closeChange=true;
          stopChange=false;
        });
      }
      else if(state.contains("03")){
        setState(() {
          openChange=false;
          closeChange=false;
          stopChange=true;
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

          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Center(child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child:
                    Text(
                      devicename,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal
                      ),

                      maxLines: 2,

                    ),)
                  ),

                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child:Transform.scale(
                        scale: 2.0,
                        child: IconButton(
                            iconSize: MediaQuery.of(context).size.width/10,
                            icon: openChange?open01:open,
                            splashRadius: 0.1,
                            splashColor:Colors.transparent ,

                            onPressed: () {
                                sendDataCur(senddata: "101", castType: "01");
                            }
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(05.0),

                      child:Transform.scale(
                        scale: 2.0,
                        child: IconButton(
                            iconSize: MediaQuery.of(context).size.width/10,
                            icon: stopChange?stop01:stop,
                            splashRadius: 0.1,
                            splashColor:Colors.transparent ,

                            onPressed: () {
                                sendDataCur(senddata: "103", castType: "01");
                            }
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(05.0),
                      child:Transform.scale(
                        scale: 2.0,
                        child: IconButton(
                            iconSize: MediaQuery.of(context).size.width/10,
                            icon: closeChange?close01:close,
                            onPressed: () {
                                sendDataCur(senddata: "102", castType: "01");
                            }
                        ),
                      ),
                    )
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