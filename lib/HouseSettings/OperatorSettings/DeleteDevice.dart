import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/Singleton.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:smart_home/HouseSettings/OperatorSettings/deleteDeviceModelClass.dart';
import 'package:smart_home/HouseSettings/OperatorSettings/deleteRoomModelClass.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focus_detector/focus_detector.dart';

class DeleteDevicePage extends StatefulWidget {

  DeleteDevicePage({Key key, this.title}) :super(key: key);
  final String title;
  @override
  _DeleteDevicePageState createState() => _DeleteDevicePageState();
}

class _DeleteDevicePageState extends State<DeleteDevicePage>{

  var s=Singleton();



  GlobalService _globalService = GlobalService();

  String hname,hnum;

  DBHelper dbHelper;

  Future<List>rooms;

  List<DeleteRoom> userdefinedrooms;
  List<DeleteDevice>userdefineddevices;
  List<DropdownMenuItem<int>> _menuItems;
  List<DropdownMenuItem<int>> _devicemenuItems;

  int _value=0;
  int _value1=0;
  int roomnumber=0;
  int devicenumber=0;

  String imgs = "disconnected";
  String imgn= "nonet";
  String options1="No_net";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );

    hname=_globalService.hname;
    hnum=_globalService.hnum;

    FNC.DartNotificationCenter.unregisterChannel(channel: 'DeleteDevice');
    FNC.DartNotificationCenter.registerChannel(channel: 'DeleteDevice');
    FNC.DartNotificationCenter.subscribe(channel: 'DeleteDevice', onNotification: (options) {
      print('DeleteDevice: $options');
      deletedeviceresponce(options);
    },observer: null
    );

    hname=_globalService.hname;
    hnum=_globalService.hnum;
    getrooms();
    getdevices();

  }

  void nwimage(String options){

    if (options.contains("Mobile")) {
      print("Mobile");
      imgn = "3g";
      setState(() {
        imgn=imgn;
      });

    }
    else if (options.contains("LWi-Fi")) {
      imgn = 'local_sig';
      setState(() {
        imgn=imgn;
      });
    }
    else if (options.contains("RWi-Fi")) {
      imgn = 'remote01';
      setState(() {
        imgn=imgn;
      });
    }
    else if (options.contains("No_Net")) {
      imgn = 'nonet';
      setState(() {
        imgn=imgn;
      });
    }

  }

  void swimage(bool s1){

    print(s1);
    if(s1==false){
      imgs = "disconnected";
    }
    else if(s1 == true){
      imgs = "connected";
    }

    setState(() {

      imgs=imgs;

    });
  }


  deletedeviceresponce(String options){

    print(options);
    if(options==("&011W@")){
      print("Delete Device in Wired DB failed");
    }
    else if(options == ("&011WL@")){
      print("Delete Device in Wireless DB Failed");
    }
    else if(options == ("&011T@")){

      DBProvider.db.deleteSWdevice(devicenumber);
      DBProvider.db.deleteMasdevice(devicenumber);
      showAlertDialogdeleteDeviceSuccess(context, "Delete Device in Timer DB Failed");

    }
    else if(options == ("&011S@")){

      DBProvider.db.deleteSWdevice(devicenumber);
      DBProvider.db.deleteMasdevice(devicenumber);
      showAlertDialogdeleteDeviceSuccess(context, "Device Deleted Successfully");

    }
  }

  showAlertDialogdeleteDeviceSuccess(BuildContext context, String finala) {

    Widget yesButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
          Navigator.of(context,rootNavigator: true).pop();
         // getrooms();
         // getdevices();
        },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text(finala),
      actions: [
        yesButton,
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

  getrooms()async{
    rooms=DBProvider.db.comlist();
    functiongetlist().then((List value) {
      userdefinedrooms=[];
      if (value.length > 0) {
        userdefinedrooms.add(DeleteRoom(rnumber: 0, rname: "Select Room"));
        for (int i = 0; i < value.length; i++) {
          userdefinedrooms.add(DeleteRoom(rnumber: value[i]['a'], rname: value[i]['b']));
        }
      }
      for(int i=0;i<userdefinedrooms.length;i++){
        print(userdefinedrooms[i].rnumber);
        print(userdefinedrooms[i].rname);
      }

      _menuItems = List.generate(userdefinedrooms.length, (i) => DropdownMenuItem(
          value: userdefinedrooms[i].rnumber,
          child: Text("${userdefinedrooms[i].rname}-${userdefinedrooms[i].rnumber.toString()}"
          )
      )
      );
      setState(() {
        _menuItems=_menuItems;
      });
    }
    );
  }
  getdevices()async{

    print("$roomnumber,$hname,$hnum");

    userdefineddevices=[];

    int sccount = await DBProvider.db.GetSwitchCountWithRNAndHN(roomnumber, hnum,hname);
    List switchboarddata = await DBProvider.db.getSwitchBoardDateFromRNumAndHNum(roomnumber.toString(), hnum, hname);
    print(switchboarddata);

    userdefineddevices.add(DeleteDevice(dnumber: 0, dname: "Select Device"));
    if (sccount != 0) {
      for (int cp = 0; cp < sccount; cp++) {
          String devicename = switchboarddata[cp]['ec'];
          int deviceno = switchboarddata[cp]['d'];
          userdefineddevices.add(DeleteDevice(dnumber: deviceno, dname:devicename));
      }
    }
    List masdata = [];
    masdata = await DBProvider.db.DataFromMTRNumAndHNum(roomnumber, hnum, hname);
    print(masdata);
    int masterc = masdata.length;
    if (masterc != 0) {
      for (int cp = 0; cp < masterc; cp++) {

        String devicename = masdata[cp]['ec'];
        int deviceno = masdata[cp]['d'];
        userdefineddevices.add(DeleteDevice(dnumber: deviceno, dname:devicename));
      }
    }

    for(int i=0;i<userdefineddevices.length;i++){
      print(userdefineddevices[i].dnumber);
      print(userdefineddevices[i].dname);
    }

    _devicemenuItems = List.generate(userdefineddevices.length, (i) => DropdownMenuItem(
        value: userdefineddevices[i].dnumber,
        child: Text("${userdefineddevices[i].dname}-${userdefineddevices[i].dnumber.toString()}"
        )
    )
    );
    setState(() {
      _devicemenuItems=_devicemenuItems;
    });
  }

  Future<List> functiongetlist() async {
    rooms = rooms;
    return rooms;
  }

  @override
  Widget build(BuildContext context) =>FocusDetector(

    onFocusGained: () {

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

    },

    onFocusLost: () {

      FNC.DartNotificationCenter.unregisterChannel(channel: "networkconn");
      FNC.DartNotificationCenter.unregisterChannel(channel: "socketconn");

    },
    child: WillPopScope(onWillPop: ()async{
        return Navigator.canPop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(66, 130, 208, 1),
          title: Text("Delete Device"),
          actions: <Widget>[

            IconButton(
              icon: Image.asset('images/$imgs.png', fit: BoxFit.cover),
              onPressed: () {
                s.checkindevice(hname, hnum);
              },
            ),

            IconButton(
              icon: Image.asset(
                  'images/$imgn.png',
                  fit: BoxFit.cover),
              onPressed: () {},
            ),

          ],
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:<Widget> [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex:3,
                      child: Text("Room Name"),
                    ),
                    Expanded(
                        flex:7,
                        child: DropdownButton<int>(
                            hint: Text('Select Room'),
                            items: _menuItems,
                            value: _value,
                            onChanged: (value) async {
                              print("value is $value");

                              setState(() {
                                _value= value ;
                                roomnumber=value;
                                _value1 = 0 ;
                                },
                              );
                              await getdevices();
                            }
                        )

                      // child: DropdownButton(
                      //   hint: Text('Select Room'),
                      //   value: dropdownValue,
                      //   icon: const Icon(Icons.keyboard_arrow_down),
                      //   onChanged: (newValue) {
                      //
                      //     value = Roomname.indexOf(newValue);
                      //     print("value is $value");
                      //     setState(() {
                      //       dropdownValue = newValue;
                      //     });
                      //   },
                      //
                      //   items:Roomname.map((String rooms){
                      //     return DropdownMenuItem(
                      //       child: new Text(rooms),
                      //       value: rooms,
                      //     );
                      //   }).toList(),
                      // )
                    ),

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex:3,
                      child: Text("Device Name"),
                    ),
                    Expanded(
                        flex:7,
                        child: DropdownButton<int>(
                            hint: Text('Select Device'),
                            items: _devicemenuItems,
                            value: _value1,
                            onChanged: (value){
                              print("value is $value");
                              getdevices();
                              setState(() {
                                _value1= value ;
                                devicenumber=value;
                              },
                              );
                            }
                        )

                      // child: DropdownButton(
                      //   hint: Text('Select Room'),
                      //   value: dropdownValue,
                      //   icon: const Icon(Icons.keyboard_arrow_down),
                      //   onChanged: (newValue) {
                      //
                      //     value = Roomname.indexOf(newValue);
                      //     print("value is $value");
                      //     setState(() {
                      //       dropdownValue = newValue;
                      //     });
                      //   },
                      //
                      //   items:Roomname.map((String rooms){
                      //     return DropdownMenuItem(
                      //       child: new Text(rooms),
                      //       value: rooms,
                      //     );
                      //   }).toList(),
                      // )
                    ),

                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      padding: EdgeInsets.all(8.0),
                      textColor: Colors.white,
                      // splashColor: Colors.greenAccent,
                      elevation: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('images/Moods/save_button.png'),
                              fit: BoxFit.cover),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(" Delete Device "),
                        ),
                      ),
                      // ),
                      onPressed: () {

                        print("Device number to Delete is $devicenumber");
                        print(devicenumber.toString().length);

                        if(devicenumber.toString().length==0){
                            print("Please select the room to be deletedzero");
                            fluttertoast("Select Device");
                        }
                        else if(devicenumber.toString() == "null"){
                            print("Please select the room to be deleted-null");
                            fluttertoast("Select Device");
                        }
                        else if(devicenumber.toString()=="0"){
                            print("Please select the room to be deleted-zero");
                            fluttertoast("Select Device");
                        }
                        else{
                          showAlertDialogdeleteDevice(context);
                        }
                      },

                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    )
  );



  showAlertDialogdeleteDevice(BuildContext context){


    // Create button
    Widget yesButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        print(devicenumber);

        if(s.socketconnected == true){
          String send = "<"+devicenumber.toString()+"*";
          s.socket1(send);

        }
        else{
          fluttertoast("Socket Not Connected");
          print("socket not connected");
        }

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
      content: Text("Do you want to Delete the Device Selected"),
      actions: [
        yesButton,
        noButton
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



}


