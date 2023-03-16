import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/DimmerIndv/dimmer.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/Singleton.dart';
import 'package:smart_home/GlobalService.dart';

class DmrIViewState extends StatefulWidget {
  @override
  _DmrIViewState createState() => _DmrIViewState();
}
class _DmrIViewState extends State<DmrIViewState> {

  GlobalService _globalService = GlobalService();
  var s=Singleton();

  bool dmrStatus = false;

  int iSpeed = 121;
  int iSpeed1 = 0;

  String hnameDmr,hnumDmr,rnumDmr,dnumDmr,rnameDmr,groupIdDmr,dtypeDmr;
  String devicename="";

  int myValue = 1;
  final leadingWidgetWidth = 120.0;


  Image dimmer00 = Image.asset('images/Dimmer/dimmer00.png');
  Image dimmer01 = Image.asset('images/Dimmer/dimmer01.png');
  Image dimmer02 = Image.asset('images/Dimmer/dimmer02.png');
  Image dimmer03 = Image.asset('images/Dimmer/dimmer03.png');
  Image dimmer04 = Image.asset('images/Dimmer/dimmer04.png');
  Image dimmer05 = Image.asset('images/Dimmer/dimmer05.png');
  Image dimmer06 = Image.asset('images/Dimmer/dimmer06.png');
  Image dimmer07 = Image.asset('images/Dimmer/dimmer07.png');
  Image dimmer08 = Image.asset('images/Dimmer/dimmer08.png');
  Image dimmer09 = Image.asset('images/Dimmer/dimmer09.png');

  Image low = Image.asset('images/Dimmer/low.png');
  Image low01 = Image.asset('images/Dimmer/low01.png');

  Image high = Image.asset('images/Dimmer/high.png');
  Image high01 = Image.asset('images/Dimmer/high01.png');

  Image medium = Image.asset('images/Dimmer/medium.png');
  Image medium01 = Image.asset('images/Dimmer/medium01.png');


  Color colorBoth=Colors.black;
  Color colorOn=Colors.green,colorOff=Colors.red,colorNormal=Colors.black;


  @override
  void initState() {

    super.initState();

    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );

    colorBoth = colorNormal;

    FNC.DartNotificationCenter.unregisterChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'MasterNotification', onNotification: (options) {
      print('ACNotified: $options');
      dmrResponce(options);
    }, observer: null);
    // TODO: implement initState

    hnameDmr = hnameDMR;
    hnumDmr= hnumDMR;
    rnumDmr = rnumDMR;
    dnumDmr = dnumDMR;
    rnameDmr = rnameDMR;
    groupIdDmr = groupIdDMR;
    dtypeDmr = dtypeDMR;

    dmrDetails();
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

  dmrDetails(){
    details();
  }

  void details()async{

    DBHelper dbHelper;
    dbHelper = DBHelper();

    List result = await dbHelper.getLocalDateHName(hnameDmr);
    String userAdmin = result[0]['lg'];
    print(userAdmin);

    List acdata = await DBProvider.db.DataFromMTRNumAndHNumGroupIdDetails1WithDN(rnumDmr, hnumDmr, hnameDmr, groupIdDmr, dnumDmr);
    devicename = acdata[0]['ec'];
    _globalService.devicenameset=devicename;

    setState(() {
      devicename=devicename;
    });

    socketsend();
  }

  socketsend(){

    if(s.socketconnected == true){
      sendDatadmr(senddata: "920",castType: "01");
    }
    else{
      s.checkindevice(hnameDmr,hnumDmr);
    }
  }

  dmrResponce(String notification) {
    print("rgb $Notification");
    String cDev = dnumDmr.padLeft(4, '0');
    String rDev = notification.substring(4, 8);

    if (cDev==(rDev)) {

      setState(() {


      });
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [


                  Expanded(
                    child: IconButton(
                      iconSize: MediaQuery.of(context).size.width/10,
                      splashRadius: 0.1,
                      splashColor:Colors.transparent,
                      icon:Image.asset('images/switchicons/all_on.png'),
                      onPressed: () {
                        sendDatadmr(senddata: "102",castType: "01");
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
                        sendDatadmr(senddata: "103",castType: "01");
                      },
                    ),
                  ),
                ],
              ),

              Container(
                padding: EdgeInsets.all(2), height: 100,  child: Column(
                  children: [
                    Flexible(
                      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                        //Image.asset("images/up.png" ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.40,
                          // color: Colors.blue,
                          child: Wrap(
                          // alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,

                            children: [
                              ClipRRect(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0,top: 0.0),
                                  child: Transform.scale(
                                    scale: 0.6 ,
                                    alignment: Alignment.topLeft,
                                      child: Container()
                                  ),
                                ),
                              ),
                            ] ),
                        ),


                        Container(
                          padding: EdgeInsets.all(2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Flexible(
                                flex: 1,
                                child: IconButton(
                                  //iconSize: MediaQuery.of(context).size.width/10,
                                  icon: Image.asset('images/Dimmer/low.png'),
                                  onPressed: () {

                                    },
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: IconButton(
                                  icon: Image.asset('images/Dimmer/medium.png'),
                                  onPressed: () {

                                    },
                                ),
                              ),

                              Flexible(
                                flex: 1,
                                child: IconButton(
                                  icon: Image.asset('images/Dimmer/high.png'),
                                  onPressed: () {

                                     },
                                ),
                              ),
                            ],
                          )
                      )
                    ]
                    ),
                  ),
                ],
              )
              ),

              Row(
                children: [
                  //SizedBox(height: 300),
                  Expanded(
                    flex: 7,
                    child: Slider(
                      value: myValue.isNaN == true || myValue == null ? 0 : myValue.toDouble(),
                      onChanged: (value) {
                        if (dmrStatus) {
                          setState(() {
                            myValue = value.toInt();
                          });
                        }
                      },
                      min: 1,
                      max: 10,

                      onChangeEnd: (double value) {
                        if (dmrStatus) {

                          myValue = value.toInt();
                          int x = 130;
                          int y = myValue + x;
                          //  transmitData(y, 000, 000, 000, "A");
                        }
                        else {
                          flutterToast("please switch on the device first");
                        }
                      },
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  void sendDatadmr({String senddata, String castType}) {

    String cast1 = castType;
    String gI = groupIdDmr;
    String c = dnumDmr.padLeft(4, '0');
    String rN = rnumDmr.padLeft(2, '0');
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

  flutterToast(String message){

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

}