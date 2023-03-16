//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/Swb/switchlayout.dart';
import 'package:smart_home/main.dart';
import 'package:smart_home/Curtain/CurtainLayout.dart';
import 'package:smart_home/PIR/PIRLayout.dart';
import 'package:smart_home/Sprinkler/SprinkLayout.dart';
import 'package:smart_home/Projector/ProjLayout.dart';
import 'package:smart_home/SmartDog/SmrtDogLayout.dart';
import 'package:smart_home/Somphy/SomphyLayout.dart';
import 'package:smart_home/Slide/SlideLayout.dart';
import 'package:smart_home/Swing/SwingLayout.dart';
import 'package:smart_home/AC/Ac.dart';
import 'package:smart_home/Bell/bell.dart';
import 'package:smart_home/DLock/DLock.dart';
import 'package:smart_home/Geyser/Geyser.dart';
import 'package:smart_home/ProjectorLift/ProjLiftLayout.dart';
import 'package:smart_home/RGB/RGBLayout.dart';
import 'package:smart_home/FM/fm.dart';

String device1,roomName1,roomNum1,houseNum1,houseName1,groupId1,deviceType1,deviceNum1,dType1,gType1,first1;
class MainlayoutPage extends StatefulWidget {
  @override
  _MainlayoutPageState createState() => _MainlayoutPageState();
}

class _MainlayoutPageState extends State<MainlayoutPage>{

  String layoutcall;

