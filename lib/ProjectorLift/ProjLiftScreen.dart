import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/ProjectorLift/ProjLiftLayout.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/Singleton.dart';
import 'package:smart_home/GlobalService.dart';

class PLCPage extends StatefulWidget {
  PLCPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _PLCPageState createState() => _PLCPageState();
}
class _PLCPageState extends State<PLCPage> {

  GlobalService _globalService = GlobalService();
  var s=Singleton();

  String hnamepsc1,hnumpsc1,rnumpsc1,dnumpsc1,rnamepsc1,groupIdpsc1,dtypepsc1;
  String devicename="";
  String status = "OFF";
  Color colorBoth;
  Color colorOn=Colors.green,colorOff = Colors.red;


  @override
  void initState(){

    super.initState();

    colorBoth=colorOff;

    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );

    FNC.DartNotificationCenter.unregisterChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'MasterNotification', onNotification: (options) {
      pscResponce(options);
    }, observer: null);

    hnamepsc1 = hnamePlc;
    hnumpsc1 = hnumPlc;
    rnumpsc1 = rnumPlc;
    dnumpsc1 = dnumPlc;
    rnamepsc1 = rnamePlc;
    groupIdpsc1 = groupIdPlc;
    dtypepsc1 = dtypePlc;

    print("$hnamepsc1,$hnumpsc1,$rnumpsc1,$dnumpsc1,$rnamepsc1,$groupIdpsc1,$dtypepsc1");
    pscdetails();

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

  pscdetails(){
    details();
  }

  void details()async{

    DBHelper dbHelper;
    dbHelper = DBHelper();

    List result = await dbHelper.getLocalDateHName(hnamepsc1);
    String userAdmin = result[0]['lg'];
    print(userAdmin);

    List pscdata = await DBProvider.db.DataFromMTRNumAndHNumGroupIdDetails1WithDN(
        rnumpsc1, hnumpsc1, hnamepsc1, groupIdpsc1, dnumpsc1);

    print(pscdata);

    devicename = pscdata[0]['ec'];

    _globalService.devicenameset=devicename;

    setState(() {
      devicename=devicename;
    });

    socketsend();

  }

  socketsend(){

    if(s.socketconnected == true){
      sendDataPsc(senddata: "920",castType: "01");
    }
    else{
      s.checkindevice(hnamepsc1,hnumpsc1);
    }
  }

  @override
  Widget build(BuildContext context){

    return MaterialApp(

        debugShowCheckedModeBanner: false,
        home: Scaffold(

            backgroundColor: Colors.white,
            body:Center(
                child:Column(
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
                              sendDataPsc(senddata: "201",castType: "01");
                            },
                          ),
                        ),

                        Expanded(
                          child: Center(
                            child: Text(devicename, maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal
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
                              sendDataPsc(senddata: "301",castType: "01");
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
                                    color: colorBoth,
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

                  ],
                )
            )

        )

    );

  }

  pscResponce(String notification) {
    print("Psc $Notification");
    String cDev = dnumpsc1.padLeft(4, '0');
    String rDev = notification.substring(4, 8);

    print("$cDev,$rDev");

    if (cDev==(rDev)) {

      String state = notification.substring(8,9);

      if(state==("1")){
        setState(() {
          status="ON";
          colorBoth=colorOn;
        });
      }
      else{
        setState(() {
          status="OFF";
          colorBoth=colorOff;
        });
      }

    }
  }

  void sendDataPsc({String senddata, String castType}) {

    String cast1 = castType;
    String gI = groupIdpsc1;
    String c = dnumpsc1.padLeft(4, '0');
    String rN = rnumpsc1.padLeft(2, '0');
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