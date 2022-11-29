import 'package:flutter/material.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:smart_home/Singleton.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:smart_home/HouseSettings/OperatorSettings/EditUserSettings.dart';

class AddUserPage extends StatefulWidget {
  AddUserPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {

  var s=Singleton();

  Image off=Image.asset('images/PIR/radio.png');
  Image on=Image.asset('images/PIR/radio01.png');
  Image image1;
  Image image2;
  Image image3;


  GlobalService _globalService = GlobalService();
  GlobalKey<FormState> _key1 = new GlobalKey();
  var usernamecontroller = TextEditingController();
  var passwordcontroller = TextEditingController();

  String usertype,loggedusertype;
  String hname,hnum;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    image1=off;
    image2=off;
    image3=off;

    FNC.DartNotificationCenter.unregisterChannel(channel: 'AddUserNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'AddUserNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'AddUserNotification', onNotification: (options) {
      print('ADDUSER: $options');
      addusersuccess(context);
      DBProvider.db.adduserdetailstouser(usernamecontroller.text, usertype);
      DBProvider.db.addserverdetailsuser(passwordcontroller.text, usernamecontroller.text, usertype);

    },observer: null);

    FNC.DartNotificationCenter.unregisterChannel(channel: 'AddAdminNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'AddAdminNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'AddAdminNotification', onNotification: (options) {

      addadminsuccess(context);
      DBProvider.db.adduserdetailstouser(usernamecontroller.text, usertype);
      DBProvider.db.addserverdetailsuser(passwordcontroller.text, usernamecontroller.text, usertype);

      },observer: null);

    FNC.DartNotificationCenter.unregisterChannel(channel: 'AddGuestNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'AddGuestNotificationn');
    FNC.DartNotificationCenter.subscribe(channel: 'AddGuestNotification', onNotification: (options) {
      print('ADDGUEST: $options');
      addguestsuccess(context);
      DBProvider.db.adduserdetailstouser(usernamecontroller.text, usertype);
      DBProvider.db.addserverdetailsuser(passwordcontroller.text, usernamecontroller.text, usertype);

    }, observer: null);

    FNC.DartNotificationCenter.unregisterChannel(channel: 'FailAddUserNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'FailAddUserNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'FailAddUserNotification', onNotification: (options) {
      print('FAILEDUSERADDED: $options');

      addusererror(context);
      DBProvider.db.adduserdetailstouser(usernamecontroller.text, usertype);
      DBProvider.db.addserverdetailsuser(passwordcontroller.text, usernamecontroller.text, usertype);

    },observer: null);

    hname=_globalService.hname;
    hnum=_globalService.hnum;
    call();
  }
  call()async{

    DBHelper dbHelper;
    dbHelper = DBHelper();
    List res = await dbHelper.getStudents1(hname, hnum);
    print(res);

    loggedusertype=res[0]['lg'];
    print(loggedusertype);

  }

  addguestsuccess(BuildContext context1){

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("Guest Added Successfully"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Edituser(username: usernamecontroller.text)));
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
  addusersuccess(BuildContext context1){

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("User Added Successfully"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Edituser(username: usernamecontroller.text)));
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

  addadminsuccess(BuildContext context1){

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("Admin Added Successfully"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
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
  addusererror(BuildContext context1){

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("Failed to add user"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset : false,
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.center,

          child:Container(
            color: Colors.transparent,
            child:Form(
              key:_key1,
              autovalidateMode: AutovalidateMode.disabled,
              child: ListView(
                shrinkWrap: true,
                children:<Widget> [

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    Expanded(
                        flex:10,
                        child:Container(
                          color: Colors.white,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child:
                                    Text(
                                      'ADD USER',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.normal
                                      ),
                                      maxLines: 2,

                                    ),
                                  ),
                                ]
                            )
                        ),
                    )
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
                            child:Padding(padding: const EdgeInsets.all(5.0),),
                          )

                      ),
                    ],
                  ),

                  Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    Expanded(
                      flex:10,
                      child:Container(
                        color:Colors.white,
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Expanded(
                                flex:3 ,
                                //child: Text('User Name'),
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child:
                                  Text('User Name',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    textScaleFactor: 1.10,
                                    // style: TextStyle(fontWeight:FontWeight.w600 ),
                                    maxLines: 2,
                                  ),
                                )
                            ),
                            Padding(padding: const EdgeInsets.all(5.0),),
                            Expanded(
                                flex: 7,
                                child: TextFormField(
                                  // autofocus: true,
                                  // focusNode: focusNode,
                                  enabled: true,
                                  maxLength: 10,
                                  controller: usernamecontroller,
                                  validator: _validateUserName,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 1, color: Colors.black),
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 1, color: Colors.red),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                    labelText: 'UserName',
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex:10,
                        child: Container(
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [

                              Expanded(
                                  flex:3 ,
                                  //child: Text('Password'),
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child:

                                    Text('Password',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      textScaleFactor: 1.10,
                                      // style: TextStyle(fontWeight:FontWeight.w600 ),
                                      maxLines: 1,
                                    ),
                                  )
                              ),
                              Padding(padding: const EdgeInsets.all(5.0),),
                              Expanded(
                                  flex: 7,
                                  child: TextFormField(
                                    //autofocus: true,
                                    //  focusNode: focusNode,
                                    enabled: true,
                                    maxLength: 8,
                                    controller: passwordcontroller,
                                    validator: _validatePwd,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(width: 1, color: Colors.black),
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(width: 1, color: Colors.red),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                      labelText: ' Password ',
                                    ),
                                  )
                              )

                            ],
                          ),
                        ),
                      ),
                    ]
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    Expanded(
                        flex:10,
                        child:Container(
                          color: Colors.white,
                          child:Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                Expanded(
                                  child:Transform.scale(scale: 1.80,
                                    child: IconButton(
                                      icon: image1,
                                      splashRadius: 0.1,
                                      splashColor:Colors.transparent ,
                                      onPressed: () {

                                        print(loggedusertype);
                                        if(loggedusertype=="A"){
                                          print("Access Denied");
                                          fluttertoast("Access Denied. Only SuperAdmin can add Admin");
                                        }
                                        else {
                                          usertype="A";
                                          image1=on;
                                          image2=off;
                                          image3=off;
                                        }

                                        setState(() {
                                          image1=image1;
                                          image2=image2;
                                          image3=image3;
                                        });

                                      },
                                    ),
                                  ),

                                  flex: 1,
                                ),
                                Expanded(
                                  flex:2 ,
                                  child: Text('Admin',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    textScaleFactor: 1.10,
                                    style: TextStyle(fontWeight:FontWeight.w600 ),
                                    maxLines: 1,
                                  ),
                                ),
                                Expanded(
                                  child:Transform.scale(scale: 1.80,
                                    child: IconButton(
                                      icon: image2,
                                      splashRadius: 0.1,
                                      splashColor:Colors.transparent,
                                      onPressed: () {

                                        usertype="U";
                                        image1=off;
                                        image2=on;
                                        image3=off;

                                        setState(() {
                                          image1=image1;
                                          image2=image2;
                                          image3=image3;
                                        });

                                      },
                                    ),
                                  ),
                                  flex: 1,
                                ),
                                Expanded(
                                  flex:2 ,
                                  child: Text('User',
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    textScaleFactor: 1.10,
                                    style: TextStyle(fontWeight:FontWeight.w600),
                                    maxLines: 1,),
                                ),
                                Expanded(
                                  child:Transform.scale(
                                    scale: 1.80,
                                    child: IconButton(
                                      icon: image3,
                                      splashRadius: 0.1,
                                      splashColor:Colors.transparent,
                                      onPressed: () {
                                        usertype="G";
                                        image1=off;
                                        image2=off;
                                        image3=on;

                                        setState(() {
                                          image1=image1;
                                          image2=image2;
                                          image3=image3;
                                        });
                                      },
                                    ),
                                  ),
                                  flex: 1,
                                ),
                                Expanded(
                                  flex:2 ,
                                  child: Text('Guest',
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    textScaleFactor: 1.10,
                                    style: TextStyle(fontWeight:FontWeight.w600 ),
                                    maxLines: 1,
                                  ),
                                ),

                              ]

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

                                mainAxisAlignment: MainAxisAlignment.spaceEvenly
                                ,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children:[

                                  MaterialButton(
                                    padding: EdgeInsets.all(8.0),
                                    textColor: Colors.white,
                                    // splashColor: Colors.greenAccent,
                                    elevation: 8.0,
                                    child: Container(
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

                                      Navigator.pop(context);
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
                                        if(usertype.length==0){
                                          if(loggedusertype=="A"){
                                            fluttertoast("Select USER or GUEST");
                                          }
                                          else if(loggedusertype == "SA"){
                                            fluttertoast("Select ADMIN or USER or GUEST");
                                          }
                                        }
                                        else{

                                          _key1.currentState.save();
                                          String data = "<"+usernamecontroller.text+passwordcontroller.text+usertype+"@";

                                          if(s.socketconnected == true){
                                            s.socket1(data);
                                          }
                                          else{
                                            fluttertoast("Socket Not Connected");
                                          }

                                        }
                                      }
                                      else{

                                      }
                                    },

                                  ),
                                ]
                            ),
                          )),
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

              ],
            ),
          ),
        ),),
      ), );
  }

  String _validateUserName(String value) {
    if (value.length == 0) {
      print("Enter Username");
      return 'Enter UserName';
    } else if (value.length < 10) {

      return '10 Characters!';
    }
    else  if( !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value))
    {
      return 'Special Characters are not allowed';
    }
    else {
      return null;
    }
  }

  String _validatePwd(String value) {
    if (value.length == 0) {
      return 'Enter Password';
    } else if (value.length < 8) {
      return 'pass 8 Characters!';
    }
    else  if( !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value))
    {
      return 'remove Spcl Characters';
    }
    else {
      return null;
    }
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


