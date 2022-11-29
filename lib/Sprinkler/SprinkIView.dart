import 'package:flutter/material.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/Sprinkler/SprinkLayout.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/Singleton.dart';
import 'package:smart_home/GlobalService.dart';

class SpnkIView extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<SpnkIView> createState() => _SpnkIViewState();
}

class _SpnkIViewState extends State<SpnkIView> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home-page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:MyHomePage(title: 'home-page',),

    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {

  GlobalService _globalService = GlobalService();

  var s=Singleton();

  String hnamespnk,hnumspnk,rnumspnk,dnumspnk,rnamespnk,groupIdspnk,dtypespnk;
  String devicename="name";
  String status="OFF";

  @override
  void initState() {

    super.initState();

    FNC.DartNotificationCenter.unregisterChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'MasterNotification', onNotification: (options) {
      print('SWNotified: $options');
      spnkResponce(options);
    }, observer: null);
    // TODO: implement initState

    hnamespnk = hnamesp;
    hnumspnk = hnumsp;
    rnumspnk = rnumsp;
    dnumspnk = dnumsp;
    rnamespnk = rnamesp;
    groupIdspnk = groupIdsp;
    dtypespnk = dtypesp;

    spnkDetails();

  }

  spnkResponce(String notification) {
    print("Cur $Notification");
    String cDev = dnumspnk.padLeft(4, '0');
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

  spnkDetails(){
    details();
  }
  void details()async{

    DBHelper dbHelper;
    dbHelper = DBHelper();

    List result = await dbHelper.getLocalDateHName(hnamesp);
    String userAdmin = result[0]['lg'];
    print(userAdmin);

    List pirdata = await DBProvider.db.DataFromMTRNumAndHNumGroupIdDetails1WithDN(
        rnumspnk, hnumspnk, hnamespnk, groupIdspnk, dnumspnk);

    print(pirdata);

    devicename = pirdata[0]['ec'];

    _globalService.devicenameset=devicename;

    setState(() {
      devicename=devicename;
    });

    socketsend();
  }

  socketsend(){

    if(s.socketconnected == true){
      sendDataGsk(senddata: "920",castType: "01");
    }
    else{
      s.checkindevice(hnamespnk,hnumspnk);
    }
  }

  void sendDataGsk({String senddata, String castType}) {

    String cast1 = castType;
    String gI = groupIdspnk;
    String c = dnumspnk.padLeft(4, '0');
    String rN = rnumspnk.padLeft(2, '0');
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
          child:Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width/1.4,
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
                          sendDataGsk(senddata: "201",castType: "01");
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
                        onPressed: (){
                          sendDataGsk(senddata: "301",castType: "01");
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
      ),
    );
  }







}