  @override
  void initState(){
    print("enter main1 init state");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    device1=device;
    roomName1=roomName;
    roomNum1=roomNo;
    houseNum1=houseNum;
    houseName1=houseName;
    groupId1=groupId;
    deviceType1=deviceType;
    deviceNum1=deviceNum;
    dType1=dType;
    gType1=gType;
    first1=first;
    String button = device;

    print("bt $button");

    if(button==("swb")){

      setState(() {
        layoutcall = "switch";
      });
      print("name $roomName1,$roomNum1,$first1");

    }
    else if(button == ("FM1")){

      setState(() {
        layoutcall = "fmView";
      });
      print("name $roomName1,$roomNum1,$first1");
    }
    else if(button==("rgb")){

      setState(() {
        layoutcall = "rgbIView";
      });
      print("name $roomName1,$roomNum1,$first1");

    }
    else if(button==("cur")){


      setState(() {
        layoutcall = "curtain";
      });
      print("name $roomName1,$roomNum1,$first1");

    }
    else if(button==("pir")) {

      setState(() {
        layoutcall = "pirsensor";
      });
    }
    else if(button==("gsk")){

      print("Enter GskIView layout");
      print("name $roomName1,$roomNum1,$first1");
      setState(() {
        layoutcall = "sprinlkerIView";
      });

    }
    else if(button==("sdg")){

      print("Enter GskIView layout");
      print("name $roomName1,$roomNum1,$first1");
      setState(() {
        layoutcall = "smartdog";
      });

    }
    else if(button==("psc")){

      print("Enter GskIView layout");
      print("name $roomName1,$roomNum1,$first1");
      setState(() {
        layoutcall = "projector";
      });

    }
    else if(button==("pscL")){

      print("Enter GskIView layout");
      print("name $roomName1,$roomNum1,$first1");
      setState(() {
        layoutcall = "projectorLift";
      });

    }
    else if(button==("swng")){

      print("Enter swng layout");
      print("name $roomName1,$roomNum1,$first1");
      setState(() {
        layoutcall = "swing";
      });

    }
    else if(button==("slg")){

      print("Enter slide layout");
      print("name $roomName1,$roomNum1,$first1");
      setState(() {
        layoutcall = "slide";
      });

    }

    else if(button==("somphy")){

      print("Enter somphy layout");
      print("name $roomName1,$roomNum1,$first1");
      setState(() {
        layoutcall = "somphyshutter";
      });

    }
    else if(button==("alxa")){

      print("Enter somphy layout");
      print("name $roomName1,$roomNum1,$first1");
      setState(() {
        layoutcall = "alexa";
      });

    }
    else if(button==("mir")){

      print("Enter somphy layout");
      print("name $roomName1,$roomNum1,$first1");
      setState(() {
        layoutcall = "Mir";
      });

    }
    else if(button==("ac")){

      print("Enter somphy layout");
      print("name $roomName1,$roomNum1,$first1");
      setState(() {
        layoutcall = "Ac";
      });

    }
    else if(button==("gey")){

      print("Enter somphy layout");
      print("name $roomName1,$roomNum1,$first1");
      setState(() {
        layoutcall = "Gey";
      });

    }
    else if(button==("bell")){

      print("Enter somphy layout");
      print("name $roomName1,$roomNum1,$first1");
      setState(() {
        layoutcall = "Bell";
      });

    }




    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Scaffold(
          body:Center(
            child: Column(
              children: [
                Expanded(child:getchild()
              ),
            ],
            ),
          )
        )

    );
  }

  getchild(){

    Container container1;
    if(layoutcall == 'switch'){
      container1=Container(
        width:MediaQuery.of(context).size.width/1.4,
        child: new Switchlayout(),
        color: Colors.white,
        //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
      );

    }

    else if(layoutcall == 'fmView'){
      container1=Container(
        width:MediaQuery.of(context).size.width/1.4,
        child: new FmLayout(),
        color: Colors.white,
        //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
      );

    }

    else if(layoutcall == 'curtain'){
      container1=Container(
        width:MediaQuery.of(context).size.width/1.4,
        child: new Curtainlayout(),
        color: Colors.white,
        //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
      );
    }

    else if(layoutcall == 'pirsensor'){
      container1=Container(
        width:MediaQuery.of(context).size.width/1.4,
        child: new Pirlayout(),
        color: Colors.white,
        //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
      );
    }
    else if(layoutcall == 'sprinlkerIView'){
      container1=Container(
        width:MediaQuery.of(context).size.width/1.4,
        child: new Spnklayout(),
        color: Colors.white,
        //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
      );
    }
    else if(layoutcall == 'smartdog'){
      container1=Container(
        width:MediaQuery.of(context).size.width/1.4,
        child: new Smartdoglayout(),
        color: Colors.white,
        //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
      );
    }
    else if(layoutcall == 'projector'){
      container1=Container(
        width:MediaQuery.of(context).size.width/1.4,
        child: new PscLayout(),
        color: Colors.white,
        //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
      );
    }
    else if(layoutcall == 'projectorLift'){
      print("enter lift layout");
      container1=Container(
        width:MediaQuery.of(context).size.width/1.4,
        child: new PlcLayout(),
        color: Colors.white,
        //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
      );
    }
    else if(layoutcall == 'swing'){
      container1=Container(
        width:MediaQuery.of(context).size.width/1.4,
        child: new Swinglayout(),
        color: Colors.white,
        //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
      );
    }
    else if(layoutcall == 'slide'){
      container1=Container(
        width:MediaQuery.of(context).size.width/1.4,
        child: new SlideLayout(),
        color: Colors.white,
        //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
      );
    }
    else if(layoutcall == 'somphyshutter'){
      print("enter somphy shutter");
      container1=Container(
        width:MediaQuery.of(context).size.width/1.4,
        child: new SomphyLayout(),
        color: Colors.white,
        //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
      );
    }
    else if(layoutcall == 'Ac'){
      container1=Container(
        width:MediaQuery.of(context).size.width/1.4,
        child: new Aclayout(),
        color: Colors.white,
        //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
      );
    }
    else if(layoutcall == 'Gey'){
      container1=Container(
        width:MediaQuery.of(context).size.width/1.4,
        child: new Geylayout(),
        color: Colors.white,
        //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
      );
    }
    else if(layoutcall == 'Bell'){
      container1=Container(
        width:MediaQuery.of(context).size.width/1.4,
        child: new BellLayout(),
        color: Colors.white,
        //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
      );
    }
    else if(layoutcall == 'DLock'){
      print("enter lock layout");
      container1=Container(
        width:MediaQuery.of(context).size.width/1.4,
        child: new LockLayout(),
        color: Colors.white,
        //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
      );
    }
    else if(layoutcall == 'rgbIView'){
      print("enter rgb layout");
      container1=Container(
        width:MediaQuery.of(context).size.width/1.4,
        child: new RGBLayout(),
        color: Colors.white,
        //child: MainlayoutPage(s:"swb1",Roomname: roomnametest,Roomno: roommnumtest.toString(),Housenum:lb, Housename: name, GroupID:"000", DeviceType:"0000",deviceNum:"0000",GType:"1",DType:"1")
      );
    }
    else{
      container1=Container();
    }
    return container1;

  }



}
