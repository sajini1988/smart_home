// ignore_for_file: unnecessary_statements, duplicate_ignore
//import 'dart:async';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home/HouseSettings/OperatorSettings/GatewaySettings.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:smart_home/Singleton.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/HouseSettings/OperatorSettings/DeleteUser.dart';
import 'package:smart_home/HouseSettings/OperatorSettings/EditUserMenu.dart';
import 'package:smart_home/HouseSettings/OperatorSettings/DeleteDevice.dart';
import 'package:smart_home/HouseSettings/OperatorSettings/DeleteRoom.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:smart_home/HouseSettings/OperatorSettings/Roomname_edit.dart';
import 'package:smart_home/HouseSettings/OperatorSettings/AddUsern.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum OperatorSett {IPSettings,UserSettings,Configuration,GatewaySettings,empty}

class OperatorSettings extends StatefulWidget{
  OperatorSettings({Key key, todo,}): super(key:key);

  @override
  _OperatorSettings createState() => _OperatorSettings();
}

class _OperatorSettings extends State<OperatorSettings>{

  var s=Singleton();
  GlobalService _globalService = GlobalService();
  String hname,hnum;
  String imgso = "disconnected";
  String imgno= "nonet";

  bool visibleC=false;
  bool visibleIp=false;
  bool visibleG=false;

  bool deleteR=false;
  bool deleteD=false;

  bool hideVup=false,deleteVRm=false,deleteVdv=false,deleteVHou=false,editVr=false;

  //Operator_Settings _site1=Operator_Settings.IPSettings;

  OperatorSett _site1=OperatorSett.empty;

  bool adduserenabled=false,edituserenabled=false,deleteuserenabled=false,updatehouseenabled=false,deleteRoomenabled=false,deleteDeviceenabled=false,deleteHouseenabled=false,editroomname=false;

  var serverIPController = TextEditingController();
  var portController = TextEditingController();
  var ssidController = TextEditingController();
  var remoteIPController = TextEditingController();

  bool disableIp=false,userSettings=false,gatewaySettings=false,configuration=false,userAccess=false;
  GlobalKey<FormState> _key1 = new GlobalKey();

  String userAdmin,userName;

  DBHelper dbHelper;

  Color colorOn=Colors.black,colorOff= Color.fromRGBO(211, 211, 211, 0.7);
  Color colorBoth;

