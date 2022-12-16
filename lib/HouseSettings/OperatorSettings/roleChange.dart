import 'package:flutter/material.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/Singleton.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:smart_home/HouseSettings/OperatorSettings/EditUserSettings.dart';

class RoleChangePage extends StatefulWidget {
  RoleChangePage({Key key, this.username, this.role}) : super(key: key);
  final String username,role;
  @override
  _RoleChangePageState createState() => _RoleChangePageState(username: username,role: role);
}
class _RoleChangePageState extends State<RoleChangePage> {

  _RoleChangePageState({this.username,this.role});
  final String username,role;
  List user = [];
  int tappedIndex=-1;
  Future<List> userdata;
  String roles="";
  String fRole="";

  String hNameR,hNumR;

  ScrollController _controller = ScrollController();
  var s = Singleton();

  GlobalService _globalService = GlobalService();

  @override
  void initState(){
    super.initState();

    hNameR=_globalService.hname;
    hNumR=_globalService.hnum;


    FNC.DartNotificationCenter.unregisterChannel(channel: 'UserAddedSuccessfully');
    FNC.DartNotificationCenter.registerChannel(channel: 'UserAddedSuccessfully');
    FNC.DartNotificationCenter.subscribe(channel: 'UserAddedSuccessfully', onNotification: (options) {

      successNotificationUR();

    },observer: null);

    FNC.DartNotificationCenter.unregisterChannel(channel: 'GuestAddedSuccessfully');
    FNC.DartNotificationCenter.registerChannel(channel: 'GuestAddedSuccessfully');
    FNC.DartNotificationCenter.subscribe(channel: 'GuestAddedSuccessfully', onNotification: (options) {

      successNotificationGR();

    },observer: null);

    FNC.DartNotificationCenter.unregisterChannel(channel: 'AdminAddedSuccessfully');
    FNC.DartNotificationCenter.registerChannel(channel: 'AdminAddedSuccessfully');
    FNC.DartNotificationCenter.subscribe(channel: 'AdminAddedSuccessfully', onNotification: (options) {

      successNotificationAR();

    }, observer: null);


    FNC.DartNotificationCenter.unregisterChannel(channel: 'User_not_present_in_ServerDetails');
    FNC.DartNotificationCenter.registerChannel(channel: 'User_not_present_in_ServerDetails');
    FNC.DartNotificationCenter.subscribe(channel:'User_not_present_in_ServerDetails', onNotification: (options) {

      failureNotificationUSD();

      }, observer: null);

    FNC.DartNotificationCenter.unregisterChannel(channel: 'User_not_present_in_UserTable');
    FNC.DartNotificationCenter.registerChannel(channel: 'User_not_present_in_UserTable');
    FNC.DartNotificationCenter.subscribe(channel: 'User_not_present_in_UserTable', onNotification: (options) {

      failureNotificationUUT();

      }, observer: null);

    FNC.DartNotificationCenter.unregisterChannel(channel: 'Error while updating to server Details');
    FNC.DartNotificationCenter.registerChannel(channel: 'Error while updating to server Details');
    FNC.DartNotificationCenter.subscribe(channel: 'Error while updating to server Details', onNotification: (options) {

      failureNotificationSD();

      }, observer: null);

    FNC.DartNotificationCenter.unregisterChannel(channel: 'Error while updating to user table');
    FNC.DartNotificationCenter.registerChannel(channel: 'Error while updating to user table');
    FNC.DartNotificationCenter.subscribe(channel: 'Error while updating to user table', onNotification: (options) {

      failureNotificationUT();

    }, observer: null);

    FNC.DartNotificationCenter.unregisterChannel(channel: 'Invalid Data Format');
    FNC.DartNotificationCenter.registerChannel(channel: 'Invalid Data Format');
    FNC.DartNotificationCenter.subscribe(channel: 'Invalid Data Format', onNotification: (options) {

      failureNotificationINVDF();

    }, observer: null);

    print(" Role $username,$role");

    if(role =="A"){
      user=["User","Guest"];
    }
    else if (role == "U"){
      user = ["Admin","Guest"];
    }
    else if(role == "G"){
      user = ["Admin","User"];
    }
    print(" Role is $role");
    data();
  }

