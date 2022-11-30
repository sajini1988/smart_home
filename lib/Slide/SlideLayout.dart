import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:smart_home/main1.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:smart_home/Slide/SlideIView.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/Devicesettings.dart';
import 'package:smart_home/Timer/TimerPopUp.dart';

String hnameSl,hnumSl, rnumSl,dnumSl,rnameSl,groupIdSl,dtypeSl,firstSl,devicenumSh;

class SlideLayout extends StatefulWidget {
  @override
  _SlideLayoutState createState() => _SlideLayoutState();
}
class _SlideLayoutState extends State<SlideLayout>{

  GlobalService _globalService = GlobalService();
  double currentindex=0;
  int listcount=1;
  int sl;
  String ddevmodel;
  int empty=0;

  bool timerVisible = false;
  bool settingsVisible = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("enter cur init state");
    hnameSl = houseName1;
    hnumSl = houseNum1;
    rnumSl = roomNum1;
    dnumSl = deviceNum1;
    rnameSl = roomName1;
    groupIdSl = groupId1;
    dtypeSl = dType1;
    firstSl = first1;
    devicenumSh="0000";
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
                      dtypeSl="2";
                      print("left");
                      print(sl);

                      if(sl==0){
                        if(listcount==1){
                          currentindex=0;
                          swipe();
                        }
                        else{
                          sl=listcount-1;
                          currentindex=(listcount-1).toDouble();
                          swipe();
                        }
                      }
                      else{
                        sl--;
                        currentindex--;
                        swipe();
                        print("$sl $currentindex");

                      }
                    }
                    else if(details.primaryVelocity<0){
                      dtypeSl="2";
                      print("right");
                      print(sl);
                      fluttertoast("Right Gesture");
                      if(sl==listcount-1){
                        currentindex=0;
                        sl=0;
                        swipe();
                      }
                      else if(sl == 0){
                        print("s eqr $sl");
                        if(listcount==1){
                          currentindex=0;
                          swipe();
                        }
                        else{
                          currentindex++;
                          print(currentindex);
                          sl++;
                          swipe();
                        }

                      }
                      else{
                        currentindex++;
                        print(currentindex);
                        sl++;
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



                            InkWell(

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

                            InkWell(
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
    if(ddevmodel == 'SLG1') {
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: SlideIView(),
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

    if (dtypeSl==("1")) {
      sl = 0;
    }
    else {
      dtypeSl = "2";
    }

    DBHelper dbHelper;
    dbHelper = DBHelper();

    List result = await dbHelper.getLocalDateHName(hnameSl);
    String userAdmin = result[0]['lg'];
    String userName = result[0]['ld'];


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

        List res = await DBProvider.db.dataFromMTRNumAndHNumGroupIdDetails1User(rnumSl, hnumSl, hnameSl, groupIdSl,devNo);
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

          if(feature==("SLG1")){
            dnumlist.add(devNom.toString());
            featuretypelist.add(feature);
            devicenamea.add(devicename);
            deviceID.add(ddevID);
            devicemodelnum.add(devmnum);
          }


        }
      }

    }
    else if (userAdmin == 'A' || userAdmin == 'SA') {
          timerVisible=true;
          settingsVisible=true;


          print("num $rnumSl $hnumSl $hnameSl $groupIdSl");
          List curdata = await DBProvider.db.DataFromMTRNumAndHNumGroupIdDetails1(rnumSl, hnumSl, hnameSl, groupIdSl);
          print(curdata);
          int masterC = curdata.length;

          if (masterC!= 0) {
            for (int p = 0; p < curdata.length; p++) {

              int devNom = curdata[p]["d"];
              String feature = curdata[p]["e"];
              String devicename = curdata[p]["ec"];
              String ddevID = curdata[p]['f'];
              String ddevmodelNum=curdata[p]['c'];


              if(feature==("SLG1")){
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
    ddevmodel=featuretypelist[sl];
    dnumSl=dnumlist[sl];
    String name=devicenamea[sl];

    String dddevmodelnumc=devicemodelnum[sl];
    String deviceIDc=deviceID[sl];


    _globalService.hnameset=hnameSl;
    _globalService.hnumset=hnumSl;
    _globalService.rnumset=rnumSl;
    _globalService.dnumset=dnumSl;
    _globalService.rnameset=rnameSl;
    _globalService.groupIdset=groupIdSl;
    _globalService.ddevModelset=ddevmodel;
    _globalService.modeltypeset="slide";
    _globalService.sheerdnumset=devicenumSh;
    _globalService.ddevModelNumset=dddevmodelnumc;
    _globalService.deviceIDset=deviceIDc;


    setState(() {
      listcount=listcount;
      ddevmodel=ddevmodel;
    });

    print("value is $hnameSl,$hnumSl,$rnumSl,$dnumSl,$rnameSl,$groupIdSl");
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
