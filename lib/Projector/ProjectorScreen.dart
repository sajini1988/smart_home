import 'package:flutter/material.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/Projector/ProjLayout.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/Singleton.dart';
import 'package:smart_home/GlobalService.dart';

class PSCPage extends StatefulWidget {
  PSCPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _PSCPageState createState() => _PSCPageState();
}

class _PSCPageState extends State<PSCPage> {

  GlobalService _globalService = GlobalService();
  var s=Singleton();
  String hnamepsc1,hnumpsc1,rnumpsc1,dnumpsc1,rnamepsc1,groupIdpsc1,dtypepsc1;
  String devicename="name";

  Image open=Image.asset('images/Curtain/open.png');
  Image open01=Image.asset('images/Curtain/open01.png');

  Image close=Image.asset('images/Curtain/close.png');
  Image close01=Image.asset('images/Curtain/close01.png');

  Image stop=Image.asset('images/Curtain/stop.png');
  Image stop01=Image.asset('images/Curtain/stop01.png');

  bool openChange = false;
  bool closeChange = false;
  bool stopChange = false;

 @override
  void initState(){

   super.initState();

   FNC.DartNotificationCenter.unregisterChannel(channel: 'MasterNotification');
   FNC.DartNotificationCenter.registerChannel(channel: 'MasterNotification');
   FNC.DartNotificationCenter.subscribe(channel: 'MasterNotification', onNotification: (options) {
        pscResponce(options);
     }, observer: null);

   hnamepsc1 = hnamepsc;
   hnumpsc1 = hnumpsc;
   rnumpsc1 = rnumpsc;
   dnumpsc1 = dnumpsc;
   rnamepsc1 = rnamepsc;
   groupIdpsc1 = groupIdpsc;
   dtypepsc1 = dtypepsc;

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
                             sendDataPsc(senddata: "101", castType: "01");
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
                             sendDataPsc(senddata: "103", castType: "01");
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
                             sendDataPsc(senddata: "102", castType: "01");
                           }
                       ),
                     ),
                   )
                 ],
               ),
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

      String state = notification.substring(8,10);
      print("$state");
      if(state==("01")){

        setState(() {
          openChange=true;
          stopChange=false;
          closeChange=false;
        });

      }
      else if(state==("02")){
        setState(() {
          openChange=false;
          closeChange=true;
          stopChange=false;
        });
      }
      else if(state==("03")){
        setState(() {
          openChange=false;
          closeChange=false;
          stopChange=true;
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