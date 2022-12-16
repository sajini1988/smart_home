import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/DLock/DLock.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/Singleton.dart';
import 'package:smart_home/GlobalService.dart';

class DLockViewState extends StatefulWidget {
  @override
  _DLockViewState createState() => _DLockViewState();
}

class _DLockViewState extends State<DLockViewState> {

  GlobalService _globalService = GlobalService();
  var s=Singleton();

  String hnameLock,hnumLock,rnumLock,dnumLock,rnameLock,groupIdLock,dtypeLock;
  String devicename="name";
  String status="OPEN";

  @override
  void initState() {

    super.initState();

    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );

    FNC.DartNotificationCenter.unregisterChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'MasterNotification', onNotification: (options) {
      print('LockNotified: $options');
    }, observer: null);
    // TODO: implement initState

    hnameLock = hnameL;
    hnumLock = hnumL;
    rnumLock = rnumL;
    dnumLock = dnumL;
    rnameLock = rnameL;
    groupIdLock = groupIdL;
    dtypeLock= dtypeL;

    lockDetails();
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

  lockDetails(){
    details();
  }

  void details()async{

    DBHelper dbHelper;
    dbHelper = DBHelper();

    List result = await dbHelper.getLocalDateHName(hnameLock);
    String userAdmin = result[0]['lg'];
    print(userAdmin);



    List acdata = await DBProvider.db.DataFromMTRNumAndHNumGroupIdDetails1WithDN(rnumLock, hnumLock, hnameLock, groupIdLock, dnumLock);
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
      s.checkindevice(hnameLock,hnumLock);
    }
  }

  void sendDataGey({String senddata, String castType}) {

    String cast1 = castType;
    String gI = groupIdLock;
    String c = dnumLock.padLeft(4, '0');
    String rN = rnameLock.padLeft(2, '0');
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

  geyResponce(String notification) {
    print("Cur $Notification");
    String cDev = dnumLock.padLeft(4, '0');
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
                  Center(
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
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        status,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal
                        ),
                        maxLines: 2,
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







}