import 'package:flutter/material.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/AC/Ac.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/Singleton.dart';
import 'package:smart_home/GlobalService.dart';

class ACIViewState extends StatefulWidget {

  @override
  _ACIViewState createState() => _ACIViewState();

}

class _ACIViewState extends State<ACIViewState> {

  GlobalService _globalService = GlobalService();

  var s=Singleton();

  String hnameAc,hnumAc,rnumAc,dnumAc,rnameAc,groupIdAc,dtypeAc;
  String devicename="name";
  String status="OFF";

  @override
  void initState() {

    super.initState();

    FNC.DartNotificationCenter.unregisterChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'MasterNotification', onNotification: (options) {
      print('ACNotified: $options');
      acResponce(options);
    }, observer: null);
    // TODO: implement initState

    hnameAc = hnameac;
    hnumAc = hnumac;
    rnumAc = rnumac;
    dnumAc = dnumac;
    rnameAc = rnameac;
    groupIdAc = groupIdac;
    dtypeAc = dtypeac;

    acdetails();
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

  acdetails(){
    details();
  }

  void details()async{

    DBHelper dbHelper;
    dbHelper = DBHelper();

    List result = await dbHelper.getLocalDateHName(hnameAc);
    String userAdmin = result[0]['lg'];
    print(userAdmin);

    if (userAdmin == 'U' || userAdmin == 'G') {

    }

    List acdata = await DBProvider.db.DataFromMTRNumAndHNumGroupIdDetails1WithDN(rnumAc, hnumAc, hnameAc, groupIdAc, dnumAc);
    devicename = acdata[0]['ec'];
    _globalService.devicenameset=devicename;

    setState(() {
      devicename=devicename;
    });

    socketsend();
  }

  socketsend(){

    if(s.socketconnected == true){
        sendDataAc(senddata: "920",castType: "01");
    }
    else{
      s.checkindevice(hnameAc,hnumAc);
    }
  }

  acResponce(String notification) {
    print("Cur $Notification");
    String cDev = dnumAc.padLeft(4, '0');
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
                        sendDataAc(senddata: "201",castType: "01");
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
                        sendDataAc(senddata: "301",castType: "01");
                      },
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          status,
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal
                          ),
                          maxLines: 2,
                        ),
                      ),

                    ),
                  )

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

  void sendDataAc({String senddata, String castType}) {

    String cast1 = castType;
    String gI = groupIdAc;
    String c = dnumAc.padLeft(4, '0');
    String rN = rnumAc.padLeft(2, '0');
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