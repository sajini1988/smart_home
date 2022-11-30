import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:smart_home/Singleton.dart';
import 'package:smart_home/main1.dart';
import 'package:smart_home/menupage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/gridmodleclass.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/Moods/MoodS010.dart';
import 'package:smart_home/Moods/MoodS020.dart';
import 'package:smart_home/Moods/MoodS021.dart';
import 'package:smart_home/Moods/MoodS030.dart';
import 'package:smart_home/Moods/MoodS051.dart';
import 'package:smart_home/Moods/MoodS080.dart';
import 'package:smart_home/Moods/MoodCurtain.dart';
import 'package:smart_home/Moods/MoodPrjSosh.dart';
import 'package:smart_home/Moods/MoodDB.dart';
import 'package:smart_home/Timer/TimerDB.dart';
import 'package:flutter/services.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:smart_home/Moods/MoodOn.dart';
import 'package:smart_home/Moods/MoodRGB.dart';

String device,roomName,roomNo,houseNum,houseName,groupId,deviceType,deviceNum,dType,gType,first;

void main(){

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
  );
  runApp(MyApp());//
}


class MyApp extends StatelessWidget {

  const MyApp({Key key, this.name, this.lb}) : super(key: key);
  final String name;
  final String lb;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(hname: this.name, hnum: this.lb),
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.hname,this.hnum}) : super(key: key);
  final String hname;
  final String hnum;
  @override
  MyHomePageState createState() => MyHomePageState(hname,hnum);
}

class MyHomePageState extends State<MyHomePage> {

  MyHomePageState(this.name, this.lb);

  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();

  int f=0;

  String hname,hnum,rnum,rname,dnum,groupIdset,ddevmodel,modeltypeset,devicenameset;
  GlobalService _globalService = GlobalService();

  MDBHelper mdb;

  String name;
  String lb;
  String userAdmin,userName;
  Future<List> listdata;
  DBHelper dbHelper;
  static var margin;
  int selectedindexl = 0;
  int selectedindexgr = 0;

  List<Gridmodle>addDataArray=[];
  Future<List<Gridmodle>> gridarray;

  int roomnum;
  String roomname;

  int roommnumtest;
  String roomnametest;

  String roomnamei;
  int roomnumi;

  //for empty layout on click of list and grid
  int empty=0;

  String imgs = "disconnected";
  String imgn= "nonet";
  String options1="No_net";

  bool options2=false;

  bool swb = false;
  bool pir = false;
  bool cur = false;
  bool gsk = false;
  bool sdg = false;
  bool psc = false;
  bool pscL = false;
  bool swng = false;
  bool slide = false;
  bool alxa = false;
  bool mir = false;
  bool ac = false;
  bool gey = false;
  bool bell = false;
  bool lock = false;
  bool somphy = false;
  bool rgb = false;


  String c="null";

  String b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,fan1="No";
  String countSwitch1,countSwitch2,countSwitch3,fanN1Data,fanSwitch1,mooddevicenum,mooddata;

  bool subscribed;

  String img;
  Image imager;

  var s=Singleton();

  List bothr=[];


  // Image Imager1 = Image.asset("images/rooms/im_accounts1.png", fit: BoxFit.fill,);
  // Image Imager2 = Image.asset("images/rooms/im_bathroomm1.png", fit: BoxFit.fill,);
  // Image Imager3 = Image.asset("images/rooms/im_bedroom1.png", fit: BoxFit.fill,);
  // Image Imager4 = Image.asset("images/rooms/im_cgm1.png", fit: BoxFit.fill,);
  // Image Imager5 = Image.asset("images/rooms/im_chef1.png", fit: BoxFit.fill,);
  // Image Imager6 = Image.asset("images/rooms/im_childcare1.png", fit: BoxFit.fill,);
  // Image Imager7 = Image.asset("images/rooms/im_civilroom1.png", fit: BoxFit.fill,);
  // Image Imager8 = Image.asset("images/rooms/im_conference1.png", fit: BoxFit.fill,);
  // Image Imager9 = Image.asset("images/rooms/im_corridor1.png", fit: BoxFit.fill,);
  // Image Imager10 = Image.asset("images/rooms/im_cross1.png", fit: BoxFit.fill,);
  // Image Imager11 = Image.asset("images/rooms/im_dgm1.png", fit: BoxFit.fill,);
  // Image Imager12 = Image.asset("images/rooms/im_diningroom1.png", fit: BoxFit.fill,);
  // Image Imager13;

