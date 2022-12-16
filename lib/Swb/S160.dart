//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/Swb/switchlayout.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:smart_home/Singleton.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/Swb/Icon_change.dart';
//import 'package:fluttertoast/fluttertoast.dart';

class S160 extends StatelessWidget {
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
  int val,val1;

  Image imagenum_on;
  Image imagenum_off;

  Image bulbon=Image.asset('images/switchicons/bulb_on.png');
  Image bulboff=Image.asset('images/switchicons/bulb_off.png');

  Image imagehvon = Image.asset('images/switchicons/highvolt_on.png');
  Image imagehvoff = Image.asset('images/switchicons/highvolt_off.png');

  Image socketNOn = Image.asset('images/switchicons/socketOn.png');
  Image socketNOff = Image.asset('images/switchicons/socketOff.png');

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
  bool imgchange2=false;
  bool imgchange3=false;
  bool imgchange4=false;
  bool imgchange5=false;
  bool imgchange6=false;
  bool imgchange7=false;


  String devicename="name80";

  String hname80,hnum80,rnum80,dnum80,rname80,GroupId80;
  String icon1,icon2,icon3,icon4,icon5,icon6,icon7;
  Image img1_On,img1_Off,img2_On,img2_Off,img3_On,img3_Off,img4_Off,img4_On,img5_Off,img5_On,img6_Off,img6_On,img7_Off,img7_On;

  @override
  void initState(){

    super.initState();


    FNC.DartNotificationCenter.unregisterChannel(channel: 'socketconndevice');
    FNC.DartNotificationCenter.registerChannel(channel: 'socketconndevice');
    FNC.DartNotificationCenter.subscribe(channel: 'socketconndevice', onNotification: (options) {
      socketsend();
    }, observer: null);


    FNC.DartNotificationCenter.unregisterChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'MasterNotification', onNotification: (options) {

      swresponce(options);
    }, observer: null);

    FNC.DartNotificationCenter.unregisterChannel(channel: 'changeicon_switch80');
    FNC.DartNotificationCenter.registerChannel(channel: "changeicon_switch80");
    FNC.DartNotificationCenter.subscribe(channel: "changeicon_switch80", observer: null, onNotification: (options){
      print('SWNOtified8i:$options');
      swdetails();
    });

    img1_Off=bulboff;
    img2_Off=bulboff;
    img3_Off=bulboff;
    img4_Off=bulboff;
    img5_Off=bulboff;
    img6_Off=bulboff;
    img7_Off=socketNOff;


    hname80=hnames;
    hnum80=hnums;
    rnum80=rnums;
    dnum80=dnums;
    rname80=rnames;
    GroupId80=groupIds;