  Timer timer1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );

    colorBoth=colorOff;
    hname = _globalService.hname;
    hnum = _globalService.hnum;


    FNC.DartNotificationCenter.unregisterChannel(channel: 'DownLoadW');
    FNC.DartNotificationCenter.registerChannel(channel: 'DownLoadW');
    FNC.DartNotificationCenter.subscribe(channel: 'DownLoadW', onNotification: (options) {

      recWDownload();
      timer1.cancel();

    },observer: null);


    FNC.DartNotificationCenter.unregisterChannel(channel: 'DownLoadWLS');
    FNC.DartNotificationCenter.registerChannel(channel: 'DownLoadWLS');
    FNC.DartNotificationCenter.subscribe(channel: 'DownLoadWLS', onNotification: (options) {

      recWLSDownload();
      timer1.cancel();

    },observer: null);

    FNC.DartNotificationCenter.unregisterChannel(channel: 'DownLoadWFailure');
    FNC.DartNotificationCenter.registerChannel(channel: 'DownLoadWFailure');
    FNC.DartNotificationCenter.subscribe(channel: 'DownLoadWFailure', onNotification: (options) {

      recFailure();
      timer1.cancel();

    },observer: null);

    dbHelper = DBHelper();
    userAdminAccess();

  }

  recFailure(){
    Navigator.of(context,rootNavigator: true).pop();
    showAlertDialogUpdateFailure(context,"Update Failure");

  }

  recWLSDownload(){

    Navigator.of(context,rootNavigator: true).pop();
    showAlertDialogUpdateFailure(context,"Wireless Settings Downloaded Successfully.");

  }

  recWDownload(){

    Navigator.of(context,rootNavigator: true).pop();
    showAlertDialogUpdateStatus(context,"Wired updated Successfully. Do you want to Download Wireless Settings");

  }

  showIndicator(){

    showDialog(
        context: context,
        barrierDismissible:false ,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator(),);
        }
    );

    timer1 = Timer(Duration(seconds: 10), () {
      showAlertDialogUpdateFailure(context, "UpdateFailed");
    });

  }

  showAlertDialogUpdateStatus(BuildContext context,String message) {

    // Create button
    Widget yesButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.of(context,rootNavigator: true).pop();

        updateWireless();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text(message),
      actions: [
        yesButton
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  updateWireless(){

    if(s.socketconnected == true){

      showIndicator();
      Timer(Duration(seconds: 2), () {
        s.socket1('\$121&');
      });
    }
    else{
      fluttertoast("Socket Not Connected");
    }
  }

  showAlertDialogUpdateFailure(BuildContext context,String message) {

    // Create button
    Widget yesButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.of(context,rootNavigator: true).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text(message),
      actions: [
        yesButton
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  userAdminAccess() async {


    List result = await dbHelper.getLocalDateHName(hname);
    userAdmin = result[0]['lg'];
    userName = result[0]['ld'];

    if(userAdmin == "A") {

      visibleC = false;
      visibleIp = false;
      visibleG = false;

      hideVup = false;
      deleteVRm = false;
      deleteVdv = false;
      deleteVHou = false;
      editVr = false;

      colorBoth=colorOff;

    }
    else if(userAdmin == "SA"){


      colorBoth=colorOn;


      visibleC=true;
      visibleIp=true;
      visibleG=true;

      hideVup = true;
      deleteVRm = true;
      deleteVdv = true;
      deleteVHou = true;
      editVr = true;

    }
  }

  clearRadio(){

    setState(() {
      _site1=OperatorSett.empty;
    });

  }

  void nwimage(String options){

    if (options==("Mobile")) {
      print("Mobile");
      imgno = "3g";
      setState(() {
        imgno=imgno;
      });

    }
    else if (options.contains("LWi-Fi")) {
      imgno = 'local_sig';
      setState(() {
        imgno=imgno;
      });
    }
    else if (options.contains("RWi-Fi")) {
      imgno = 'remote01';
      setState(() {
        imgno=imgno;
      });
    }
    else if (options.contains("No_Net")) {
      imgno = 'nonet';
      setState(() {
        imgno=imgno;
      });
    }

  }

  void swimage(bool s1){

    print(s1);
    if(s1==false){
      imgso = "disconnected";
    }
    else if(s1 == true){
      imgso = "connected";
    }

    setState(() {
      imgso=imgso;
    });
  }


  @override
  Widget build(BuildContext context) =>FocusDetector(

      onFocusLost: () {
        print("focusop lost");

        FNC.DartNotificationCenter.unregisterChannel(channel: "networkconn");
        FNC.DartNotificationCenter.unregisterChannel(channel: "socketconn");
      },
      onFocusGained: () {
        print("focusop gained");

        FNC.DartNotificationCenter.registerChannel(channel: 'networkconn');
        FNC.DartNotificationCenter.subscribe(channel: 'networkconn', onNotification: (options) {
          print('Notified: $options');
          nwimage(options);
        }, observer: null,
        );

        FNC.DartNotificationCenter.registerChannel(channel: 'socketconn');
        FNC.DartNotificationCenter.subscribe(channel: 'socketconn', onNotification: (options) {
          print('Notified: $options');
          swimage(options);
        }, observer: null,
        );

        nwimage(s.networkconnected);
        swimage(s.socketconnected);

       // clearRadio();
      },
    child: WillPopScope(onWillPop: () async {
        return Navigator.canPop(context);
      },
        child:Scaffold(
          appBar: AppBar(
            toolbarHeight: 40.0,
            backgroundColor: Color.fromRGBO(66, 130, 208, 1),
            title: Text("Operator Settings",style:TextStyle(fontSize: 18)),
            actions: <Widget>[
            IconButton(
              icon: Image.asset('images/$imgso.png', fit: BoxFit.fill),
              onPressed: () {
                s.checkindevice(hname, hnum);
              },
            ),
            IconButton(
              icon: Image.asset('images/$imgno.png', fit: BoxFit.fill),
              onPressed: () {

              },
            ),
            ],
          ),
          backgroundColor: Colors.white,
          body: ListView(
            children: [
              Column(
                children:<Widget> [
                  Row(
                    children: [
                      Expanded(
                          child: ListTile(
                            title: Text('IP Settings',
                              style: TextStyle(
                                  color: colorBoth,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal
                              ),),
                            leading: Visibility(
                              visible: visibleIp,
                              child: Radio(
                              value: OperatorSett.IPSettings,
                              groupValue: _site1,
                              onChanged: (OperatorSett value) {


                                if(userAdmin=="SA"){

                                  print("changed $_site1,$value");
                                  setState(() {
                                    print("$_site1,$value");
                                    _site1=value;
                                    print("$_site1,$value");
                                    deleteuserenabled=false;
                                    adduserenabled=false;
                                    edituserenabled=false;
                                    updatehouseenabled=false;
                                    deleteRoomenabled=false;
                                    deleteDeviceenabled=false;
                                    deleteHouseenabled=false;
                                    editroomname=false;

                                  });

                                  ipsettingsdialog();

                                }
                                else{
                                  fluttertoast("ACCESS DENIED");
                                }

                                },
                            ),),
                            onTap: (){

                              print("on tap change");

                            },
                          )
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: ListTile(
                            title: Text('User Settings',
                              style: TextStyle(
                                  color: colorOn,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal
                              ),),
                            leading: Radio(
                              value: OperatorSett.UserSettings,
                              groupValue: _site1,
                              onChanged: (OperatorSett value){
                                setState(() {
                                  _site1=value;
                                  adduserenabled=true;
                                  edituserenabled=true;
                                  deleteuserenabled=true;
                                  updatehouseenabled=false;
                                  deleteRoomenabled=false;
                                  deleteDeviceenabled=false;
                                  deleteHouseenabled=false;
                                  editroomname=false;
                                });
                              },
                            ),
                            onTap: (){

                            },
                          )
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0,0.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Expanded(
                        //   flex:1,
                        //   child: Container()
                        // ),
                      Expanded(
                        flex: 3,
                        child:MaterialButton(
                          padding: EdgeInsets.all(8.0),
                          textColor: Colors.white,
                          // splashColor: Colors.greenAccent,
                          elevation: 0.0,
                          child: Container(
                            width:MediaQuery.of(context).size.width ,

                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: adduserenabled?AssetImage('images/Moods/save_button.png'):AssetImage('images/Moods/config1.png'),
                                  fit: BoxFit.fill),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(child: Text(" Add User ")),
                            ),
                          ),
                          // ),
                          onPressed: () {
                            print(adduserenabled);
                            adduserenabled ? adduser(): null;
                          },

                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child:MaterialButton(
                          padding: EdgeInsets.all(8.0),
                          textColor: Colors.white,
                         // splashColor: Colors.greenAccent,
                          elevation: 0.0,
                          child: Container(
                            width:MediaQuery.of(context).size.width ,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: edituserenabled?AssetImage('images/Moods/save_button.png'):AssetImage('images/Moods/config1.png'),
                                  fit: BoxFit.fill),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(child: Text(" Edit User ")),
                            ),
                          ),
                          // ),
                          // ignore: duplicate_ignore
                          onPressed: () {
                            print(edituserenabled);
                            // ignore: unnecessary_statements
                            edituserenabled ? edituser() : null;
                          },
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child:MaterialButton(
                          padding: EdgeInsets.all(8.0),
                          textColor: Colors.white,
                          // splashColor: Colors.greenAccent,
                          elevation: 0.0,
                          child: Container(
                            width:MediaQuery.of(context).size.width ,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: deleteuserenabled?AssetImage('images/Moods/save_button.png'):AssetImage('images/Moods/config1.png'),
                                  fit: BoxFit.fill),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(child: Text("Delete User")),
                            ),
                          ),
                          // ),
                          onPressed: () {
                            print(deleteuserenabled);
                            deleteuserenabled ? deleteuser() : null;
                          },

                        ),
                      ),
                    ],
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(
                          child: ListTile(
                            title: Text('Gateway Settings',style: TextStyle(
                                color: colorBoth,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal
                            ),),
                            leading:
                            Visibility(
                              visible: visibleG,
                              child:Radio(
                              value: OperatorSett.GatewaySettings,
                              groupValue: _site1,
                              onChanged: (OperatorSett value){
                                setState(() {

                                  if(userAdmin=="SA"){

                                    _site1=value;
                                    adduserenabled=false;
                                    edituserenabled=false;
                                    deleteuserenabled=false;
                                    updatehouseenabled=false;
                                    deleteRoomenabled=false;
                                    deleteDeviceenabled=false;
                                    deleteHouseenabled=false;
                                    editroomname=false;
                                    _site1=OperatorSett.empty;

                                  }
                                  else  if( userAdmin == "A"){
                                    fluttertoast("Access Denied");
                                  }


                                });
                                Navigator.push(context, MaterialPageRoute(builder: (context) => GatewaySettingsPage()));
                              },
                            ),),
                            onTap: (){


                              // Navigator.push(context,
                              //     MaterialPageRoute(builder: (context) => GatewaySettingsPage()));
                              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => GatewaySettings()));
                            },
                          )
                      )

                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: ListTile(
                            title: Text('Configuration',
                              style: TextStyle(
                                  color: colorBoth,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal
                              ),),
                            leading:Visibility(
                              visible: visibleC,
                              child:Radio(
                              value: OperatorSett.Configuration,
                              groupValue: _site1,
                              onChanged: (OperatorSett value){

                                setState(() {
                                  _site1=value;
                                  adduserenabled=false;
                                  edituserenabled=false;
                                  deleteuserenabled=false;
                                  updatehouseenabled=true;
                                  deleteRoomenabled=true;
                                  deleteDeviceenabled=true;
                                  deleteHouseenabled=true;
                                  editroomname=true;
                                });
                              },
                            ),),
                            onTap: (){


                            },
                          )
                      )
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0,0.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child:
                          Visibility(
                            visible: hideVup,
                            child:MaterialButton(
                            padding: EdgeInsets.all(8.0),
                            textColor: Colors.white,
                            // splashColor: Colors.greenAccent,
                            elevation: 0.0,
                            child: Container(
                              width:MediaQuery.of(context).size.width ,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: updatehouseenabled?AssetImage('images/Moods/save_button.png'):AssetImage('images/Moods/config1.png'),
                                    fit: BoxFit.fill),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(child: Text(" Update House ")),
                              ),
                            ),
                            // ),
                            onPressed: () {

                              print(updatehouseenabled);
                              updatehouseenabled ? updateHouse() : null;

                            },

                          ),
                        ),),
                        Expanded(
                          flex: 3,
                          child:Visibility(
                            visible:deleteVRm,
                            child:MaterialButton(
                            padding: EdgeInsets.all(8.0),
                            textColor: Colors.white,
                            // splashColor: Colors.greenAccent,
                            elevation: 0.0,
                            child: Container(
                              width:MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: deleteRoomenabled?AssetImage('images/Moods/save_button.png'):AssetImage('images/Moods/config1.png'),
                                    fit: BoxFit.fill),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(child: Text(" Delete Room ")),
                              ),
                            ),
                            // ),
                            onPressed: () {

                                print(deleteRoomenabled);
                                deleteRoomenabled ? deleteRoom() : null;
                              },
                          ),
                        ),

                        ),],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0,0.0),
                    child: Row(

                      children: [
                        Expanded(
                          flex: 3,
                          child: Visibility(
                            visible:deleteVdv,
                            child:MaterialButton(
                            padding: EdgeInsets.all(8.0),
                            textColor: Colors.white,
                            // splashColor: Colors.greenAccent,
                            elevation: 0.0,
                            child: Container(
                              width:MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: deleteDeviceenabled?AssetImage('images/Moods/save_button.png'):AssetImage('images/Moods/config1.png'),
                                    fit: BoxFit.fill),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(child: Text(" Delete Device ")),
                              ),
                            ),
                            // ),
                            onPressed: () {

                              print(deleteDeviceenabled);
                              deleteDeviceenabled ? deleteDevice() : null;

                              },
                          ),
                        ),),
                        Expanded(
                          flex: 3,
                          child:Visibility(
                            visible: deleteVHou,
                            child:MaterialButton(
                            padding: EdgeInsets.all(8.0),
                            textColor: Colors.white,
                            // splashColor: Colors.greenAccent,
                            elevation: 0.0,
                            child: Container(
                              width:MediaQuery.of(context).size.width ,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: deleteHouseenabled?AssetImage('images/Moods/save_button.png'):AssetImage('images/Moods/config1.png'),
                                    fit: BoxFit.fill),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(child: Text(" Delete House ")),
                              ),
                            ),
                            // ),
                            onPressed: () {

                              print(deleteHouseenabled);
                              deleteHouseenabled ? deleteHouse() : null;

                            },

                          ),
                        ),
                        ),],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0,0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                         // flex: 3,
                          child:Visibility(visible:editVr,child:MaterialButton(
                            padding: EdgeInsets.all(8.0),
                            textColor: Colors.white,
                            // splashColor: Colors.greenAccent,
                            elevation: 0.0,
                            child: Container(
                             // width:MediaQuery.of(context).size.width ,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: editroomname?AssetImage('images/Moods/save_button.png'):AssetImage('images/Moods/config1.png'),
                                    fit: BoxFit.fill),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(" Edit Room Name "),
                              ),
                            ),
                            // ),
                            onPressed: () {

                              print(editroomname);
                              editroomname ? roomName() : null;

                            },
                          ),
                        ),

                        ),],
                    ),
                  ),
                ],
              )
            ],

          )
        )
    ));



  deleteRoom(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => DeleteRoomPage()));
  }

  updateHouse(){

    print("Update House");
    if(s.socketconnected == true){

      showIndicator();
      s.socket1('\$118&');
    }
    else{
      fluttertoast("Connect to server");
    }
  }

  deleteDevice(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => DeleteDevicePage()));
  }

  deleteHouse(){
    showAlertDialogdeletehome(context,"Delete Home");
  }

  roomName(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => RoomNameEditPage()));
  }

  showAlertDialogdeletehome(BuildContext context,String usertype) {

    print("password changed success");
    // Create button
    Widget yesButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        dbHelper.delete(hname);
        fluttertoast("Successfully deleted");

        Navigator.of(context,rootNavigator: true).pop();
      },
    );

    Widget noButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context,rootNavigator: true).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("Do you want to Delete the house"),
      actions: [
        yesButton,
        noButton
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        print("error while changed password");
        return alert;
      },
    );
  }


  void ipsettingsdialog(){

    print("ip settings dialog");

    AlertDialog alert = AlertDialog(

      title: Center(
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child:
            Text(
              "IP Settings",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal
              ),
              maxLines: 2,
            ),
          )
      ),
      content: SizedBox(
        width:double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _key1,
           autovalidateMode: AutovalidateMode.disabled,
           // autovalidate: _autoValidate1,
            child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                      child: Text("Server LIP")
                  ),
                  Expanded(
                      flex: 7,
                      child: TextFormField(
                        enabled: true,
                        controller: serverIPController,
                        validator: _validateip,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          // counterText: '',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(15)),

                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 1, color: Colors.red),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          labelText: 'Server IP',
                        ),
                      )
                  )
                ],
              ),
              Padding(padding: const EdgeInsets.all(6.0),),
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Text("PORT")
                  ),
                  Expanded(
                      flex: 7,
                      child: TextFormField(
                        enabled: true,
                        keyboardType: TextInputType.number,
                        validator: _validateport,
                        controller: portController,
                        decoration: InputDecoration(
                          // counterText: '',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 1, color: Colors.red),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          labelText: 'PORT',
                        ),
                      )
                  )
                ],
              ),
              Padding(padding: const EdgeInsets.all(6.0),),
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Text("SSID")
                  ),
                  Expanded(
                      flex: 7,
                      child: TextFormField(
                        enabled: true,
                        controller: ssidController,
                        validator: _validatessid,
                        decoration: InputDecoration(
                          // counterText: '',
                         enabledBorder: OutlineInputBorder(
                           borderSide: const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1, color: Colors.red),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                          labelText: 'SSID',
                        ),
                      )
                  )
                ],
              ),
              Padding(padding: const EdgeInsets.all(6.0),),
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Text("Server RIP")
                  ),
                  Expanded(
                      flex: 7,
                      child: TextFormField(
                        enabled: true,
                        controller: remoteIPController,
                        //validator: _validateRip,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          // counterText: '',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(15)),

                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 1, color: Colors.red),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          labelText: 'Server RIP',
                        ),
                      )
                  )
                ],
              ),
              Padding(padding: const EdgeInsets.all(5.0),),
              Container(
                height: 2,
                color: Colors.black54,
              ),
              Padding(padding: const EdgeInsets.all(5.0),),

              Row(
                 // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex:5,
                      child:MaterialButton(
                        padding: EdgeInsets.all(8.0),
                        textColor: Colors.white,
                        // splashColor: Colors.greenAccent,
                        elevation: 8.0,
                        child: Container(
                          width:MediaQuery.of(context).size.width ,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('images/Moods/save_button.png'),
                                fit: BoxFit.cover),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("CANCEL"),
                          ),
                        ),
                        // ),
                        onPressed: () {

                          _site1=OperatorSett.empty;
                          print(_site1);
                          setState(() {
                            _site1=_site1;
                          });
                          Navigator.of(context,rootNavigator: true).pop();
                          print('Tapped');
                        },
                        //   color: Colors.blueAccent,
                        //
                        //   onPressed: () =>
                        //   {
                        //   },
                        // child: Text(
                        //       "Cancel", softWrap: false, maxLines: 1,),
                      )
                    ),
                    Expanded(
                      flex:5,
                      child:MaterialButton(
                        padding: EdgeInsets.all(8.0),
                        textColor: Colors.white,
                        // splashColor: Colors.greenAccent,
                        elevation: 8.0,
                        child: Container(
                          width:MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('images/Moods/save_button.png'),
                                fit: BoxFit.cover),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(child: Text("  SAVE  ")),
                          ),
                        ),
                        // ),
                        onPressed: () {

                          if (_key1.currentState.validate()) {
                            _key1.currentState.save();
                            _site1=OperatorSett.empty;
                            Navigator.of(context,rootNavigator: true).pop();
                            setState(() {
                              _site1=_site1;
                            });
                            savedatabase();
                          }
                          else{

                          }

                        },
                      ),
                    ),
                  ]
              ),
            ],

          ),
        ),
        ),
      ),
      actions: [],
    );
    showDialog(context: context, builder: (BuildContext context){
      return alert;
    }
    );

    getip();

  }

  savedatabase()async{

   int i = await DBProvider.db.updateServerTableHName(serverIPController.text,portController.text,ssidController.text,remoteIPController.text,hname);
   int i2= await DBProvider.db.updateServerDetailsIp(serverIPController.text, portController.text,ssidController.text, hname,1);

   print("$i,$i2");

   DBHelper dbHelper;
   dbHelper = DBHelper();

   int i3=await dbHelper.updatelocalTableip(hname,serverIPController.text,portController.text);
   print(i3);

   List res = await DBProvider.db.newClient();
   print(res);

   List res1 = await DBProvider.db.newClient3();
   print(res1);

   List res3=await dbHelper.getLocalDateHName(hname);
   print(res3);

  }

  String _validateport(String value){

    if (value.length == 0) {
      print("Please Enter Port");
      return 'Please Enter Port Number';
    } else if (value.length > 0) {
     return null;
    } else {
      return null;
    }

  }

  String _validatessid(String value){

    if (value.length == 0) {
      return 'Please Enter Valid SSID';
    } else if (value.length > 0) {
      return null;
    } else {
      return null;
    }

  }
  String _validateip(String value) {

    RegExp ipExp = new RegExp(r"^(?!0)(?!.*\.$)((1?\d?\d|25[0-5]|2[0-4]\d)(\.|$)){4}$", caseSensitive: false, multiLine: false);

    List items = value.split('.');

    print("validator");
    print(items);
    print(items.length);

    if (items.length == 0) {
      return 'Please Enter Valid IP';
    }
    else if (items.length != 4) {
      return 'IP should be off 4 characters';
    }
    else if( ipExp.hasMatch(value))
    {
      return null;
    }
    else if(!(ipExp.hasMatch(value))){
      return 'Invalid IP';
    }
    else{
      return null;
    }
  }

  String _validateRip(String value) {

    RegExp ipExp = new RegExp(r"^(?!0)(?!.*\.$)((1?\d?\d|25[0-5]|2[0-4]\d)(\.|$)){4}$", caseSensitive: false, multiLine: false);

    List items = value.split('.');

    print("validator");
    print(items);
    print(items.length);

    // if (items.length == 0) {
    //   return 'Please Enter Valid IP';
    // }
    // else
    if (items.length >  4) {
      return 'IP should be off 4 characters';
    }
    else if( ipExp.hasMatch(value))
    {
      return null;
    }
    else if(!(ipExp.hasMatch(value))){
      return 'Invalid IP';
    }
    else{
      return null;
    }
  }

  getip()async{


    // List res1 = await DBProvider.db.getServerDetailsDataWithId(hname, "1");
    // print("resid $res1");
    // String gateway = res1[0]['dg'];
    // String serverdata=res1[0]['pn'];
    //
    // List mywords=gateway.split(".");
    // List portarray = serverdata.split(";");
    //
    // print(mywords.elementAt(1));
    // print(mywords.elementAt(2));
    //
    // print("data is $mywords,$portarray");


    List res = await DBProvider.db.newClient();
    print("resip $res");


    serverIPController.text=res[0]['i'];
    portController.text=res[0]['p'].toString();
    ssidController.text=res[0]['ss'];
    remoteIPController.text=res[0]['ri'];

    setState(() {
     serverIPController.text=serverIPController.text;
     portController.text=portController.text;
     ssidController.text=ssidController.text;
     remoteIPController.text = remoteIPController.text;
    });

  }
  void adduser() {

    AlertDialog alert = AlertDialog(

      elevation: 0,
      // insetPadding: EdgeInsets.symmetric(
      //   horizontal: 50.0,
      //   vertical: 100.0,
      //),
      title: Text(""),
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      content: AddUserPage(),
      actions: [],
    );
    showDialog(context: context, builder: (BuildContext context){
      return alert;
    }
    );

  }

  void edituser(){
    showDialogBoxEdituser(context);
  }

  void deleteuser(){
    showDialogBoxDeleteuser(context);
  }

  fluttertoast(String message){

    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
    );

  }


}
