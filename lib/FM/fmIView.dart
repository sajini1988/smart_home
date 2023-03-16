import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home/FM/fm.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/Singleton.dart';
import 'package:smart_home/GlobalService.dart';

class FMIViewState extends StatefulWidget {
  @override
  _FMIViewState createState() => _FMIViewState();

}

class _FMIViewState extends State<FMIViewState> {

  GlobalService _globalService = GlobalService();

  var s=Singleton();

  String hnameFmc,hnumFmc,rnumFmc,dnumFmc,rnameFmc,groupIdFmc,dtypeFmc;
  String devicename="";
  String status="OFF";
  Color colorBoth=Colors.black;
  Color colorOn=Colors.green,colorOff=Colors.red,colorNormal=Colors.black;

  Image back01=Image.asset('images/FM/backward01_fm.png');
  Image back=Image.asset('images/FM/backward_fm.png');

  Image forward01 = Image.asset('images/FM/forward01_fm.png');
  Image forward = Image.asset('images/FM/forward_fm.png');

  Image mode01 = Image.asset('images/FM/mode01_fm.png');
  Image mode = Image.asset('images/FM/mode.png');

  Image mute01 = Image.asset('images/FM/mute_fm01.png');
  Image mute = Image.asset('images/FM/mute_fm.png');

  Image volDown01 = Image.asset('images/FM/vol_down01_fm.png');
  Image volDown = Image.asset('images/FM/vol_down_fm.png');

  Image volUp01 = Image.asset('images/FM/vol_up01_fm.png');
  Image volUp = Image.asset('images/FM/vol_up_fm.png');



  @override
  void initState() {

    super.initState();

    colorBoth=colorNormal;

    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );


