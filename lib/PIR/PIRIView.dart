import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/PIR/PIRLayout.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/Singleton.dart';
import 'package:smart_home/GlobalService.dart';

class PirIView extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<PirIView> createState() => _PirIViewState();
}

class _PirIViewState extends State<PirIView> {

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

  String hnamepir,hnumpir,rnumpir,dnumpir,rnamepir,groupIdpir,dtypepir;
  String devicename="";

  Image radio = Image.asset('images/PIR/radio.png');
  Image radio1 = Image.asset('images/PIR/radio01.png');

  bool priopir=false;
  bool priolight=false;

  bool priolightvisible=false;
  bool priopirvisible=false;

  bool selectp=false;
  bool selectl=false;

  Image imageintensity = Image.asset("images/PIR/intensity.png");
  Image imageselectintensity = Image.asset("images/PIR/intensity01.png");

  Image imagepir = Image.asset("images/PIR/motion.png");
  Image imageselectpir = Image.asset("images/PIR/motion01.png");

  String alerttimetext="0000";

  TextEditingController Time_Controller;
  String senortymtext="0000";
  String lightvalue="0001";
  String Priority;

  @override
  void initState() {

    // TODO: implement initState

    super.initState();

    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );

    Time_Controller = new TextEditingController(text:alerttimetext);

