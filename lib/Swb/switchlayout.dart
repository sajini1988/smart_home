import 'dart:async';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:smart_home/main1.dart';
import 'package:smart_home/Swb/S051.dart';
import 'package:smart_home/Swb/S080.dart';
import 'package:smart_home/Swb/S010.dart';
import 'package:smart_home/Swb/S020.dart';
import 'package:smart_home/Swb/S021.dart';
import 'package:smart_home/Swb/S030.dart';
import 'package:smart_home/Swb/DFN1.dart';
import 'package:smart_home/Swb/S042.dart';
import 'package:smart_home/Swb/S110.dart';
import 'package:smart_home/Swb/S120.dart';
import 'package:smart_home/Swb/S141.dart';
import 'package:smart_home/Swb/S160.dart';
import 'package:smart_home/Swb/SFN1.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/Devicesettings.dart';
import 'package:smart_home/Timer/TimerPopUp.dart';
import 'package:smart_home/Globaltimerdata.dart';

String hnames,hnums,rnums,dnums,rnames,groupIds,dtypes,firsts;

class Switchlayout extends StatefulWidget {
  @override
  _SwitchlayoutState createState() => _SwitchlayoutState();
}

class _SwitchlayoutState extends State<Switchlayout> {

  GlobalService _globalService = GlobalService();
  Globaltimer _globaltimer = Globaltimer();

  double currentindex=0;
  int listcount=1;
  int s;
  String ddevmodel,ddevID,ddevmodelnum;
  int empty=0;
  bool timerVisible=false;
  bool settingsVisible=false;

  @override
  initState(){

    print("enter swb init state");
    super.initState();
    hnames = houseName1;
    hnums = houseNum1;
    rnums = roomNum1;
    dnums = deviceNum1;
    rnames = roomName1;
    groupIds = groupId1;
    dtypes = dType1;
    firsts = first1;
    admin();

  }
  // @override
  // void didChangeDependencies(){
  //
  //   print("did change dependencies");
  //   super.didChangeDependencies();
  //
  // }

  // @override
  // void didUpdateWidget(switchlayout oldWidget) {
  //
  //   super.didUpdateWidget(oldWidget);
  //   print("update widget");


