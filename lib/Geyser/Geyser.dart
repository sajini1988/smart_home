import'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:smart_home/Geyser/GeyserIView.dart';
import 'package:smart_home/main1.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/Devicesettings.dart';
import 'package:smart_home/Timer/TimerPopUp.dart';

String hnameG,hnumG,rnumG,dnumG,rnameG,groupIdG,dtypeG,firstG;

class Geylayout extends StatefulWidget {
  @override
  _GeylayoutState createState() => _GeylayoutState();
}
class _GeylayoutState extends State<Geylayout>{

  GlobalService _globalService = GlobalService();
  double currentindex=0;
  int listcount=1;
  int gey;
  String ddevmodel;
  int empty=0;
  bool timerVisible=false;
  bool settingsVisible=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("enter gey init state");

    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );
    hnameG = houseName1;
    hnumG = houseNum1;
    rnumG = roomNum1;
    dnumG = deviceNum1;
    rnameG = roomName1;
    groupIdG = groupId1;
    dtypeG = dType1;
    firstG = first1;
    admin();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Scaffold(
        backgroundColor: Colors.white,
        body:Center(
            child: Container(
                color:Colors.white,
                width:MediaQuery.of(context).size.width/1.4,
                child:GestureDetector(
                  onHorizontalDragEnd:(DragEndDetails details){
                    if(details.primaryVelocity>0){
                      //flutter_toast("left gesture");
                      dtypeG="2";
                      print("left");
                      print(gey);

                      if(gey==0){
                        if(listcount==1){
                          currentindex=0;
                          swipe();
                        }
                        else{
                          gey=listcount-1;
                          currentindex=(listcount-1).toDouble();
                          swipe();
                        }
                      }
                      else{
                        gey--;
                        currentindex--;
                        swipe();
                        print("$gey $currentindex");

                      }
                    }
                    else if(details.primaryVelocity<0){
                      dtypeG="2";
                      print("right");
                      print(gey);
                      //  flutter_toast("Right Gesture");
                      if(gey==listcount-1){
                        currentindex=0;
                        gey=0;
                        swipe();
                      }
                      else if(gey == 0){
                        print("s eqr $gey");
                        if(listcount==1){
                          currentindex=0;
                          swipe();
                        }
                        else{
                          currentindex++;
                          print(currentindex);
                          gey++;
                          swipe();
                        }
                      }
                      else{
                        currentindex++;
                        print(currentindex);
                        gey++;
                        swipe();
                      }
                    }
                  },
                  child:Column(
                    children: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(width: 32.0,height: 0.0),

                            Expanded(

                              child: new DotsIndicator(
                                dotsCount:listcount,
                                position: currentindex,
                                onTap:(position){
                                  print(position);
                                },
                              ),
                            ),

                            Visibility(
                              visible: settingsVisible,
                              child:InkWell(
                                onTap: (){
                                  print("devicesettings");
                                  devicesettings();
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.asset('images/settings_icon.png',
                                    width:30, height: 30),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: timerVisible,
                              child: InkWell(
                              onTap: (){
                                print("timersettings");
                                showAlertDialog(context);
                                },
                                child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.asset('images/timer_settings.png',
                                    width:30, height: 30),
                              ),
                            ),
                            )
                          ],
                        ),
                      ),
                      Expanded(child: getchild(),),
                    ],

                  ),
                )

            )
        ),
      ),
    );

  }

  showAlertDialog(BuildContext context) async {


    showDialog(
      barrierColor: Colors.black26,
      context: context,
      builder: (context) {
        return Timerpage();
      },
    );

    // AlertDialog alert = AlertDialog(
    //
    //   // elevation:0,
    //   contentPadding: EdgeInsets.zero,
    //   titlePadding: EdgeInsets.zero,
    //   clipBehavior:Clip.antiAliasWithSaveLayer,
    //   insetPadding: EdgeInsets.all(25.0),
    //   shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),
    //
    //   title: Text(""),
    //   content: Container(
    //
    //     width: MediaQuery.of(context).size.width,
    //     color: Colors.white,
    //     child:Timerpage(),
    //   ),
    //   backgroundColor: Colors.white,
    //   actions: [
    //     ],
    // );
    //
    // showDialog(context: context, builder: (BuildContext context){
    //   return alert;
    // }
    // );
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

  getchild(){

    Container container1;
    if(ddevmodel == 'GSR1') {
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: GeyIViewState(),
      );

    }
    else if(ddevmodel == 'devices') {
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: DeviceSetting(),
      );

    }
    else{
      container1=Container();
      empty=1;
      print("empty child $empty");
    }

    return container1;

  }

  devicesettings() async{

    method1();
    empty=await getMeSomethingBetter();
    method3(empty);
  }

  method3(empty){
    print("method3 $empty");
    setState(() {
      ddevmodel="devices";
    });
  }
  method1(){
    empty=0;
    setState(() {
      ddevmodel="none";
    });
  }

  Future<int> getMeSomethingBetter() async {
    Duration wait3sec = Duration(seconds: 0);
    await Future.delayed(wait3sec,(){
    });
    if(empty ==1){
      empty=1;
    }
    else{
      await getMeSomethingBetter();
    }
    return empty;
  }

  admin(){
    newAdmin();
  }

  swipe()async{
    method1swipe();
    empty=await getMeSomethingBetter();
    method3swipe(empty);

  }

  method3swipe(empty){
    print("method3 $empty");
    newAdmin();
  }

  method1swipe(){
    empty=0;
    setState(() {
      ddevmodel="none";
    });
  }

  void newAdmin()async {

    List dnumlist=[];
    List featuretypelist=[];
    List devicenamea=[];
    List deviceID =[];
    List devicemodelnum = [];

    if (dtypeG==("1")) {
      gey = 0;
    }
    else {
      dtypeG = "2";
    }

    DBHelper dbHelper;
    dbHelper = DBHelper();

    List result = await dbHelper.getLocalDateHName(hnameG);
    String userAdmin = result[0]['lg'];
    String userName = result[0]['ld'];

    print(userAdmin);

    if (userAdmin == 'U' || userAdmin == 'G') {

      timerVisible = false;
      settingsVisible=false;
      List result = await DBProvider.db.getUserDataWithUName(userName);
      String sdv = result[0]['ea'];
      List<String> splitData = sdv.split(';');
      List bothT=[];
      for(int i=0;i<splitData.length;i++){
        String devNo = splitData[i];
        print(devNo);

        List resMas = [];
        List res = await DBProvider.db.dataFromMTRNumAndHNumGroupIdDetails1User(rnumG, hnumG, hnameG, groupIdG, devNo);
        if(res.length == 0){
          resMas=res;
        }
        else if(res == null){
          resMas=res;
        }
        else {
          resMas=res;
        }
        if(bothT.length == 0){
          bothT=resMas;
        }
        else {
          bothT+=resMas;
        }
      }
      int masterU = bothT.length;

      if(masterU !=0){
        for(int i = 0;i<bothT.length ; i++){

          int devNom = bothT[i]["d"];
          String feature = bothT[i]["e"];
          String devicename = bothT[i]["ec"];
          String ddevID = bothT[i]['f'];
          String devmnum = bothT[i]["c"];

          print(devmnum);
          print(devicename);

          if(feature==("GSR1")){
            dnumlist.add(devNom.toString());
            featuretypelist.add(feature);
            devicenamea.add(devicename);
            deviceID.add(ddevID);
            devicemodelnum.add(devmnum);
          }

        }
      }

    }
    else if(userAdmin == "SA" || userAdmin == "A"){

      settingsVisible=true;
      timerVisible=true;

      print("num $rnumG $hnumG $hnameG $groupIdG");
      List geyData = await DBProvider.db.DataFromMTRNumAndHNumGroupIdDetails1(
          rnumG, hnumG, hnameG, groupIdG);
      print(geyData);
      int masterC = geyData.length;

      if (masterC!= 0) {
        for (int p = 0; p < geyData.length; p++) {

          int devNom = geyData[p]["d"];
          String feature = geyData[p]["e"];
          String devicename = geyData[p]["ec"];
          String ddevID = geyData[p]['f'];
          String devmnum = geyData[p]["c"];

          print(devmnum);
          print(devicename);

          if(feature==("GSR1")){
            dnumlist.add(devNom.toString());
            featuretypelist.add(feature);
            devicenamea.add(devicename);
            deviceID.add(ddevID);
            devicemodelnum.add(devmnum);
          }

        }

      }

    }




    listcount=dnumlist.length;
    ddevmodel=featuretypelist[gey];
    dnumG=dnumlist[gey];

    String name=devicenamea[gey];
    print(name);

    String dddevmodelnumc=devicemodelnum[gey];
    String deviceIDc=deviceID[gey];

    _globalService.hnameset=hnameG;
    _globalService.hnumset=hnumG;
    _globalService.rnumset=rnumG;
    _globalService.dnumset=dnumG;
    _globalService.rnameset=rnameG;
    _globalService.groupIdset=groupIdG;
    _globalService.ddevModelset=ddevmodel;
    _globalService.modeltypeset="GEY";
    _globalService.sheerdnumset="0000";
    _globalService.ddevModelNumset=dddevmodelnumc;
    _globalService.deviceIDset=deviceIDc;

    setState(() {
      listcount=listcount;
      ddevmodel=ddevmodel;
    });


    print("model is $ddevmodel");

  }

}
