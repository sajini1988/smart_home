import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/Singleton.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:smart_home/Somphy/SomphyLayout.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:smart_home/GlobalService.dart';

class SomphyView extends StatefulWidget {
  SomphyView({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _SomphyIViewState createState() => _SomphyIViewState();
}
class _SomphyIViewState extends State<SomphyView> {

  GlobalService _globalService = GlobalService();
  var s = Singleton();
  Image open=Image.asset('images/Curtain/open.png');
  Image open01=Image.asset('images/Curtain/open01.png');

  Image close=Image.asset('images/Curtain/close.png');
  Image close01=Image.asset('images/Curtain/close01.png');

  Image stop=Image.asset('images/Curtain/stop.png');
  Image stop01=Image.asset('images/Curtain/stop01.png');

  bool openchange = false;
  bool closechange = false;
  bool stopchange = false;

  String devicename = "";
  String hnameslg,hnumslg,rnumslg,dnumslg,rnameslg,groupIdslg;

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
      print('SlNotified: $options');
      slResponce(options);

    }, observer: null);

    hnameslg=hnameSh;
    hnumslg=hnumSh;
    rnameslg=rnameSh;
    dnumslg=dnumSh;
    rnumslg=rnumSh;
    groupIdslg=groupIdSh;

    sDetails();

  }

  sDetails(){
    details();
  }

  details() async {

    DBHelper dbHelper;
    dbHelper = DBHelper();

    List result=await dbHelper.getLocalDateHName(hnameslg);
    String userAdmin=result[0]['lg'];

    if(userAdmin == 'U' || userAdmin == 'G'){

    }
    List curdata = await DBProvider.db.DataFromMTRNumAndHNumGroupIdDetails1WithDN(rnumslg, hnumslg, hnameslg, groupIdslg, dnumslg);
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
      s.checkindevice(hnameslg,hnumslg);
    }

  }

  void sendDataCur({String senddata, String castType}) {

    String cast1 = castType;
    String gI = groupIdslg;
    String c = dnumslg.padLeft(4, '0');
    String rN = rnumslg.padLeft(2, '0');
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


  slResponce(String notification) {
    print("Cur $Notification");
    String cDev = dnumslg.padLeft(4, '0');
    String rDev = notification.substring(4, 8);

    if (cDev==(rDev)) {

      String state = notification.substring(8,10);
      if(state.contains("01")){

        setState(() {
          openchange=true;
          stopchange=false;
          closechange=false;
        });

      }
      else if(state.contains("02")){
        setState(() {
          openchange=false;
          closechange=true;
          stopchange=false;
        });
      }
      else if(state.contains("03")){
        setState(() {
          openchange=false;
          closechange=false;
          stopchange=true;
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
                            icon: openchange?open01:open,
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
                            icon: stopchange?stop01:stop,
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
                            icon: closechange?close01:close,
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