import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:smart_home/main1.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:smart_home/Swing/SwingIView.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/Devicesettings.dart';
import 'package:smart_home/Timer/TimerPopUp.dart';

String hnameswg,hnumswg, rnumswg,dnumswg,rnameswg,groupIdswg,dtypeswg,firstswg,devicenumsh;

class Swinglayout extends StatefulWidget {
  @override
  _SwinglayoutState createState() => _SwinglayoutState();
}
class _SwinglayoutState extends State<Swinglayout>{

  GlobalService _globalService = GlobalService();
  double currentindex=0;
  int listcount=1;
  int swg;
  String ddevmodel;
  int empty=0;

  bool timerVisible=false;
  bool settingsVisible=false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("enter cur init state");
    hnameswg = houseName1;
    hnumswg = houseNum1;
    rnumswg = roomNum1;
    dnumswg = deviceNum1;
    rnameswg=roomName1;
    groupIdswg=groupId1;
    dtypeswg=dType1;
    firstswg=first1;
    devicenumsh="0000";
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
                      fluttertoast("left gesture");
                      dtypeswg="2";
                      print("left");
                      print(swg);

                      if(swg==0){
                        if(listcount==1){
                          currentindex=0;
                          swipe();
                        }
                        else{
                          swg=listcount-1;
                          currentindex=(listcount-1).toDouble();
                          swipe();
                        }
                      }
                      else{
                        swg--;
                        currentindex--;
                        swipe();
                        print("$swg $currentindex");

                      }
                    }
                    else if(details.primaryVelocity<0){
                      dtypeswg="2";
                      print("right");
                      print(swg);
                      fluttertoast("Right Gesture");
                      if(swg==listcount-1){
                        currentindex=0;
                        swg=0;
                        swipe();
                      }
                      else if(swg == 0){
                        print("s eqr $swg");
                        if(listcount==1){
                          currentindex=0;
                          swipe();
                        }
                        else{
                          currentindex++;
                          print(currentindex);
                          swg++;
                          swipe();
                        }

                      }
                      else{
                        currentindex++;
                        print(currentindex);
                        swg++;
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
                            ),),
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
                            ),),

                            Container(width: 32.0,height: 0.0),


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


  fluttertoast(String message){

    // Fluttertoast.showToast(
    //     msg: message,
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.grey,
    //     textColor: Colors.white,
    //     fontSize: 16.0
    // );

  }

  getchild(){

    Container container1;
    if(ddevmodel == 'SWG1') {
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: SwingIView(),
      );

    }
    else if(ddevmodel == 'devices'){
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
    print("nwadmin");

    List dnumlist=[];
    List featuretypelist=[];
    List devicenamea=[];
    List deviceID =[];
    List devicemodelnum = [];

    if (dtypeswg==("1")) {
      swg = 0;
    }
    else {
      dtypeswg = "2";
    }

    DBHelper dbHelper;
    dbHelper = DBHelper();

    List result = await dbHelper.getLocalDateHName(hnameswg);
    String userAdmin = result[0]['lg'];
    String userName = result[0]['ld'];

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

        List res = await DBProvider.db.dataFromMTRNumAndHNumGroupIdDetails1User(rnameswg, hnumswg, hnameswg, groupIdswg,devNo);
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

          if(feature==("SWG1")){
            dnumlist.add(devNom.toString());
            featuretypelist.add(feature);
            devicenamea.add(devicename);
            deviceID.add(ddevID);
            devicemodelnum.add(devmnum);
          }


        }
      }
    }

    else if(userAdmin == 'A' || userAdmin == 'SA') {
      timerVisible = true;
      settingsVisible = true;

      print("num $rnumswg $hnumswg $hnameswg $groupIdswg");
      List curdata = await DBProvider.db.DataFromMTRNumAndHNumGroupIdDetails1(rnumswg, hnumswg, hnameswg, groupIdswg);
      print(curdata);
      int masterC = curdata.length;

      if (masterC!= 0) {
        for (int p = 0; p < curdata.length; p++) {

          int devNom = curdata[p]["d"];
          String feature = curdata[p]["e"];
          String devicename = curdata[p]["ec"];
          String ddevID = curdata[p]['f'];
          String ddevmodelNum=curdata[p]['c'];


          if(feature==("SWG1")){
            dnumlist.add(devNom.toString());
            featuretypelist.add(feature);
            devicenamea.add(devicename);
            deviceID.add(ddevID);
            devicemodelnum.add(ddevmodelNum);

            print("$ddevID,$ddevmodelNum");
          }

        }

      }

    }




    listcount=dnumlist.length;
    ddevmodel=featuretypelist[swg];
    dnumswg=dnumlist[swg];
    String name=devicenamea[swg];
    print(name);

    String dddevmodelnumc=devicemodelnum[swg];
    String deviceIDc=deviceID[swg];


    _globalService.hnameset=hnameswg;
    _globalService.hnumset=hnumswg;
    _globalService.rnumset=rnumswg;
    _globalService.dnumset=dnumswg;
    _globalService.rnameset=rnameswg;
    _globalService.groupIdset=groupIdswg;
    _globalService.ddevModelset=ddevmodel;
    _globalService.modeltypeset="swg";
    _globalService.sheerdnumset=devicenumsh;
    _globalService.ddevModelNumset=dddevmodelnumc;
    _globalService.deviceIDset=deviceIDc;


    setState(() {
      listcount=listcount;
      ddevmodel=ddevmodel;
    });

    print("value is $hnameswg,$hnumswg,$rnumswg,$dnumswg,$rnameswg,$groupIdswg");
    print("model is $ddevmodel");

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

}
