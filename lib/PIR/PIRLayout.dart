import'dart:async';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:smart_home/main1.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:smart_home/PIR/PIRIView.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/Devicesettings.dart';
import 'package:smart_home/Timer/TimerPopUp.dart';

String hnamep,hnump,rnump,dnump,rnamep,groupIdp,dtypep,firstp;

class Pirlayout extends StatefulWidget {
  @override
  _PirlayoutState createState() => _PirlayoutState();
}
class _PirlayoutState extends State<Pirlayout>{
  GlobalService _globalService = GlobalService();
  double currentindex=0;
  int listcount=1;
  int pir;
  String ddevmodel;
  int empty=0;

  bool timerVisible=false;
  bool settingsVisible = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("enter cur init state");
    hnamep = houseName1;
    hnump = houseNum1;
    rnump = roomNum1;
    dnump = deviceNum1;
    rnamep=roomName1;
    groupIdp=groupId1;
    dtypep=dType1;
    firstp=first1;
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
                      dtypep="2";
                      print("left");
                      print(pir);

                      if(pir==0){
                        if(listcount==1){
                          currentindex=0;
                          swipe();
                        }
                        else{
                          pir=listcount-1;
                          currentindex=(listcount-1).toDouble();
                          swipe();
                        }
                      }
                      else{
                        pir--;
                        currentindex--;
                        swipe();
                        print("$pir $currentindex");

                      }
                    }
                    else if(details.primaryVelocity<0){
                      dtypep="2";
                      print("right");
                      print(pir);
                    //  flutter_toast("Right Gesture");
                      if(pir==listcount-1){
                        currentindex=0;
                        pir=0;
                        swipe();
                      }
                      else if(pir == 0){
                        print("s eqr $pir");
                        if(listcount==1){
                          currentindex=0;
                          swipe();
                        }
                        else{
                          currentindex++;
                          print(currentindex);
                          pir++;
                          swipe();
                        }
                      }
                      else{
                        currentindex++;
                        print(currentindex);
                        pir++;
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
                              // child: PageIndicatorContainer(
                              //   child: PageView(
                              //
                              //       controller: controller,
                              //       reverse: true,
                              //
                              //     onPageChanged:(num){
                              //       print("num $num");
                              //     }
                              //
                              //   ),
                              //
                              //   length: listcount,
                              //   align: IndicatorAlign.top,
                              //   indicatorSpace: 8.0,
                              //   padding: const EdgeInsets.all(10),
                              //   indicatorColor: Colors.grey,
                              //   indicatorSelectorColor: Colors.blue,
                              //   shape:IndicatorShape.circle(size:7),
                              //
                              //
                              //
                              //
                              // ),
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
    if(ddevmodel == 'WPD1') {
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: PirIView(),
      );

    }
    else if(ddevmodel == 'WPS1') {
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: PirIView(),
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
    print("nwadmin");

    List dnumlist=[];
    List featuretypelist=[];
    List devicenamea=[];
    List deviceID =[];
    List devicemodelnum = [];

    if (dtypep.contains("1")) {
      pir = 0;
    }
    else {
      dtypep = "2";
    }

    DBHelper dbHelper;
    dbHelper = DBHelper();

    List result = await dbHelper.getLocalDateHName(hnamep);
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

        List res = await DBProvider.db.dataFromMTRNumAndHNumGroupIdDetails1User(rnump, hnump, hnamep, groupIdp,devNo);
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

          if(feature==("WPS1")){
            dnumlist.add(devNom.toString());
            featuretypelist.add(feature);
            devicenamea.add(devicename);
            deviceID.add(ddevID);
            devicemodelnum.add(devmnum);
          }
          else if(feature==("WPD1")){
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

      print("num $rnump $hnump $hnamep $groupIdp");
      List curdata = await DBProvider.db.DataFromMTRNumAndHNumGroupIdDetails1(
          rnump, hnump, hnamep, groupIdp);
      print(curdata);
      int masterc = curdata.length;

      if (masterc!= 0) {
        for (int p = 0; p < curdata.length; p++) {
          int devNom = curdata[p]["d"];
          String feature = curdata[p]["e"];
          String devicename = curdata[p]["ec"];
          String ddevID = curdata[0]['f'];
          String ddevmodelnum = curdata[0]['c'];


          if (feature==("WPD1")) {
            dnumlist.add(devNom.toString());
            featuretypelist.add(feature);
            devicenamea.add(devicename);
            deviceID.add(ddevID);
            devicemodelnum.add(ddevmodelnum);
          }
          else if (feature==("WPS1")) {
            dnumlist.add(devNom.toString());
            featuretypelist.add(feature);
            devicenamea.add(devicename);
            deviceID.add(ddevID);
            devicemodelnum.add(ddevmodelnum);
          }
        }
      }

    }


    listcount=dnumlist.length;
    ddevmodel=featuretypelist[pir];
    dnump=dnumlist[pir];

    String ddevmodelnump=devicemodelnum[pir];
    String deviceIDp=deviceID[pir];


    _globalService.hnameset=hnamep;
    _globalService.hnumset=hnump;
    _globalService.rnumset=rnump;
    _globalService.dnumset=dnump;
    _globalService.rnameset=rnamep;
    _globalService.groupIdset=groupIdp;
    _globalService.ddevModelset=ddevmodel;
    _globalService.modeltypeset="PIR";
    _globalService.sheerdnumset="0000";
    _globalService.ddevModelNumset=ddevmodelnump;
    _globalService.deviceIDset=deviceIDp;


    setState(() {
      listcount=listcount;
      ddevmodel=ddevmodel;
    });

    print("value is $hnamep,$hnump,$rnump,$dnump,$rnamep,$groupIdp");
    print("model is $ddevmodel");

  }

}
