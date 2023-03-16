import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home/Swb/switchlayout.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:smart_home/Singleton.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/Swb/Icon_change.dart';

class SFN1 extends StatelessWidget {
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

  Image imageup = Image.asset('images/switchicons/speed_up.png' );
  Image imagedown = Image.asset('images/switchicons/speed_down.png');
  Image imagezero = Image.asset('images/switchicons/0.png');
  Image imageone = Image.asset('images/switchicons/1.png');
  Image imagetwo = Image.asset('images/switchicons/2.png');
  Image imagethree = Image.asset('images/switchicons/3.png');
  Image imagefour = Image.asset('images/switchicons/4.png');

  Image imagefanon  = Image.asset('images/switchicons/fan1.png');
  Image imagefanoff = Image.asset('images/switchicons/fan0.png');

  bool fanimgChange1=false;

  String devicename="";

  String hname21,hnum21,rnum21,dnum21,rname21,GroupId21;

  Image img_fSpeed1;


  @override
  void initState(){

    super.initState();

    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );

    FNC.DartNotificationCenter.unregisterChannel(channel: 'socketconndevice');
    FNC.DartNotificationCenter.registerChannel(channel: 'socketconndevice');
    FNC.DartNotificationCenter.subscribe(channel: 'socketconndevice', onNotification: (options) {
      socketsend();
    }, observer: null);

    FNC.DartNotificationCenter.unregisterChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'MasterNotification', onNotification: (options) {
      SwResponce(options);
    }, observer: null);


    img_fSpeed1=imagezero;


    hname21=hnames;
    hnum21=hnums;
    rnum21=rnums;
    dnum21=dnums;
    rname21=rnames;
    GroupId21=groupIds;

    swDetails();

    print("swb initstate $hname21 $hnum21 $rnum21 $dnum21 $rname21");


  }

  SwResponce(String notification){

    print("Sw $Notification");
    print("lenght $Notification.length");

    String sdev = dnum21.padLeft(4, '0');
    String rdev = notification.substring(4,8);

    if(sdev==(rdev)){

      print("enter sw21 responce");


      switch(notification[16]){
        case '0':
          setState(() {
            fanimgChange1=false;
            img_fSpeed1=imagezero;
          });
          break;
        case '1':
          setState(() {
            fanimgChange1=true;
            img_fSpeed1=imageone;
          });
          break;
        case '2':
          setState(() {
            fanimgChange1=true;
            img_fSpeed1=imagetwo;
          });
          break;
        case '3':
          setState(() {
            fanimgChange1=true;
            img_fSpeed1=imagethree;
          });
          break;
        case '4':
          setState(() {
            fanimgChange1=true;
            img_fSpeed1=imagefour;
          });
          break;

        default:
          setState(() {
            fanimgChange1=false;
            img_fSpeed1=imagezero;
          });
          break;

        }
      }
  }
  swDetails(){
    details();
  }

  details()async{

    DBHelper dbHelper;
    dbHelper = DBHelper();
    List result = await dbHelper.getLocalDateHName(hnames);
    String UserAdmin=result[0]['lg'];

    print(UserAdmin);



    List res1 = await DBProvider.db.getSwitchBoardDateFromRNumAndHNumWithDN(rnum21, hnum21, dnum21, hname21);
    print("S051 $res1");

    devicename = res1[0]['ec'];

    _globalService.devicenameset=devicename;

    print("51name $devicename");
    setState(() {


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
      s.checkindevice(hname21, hnum21);
    }

  }

  void SendDataSw({String senddata, String CastType}) {

    String cast1 = CastType;
    String gI = GroupId21;
    String c = dnum21.padLeft(4,'0');
    String rN = rnum21.padLeft(2,'0');
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
                  children: [
                    Expanded(
                      child: IconButton(
                        splashRadius: 0.1,
                        splashColor:Colors.transparent,
                        iconSize: MediaQuery.of(context).size.width/12,
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
                        splashRadius: 0.1,
                        splashColor:Colors.transparent,
                        iconSize: MediaQuery.of(context).size.width/12
                        ,
                        icon:Image.asset('images/switchicons/all_off.png'),
                        onPressed: (){
                          SendDataSw(senddata: "902", CastType: "01");
                        },

                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width/25),),
                Padding(padding: EdgeInsets.all(0.0),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Transform.scale(scale: 1.40,
                            child: IconButton(
                              iconSize: MediaQuery.of(context).size.width/10,
                              icon:fanimgChange1?imagefanon:imagefanoff,
                              splashRadius: 0.1,
                              splashColor:Colors.transparent ,
                              onPressed: (){
                                SendDataSw(senddata: "700", CastType: "01");
                              },),
                          ),

                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: Transform.scale(scale: 1.5,
                          child: IconButton(
                            iconSize: MediaQuery.of(context).size.width/75,
                            icon: imageup,
                            splashRadius: 0.1,
                            splashColor:Colors.transparent ,
                            onPressed: (){
                              SendDataSw(senddata: "720", CastType: "01");
                            },
                          ),
                        ),
                        flex:1,
                      ),

                      Expanded(
                        child: Transform.scale(scale: 1.0,
                          child: IconButton(
                            iconSize: MediaQuery.of(context).size.width/100,
                            icon: img_fSpeed1,
                            splashRadius: 0.1,
                            splashColor:Colors.transparent ,
                            onPressed: (){

                            },
                          ),
                        ),
                      ),
                      Expanded(child: Transform.scale(scale: 1.5,
                        child: IconButton(
                          iconSize: MediaQuery.of(context).size.width/75,
                          icon: imagedown,
                          splashRadius: 0.1,
                          splashColor:Colors.transparent ,
                          onPressed:(){
                            SendDataSw(senddata: "721", CastType: "01");
                          },
                        ),
                      )
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

