import'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:smart_home/Bell/bellIView.dart';
import 'package:smart_home/main1.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/Devicesettings.dart';
import 'package:smart_home/Timer/TimerPopUp.dart';

String hnameB,hnumB,rnumB,dnumB,rnameB,groupIdB,dtypeB,firstB;

class BellLayout extends StatefulWidget {
  @override
  _BellLayoutState createState() => _BellLayoutState();
}
class _BellLayoutState extends State<BellLayout>{

  GlobalService _globalService = GlobalService();
  double currentindex=0;
  int listcount=1;
  int bell;
  String ddevmodel;
  int empty=0;

  bool timerVisible = false;
  bool settingsVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("enter bell init state");
    hnameB = houseName1;
    hnumB= houseNum1;
    rnumB = roomNum1;
    dnumB = deviceNum1;
    rnameB = roomName1;
    groupIdB = groupId1;
    dtypeB= dType1;
    firstB = first1;
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
                      dtypeB="2";
                      print("left");
                      print(bell);

                      if(bell==0){
                        if(listcount==1){
                          currentindex=0;
                          swipe();
                        }
                        else{
                          bell=listcount-1;
                          currentindex=(listcount-1).toDouble();
                          swipe();
                        }
                      }
                      else{
                        bell--;
                        currentindex--;
                        swipe();
                        print("$bell $currentindex");

                      }
                    }
                    else if(details.primaryVelocity<0){
                      dtypeB="2";
                      print("right");
                      print(bell);
                      //  flutter_toast("Right Gesture");
                      if(bell==listcount-1){
                        currentindex=0;
                        bell=0;
                        swipe();
                      }
                      else if(bell == 0){
                        print("s eqr $bell");
                        if(listcount==1){
                          currentindex=0;
                          swipe();
                        }
                        else{
                          currentindex++;
                          print(currentindex);
                          bell++;
                          swipe();
                        }
                      }
                      else{
                        currentindex++;
                        print(currentindex);
                        bell++;
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
                              child:InkWell(
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
    if(ddevmodel == 'CLB1') {
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: BellIViewState(),
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

    if (dtypeB==("1")) {
      bell = 0;
    }
    else {
      dtypeB = "2";
    }

    DBHelper dbHelper;
    dbHelper = DBHelper();

    List result = await dbHelper.getLocalDateHName(hnameB);
    String userAdmin = result[0]['lg'];
    String userName= result[0]['ld'];

    print(userAdmin);

    if (userAdmin == 'U' || userAdmin == 'G') {

      timerVisible = false;
      settingsVisible =false;
      List result = await DBProvider.db.getUserDataWithUName(userName);
      String sdv = result[0]['ea'];
      List<String> splitData = sdv.split(';');
      List bothT = [];

      for(int i = 0 ;i< splitData.length ; i++){

        String devNo = splitData[i];

        List resMas = [];
        List res = await DBProvider.db.dataFromMTRNumAndHNumGroupIdDetails1User(rnameB, hnumB, hnameB, groupIdB, devNo);

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
      if(masterU!=0){
        for(int i=0;i<bothT.length;i++){

          int devNom = bothT[i]["d"];
          String feature = bothT[i]["e"];
          String devicename = bothT[i]["ec"];
          String ddevID = bothT[i]['f'];
          String devmnum = bothT[i]["c"];

          print(devmnum);
          print(devicename);

          if(feature==("CLB1")){
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

      //print("num $rnumac $hnumac $hnameac $groupIdac");
      List bellData = await DBProvider.db.DataFromMTRNumAndHNumGroupIdDetails1(
          rnumB, hnumB, hnameB, groupIdB);
      print(bellData);
      int masterC = bellData.length;

      if (masterC!= 0) {
        for (int p = 0; p < bellData.length; p++) {

          int devNom = bellData[p]["d"];
          String feature = bellData[p]["e"];
          String devicename = bellData[p]["ec"];
          String ddevID = bellData[p]['f'];
          String devmnum = bellData[p]["c"];

          print(devmnum);
          print(devicename);

          if(feature==("CLB1")){
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
    ddevmodel=featuretypelist[bell];
    dnumB=dnumlist[bell];
    String name=devicenamea[bell];
    print(name);

    String ddevmodelNumBell=devicemodelnum[bell];
    String deviceIDB=deviceID[bell];

    _globalService.hnameset=hnameB;
    _globalService.hnumset=hnumB;
    _globalService.rnumset=rnumB;
    _globalService.dnumset=dnumB;
    _globalService.rnameset=rnameB;
    _globalService.groupIdset=groupIdB;
    _globalService.ddevModelset=ddevmodel;
    _globalService.modeltypeset="BELL";
    _globalService.sheerdnumset="0000";
    _globalService.ddevModelNumset=ddevmodelNumBell;
    _globalService.deviceIDset=deviceIDB;

    setState(() {
      listcount=listcount;
      ddevmodel=ddevmodel;
    });


    print("model is $ddevmodel");

  }

}
