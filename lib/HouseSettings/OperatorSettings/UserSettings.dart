import 'dart:async';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home/Singleton.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:smart_home/ServerDB.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserSettings extends StatefulWidget{
  UserSettings({Key key, todo,}): super(key:key);
  @override
  _UserSettings createState() => _UserSettings();
}

class _UserSettings extends State<UserSettings>{

  List result;

  Timer timer1;
  Timer timer2;

  var s=Singleton();
  GlobalService _globalService = GlobalService();
  String hname,hnum,rnum,rname,dnum;
  String imgs = "disconnected";
  String imgn= "nonet";

  var userController = TextEditingController();
  var oldPasswController = TextEditingController();
  var newPasswController = TextEditingController();

  GlobalKey<FormState> _key = new GlobalKey();
 // bool _autoValidate = false;

  GlobalKey<FormState> _key1 = new GlobalKey();
  //bool _autoValidate1 = false;

  var newUserController = TextEditingController();
  var passwordController = TextEditingController();

  DBHelper dbHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );

    dbHelper = DBHelper();

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



    FNC.DartNotificationCenter.unregisterChannel(channel: 'SuperAdminPasswordNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'SuperAdminPasswordNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'SuperAdminPasswordNotification', onNotification: (options) {
      print('SAPassnotified: $options');
      _saAdminPassNotification();
    },observer:null);

    FNC.DartNotificationCenter.unregisterChannel(channel: 'AdminPasswordNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'AdminPasswordNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'AdminPasswordNotification', onNotification: (options) {
      print('AdminPassnotified: $options');
      adminPassNotification();
    },observer: null);

    FNC.DartNotificationCenter.unregisterChannel(channel: 'UserPasswordNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'UserPasswordNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'UserPasswordNotification', onNotification: (options) {
      print('UserPassnotified: $options');
      userPassNotification();
    },observer: null);

    FNC.DartNotificationCenter.unregisterChannel(channel: 'GuestPasswordNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'GuestPasswordNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'GuestPasswordNotification', onNotification: (options) {
      print('GuestNotified: $options');
      guestPassNotification();
    },observer: null);

    FNC.DartNotificationCenter.unregisterChannel(channel: 'FailPasswordNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'FailPasswordNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'FailPasswordNotification', onNotification: (options) {
      print('failpasswNotified: $options');
      failurePassNotification();
    },observer: null);

    hname = _globalService.hname;
    hnum = _globalService.hnum;
    rnum = _globalService.rnum;
    rname = _globalService.rname;
    dnum = _globalService.dnum;
    details();
    socketsend();
  }

  recWLSDownload(){

    Navigator.of(context,rootNavigator: true).pop();
    showAlertDialogUpdateFailure(context,"Wireless Settings updated Successfully.");

  }

  recFailure(){
    Navigator.of(context,rootNavigator: true).pop();
    showAlertDialogUpdateFailure(context,"Update Failure");

  }

  recWDownload(){

    Navigator.of(context,rootNavigator: true).pop();
    showAlertDialogUpdateStatus(context,"Wired updated Successfully. Downloading Wireless Settings");

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


  _saAdminPassNotification()async{
    print("successfully updated super admin password");

    await DBProvider.db.updateServerTableHNameWithAdminPass(result[0]['ld'],newPasswController.text,hname);
    await DBProvider.db.updateServerDetailsTablePassword(result[0]['ld'],newPasswController.text);
    await dbHelper.updatelocalTablePassword(hname,result[0]['ld'],newPasswController.text);
    showAlertDialogsuccess(context,"SuperAdmin");

  }

  adminPassNotification()async{

    print("successfully updated admin password");
    await DBProvider.db.updateServerTableHNameWithAdminPass(result[0]['ld'],newPasswController.text,hname);
    await DBProvider.db.updateServerDetailsTablePassword(result[0]['ld'],newPasswController.text);
    await dbHelper.updatelocalTablePassword(hname,result[0]['ld'],newPasswController.text);
    showAlertDialogsuccess(context,"Admin");

  }

  userPassNotification()async{

    print("successfully updated user password");
    await DBProvider.db.updateServerTableHNameWithAdminPass(result[0]['ld'],newPasswController.text,hname);
    await DBProvider.db.updateServerDetailsTablePassword(result[0]['ld'],newPasswController.text);
    await dbHelper.updatelocalTablePassword(hname,result[0]['ld'],newPasswController.text);
    showAlertDialogsuccess(context,"User");
  }

  guestPassNotification()async{
    print("successfully updated guest password");
    await DBProvider.db.updateServerTableHNameWithAdminPass(result[0]['ld'],newPasswController.text,hname);
    await DBProvider.db.updateServerDetailsTablePassword(result[0]['ld'],newPasswController.text);
    await dbHelper.updatelocalTablePassword(hname,result[0]['ld'],newPasswController.text);
    showAlertDialogsuccess(context,"Guest");

  }

  failurePassNotification(){
    print("failed in updating password");
    showAlertDialogerror(context);
  }

  details()async{
    result = await dbHelper.getLocalDateHName(hname);
    print(result);
  }
  socketsend(){

    if(s.socketconnected == true) {
      imgs="connected";
    }
    else{
      imgs="disconnected";
      s.checkindevice(hname, hnum);
    }

    if (s.networkconnected.contains("Mobile")) {
      print("Mobile");
      imgn = "3g";

    }
    else if (s.networkconnected.contains("LWi-Fi")) {
      imgn = 'local_sig';

    }
    else if (s.networkconnected.contains("RWi-Fi")) {
      imgn = 'remote01';

    }
    else if (s.networkconnected.contains("No_Net")) {
      imgn = 'nonet';

    }

    setState(() {
      imgs=imgs;
      imgn=imgn;
    });
  }

  String _validateUserName(String value) {
    if (value.length == 0) {
      print("Plz Enter Username");
      return 'Please Enter UserName';
    } else if (value.length < 10) {
      print("UserName must be of 10 Characters!");
      return 'UserName must be of 10 Characters!';
    } else {
      return null;
    }
  }

  String _validateOldPwd(String value) {
    if (value.length == 0) {
      print("Please Enter Password");
      return 'Please Enter Password';
    } else if (value.length < 8) {
      print("Password must be of 8 Characters");
      return 'Password must be of 8 Characters!';
    } else {
      return null;
    }
  }

  String _validateNewPwd(String value) {
    if (value.length == 0) {
      print("Please Enter Password");
      return 'Please Enter Password';
    } else if (value.length < 8) {
      print("Password must be of 8 Characters");
      return 'Password must be of 8 Characters!';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(onWillPop: () async {
      // return Navigator.of(context).push(
      //   MaterialPageRoute(builder: (context) => MyApp(name:hname,lb:hnum)),
      // );
      return Navigator.canPop(context);
      }, child:Scaffold(
        appBar: AppBar(
          toolbarHeight: 40.0,
          title: Text("User Settings"),
          backgroundColor: Color.fromRGBO(66, 130, 208, 1),

          actions: <Widget>[
          IconButton(
            icon: Image.asset('images/$imgs.png', fit: BoxFit.cover),
            onPressed: () {
              s.checkindevice(hname, hnum);
            },
          ),
          IconButton(
            icon: Image.asset('images/$imgn.png',
                fit: BoxFit.cover),
            onPressed: () {},
          ),

        ],),
        backgroundColor: Colors.white,
        body: Align(
        alignment: Alignment.center,
          child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment:MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width/5),),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Transform.scale(scale: 5,
                    child: IconButton(
                      splashRadius: 0.1,
                      splashColor:Colors.transparent ,
                     // iconSize: MediaQuery.of(context).size.width/75,
                      icon: Image.asset("images/usersettings/change_user_password.png"),
                      onPressed: () {
                        showDialog(
                        context: context,
                        builder: (_) {

                        return AlertDialog(
                          //scrollable: true,
                          title: Text('Change User Password'),
                          content: SizedBox(
                            width: double.maxFinite,
                            child:Padding(
                              padding:const EdgeInsets.all(0.0),
                              child:Form(
                              key:_key,
                              autovalidateMode: AutovalidateMode.disabled,
                              //autovalidate:_autoValidate,
                              child:ListView(
                                shrinkWrap: true,
                                children: [
                                  TextFormField(
                                    enabled: false,
                                    maxLength:10 ,
                                    validator: _validateUserName,
                                    controller: userController,
                                    decoration: InputDecoration(hintText: 'User Name'),
                                  ),
                                  TextFormField(
                                    enabled: false,
                                    maxLength: 8,
                                    validator: _validateOldPwd,
                                    controller: oldPasswController,
                                    decoration: InputDecoration(hintText: 'Old Password'),
                                  ),
                                  TextFormField(
                                    enabled: true,
                                    maxLength: 8,
                                    validator: _validateNewPwd,
                                    controller: newPasswController,
                                    decoration: InputDecoration(hintText: 'New Password'),
                                ),
                              ],
                            ),
                            ),
                          ),
                          ),
                          actions: [

                              TextButton(
                                onPressed: () => Navigator.of(context,rootNavigator: true).pop(),
                                child: Text('Cancel'),
                                ),
                              TextButton(
                                onPressed: () {

                                var user = userController.text;
                                var oldpassword = oldPasswController.text;
                                var newpassword = newPasswController.text;

                                if (_key.currentState.validate()) {

                                  _key.currentState.save();

                                  if(oldpassword.compareTo(newpassword)==0){
                                    showAlertDialogSamePass(context,"New Password is the same as old Password. Change New Password");
                                  }
                                  else {

                                    print("both are not equal");
                                    String changepass=user;
                                    changepass=changepass+oldpassword;
                                    changepass=changepass+newpassword;

                                    String datatosend="<"+changepass;
                                    datatosend=datatosend+"%";

                                    if(s.socketconnected == true){
                                      s.socket1(datatosend);
                                      print("data is $datatosend , $changepass");
                                      Navigator.of(context,rootNavigator: true).pop();
                                    }
                                    else{
                                      print("socket not connected");
                                      showAlertDialogsocket(context,"Socket not connected");
                                    }

                                  }
                                }
                                else{
                                  //  showAlertDialogerror_text(context);
                                  }
                                },
                                child: Text('Submit'),
                              ),
                            ],
                          );
                         },
                        );

                        setState(() {
                          userController.text=result[0]['ld'];
                          oldPasswController.text=result[0]['le'];
                        });
                      }
                    ),
                  ),

                ]
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Transform.scale(scale: 5,
                    child: IconButton(
                      splashRadius: 0.1,
                      splashColor:Colors.transparent ,
                      // iconSize: MediaQuery.of(context).size.width/75,
                      icon: Image.asset("images/usersettings/signin_another_acc.png",fit: BoxFit.scaleDown,),
                     // iconSize:MediaQuery.of(context).size.width,
                      onPressed: (){
                        String loggeduser;
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                             // scrollable: true,
                              title: Text('Change Account'),
                              content:SizedBox(
                                width: double.maxFinite,
                                child:Padding(
                                padding:const EdgeInsets.all(0.0),
                                child:Form(
                                  key:_key1,
                                  autovalidateMode: AutovalidateMode.disabled,
                                  child:ListView(
                                      shrinkWrap: true,
                                      children: [
                                        Center(child: Text("Logged User : $loggeduser")),
                                        Padding(
                                          padding: const EdgeInsets.all(05.0),
                                        ),
                                        TextFormField(
                                          enabled: true,
                                          maxLength:10 ,
                                          validator: _validateUserName,
                                          controller: newUserController,
                                          decoration: InputDecoration(hintText: 'New User'),
                                        ),
                                        TextFormField(
                                          enabled: true,
                                          maxLength: 8,
                                          validator: _validateOldPwd,
                                          controller: newPasswController,
                                          decoration: InputDecoration(hintText: 'Password'),
                                        ),
                                      ],
                                  ),
                                ),
                                )
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context,rootNavigator: true).pop(),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    var user = newUserController.text;
                                   // var newpassword = NewPasswController.text;

                                      if (_key1.currentState.validate()) {
                                        _key1.currentState.save();
                                       int seDc = await DBProvider.db.GetNumCountServerDetails();
                                       print("$seDc");

                                        if(seDc!=0){
                                          for(int p=0;p<seDc;p++){

                                            DBProvider.db.getServerDetailsDataWithHNumUName(hname,user);

                                            //print(utf8.decode(res[0]));

                                           // final key = Key1.fromUtf8('edisonbrosmartha');
                                           // final iv = IV.fromUtf8('AAAAAAAAAAAAAAAA');
                                           //
                                           // final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
                                           // final decrypt = encrypter.decrypt64(s,iv: iv);
                                           // print(decrypt);

                                         }
                                       }

                                      }
                                    }, child: Text('Submit'),
                                ),
                              ],
                            );
                            },
                        );
                        setState(() {
                          loggeduser=result[0]['ld'];
                        });

                        },
                    ),
                  ),
                ]
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Transform.scale(scale: 5,
                    child: IconButton(
                      splashRadius: 0.1,
                      splashColor:Colors.transparent ,
                      // iconSize: MediaQuery.of(context).size.width/75,
                      icon: Image.asset("images/usersettings/download_updates.png"),
                      onPressed: (){

                        print("Update House");

                        if(s.socketconnected == true){

                          showIndicator();
                          s.socket1('\$118&');
                        }
                        else{
                          fluttertoast("Connect to server");
                        }
                        },
                    ),
                  ),
                ]
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Transform.scale(scale: 5,
                    child: IconButton(
                      splashRadius: 0.1,
                      splashColor:Colors.transparent ,
                      // iconSize: MediaQuery.of(context).size.width/75,
                      icon: Image.asset("images/usersettings/delete_home.png"),
                      onPressed: (){
                          showAlertDialogdeletehome(context,"Delete Home");
                        },
                    ),
                  ),
                ]
            )
          ],
        ),
        ),
      ),

    );

  }




  showAlertDialogSamePass(BuildContext context,String message) {

    // Create button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context,rootNavigator: true).pop();

      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("$message"),
      actions: [
        okButton,
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

  showAlertDialogsocket(BuildContext context,String message) {

    print("Socket not connected");
    // Create button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context,rootNavigator: true).pop();
        Navigator.of(context,rootNavigator: true).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("$message"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        print("enter alert socket not connected");
        return alert;
      },
    );
  }
  showAlertDialogsuccess(BuildContext context,String usertype) {

    print("password changed success");
    // Create button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context,rootNavigator: true).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("$usertype Password changed successfully"),
      actions: [
        okButton,
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

  showAlertDialogerror(BuildContext context) {

    print("error while updating");
    // Create button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context,rootNavigator: true).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("Error. While updating the password"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        print("return error in password");
        return alert;
      },
    );
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
  showAlertDialogupdatehome(BuildContext context,String usertype) {
    print("password changed success");
    // Create button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("Do you want to download the updates"),
      actions: [
        okButton,
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








}