  addSuccess(String message, BuildContext context1){

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("$message"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.of(context,rootNavigator: true).pop();
            },
          child: Text("OK"),
        ),
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );

  }

  addUserSuccess(String message, BuildContext context1){

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("$message"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.of(context,rootNavigator: true).pop();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Edituser(username: username)));
          },
          child: Text("OK"),
        ),
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );

  }

  addGuestSuccess(String message, BuildContext context1){

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("$message"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.of(context,rootNavigator: true).pop();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Edituser(username: username)));
          },
          child: Text("OK"),
        ),
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );

  }
  successNotificationUR(){
      DBProvider.db.updateServerDetailsRoleChange(username, fRole);
      addUserSuccess("Role changed of $username to User Updated Successfully", context);
  }

  successNotificationGR(){
    DBProvider.db.updateServerDetailsRoleChange(username, fRole);
    addGuestSuccess("Role changed of $username to Guest Updated Successfully", context);
  }

  successNotificationAR(){
    DBProvider.db.updateServerDetailsRoleChange(username, fRole);
    addSuccess("Role change of $username to Admin Updated Successfully", context);
  }

  failureNotificationUSD(){
    addSuccess("User is not present in ServerDetails", context);
  }

  failureNotificationUUT(){
    addSuccess("User is not present in User Table", context);
  }

  failureNotificationSD(){
    addSuccess("Error While updating the user to ServerDetails table", context);
  }

  failureNotificationUT(){
    addSuccess("Error While updating the user to User table", context);
  }

  failureNotificationINVDF(){
    addSuccess("Invalid Data format", context);
  }

  data(){
    setState((){
      userdata=getgridlist();
    });
  }

  Future<List> getgridlist() {
    return Future.delayed(Duration(seconds: 0), () {
      return user;
      // throw Exception("Custom Error");
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.center,
          child:Container(
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width/1.4,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Expanded(
                        flex:10,
                        child:Container(
                          color: Colors.white,
                          child:Padding(padding: const EdgeInsets.all(4.0),),
                        )

                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Expanded(
                        child: Container(
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              Expanded(
                                 // flex:4,
                                  child:Container(
                                    color: Colors.white,
                                    child: Center(
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            "Change role of $username",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.normal
                                            ),
                                            maxLines: 2,
                                          ),
                                        )
                                    ),
                                  )
                              ),

                            ],
                          ),
                        )
                    ),

                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Expanded(
                        flex:10,
                        child:Container(
                          color: Colors.white,
                          child:Padding(padding: const EdgeInsets.all(4.0),),
                        )

                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Expanded(
                        flex:10,
                        child:Container(
                          color: Colors.white,
                          child:Padding(padding: const EdgeInsets.all(4.0),),
                        )

                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Expanded(
                        child: Container(
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              Expanded(
                                  flex:4,
                                  child:Container(
                                    color: Colors.white,
                                    child: Center(
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            "Present role: $role",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.normal
                                            ),
                                            maxLines: 2,
                                          ),
                                        )
                                    ),
                                  )
                              ),

                            ],
                          ),
                        )
                    ),

                  ],
                ),

                Container(
                  height: 2,
                  color: Colors.black54,
                ),

                Row(

                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Expanded(
                        flex:10,
                        child:Container(
                          color: Colors.white,
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              Container(

                                width: MediaQuery.of(context).size.width*0.60,
                                  color: Colors.white,
                                  child:ConstrainedBox(

                                      constraints: BoxConstraints(
                                          maxHeight: MediaQuery.of(context).size.height*0.4),
                                      child:Scrollbar(
                                        thumbVisibility:true,
                                        thickness: 5,
                                        child:FutureBuilder<List>(
                                            future: userdata,
                                            builder: (context,snapshot){
                                              if(snapshot.hasData){

                                                return ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: snapshot.data.length,
                                                    itemBuilder: (context,index){

                                                      String user1 = snapshot.data[index];
                                                      String usertype;
                                                      if(user1 == "Admin"){
                                                        usertype="A";
                                                      }
                                                      else if(user1 == "Guest"){
                                                        usertype="G";
                                                      }
                                                      else if(user1 == "User"){
                                                        usertype="U";
                                                      }

                                                      print(usertype);
                                                      print(tappedIndex);
                                                      print(index);

                                                      return Column(
                                                          children:<Widget>[
                                                            ListTile(
                                                              tileColor:tappedIndex == index ? Colors.blue : Colors.black,
                                                              dense:true,
                                                              contentPadding: EdgeInsets.only(left: 10.0, right: 5.0,top: 0,bottom: 0),
                                                              title: Text(
                                                                user1,
                                                                style: TextStyle(

                                                                  //fontSize: 15
                                                                    color: tappedIndex == index ? Colors.blue : Colors.black
                                                                ),
                                                                textScaleFactor: 1.40,

                                                              ),
                                                              trailing:CircleAvatar(
                                                                  backgroundImage:  AssetImage('images/UGA.png'),
                                                                  maxRadius: 15,
                                                                  child: Text(usertype)),

                                                              onTap: (){
                                                                setState((){
                                                                  tappedIndex=index;
                                                                  print("index $tappedIndex");

                                                                  roles=user[index];

                                                                });
                                                              },
                                                            ),
                                                          ]
                                                      );
                                                    });
                                              }
                                              if (snapshot.data == null || snapshot.data.length == 0) {
                                                print("NoDataFound");
                                                return Text('No Data Found');
                                              }
                                              return CircularProgressIndicator();
                                            }
                                        ) ,
                                      )

                                  )
                              ),

                            ],
                          ),
                        )

                    ),
                  ],
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Expanded(
                        flex:10,
                        child:Container(
                          color: Colors.white,
                          child:Padding(padding: const EdgeInsets.all(5.0),),
                        )

                    ),
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 10,
                        child: Container(
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                              MaterialButton(
                                padding: EdgeInsets.all(8.0),
                                textColor: Colors.white,
                                // splashColor: Colors.greenAccent,
                                elevation: 8.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('images/Moods/save_button.png'),
                                        fit: BoxFit.fill),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text("CANCEL"),
                                  ),
                                ),
                                // ),
                                onPressed: () {

                                  Navigator.of(context,rootNavigator: true).pop();
                                  print('Tapped');
                                },

                              ),

                              MaterialButton(
                                padding: EdgeInsets.all(8.0),
                                textColor: Colors.white,
                                // splashColor: Colors.greenAccent,
                                elevation: 8.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('images/Moods/save_button.png'),
                                        fit: BoxFit.fill),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Center(child: Text("  CHANGE  ")),
                                  ),
                                ),
                                // ),
                                onPressed: () {

                                  if(roles==""){
                                    fluttertoast("Select Type");

                                  }
                                  else{

                                    if(roles=="Admin"){
                                      fRole="A";
                                    }
                                    else if(roles == "Guest"){
                                      fRole="G";
                                    }
                                    else if(roles == "User"){
                                      fRole="U";
                                    }

                                    String dataSend = "<"+username +":"+ role + ":"+ fRole+")";
                                    if(s.socketconnected == true){
                                      s.socket1(dataSend);
                                    }
                                    else {
                                      fluttertoast("Socket not connected");
                                    }


                                  }

                                  },),
                            ],
                          ),
                        ),
                      ),
                    ]
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Expanded(
                        flex:10,
                        child:Container(
                          color: Colors.white,
                          child:Padding(padding: const EdgeInsets.all(5.0),),
                        )

                    ),
                  ],
                ),

              ],
            ),

          ),
        ),
      ),
    );

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
