//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/Singleton.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:smart_home/HouseSettings/OperatorSettings/deleteRoomModelClass.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focus_detector/focus_detector.dart';

class DeleteRoomPage extends StatefulWidget {

  DeleteRoomPage({Key key, this.title}) :super(key: key);
  final String title;

  @override
  _DeleteRoomPageState createState() => _DeleteRoomPageState();
}

class _DeleteRoomPageState extends State<DeleteRoomPage>{

  var s=Singleton();
  GlobalService _globalService = GlobalService();
  String hname,hnum;
  DBHelper dbHelper;

  Future<List>rooms;
  List<DeleteRoom>userdefinedrooms;
  List<DropdownMenuItem<int>> _menuItems;
  int _value=0;
  int roomnumber=0;

  String s4a,s5a,s6a,finala;
  String imgs = "disconnected";
  String imgn= "nonet";
  String options1="No_net";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FNC.DartNotificationCenter.unregisterChannel(channel: 'DeleteRoom');
    FNC.DartNotificationCenter.registerChannel(channel: 'DeleteRoom');
    FNC.DartNotificationCenter.subscribe(channel: 'DeleteRoom', onNotification: (options) {
      print('DeleteRoom: $options');
      deleteRoomResponce(options);
    },observer: null);

    hname=_globalService.hname;
    hnum=_globalService.hnum;
    getrooms();

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

  deleteRoomResponce(options){

    switch (options[4]) {
      case 'X':
        {
          s4a="Room not exists in Wired DB";
          break;
        }

      case 'F':
        {
          s4a="Delete Room failed in Wired DB";
          break;
        }

      case 'S':
        {
          s4a="Successfully Deleted Room in Wired DB";
          DBProvider.db.deleteSW(roomnumber);
          DBProvider.db.deleteMas(roomnumber);
          break;
        }
      default:
        break;
    }

    switch (options[5]) {
      case 'X':
        {
          s5a="Room not exists in Wireless DB";
          break;
        }

      case 'F':
        {
          s5a="Delete Room failed in Wireless DB";
          break;
        }

      case 'S':
        {
          s5a="Successfully Deleted Room in Wireless DB";
          DBProvider.db.deleteSW(roomnumber);
          DBProvider.db.deleteMas(roomnumber);
          break;
        }
      default:
        break;
    }

    switch (options[6]) {
      case 'X':
        {
          s6a="Room not exists in Timer DB";
          break;
        }

      case 'F':
        {
          s6a="Delete Room failed in Wireless DB";
          break;
        }

      case 'S':
        {
          s6a="Successfully Deleted Room in TimerDB";
          DBProvider.db.deleteSW(roomnumber);
          DBProvider.db.deleteMas(roomnumber);
          break;
        }
      default:
        break;
    }

    finala = s4a+"."+s5a+"."+s6a+".";
    print(finala);

    showAlertDialogdeleteRoomSuccess(context);
  }

  showAlertDialogdeleteRoomSuccess(BuildContext context) {

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


      _menuItems = List.generate(userdefinedrooms.length, (i) => DropdownMenuItem(
          value: userdefinedrooms[i].rnumber,
          child: Text("${userdefinedrooms[i].rname}-${userdefinedrooms[i].rnumber.toString()}"
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

  showAlertDialogdeleteRoom(BuildContext context) {

    // Create button
    Widget yesButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        print(roomnumber);

        if(s.socketconnected == true){
          String send = "<"+roomnumber.toString()+"_";
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
      content: Text("Do you want to Delete the Room Selected"),
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

  @override
  Widget build(BuildContext context) =>FocusDetector(

    onFocusLost: () {

      FNC.DartNotificationCenter.unregisterChannel(channel: "networkconn");
      FNC.DartNotificationCenter.unregisterChannel(channel: "socketconn");

    },
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

    }, child: WillPopScope(onWillPop: ()async{
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
                            // Expanded(
                            //   flex: 1, child: Container()
                            // ),
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
                                child: Text(" Delete Room "),
                              ),
                            ),
                            // ),
                            onPressed: () {
                              print("Room number to Delete is $roomnumber");
                              print(roomnumber.toString().length);

                              if(roomnumber.toString().length==0){
                                print("Please select the room to be deletedzero");
                                fluttertoast("Please Select Room");
                              }
                              else if(roomnumber.toString() == "null"){
                                print("Please select the room to be deleted-null");
                                fluttertoast("Please Select Room");
                              }
                              if(roomnumber.toString()=="0"){

                                print("Please select the room to be deleted-zero");
                                fluttertoast("Please Select Room");
                              }
                              else{
                                showAlertDialogdeleteRoom(context);
                              }
                              },
                          ),
                        ],
                      ),
                    ]
                  )
              )
          )
      ),
    )
  );


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


