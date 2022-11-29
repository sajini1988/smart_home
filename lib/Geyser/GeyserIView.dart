import 'package:flutter/material.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/Geyser/Geyser.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/Singleton.dart';
import 'package:smart_home/GlobalService.dart';

class GeyIViewState extends StatefulWidget {

  @override
  _GeyIViewState createState() => _GeyIViewState();

}

class _GeyIViewState extends State<GeyIViewState> {

  GlobalService _globalService = GlobalService();

  var s=Singleton();

  String hnameGy,hnumGy,rnumGy,dnumGy,rnameGy,groupIdGy,dtypeGy;
  String devicename="name";
  String status="OFF";

  @override
  void initState() {

    super.initState();

    FNC.DartNotificationCenter.unregisterChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'MasterNotification', onNotification: (options) {
      print('GeyNotified: $options');
      geyResponce(options);
    }, observer: null);
    // TODO: implement initState

    hnameGy = hnameG;
    hnumGy = hnumG;
    rnumGy = rnumG;
    dnumGy = dnumG;
    rnameGy = rnameG;
    groupIdGy = groupIdG;
    dtypeGy = dtypeG;

    geyDetails();
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

  geyDetails(){
    details();
  }

  void details()async{

    DBHelper dbHelper;
    dbHelper = DBHelper();

    List result = await dbHelper.getLocalDateHName(hnameGy);
    String userAdmin = result[0]['lg'];
    print(userAdmin);

    List acdata = await DBProvider.db.DataFromMTRNumAndHNumGroupIdDetails1WithDN(rnumGy, hnumGy, hnameGy, groupIdGy, dnumGy);
    devicename = acdata[0]['ec'];
    _globalService.devicenameset=devicename;

    setState(() {
      devicename=devicename;
    });

    socketsend();
  }

  socketsend(){

    if(s.socketconnected == true){
        sendDataGey(senddata: "920", castType: "01");
    }
    else{
      s.checkindevice(hnameGy,hnumGy);
    }
  }

  void sendDataGey({String senddata, String castType}) {

    String cast1 = castType;
    String gI = groupIdGy;
    String c = dnumGy.padLeft(4, '0');
    String rN = rnameGy.padLeft(2, '0');
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Expanded(
                    child: IconButton(
                      iconSize: MediaQuery.of(context).size.width/10,
                      splashRadius: 0.1,
                      splashColor:Colors.transparent,
                      icon:Image.asset('images/switchicons/all_on.png'),
                      onPressed: () {
                        sendDataGey(senddata: "201",castType: "01");
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
                    )
                  ),
                  Expanded(
                    child: IconButton(
                      iconSize: MediaQuery.of(context).size.width/10,
                      splashRadius: 0.1,
                      splashColor:Colors.transparent,
                      icon:Image.asset('images/switchicons/all_off.png'),
                      onPressed: () {
                        sendDataGey(senddata: "301",castType: "01");
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

  geyResponce(String notification) {
    print("Cur $Notification");
    String cDev = dnumGy.padLeft(4, '0');
    String rDev = notification.substring(4, 8);

    if (cDev==(rDev)) {
      String state = notification.substring(8,9);
      if(state==("1")){
        setState(() {
          status="ON";
        });
      }
      else{
        setState(() {
          status="OFF";
        });
      }


    }
  }







}