    swdetails();
    print("swb initstate $hname80 $hnum80 $rnum80 $dnum80 $rname80");

  }

  swresponce(String notification){

    print("Sw $Notification");
    print("lenght $Notification.length");

    String sdev = dnum80.padLeft(4, '0');
    String rdev = notification.substring(4,8);

    if(sdev.contains(rdev)){

      print("enter sw80 responce");
      switch(notification[8]){
        case '0':
          val = 0;
          {
            updateswb_1_4(4, true, false, true, false, true, false, true, false);
            break;
          }
        case '1':
          val = 1;
          {
            print("switchboard1");
            updateswb_1_4(4, true, true, true, false,true,false, true, false);
            break;
          }
        case '2':
          val = 2;
          {
            print("switchboard2");
            updateswb_1_4(4, true, false,true, true, true, false,true, false);
            break;
          }
        case '3':
          val = 3;
          {
            print("switchboard3");
            updateswb_1_4(4, true, true,true, true, true, false, true, false);
            break;
          }

        case '4':
          val = 4;
          {
            print("switchboard4");
            updateswb_1_4(4,true, false,true, false, true, true, true, false);
            break;
          }

        case '5':
          val = 5;
          {
            print("switchboard5");
            updateswb_1_4(4, true, true, true, false, true, true, true, false);
            break;
          }
        case '6':
          val = 6;
          {
            print("switchboard6");
            updateswb_1_4(4, true, false, true, true, true, true, true, false);
            break;
          }
        case '7':
          val = 7;
          {
            print("switchboard7");
            updateswb_1_4(4, true, true, true, true, true, true, true, false);
            break;
          }

        case '8':
          val = 8;
          {
            print("switchboard8");
            updateswb_1_4(4, true, false, true, false, true, false, true, true);
            break;
          }

        case '9':
          val = 9;
          {
            print("switchboard9");
            updateswb_1_4(4, true, true, true, false, true, false, true, true);
            break;
          }
        case 'A':
          val = 10;
          {
            print("switchboard10");
            updateswb_1_4(4, true, false, true, true, true, false, true, true);
            break;
          }

        case 'B':
          val = 11;
          {
            print("switchboard11");
            updateswb_1_4(4, true,true, true, true, true, false, true, true);
            break;
          }

        case 'C':
          val = 12;
          {
            print("switchboard12");
            updateswb_1_4(4, true, false, true, false, true, true, true, true);
            break;
          }
        case 'D':
          val = 13;
          {
            print("switchboard13");
            updateswb_1_4(4, true, true, true, false, true, true,true, true);
            break;
          }

        case 'E':
          val = 14;
          {
            print("switchboard14");
            updateswb_1_4(4, true, false, true, true, true, true, true, true);
            break;
          }

        case 'F':
          val = 15;
          {
            print("switchboard15");
            updateswb_1_4(4, true, true, true, true, true,true, true, true);
            break;
          }
        default:
          val = 0;
          {
            print("switchboard_default");
            updateswb_1_4(4, true, false, true, false, true, false, true, false);
            break;
          }
      }

      switch (notification[9]) {
        case '0':
          val1 = 0;
          {
            print("switchboard0");
            updateswb_5_8(4, true, false, true, false, true, false, true, false);
            break;
          }

        case '1':
          val1 = 1;
          {
            print("switchboard1");
            updateswb_5_8(4, true, true, true, false, true, false, true, false);
            break;
          }
        case '2':
          val1 = 2;
          {
            print("switchboard2");
            updateswb_5_8(4,true, false, true,true, true, false, true, false);
            break;
          }
        case '3':
          val1 = 3;
          {
            print("switchboard3");
            updateswb_5_8(4, true, true, true, true, true, false, true, false);
            break;
          }

        case '4':
          val1 = 4;
          {
            print("switchboard4");
            updateswb_5_8(4, true, false, true, false, true, true, true, false);
            break;
          }

        case '5':
          val1 = 5;
          {
            print("switchboard5");
            updateswb_5_8(4, true, true, true, false, true, true, true, false);
            break;
          }
        case '6':
          val1 = 6;
          {
            print("switchboard6");
            updateswb_5_8(4, true, false, true, true, true, true, true, false);
            break;
          }
        case '7':
          val1 = 7;
          {
            print("switchboard7");
            updateswb_5_8(4, true, true, true, true, true, true, true, false);
            break;
          }

        case '8':
          val1 = 8;
          {
            print("switchboard8");
            updateswb_5_8(4, true, false, true, false, true, false, true, true);
            break;
          }

        case '9':
          val1 = 9;
          {
            print("switchboard9");
            updateswb_5_8(4,true, true, true, false, true, false, true, true);
            break;
          }
        case 'A':
          val1 = 10;
          {
            print("switchboard10");
            updateswb_5_8(4, true, false, true, true, true, false, true, true);
            break;
          }

        case 'B':
          val1 = 11;
          {
            print("switchboard11");
            updateswb_5_8(4, true, true, true, true, true, false,true, true);
            break;
          }

        case 'C':
          val1 = 12;
          {
            print("switchboard12");
            updateswb_5_8(4, true, false, true, false, true, true, true, true);
            break;
          }
        case 'D':
          val1 = 13;
          {
            print("switchboard13");
            updateswb_5_8(4, true, true, true, false, true, true, true, true);
            break;
          }

        case 'E':
          val1 = 14;
          {
            print("switchboard14");
            updateswb_5_8(4, true, false, true, true, true, true, true, true);
            break;
          }

        case 'F':
          val1 = 15;
          {
            print("switchboard15");
            updateswb_5_8(4, true, true, true, true, true, true, true, true);
            break;
          }
        default:
          val1 = 0;
          {
            print("switchboard_default");
            updateswb_5_8(4, true, false, true, false, true, false, true, false);
            break;
          }
      }

    }
  }

  Future<void> updateswb_5_8(int i, bool sb5, bool sb55, bool sb6, bool sb66, bool sb7, bool sb77, bool sb8, bool sb88) async {

    if (sb5) {
      if (sb55) {
        imagechageOn(icon5,"5",img5_On);
      }
      else {
        imagechangeOff(icon5,"5",img5_Off);
      }
      sb5 = false;

    }
    if (sb6) {
      if (sb66) {
        imagechageOn(icon6,"6",img6_On);
      }
      else {
        imagechangeOff(icon6,"6",img6_Off);
      }
      sb6 = false;

    }
    if (sb7) {
      if (sb77) {
        imagechageOn(icon7,"7",img7_On);
      }
      else {
        imagechangeOff(icon7,"7",img7_Off);
      }
      sb7 = false;

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
    if (sb2) {
      if (sb22) {
        imagechageOn(icon2,"2",img2_On);
      }
      else {
        imagechangeOff(icon2,"2",img2_Off);
      }
      sb2 = false;

    }
    if (sb3) {
      if (sb33) {
        imagechageOn(icon3,"3",img3_On);
      }
      else {
        imagechangeOff(icon3,"3",img3_Off);
      }
      sb3 = false;

    }
    if (sb4) {
      if (sb44) {
        imagechageOn(icon4,"4",img4_On);
      }
      else {
        imagechangeOff(icon4,"4",img4_Off);
      }
      sb4 = false;

    }


  }

  imagechageOn(String icontype, String swnum,Image image_on){

    print("onimagechange $icontype");
    switch(icontype) {
      case 'dimmr':
        imagenum_on = dimmerOn;
        break;
      case 'Bicon1':
        imagenum_on = bulbon;
        break;
      case 'Bicon2':
        imagenum_on = bulbon;
        break;
      case 'Bicon3':
        imagenum_on = bulbon;
        break;
      case 'Bicon4':
        imagenum_on = bulbon;
        break;
      case 'Bicon5':
        imagenum_on = bulbon;
        break;
      case 'Bicon6':
        imagenum_on = bulbon;
        break;
      case 'Bicon7':
        imagenum_on = imagehvon;
        break;
      case 'Bicon8':
        imagenum_on = imagehvon;
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
      case 'auqa':
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
    else if(swnum.contains("2")){
      setState(() {
        print("2on");
        img2_On=imagenum_on;
        imgchange2=true;
      });
    }
    else if(swnum.contains("3")){

      setState(() {
        print("3on");
        img3_On=imagenum_on;
        imgchange3=true;
      });
    }
    else if(swnum.contains("4")){

      setState(() {
        print("4on");
        img4_On=imagenum_on;
        imgchange4=true;
      });

    }
    else if(swnum.contains("5")){

      setState(() {
        print("5on");
        img5_On=imagenum_on;
        imgchange5=true;
      });
    }
    else if(swnum.contains("6")){

      setState(() {
        print("6on");
        img6_On=imagenum_on;
        imgchange6=true;
      });
    }
    else if(swnum.contains("7")){

      setState(() {
        print("7on");
        img7_On=socketNOn;
        imgchange7=true;
      });
    }



  }

  imagechangeOff(String icontype, String swnum,Image image_off){

    print("offimagechange $icontype");
    switch(icontype) {
      case 'dimmr':
        imagenum_off = dimmerOff;
        break;
      case 'Bicon1':
        imagenum_off = bulboff;
        break;
      case 'Bicon2':
        imagenum_off = bulboff;
        break;
      case 'Bicon3':
        imagenum_off = bulboff;
        break;
      case 'Bicon4':
        imagenum_off = bulboff;
        break;
      case 'Bicon5':
        imagenum_off = bulboff;
        break;
      case 'Bicon6':
        imagenum_off = bulboff;
        break;
      case 'Bicon7':
        imagenum_off = imagehvoff;
        break;
      case 'Bicon8':
        imagenum_off = imagehvoff;
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
      case 'auqa':
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
    if(swnum==("1")){

      setState(() {
        img1_Off=imagenum_off;
        imgchange1=false;

      });
    }
    else if(swnum==("2")){
      setState(() {
        img2_Off=imagenum_off;
        imgchange2=false;
      });
    }
    else if(swnum==("3")){

      setState(() {
        img3_Off=imagenum_off;
        imgchange3=false;
      });
    }
    else if(swnum==("4")){

      setState(() {
        img4_Off=imagenum_off;
        imgchange4=false;
      });

    }
    else if(swnum==("5")){

      setState(() {
        img5_Off=imagenum_off;
        imgchange5=false;
      });
    }
    else if(swnum==("6")){

      setState(() {
        img6_Off=imagenum_off;
        imgchange6=false;
      });
    }
    else if(swnum==("7")){

      setState(() {
        img7_Off=socketNOff;
        imgchange7=false;
      });
    }


  }

  swdetails(){
    details();
  }

  details()async{

    DBHelper dbHelper;
    dbHelper = DBHelper();
    List result = await dbHelper.getLocalDateHName(hnames);
    String UserAdmin=result[0]['lg'];
    print(UserAdmin);



    List res1 = await DBProvider.db.getSwitchBoardDateFromRNumAndHNumWithDN(rnum80, hnum80, dnum80, hname80);
    print("S051 $res1");

    devicename = res1[0]['ec'];
    icon1=res1[0]['bi1'];
    icon2=res1[0]['bi2'];
    icon3=res1[0]['bi3'];
    icon4=res1[0]['bi4'];
    icon5=res1[0]['bi5'];
    icon6=res1[0]['bi6'];
    icon7=res1[0]['bi7'];

    switch(icon1){
      case 'dimmr':
        img1_Off=dimmerOff;
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
    switch(icon2){
      case 'dimmr':
        img2_Off=dimmerOff;
        break;
      case 'Bicon2':
        img2_Off=bulboff;
        break;
      case 'rgb':
        img2_Off=rgbOff;
        break;
      case 'tv':
        img2_Off=TvOff;
        break;
      case 'curtain':
        img2_Off=CurOff;
        break;
      case 'geyser':
        img2_Off=geyOff;
        break;
      case 'ac':
        img2_Off=acoff;
        break;
      case 'sprinkler':
        img2_Off=sprinklerOff;
        break;
      case 'door':
        img2_Off=dlockOff;
        break;
      case 'auqa':
        img2_Off=aquaOff;
        break;
      case 'disp':
        img2_Off=nameboardOff;
        break;
      case 'bedlamp':
        img2_Off=lampOff;
        break;
      case 'socket':
        img1_Off=socketOff;
        break;
      case 'speaker':
        img2_Off=speakerOff;
        break;
      case 'cfl':
        img2_Off=cflOff;
        break;
      case 'bulb':
        img2_Off=bulboff;
        break;
      case 'Bulb':
        img2_Off=bulboff;
        break;
      case 'tubelight':
        img2_Off=tbOff;
        break;
      case 'exhaustfan':
        img2_Off=bulboff;
        break;
      case '':
        img2_Off=bulboff;
        break;
      case 'null':
        img2_Off=bulboff;
        break;
      case 'ebulb':
        img2_Off=EbOff;
        break;
      default:
        img2_Off=bulboff;
    }
    switch(icon3){
      case 'dimmr':
        img3_Off=dimmerOff;
        break;
      case 'Bicon3':
        img3_Off=bulboff;
        break;
      case 'rgb':
        img3_Off=rgbOff;
        break;
      case 'tv':
        img3_Off=TvOff;
        break;
      case 'curtain':
        img3_Off=CurOff;
        break;
      case 'geyser':
        img3_Off=geyOff;
        break;
      case 'ac':
        img3_Off=acoff;
        break;
      case 'sprinkler':
        img3_Off=sprinklerOff;
        break;
      case 'door':
        img3_Off=dlockOff;
        break;
      case 'auqa':
        img3_Off=aquaOff;
        break;
      case 'disp':
        img3_Off=nameboardOff;
        break;
      case 'bedlamp':
        img3_Off=lampOff;
        break;
      case 'socket':
        img3_Off=socketOff;
        break;
      case 'speaker':
        img3_Off=speakerOff;
        break;
      case 'cfl':
        img3_Off=cflOff;
        break;
      case 'bulb':
        img3_Off=bulboff;
        break;
      case 'Bulb':
        img3_Off=bulboff;
        break;
      case 'tubelight':
        img3_Off=tbOff;
        break;
      case 'exhaustfan':
        img3_Off=bulboff;
        break;
      case '':
        img3_Off=bulboff;
        break;
      case 'null':
        img3_Off=bulboff;
        break;
      case 'ebulb':
        img3_Off=EbOff;
        break;
      default:
        img3_Off=bulboff;
    }
    switch(icon4){
      case 'dimmr':
        img4_Off=dimmerOff;
        break;
      case 'Bicon4':
        img4_Off=bulboff;
        break;
      case 'rgb':
        img4_Off=rgbOff;
        break;
      case 'tv':
        img4_Off=TvOff;
        break;
      case 'curtain':
        img4_Off=CurOff;
        break;
      case 'geyser':
        img4_Off=geyOff;
        break;
      case 'ac':
        img4_Off=acoff;
        break;
      case 'sprinkler':
        img4_Off=sprinklerOff;
        break;
      case 'door':
        img4_Off=dlockOff;
        break;
      case 'auqa':
        img4_Off=aquaOff;
        break;
      case 'disp':
        img4_Off=nameboardOff;
        break;
      case 'bedlamp':
        img4_Off=lampOff;
        break;
      case 'socket':
        img4_Off=socketOff;
        break;
      case 'speaker':
        img4_Off=speakerOff;
        break;
      case 'cfl':
        img4_Off=cflOff;
        break;
      case 'bulb':
        img4_Off=bulboff;
        break;
      case 'Bulb':
        img4_Off=bulboff;
        break;
      case 'tubelight':
        img4_Off=tbOff;
        break;
      case 'exhaustfan':
        img4_Off=bulboff;
        break;
      case '':
        img4_Off=bulboff;
        break;
      case 'null':
        img4_Off=bulboff;
        break;
      case 'ebulb':
        img4_Off=EbOff;
        break;
      default:
        img4_Off=bulboff;
    }
    switch(icon5){
      case 'dimmr':
        img5_Off=dimmerOff;
        break;
      case 'Bicon4':
        img5_Off=bulboff;
        break;
      case 'rgb':
        img5_Off=rgbOff;
        break;
      case 'tv':
        img5_Off=TvOff;
        break;
      case 'curtain':
        img5_Off=CurOff;
        break;
      case 'geyser':
        img5_Off=geyOff;
        break;
      case 'ac':
        img5_Off=acoff;
        break;
      case 'sprinkler':
        img5_Off=sprinklerOff;
        break;
      case 'door':
        img5_Off=dlockOff;
        break;
      case 'auqa':
        img5_Off=aquaOff;
        break;
      case 'disp':
        img5_Off=nameboardOff;
        break;
      case 'bedlamp':
        img5_Off=lampOff;
        break;
      case 'socket':
        img5_Off=socketOff;
        break;
      case 'speaker':
        img5_Off=speakerOff;
        break;
      case 'cfl':
        img5_Off=cflOff;
        break;
      case 'bulb':
        img5_Off=bulboff;
        break;
      case 'Bulb':
        img5_Off=bulboff;
        break;
      case 'tubelight':
        img5_Off=tbOff;
        break;
      case 'exhaustfan':
        img5_Off=bulboff;
        break;
      case '':
        img5_Off=bulboff;
        break;
      case 'null':
        img5_Off=bulboff;
        break;
      case 'ebulb':
        img5_Off=EbOff;
        break;
      default:
        img5_Off=bulboff;
    }

    switch(icon6){
      case 'dimmr':
        img6_Off=dimmerOff;
        break;
      case 'Bicon6':
        img6_Off=bulboff;
        break;
      case 'rgb':
        img6_Off=rgbOff;
        break;
      case 'tv':
        img6_Off=TvOff;
        break;
      case 'curtain':
        img6_Off=CurOff;
        break;
      case 'geyser':
        img6_Off=geyOff;
        break;
      case 'ac':
        img6_Off=acoff;
        break;
      case 'sprinkler':
        img6_Off=sprinklerOff;
        break;
      case 'door':
        img6_Off=dlockOff;
        break;
      case 'auqa':
        img6_Off=aquaOff;
        break;
      case 'disp':
        img6_Off=nameboardOff;
        break;
      case 'bedlamp':
        img6_Off=lampOff;
        break;
      case 'socket':
        img6_Off=socketOff;
        break;
      case 'speaker':
        img6_Off=speakerOff;
        break;
      case 'cfl':
        img6_Off=cflOff;
        break;
      case 'bulb':
        img6_Off=bulboff;
        break;
      case 'Bulb':
        img6_Off=bulboff;
        break;
      case 'tubelight':
        img6_Off=tbOff;
        break;
      case 'exhaustfan':
        img6_Off=bulboff;
        break;
      case '':
        img6_Off=bulboff;
        break;
      case 'null':
        img6_Off=bulboff;
        break;
      case 'ebulb':
        img6_Off=EbOff;
        break;
      default:
        img6_Off=bulboff;
    }
    switch(icon7){

      case 'Bicon7':
        img7_Off=socketNOff;
        break;
      case "":
        img7_Off=socketNOff;
        break;
      case 'Bulb':
        img7_Off=socketNOff;
        break;
      case 'null':
        img7_Off=socketNOff;
        break;
      default:
        img7_Off=socketNOff;
    }


    _globalService.devicenameset=devicename;
    print("80name $devicename");
    setState(() {
      img1_Off=img1_Off;
      img2_Off=img2_Off;
      img3_Off=img3_Off;
      img4_Off=img4_Off;
      img5_Off=img5_Off;
      img6_Off=img6_Off;
      img7_Off=img7_Off;

      devicename=devicename;
    });

    socketsend();
  }

  socketsend(){

    if(s.socketconnected == true) {
      print("sendswdata");
      SendDataSw(senddata: "920", CastType: "01");
    }
    else{
      s.checkindevice(hname80, hnum80);
    }

  }
  void SendDataSw({String senddata, String CastType}) {

    String cast1 = CastType;
    String gI = GroupId80;
    String c = dnum80.padLeft(4, '0');
    String rN = rnum80.padLeft(2, '0');
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

            color:Colors.white,
            width: MediaQuery.of(context).size.width/1.4,
            child: Column(

              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex:1,
                      child: IconButton(
                        iconSize: MediaQuery.of(context).size.width/10,
                        icon:Image.asset('images/switchicons/all_on.png'),
                        splashRadius: 0.1,
                        splashColor:Colors.transparent,
                        onPressed: () {
                          SendDataSw(senddata: "901", CastType: "01");
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
                        onPressed: (){
                          SendDataSw(senddata: "902", CastType: "01");
                        },
                      ),
                    ),
                  ],
                ),


                Padding(padding: const EdgeInsets.all(05.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(padding: const EdgeInsets.all(5.0),
                          child:GestureDetector(
                            onLongPress: (){
                              _globalService.bulbnumberset="b1t";
                              showAlertDialog(context);
                            },
                            child:Transform.scale(
                              scale: 2.5,
                              child: IconButton(
                                  iconSize: MediaQuery.of(context).size.width/10,
                                  icon: imgchange1?img1_On:img1_Off,
                                  splashRadius: 0.1,
                                  splashColor:Colors.transparent ,
                                  onPressed: () {
                                    SendDataSw(senddata: "101", CastType: "01");
                                  }
                              ),
                            ),
                          )
                      ),
                      Padding(padding: const EdgeInsets.all(05.0),
                          child:GestureDetector(
                            onLongPress: (){
                              _globalService.bulbnumberset="b2t";
                              showAlertDialog(context);
                            },
                            child:Transform.scale(
                              scale: 2.5,
                              child: IconButton(
                                  iconSize: MediaQuery.of(context).size.width/10,
                                  icon: imgchange2?img2_On:img2_Off,
                                  splashRadius: 0.1,
                                  splashColor:Colors.transparent ,
                                  onPressed: () {
                                    SendDataSw(senddata: "102", CastType: "01");
                                  }
                              ),
                            ),
                          )
                      ),
                      Padding(padding: const EdgeInsets.all(05.0),
                          child:GestureDetector(
                            onLongPress: (){
                              _globalService.bulbnumberset="b3t";
                              showAlertDialog(context);
                            },
                            child:Transform.scale(
                              scale: 2.5,
                              child: IconButton(
                                  iconSize: MediaQuery.of(context).size.width/10,
                                  icon: imgchange3?img3_On:img3_Off,
                                  splashRadius: 0.1,
                                  splashColor:Colors.transparent ,
                                  onPressed: () {
                                    SendDataSw(senddata: "103", CastType: "01");}
                              ),
                            ),
                          )
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(05.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(padding: const EdgeInsets.all(05.0),
                          child:GestureDetector(
                            onLongPress: (){
                              _globalService.bulbnumberset="b4t";
                              showAlertDialog(context);
                            },
                            child:Transform.scale(
                              scale: 2.5,
                              child: IconButton(
                                  iconSize: MediaQuery.of(context).size.width/10,
                                  icon: imgchange4?img4_On:img4_Off,
                                  splashRadius: 0.1,
                                  splashColor:Colors.transparent ,
                                  onPressed: () {
                                    SendDataSw(senddata: "104", CastType: "01");
                                  }
                              ),
                            ),
                          )
                      ),
                      Padding(padding: const EdgeInsets.all(05.0),
                        child:GestureDetector(
                          onLongPress: (){
                            _globalService.bulbnumberset="b5t";
                            showAlertDialog(context);
                          },
                          child:Transform.scale(
                            scale: 2.5,
                            child: IconButton(
                                iconSize: MediaQuery.of(context).size.width/10,
                                icon: imgchange5?img5_On:img5_Off,
                                splashRadius: 0.1,
                                splashColor:Colors.transparent ,
                                onPressed: () {
                                  SendDataSw(senddata: "105", CastType: "01");
                                }
                            ),
                          ),
                        ),
                      ),
                      Padding(padding: const EdgeInsets.all(05.0),
                          child:GestureDetector(
                            onLongPress: (){
                              _globalService.bulbnumberset="b6t";
                              showAlertDialog(context);
                            },
                            child:Transform.scale(
                              scale: 2.5,
                              child: IconButton(
                                  iconSize: MediaQuery.of(context).size.width/10,
                                  icon: imgchange6?img6_On:img6_Off,
                                  splashRadius: 0.1,
                                  splashColor:Colors.transparent ,
                                  onPressed: () {
                                    SendDataSw(senddata: "106", CastType: "01");
                                  }
                              ),
                            ),
                          )
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(padding: const EdgeInsets.all(10.0),
                          child:GestureDetector(

                            child:Transform.scale(
                              scale: 2.5,
                              child: IconButton(
                                  iconSize: MediaQuery.of(context).size.width/10,
                                  icon: imgchange7?img7_On:img7_Off,
                                  splashRadius: 0.1,
                                  splashColor:Colors.transparent ,
                                  onPressed: () {
                                    SendDataSw(senddata: "107", CastType: "01");
                                  }
                              ),
                            ),
                          )
                      ),
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

