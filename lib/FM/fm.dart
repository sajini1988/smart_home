import'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:smart_home/FM/fmIView.dart';
import 'package:smart_home/main1.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/Devicesettings.dart';
import 'package:smart_home/Timer/TimerPopUp.dart';

String hnameFm,hnumFm,rnumFm,dnumFm,rnameFm,groupIdFm,dtypeFm,firstFm;

class FmLayout extends StatefulWidget {
  @override
  _FmLayoutState createState() => _FmLayoutState();
}
class _FmLayoutState extends State<FmLayout>{

  GlobalService _globalService = GlobalService();
  double currentindex=0;
  int listcount=1;
  int fm;
  String ddevmodel;
  int empty=0;
  bool timerVisible=false;
  bool settingsVisible=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("enter fmk");

    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );

    print("enter ac init state");
    hnameFm = houseName1;
    hnumFm= houseNum1;
    rnumFm = roomNum1;
    dnumFm = deviceNum1;
    rnameFm = roomName1;
    groupIdFm = groupId1;
    dtypeFm= dType1;
    firstFm= first1;
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
                      dtypeFm="2";
                      print("left");
                      print(fm);

                      if(fm==0){
                        if(listcount==1){
                          currentindex=0;
                          swipe();
                        }
                        else{
                          fm=listcount-1;
                          currentindex=(listcount-1).toDouble();
                          swipe();
                        }
                      }
                      else{
                        fm--;
                        currentindex--;
                        swipe();
                        print("$fm $currentindex");

                      }
                    }
                    else if(details.primaryVelocity<0){
                      dtypeFm="2";
                      print("right");
                      print(fm);
                      //  flutter_toast("Right Gesture");
                      if(fm==listcount-1){
                        currentindex=0;
                        fm=0;
                        swipe();
                      }
                      else if(fm == 0){
                        print("s eqr $fm");
                        if(listcount==1){
                          currentindex=0;
                          swipe();
                        }
                        else{
                          currentindex++;
                          print(currentindex);
                          fm++;
                          swipe();
                        }
                      }
                      else{
                        currentindex++;
                        print(currentindex);
                        fm++;
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
    if(ddevmodel == 'FMD1') {
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: FMIViewState(),
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

    if (dtypeFm==("1")) {
      fm = 0;
    }
    else {
      dtypeFm = "2";
    }

    DBHelper dbHelper;
    dbHelper = DBHelper();

    List result = await dbHelper.getLocalDateHName(hnameFm);
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

        List res = await DBProvider.db.dataFromMTRNumAndHNumGroupIdDetails1User(rnumFm, hnumFm, hnameFm, groupIdFm,devNo);
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

          if(feature==("FMD1")){
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

      print("num $rnumFm $hnumFm $hnameFm $groupIdFm");
      List acdata = await DBProvider.db.DataFromMTRNumAndHNumGroupIdDetails1(rnumFm, hnumFm, hnameFm, groupIdFm);
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


          if(feature==("FMD1")){
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
    ddevmodel=featuretypelist[fm];
    dnumFm=dnumlist[fm];
    String name=devicenamea[fm];
    print(name);

    String dddevmodelnumac=devicemodelnum[fm];
    String deviceIDac=deviceID[fm];



    _globalService.hnameset=hnameFm;
    _globalService.hnumset=hnumFm;
    _globalService.rnumset=rnumFm;
    _globalService.dnumset=dnumFm;
    _globalService.rnameset=rnameFm;
    _globalService.groupIdset=groupIdFm;
    _globalService.ddevModelset=ddevmodel;
    _globalService.modeltypeset="FM";
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