  void checkConnectivity2() async {

    // Subscribe to the connectivity change
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) async {
          var conn = getConnectionValue(result);

            String _networkStatus2 = '<Subscription> :: ' + conn;
            print("network change $_networkStatus2");
            s.close("In main");
            await Future.delayed(const Duration(milliseconds: 500));
            s.checkindevice(name, lb);

        });
    print( _connectivitySubscription);
  }

  String getConnectionValue(var connectivityResult) {
    String status = '';
    print(connectivityResult);
    switch (connectivityResult) {

      case ConnectivityResult.mobile:
        status = 'Mobile';
        break;
      case ConnectivityResult.wifi:
      //  periodicTimer.cancel();
        status = 'Wi-Fi';
        break;
      case ConnectivityResult.none:
      //  periodicTimer.cancel();
        status = 'None';
        break;
      default:
        status = 'None';
        break;
    }
    return status;
  }

  @override
  void initState() {
    super.initState();

    subscribed=_globalService.subscription;
    print("name $name hnum $lb");
    if (name != null) {
      TimerDBProvider.tdbname = name;
      DBProvider.dbname = name;
     // DBProvider.db.newClient();
      function1();
    }
    else {

      name="fetching";
      function().then((List value) {

        if(value.length <= 0){
          name="No House Downloaded";
        }
        else{
          name=value[0]["name"];
          lb=value[0]["lb"];
          DBProvider.dbname = name;
          TimerDBProvider.tdbname = name;
          function1();
        }
        setState(() {
          name=name;
          lb=lb;
        });
        print("name $name hnum $lb");
      });
    }

    if(subscribed) {

      print("Already subscribed");

      subscribed=_globalService.subscription;
      print("subst $subscribed");

    }
    else{

      _globalService.subscriptionset=true;
      subscribed=_globalService.subscription;
      print("subsf $subscribed");

      FNC.DartNotificationCenter.registerChannel(channel: 'MasterNotification');
      FNC.DartNotificationCenter.registerChannel(channel: 'AddUserNotification');
      FNC.DartNotificationCenter.registerChannel(channel: 'AddAdminNotification');
      FNC.DartNotificationCenter.registerChannel(channel: 'AddGuestNotification');
      FNC.DartNotificationCenter.registerChannel(channel: 'FailAddUserNotification');
      FNC.DartNotificationCenter.registerChannel(channel: 'SuperAdminPasswordNotification');
      FNC.DartNotificationCenter.registerChannel(channel: 'AdminPasswordNotification');
      FNC.DartNotificationCenter.registerChannel(channel: 'UserPasswordNotification');
      FNC.DartNotificationCenter.registerChannel(channel: 'GuestPasswordNotification');
      FNC.DartNotificationCenter.registerChannel(channel: 'FailPasswordNotification');
      FNC.DartNotificationCenter.registerChannel(channel: 'DeleteUserNotification');
      FNC.DartNotificationCenter.registerChannel(channel: 'FailDeleteNotification');
      FNC.DartNotificationCenter.registerChannel(channel: 'UserTimerDeleted');
      FNC.DartNotificationCenter.registerChannel(channel: 'UserDeletedTimernotDeleted');
      FNC.DartNotificationCenter.registerChannel(channel: 'UserTimernotDeleted');
      FNC.DartNotificationCenter.registerChannel(channel: 'SuccessUserNotification');
      FNC.DartNotificationCenter.registerChannel(channel: 'FailUserNotification');
      FNC.DartNotificationCenter.registerChannel(channel: 'UserAddedSuccessfully');
      FNC.DartNotificationCenter.registerChannel(channel: 'GuestAddedSuccessfully');
      FNC.DartNotificationCenter.registerChannel(channel: 'AdminAddedSuccessfully');
      FNC.DartNotificationCenter.registerChannel(channel: 'UserWithRoomsAddedError');
      FNC.DartNotificationCenter.registerChannel(channel: 'User_not_present_in_UserTable');
      FNC.DartNotificationCenter.registerChannel(channel: 'Error while updating to server Details');
      FNC.DartNotificationCenter.registerChannel(channel: 'Error while updating to user table');
      FNC.DartNotificationCenter.registerChannel(channel: 'Invalid Data Format');
      FNC.DartNotificationCenter.registerChannel(channel: 'DeleteDevice');
      FNC.DartNotificationCenter.registerChannel(channel: 'DeleteRoom');
      FNC.DartNotificationCenter.registerChannel(channel: "DownLoadW");
      FNC.DartNotificationCenter.registerChannel(channel: "DownLoadWLS");
      FNC.DartNotificationCenter.registerChannel(channel: "changeicon_switch51");
      FNC.DartNotificationCenter.registerChannel(channel: "changeicon_switch20");
      FNC.DartNotificationCenter.registerChannel(channel: "changeicon_switch30");
      FNC.DartNotificationCenter.registerChannel(channel: "changeicon_switch21");
      FNC.DartNotificationCenter.registerChannel(channel: "changeicon_switch10");
      FNC.DartNotificationCenter.registerChannel(channel: "changeicon_switch80");

      //gateway

      FNC.DartNotificationCenter.registerChannel(channel: 'get_time');
      FNC.DartNotificationCenter.registerChannel(channel: 'get_ssid');
      FNC.DartNotificationCenter.registerChannel(channel: 'get_version');
      FNC.DartNotificationCenter.registerChannel(channel: 'get_ebcode');

      //connect & disconnect socket

      FNC.DartNotificationCenter.registerChannel(channel: "socketconndevice");
      FNC.DartNotificationCenter.registerChannel(channel: "socketdisconndevice");

      //Delete Timers
      FNC.DartNotificationCenter.registerChannel(channel: "deleteSuccess");
      FNC.DartNotificationCenter.registerChannel(channel: "deleteError");

      //Update Timers
      FNC.DartNotificationCenter.registerChannel(channel: "updateSuccess");
      FNC.DartNotificationCenter.registerChannel(channel: "updateFailure");

      //updateList
      FNC.DartNotificationCenter.registerChannel(channel: "timerlistupdate");

    }

  }


  Future<int> signalFunc() async {

    Future<int> i = WiFiForIoTPlugin.getCurrentSignalStrength();
    return i;


  }

  void nwimage(String options){

    if (options==("Mobile")) {
      print("Mobile");
      imgn = "3g";
      setState(() {
        imgn=imgn;
      });

    }
    else if (options==("LWi-Fi")) {

      imgn = 'local_sig';
      setState(() {
        imgn=imgn;
      });

      signalFunc().then((int value) {

        fluttertoast(value.toString());
        // periodicTimer = Timer.periodic(
        //   const Duration(seconds: 1),
        //       (timer) {
        //     // Update user about remaining time
        //   },
        // );

      });

    }
    else if (options==("RWi-Fi")) {
      imgn = 'remote01';

      signalFunc().then((int value) {

        fluttertoast(value.toString());
        // periodicTimer = Timer.periodic(
        //   const Duration(seconds: 1),
        //       (timer) {
        //     // Update user about remaining time
        //   },
        // );

      });
      setState(() {
        imgn=imgn;
      });
    }
    else if (options==("No_Net")) {
      imgn = 'nonet';
      setState(() {
        imgn=imgn;
      });
    }

  }

  void swimage(bool s1){

    print(s1);
    if(s1==false){
      imgs = "disconnected";
    }
    else if(s1 == true){
      imgs = "connected";
    }

    setState(() {
      imgs=imgs;

    });
  }


  getrooms() {
    setState(() {
        listdata=listdata;

    });
  }

  getglist(){

    setState(() {
      gridarray = gridarray;
      first=first;
    });
  }

  Future<List> function() async {

    dbHelper = DBHelper();
    List res = await dbHelper.getall();
    print(res);
    return res;

  }

  Future<List<Gridmodle>> getgridlist() {
    return Future.delayed(Duration(seconds: 0), () {
      return addDataArray;
      // throw Exception("Custom Error");
    });
  }

  @override
  void dispose() {

    print("dispose main");
    _connectivitySubscription.cancel();
    super.dispose();

  }

  @override
  Widget build(BuildContext context)=>FocusDetector(

      onFocusLost: () {
        print("focus lost");

     //   periodicTimer.cancel();

        FNC.DartNotificationCenter.unregisterChannel(channel: "networkconn");
        FNC.DartNotificationCenter.unregisterChannel(channel: "socketconn");
      },
      onFocusGained: () {
        print("focus gained");
        print(s.socketconnected);

        FNC.DartNotificationCenter.registerChannel(channel: 'networkconn');
        FNC.DartNotificationCenter.subscribe(channel: 'networkconn', onNotification: (options) {
          print('Notified: $options');
          print(subscribed);
          options1=options;
          setState(() {
            options1=options1;
          });
          nwimage(options1);
        }, observer: null,
        );

        FNC.DartNotificationCenter.registerChannel(channel: 'socketconn');
        FNC.DartNotificationCenter.subscribe(channel: 'socketconn', onNotification: (options) {
          print('Notified: $options');
          print(subscribed);
          options2=options;
          setState(() {
            options2=options2;
          });
          swimage(options2);
        }, observer: null,
        );

        nwimage(s.networkconnected);
        swimage(s.socketconnected);

        function1();

      },
      child: WillPopScope(
        onWillPop: () async {
        return _onBackPressed();

        },
        child: Scaffold(

        appBar: AppBar(
         // backgroundColor: Color.fromRGBO(66, 130, 208, 255),
          backgroundColor: Color.fromRGBO(66, 130, 208, 1),
          title: widget.hname != null ? Text(widget.hname) : Text(name),
          actions: <Widget>[

            IconButton(
              icon: Image.asset('images/$imgs.png', fit: BoxFit.cover),
              onPressed: () {
                s.checkindevice(name, lb);
              },
            ),

            IconButton(
              icon: Image.asset('images/$imgn.png', fit: BoxFit.cover),
              onPressed: () {

              },
            ),

            IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              onPressed: () {
                // do something
              },
            ),
            ],
          ),
          body: Container(
          child: Row(
            children: <Widget>[
              Expanded(
                //flex: 2,
                child: Column(
                children:[

                  Image.asset("images/rooms/logo.png", fit: BoxFit.fill,height: 62.0),

                  Flexible(
                    child:Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,

                  child: FutureBuilder<List>(
                    future: listdata,
                    builder: (context, snapshot) {
                      print("snap data : ${snapshot.hasData}");
                      print('List Data:${snapshot.data}');

                      if (snapshot.hasData) {
                        return ListView.builder
                          (
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {

                              if (index == selectedindexl) {

                                // when it is pressed it gets refereshed here
                                img = snapshot.data[index]['eb'] + '1';
                                print(" list $roomname $roomnum");

                                roomname = snapshot.data[index]['b'];
                                roomnum = snapshot.data[index]['a'];

                                print("$img");

                                imager = Image.asset("images/rooms/$img.png", fit: BoxFit.fill,);
                              }
                              else {
                                img = snapshot.data[index]['eb'];

                                if(img == "im_toiletcorridor1"){
                                 // Imager=Imager13;
                                }
                                else{
                                  imager = Image.asset("images/rooms/$img.png", fit: BoxFit.fill,);
                                }

                              }

                              return Column(
                                children: <Widget>[

                                  GestureDetector(
                                    onTap: () {
                                      //Scaffold.of(context).showSnackBar(SnackBar(content: Text(index.toString())));
                                      print("On Tap");
                                      setState(() {

                                        // swb=false;
                                        // cur=false;
                                        // pir=false;
                                        // sdg=false;
                                        // gsk=false;

                                        // when it is pressed change the index of it
                                        selectedindexgr = 0;
                                        selectedindexl = index;
                                        empty = 0;
                                      }
                                      );
                                      roomnamei = snapshot.data[index]['b'];
                                      roomnumi = snapshot.data[index]['a'];
                                      gridview(roomnamei, roomnumi);
                                    },
                                    //child: imager,


                                    child: Card(

                                      margin: EdgeInsets.only(left:0.0,top:4,right:0.0,bottom: 4),
                                      elevation: 00,
                                      //shadowColor: Colors.black,
                                      //color: Colors.grey[300],
                                      color: selectedindexl == index ?  Colors.grey[300] : Colors.white70,

                                      child:  Stack(

                                        alignment:Alignment.center,
                                        children: <Widget>[
                                          Align(
                                            //alignment: Alignment.center,
                                            child:imager,
                                          ),
                                          Positioned.fill(
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Text(snapshot.data[index]['b'],
                                                  style: TextStyle(fontWeight: FontWeight.normal,fontSize: 11.0, color: selectedindexl == index ? Color.fromRGBO(66, 130, 208, 1) : Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),


                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    height: 0,
                                    color: Colors.black12,
                                    indent: 0, //spacing at the start of divider
                                    endIndent: 0,
                                  )
                                ],
                              );
                            }

                        );
                      }
                      if (snapshot.data == null || snapshot.data.length == 0) {
                        print("NoDataFound");
                        return Text('No Data Found');
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                ),
              ),],),),
              Container(
                width: 2.5,
                height: double.maxFinite,
                color: Colors.grey,
              ),

              //Gridview

              new Column(
                children:<Widget> [
                  Expanded(
                    flex:10,
                      child: Container(
                      width: MediaQuery.of(context).size.width * 0.70,
                        child: Column(
                        children: <Widget>[
                          Expanded(
                          flex:2000,
                            child:Container(
                              child: FutureBuilder<List<Gridmodle>>(
                                future: gridarray,
                                initialData: [],
                                builder: (context, snapshot) {
                                  // print("G snap data : ${snapshot.hasData}");
                                  // print('G List Data:${snapshot.data}');
                                  if (snapshot.hasData) {
                                    return GridView.builder(
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            childAspectRatio: 1.65
                                        ),
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index) {
                                         // String name = snapshot.data[index].name;
                                          String img;
                                          if (index == selectedindexgr) {
                                            img = snapshot.data[index].selectedimg;
                                          }
                                          else{
                                            img = snapshot.data[index].img;
                                          }
                                          //  print("$name,$img");

                                          return Container(
                                            alignment: Alignment.topLeft,
                                            child:GestureDetector(
                                              onTap: (){
                                                setState(() {
                                                    selectedindexgr = index;
                                                  });
                                                  c = snapshot.data[index].name;
                                                  checkGridFunction();
                                                  print("$roomnumi,$roomnamei");

                                                },
                                                child: new Image.asset(
                                                'images/gridicons/$img.png',
                                                fit: BoxFit.cover,
                                                width: MediaQuery.of(context).size.width,
                                                height: MediaQuery.of(context).size.height,
                                              ),
                                            ),
                                                    // child: new Text(addDataArray[index].name),
                                                    // decoration: BoxDecoration(
                                                    //     color: Colors.amber,
                                                    //     borderRadius: BorderRadius.circular(15)),
                                          );
                                        }
                                        );
                                  }
                                  if (snapshot.data == null || snapshot.data.length == 0) {
                                    return Text('No Data Found');
                                  }
                                  return CircularProgressIndicator();
                                  },
                              ),

                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .70,
                            height: 2.5,
                            color: Colors.grey,
                          ),
                          Expanded(

                            flex: 5000,
                            child:Container(
                              width: MediaQuery.of(context).size.width * .70,
                              color: Colors.white38,
                              child: Column(
                                children: [
                                  Expanded(child: getchild())
                                ],
                              ),
                            ),
                          ),

                          Expanded(
                            flex:550,
                            child:Container(
                              width: MediaQuery.of(context).size.width * .70,
                              color: Colors.black26,
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[

                                  Expanded(
                                      flex:3,
                                      child: GestureDetector(
                                          onLongPress: (){
                                            print("long press1");
                                            _globalService.moodnumset="1";
                                            moods("1");
                                          },
                                          onTap: (){
                                            print("On Tap1");
                                            moodtap("1");
                                          },
                                          child: Container(
                                           // color: Colors.white,
                                          decoration: BoxDecoration(
                                          //color: Colors.black,
                                          image: DecorationImage(
                                              image:AssetImage("images/Moods/mood1.png"),
                                              fit:BoxFit.cover
                                          ),

                                        ),
                                      ))

                                  ),
                                  Padding(padding: const EdgeInsets.all(0.5),),
                                  Expanded(
                                      flex:3,
                                      child: GestureDetector(
                                          onLongPress: (){
                                            _globalService.moodnumset="2";
                                            print("long press2");
                                            moods("2");
                                          },
                                          onTap: (){
                                            print("on Tap2");
                                            moodtap("2");
                                            },
                                          child: Container(
                                          decoration: BoxDecoration(
                                          //color: Colors.black,
                                          image: DecorationImage(
                                              image:AssetImage("images/Moods/mood2.png"),
                                              fit:BoxFit.cover
                                            ),

                                          ),
                                        )
                                      )

                                  ),
                                  Padding(padding: const EdgeInsets.all(0.5),),
                                  Expanded(
                                     flex:3,
                                      child: GestureDetector(
                                        onLongPress: (){
                                          _globalService.moodnumset="3";
                                          print("on longpress3");
                                          moods("3");
                                        },
                                          onTap: (){
                                            print("On Tap3");
                                            moodtap("3");
                                          },
                                          child: Container(
                                          decoration: BoxDecoration(
                                          //color: Colors.black,
                                          image: DecorationImage(
                                              image:AssetImage("images/Moods/mood3.png"),
                                              fit:BoxFit.cover
                                          ),

                                        ),
                                      ))

                                  ),
                                 // Padding(padding: const EdgeInsets.all(1.0),),
                                ],
                              ),

                            ),
                          ),
                          //Padding(padding: const EdgeInsets.all(2.0),),
                        ],
                      ),

                    )
                  ),
                ],
              )

            ],

          ),
        ),

        drawer: SideDrawer(),
      ),
    ));

  moodtap(String number)async{


    if(userAdmin == "A" || userAdmin == "SA" || userAdmin == "U"){

      DBHelper dbHelper = DBHelper();

      mdb = MDBHelper();

      hnum=_globalService.hnum;
      rnum=_globalService.rnum;
      hname=_globalService.hname;

      List result = await dbHelper.getLocalDateHName(hname);
      // print("res $result");

      String username = result[0]['ld'];

      List res = await mdb.getcountofmoods(hname,hnum, rnum, number, username);
      f=0;
      //  print("res count $res");

      if(res.length == 0){

        print("moods not set. Please set moods");
        fluttertoast("Mood Not Set. Please set Moods");

      }

      else{

        showDialog(
            context: context,
            barrierDismissible:false ,
            builder: (BuildContext context) {
              return Center(child: CircularProgressIndicator(),);
            }
        );

        f=0;
        List res1 = await mdb.getFromUserDataHNumDNameWithDevice(hname,hnum, rnum, number, "S051", username);
        for(int i=0;i<res1.length;i++){

          b1=b2=b3=b4=b5=b6=b7=b8=b9=b10=b11=b12=fan1="No";
          print("S051 $res1");

          String deviceData = res1[i]['dd'];
          String _s051dvnum = res1[i]['dno'];
          String _s051Yes = res1[i]['ea'];

          print("data $deviceData,$_s051dvnum,$_s051Yes");

          if(_s051Yes.contains("Yes")){
            switchboard(_s051dvnum, deviceData);
            timerSwitch("s051");

            await Future.delayed(const Duration(milliseconds: 500));
          }
        }
        List res2 = await mdb.getFromUserDataHNumDNameWithDevice(hname,hnum, rnum, number, "S021", username);
        for(int i=0;i<res2.length;i++){

          b1=b2=b3=b4=b5=b6=b7=b8=b9=b10=b11=b12=fan1="No";
          print("S021 $res2");

          String deviceData = res2[i]['dd'];
          String _s021dvnum = res2[i]['dno'];

          String _s021Yes = res2[i]['ea'];

          if(_s021Yes.contains("Yes")){
            switchboard(_s021dvnum, deviceData);
            timerSwitch("s021");

            await Future.delayed(const Duration(milliseconds: 500));
          }
        }

        List res3 = await mdb.getFromUserDataHNumDNameWithDevice(hname,hnum, rnum, number, "S030", username);
        for(int i=0;i<res3.length;i++){

          b1=b2=b3=b4=b5=b6=b7=b8=b9=b10=b11=b12=fan1="No";
          print("S030 $res3");

          String deviceData = res3[i]['dd'];
          String _s030dvnum = res3[i]['dno'];
          String _s030Yes = res3[i]['ea'];

          if(_s030Yes.contains("Yes")){
            switchboard(_s030dvnum, deviceData);
            timerSwitch("s030");

            await Future.delayed(const Duration(milliseconds: 500));
          }


        }

        List res4 = await mdb.getFromUserDataHNumDNameWithDevice(hname,hnum, rnum, number, "S080", username);
        for(int i=0;i<res4.length;i++){

          b1=b2=b3=b4=b5=b6=b7=b8=b9=b10=b11=b12=fan1="No";
          print("S080 $res4");

          String deviceData = res4[i]['dd'];
          String _s080dvnum = res4[i]['dno'];
          String _s080Yes = res4[i]['ea'];

          if(_s080Yes.contains("Yes")){
            switchboard(_s080dvnum, deviceData);
            timerSwitch("S080");
            await Future.delayed(const Duration(milliseconds: 500));
          }
        }

        List res5 = await mdb.getFromUserDataHNumDNameWithDevice(hname,hnum, rnum, number, "S020", username);
        for(int i=0;i<res5.length;i++){

          b1=b2=b3=b4=b5=b6=b7=b8=b9=b10=b11=b12=fan1="No";
          print("S020 $res5");

          String deviceData = res5[i]['dd'];
          String _s020dvnum = res5[i]['dno'];
          String _s020Yes = res5[i]['ea'];

          if(_s020Yes.contains("Yes")){
            switchboard(_s020dvnum, deviceData);
            timerSwitch("s020");
            await Future.delayed(const Duration(milliseconds: 500));
          }
        }

        List res6 = await mdb.getFromUserDataHNumDNameWithDevice(hname,hnum, rnum, number, "S010", username);
        for(int i=0;i<res6.length;i++){

          b1=b2=b3=b4=b5=b6=b7=b8=b9=b10=b11=b12=fan1="No";
          print("S010 $res6");

          String deviceData = res6[i]['dd'];
          String _s010dvnum = res6[i]['dno'];
          String _s010Yes = res6[i]['ea'];

          print("data $deviceData,dnum $_s010dvnum,yes $_s010Yes");

          if(_s010Yes.contains("Yes")){
            switchboard(_s010dvnum, deviceData);
            timerSwitch("s010");
            await Future.delayed(const Duration(milliseconds: 500));
          }
        }

        List res7 = await mdb.getFromUserDataHNumDNameWithDevice(hname,hnum, rnum, number, "CLNR", username);

        for(int i=0;i<res7.length;i++){

          String deviceData = res7[i]['dd'];
          String curDvnum = res7[i]['dno'];
          String curYes = res7[i]['ea'];

          print("dd $deviceData dvnum$curDvnum yes$curYes");

          if(curYes.contains("Yes")){

            print(" CLNR $res7");
            List<String> dvnum = curDvnum.split(',');
            print(dvnum);
            List<String> data = deviceData.split(',');
            print(data);

            String dvnumcu,dvnumsh,datacu,dataSh,curdata,sheerData;

            if(data.length == 1){

              dvnumcu = dvnum[0];
              datacu = data[0];

              curdata = dvnumcu+','+datacu;

              Timer(Duration(seconds: f
              ), () {
                print(f);
                print("Yeah cu_n, this line is printed after $f second");
                curtain(curdata);
                f+=1;
              });

            }
            else if(dvnum.length == 2){

              dvnumcu = dvnum[0];
              dvnumsh = dvnum[1];

              datacu = data[0];
              dataSh = data[1];

              curdata = dvnumcu+','+datacu;
              sheerData = dvnumsh +','+dataSh;

              Timer(Duration(seconds: f
              ), () {
                print(f);
                print("Yeah cu_n, this line is printed after $f second");
                curtain(curdata);
                f+=1;
              });

              await Future.delayed(const Duration(milliseconds: 500));

              print("clnrsh $f");
              Timer(Duration(seconds: f
              ), () {
                print(f);
                print("Yeah cn_sh, this line is printed after $f second");
                curtain(sheerData);
                f+=1;

              });

            }

            await Future.delayed(const Duration(milliseconds: 500));
          }
        }

        List res8 = await mdb.getFromUserDataHNumDNameWithDevice(hname,hnum, rnum, number, "CRS1", username);

        for(int i=0;i<res8.length;i++){

          String deviceData = res8[i]['dd'];
          String curDvnum = res8[i]['dno'];
          String curYes = res8[i]['ea'];

          if(curYes.contains("Yes")){

            print("CRS1 $res8");

            List<String> dvnum = curDvnum.split(',');
            List<String> data = deviceData.split(',');

            String dvnumcu = dvnum[0];
            String datacu = data[0];

            String curdata = dvnumcu+','+datacu;

            print("fcr is $f");
            Timer(Duration(seconds: f
            ), () {
              print("Yeah crs, this line is printed after $f second");
              curtain(curdata);
              f+=0;

            });

            await Future.delayed(const Duration(milliseconds: 500));
          }
        }

        List res9 = await mdb.getFromUserDataHNumDNameWithDevice(hname,hnum, rnum, number, "CLS1", username);
        for(int i=0;i<res9.length;i++){

          String deviceData = res9[i]['dd'];
          String curDvnum = res9[i]['dno'];
          String curYes = res9[i]['ea'];

          if(curYes.contains("Yes")){

            print("CLS1 $res9");

            List<String> dvnum = curDvnum.split(',');
            List<String> data = deviceData.split(',');

            String dvnumcu = dvnum[0];
            String datacu = data[0];

            String curdata = dvnumcu+','+datacu;

            print("cls1 $f");
            Timer(Duration(seconds: f
            ), () {
              print(f);
              print("Yeah cls, this line is printed after $f second");
              curtain(curdata);
              f+=0;

            });

            await Future.delayed(const Duration(milliseconds: 500));

          }

        }

        List res10 = await mdb.getFromUserDataHNumDNameWithDevice(hname,hnum, rnum, number, "SOSH", username);
        for(int i=0;i<res10.length;i++) {
          String deviceData = res10[i]['dd'];
          String soshDvnum = res10[i]['dno'];
          String soshYes = res10[i]['ea'];

          if (soshYes==("Yes")) {
            print("SOSH $res10");

            List<String> dvnum = soshDvnum.split(',');
            List<String> data = deviceData.split(',');

            String dvnumSosh = dvnum[0];
            String dataSosh = data[0];

            String soshData = dvnumSosh + ',' + dataSosh;


            Timer(Duration(seconds: f
            ), () {
              curtain(soshData
              );
              f += 0;
            });

            await Future.delayed(const Duration(milliseconds: 500));
          }

        }

        List res11 = await mdb.getFromUserDataHNumDNameWithDevice(hname,hnum, rnum, number, "SWG1", username);
        for(int i=0;i<res11.length;i++) {
          String deviceData = res11[i]['dd'];
          String swingDvnum = res11[i]['dno'];
          String swingYes = res11[i]['ea'];

          if (swingYes==("Yes")) {
            print("SWG1 $res11");


            List<String> dvnum = swingDvnum.split(',');
            List<String> data = deviceData.split(',');

            String dvnumSwg = dvnum[0];
            String dataSwg= data[0];

            String swngData = dvnumSwg + ',' + dataSwg;

            Timer(Duration(seconds: f
            ), () {
              print(f);
              print("Yeah cls, this line is printed after $f second");
              curtain(swngData);
              f += 0;
            });

            await Future.delayed(const Duration(milliseconds: 500));
          }
        }

        List res12 = await mdb.getFromUserDataHNumDNameWithDevice(hname,hnum, rnum, number, "SLG1", username);
        for(int i=0;i<res12.length;i++) {
          String deviceData = res12[i]['dd'];
          String slideDvnum = res12[i]['dno'];
          String slideYes = res12[i]['ea'];

          if (slideYes==("Yes")) {
            print("SLG1 $res12");

            List<String> dvnum = slideDvnum.split(',');
            List<String> data = deviceData.split(',');

            String dvnumSlg = dvnum[0];
            String dataSlg= data[0];

            String swngData = dvnumSlg + ',' + dataSlg;

            Timer(Duration(seconds: f
            ), () {
              curtain(swngData);
              f += 0;
            });

            await Future.delayed(const Duration(milliseconds: 500));
          }
        }

        List res13 = await mdb.getFromUserDataHNumDNameWithDevice(hname,hnum, rnum, number, "GSK1", username);
        for(int i=0;i<res13.length;i++) {
          String deviceData = res13[i]['dd'];
          String spnkDvnum = res13[i]['dno'];
          String spnkYes = res13[i]['ea'];

          if (spnkYes==("Yes")) {
            print("SLG1 $res12");

            List<String> dvnum = spnkDvnum.split(',');
            List<String> data = deviceData.split(',');

            String dvnumSpnk = dvnum[0];
            String dataSpnk= data[0];

            String spnkData = dvnumSpnk + ',' + dataSpnk;

            Timer(Duration(seconds: f
            ), () {
              curtain(spnkData);
              f += 0;
            });

            await Future.delayed(const Duration(milliseconds: 500));
          }


        }

        List res14 = await mdb.getFromUserDataHNumDNameWithDevice(hname,hnum, rnum, number, "SDG1", username);

        for(int i=0;i<res14.length;i++) {
          String deviceData = res14[i]['dd'];
          String sdgDvnum = res14[i]['dno'];
          String sdgYes = res14[i]['ea'];

          if (sdgYes==("Yes")) {
            print("SLG1 $res12");

            List<String> dvnum = sdgDvnum.split(',');
            List<String> data = deviceData.split(',');

            String dvnumSdg = dvnum[0];
            String dataSdg= data[0];

            String spnkData = dvnumSdg + ',' + dataSdg;

            Timer(Duration(seconds: f
            ), () {
              curtain(spnkData);
              f += 0;
            });

            await Future.delayed(const Duration(milliseconds: 500));
          }
        }

        List res15 = await mdb.getFromUserDataHNumDNameWithDevice(hname,hnum, rnum, number, "PSC1", username);
        for(int i=0;i<res15.length;i++) {
          String deviceData = res15[i]['dd'];
          String sdgDvnum = res15[i]['dno'];
          String sdgYes = res15[i]['ea'];

          if (sdgYes==("Yes")) {
            print("SLG1 $res15");

            List<String> dvnum = sdgDvnum.split(',');
            List<String> data = deviceData.split(',');

            String dvnumSdg = dvnum[0];
            String dataSdg= data[0];

            String spnkData = dvnumSdg + ',' + dataSdg;

            Timer(Duration(seconds: f
            ), () {
              curtain(spnkData);
              f += 0;
            });

            await Future.delayed(const Duration(milliseconds: 500));
          }
        }

        List res16 = await mdb.getFromUserDataHNumDNameWithDevice(hname,hnum, rnum, number, "PLC1", username);
        for(int i=0;i<res16.length;i++) {
          String deviceData = res16[i]['dd'];
          String sdgDvnum = res16[i]['dno'];
          String sdgYes = res16[i]['ea'];

          if (sdgYes==("Yes")) {
            print("SLG1 $res16");

            List<String> dvnum = sdgDvnum.split(',');

            List<String> data = deviceData.split(',');

            String dvnumSdg = dvnum[0];
            String dataSdg= data[0];

            String spnkData = dvnumSdg + ',' + dataSdg;

            Timer(Duration(seconds: f
            ), () {
              curtain(spnkData);
              f += 0;
            });

            await Future.delayed(const Duration(milliseconds: 500));
          }
        }

        List res17 = await mdb.getFromUserDataHNumDNameWithDevice(hname,hnum, rnum, number, "ACR1", username);
        for(int i=0;i<res17.length;i++) {
          String deviceData = res17[i]['dd'];
          String sdgDvnum = res17[i]['dno'];
          String sdgYes = res17[i]['ea'];

          if (sdgYes==("Yes")) {
            print("SLG1 $res17");

            List<String> dvnum = sdgDvnum.split(',');
            List<String> data = deviceData.split(',');

            String dvnumSdg = dvnum[0];
            String dataSdg= data[0];

            String spnkData = dvnumSdg + ',' + dataSdg;

            Timer(Duration(seconds: f
            ), () {
              curtain(spnkData);
              f += 0;
            });

            await Future.delayed(const Duration(milliseconds: 500));
          }
        }

        List res18 = await mdb.getFromUserDataHNumDNameWithDevice(hname,hnum, rnum, number, "GSR1", username);
        for(int i=0;i<res18.length;i++) {
          String deviceData = res18[i]['dd'];
          String sdgDvnum = res18[i]['dno'];
          String sdgYes = res18[i]['ea'];

          if (sdgYes==("Yes")) {
            print("SLG1 $res18");

            List<String> dvnum = sdgDvnum.split(',');

            List<String> data = deviceData.split(',');

            String dvnumSdg = dvnum[0];
            String dataSdg= data[0];

            String spnkData = dvnumSdg + ',' + dataSdg;

            Timer(Duration(seconds: f
            ), () {
              curtain(spnkData);
              f += 0;
            });

            await Future.delayed(const Duration(milliseconds: 500));
          }
        }

        List res19 = await mdb.getFromUserDataHNumDNameWithDevice(hname,hnum, rnum, number, "RGB1", username);
        print("res $res19");
        for(int i=0;i<res19.length;i++) {
          String deviceData = res19[i]['dd'];
          String rgbDvnum = res19[i]['dno'];
          String rgbYes = res19[i]['ea'];

          if (rgbYes==("Yes")) {

            print(" data rgb yes $deviceData,$rgbDvnum,$rgbYes");
            List<String> dvnum = rgbDvnum.split(',');
            String dvnumRgb = dvnum[0];
            String onOff = res19[i]['OnOff'];


            if(onOff == "1"){

              String rgbData = dvnumRgb + ',' + "102";
              List<String> dd = deviceData.split(';');
              String dd0=dd[0];
              String dd1=dd[1];
              String dd2=dd[2];

              final splitData0 = dd0
                  .split(",")
                  .map((x) => x.trim())
                  .where((element) =>
              element.isNotEmpty)
                  .toList();


              final splitData1 = dd1
                  .split(",")
                  .map((x) => x.trim())
                  .where((element) =>
              element.isNotEmpty)
                  .toList();

              final splitData2 = dd2
                  .split(",")
                  .map((x) => x.trim())
                  .where((element) =>
              element.isNotEmpty)
                  .toList();


              Timer(Duration(seconds: f
              ), () {
                curtain(rgbData);
                f += 0;
              });

              await Future.delayed(const Duration(milliseconds: 500));
              transmitData(splitData0[0],splitData0[1],splitData0[2],splitData0[3],splitData0[4]);

              await Future.delayed(const Duration(milliseconds: 500));
              transmitData(splitData1[0],splitData1[1],splitData1[2],splitData1[3],splitData1[4]);

              await Future.delayed(const Duration(milliseconds: 500));
              transmitData(splitData2[0],splitData2[1],splitData2[2],splitData2[3],splitData2[4]);


              await Future.delayed(const Duration(milliseconds: 0));

            }
            else{

              String rgbData = dvnumRgb + ',' + "103";

              Timer(Duration(seconds: f
              ), () {
                curtain(rgbData);
                f += 0;
              });

              await Future.delayed(const Duration(milliseconds: 0));
            }
          }


        }
        Navigator.of(context,rootNavigator: true).pop();
      }

    }
    else if(userAdmin == "G"){
      fluttertoast("Access Denied");
    }




  }

  void transmitData(final String val, final String rc, final String gc,
      final String bc, String type) {

    String str;
    String str2 = "" + val;
    while (str2.length < 3) str2 = "0" + str2;
    String redStr = "" + rc;
    while (redStr.length < 3) redStr = "0" + redStr;
    print("redStr" + redStr);
    String greenStr = "" + gc;
    while (greenStr.length < 3) greenStr = "0" + greenStr;
    print("greenStr" + greenStr);
    String blueStr = "" + bc;
    while (blueStr.length < 3) blueStr = "0" + blueStr;
    print("blueStr" + blueStr);

    String rN = _globalService.rnum.padLeft(2, '0');
    String devN= _globalService.dnum.padLeft(4 , '0');

    if (type.contains("A")) {

      str = "*"+"0" + "01" + "000" + devN + rN + str2 + "000000000000003"+"#";
      print("TypeA_str" + str);

    } else {

      str = "*"+"0" + "01" + "000" + devN + rN + "112" + redStr + greenStr + blueStr + "000003"+"#";
      print("Type_b_str" + str);

    }

    if(s.socketconnected == true){
      s.socket1(str);
    }
    else{

    }


  }

  void curtain(String curdata){

    List<String> cdata = curdata.split(',');

    String dvnum= cdata[0].padLeft(4,'0');
    String data = cdata[1];

    if(data.startsWith("000")){

    }
    else{
      senddatatodevice(data: data, casttype:"01", devicenum: dvnum);
    }
  }

  void senddatatodevice({String data, String casttype, String devicenum}){

    String dN = devicenum.padLeft(4, '0');
    String gI="000";
    String rN = _globalService.rnum.padLeft(2,'0');
    String a = '0';
    String cE = "000000000000000";

    String sData = '*' + a + casttype + gI + dN + rN + data + cE + '#';
    print(sData);


    if(s.socketconnected == true){
      s.socket1(sData);
    }
    else{

    }
  }

  void switchboard(String devicenum, String deviceData){

    mooddevicenum = devicenum.padLeft(4, '0');

    List<String> results = deviceData.split(':');
    for(int i=0;i<results.length;i++){

      String bulbi=results[i];
      if(bulbi.startsWith("1")){
        b1="Yes";
      }
      if(bulbi.startsWith("2")){
        b2="Yes";
      }
      if(bulbi.startsWith("3")){
        b3="Yes";
      }
      if(bulbi.startsWith("4")){
        b4="Yes";
      }

      if(b1.contains("Yes")){

        if(b2.contains("Yes")){

          if(b3.contains("Yes"))
          {
            if(b4.contains("Yes"))
            {
              countSwitch1 = "F";
            }
            else
            {
              countSwitch1 = "7";
            }
          }
          else {

            if(b4.contains("Yes")){
              countSwitch1 = "B";
            }
            else {
              countSwitch1 = "3";
            }

          }

        }
        else{

          if(b3.contains("Yes")){

            if(b4.contains("Yes")){
                //D
                countSwitch1 = "D";
            }
            else{

              //5
              countSwitch1 = "5";

            }

          }
          else{

            if(b4.contains("Yes"))
            {
              //9
              countSwitch1 = "9";
            }
            else
            {
              //1
              countSwitch1 = "1";
            }
          }

        }

      }
      else{

        if(b2.contains("Yes"))
        {
          if(b3.contains("Yes"))
          {
              if(b4.contains("Yes"))
              {
                  //E
                  countSwitch1 = "E";
              }
              else
              {
                    //6
                  countSwitch1 = "6";
              }
          }
          else
          {
            if(b4.contains("Yes"))
            {
              //A
              countSwitch1 = "A";
            }
            else
            {
              //2
              countSwitch1 = "2";
            }
          }
        }
        else
        {
          if(b3.contains("Yes"))
          {
            if(b4.contains("Yes"))
            {
              //C
              countSwitch1 = "C";

            }
            else
            {
              //4
              countSwitch1 = "4";
            }
          }
          else
          {
            if(b4.contains("Yes"))
            {
              //8
              countSwitch1 = "8";
            }
            else
            {
              //0
              countSwitch1 = "0";
            }
         }
        }

      }
      //
      if(bulbi.startsWith("5"))
      {
        b5 = "Yes";
      }

      if(bulbi.startsWith("6"))
      {
        b6 = "Yes";
      }

      if(bulbi.startsWith("7"))
      {
        b7 = "Yes";
      }

      if(bulbi.startsWith("8"))
      {
        b8 = "Yes";
      }
      //
      if(b5.contains("Yes"))
      {
        if(b6.contains("Yes"))
        {
          if(b7.contains("Yes"))
          {
            if(b8.contains("Yes"))
            {
              //F
              countSwitch2 = "F";
            }
            else
            {
              //7
              countSwitch2 = "7";
            }
          }
          else
          {
            if(b8.contains("Yes"))
            {
              //B
              countSwitch2 = "B";
            }
            else
            {
              //3
              countSwitch2 = "3";
            }
          }
        }
        else
        {
          if(b7.contains("Yes"))
          {
            if(b8.contains("Yes"))
            {
              //D
              countSwitch2 = "D";
            }
            else
            {
                //5
                countSwitch2 = "5";
            }
         }
          else
          {
            if(b8.contains("Yes"))
            {
                //9
                countSwitch2 = "9";
            }
              else
              {
                //1
                countSwitch2 = "1";
              }
          }
        }
      }
      else
      {
        if(b6.contains("Yes"))
        {
          if(b7.contains("Yes"))
          {
            if(b8.contains("Yes"))
            {
                //E
                countSwitch2 = "E";
            }
            else
            {
                //6
                countSwitch2 = "6";
            }
          }
          else
          {
              if(b8.contains("Yes"))
              {
                //A
                countSwitch2 = "A";
              }
              else
              {
                  //2
                countSwitch2 = "2";
              }
          }
        }
        else
        {
          if(b7.contains("Yes"))
          {
            if(b8.contains("Yes"))
            {
              //C
              countSwitch2 = "C";
            }
            else
            {
              //4
              countSwitch2 = "4";
            }
          }
          else
          {
            if(b8.contains("Yes"))
            {
                //8
                countSwitch2 = "8";
            }
            else
            {
                //0
                countSwitch2 = "0";
            }
          }
        }
      }

      if(bulbi.startsWith("fan")){
        List<String> results = deviceData.split('-');
        if(results[0].contains("fan")){
          fan1="Yes";
          fanN1Data=results[1];
          if(fanN1Data.contains("0")){
            fanN1Data="B";
          }
          else{
            fanN1Data=results[1];
          }
        }
      }

      if(fan1.contains("Yes")){
        fanSwitch1=fanN1Data;
      }
      else{
        fanSwitch1="0";
      }
    }

    print("end switch $mooddevicenum,$countSwitch1,$countSwitch2,$fanSwitch1");
  }

  void timerSwitch(String data)async{
    print("enter timer_switch");

    mooddata = mooddevicenum+','+countSwitch1+countSwitch2+','+fanSwitch1;
    print("f is $f");
    bulb(data,mooddata);


    // await Future.delayed(Duration(seconds: f), () {
    //   print("Execute this code after $f seconds");
    //   bulb(mooddata);
    // });
    // f+=1;



    //
    // if(fan1.contains("Yes")){
    //   mooddata = mooddevicenum+','+countSwitch1+countSwitch2+','+fanSwitch1;
    //   await Future.delayed(Duration(seconds: f), () {
    //     print("Execute this code after given seconds");
    //     bulb(mooddata);
    //     f+=0.3 as int;
    //   });
    // }
    // else{
    //
    //   mooddata = mooddevicenum+','+countSwitch1+countSwitch2+','+fanSwitch1;
    //   await Future.delayed(Duration(seconds: f), () {
    //     print("Execute this code after given seconds");
    //     bulb(mooddata);
    //     f+=0.3 as int;
    //   });
    // }
  }


  void bulb(String sw,String data){

    List<String> results = data.split(',');
    print("data is $results");

    String devicenum = results[0];
    String deviceData = results[1];
    String fanData = results[2];

    print("sw $devicenum $deviceData $fanData");

    Timer(Duration(seconds: 0), () {
      print("Yeah sw, this line is printed after $f second");
      senddatatoSwitchboard(sw:sw,devicedata: deviceData, casttype: "01",dvalue: devicenum,fanData: fanData);
      f+=0;
    });



  }

  void senddatatoSwitchboard({String sw,String devicedata, String casttype, String dvalue, String fanData}){


    print("dd $devicedata, castty $casttype , dvalue $dvalue, fandata $fanData");

    String dN = dvalue.padLeft(4, '0');
    String gI="000";
    String rN = _globalService.rnum.padLeft(2,'0');
    String a = '0';

    String cE="00000";
    String cE1="000000";

    String sData = '*' + a + casttype + gI + dN + rN + '999' + devicedata +'0'+ cE + fanData + cE1 + '#';

    int i=sData.length;

    print(" datafinal is $sw $sData $i");

    if(s.socketconnected == true){
      s.socket1(sData);
    }
    else{

    }

  }

  void moods(String number) {

    hname = _globalService.hname;
    hnum = _globalService.hnum;
    rnum = _globalService.rnum;
    rname = _globalService.rname;
    dnum = _globalService.dnum;
    groupIdset = _globalService.groupId;
    ddevmodel = _globalService.ddevModel;
    modeltypeset = _globalService.modeltype;
    devicenameset = _globalService.devicename;

    if (userAdmin == "G") {

      fluttertoast("Access Denied");

    }
    else if(userAdmin == "U" || userAdmin == "SA" || userAdmin == "A"){


      if(ddevmodel == ("SDG1") || ddevmodel == ("GSR1") || ddevmodel == ("ACR1") || ddevmodel == ("GSK1") || ddevmodel == ("PLC1")){

        AlertDialog alert = AlertDialog(

          elevation:0,
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          clipBehavior:Clip.antiAliasWithSaveLayer,
          //insetPadding: EdgeInsets.all(5.0),
          shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),
          title: Text(""),
          content: Container(
            width: MediaQuery.of(context).size.width*0.75,
            child:MoodOnPage(number: "0"),
          ),
          //content: //MoodS010Page(number: "0"),
          backgroundColor: Colors.transparent,
          actions: [],
        );
        showDialog(
          // barrierColor: Colors.white.withOpacity(0),
            barrierDismissible: false,
            context: context, builder: (BuildContext context) {

          return alert;
        }
        );

      }

      else if (ddevmodel==("RGB1")) {
        AlertDialog alert = AlertDialog(

          elevation:0,
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          clipBehavior:Clip.antiAliasWithSaveLayer,

          shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),
          title: Text(""),
          content: Container(
            width: MediaQuery.of(context).size.width*0.75,
            child:MoodRGBPage(number: "0"),
          ),
          //content: //MoodS010Page(number: "0"),
          backgroundColor: Colors.transparent,
          actions: [],
        );
        showDialog(
          // barrierColor: Colors.white.withOpacity(0),
            barrierDismissible: false,
            context: context, builder: (BuildContext context) {

          return alert;
        }
        );
      }
      else if (ddevmodel==("S010")) {
        AlertDialog alert = AlertDialog(

          elevation:0,
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          clipBehavior:Clip.antiAliasWithSaveLayer,
          //insetPadding: EdgeInsets.all(5.0),
          shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),
          title: Text(""),
          content: Container(
            width: MediaQuery.of(context).size.width*0.75,
            child:MoodS010Page(number: "0"),
          ),
          //content: //MoodS010Page(number: "0"),
          backgroundColor: Colors.transparent,
          actions: [],
        );
        showDialog(
          // barrierColor: Colors.white.withOpacity(0),
            barrierDismissible: false,
            context: context, builder: (BuildContext context) {

          return alert;
        }
        );
      }
      else if(ddevmodel==("S051")){
        AlertDialog alert = AlertDialog(

          elevation: 0,
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          title:Text(""),
          shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),

          content: Container(
            width: MediaQuery.of(context).size.width*0.75,
            child:S051Page(number: "0"),
          ),

          // content: S051Page(number: "0"),
          backgroundColor: Colors.transparent,
          // new Row(
          //   mainAxisSize: MainAxisSize.min,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: <Widget>[
          //     MoodS051()
          //   ],
          // ),
          actions: [],
        );
        showDialog(context: context, builder: (BuildContext context){
          return alert;
        }
        );

      }
      else if(ddevmodel==("S080")){
        AlertDialog alert = AlertDialog(

          elevation: 0,
          // insetPadding: EdgeInsets.symmetric(
          //   horizontal: 50.0,
          //   vertical: 100.0,
          // ),
          title: Text(""),
          //content: MoodS080Page(number: "0",),
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),

          content: Container(
            width: MediaQuery.of(context).size.width*0.75,
            child:MoodS080Page(number: "0"),
          ),

          // new Row(
          //   mainAxisSize: MainAxisSize.min,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: <Widget>[
          //     MoodS051()
          //   ],
          // ),
          actions: [],
        );
        showDialog(context: context, builder: (BuildContext context){
          return alert;
        }
        );

      }
      else if(ddevmodel==("S020")){
        AlertDialog alert = AlertDialog(

          elevation: 0,
          // insetPadding: EdgeInsets.symmetric(
          //   horizontal: 50.0,
          //   vertical: 100.0,
          // ),
          title: Text(""),
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          // content: MoodS020Page(number: "0",),
          backgroundColor: Colors.transparent,
          shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),

          content: Container(
            width: MediaQuery.of(context).size.width*0.75,
            child:MoodS020Page(number: "0"),
          ),

          // new Row(
          //   mainAxisSize: MainAxisSize.min,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: <Widget>[
          //     MoodS051()
          //   ],
          // ),
          actions: [],
        );
        showDialog(context: context, builder: (BuildContext context){
          return alert;
        }
        );

      }

      else if(ddevmodel==("S021")){
        AlertDialog alert = AlertDialog(

          elevation: 0,
          // insetPadding: EdgeInsets.symmetric(
          //   horizontal: 50.0,
          //   vertical: 100.0,
          // ),
          title: Text(""),
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          //content: MoodS021Page(number: "0",),

          shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),

          content: Container(
            width: MediaQuery.of(context).size.width*0.75,
            child:MoodS021Page(number: "0"),
          ),

          // new Row(
          //   mainAxisSize: MainAxisSize.min,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: <Widget>[
          //     MoodS051()
          //   ],
          // ),
          actions: [],
        );
        showDialog(context: context, builder: (BuildContext context){
          return alert;
        }
        );

      }

      else if(ddevmodel==("S030")){
        AlertDialog alert = AlertDialog(

          elevation: 0,
          // insetPadding: EdgeInsets.symmetric(
          //   horizontal: 50.0,
          //   vertical: 100.0,
          //),
          title: Text(""),
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          // content: MoodS030Page(number: "0",),
          shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),

          content: Container(
            width: MediaQuery.of(context).size.width*0.75,
            child:MoodS030Page(number: "0"),
          ),

          // new Row(
          //   mainAxisSize: MainAxisSize.min,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: <Widget>[
          //     MoodS051()
          //   ],
          // ),
          actions: [],
        );
        showDialog(context: context, builder: (BuildContext context){
          return alert;
        }
        );

      }
      else if(ddevmodel==("CLS1")){

        AlertDialog alert = AlertDialog(

          elevation: 0,
          // insetPadding: EdgeInsets.symmetric(
          //   horizontal: 50.0,
          //   vertical: 100.0,
          //),
          title: Text(""),
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),
          content: Container(
            width: MediaQuery.of(context).size.width*0.75,
            child:MoodCurtain(number: "0"),
          ),

          //content: MoodCurtain(number: "0",),
          // new Row(
          //   mainAxisSize: MainAxisSize.min,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: <Widget>[
          //     MoodS051()
          //   ],
          // ),
          actions: [],
        );
        showDialog(context: context, builder: (BuildContext context){
          return alert;
        }
        );

      }
      else if(ddevmodel==("CRS1")){

        AlertDialog alert = AlertDialog(

          elevation: 0,
          title: Text(""),
          //content: MoodCurtain(number: "0",),
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),
          content: Container(
            width: MediaQuery.of(context).size.width*0.75,
            child:MoodCurtain(number: "0"),
          ),
          actions: [],
        );
        showDialog(context: context, builder: (BuildContext context){
          return alert;
        }
        );
      }
      else if(ddevmodel==("CLNR")) {
        AlertDialog alert = AlertDialog(

          elevation: 0,
          // insetPadding: EdgeInsets.symmetric(
          //   horizontal: 50.0,
          //   vertical: 100.0,
          //),
          title: Text(""),
          shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),
          content: Container(
            width: MediaQuery.of(context).size.width*0.75,
            child:MoodCurtain(number: "0"),
          ),

          // content: MoodCurtain(number: "0",),
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          // new Row(
          //   mainAxisSize: MainAxisSize.min,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: <Widget>[
          //     MoodS051()
          //   ],
          // ),

          actions: [],
        );
        showDialog(context: context, builder: (BuildContext context) {
          return alert;
        }
        );
      }
      else if(ddevmodel =="PSC1" || ddevmodel=="SOSH" || ddevmodel == "SWG1" || ddevmodel == 'SLG1'){

        AlertDialog alert = AlertDialog(

          elevation: 0,
          title: Text(""),
          //content: MoodCurtain(number: "0",),
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),
          content: Container(
            width: MediaQuery.of(context).size.width*0.75,
            child:MoodProjSom(number: "0"),
          ),
          actions: [],
        );
        showDialog(context: context, builder: (BuildContext context){
          return alert;
        }
        );

      }
      else if(ddevmodel==("WPD1"))
      {
        fluttertoast("Access Denied");
      }
      else if(ddevmodel==("WPS1"))
      {
        fluttertoast("Access Denied");
      }
      else
      {
        fluttertoast("Access Denied");
      }


    }


  }

  getchild(){

    print("enter child");
    print("bool s$swb c$cur p$pir e$empty");
    Container container1;


    if (swb) {

      print("name: $roomnametest$roommnumtest");

      roomName = roomnametest;
      roomNo = roommnumtest.toString();
      houseNum = lb;
      houseName = name;
      groupId = "000";
      deviceType = "0000";
      deviceNum = "0000";
      gType = "1";
      dType = "1";
      device = "swb";
      first = first;
      print("first is $first");
      container1 = Container(
          width: MediaQuery
              .of(context)
              .size
              .width / 1.4,
          color: Colors.white,
          margin: margin,
          child: new MainlayoutPage(),
          //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
        );

    }
    else if(cur){


        print("name: $roomnametest$roommnumtest");

        roomName=roomnametest;
        roomNo=roommnumtest.toString();
        houseNum=lb;
        houseName=name;
        groupId="000";
        deviceType="0000";
        deviceNum="0000";
        gType="1";
        dType="1";
        device="cur";
        first=first;

        print("first is $first");
        container1= Container(
          width:MediaQuery.of(context).size.width/1.4,
          margin: margin,
          child: new MainlayoutPage(),
          color: Colors.white,
          //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
        );

    }
    else if(pir){


        print("name: $roomnametest$roommnumtest");

        roomName=roomnametest;
        roomNo=roommnumtest.toString();
        houseNum=lb;
        houseName=name;
        groupId="000";
        deviceType="0000";
        deviceNum="0000";
        gType="1";
        dType="1";
        device="pir";
        first=first;

        print("first is $first");
        container1= Container(
          width:MediaQuery.of(context).size.width/1.4,
          margin: margin,
          color: Colors.white,
          child: new MainlayoutPage(),
          //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
        );

    }
    else if(gsk){

      print("name: $roomnametest$roommnumtest");
      roomName=roomnametest;
      roomNo=roommnumtest.toString();
      houseNum=lb;
      houseName=name;
      groupId="000";
      deviceType="0000";
      deviceNum="0000";
      gType="1";
      dType="1";
      device="gsk";
      first=first;

      print("first is $first");
      container1= Container(
        width:MediaQuery.of(context).size.width/1.4,
        margin: margin,
        color: Colors.white,
        child: new MainlayoutPage(),
        //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
      );
    }
    else if(sdg)
    {
      roomName=roomnametest;
      roomNo=roommnumtest.toString();
      houseNum=lb;
      houseName=name;
      groupId="000";
      deviceType="0000";
      deviceNum="0000";
      gType="1";
      dType="1";
      device="sdg";
      first=first;

      print("first is $first");
      container1= Container(
        width:MediaQuery.of(context).size.width/1.4,
        margin: margin,
        color: Colors.white,
        child: new MainlayoutPage(),
        //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
      );


    }
    else if(psc)
    {
      roomName=roomnametest;
      roomNo=roommnumtest.toString();
      houseNum=lb;
      houseName=name;
      groupId="000";
      deviceType="0000";
      deviceNum="0000";
      gType="1";
      dType="1";
      device="psc";
      first=first;

      container1= Container(
        width:MediaQuery.of(context).size.width/1.4,
        margin: margin,
        color: Colors.white,
        child: new MainlayoutPage(),
        //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
      );
    }
    else if(pscL)
    {
      roomName=roomnametest;
      roomNo=roommnumtest.toString();
      houseNum=lb;
      houseName=name;
      groupId="000";
      deviceType="0000";
      deviceNum="0000";
      gType="1";
      dType="1";
      device="pscL";
      first=first;

      container1= Container(
        width:MediaQuery.of(context).size.width/1.4,
        margin: margin,
        color: Colors.white,
        child: new MainlayoutPage(),
        //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
      );


    }
    else if(swng)
    {
      roomName=roomnametest;
      roomNo=roommnumtest.toString();
      houseNum=lb;
      houseName=name;
      groupId="000";
      deviceType="0000";
      deviceNum="0000";
      gType="1";
      dType="1";
      device="swg";
      first=first;

      container1= Container(
        width:MediaQuery.of(context).size.width/1.4,
        margin: margin,
        color: Colors.white,
        child: new MainlayoutPage(),
        //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
      );

    }
    else if(slide)
    {
      roomName=roomnametest;
      roomNo=roommnumtest.toString();
      houseNum=lb;
      houseName=name;
      groupId="000";
      deviceType="0000";
      deviceNum="0000";
      gType="1";
      dType="1";
      device="slg";
      first=first;

      container1= Container(
        width:MediaQuery.of(context).size.width/1.4,
        margin: margin,
        color: Colors.white,
        child: new MainlayoutPage(),
        //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
      );


    }

    else if(somphy)
    {
      roomName=roomnametest;
      roomNo=roommnumtest.toString();
      houseNum=lb;
      houseName=name;
      groupId="000";
      deviceType="0000";
      deviceNum="0000";
      gType="1";
      dType="1";
      device="somphy";
      first=first;

      container1= Container(
        width:MediaQuery.of(context).size.width/1.4,
        margin: margin,
        color: Colors.white,
        child: new MainlayoutPage(),
        //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
      );
    }
    else if(alxa)
    {
      roomName=roomnametest;
      roomNo=roommnumtest.toString();
      houseNum=lb;
      houseName=name;
      groupId="000";
      deviceType="0000";
      deviceNum="0000";
      gType="1";
      dType="1";
      device="alxa";
      first=first;

      container1= Container(
        width:MediaQuery.of(context).size.width/1.4,
        margin: margin,
        color: Colors.white,
        child: new MainlayoutPage(),
        //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
      );
    }
    else if(mir)
    {
        roomName=roomnametest;
        roomNo=roommnumtest.toString();
        houseNum=lb;
        houseName=name;
        groupId="000";
        deviceType="0000";
        deviceNum="0000";
        gType="1";
        dType="1";
        device="mir";
        first=first;

        container1= Container(
          width:MediaQuery.of(context).size.width/1.4,
          margin: margin,
          color: Colors.white,
          child: new MainlayoutPage(),
        //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
        );
    }
    else if(ac)
    {
        roomName=roomnametest;
        roomNo=roommnumtest.toString();
        houseNum=lb;
        houseName=name;
        groupId="000";
        deviceType="0000";
        deviceNum="0000";
        gType="1";
        dType="1";
        device="ac";
        first=first;

        container1= Container(
          width:MediaQuery.of(context).size.width/1.4,
          margin: margin,
          color: Colors.white,
          child: new MainlayoutPage(),
        //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
        );
    }

    else if(gey)
    {
        roomName=roomnametest;
        roomNo=roommnumtest.toString();
        houseNum=lb;
        houseName=name;
        groupId="000";
        deviceType="0000";
        deviceNum="0000";
        gType="1";
        dType="1";
        device="gey";
        first=first;

        container1= Container(
          width:MediaQuery.of(context).size.width/1.4,
          margin: margin,
          color: Colors.white,
          child: new MainlayoutPage(),
        //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
        );
    }

    else if(bell)
    {
      roomName=roomnametest;
      roomNo=roommnumtest.toString();
      houseNum=lb;
      houseName=name;
      groupId="000";
      deviceType="0000";
      deviceNum="0000";
      gType="1";
      dType="1";
      device="bell";
      first=first;

      container1= Container(
        width:MediaQuery.of(context).size.width/1.4,
        margin: margin,
        color: Colors.white,
        child: new MainlayoutPage(),
      //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
      );
    }

    else if(lock)
    {
      print("enter lock layout");
      roomName=roomnametest;
      roomNo=roommnumtest.toString();
      houseNum=lb;
      houseName=name;
      groupId="000";
      deviceType="0000";
      deviceNum="0000";
      gType="1";
      dType="1";
      device="lock";
      first=first;

      container1= Container(
        width:MediaQuery.of(context).size.width/1.4,
        margin: margin,
        color: Colors.white,
        child: new MainlayoutPage(),
      //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
      );
    }
    else if(rgb){

      print("enter rgb layout");
      roomName=roomnametest;
      roomNo=roommnumtest.toString();
      houseNum=lb;
      houseName=name;
      groupId="000";
      deviceType="0000";
      deviceNum="0000";
      gType="1";
      dType="1";
      device="rgb";
      first=first;

      container1= Container(
        width:MediaQuery.of(context).size.width/1.4,
        margin: margin,
        color: Colors.white,
        child: new MainlayoutPage(),
        //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
      );

    }
    else {

      print("empty");

      // container1= Container(
      //   width:MediaQuery.of(context).size.width/1.4,
      //   margin: margin,
      //   color: Colors.white,
      //   child: new MainlayoutPage(),
      //   //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
      // );
      container1 = Container();
      empty=1;
    }
    return container1;

  }

  // Widget networkImage() {
  //   return FutureBuilder<String>(
  //       future: Nw_conn,
  //       initialData: s.networkconnected,
  //       builder: (context, snapshot) {
  //         print("N$snapshot.data");
  //         switch (snapshot.connectionState) {
  //           case ConnectionState.none:
  //             return Image.asset('images/nonet.png');
  //
  //           case ConnectionState.waiting:
  //             return Image.asset('images/nonet.png');
  //
  //             case ConnectionState.done:

  //             if (snapshot.hasError) {
  //               print('Error:${snapshot.error}');
  //               return Image.asset('images/nonet.png');
  //             }
  //             else {
  //               print('ResultN:${snapshot.data}');
  //               String Result;
  //               if ((snapshot.data) == 'null') {
  //                 Result = 'images/nonet.png';
  //               }
  //               else if ((snapshot.data).contains("Mobile")) {
  //                 Result = "images/remote01.png";
  //               }
  //               else if ((snapshot.data).contains("LWi-Fi")) {
  //                 Result = 'images/local_sig.png';
  //               }
  //               else if ((snapshot.data).contains("RWi-Fi")) {
  //                 Result = 'images/remote01.png';
  //               }
  //               else if ((snapshot.data).contains("No_Net")) {
  //                 Result = 'images/nonet.png';
  //               }
  //               else if ((snapshot.data).contains("null")) {
  //                 Result = 'images/nonet.png';
  //               }
  //               else {
  //                 if ((snapshot.data) == "") {
  //                   Result = 'images/nonet.png';
  //                 }
  //                 else if ((snapshot.data).length == 0) {
  //                   Result = 'images/nonet.png';
  //                 }
  //               }
  //               return Image.asset('$Result');
  //             }
  //
  //             break;
  //           default:
  //             return Image.asset('images/nonet.png');
  //         }
  //       });
  // }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) =>
      new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(true),
            child: Text("YES"),
          ),
        ],
      ),
    ) ??
        false;
  }

  function1() async {


    checkConnectivity2();
    print("switch board table");
    dbHelper = DBHelper();
    List result = await dbHelper.getLocalDateHName(name);

    print(result[0]['lg']);
    print(result[0]['ld']);
    userAdmin = result[0]['lg'];
    userName = result[0]['ld'];

    print("usertype4 $userAdmin");
    print(userAdmin);

    if (userAdmin == "A" || userAdmin == "SA") { // checking the admin login
      listdata = DBProvider.db.comlist();

    }
    else if (userAdmin == "G" || userAdmin == "U") {

      List result = await DBProvider.db.getUserDataWithUName(userName);
      print("guest $result");
      String s = result[0]['ea'];
      List<String> splitData = s.split(';');


      for(int i=0;i<splitData.length ; i++){

        String devNo = splitData[i];
        print(devNo);

        List resSw=[],resMas=[];

        List res = await DBProvider.db.dataFromSw(devNo);
        if(res.length==0){
            resSw=res;
        }
        else{
            resSw=res;

        }

        List res1 = await DBProvider.db.dataFromMTR(devNo);
        if(res1.length==0){
              resMas=res1;
        }
        else{
            resMas=res1;

        }


        if(bothr.length == 0){
          bothr=resSw+resMas;
        }
        else {
          bothr+=resSw+resMas;
        }

        print("both is  $bothr");

      }

      // convert each item to a string by using JSON encoding
      final jsonList = bothr.map((item) => jsonEncode(item)).toList();

      // using toSet - toList strategy
      final uniqueJsonList = jsonList.toSet().toList();

      // convert each item back to the original form using JSON decoding
      final result1 = uniqueJsonList.map((item) => jsonDecode(item)).toList();

      bothr=result1.whereType<Map>().toList();

      listdata=getbothu();

      setState((){

        listdata=listdata;
      });

      print("both $bothr");

    }

    functiongetlist().then((List value) {
      roomname=value[0]["b"];
      roomnum=value[0]["a"];
      print("name $roomname, $roomnum");

      roomnamei=roomname;
      roomnumi=roomnum;
      gridview(roomname, roomnum);
    });
  }

  Future<List> getbothu() {
    return Future.delayed(Duration(seconds: 0), () {
      return bothr;
      // throw Exception("Custom Error");
    });
  }

  Future<List> functiongetlist() async {

    listdata = listdata;
    return listdata;

  }

  gridview(String roomname, int roomnum) async {

    print("enter grid view $roomname,$roomnum");

    roomnametest=null;
    roommnumtest=null;

    roomnametest=roomname;
    roommnumtest=roomnum;

    addDataArray = [];

    if (userAdmin == 'A' || userAdmin == 'SA')
    {
      int scount = await DBProvider.db.GetSwitchCountWithRNAndHN(roomnum, lb, name);
      if (scount > 0) {
        addDataArray.add(Gridmodle("Swb", "switch01", "switch02"));
      }
      print(addDataArray);
      List masdata = [];
      masdata = await DBProvider.db.DataFromMTRNumAndHNum(roomnum, lb, name);
      int masterc = masdata.length;
      if (masterc != 0) {
        for (int i = 0; i < masterc; i++) {

          String device = masdata[i]['e'];
          switch(device) {
            case 'WPD1':
              addDataArray.add(Gridmodle("Pir", "pir01", "pir02"));
              break; // The switch statement must be told to exit, or it will execute every case.
            case 'WPS1':
              addDataArray.add(Gridmodle("Pir", "pir01", "pir02"));
              break;
            case 'RGB1':
              addDataArray.add(Gridmodle("Rgb", "rgb01", "rgb02"));
              break;
            case 'DMR1':
              addDataArray.add(Gridmodle("Dimmer", "dimer01", "dimer02"));
              break;
            case 'CLS1':
              addDataArray.add(Gridmodle("Cur", "curtain01", "curtain02"));
              break;
            case 'CRS1':
              addDataArray.add(Gridmodle("Cur", "curtain01", "curtain02"));
              break;
            case 'CLNR':
              addDataArray.add(Gridmodle("Cur", "curtain01", "curtain02"));
              break;
            case 'PLC1':
              addDataArray.add(Gridmodle("Plc", "projectorlift01", "projectorlift02"));
              break;
            case 'PSC1':
              addDataArray.add(Gridmodle("Psc", "projector01", "projector02"));
              break;

            case 'FMD1':
              addDataArray.add(Gridmodle("Fm", "fm01", "fm02"));
              break;
            case 'GSK1':
              addDataArray.add(Gridmodle("Gsk", "sprinkler01", "sprinkler02"));
              break;
            case 'SDG1':
              addDataArray.add(Gridmodle("Sdg", "dog01", "dog02"));
              break;
            case 'ALXA':
              addDataArray.add(Gridmodle("Alx", "alxa01", "alxa02"));
              break;
            case 'WIR1':
              addDataArray.add(Gridmodle("Mir", "mir_n01", "mir_p02"));
              break;
            case 'SOSH':
              addDataArray.add(Gridmodle("Sosh", "roller01", "roller02"));
              break;
            case 'SWG1':
              addDataArray.add(Gridmodle("Swing", "swing01", "swing02"));
              break;
            case 'SLG1':
              addDataArray.add(Gridmodle("Slide", "slide01", "slide02"));
              break;
            case 'DLS1':
              addDataArray.add(Gridmodle("Dls", "lock01", "lock02"));
              break;
            case 'ACR1':
              addDataArray.add(Gridmodle("Ac", "ac01", "ac02"));
              break;
            case 'GSR1':
              addDataArray.add(Gridmodle("Gey", "geyser01", "geyser02"));
              break;
            case 'CLB1':
              addDataArray.add(Gridmodle("Clb", "bell01", "bell02"));
              break;
            default:
              print('choose a different number!');
          }
        }
      }


    }
    else{
      List result = await DBProvider.db.getUserDataWithUName(userName);
      print("guest $result");
      String s = result[0]['ea'];
      List<String> splitData = s.split(';');


      for(int i=0;i<splitData.length ; i++){

        String devNo = splitData[i];
        print(devNo);

        int scount = await DBProvider.db.getSwitchCountWithRNAndHNUser(roomnum, lb, name,devNo);
        if (scount > 0) {
          addDataArray.add(Gridmodle("Swb", "switch01", "switch02"));
        }
        print(addDataArray);
        List masdata = [];
        masdata = await DBProvider.db.dataFromMTRNumAndHNumUser(roomnum, lb, devNo);
        int masterc = masdata.length;
        if (masterc != 0) {
          for (int i = 0; i < masterc; i++) {

            String device = masdata[i]['e'];
            switch(device) {
              case 'WPD1':
                addDataArray.add(Gridmodle("Pir", "pir01", "pir02"));
                break; // The switch statement must be told to exit, or it will execute every case.
              case 'WPS1':
                addDataArray.add(Gridmodle("Pir", "pir01", "pir02"));
                break;
              case 'RGB1':
                addDataArray.add(Gridmodle("Rgb", "rgb01", "rgb02"));
                break;
              case 'DMR1':
                addDataArray.add(Gridmodle("Dimmer", "dimer01", "dimer02"));
                break;
              case 'CLS1':
                addDataArray.add(Gridmodle("Cur", "curtain01", "curtain02"));
                break;
              case 'CRS1':
                addDataArray.add(Gridmodle("Cur", "curtain01", "curtain02"));
                break;
              case 'CLNR':
                addDataArray.add(Gridmodle("Cur", "curtain01", "curtain02"));
                break;
              case 'PLC1':
                addDataArray.add(Gridmodle("Plc", "projectorlift01", "projectorlift02"));
                break;
              case 'PSC1':
                addDataArray.add(Gridmodle("Psc", "projector01", "projector02"));
                break;

              case 'FMD1':
                addDataArray.add(Gridmodle("Fm", "fm01", "fm02"));
                break;
              case 'GSK1':
                addDataArray.add(Gridmodle("Gsk", "sprinkler01", "sprinkler02"));
                break;
              case 'SDG1':
                addDataArray.add(Gridmodle("Sdg", "dog01", "dog02"));
                break;
              case 'ALXA':
                addDataArray.add(Gridmodle("Alx", "alxa01", "alxa02"));
                break;
              case 'WIR1':
                addDataArray.add(Gridmodle("Mir", "mir_n01", "mir_p02"));
                break;
              case 'SOSH':
                addDataArray.add(Gridmodle("Sosh", "roller01", "roller02"));
                break;
              case 'SWG1':
                addDataArray.add(Gridmodle("Swing", "swing01", "swing02"));
                break;
              case 'SLG1':
                addDataArray.add(Gridmodle("Slide", "slide01", "slide02"));
                break;
              case 'DLS1':
                addDataArray.add(Gridmodle("Dls", "lock01", "lock02"));
                break;
              case 'ACR1':
                addDataArray.add(Gridmodle("Ac", "ac01", "ac02"));
                break;
              case 'GSR1':
                addDataArray.add(Gridmodle("Gey", "geyser01", "geyser02"));
                break;
              case 'CLB1':
                addDataArray.add(Gridmodle("Clb", "bell01", "bell02"));
                break;
              default:
                print('choose a different number!');
            }
          }
        }

      }
    }

    Set<Gridmodle> set = new HashSet.from(addDataArray);
    addDataArray.clear();
    addDataArray.addAll(set);
    gridarray = getgridlist();
    c = addDataArray.first.name;
    getglist();

    checkGridFunction();

  }

  checkGridFunction()async{

    method1();
    print("method2 $empty");
    empty=await getMeSomethingBetter();
    print("method2 $empty");
    method3(empty);
  }

  method1(){
    empty=0;
    setState(() {
      swb=false;
      pir=false;
      cur=false;
      gsk=false;
      sdg=false;
      psc=false;
      pscL=false;
      slide=false;
      swng=false;
      somphy=false;
      alxa=false;
      mir=false;
      bell=false;
      ac=false;
      gey=false;
      somphy=false;
      lock=false;
      rgb=false;
    });
  }

  method3(empty){
    print("method3 $empty");
    deviceDisplay(c);

  }
  Future<int> getMeSomethingBetter() async {

    Duration wait3sec = Duration(seconds: 0);
    await Future.delayed(wait3sec,(){

    });

    print("empty $empty");
    if(empty == 1){
      print("enter empty1 function");
      empty=1;

    }
    else{
      print("enter empty0 function");
      await getMeSomethingBetter();
    }

    return empty;

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

  void deviceDisplay(String c){

    if(empty==1){
      print("enter device display function $c");
      if(c[0] == 'S'){

        if(c[1] == 'w'){

          if(c[2] == 'b')
          {
            print("$swb $pir $cur");
            setState(() {
              swb = true;
              pir = false;
              cur = false;
              gsk=false;
              sdg=false;
              psc=false;
              swng=false;
              slide=false;
              alxa=false;
              mir=false;
              bell=false;
              ac=false;
              gey=false;
              somphy=false;
              lock=false;
              pscL=false;
              rgb=false;

            });
          }
          else if(c[2] == 'i'){

            print("$swb $pir $cur");
            setState(() {
              swb = false;
              pir = false;
              cur = false;
              gsk=false;
              sdg=false;
              psc=false;
              swng=true;
              slide=false;
              alxa=false;
              mir=false;
              bell=false;
              ac=false;
              gey=false;
              somphy=false;
              lock=false;
              pscL=false;
              rgb=false;
            });
          }
        }
        else if(c[1] == "o"){

          print("enter somphy");

          setState(() {
            swb=false;
            pir=false;
            cur=false;
            gsk=false;
            sdg=false;
            psc=false;
            swng=false;
            slide=false;
            alxa=false;
            mir=false;
            bell=false;
            ac=false;
            gey=false;
            somphy=true;
            lock=false;
            pscL=false;
            rgb=false;
          });
        }
        else if(c[1] == "d"){

          setState(() {
            swb=false;
            pir=false;
            cur=false;
            gsk=false;
            sdg=true;
            psc=false;
            swng=false;
            slide=false;
            somphy=false;
            alxa=false;
            mir=false;
            bell=false;
            ac=false;
            gey=false;
            lock=false;
            pscL=false;
            rgb=false;
          });
        }
        else if(c[1] == "l"){

          setState(() {
            swb=false;
            pir=false;
            cur=false;
            gsk=false;
            sdg=false;
            psc=false;
            swng=false;
            slide=true;
            somphy=false;
            alxa=false;
            mir=false;
            bell=false;
            ac=false;
            gey=false;
            lock=false;
            pscL=false;
            rgb=false;
          });
        }
        else{

          setState(() {
            swb=false;
            pir=false;
            cur=false;
            gsk=false;
            sdg=false;
            psc=false;
            swng=false;
            slide=false;
            somphy=false;
            alxa=false;
            mir=false;
            bell=false;
            ac=false;
            gey=false;
            lock=false;
            pscL=false;
            rgb=false;

          });
        }
      }
      else if(c[0] == 'R'){

        rgbClassDivideHNum(lb,name,roomnum,roomname);

      }
      else if(c[0] == 'D'){

        if(c[1]== 'l') {

          print("lock true");

          setState(() {
            swb=false;
            pir=false;
            cur=false;
            gsk=false;
            sdg=false;
            psc=false;
            swng=false;
            slide=false;
            somphy=false;
            alxa=false;
            mir=false;
            bell=false;
            ac=false;
            gey=false;
            lock=true;
            pscL=false;
            rgb=false;
          });
        }
        else{
          setState(() {
            swb=false;
            pir=false;
            cur=false;
            gsk=false;
            sdg=false;
            psc=false;
            swng=false;
            slide=false;
            somphy=false;
            alxa=false;
            mir=false;
            bell=false;
            ac=false;
            gey=false;
            lock=false;
            pscL=false;
            rgb=false;
          });
        }

      }
      else if(c[0] == 'P'){

        if(c[1] == 'i') {

          pirClassDivideHNum(lb,name,roomnum,roomname);

        }
        else if(c[1] == 's'){
          setState(() {
            swb=false;
            pir=false;
            cur=false;
            gsk=false;
            sdg=false;
            psc=true;
            pscL=false;
            swng=false;
            slide=false;
            somphy=false;
            alxa=false;
            mir=false;
            bell=false;
            ac=false;
            gey=false;
            lock=false;
            rgb=false;
          });
        }
        else if(c[1] == 'l'){
          setState(() {
            swb=false;
            pir=false;
            cur=false;
            gsk=false;
            sdg=false;
            psc=false;
            pscL=true;
            swng=false;
            slide=false;
            somphy=false;
            alxa=false;
            mir=false;
            bell=false;
            ac=false;
            gey=false;
            lock=false;
            rgb=false;
          });
        }


      }
      else if(c[0] == 'C'){

        if(c[1] == 'l'){

          setState(() {
            swb=false;
            pir=false;
            cur=false;
            gsk=false;
            sdg=false;
            psc=false;
            pscL=false;
            swng=false;
            slide=false;
            somphy=false;
            alxa=false;
            mir=false;
            bell=true;
            ac=false;
            gey=false;
            lock=false;
            rgb=false;
          });

        }
        else if(c[1] == 'a'){

          setState(() {
            swb=false;
            pir=false;
            cur=false;
            gsk=false;
            sdg=false;
            psc=false;
            pscL=false;
            swng=false;
            slide=false;
            somphy=false;
            alxa=false;
            mir=false;
            bell=false;
            ac=false;
            gey=false;
            lock=false;
            rgb=false;

          });

        }
        else if(c[1] == 'u'){

          curtainClassDivideHNum(lb,name,roomnum,roomname);

        }

      }
      else if(c[0]=='A')
      {
        //ac
        if(c[1] == 'c'){

          setState(() {
            swb=false;
            pir=false;
            cur=false;
            gsk=false;
            sdg=false;
            psc=false;
            pscL=false;
            swng=false;
            slide=false;
            somphy=false;
            alxa=false;
            mir=false;
            bell=false;
            ac=true;
            gey=false;
            lock=false;
            rgb=false;

          });

        }
        //aqu
        else if(c[1] == 'q'){

          setState(() {
            swb=false;
            pir=false;
            cur=false;
            gsk=false;
            sdg=false;
            psc=false;
            pscL=false;
            swng=false;
            slide=false;
            somphy=false;
            alxa=false;
            mir=false;
            bell=false;
            ac=false;
            gey=false;
            lock=false;
            rgb=false;
          });

        }
        //alx
        else if(c[1] == 'l'){

          setState(() {
            swb=false;
            pir=false;
            cur=false;
            gsk=false;
            sdg=false;
            psc=false;
            pscL=false;
            swng=false;
            slide=false;
            somphy=false;
            alxa=true;
            mir=false;
            bell=false;
            ac=false;
            gey=false;
            lock=false;
            rgb=false;
          });

        }


      }
      else if(c[0] == 'M'){

        if(c[1] == 'i'){

          setState(() {
            swb=false;
            pir=false;
            cur=false;
            gsk=false;
            sdg=false;
            psc=false;
            pscL=false;
            swng=false;
            slide=false;
            somphy=false;
            alxa=false;
            mir=true;
            bell=false;
            ac=false;
            gey=false;
            lock=false;
            rgb=false;
          });
        }
      }
      else if(c[0] == 'G'){

        if(c[1] =='s' && c[2] == 'k'){

          gskClassDivideHNum(lb,name,roomnum,roomname);

        }
        else{

          setState(() {
            swb=false;
            pir=false;
            cur=false;
            gsk=false;
            sdg=false;
            psc=false;
            pscL=false;
            swng=false;
            slide=false;
            somphy=false;
            alxa=false;
            mir=false;
            bell=false;
            ac=false;
            gey=false;
            lock=false;
            rgb=false;
          });

        }
      }
      else if(c[0] == 'F'){

        setState(() {
          swb=false;
          pir=false;
          cur=false;
          gsk=false;
          sdg=false;
          psc=false;
          pscL=false;
          swng=false;
          slide=false;
          somphy=false;
          alxa=false;
          mir=false;
          bell=false;
          ac=false;
          gey=false;
          lock=false;
          rgb=false;

        });
      }
      else {
        setState(() {
          swb = false;
          cur = false;
          pir=false;
          sdg=false;
          gsk=false;
          psc=false;
          pscL=false;
          swng=false;
          slide=false;
          somphy=false;
          alxa=false;
          mir=false;
          bell=false;
          ac=false;
          gey=false;
          lock=false;
          rgb=false;
        });
      }
    }
  }


  Future<void>rgbClassDivideHNum(String lb, String name, int roomNum, String roomname)async{

    print("enter rgbClass");
    List groupArray=[];
    List inDevArray=[];
    List groupIDList=[];
    List data = await DBProvider.db.DataFromMTRNumAndHNum(roomNum, lb, name);
    int cou = data.length;

    if(cou !=0){

      for(int i=0;i<cou;i++){
        String feature = data[i]['e'];
        String deviceNo = data[i]['d'].toString();
        print(feature);
        if(feature == 'RGB1'){
          List resultRgb =  await DBProvider.db.DataFromMTRNumAndHNumGroupId(roomNum, lb, name, feature,deviceNo);
          groupIDList.add(resultRgb[0]['ea']);
        }
      }
    }


    groupIDList = groupIDList.toSet().toList();
    int gid = groupIDList.length;

    print("Group Id is $groupIDList");

    for(int i=0;i<gid;i++){

      if(groupIDList[i] == "000"){
        inDevArray.add(groupIDList[i]);

      }
      if(groupIDList[i]!="000"){
        groupArray.add(groupIDList[i]);
      }
    }

    if(inDevArray.length == 0){

      if(groupArray.length == 0){

      }
      else{
        if(groupArray.length == 1){

          print("master layout");

        }
        else{

          print("master layout and individual class");

        }

      }

    }
    else{

      if(groupArray.length == 0){

        if(inDevArray.length == 1){

          print("enter rgb layout");

          setState(() {
            pir=false;
            swb=false;
            cur=false;
            gsk=false;
            sdg=false;
            psc=false;
            pscL=false;
            slide=false;
            swng=false;
            somphy=false;
            alxa=false;
            mir=false;
            bell=false;
            ac=false;
            gey=false;
            lock=false;
            rgb=true;
          });

        }
        else{

          print("enter pirlayout");

          setState(() {
            pir=false;
            swb=false;
            cur=false;
            gsk=false;
            sdg=false;
            psc=false;
            pscL=false;
            slide=false;
            swng=false;
            somphy=false;
            alxa=false;
            mir=false;
            bell=false;
            ac=false;
            gey=false;
            lock=false;
            rgb=true;
          });


        }
      }
      else{


      }
    }
  }


  Future<void>pirClassDivideHNum(String lb, String name, int roomnum, String roomname)async{

    print("enter pirclass");
    List groupArray=[];
    List inDevArray=[];
    List groupIDList=[];
    List data = await DBProvider.db.DataFromMTRNumAndHNum(roomnum, lb, name);
    int cou = data.length;

    if(cou !=0){

      for(int i=0;i<cou;i++){
        String feature = data[i]['e'];
        String deviceno = data[i]['d'].toString();
        print(feature);
        if(feature == 'WPS1'){
          List resultwps =  await DBProvider.db.DataFromMTRNumAndHNumGroupId(roomnum, lb, name, feature,deviceno);
          groupIDList.add(resultwps[0]['ea']);
        }
        else if(feature == 'WPD1'){
          List resultwpd =  await DBProvider.db.DataFromMTRNumAndHNumGroupId(roomnum, lb, name, feature,deviceno);
          groupIDList.add(resultwpd[0]['ea']);
        }

      }

    }


    groupIDList = groupIDList.toSet().toList();
    int gid = groupIDList.length;

    print("Group Id is $groupIDList");

    for(int i=0;i<gid;i++){

      if(groupIDList[i] == "000"){
        inDevArray.add(groupIDList[i]);

      }
      if(groupIDList[i]!="000"){
        groupArray.add(groupIDList[i]);
      }
    }

    if(inDevArray.length == 0){

      if(groupArray.length == 0){

      }
      else{
        if(groupArray.length == 1){

          print("master layout");

        }
        else{

          print("master layout and individual class");

        }

      }

    }
    else{

      if(groupArray.length == 0){

        if(inDevArray.length == 1){

          print("enter pir layout");

          setState(() {
            pir=true;
            swb=false;
            cur=false;
            gsk=false;
            sdg=false;
            psc=false;
            pscL=false;
            slide=false;
            swng=false;
            somphy=false;
            alxa=false;
            mir=false;
            bell=false;
            ac=false;
            gey=false;
            lock=false;
          });

        }
        else{

          print("enter pirlayout");

          setState(() {
            pir=true;
            swb=false;
            cur=false;
            gsk=false;
            sdg=false;
            psc=false;
            pscL=false;
            slide=false;
            swng=false;
            somphy=false;
            alxa=false;
            mir=false;
            bell=false;
            ac=false;
            gey=false;
            lock=false;
          });


        }
      }
      else{


      }
    }
  }


  Future<void>gskClassDivideHNum(String lb, String name, int roomnum, String roomname)async{

    print("enter pirclass");
    List groupArray=[];
    List inDevArray=[];
    List groupIDList=[];
    List data = await DBProvider.db.DataFromMTRNumAndHNum(roomnum, lb, name);
    int cou = data.length;

    if(cou !=0){

      for(int i=0;i<cou;i++){
        String feature = data[i]['e'];
        String deviceno = data[i]['d'].toString();
        print(feature);
        if(feature == 'GSK1'){
          List resultgsk =  await DBProvider.db.DataFromMTRNumAndHNumGroupId(roomnum, lb, name, feature,deviceno);
          groupIDList.add(resultgsk[0]['ea']);
        }
      }
    }

    groupIDList = groupIDList.toSet().toList();
    int gid = groupIDList.length;

    print("Group Id is $groupIDList");

    for(int i=0;i<gid;i++){

      if(groupIDList[i] == "000"){
        inDevArray.add(groupIDList[i]);

      }
      if(groupIDList[i]!="000"){
        groupArray.add(groupIDList[i]);
      }
    }

    if(inDevArray.length == 0){

      if(groupArray.length == 0){

      }
      else{
        if(groupArray.length == 1){

          print("master layout");

        }
        else{

          print("master layout and individual class");

        }

      }

    }
    else{

      if(groupArray.length == 0){

        if(inDevArray.length == 1){

          print("enter gsk layout");

          setState(() {
            pir=false;
            swb=false;
            cur=false;
            gsk=true;
            sdg=false;
            psc=false;
            pscL=false;
            slide=false;
            swng=false;
            somphy=false;
            alxa=false;
            mir=false;
            bell=false;
            ac=false;
            gey=false;
            lock=false;

          });

        }
        else{

          print("enter gsklayout");

          setState(() {
            pir=false;
            swb=false;
            cur=false;
            gsk=true;
            sdg=false;
            psc=false;
            pscL=false;
            slide=false;
            swng=false;
            somphy=false;
            alxa=false;
            mir=false;
            bell=false;
            ac=false;
            gey=false;
            lock=false;

          });


        }
      }
      else{


      }
    }
  }


  Future<void> curtainClassDivideHNum(String lb,String name, int roomnum, String roomname) async {

    List groupArray = [];
    List inDevArray = [];
    List groupIDList = [];

    List datacur = await DBProvider.db.DataFromMTRNumAndHNum(roomnum,lb,name);

    int cou = datacur.length;

    if(cou!=0){

      for(int i=0;i<cou;i++){

        String feature = datacur[i]['e'];
        String devicenum = datacur[i]['d'].toString();

        print(feature);

        if(feature == 'CLS1'){
          List resultcls =  await DBProvider.db.DataFromMTRNumAndHNumGroupId(roomnum, lb, name, feature,devicenum);
          groupIDList.add(resultcls[0]['ea']);

        }
        else if(feature == 'CRS1'){

          List resultcrs =  await DBProvider.db.DataFromMTRNumAndHNumGroupId(roomnum, lb, name, feature,devicenum);
          groupIDList.add(resultcrs[0]['ea']);

        }
        else if(feature == 'CLNR'){

          List resultcrs =  await DBProvider.db.DataFromMTRNumAndHNumGroupId(roomnum, lb, name, feature,devicenum);
          groupIDList.add(resultcrs[0]['ea']);

        }
        else if(feature == 'CLSH'){

          List resultcrs =  await DBProvider.db.DataFromMTRNumAndHNumGroupId(roomnum, lb, name, feature,devicenum);
          groupIDList.add(resultcrs[0]['ea']);

        }


      }


    }

    groupIDList = groupIDList.toSet().toList();
    int gid = groupIDList.length;

    print(groupIDList);

    for(int i=0;i<gid;i++){

      if(groupIDList[i] == "000"){
        inDevArray.add(groupIDList[i]);

      }
      if(groupIDList[i]!="000"){
        groupArray.add(groupIDList[i]);
      }
    }

    if(inDevArray.length == 0){
      if(groupArray.length == 0){

      }
      else{
        if(groupArray.length == 1){

        }
        else{


        }

      }

    }
    else{

      if(groupArray.length == 0){

        if(inDevArray.length == 1){

          setState(() {
            pir=false;
            swb=false;
            cur=true;
            gsk=false;
            sdg=false;
            psc=false;
            pscL=false;
            swng=false;
            slide=false;
            somphy=false;
            alxa=false;
            mir=false;
            bell=false;
            ac=false;
            gey=false;
            lock=false;

          });
        }
        else{

          setState(() {
            pir=false;
            swb=false;
            cur=true;
            gsk=false;
            sdg=false;
            psc=false;
            pscL=false;
            swng=false;
            slide=false;
            somphy=false;
            alxa=false;
            mir=false;
            bell=false;
            ac=false;
            gey=false;
            lock=false;
          });
        }
      }
      else{


      }
    }

  }
}