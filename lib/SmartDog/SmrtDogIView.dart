//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/Singleton.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:smart_home/SmartDog/SmrtDogLayout.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:smart_home/GlobalService.dart';

class SmartDogIView extends StatefulWidget {

  @override
  _SmartDogIViewState createState() => _SmartDogIViewState();
}

class _SmartDogIViewState extends State<SmartDogIView> {

  GlobalService _globalService = GlobalService();
  var s = Singleton();

  String devicename = "name";
  String status="OFF";
  String _hnamesdg,_hnumsdg,_rnumsdg,_dnumsdg,_rnamesdg,_groupIdsdg;
  Color colorBoth;
  Color colorOn=Colors.green,colorOff=Colors.red;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    colorBoth=colorOff;

    FNC.DartNotificationCenter.unregisterChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'MasterNotification', onNotification: (options) {
      print('SdgNotified: $options');
      sdgResponce(options);

    }, observer: null);


    _hnamesdg=hnamesdg;
    _hnumsdg=hnumsdg;
    _rnamesdg=rnamesdg;
    _dnumsdg=dnumsdg;
    _rnumsdg=rnumsdg;
    _groupIdsdg=groupIdsdg;

    print("$_hnamesdg,$_hnumsdg,$_rnumsdg,$_dnumsdg,$_rnamesdg,$_groupIdsdg");

    sdgdetails();

  }

  sdgdetails(){
    details();
  }

  details() async {

    DBHelper dbHelper;
    dbHelper = DBHelper();

    print("name is $_hnamesdg,$_hnumsdg,$_rnumsdg,$_dnumsdg,$_rnamesdg,$_groupIdsdg");

    List result=await dbHelper.getLocalDateHName(_hnamesdg);
    String userAdmin=result[0]['lg'];

    if(userAdmin == 'U' || userAdmin == 'G'){

    }
    List sdgdata = await DBProvider.db.DataFromMTRNumAndHNumGroupIdDetails1WithDN(
        _rnumsdg, _hnumsdg, _hnamesdg, _groupIdsdg, _dnumsdg);
    devicename = sdgdata[0]['ec'];

    _globalService.devicenameset=devicename;

    setState(() {
      devicename=devicename;
    });

    socketsend();


  }

  socketsend(){

    if(s.socketconnected == true) {
      senddataSdg(senddata: "920", castType: "01");
    }
    else{
      s.checkindevice(_hnamesdg,_hnumsdg);
    }

  }

  void senddataSdg({String senddata, String castType}) {

    String cast1 = castType;
    String gI = _groupIdsdg;
    String c = _dnumsdg.padLeft(4, '0');
    String rN = _rnumsdg.padLeft(2, '0');
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


  sdgResponce(String notification) {
    print("sdg $Notification");
    String sdgDev = _dnumsdg.padLeft(4, '0');
    String rdev = notification.substring(4, 8);

    if (sdgDev==rdev) {

      String state = notification.substring(8,9);
      if(state==("0")){

        setState(() {
          status="OFF";
          colorBoth=colorOff;
        });

      }
      else if(state==("1")){
        setState(() {
          status="ON";
          colorBoth=colorOn;
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
                          senddataSdg(senddata: "201",castType: "01");
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
                          senddataSdg(senddata: "301",castType: "01");
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
                                color:colorBoth,
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
          ),
        ),
      ),
    ));
  }



}