import 'dart:async';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:smart_home/main1.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/Devicesettings.dart';
import 'package:smart_home/Timer/TimerPopUp.dart';
import 'package:smart_home/SmartDog/SmrtDogIView.dart';

String hnamesdg,hnumsdg,rnumsdg,dnumsdg,rnamesdg,groupIdsdg,dtypesdg,firstsdg;

class Smartdoglayout extends StatefulWidget {
  @override
  _SmartdoglayoutState createState() => _SmartdoglayoutState();
}
class _SmartdoglayoutState extends State<Smartdoglayout>{

  GlobalService _globalService = GlobalService();
  double currentindex=0;
  int listcount=1;
  int sdg;
  String ddevmodel;
  int empty=0;

  bool timerVisible=false;
  bool settingsVisible=false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("enter sdg init state");
    hnamesdg = houseName1;
    hnumsdg = houseNum1;
    rnumsdg = roomNum1;
    dnumsdg = deviceNum1;
    rnamesdg=roomName1;
    groupIdsdg=groupId1;
    dtypesdg=dType1;
    firstsdg=first1;
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
                      dtypesdg="2";
                      print("left");
                      print(sdg);

                      if(sdg==0){
                        if(listcount==1){
                          currentindex=0;
                          swipe();
                        }
                        else{
                          sdg=listcount-1;
                          currentindex=(listcount-1).toDouble();
                          swipe();
                        }
                      }
                      else{
                        sdg--;
                        currentindex--;
                        swipe();
                        print("$sdg $currentindex");

                      }
                    }
                    else if(details.primaryVelocity<0){
                      dtypesdg="2";
                      print("right");
                      print(sdg);
                      fluttertoast("Right Gesture");
                      if(sdg==listcount-1){
                        currentindex=0;
                        sdg=0;
                        swipe();
                      }
                      else if(sdg == 0){
                        print("s eqr $sdg");
                        if(listcount==1){
                          currentindex=0;
                          swipe();
                        }
                        else{
                          currentindex++;
                          print(currentindex);
                          sdg++;
                          swipe();
                        }

                      }
                      else{
                        currentindex++;
                        print(currentindex);
                        sdg++;
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
    if(ddevmodel == 'SDG1') {
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: SmartDogIView(),
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

    if (dtypesdg==("1")) {
      sdg = 0;
    }
    else {
      dtypesdg = "2";
    }

    DBHelper dbHelper;
    dbHelper = DBHelper();

    List result = await dbHelper.getLocalDateHName(hnamesdg);
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

        List res = await DBProvider.db.dataFromMTRNumAndHNumGroupIdDetails1User(rnumsdg, hnumsdg, hnamesdg, groupIdsdg,devNo);
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

          if(feature==("SDG1")){
            dnumlist.add(devNom.toString());
            featuretypelist.add(feature);
            devicenamea.add(devicename);
            deviceID.add(ddevID);
            devicemodelnum.add(devmnum);
          }


        }
      }

    }
    else if(userAdmin == "A" || userAdmin == "SA"){

      timerVisible=true;
      settingsVisible=true;

      print("num $rnumsdg $hnumsdg $hnamesdg $groupIdsdg");
      List sdgdata = await DBProvider.db.DataFromMTRNumAndHNumGroupIdDetails1(
          rnumsdg, hnumsdg, hnamesdg, groupIdsdg);
      print(sdgdata);
      int masterC = sdgdata.length;

      if (masterC!= 0) {
        for (int p = 0; p < sdgdata.length; p++) {

          int devNom = sdgdata[p]["d"];
          String feature = sdgdata[p]["e"];
          String devicename = sdgdata[p]["ec"];
          String ddevID = sdgdata[p]['f'];
          String devmnum = sdgdata[p]["c"];

          print(devmnum);
          print(devicename);

          if(feature==("SDG1")){
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
    ddevmodel=featuretypelist[sdg];
    dnumsdg=dnumlist[sdg];


    String name=devicenamea[sdg];
    print(name);
    String dddevmodelnumc=devicemodelnum[sdg];
    String deviceIDc=deviceID[sdg];

    _globalService.hnameset=hnamesdg;
    _globalService.hnumset=hnumsdg;
    _globalService.rnumset=rnumsdg;
    _globalService.dnumset=dnumsdg;
    _globalService.rnameset=rnamesdg;
    _globalService.groupIdset=groupIdsdg;
    _globalService.ddevModelset=ddevmodel;
    _globalService.modeltypeset="SDG";
    _globalService.sheerdnumset="0000";
    _globalService.ddevModelNumset=dddevmodelnumc;
    _globalService.deviceIDset=deviceIDc;


    setState(() {
      listcount=listcount;
      ddevmodel=ddevmodel;
    });

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
