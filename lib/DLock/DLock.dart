import'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_home/DLock/DLockView.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:smart_home/main1.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/Devicesettings.dart';
import 'package:smart_home/Timer/TimerPopUp.dart';

String hnameL,hnumL,rnumL,dnumL,rnameL,groupIdL,dtypeL,firstL;

class LockLayout extends StatefulWidget {
  @override
  _LockLayoutState createState() => _LockLayoutState();
}
class _LockLayoutState extends State<LockLayout>{

  GlobalService _globalService = GlobalService();
  double currentindex=0;
  int listcount=1;
  int lock;
  String ddevmodel;
  int empty=0;

  bool timerVisible = false;
  bool settingsVisible=false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    hnameL = houseName1;
    hnumL = houseNum1;
    rnumL = roomNum1;
    dnumL = deviceNum1;
    rnameL = roomName1;
    groupIdL = groupId1;
    dtypeL= dType1;
    firstL = first1;
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
                      dtypeL="2";
                      print("left");
                      print(lock);

                      if(lock==0){
                        if(listcount==1){
                          currentindex=0;
                          swipe();
                        }
                        else{
                          lock=listcount-1;
                          currentindex=(listcount-1).toDouble();
                          swipe();
                        }
                      }
                      else{
                        lock--;
                        currentindex--;
                        swipe();
                        print("$lock $currentindex");

                      }
                    }
                    else if(details.primaryVelocity<0){
                      dtypeL="2";
                      print("right");
                      print(lock);
                      //  flutter_toast("Right Gesture");
                      if(lock==listcount-1){
                        currentindex=0;
                        lock=0;
                        swipe();
                      }
                      else if(lock == 0){
                        print("s eqr $lock");
                        if(listcount==1){
                          currentindex=0;
                          swipe();
                        }
                        else{
                          currentindex++;
                          print(currentindex);
                          lock++;
                          swipe();
                        }
                      }
                      else{
                        currentindex++;
                        print(currentindex);
                        lock++;
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
                              child: InkWell(
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
                            ),
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

    AlertDialog alert = AlertDialog(

      // elevation:0,
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      clipBehavior:Clip.antiAliasWithSaveLayer,
      insetPadding: EdgeInsets.all(25.0),
      shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),

      title: Text(""),
      content: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child:Timerpage(),
      ),
      backgroundColor: Colors.white,
      actions: [

      ],
    );

    showDialog(context: context, builder: (BuildContext context){
      return alert;
    }
    );
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
    if(ddevmodel == 'DLS1') {
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: DLockViewState(),
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
    List deviceID = [];
    List devicemodelnum = [];

    if (dtypeL==("1")) {
      lock = 0;
    }
    else {
      dtypeL = "2";
    }

    DBHelper dbHelper;
    dbHelper = DBHelper();

    List result = await dbHelper.getLocalDateHName(hnameL);
    String userAdmin = result[0]['lg'];
    String userName =  result[0]['ld'];

    print(userAdmin);

    if (userAdmin == 'U' || userAdmin == 'G') {

      timerVisible=false;
      settingsVisible=false;
      List result = await DBProvider.db.getUserDataWithUName(userName);
      print("guest $result");
      String sdv = result[0]['ea'];
      List<String> splitData = sdv.split(';');
      List bothT=[];

      for (int i = 0; i < splitData.length; i++) {

        String devNo = splitData[i];
        print(devNo);

        List resMas=[];

        List res = await DBProvider.db.dataFromMTRNumAndHNumGroupIdDetails1User(rnumL, hnumL, hnameL, groupIdL,devNo);
        if(res.length==0){
          resMas=res;
        }
        else if(res==null){
          resMas=res;
        }
        else{
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
        for(int i=0;i<bothT.length;i++){

          int devNom = bothT[i]["d"];
          String feature = bothT[i]["e"];
          String devicename = bothT[i]["ec"];
          String ddevID = bothT[i]['f'];
          String devmnum = bothT[i]["c"];

          print(devmnum);
          print(devicename);

          if(feature==("DLS1")){
            dnumlist.add(devNom.toString());
            featuretypelist.add(feature);
            devicenamea.add(devicename);
            deviceID.add(ddevID);
            devicemodelnum.add(devmnum);
          }

        }
      }

    }
    else if(userAdmin == 'A' || userAdmin == 'SA'){

      timerVisible=true;
      settingsVisible=true;

      print("num $rnumL $hnumL $hnameL $groupIdL");
      List lockData = await DBProvider.db.DataFromMTRNumAndHNumGroupIdDetails1(
          rnumL, hnumL, hnameL, groupIdL);
      print(lockData);
      int masterC = lockData.length;

      if (masterC!= 0) {
        for (int p = 0; p < lockData.length; p++) {

          int devNom = lockData[p]["d"];
          String feature = lockData[p]["e"];
          String devmnum = lockData[p]["c"];
          String devicename = lockData[p]["ec"];

          print(devmnum);
          print(devicename);

          if(feature==("DLS1")){
            dnumlist.add(devNom.toString());
            featuretypelist.add(feature);
            devicenamea.add(devicename);
          }

        }

      }


    }


    listcount=dnumlist.length;
    ddevmodel=featuretypelist[lock];
    dnumL=dnumlist[lock];
    String name = devicenamea[lock];

    String ddDevModelNumLock=devicemodelnum[lock];
    String deviceIDl=deviceID[lock];

    _globalService.hnameset=hnameL;
    _globalService.hnumset=hnumL;
    _globalService.rnumset=rnumL;
    _globalService.dnumset=dnumL;
    _globalService.rnameset=rnameL;
    _globalService.groupIdset=groupIdL;
    _globalService.ddevModelset=ddevmodel;
    _globalService.modeltypeset="Lock";
    _globalService.sheerdnumset="0000";
    _globalService.ddevModelNumset=ddDevModelNumLock;
    _globalService.deviceIDset=deviceIDl;

    setState(() {
      listcount=listcount;
      ddevmodel=ddevmodel;
    });

    print("model is $ddevmodel");

  }

}