    FNC.DartNotificationCenter.unregisterChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'MasterNotification', onNotification: (options) {
      print('FmNotified: $options');
      fmResponce(options);
    }, observer: null);
    // TODO: implement initState

    hnameFmc = hnameFm;
    hnumFmc = hnumFm;
    rnumFmc = rnumFm;
    dnumFmc = dnumFm;
    rnameFmc = rnameFmc;
    groupIdFmc = groupIdFm;
    dtypeFmc = dtypeFm;

    fmDetails();
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

  fmDetails(){
    details();
  }

  void details()async{

    DBHelper dbHelper;
    dbHelper = DBHelper();

    List result = await dbHelper.getLocalDateHName(hnameFm);
    print(result);
    String userAdmin = result[0]['lg'];
    print(userAdmin);

    List acdata = await DBProvider.db.DataFromMTRNumAndHNumGroupIdDetails1WithDN(rnumFm, hnumFm, hnameFm, groupIdFm, dnumFm);
    devicename = acdata[0]['ec'];
    _globalService.devicenameset=devicename;

    setState(() {
      devicename=devicename;
    });

    socketsend();
  }

  socketsend(){

    if(s.socketconnected == true){
      sendDataFm(senddata: "920",castType: "01");
    }
    else{
      s.checkindevice(hnameFm,hnumFm);
    }
  }

  fmResponce(String notification) {
    print("Cur $Notification");
    String cDev = dnumFm.padLeft(4, '0');
    String rDev = notification.substring(4, 8);

    if (cDev==(rDev)) {
      String state = notification.substring(8,9);
      print(state);

      if(state == "0"){
        colorBoth=colorOff;
      }
      else if(state == "1"){
        colorBoth=colorOn;
      }
    }

    setState(() {
      colorBoth=colorOff;
    });
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

              Expanded(
              flex:1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Expanded(
                    child:Transform.scale(
              scale: 1.75,
                    child: IconButton(
                      iconSize: MediaQuery.of(context).size.width/10,
                      splashRadius: 0.1,
                      splashColor:Colors.transparent,
                      icon:Image.asset('images/switchicons/all_on.png'),
                      onPressed: () {
                        sendDataFm(senddata: "201",castType: "01");
                      },
                    ),
                  ),),
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
                    child:Transform.scale(
                      scale: 1.75,
                    child: IconButton(
                      iconSize: MediaQuery.of(context).size.width/10,
                      splashRadius: 0.1,
                      splashColor:Colors.transparent,
                      icon:Image.asset('images/switchicons/all_off.png'),
                      onPressed: () {
                        sendDataFm(senddata: "301",castType: "01");
                      },
                    ),
                  ),
                  )],
              ),),
              Expanded(
                flex:2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  Spacer(),

                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child:Transform.scale(
                      scale: 1.5,
                      child: IconButton(
                          iconSize: MediaQuery.of(context).size.width/10,
                          icon: back,
                          splashRadius: 0.1,
                          splashColor:Colors.transparent ,
                          onPressed: () {
                            sendDataFm(senddata: "117", castType: "01");
                          }
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(05.0),

                    child:Transform.scale(
                      scale: 1.5,
                      child: IconButton(
                          iconSize: MediaQuery.of(context).size.width/10,
                          icon: volDown,
                          splashRadius: 0.1,
                          splashColor:Colors.transparent ,
                          onPressed: () {
                            sendDataFm(senddata: "114", castType: "01");
                          }
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(05.0),
                    child:Transform.scale(
                      scale: 1.5,
                      child: IconButton(
                          iconSize: MediaQuery.of(context).size.width/10,
                          icon: volUp,
                          onPressed: () {
                            sendDataFm(senddata: "113", castType: "01");
                          }
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(05.0),
                    child:Transform.scale(
                      scale: 1.5,
                      child: IconButton(
                          iconSize: MediaQuery.of(context).size.width/10,
                          icon:forward,
                          onPressed: () {
                            sendDataFm(senddata: "116", castType: "01");
                          }
                      ),
                    ),
                  ),

                  Spacer(),
                ],
              ),),

             Expanded(
               flex:1,
               child:Row(

                   crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [

                     TextButton(
                       child: Text("1",style: TextStyle(
                           color: Colors.grey,
                           fontWeight: FontWeight.bold,
                           fontStyle: FontStyle.normal
                       ),),
                       onPressed:() {
                         sendDataFm(senddata: "101", castType: "01");
                       },
                     ),
                     TextButton(
                       child: Text("2",style: TextStyle(
                           color: Colors.grey,
                           fontWeight: FontWeight.bold,
                           fontStyle: FontStyle.normal
                       ),),
                       onPressed:() {
                         sendDataFm(senddata: "102", castType: "01");
                       },
                     ),
                     TextButton(
                       child: Text("3",style: TextStyle(
                           color: Colors.grey,
                           fontWeight: FontWeight.bold,
                           fontStyle: FontStyle.normal
                       ),),
                       onPressed:() {
                         sendDataFm(senddata: "103", castType: "01");
                       },
                     ),

                   ]

               ),

             ),

              Expanded(
                flex:1,
                child:Row(

                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      TextButton(
                        child: Text("4",style: TextStyle(
                color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal
                ),),
                        onPressed:() {
                          sendDataFm(senddata: "104", castType: "01");
                        },
                      ),
                      TextButton(
                        child: Text("5",style: TextStyle(
                        color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal
                        ),),
                        onPressed:() {
                          sendDataFm(senddata: "105", castType: "01");
                        },
                      ),
                      TextButton(
                        child: Text("6",style: TextStyle(
                        color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal
                        )),
                        onPressed:() {
                          sendDataFm(senddata: "106", castType: "01");
                        },
                      ),
                    ]
                ),
              ),
              Expanded(
                flex:1,
                child:Row(

                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      TextButton(
                        child: Text("7",style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal
                        )),
                        onPressed:() {
                          sendDataFm(senddata: "107", castType: "01");
                        },
                      ),
                      TextButton(
                        child: Text("8",style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal
                        )),
                        onPressed:() {
                          sendDataFm(senddata: "108", castType: "01");
                        },
                      ),
                      TextButton(
                        child: Text("9",style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal
                        )),
                        onPressed:() {
                          sendDataFm(senddata: "109", castType: "01");
                        },
                      ),

                    ]

                ),

              ),

              Expanded(
                flex:1,
                child:Row(

                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [


                      Expanded(
                        child: Transform.scale(
                          scale:1.5,
                          child: IconButton(
                            iconSize: MediaQuery.of(context).size.width/10,
                            splashRadius: 0.1,
                            splashColor:Colors.transparent,
                            icon:Image.asset('images/FM/mute_fm.png'),
                            onPressed: (){
                            sendDataFm(senddata: "115", castType: "01");
                          },
                          ),
                        ),
                      ),

                      TextButton(
                        child: Text("0",style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal
                        )),
                        onPressed:() {
                          sendDataFm(senddata: "110", castType: "01");
                        },
                      ),

                      Expanded(

                        child: Transform.scale(
                          scale: 1.75,
                          child:IconButton(
                          iconSize: MediaQuery.of(context).size.width/10,
                          splashRadius: 0.1,
                          splashColor:Colors.transparent,
                          icon:Image.asset('images/FM/fm.jpg'),
                          onPressed: (){
                            sendDataFm(senddata: "118", castType: "01");
                          },
                        ),
                      ),),


                    ]

                ),

              ),

              Expanded(
                flex:1,
                child:Row(

                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [


                      Expanded(

                        child:Transform.scale(
                          scale:1.80,
                        child: IconButton(
                          iconSize: MediaQuery.of(context).size.width/10,
                          splashRadius: 0.1,
                          splashColor:Colors.transparent,
                          icon:Image.asset('images/FM/uwithb.png'),
                          onPressed: (){
                            sendDataFm(senddata: "119", castType: "01");
                          },
                        ),
                      ),),


                    ]

                ),

              ),

             Expanded(
               flex:2,
               child: Row(

                   crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [

                     Spacer()

                   ]

               ),
             )








             // Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width/25),),
             // Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width/25),),

            ],
          ),
        ),
      ),
    );
  }

  void sendDataFm({String senddata, String castType}) {

    String cast1 = castType;
    String gI = groupIdFm;
    String c = dnumFm.padLeft(4, '0');
    String rN = rnumFm.padLeft(2, '0');
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