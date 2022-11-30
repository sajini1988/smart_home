//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/Singleton.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:smart_home/HouseSettings/OperatorSettings/deleteRoomModelClass.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RoomNameEditPage extends StatefulWidget {

  RoomNameEditPage({Key key, this.title}) :super(key: key);
  final String title;

  @override
  _RoomNameEditPageState createState() => _RoomNameEditPageState();
}

class _RoomNameEditPageState extends State<RoomNameEditPage>{

  var s=Singleton();
  GlobalService _globalService = GlobalService();
  String hname,hnum;
  DBHelper dbHelper;

  Future<List>rooms;
  List<DeleteRoom>userdefinedrooms;
  List<DropdownMenuItem<int>> _menuItems;
  int _value=0;
  int roomnumber=0;

  String imgs = "disconnected";
  String imgn= "nonet";
  String options1="No_net";

  var roomnameController = TextEditingController();

  GlobalKey<FormState> _key1 = new GlobalKey();
 // bool _autoValidate1 = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FNC.DartNotificationCenter.unregisterChannel(channel: "networkconn");
    FNC.DartNotificationCenter.unregisterChannel(channel: "socketconn");

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
    },observer: null,
    );

    hname=_globalService.hname;
    hnum=_globalService.hnum;
    getrooms();

    nwimage(s.networkconnected);
    swimage(s.socketconnected);

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

  getrooms()async{

    rooms=DBProvider.db.comlist();
    functiongetlist().then((List value) {
      userdefinedrooms=[];
      if(value.length>0){
        userdefinedrooms.add(DeleteRoom(rnumber: 0, rname: "Select Room"));
        for (int i = 0; i < value.length; i++) {
          userdefinedrooms.add(DeleteRoom(rnumber: value[i]['a'], rname: value[i]['b']));
        }
      }
      for(int i=0;i<userdefinedrooms.length;i++){
        print(userdefinedrooms[i].rnumber);
        print(userdefinedrooms[i].rname);
      }

      _value=userdefinedrooms[0].rnumber;


      _menuItems = List.generate(userdefinedrooms.length, (i) => DropdownMenuItem(
          value: userdefinedrooms[i].rnumber,
          child: Text("${userdefinedrooms[i].rname}"
          )
      )
      );
      setState(() {
        _menuItems=_menuItems;
      });
    });

  }

  Future<List> functiongetlist() async {
    rooms = rooms;
    return rooms;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: ()async{
      return Navigator.canPop(context);
    },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Delete Room"),
            backgroundColor: Color.fromRGBO(66, 130, 208, 1),
            actions: <Widget>[

              IconButton(
                icon: Image.asset(
                    'images/$imgs.png',
                    fit: BoxFit.cover),
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
          ), backgroundColor: Colors.white,
          body: Center(
            child:Form(
              key: _key1,
              autovalidateMode: AutovalidateMode.disabled,
              child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        //Padding(padding: const EdgeInsets.all(20.0),),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  flex:3,
                                  child: Text("Room Name")
                              ),
                              Expanded
                                (
                                  flex:7,
                                  child: DropdownButton<int>(
                                      hint: Text('Select Room'),
                                      items: _menuItems,
                                      value: _value,
                                      onChanged: (value){
                                        print("value is $value");
                                        setState(() {
                                          _value= value ;
                                          roomnumber=value;
                                        },
                                        );
                                      }
                                  )
                              ),
                            ]
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  flex:3,
                                  child: Text("Enter New Name")
                              ),
                              Expanded(
                                  flex: 7,
                                  child: TextFormField(

                                    enabled: true,
                                    controller: roomnameController,
                                    validator:_validateRoomname,
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                      // counterText: '',
                                      // enabledBorder: OutlineInputBorder(
                                      //   borderSide: const BorderSide(width: 1, color: Colors.black),
                                      //   borderRadius: BorderRadius.all(Radius.circular(15)),
                                      //
                                      // ),
                                      // focusedBorder: OutlineInputBorder(
                                      //   borderSide: const BorderSide(width: 1, color: Colors.red),
                                      //   borderRadius: BorderRadius.circular(15),
                                      // ),
                                      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                      labelText: 'Enter Room Name',
                                    ),
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z_]")),],
                                  )
                              ),
                            ]
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
                                  child: Text(" Edit RoomName "),
                                ),
                              ),
                              // ),
                              onPressed: () {

                                if(_key1.currentState.validate()) {
                                  _key1.currentState.save();
                                  print("Room number to Delete is $roomnumber");
                                  print(roomnumber.toString().length);

                                  if (roomnumber.toString().length == 0) {
                                    print("Please select the room to be deletedzero");
                                    fluttertoast("Please Select Room");
                                  }
                                  else if (roomnumber.toString() == "null") {
                                    print("Please select the room to be deleted-null");
                                    fluttertoast("Please Select Room");
                                  }
                                  else if (roomnumber.toString() == "0") {
                                    print("Please select the room to be Edited");
                                    fluttertoast("Please Select Room");
                                  }
                                  else {

                                    print("no $roomnumber");

                                    String roomname= roomnameController.text;
                                    print(roomname);

                                    showAlertDialogUpdateSuccess(context);

                                    DBProvider.db.updateSwitchBoardTableRName(hname, hnum, roomnumber.toString(), roomname);
                                    DBProvider.db.updateMasterTableRName(hname, hnum, roomnumber.toString(), roomname);
                                  }
                                }
                                },
                            ),
                          ],
                        ),
                      ]
                  )
              )
            ))
      ),
    );
  }

  showAlertDialogUpdateSuccess(BuildContext context) {

    // Create button
    Widget yesButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.of(context,rootNavigator: true).pop();

        _value=0;
        roomnumber=0;
        getrooms();

      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("Updated"),
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

  String _validateRoomname(String value) {

    RegExp roomExp = new RegExp("[0-9a-zA-Z_]");

    if (value.length == 0) {
      return 'Please Enter Roomname';
    }
    else if( roomExp.hasMatch(value))
    {
      return null;
    }
    else{
      return null;
    }
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


