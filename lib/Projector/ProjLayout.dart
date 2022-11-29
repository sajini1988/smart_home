import 'dart:async';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:smart_home/main1.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:smart_home/Projector/ProjectorScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/Devicesettings.dart';
import 'package:smart_home/Timer/TimerPopUp.dart';

String hnamepsc,hnumpsc,rnumpsc,dnumpsc,rnamepsc,groupIdpsc,dtypepsc,firstpsc;

class PscLayout extends StatefulWidget {
  @override
  _PscLayoutState createState() => _PscLayoutState();
}

class _PscLayoutState extends State<PscLayout> {

  GlobalService _globalService = GlobalService();
  double currentindex=0;
  int listcount=1;
  int psc;
  String ddevmodel;
  int empty=0;
  bool timerVisible=false;
  bool settingsVisible=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("enter proj init state");
    hnamepsc = houseName1;
    hnumpsc = houseNum1;
    rnumpsc = roomNum1;
    dnumpsc = deviceNum1;
    rnamepsc=roomName1;
    groupIdpsc=groupId1;
    dtypepsc=dType1;
    firstpsc=first1;
    admin();
  }

  @override
  Widget build(BuildContext context){

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body:Center(
          child: Container(
            color:Colors.white,
            width: MediaQuery.of(context).size.width/1.4,
            child: GestureDetector(
              onHorizontalDragEnd: (DragEndDetails details){
                if(details.primaryVelocity >0){
                  dtypepsc="2";

                  if(psc == 0){
                    if(listcount == 1){
                      currentindex=0;
                      swipe();
                    }
                    else {
                      psc=listcount-1;
                      currentindex = (listcount-1).toDouble();
                      swipe();
                    }
                  }
                  else{
                    psc--;
                    currentindex--;
                    swipe();
                    print("$psc $currentindex");
                  }
                }
                else if(details.primaryVelocity<0){
                  dtypepsc="2";
                  if(psc == listcount-1){
                    currentindex = 0;
                    psc=0;
                    swipe();
                  }
                  else if(psc == 0){
                    if(listcount == 1){
                      currentindex=0;
                      swipe();
                    }
                    else {
                      currentindex++;
                      psc++;
                      swipe();
                    }
                  }
                  else{
                    currentindex++;
                    psc++;
                    swipe();
                  }
                }
              },
              child: Column(
                children: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(width: 32.0,height: 0.0),
                        Expanded(
                            child:new DotsIndicator(
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
                            child: ClipRRect(borderRadius: BorderRadius.circular(20.0),
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
            ),
          ),
        )
      ),
    );

  }
  showAlertDialog(BuildContext context) async {

    AlertDialog alert = AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      title: Text(""),
      content: Timerpage(),
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
    if(ddevmodel == 'PSC1') {
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: PSCPage(),
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
    List deviceID = [];
    List devicemodelnum = [];

    if (dtypepsc==("1")) {
      psc = 0;
    }
    else {
      dtypepsc = "2";
    }

    DBHelper dbHelper;
    dbHelper = DBHelper();

    List result = await dbHelper.getLocalDateHName(hnamepsc);
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

        List res = await DBProvider.db.dataFromMTRNumAndHNumGroupIdDetails1User(rnumpsc, hnumpsc, hnamepsc, groupIdpsc,devNo);
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

          if(feature==("PSC1")){
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

      timerVisible=true;
      settingsVisible=true;

      print("num $rnumpsc $hnumpsc $hnamepsc $groupIdpsc");
      List curdata = await DBProvider.db.DataFromMTRNumAndHNumGroupIdDetails1(
          rnumpsc, hnumpsc, hnamepsc, groupIdpsc);
      print(curdata);
      int masterC = curdata.length;

      if (masterC!= 0) {
        for (int p = 0; p < curdata.length; p++) {

          int devNom = curdata[p]["d"];
          String feature = curdata[p]["e"];
          String devicename = curdata[p]["ec"];
          String ddevID = curdata[p]['f'];
          String devmnum = curdata[p]["c"];

          print(devmnum);
          print(devicename);

          if(feature==("PSC1")){
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
    ddevmodel=featuretypelist[psc];
    dnumpsc=dnumlist[psc];

    String name=devicenamea[psc];
    print(name);

    String dddevmodelnumc=devicemodelnum[psc];
    String deviceIDc=deviceID[psc];

    _globalService.hnameset=hnamepsc;
    _globalService.hnumset=hnumpsc;
    _globalService.rnumset=rnumpsc;
    _globalService.dnumset=dnumpsc;
    _globalService.rnameset=rnamepsc;
    _globalService.groupIdset=groupIdpsc;
    _globalService.ddevModelset=ddevmodel;
    _globalService.modeltypeset="PSC";
    _globalService.sheerdnumset="0000";
    _globalService.ddevModelNumset=dddevmodelnumc;
    _globalService.deviceIDset=deviceIDc;

    setState(() {
      listcount=listcount;
      ddevmodel=ddevmodel;
    });

    print("value is $hnamepsc,$hnumpsc,$rnumpsc,$dnumpsc,$rnamepsc,$groupIdpsc");
    print("model is $ddevmodel");

  }


}
