//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/Swb/switchlayout.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:smart_home/Singleton.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/Swb/Icon_change.dart';


class S010 extends StatelessWidget {
  // This widget is the root of your application.
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
  int val;

  Image imagenum_on;
  Image imagenum_off;

  Image bulbon=Image.asset('images/switchicons/bulb_on.png');
  Image bulboff=Image.asset('images/switchicons/bulb_off.png');

  Image acon = Image.asset('images/switchicons/ac_on.png');
  Image acoff = Image.asset('images/switchicons/ac_off.png');

  Image aquaOn = Image.asset('images/switchicons/aqua_on.png');
  Image aquaOff = Image.asset('images/switchicons/aqua_off.png');

  Image cflOn = Image.asset('images/switchicons/cfl_on.png');
  Image cflOff = Image.asset('images/switchicons/cfl_off.png');

  Image curOn = Image.asset('images/switchicons/cur_on.png');
  Image CurOff = Image.asset('images/switchicons/cur_off.png');

  Image dimmerOn = Image.asset('images/switchicons/dimmer_on.png');
  Image dimmerOff = Image.asset('images/switchicons/dimmer_off.png');

  Image geyOn = Image.asset('images/switchicons/gey_on.png');
  Image geyOff = Image.asset('images/switchicons/gey_off.png');

  Image lampOn = Image.asset('images/switchicons/lamp_on.png');
  Image lampOff = Image.asset('images/switchicons/lamp_off.png');

  Image dlockOn = Image.asset('images/switchicons/dlock_on.png');
  Image dlockOff = Image.asset('images/switchicons/dlock_off.png');

  Image nameboardOn = Image.asset('images/switchicons/nameboard_on.png');
  Image nameboardOff = Image.asset('images/switchicons/nameboard_off.png');

  Image rgbOn = Image.asset('images/switchicons/rgb_on.png');
  Image rgbOff = Image.asset('images/switchicons/rgb_off.png');

  Image socketOn = Image.asset('images/switchicons/socket_on.png');
  Image socketOff = Image.asset('images/switchicons/socket_off.png');

  Image speakerOn = Image.asset('images/switchicons/speaker_on.png');
  Image speakerOff = Image.asset('images/switchicons/speaker_off.png');

  Image TvOn = Image.asset('images/switchicons/tv_on.png');
  Image TvOff = Image.asset('images/switchicons/tv_off.png');

  Image tbOn = Image.asset('images/switchicons/tb_on.png');
  Image tbOff = Image.asset('images/switchicons/tb_off.png');

  Image EbOn = Image.asset('images/switchicons/eb_on.png');
  Image EbOff = Image.asset('images/switchicons/eb_off.png');

  Image dispOn = Image.asset('images/switchicons/eb_on.png');
  Image dispOff = Image.asset('images/switchicons/eb_off.png');

  Image sprinklerOn = Image.asset('images/switchicons/eb_on.png');
  Image sprinklerOff = Image.asset('images/switchicons/eb_off.png');

  bool imgchange1=false;
  String devicename="name10";
  String hname10,hnum10,rnum10,dnum10,rname10,GroupId10;
  String icon1;
  Image img1_On,img1_Off;


  @override
  void initState() {

    super.initState();
    FNC.DartNotificationCenter.unregisterChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'MasterNotification', onNotification: (options) {
      SwResponce(options);
    }, observer: null);

    FNC.DartNotificationCenter.unregisterChannel(channel: 'changeicon_switch10');
    FNC.DartNotificationCenter.registerChannel(channel: "changeicon_switch10");
    FNC.DartNotificationCenter.subscribe(channel: "changeicon_switch10", observer: null, onNotification: (options){
      print('SWNOtified:$options');
      swdetails();
    });

    FNC.DartNotificationCenter.unregisterChannel(channel: 'socketconndevice');
    FNC.DartNotificationCenter.registerChannel(channel: 'socketconndevice');
    FNC.DartNotificationCenter.subscribe(channel: 'socketconndevice', onNotification: (options) {
      socketsend();
    }, observer: null);


    img1_Off = bulboff;
    hname10 = hnames;
    hnum10 = hnums;
    rnum10 = rnums;
    dnum10 = dnums;
    rname10 = rnames;
    GroupId10 = groupIds;