  // }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home:Scaffold(
          backgroundColor: Colors.white,
          body:
            Center(
              child:Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width/1.4,
                  child:GestureDetector(
                    onHorizontalDragEnd: (DragEndDetails details) {
                    if (details.primaryVelocity > 0) {

                   //   flutter_toast("left gesture");
                      dtypes="2";
                      print("left");
                      print(s);

                      if(s==0) {
                        if (listcount == 1) {
                          currentindex = 0;
                          swipe();
                        }
                        else {
                          s = listcount - 1;
                          currentindex = (listcount - 1).toDouble();
                          swipe();
                        }
                      }
                      else{
                        s--;
                        currentindex--;
                        swipe();
                        print("$s $currentindex");
                      }
                      // User swiped Left
                    }
                    else if (details.primaryVelocity < 0) {
                      dtypes="2";
                      print("right");
                      print(s);

                     // flutter_toast("Right Gesture");

                      if(s==listcount-1){
                        currentindex=0;
                        s=0;
                        swipe();

                      }
                      else if(s==0){
                        print("s eqr $s");
                        if(listcount==1){
                          currentindex=0;
                          swipe();
                        }
                        else {
                          currentindex++;
                          print(currentindex);
                          s++;
                          swipe();
                        }
                      }
                      else{

                        currentindex++;
                        print(currentindex);
                        s++;

                        print("$s $currentindex");
                        swipe();
                      }

                      // User swiped Right
                    }
                  },
                    child: Column(

                    children: [
                      Tab(

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(flex: 2,child:Container()),
                            Expanded(

                                flex:4,
                                child:Center(
                                  child:Container(alignment: Alignment.center,
                                    child:new DotsIndicator(
                                      dotsCount:listcount,
                                      position: currentindex,
                                      decorator: DotsDecorator(
                                        color: Colors.black12, // Inactive color
                                        activeColor: Colors.blue,
                                      ),
                                      onTap:(position){
                                        print(position);
                                      },
                                    ),
                                  ),)),


                            Expanded(
                                flex:1,
                                child:Container(
                                  child:Visibility(
                                    visible: settingsVisible,
                                    child: InkWell(
                                      onTap: (){
                                        print("devicesettings");
                                        devicesettings();
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20.0),
                                        child: Image.asset('images/settings_icon.png',
                                            width:MediaQuery.of(context).size.width/11, fit: BoxFit.fill),
                                      ),
                                    ),
                                  ),)),

                            Expanded(
                                flex:1,
                                child:Container(
                                  margin: EdgeInsets.only(right: 02),
                                  child: Visibility(
                                    visible: timerVisible,
                                    child: InkWell(
                                      onTap: (){
                                        print("timersettings");
                                        _globaltimer.ondataarrayset=[];
                                        _globaltimer.offdataarrayset=[];
                                        _globaltimer.switchnumberset=[];
                                        showAlertDialog(context);
                                      },
                                      //child: ClipRRect(
                                        //borderRadius: BorderRadius.circular(20.0),
                                        child: Image.asset('images/timer_settings.png',
                                            width:MediaQuery.of(context).size.width/11, fit: BoxFit.fill),
                                      ),
                                    ),
                                  ),
                            )
                          //)

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

      // AlertDialog alert = AlertDialog(
      //
      //  // elevation:0,
      //   contentPadding: EdgeInsets.zero,
      //   titlePadding: EdgeInsets.zero,
      //   clipBehavior:Clip.antiAliasWithSaveLayer,
      //   insetPadding: EdgeInsets.all(30.0),
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

    showDialog(
      barrierColor: Colors.black26,
      context: context,
      builder: (context) {
        return Timerpage();
      },
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

    print("child $ddevmodel");
    Container container1;
    if(ddevmodel == 'S051') {
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: S051(),
      );
    }
    else if(ddevmodel == 'S141') {
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: S141(),
      );
    }
    else if(ddevmodel == 'S110') {
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: S110(),
      );
    }
    else if(ddevmodel == 'S120') {
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: S120(),
      );
    }
    else if(ddevmodel == 'S160') {
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: S160(),
      );
    }
    else if(ddevmodel == 'SFN1') {
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: SFN1(),
      );
    }
    else if(ddevmodel == 'S042') {
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: S042(),
      );
    }
    else if(ddevmodel == 'DFN1') {
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: DFN1(),
      );
    }
    else if(ddevmodel == 'S080'){
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: S080(),
      );
    }
    else if(ddevmodel == 'S010'){
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: S010(),
      );
    }
    else if(ddevmodel == 'SLT1'){
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: S010(),
      );
    }

    else if(ddevmodel == 'S020'){
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: S020(),
      );
    }
    else if(ddevmodel == 'S021'){
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: S021(),
      );
    }
    else if(ddevmodel == 'S030'){
      container1 = Container(
        width:MediaQuery.of(context).size.width / 1.4,
        color: Colors.white,
        child: S030(),
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
      empty=1;
      container1=Container();
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

  void newAdmin()async{

    print("nwadmin");

    if(dtypes==("1")){
      s=0;
    }
    else{
      dtypes = "2";
    }

    DBHelper dbHelper;
    dbHelper = DBHelper();

    List result = await dbHelper.getLocalDateHName(hnames);
    String userAdmin=result[0]['lg'];
    String userName = result[0]['ld'];

    print(userAdmin);

    if(userAdmin == "U" || userAdmin == "G") {
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

        List resSw=[];

        List res = await DBProvider.db.getSwitchBoardDateFromRNumAndHNumUser(rnums,hnums,hnames,devNo);
        if(res.length==0){
          resSw=res;
        }
        else if(res==null){
          resSw=res;
        }
        else{
          resSw=res;
        }


        if(bothT.length == 0){
          bothT=resSw;
        }
        else {
          bothT+=resSw;
        }
      }

      listcount = bothT.length;

      if(s<=listcount){
        dnums = bothT[s]['d'].toString();
      }

    }

    else if(userAdmin == 'A' || userAdmin == 'SA') {
      timerVisible=true;
      settingsVisible=true;

      List res = await DBProvider.db.getSwitchBoardDateFromRNumAndHNum(
          rnums, hnums, hnames);
      // List res=["S051","S030","S021","S020","S080"];
      listcount = res.length;

      if (s <= listcount) {
        dnums = res[s]['d'].toString();
      }
    }
     List res1 = await DBProvider.db.getSwitchBoardDateFromRNumAndHNumWithDN(rnums, hnums, dnums, hnames);
     print("sw $res1");
     ddevmodel = res1[0]['e'];
     ddevID = res1[0]['f'];
     ddevmodelnum=res1[0]['c'];

     _globalService.hnameset=hnames;
     _globalService.hnumset=hnums;
     _globalService.rnumset=rnums;
     _globalService.dnumset=dnums;
     _globalService.rnameset=rnames;
     _globalService.groupIdset=groupIds;
     _globalService.ddevModelset=ddevmodel;
     _globalService.ddevModelNumset=ddevmodelnum;
     _globalService.modeltypeset="SWB";
     _globalService.deviceIDset=ddevID;

     setState(() {
       ddevmodel =ddevmodel;
       listcount=listcount;
     });

     print("devmodel $ddevmodel$s");



  }




}