//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home/Swb/switchlayout.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:smart_home/Singleton.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/Swb/Icon_change.dart';


class S042 extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home-page',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'home-page',),

    );
  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{

  GlobalService _globalService = GlobalService();

  var s=Singleton();

  int val,val1,fan;

  Image imagenum_on;
  Image imagenum_off;

  Image bulbon=Image.asset('images/switchicons/bulb_on.png');
  Image bulboff=Image.asset('images/switchicons/bulb_off.png');

  Image imagehvon = Image.asset('images/switchicons/highvolt_on.png');
  Image imagehvoff = Image.asset('images/switchicons/highvolt_off.png');

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

  Image imageup = Image.asset('images/switchicons/speed_up.png' );
  Image imagedown = Image.asset('images/switchicons/speed_down.png',fit: BoxFit.cover,);
  Image imagezero = Image.asset('images/switchicons/0.png');
  Image imageone = Image.asset('images/switchicons/1.png');
  Image imagetwo = Image.asset('images/switchicons/2.png');
  Image imagethree = Image.asset('images/switchicons/3.png');
  Image imagefour = Image.asset('images/switchicons/4.png');


  Image imagefanon  = Image.asset('images/switchicons/fan1.png');
  Image imagefanoff = Image.asset('images/switchicons/fan0.png');

  bool imgchange1=false;
  bool imgchange2=false;
  bool imgchange3=false;
  bool imgchange4=false;

  bool fanimgchange1=false;
  bool fanimgchange2=false;

  String devicename="";

  String hname51,hnum51,rnum51,dnum51,rname51,GroupId51;
  String icon1,icon2,icon3,icon4,icon5;
  Image img1_On,img1_Off,img2_On,img2_Off,img3_On,img3_Off,img4_Off,img4_On,img_FSpeed1,img_FSpeed2;

  @override
  void initState(){

    super.initState();


    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );

    FNC.DartNotificationCenter.unregisterChannel(channel: 'changeicon_switch51');
    FNC.DartNotificationCenter.registerChannel(channel: "changeicon_switch51");
    FNC.DartNotificationCenter.subscribe(channel: "changeicon_switch51", observer: null, onNotification: (options){
      print('SWNOtified:$options');
      swdetails();
    });


    FNC.DartNotificationCenter.unregisterChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'MasterNotification', onNotification: (options) {

      SwResponce(options);
    }, observer: null);


    FNC.DartNotificationCenter.unregisterChannel(channel: 'socketconndevice');
    FNC.DartNotificationCenter.registerChannel(channel: 'socketconndevice');
    FNC.DartNotificationCenter.subscribe(channel: 'socketconndevice', onNotification: (options) {
      socketsend();
    }, observer: null);


    FNC.DartNotificationCenter.unregisterChannel(channel: 'socketdisconndevice');
    FNC.DartNotificationCenter.registerChannel(channel: 'socketdisconndevice');
    FNC.DartNotificationCenter.subscribe(channel: 'socketdisconndevice', onNotification: (options) {
      socketsend();
    }, observer: null);

    img1_Off=bulboff;
    img2_Off=bulboff;
    img3_Off=bulboff;
    img4_Off=imagehvoff;

    img_FSpeed1=imagezero;
    img_FSpeed2=imagezero;

    hname51=hnames;
    hnum51=hnums;
    rnum51=rnums;
    dnum51=dnums;
    rname51=rnames;
    GroupId51=groupIds;

    swdetails();
    print("swb initstate $hname51 $hnum51 $rnum51 $dnum51 $rname51");

  }

  @override
  void dispose(){

    super.dispose();
    //  FNC.DartNotificationCenter.unregisterChannel(channel: "MasterNotification");
  }

  SwResponce(String notification){

    print("Sw $notification");
    print("lenght $notification.length");

    String sdev = dnum51.padLeft(4, '0');
    String rdev = notification.substring(4,8);

    print("responce $sdev,$rdev");

    print(notification[4]);
    print(notification[5]);
    print(notification[6]);
    print(notification[7]);
    print(notification[8]);
    print(notification[9]);
    print(notification[10]);

    if(sdev==(rdev)){

      print("enter sw51 responce");
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
      switch(notification[16]){
        case '0':
          setState(() {
            fanimgchange1=false;
            img_FSpeed1=imagezero;
          });
          break;
        case '1':
          setState(() {
            fanimgchange1=true;
            img_FSpeed1=imageone;
          });
          break;
        case '2':
          setState(() {
            fanimgchange1=true;
            img_FSpeed1=imagetwo;
          });
          break;
        case '3':
          setState(() {
            fanimgchange1=true;
            img_FSpeed1=imagethree;
          });
          break;
        case '4':
          setState(() {
            fanimgchange1=true;
            img_FSpeed1=imagefour;
          });
          break;

        default:
          setState(() {
            fanimgchange1=false;
            img_FSpeed1=imagezero;
          });
          break;
        }

      switch(notification[17]){
        case '0':
          setState(() {
            fanimgchange2=false;
            img_FSpeed2=imagezero;
          });
          break;
        case '1':
          setState(() {
            fanimgchange2=true;
            img_FSpeed2=imageone;
          });
          break;
        case '2':
          setState(() {
            fanimgchange2=true;
            img_FSpeed2=imagetwo;
          });
          break;
        case '3':
          setState(() {
            fanimgchange2=true;
            img_FSpeed2=imagethree;
          });
          break;
        case '4':
          setState(() {
            fanimgchange2=true;
            img_FSpeed2=imagefour;
          });
          break;

        default:
          setState(() {
            fanimgchange2=false;
            img_FSpeed2=imagezero;
          });
          break;
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

    imagenum_on=image_on;

    print("icon $icontype");

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
        imagenum_on = imagehvon;
        break;
      case 'Bicon5':
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
        imagenum_on=bulbon;
    }

    if(swnum==("1")){

      setState(() {
        print("1on");
        img1_On=imagenum_on;
        imgchange1=true;
      });
    }
    else if(swnum==("2")){
      setState(() {
        print("2on");
        img2_On=imagenum_on;
        imgchange2=true;
      });
    }
    else if(swnum==("3")){

      setState(() {
        print("3on");
        img3_On=imagenum_on;
        imgchange3=true;
      });
    }
    else if(swnum==("4")){

      setState(() {
        print("4on");
        img4_On=imagenum_on;
        imgchange4=true;
      });

    }


  }

  imagechangeOff(String icontype, String swnum,Image image_off){

    imagenum_off=image_off;
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
        imagenum_off = imagehvoff;
        break;
      case 'Bicon5':
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



    List res1 = await DBProvider.db.getSwitchBoardDateFromRNumAndHNumWithDN(rnum51, hnum51, dnum51, hname51);
    print("S051 $res1");

    devicename = res1[0]['ec'];
    icon1=res1[0]['bi1'];
    icon2=res1[0]['bi2'];
    icon3=res1[0]['bi3'];
    icon4=res1[0]['bi4'];
    icon5=res1[0]['bi5'];

    print("icons $icon1 $icon2 $icon3 $icon4 $icon5");

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
      case 'geyser':
        img4_Off=geyOff;
        break;
      case 'ac':
        img4_Off=acoff;
        break;
      case 'Bicon4':
        img4_Off=imagehvoff;
        break;
      case "":
        img4_Off=imagehvoff;
        break;
      case 'Bulb':
        img4_Off=imagehvoff;
        break;
      case 'null':
        img4_Off=imagehvoff;
        break;
      default:
        img4_Off=imagehvoff;
    }


    _globalService.devicenameset=devicename;


    print("51name $devicename");
    setState(() {
      img1_Off=img1_Off;
      img2_Off=img2_Off;
      img3_Off=img3_Off;
      img4_Off=img4_Off;

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
      s.checkindevice(hname51, hnum51);
    }

  }

  void SendDataSw({String senddata, String CastType}) {

    String cast1 = CastType;
    String gI = GroupId51;
    String c = dnum51.padLeft(4, '0');
    String rN = rnum51.padLeft(2, '0');
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
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white30,
        body: Center(
          child: Container(
            color: Color.fromRGBO(255, 254, 250,1),
            width: MediaQuery.of(context).size.width/1.4,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,

              children:<Widget> [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    Expanded(
                      flex:1,
                      child: IconButton(
                        iconSize: MediaQuery.of(context).size.width/9,
                        icon:Image.asset('images/switchicons/all_on.png'),
                        onPressed: () {
                          SendDataSw(senddata: "901", CastType: "01");
                        },
                      ),

                    ),

                    Expanded(
                      child:Center(
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
                        icon:Image.asset('images/switchicons/all_off.png'),
                        onPressed: (){
                          SendDataSw(senddata: "902", CastType: "01");
                        },
                      ),

                    ),
                  ],
                ),
                // Padding(padding: const EdgeInsets.all(10.0),),
                Padding(padding: const EdgeInsets.all(0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,

                    children: [
                      Expanded(
                        flex:10,

                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(padding: const EdgeInsets.all(0.0),
                                  child:GestureDetector(
                                    onLongPress: (){
                                      _globalService.bulbnumberset="b1t";
                                      showAlertDialog(context);
                                    },
                                    child: Transform.scale(scale: 2.5,
                                      child: IconButton(
                                        iconSize: MediaQuery.of(context).size.width/10,
                                        icon: imgchange1?img1_On:img1_Off,
                                        splashRadius: 0.1,
                                        splashColor:Colors.transparent ,
                                        onPressed: (){
                                          SendDataSw(senddata: "101", CastType: "01");
                                        },
                                      ),
                                    ),
                                  )
                              ),
                              Padding(padding: const EdgeInsets.all(10.0),),
                              Padding(padding:const EdgeInsets.all(0.0),
                                  child:GestureDetector(
                                      onLongPress: (){
                                        _globalService.bulbnumberset="b2t";
                                        showAlertDialog(context);
                                      },
                                      child:Transform.scale(scale: 2.5,
                                        child: IconButton(
                                          iconSize: MediaQuery.of(context).size.width/10,
                                          icon: imgchange2?img2_On:img2_Off,
                                          splashRadius: 0.1,
                                          splashColor:Colors.transparent ,
                                          onPressed: (){
                                            SendDataSw(senddata: "102", CastType: "01");
                                          },
                                        ),
                                      )
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),


                Padding(padding: const EdgeInsets.all(10.0),),
                Padding(padding: const EdgeInsets.all(0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,

                    children: [
                      Expanded(
                        flex:10,

                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(padding: const EdgeInsets.all(0.0),
                                  child:GestureDetector(
                                    onLongPress: (){
                                      _globalService.bulbnumberset="b3t";
                                      showAlertDialog(context);
                                    },
                                    child: Transform.scale(scale: 2.5,
                                      child: IconButton(
                                        iconSize: MediaQuery.of(context).size.width/10,
                                        icon: imgchange3?img3_On:img3_Off,
                                        splashRadius: 0.1,
                                        splashColor:Colors.transparent ,
                                        onPressed: (){
                                          SendDataSw(senddata: "103", CastType: "01");
                                        },
                                      ),
                                    ),
                                  )
                              ),
                              Padding(padding: const EdgeInsets.all(10.0),),
                              Padding(padding:const EdgeInsets.all(0.0),
                                  child:GestureDetector(
                                      onLongPress: (){
                                        _globalService.bulbnumberset="b4t";
                                        showAlertDialog(context);
                                      },
                                      child:Transform.scale(scale: 2.5,
                                        child: IconButton(
                                          iconSize: MediaQuery.of(context).size.width/10,
                                          icon: imgchange4?img4_On:img4_Off,
                                          splashRadius: 0.1,
                                          splashColor:Colors.transparent ,
                                          onPressed: (){
                                            SendDataSw(senddata: "104", CastType: "01");
                                          },
                                        ),
                                      )
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //Padding(padding: const EdgeInsets.all(8.0),),
                //Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width/45),),
                Padding(padding: EdgeInsets.all(0.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex:10,
                            child: Container(
                              color: Colors.white,

                              child: Row(

                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0.0),
                                      child: Transform.scale(scale: 1.40,
                                        child: IconButton(

                                          iconSize: MediaQuery.of(context).size.width/10,
                                          icon:fanimgchange1?imagefanon:imagefanoff,
                                          splashRadius: 0.1,
                                          splashColor:Colors.transparent ,
                                          onPressed: (){
                                            SendDataSw(senddata: "700", CastType: "01");
                                          },),
                                      ),

                                    ),
                                    flex:2,
                                  ),
                                  Padding(padding: const EdgeInsets.all(0.0),),
                                  Expanded(
                                    child: Transform.scale(scale: 1.5,
                                      child: IconButton(
                                        splashRadius: 0.1,
                                        splashColor:Colors.transparent ,
                                        iconSize: MediaQuery.of(context).size.width/75,
                                        icon: imageup,
                                        onPressed: (){
                                          SendDataSw(senddata: "720", CastType: "01");
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(padding: const EdgeInsets.all(0.0),),
                                  Expanded(
                                    child: Transform.scale(scale: 1.0,
                                      child: IconButton(
                                        splashRadius: 0.1,
                                        splashColor:Colors.transparent,
                                        iconSize: MediaQuery.of(context).size.width/100,
                                        icon: img_FSpeed1,
                                        onPressed: (){

                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(padding: const EdgeInsets.all(0.0),),
                                  Expanded(
                                      child: Transform.scale(scale: 1.5,
                                        child: IconButton(iconSize: MediaQuery.of(context).size.width/50,
                                          splashRadius: 0.1,
                                          splashColor:Colors.transparent ,

                                          icon: imagedown,
                                          onPressed:(){
                                            SendDataSw(senddata: "721", CastType: "01");
                                          },
                                        ),
                                      )
                                  )


                                ],

                              ),
                            ),
                          ),
                        ])
                ),

                Padding(padding: EdgeInsets.all(0.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex:10,
                            child: Container(
                              color: Colors.white,

                              child: Row(

                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0.0),
                                      child: Transform.scale(scale: 1.40,
                                        child: IconButton(

                                          iconSize: MediaQuery.of(context).size.width/10,
                                          icon:fanimgchange2?imagefanon:imagefanoff,
                                          splashRadius: 0.1,
                                          splashColor:Colors.transparent ,
                                          onPressed: (){
                                            SendDataSw(senddata: "730", CastType: "01");
                                          },),
                                      ),

                                    ),
                                    flex:2,
                                  ),
                                  Padding(padding: const EdgeInsets.all(0.0),),
                                  Expanded(
                                    child: Transform.scale(scale: 1.5,
                                      child: IconButton(
                                        splashRadius: 0.1,
                                        splashColor:Colors.transparent ,
                                        iconSize: MediaQuery.of(context).size.width/75,
                                        icon: imageup,
                                        onPressed: (){
                                          SendDataSw(senddata: "750", CastType: "01");
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(padding: const EdgeInsets.all(0.0),),
                                  Expanded(
                                    child: Transform.scale(scale: 1.0,
                                      child: IconButton(
                                        splashRadius: 0.1,
                                        splashColor:Colors.transparent,
                                        iconSize: MediaQuery.of(context).size.width/100,
                                        icon: img_FSpeed2,
                                        onPressed: (){

                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(padding: const EdgeInsets.all(0.0),),
                                  Expanded(
                                      child: Transform.scale(scale: 1.5,
                                        child: IconButton(iconSize: MediaQuery.of(context).size.width/50,
                                          splashRadius: 0.1,
                                          splashColor:Colors.transparent ,

                                          icon: imagedown,
                                          onPressed:(){
                                            SendDataSw(senddata: "751", CastType: "01");
                                          },
                                        ),
                                      )
                                  )


                                ],

                              ),
                            ),
                          ),
                        ])
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