    swdetails();
    print("swb initstate $hname10 $hnum10 $rnum10 $dnum10 $rname10");
  }

  SwResponce(String notification){

    print("Sw $Notification");

    String sdev = dnum10.padLeft(4, '0');
    String rdev = notification.substring(4,8);

    if(sdev.contains(rdev)) {
        print("enter sw10 responce");
        switch (notification[8]) {
          case '0':
            val = 0;
            {
              updateswb_1_4(
                  4,
                  true,
                  false,
                  true,
                  false,
                  true,
                  false,
                  true,
                  false);
              break;
            }
          case '1':
            val = 1;
            {
              print("switchboard1");
              updateswb_1_4(
                  4,
                  true,
                  true,
                  true,
                  false,
                  true,
                  false,
                  true,
                  false);
              break;
            }

          default:
            val = 0;
            {
              print("switchboard_default");
              updateswb_1_4(
                  4,
                  true,
                  false,
                  true,
                  false,
                  true,
                  false,
                  true,
                  false);
              break;
            }
        }
      }
  }

  Future<void> updateswb_1_4(int i, bool sb1, bool sb11, bool sb2, bool sb22, bool sb3, bool sb33, bool sb4, bool sb44) async {

    if (sb1) {

      if (sb11) {
        print("On");
        imagechageOn(icon1,"1",img1_On);
      }
      else {
        print("Off");
        imagechangeOff(icon1,"1",img1_Off);
      }
      sb1 = false;

    }
  }

  imagechageOn(String icontype, String swnum,Image image_on){

    switch(icontype) {
      case 'dimmr':
        imagenum_on = dimmerOn;
        break;
      case 'auqa':
        imagenum_on = aquaOn;
        break;
      case 'Bicon1':
        imagenum_on = bulbon;
        break;
      case 'rgb':
        imagenum_on = rgbOn;
        break;
      case 'tv':
        imagenum_on = TvOn;
        break;
      case 'curtain':
        imagenum_on = curOn;
        break;
      case 'geyser':
        imagenum_on = geyOn;
        break;
      case 'ac':
        imagenum_on = acon;
        break;
      case 'sprinkler':
        imagenum_on = sprinklerOn;
        break;
      case 'door':
        imagenum_on = dlockOn;
        break;
      case 'aqua':
        imagenum_on = aquaOn;
        break;
      case 'disp':
        imagenum_on = nameboardOn;
        break;
      case 'bedlamp':
        imagenum_on = lampOn;
        break;
      case 'socket':
        imagenum_on = socketOn;
        break;
      case 'speaker':
        imagenum_on = speakerOn;
        break;
      case 'cfl':
        imagenum_on = cflOn;
        break;
      case 'bulb':
        imagenum_on = bulbon;
        break;
      case 'Bulb':
        imagenum_on = bulbon;
        break;
      case 'tubelight':
        imagenum_on = tbOn;
        break;
      case 'exhaustfan':
        imagenum_on = bulbon;
        break;
      case '':
        imagenum_on = bulbon;
        break;
      case 'null':
        imagenum_on = bulbon;
        break;
      case 'ebulb':
        imagenum_on = EbOn;
        break;
      default:
        imagenum_on = bulbon;
    }

    if(swnum.contains("1")){

      setState(() {
        print("1on");
        img1_On=imagenum_on;
        imgchange1=true;
      });
    }

  }

  imagechangeOff(String icontype, String swnum,Image image_off){

    switch(icontype) {
      case 'dimmr':
        imagenum_off = dimmerOff;
        break;
      case 'auqa':
        imagenum_off = aquaOff;
        break;

        case 'Bicon1':
        imagenum_off = bulboff;
        break;
      case 'rgb':
        imagenum_off = rgbOff;
        break;
      case 'tv':
        imagenum_off = TvOff;
        break;
      case 'curtain':
        imagenum_off = CurOff;
        break;
      case 'geyser':
        imagenum_off = geyOff;
        break;
      case 'ac':
        imagenum_off = acoff;
        break;
      case 'sprinkler':
        imagenum_off = sprinklerOff;
        break;
      case 'door':
        imagenum_off = dlockOff;
        break;
      case 'aqua':
        imagenum_off = aquaOff;
        break;
      case 'disp':
        imagenum_off = nameboardOff;
        break;
      case 'bedlamp':
        imagenum_off = lampOff;
        break;
      case 'socket':
        imagenum_off = socketOff;
        break;
      case 'speaker':
        imagenum_off = speakerOff;
        break;
      case 'cfl':
        imagenum_off = cflOff;
        break;
      case 'bulb':
        imagenum_off = bulboff;
        break;
      case 'Bulb':
        imagenum_off = bulboff;
        break;
      case 'tubelight':
        imagenum_off = tbOff;
        break;
      case 'exhaustfan':
        imagenum_off = bulboff;
        break;
      case '':
        imagenum_off = bulboff;
        break;
      case 'null':
        imagenum_off = bulboff;
        break;
      case 'ebulb':
        imagenum_off = EbOff;
        break;

      default:
        imagenum_off=bulboff;
    }
    if(swnum.contains("1")){

      setState(() {
        img1_Off=imagenum_off;
        imgchange1=false;

      });
    }
  }

  swdetails(){

    details();

  }

  ////////////////////Details///////////////////////
  details()async{

    DBHelper dbHelper;
    dbHelper = DBHelper();
    List result = await dbHelper.getLocalDateHName(hnames);
    String UserAdmin=result[0]['lg'];

    print(UserAdmin);

    if(UserAdmin == 'A' || UserAdmin == 'SA') {
      List res1 = await DBProvider.db.getSwitchBoardDateFromRNumAndHNumWithDN(rnum10, hnum10, dnum10, hname10);
      print("S051 $res1");

      devicename = res1[0]['ec'];
      icon1=res1[0]['bi1'];

      switch(icon1){
        case 'dimmr':
          img1_Off = dimmerOff;
          break;
        case 'auqa':
          img1_Off = aquaOff;
          break;
        case 'Bicon1':
          img1_Off=bulboff;
          break;
        case 'rgb':
          img1_Off=rgbOff;
          break;
        case 'tv':
          img1_Off=TvOff;
          break;
        case 'curtain':
          img1_Off=CurOff;
          break;
        case 'geyser':
          img1_Off=geyOff;
          break;
        case 'ac':
          img1_Off=acoff;
          break;
        case 'sprinkler':
          img1_Off=sprinklerOff;
          break;
        case 'door':
          img1_Off=dlockOff;
          break;
        case 'auqa':
          img1_Off=aquaOff;
          break;
        case 'disp':
          img1_Off=nameboardOff;
          break;
        case 'bedlamp':
          img1_Off=lampOff;
          break;
        case 'socket':
          img1_Off=socketOff;
          break;
        case 'speaker':
          img1_Off=speakerOff;
          break;
        case 'cfl':
          img1_Off=cflOff;
          break;
        case 'bulb':
          img1_Off=bulboff;
          break;
        case 'Bulb':
          img1_Off=bulboff;
          break;
        case 'tubelight':
          img1_Off=tbOff;
          break;
        case 'exhaustfan':
          img1_Off=bulboff;
          break;
        case '':
          img1_Off=bulboff;
          break;
        case 'null':
          img1_Off=bulboff;
          break;
        case 'ebulb':
          img1_Off=EbOff;
          break;
        default:
          img1_Off=bulboff;
      }

      _globalService.devicenameset=devicename;

      print("51name $devicename");
      setState(() {
        img1_Off=img1_Off;
        devicename=devicename;
      });
    }
    socketsend();
  }

  socketsend(){

    if(s.socketconnected == true) {
      print("sendswdata");
      SendDataSw(senddata: "920", CastType: "01");
    }
    else if(s.socketconnected == false){
      s.checkindevice(hname10, hnum10);
    }

  }

  void SendDataSw({String senddata, String CastType}) {

    String cast1 = CastType;
    String gI = GroupId10;
    String c = dnum10.padLeft(4, '0');
    String rN = rnum10.padLeft(2, '0');
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
        body: Center(

          child:Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children:<Widget> [

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
                      padding: const EdgeInsets.all(10.0),
                      child:GestureDetector(
                        onLongPress: (){
                          _globalService.bulbnumberset="b1t";
                          showAlertDialog(context);
                        },
                        child:Transform.scale(
                          scale: 3,
                          child: IconButton(
                            icon: imgchange1?img1_On:img1_Off,
                            splashRadius: 0.1,
                            splashColor:Colors.transparent ,
                            onPressed: () {
                              SendDataSw(senddata: "101", CastType: "01");
                            }

                          ),
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
      ),
    );
  }
  showAlertDialog(BuildContext context) async {

    AlertDialog alert = AlertDialog(

      titlePadding: EdgeInsets.zero, contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,

      title: Text(""),
      content: IconchangePage(),
      actions: [

      ],
    );
    showDialog(context: context, builder: (BuildContext context){
      return alert;
    }
    );
  }
}

