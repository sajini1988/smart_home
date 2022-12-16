import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:smart_home/main1.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:smart_home/Curtain/DoubleCurtain.dart';
import 'package:smart_home/Curtain/SingleCurtain.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/Devicesettings.dart';
import 'package:smart_home/Timer/TimerPopUp.dart';


String hnamec,hnumc, rnumc,dnumc,rnamec,groupIdc,dtypec,firstc,devinumsh;

class Curtainlayout extends StatefulWidget {
  @override
  _CurtainlayoutState createState() => _CurtainlayoutState();
}
class _CurtainlayoutState extends State<Curtainlayout>{

  GlobalService _globalService = GlobalService();
  double currentindex=0;
  int listcount=1;
  int cur;
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
    print("enter cur init state");
    hnamec = houseName1;
    hnumc = houseNum1;
    rnumc = roomNum1;
    dnumc = deviceNum1;
    rnamec=roomName1;
    groupIdc=groupId1;
    dtypec=dType1;
    firstc=first1;
    devinumsh="0000";
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
                      dtypec="2";
                      print("left");
                      print(cur);

                      if(cur==0){
                          if(listcount==1){
                            currentindex=0;
                            swipe();
                          }
                          else{
                            cur=listcount-1;
                            currentindex=(listcount-1).toDouble();
                            swipe();
                          }
                      }
                      else{
                        cur--;
                        currentindex--;
                        swipe();
                        print("$cur $currentindex");

                      }
                    }
                    else if(details.primaryVelocity<0){
                      dtypec="2";
                      print("right");
                      print(cur);
                      fluttertoast("Right Gesture");
                      if(cur==listcount-1){
                        currentindex=0;
                        cur=0;
                        swipe();
                      }
                      else if(cur == 0){
                        print("s eqr $cur");
                        if(listcount==1){
                          currentindex=0;
                          swipe();
                        }
                        else{
                          currentindex++;
                          print(currentindex);
                          cur++;
                          swipe();
                        }

                      }
                      else{
                        currentindex++;
                        print(currentindex);
                        cur++;
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
    if(ddevmodel == 'CLS1') {
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: SingleCurtain(),
      );

    }
    else if(ddevmodel == 'CRS1') {
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: SingleCurtain(),
      );

    }
    else if(ddevmodel == 'CLNR'){
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: DoubleCurtain(),
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


    List dnumlist=[];
    List featuretypelist=[];
    List devicenamea=[];
    List deviceID =[];
    List devicemodelnum = [];

    if (dtypec==("1")) {
      cur = 0;
    }
    else {
      dtypec = "2";
    }

    DBHelper dbHelper;
    dbHelper = DBHelper();

    List result = await dbHelper.getLocalDateHName(hnamec);
    String userAdmin = result[0]['lg'];
    String userName  = result[0]['ld'];

    print(userAdmin);

    if (userAdmin == 'U' || userAdmin == 'G') {

      timerVisible=false;
      settingsVisible=false;
      List result = await DBProvider.db.getUserDataWithUName(userName);
      String sdv = result[0]['ea'];
      List<String> splitData = sdv.split(';');
      List bothT=[];

      for(int i =0 ; i<splitData.length ; i++){

        String devNo = splitData[i];
        print(devNo);

        List resMas=[];

        List res = await DBProvider.db.dataFromMTRNumAndHNumGroupIdDetails1User(rnumc, hnumc, hnamec, groupIdc, devNo);
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
        else{
          bothT+=resMas;
        }
      }

      int masterU = bothT.length;

      if(masterU != 0){

        for(int i=0;i<bothT.length;i++){

          int devNom = bothT[i]['d'];
          String feature = bothT[i]['e'];
          String deviceName = bothT[i]['ec'];
          String ddevID = bothT[i]['f'];
          String devMNum = bothT[i]['c'];

          if(feature==("CLS1")){
            dnumlist.add(devNom.toString());
            featuretypelist.add(feature);
            devicenamea.add(deviceName);
            deviceID.add(ddevID);
            devicemodelnum.add(devMNum);
          }
          else if(feature==("CRS1")){
            dnumlist.add(devNom.toString());
            featuretypelist.add(feature);
            devicenamea.add(deviceName);
            deviceID.add(ddevID);
            devicemodelnum.add(devMNum);
          }
          else if(feature==("CLNR")){
            dnumlist.add(devNom.toString());
            featuretypelist.add(feature);
            devicenamea.add(deviceName);
            deviceID.add(ddevID);
            devicemodelnum.add(devMNum);


          }

        }

      }


    }
    else if(userAdmin == 'A' || userAdmin == 'SA'){

      timerVisible=true;
      settingsVisible=true;

      print("num $rnumc $hnumc $hnamec $groupIdc");
      List curdata = await DBProvider.db.DataFromMTRNumAndHNumGroupIdDetails1(
          rnumc, hnumc, hnamec, groupIdc);
      print(curdata);
      int masterc = curdata.length;

      if (masterc!= 0) {
        for (int p = 0; p < curdata.length; p++) {

          int devNom = curdata[p]["d"];
          String feature = curdata[p]["e"];
          String devicename = curdata[p]["ec"];
          String ddevID = curdata[p]['f'];
          String ddevmodelnum=curdata[p]['c'];


          if(feature==("CLS1")){
            dnumlist.add(devNom.toString());
            featuretypelist.add(feature);
            devicenamea.add(devicename);
            deviceID.add(ddevID);
            devicemodelnum.add(ddevmodelnum);

            print("$ddevID,$ddevmodelnum");
          }
          else if(feature==("CRS1")){
            dnumlist.add(devNom.toString());
            featuretypelist.add(feature);
            devicenamea.add(devicename);
            deviceID.add(ddevID);
            devicemodelnum.add(ddevmodelnum);

            print("$ddevID,$ddevmodelnum");
          }
          else if(feature==("CLNR")){
            dnumlist.add(devNom.toString());
            featuretypelist.add(feature);
            devicenamea.add(devicename);
            deviceID.add(ddevID);
            devicemodelnum.add(ddevmodelnum);

            print("$ddevID,$ddevmodelnum");
          }
        }

      }

    }



    listcount=dnumlist.length;
    ddevmodel=featuretypelist[cur];
    dnumc=dnumlist[cur];
    String name=devicenamea[cur];

    String dddevmodelnumc=devicemodelnum[cur];
    String deviceIDc=deviceID[cur];



    if(ddevmodel==("CLNR")){
      String devicenamesh="$name"+"SH";
      print("SH $devicenamesh");
      List curdata=await DBProvider.db.DataFromMTHNumSHDeviceNum(rnumc, hnumc, hnamec, groupIdc,devicenamesh);
      print("curdata $curdata");
      if(curdata.length == 0){
       // ddevmodel=="CLNR";
        devinumsh="0000";
      }
      else{
        String devinumShl=curdata[0]['d'].toString();
        devinumsh = devinumShl.padLeft(4, '0');
       // ddevmodel=="CLNRSH";
      }


      if(devinumsh==("0000")){
        print("noshher");
      }

    }
    else{
      devinumsh="0000";

    }

    print("dvs $devinumsh");

    _globalService.hnameset=hnamec;
    _globalService.hnumset=hnumc;
    _globalService.rnumset=rnumc;
    _globalService.dnumset=dnumc;
    _globalService.rnameset=rnamec;
    _globalService.groupIdset=groupIdc;
    _globalService.ddevModelset=ddevmodel;
    _globalService.modeltypeset="CUR";
    _globalService.sheerdnumset=devinumsh;
    _globalService.ddevModelNumset=dddevmodelnumc;
    _globalService.deviceIDset=deviceIDc;


    setState(() {
      listcount=listcount;
      ddevmodel=ddevmodel;
    });

    print("value is $hnamec,$hnumc,$rnumc,$dnumc,$rnamec,$groupIdc");
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
