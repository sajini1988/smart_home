import'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:smart_home/AC/AcIView.dart';
import 'package:smart_home/main1.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/Devicesettings.dart';
import 'package:smart_home/Timer/TimerPopUp.dart';

String hnameW3S,hnumW3S,rnumW3S,dnumW3S,rnameW3S,groupIdW3S,dtypeW3S,firstW3S;

class W3switchLayout extends StatefulWidget {
  @override
  _W3switchLayoutState createState() => _W3switchLayoutState();
}
class _W3switchLayoutState extends State<W3switchLayout>{

  GlobalService _globalService = GlobalService();
  double currentindex=0;
  int listcount=1;
  int ac;
  String ddevmodel;
  int empty=0;
  bool timerVisible=false;
  bool settingsVisible=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );

    print("enter ac init state");
    hnameW3S = houseName1;
    hnumW3S= houseNum1;
    rnumW3S = roomNum1;
    dnumW3S = deviceNum1;
    rnameW3S= roomName1;
    groupIdW3S = groupId1;
    dtypeW3S= dType1;
    firstW3S = first1;
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
                      dtypeW3S="2";
                      print("left");
                      print(ac);

                      if(ac==0){
                        if(listcount==1){
                          currentindex=0;
                          swipe();
                        }
                        else{
                          ac=listcount-1;
                          currentindex=(listcount-1).toDouble();
                          swipe();
                        }
                      }
                      else{
                        ac--;
                        currentindex--;
                        swipe();
                        print("$ac $currentindex");

                      }
                    }
                    else if(details.primaryVelocity<0){
                      dtypeW3S="2";
                      print("right");
                      print(ac);
                      //  flutter_toast("Right Gesture");
                      if(ac==listcount-1){
                        currentindex=0;
                        ac=0;
                        swipe();
                      }
                      else if(ac == 0){
                        print("s eqr $ac");
                        if(listcount==1){
                          currentindex=0;
                          swipe();
                        }
                        else{
                          currentindex++;
                          print(currentindex);
                          ac++;
                          swipe();
                        }
                      }
                      else{
                        currentindex++;
                        print(currentindex);
                        ac++;
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
    //
    //   ],
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
    if(ddevmodel == 'WS03') {
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: ACIViewState(),
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

    if (dtypeW3S==("1")) {
      ac = 0;
    }
    else {
      dtypeW3S = "2";
    }

    DBHelper dbHelper;
    dbHelper = DBHelper();

    List result = await dbHelper.getLocalDateHName(hnameW3S);
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

        List res = await DBProvider.db.dataFromMTRNumAndHNumGroupIdDetails1User(rnumW3S, hnumW3S, hnameW3S, groupIdW3S,devNo);
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

          if(feature==("WS03")){
            dnumlist.add(devNom.toString());
            featuretypelist.add(feature);
            devicenamea.add(devicename);
            deviceID.add(ddevID);
            devicemodelnum.add(devmnum);
          }

        }
      }

    }
    else if(userAdmin == 'A' || userAdmin == "SA"){


      timerVisible=true;
      settingsVisible=true;


      List acdata = await DBProvider.db.DataFromMTRNumAndHNumGroupIdDetails1(rnumW3S, hnumW3S, hnameW3S, groupIdW3S);
      print(acdata);
      int masterc = acdata.length;

      if (masterc!= 0) {
        for (int p = 0; p < acdata.length; p++) {

          int devNom = acdata[p]["d"];
          String feature = acdata[p]["e"];
          String devicename = acdata[p]["ec"];
          String ddevID = acdata[p]['f'];
          String devmnum = acdata[p]["c"];

          print(devmnum);
          print(devicename);


          if(feature==("WS03")){
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
    ddevmodel=featuretypelist[ac];
    dnumW3S=dnumlist[ac];
    String name=devicenamea[ac];
    print(name);

    String dddevmodelnumac=devicemodelnum[ac];
    String deviceIDac=deviceID[ac];



    _globalService.hnameset=hnameW3S;
    _globalService.hnumset=hnumW3S;
    _globalService.rnumset=rnumW3S;
    _globalService.dnumset=dnumW3S;
    _globalService.rnameset=rnameW3S;
    _globalService.groupIdset=groupIdW3S;
    _globalService.ddevModelset=ddevmodel;
    _globalService.modeltypeset="WS";
    _globalService.sheerdnumset="0000";
    _globalService.ddevModelNumset=dddevmodelnumac;
    _globalService.deviceIDset=deviceIDac;


    setState(() {
      listcount=listcount;
      ddevmodel=ddevmodel;
    });


    print("model is $ddevmodel");



  }

}