    FNC.DartNotificationCenter.unregisterChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'MasterNotification', onNotification: (options) {
      print('PIRNotified: $options');
      pirResponce(options);
    }, observer: null);


    hnamepir = hnamep;
    hnumpir = hnump;
    rnumpir = rnump;
    dnumpir = dnump;
    rnamepir = rnamep;
    groupIdpir = groupIdp;
    dtypepir = dtypep;

    print("$hnamepir,$hnumpir,$rnumpir,$dnumpir,$rnamepir,$groupIdpir,$dtypepir");
    pirdetails();

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

  pirdetails(){
    details();
  }
  void details()async{

    DBHelper dbHelper;
    dbHelper = DBHelper();

    List result = await dbHelper.getLocalDateHName(hnamep);
    String UserAdmin = result[0]['lg'];
    print(UserAdmin);

    if (UserAdmin == 'U' || UserAdmin == 'G') {

    }

    List pirdata = await DBProvider.db.DataFromMTRNumAndHNumGroupIdDetails1WithDN(
        rnumpir, hnumpir, hnamepir, groupIdpir, dnumpir);

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
      sendDataPir(sendpir: "920",castType: "01");
    }
    else{
      s.checkindevice(hnamepir,hnumpir);
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
                crossAxisAlignment: CrossAxisAlignment.center,
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
              Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width/25),),
              Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
               child:Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:<Widget> [

                  Expanded(
                    flex:2,
                    child:Visibility(
                      visible: priopirvisible,
                      child:Transform.scale(scale: 0.75,
                        child: IconButton(
                          iconSize: MediaQuery.of(context).size.width/10,
                          splashRadius: 5.0,
                          splashColor:Colors.blue,
                          icon:priopir?radio1:radio,
                          onPressed: (){

                            print("pressed")  ;
                            String priority="1";
                            sendDataPriority(sendpriority: "103",castType: "01",data: priority);
                          },
                        ),
                      ),
                    )
                  ),

                  Expanded(
                    child: Transform.scale(scale: 1.5,
                      child: IconButton(
                        iconSize: MediaQuery.of(context).size.width/10,
                        icon:selectp?imageselectpir:imagepir,
                        splashRadius: 0.1,
                        splashColor:Colors.transparent ,
                        onPressed: ()
                        {

                        },
                      ),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: GestureDetector(
                        onTap: (){
                          showAlertDialogtimer(context);
                        },
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              senortymtext,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal
                              ),
                              maxLines: 2,
                            ),

                          ),
                        )
                    ),
                    flex: 2,
                  ),

                  Expanded(
                    child: IconButton(
                      icon: Image.asset('images/PIR/on.png'), onPressed: () {
                      sendDataPir(sendpir: "909", castType: "01");
                      },
                    ),
                    flex: 2,
                  ),

                  Expanded(
                    child: IconButton(
                      icon: Image.asset('images/PIR/off.png'), onPressed: () {
                        sendDataPir(sendpir: "910", castType: "01");
                      },
                    ),
                    flex: 2,
                  )
                ],
              ),
              ),
              Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width/60),),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children:<Widget> [

                  Expanded(
                    flex:2,
                    child: Visibility(
                      visible: priolightvisible,
                      child: Transform.scale(scale: 0.75,
                        child: IconButton(
                          iconSize: MediaQuery.of(context).size.width/10,
                          splashRadius: 5.0,
                          splashColor:Colors.blue,
                          icon:priolight?radio1:radio,
                          onPressed: (){
                            String priority="2";
                            sendDataPriority(sendpriority: "103",castType: "01",data: priority);
                            },
                        ),
                      ),
                    ),
                  ),


                  Expanded(
                    child: Transform.scale(scale: 1.5,
                      child: IconButton(
                        iconSize: MediaQuery.of(context).size.width/10,
                        icon:selectl?imageselectintensity:imageintensity,
                        splashRadius: 0.1,
                        splashColor:Colors.transparent ,
                        onPressed: (){

                        },),
                    ),

                    flex: 2,
                  ),
                  Expanded(
                    child: GestureDetector(
                        onTap: (){

                        },
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              lightvalue,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal
                              ),
                              maxLines: 2,
                            ),
                          ),
                        )
                    ),
                    flex: 2,
                  ),

                  Expanded(
                    child: IconButton(
                      icon: Image.asset('images/PIR/on.png'), onPressed: () {
                        sendDataPir(sendpir: "101", castType: "01");
                      },
                    ),
                    flex: 2,
                  ),

                  Expanded(
                    child: IconButton(
                      icon: Image.asset('images/PIR/off.png'), onPressed: () {
                        sendDataPir(sendpir: "102", castType: "01");
                      },
                    ),
                    flex: 2,
                  )
                ],
              ),
              Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width/25),),
              Row(),

            ],
          ),
        ),
      ),
    );
  }
  void showAlertDialogtimer(BuildContext context)  {

    // set up the button
    Widget clearbtn = TextButton(
      child: Text("CLEAR"),
      onPressed: () {
        Time_Controller.clear();
      }
    );
    Widget setbutton = TextButton(
      child: Text("SET"),
      onPressed: () {
        String time= Time_Controller.text.padLeft(4,'0');
        print("time is:$time");
        sendDataPirn1(sendpirn1: "000",castType: "01",data: time);
        Navigator.of(context,rootNavigator: true).pop();
        },
    );
    Widget cancelButton = TextButton(
      child: Text("CANCEL"),
      onPressed: () {
        Time_Controller.clear();

        Navigator.of(context,rootNavigator: true).pop();
        //Navigator.of(ctx).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      // content:  TimerPopUp(),
      title: Text("SET TIME"),
      content: TextFormField(
        controller: Time_Controller,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.go,
        maxLength: 4,
        decoration: InputDecoration(
            counterText: alerttimetext
        ),
        onFieldSubmitted: (value) {
          print("Go button is clicked");
        },
      ),
      actions: [
        clearbtn,
        setbutton,
        cancelButton,


      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return alert;
      },
    );
  }
  sendDataPir({String sendpir, String castType}) {
    String cast1 = castType;
    String gI = groupIdp;
    String c = dnump.padLeft(4, '0');
    String rN = rnump.padLeft(2, '0');
    String chr = sendpir;
    String cE = "000000000000000";
    String a = '0';
    String sData = '*' + a + cast1 + gI + c + rN + chr + cE + '#';
    print("Sending String is : $sData"); // output is : 001000000205920000000000000000

    if (s.socketconnected == true) {
      s.socket1(sData);
    }
    else {

    }
  }

  void sendDataPriority({String sendpriority, String castType, String data}) {

    String cast1 = castType;
    String gI = groupIdp;
    String c = dnump.padLeft(4, '0');
    String rN = rnump.padLeft(2, '0');
    String chr = sendpriority;
    String zo = "0000";
    String cE = "0000000000";
    String a = '0';

    String sDataPriority = '*' + a + cast1 + gI + c + rN + chr + zo + data +
        cE + '#';
    print(
        "Sending Priority String is : $sDataPriority}"); // output is : 001000000205920000000000000000

    if (s.socketconnected == true) {
      s.socket1(sDataPriority);
    }
    else {
      print("socket not connected");
    }
  }

  void sendDataPirn1({String sendpirn1, String castType, String data}) {

    String cast1 = castType;
    String gI = groupIdp;
    String c = dnump.padLeft(4, '0');
    String rN = rnump.padLeft(2, '0');
    String chr = sendpirn1;
    String data1 = data.padLeft(4, '0');
    String cE = "00000000000";
    String a ='0';

    String stextvalue = '*' + a + cast1 + gI + c + rN + chr + data1 + cE + '#';
    print(" Text value:$stextvalue");

    if (s.socketconnected == true) {
      s.socket1(stextvalue);
    }
    else {
      print("socket not connected");

    }


  }
  pirResponce(String notification) {
    String sdev = dnump.padLeft(4, '0');
    String rdev = notification.substring(4, 8);

    if (sdev.contains(rdev)) {
      String dNumEE = notification.substring(28, 30);
      String sensorenable = notification[13];
      if (dNumEE == ("01") && (sensorenable == "0")) {
        selectl = false;
        selectp = false;
        String sensortym = notification.substring(8, 12);
        senortymtext = sensortym;
        lightvalue = notification[14];
        setState(() {
          selectl = selectl;
          selectp = selectp;
          senortymtext = senortymtext;
          lightvalue = lightvalue;
        });
      }
      else {
        String sensortym = notification.substring(8, 12);
        senortymtext = sensortym;
        alerttimetext = senortymtext;
        selectp = true;
        lightvalue = notification[14];

        String prioritys = notification[12];
        String sensorenable = notification[13];

        if (prioritys==("1")) {

          if (sensorenable==("0") && dNumEE == ("03")) {
            selectp = true;
            selectl = false;
            priolight=false;
            priopir=false;
            priolightvisible=false;
            priopirvisible=false;

          }
          else if(sensorenable==("1") && dNumEE==("03")){
            selectp = true;
            selectl = true;
            priopir=true;
            priolight=false;

            priolightvisible=true;
            priopirvisible=true;
          }
          else if(sensorenable == ("1") && dNumEE == ("01")){

            print("enter 01");

            selectp = false;
            selectl = true;
            priopir=false;
            priolight=false;

            priolightvisible=false;
            priopirvisible=false;

          }
        }
        else if(prioritys=="2"){

          if(sensorenable==("1") && dNumEE == "03"){

            selectp=true;
            selectl=true;
            priopir=false;
            priolight=true;
            priopirvisible=true;
            priolightvisible=true;

          }
          else if(sensorenable==("0") && dNumEE == "03"){

            selectp=true;
            selectl=false;
            priopir=false;
            priolight=false;
            priopirvisible=false;
            priolightvisible=false;

          }
          else if(sensorenable==("1") && dNumEE == "01"){

            selectp=false;
            selectl=true;
            priopir=false;
            priolight=false;
            priopirvisible=false;
            priolightvisible=false;

          }
        }

        print(priolightvisible);
        print(priopirvisible);









        setState(() {
          selectp=selectp;
          selectl=selectl;
          senortymtext=senortymtext;
          alerttimetext = alerttimetext;
          lightvalue=lightvalue;

        });
      }
    }
  }




}