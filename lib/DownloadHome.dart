import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/LDatabaseModelClass.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:smart_home/homepage.dart';
import 'package:smart_home/main.dart';
import 'package:encrypt/encrypt.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Downloadhome extends StatefulWidget {
  Downloadhome({Key key, todo,}) : super(key: key);

  @override
  _Downloadhome createState() => _Downloadhome();
}
class _Downloadhome extends State<Downloadhome> {

  String errorText = '';
  IconData errorIcon;
  double errorContainerHeight = 0.0;
  //final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _key = new GlobalKey();
 // bool _autoValidate = false;
  var hName;
  DBHelper dbHelper;
  Future<List<Student>> students;
  String ok="false";


  bool socketconnect= false;
  int maxsize;
  int roomv = 0;
  int ddcou,dc;
  BytesBuilder builder = new BytesBuilder(copy: false);
  Socket socket;
  String serverip,serverport;
  int sp, serverportaddress;
  String path, serC1;

  String hname;

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController download = TextEditingController();

  FocusNode _focus1 = new FocusNode();
  FocusNode _focus2 = new FocusNode();
  FocusNode _focus3 = new FocusNode();

  Timer timer;

  void _onFocusChange(){
    SystemChrome.setEnabledSystemUIMode
      (SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);// hide status + action buttons
  }

  @override
  void initState() {

    // TODO: implement initState
    super.initState();

    _focus1.addListener(_onFocusChange);
    _focus2.addListener(_onFocusChange);
    _focus3.addListener(_onFocusChange);

    print("Remote and local $ip_port");

    cleartext();
    dbHelper = DBHelper();
    refreshStudentList();
    print(students);

    //Remote and local 192.168.0.105:9951

  }

  refreshStudentList() {
    setState(() {
      students = dbHelper.getStudents();
    });
  }

  @override
  Future<void> dispose() async {

    nameController.dispose();
    passwordController.dispose();
    download.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        // return Navigator.of(context).push(
        //   MaterialPageRoute(builder: (context) => MyStatefulWidget()),
        // );
        return Navigator.canPop(context);
      },
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Color.fromRGBO(66, 130, 208, 1),
              title: Text("Download Home")
          ),

          body: Form(
            key: _key,
            autovalidateMode: AutovalidateMode.disabled,
            child: Padding(
                padding: EdgeInsets.all(50),
                child: ListView(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        focusNode: _focus1,
                        maxLength: 10,
                        validator: _validateUserName,
                        controller: nameController,
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),

                          ),
                          labelText: 'Enter User Name',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        focusNode: _focus2,
                        maxLength: 8,
                        validator: _validatePwd,
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: 'Enter Password',
                        ),

                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        focusNode: _focus3,
                        maxLength: 25,
                        validator: _validateDownloadhome,
                        controller: download,
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: 'Enter House Name',
                        ),

                      ),
                    ),

                    Container(
                        height: 50,
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Wrap(
                          alignment: WrapAlignment.spaceAround,
                          children: [

                            ElevatedButton(
                                child: Text('Clear', style: TextStyle(color: Colors.white),),
                                  style: ElevatedButton.styleFrom(
                                  onPrimary: Colors.white,
                                  primary: Color.fromRGBO(66, 130, 208, 1),
                                  onSurface: Colors.grey,
                                  // side: BorderSide(color: Colors.black, width: 1),
                                  // elevation: 20,
                                  // minimumSize: Size(150,50),
                                  // shadowColor: Colors.teal,
                                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                ),
                                onPressed: () {
                                  cleartext();
                                }
                            ),

                            ElevatedButton(
                                child: Text('Download', style: TextStyle(
                                    color: Colors.white),),
                                style: ElevatedButton.styleFrom(
                                  onPrimary: Colors.white,
                                  primary: Color.fromRGBO(66, 130, 208, 1),
                                  onSurface: Colors.grey,
                                ),
                                onPressed: () async {

                                  print("enter download");

                                  int idx = ip_port.indexOf(":");
                                  // List parts = [ip.substring(0,idx).trim(), ip.substring(idx+1).trim()];
                                  // print(parts);

                                  //server Ip and Port Adress
                                  serverip = ip_port.substring(0,idx).trim();
                                  serverport = ip_port.substring(idx+1).trim();
                                  serverportaddress = int.parse(serverport);

                                  print(serverport);
                                  print(serverportaddress);

                                  dc = await dbHelper.getCounthname(download.text);
                                  print(dc);

                                  if (_key.currentState.validate()) {
                                    _key.currentState.save();

                                    String p1 = nameController.text;
                                    String p2 = passwordController.text;
                                    print(p1 + p2);

                                    //socket1(nameController.text passwordController.text);
                                    //socket1('superadmin12345678');

                                    socket1(p1 + p2);
                                    showAlertDialog(context);
                                    Timer(Duration(seconds: 5), () {


                                      if(ok=="*OK#"){
                                        print("enter here");
                                        socket1('\$118&');
                                      }

                                    });
                                  }
                                  else{

                                  //  showAlertDialogerror_text(context);

                                  }
                                }


                            ),

                          ],

                        )),
                  ],
                )),
          )),
    );
  }


  showAlertDialog(BuildContext context)  {
    AlertDialog alert=AlertDialog(
      title: Text("Downloading WiredDataBase From Server"),
      content:
      new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
              child: SizedBox(width:  MediaQuery.of(context).size.width - 50,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  width: 300,
                  height: 20,
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child:LinearProgressIndicator()

                  ),
                ),
              )
          ),
          //),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );

    timer = Timer(Duration(seconds: 10), () {
      showAlertDialogerr(this.context);
    });

  }


  String _validateUserName(String value) {
    if (value.length == 0) {
      return 'Please Enter UserName';
    } else if (value.length < 10) {
      return 'UserName must be of 10 Characters!';
    }
    else  if( !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'Special Characters are not allowed';
    }
    else {
      return null;
    }
  }

  String _validatePwd(String value) {
    if (value.length == 0) {
      print("Please Enter Password");
      return 'Please Enter Password';
    } else if (value.length < 8) {
      return 'Password must be of 8 Characters!';
    }
    else  if( !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value))
    {
      return 'Special Characters are not allowed';
    }
    else {
      return null;
    }
  }

  String _validateDownloadhome(String value) {

    print(ddcou);
    print("count11");

    print("validateDownloadhome");
    print(value);
    if (value.length == 0) {

      return 'Please Enter HouseName';
    } else if (value.length > 25) {

      return 'download home should not be more than 25 charactors';
      // ignore: unrelated_type_equality_checks
    } else  if( !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value))
    {
      return 'Special Characters are not allowed';
    }

    else if(dc == 0){

      print(dc);
      return null;
      //return null;
    }
    else if(dc != 0){

      return 'House Name already Exists.Try Another Name';
    }
    else{
      return null;
    }

  }

  socket1(String S)async{

    print("sock $socketconnect");
    try {
      if (socketconnect == false) {
        print("ip: $serverip");
        print(socket);
        socket = await Socket.connect(serverip, serverportaddress);
        print(socket);
      }
      else if (socketconnect == true) {
        print("socket alraddy establishd");
      }

      final key = Key1.fromUtf8('edisonbrosmartha');
      final iv = IV.fromUtf8('AAAAAAAAAAAAAAAA');
      print("key: $key");
      print("iv: $iv");

      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      final encrypted = encrypter.encrypt(S, iv: iv);
      socket.add(encrypted.bytes);

      final decrypt = encrypter.decrypt(encrypted, iv: iv);
      print(decrypt);

      try{
        //socket.listen((data1)
        socket.asBroadcastStream().listen((data1) async {
          String decrypt;
          print(data1);

          int len = data1.lengthInBytes;
          print("len:$len");

          int bytes = builder.length;

          if (len <= 48) {
            String serverResponse = String.fromCharCodes(data1);
            print("Server Response: " + serverResponse);
            print(data1);
            Uint8List bytes = Uint8List.fromList(data1);
            print(base64.encode(bytes));
            decrypt = encrypter.decrypt64(base64.encode(bytes), iv: iv);
            print("decrypt:$decrypt");



            if (decrypt.startsWith('\$') && decrypt.endsWith('&')) {
              String strl = decrypt.substring(1, (decrypt.length) - 1);
              maxsize = int.parse(strl);
              print("maxsize:$maxsize");
              Fluttertoast.showToast(
                  msg: decrypt,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
            else if (decrypt.contains("*OK#")) {
              socketconnect = true;
              ok="*OK#";
            }
            else if (decrypt.contains('*ERRUSER#')) {
              ok="false";
              socket.destroy();
              socketconnect=false;
              Navigator.of(this.context,rootNavigator: true).pop();

              //close();
              showAlertDialogerrusr(this.context);
            }
          }
          else {
            builder.add(data1);
            bytes = builder.length;
            print("bytes :$bytes");
            print("max_size: $maxsize");


            if (maxsize.bitLength == 0) {
              print("try downloading again");
            }
            else {
              if (bytes >= maxsize) {
                print(download.text);

                Uint8List dt = builder.toBytes();

                Directory documentsDirectory = await getApplicationDocumentsDirectory();
                path = join(documentsDirectory.path, download.text + ".db");
                print("Path: $path");

                ByteData data = dt.buffer.asByteData(
                    0, dt.buffer.lengthInBytes);
                final buffer = data.buffer;
                File(path).writeAsBytes(
                    buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

                socket.destroy();
                close();

                DBProvider.db.close();
                DBProvider.dbname = download.text;
                callingmethoad();
              }
            }
          }
        },
          // handle errors
          onError: (error) {
            socket.destroy();
            close();
            print("error: $error");
            Navigator.of(this.context,rootNavigator: true).pop();
            showAlertDialogerr(this.context);
          },
          // handle server ending connection
          onDone: () {
           // socketconnect = true;
            print("close");
          },

        );
      }
      on TimeoutException catch (e) {
        Navigator.of(this.context,rootNavigator: true).pop();
        socketconnect=false;
        showAlertDialogerr(this.context);
        print('Timeout Error: $e');
      } on SocketException catch (e) {
        Navigator.of(this.context,rootNavigator: true).pop();
        socketconnect=false;
        showAlertDialogerr(this.context);
        print('Socket Error: $e');
      } on Error catch (e) {
       // Navigator.of(this.context,rootNavigator: true).pop();
       // socketconnect=false;
      //  showAlertDialogerr(this.context);
        print('General Error: $e');
      }
    }

    on TimeoutException catch (e) {
      Navigator.of(this.context,rootNavigator: true).pop();
      showAlertDialogerr(this.context);
      print('Timeout Errorconnect: $e');
    } on SocketException catch (e) {
      Navigator.of(this.context,rootNavigator: true).pop();
      showAlertDialogerr(this.context);
      print('Socket Errorconnect: $e');
    } on Error catch (e) {
      Navigator.of(this.context,rootNavigator: true).pop();
      showAlertDialogerr(this.context);
      print('General Errorconnect: $e');
    }

  }

  close(){
    socketconnect=false;
  }

  Future<void> callingmethoad() async {

    try {

      DBProvider.db.newClient();
      DBProvider.db.newClient1();
      DBProvider.db.newClient2();
      DBProvider.db.newClient3();

      roomv++;
      int sCo = await dbHelper.getNumCountLocal();
      print("CountLocal_in_calling_method: $sCo");
      sCo++;
      print("Increment_the_sCo : $sCo++ ");
      serC1 = "";
      serC1 = "$sCo";

      print(download.text);
      print(serC1);

      DBProvider.db.update(download.text, serC1);
      DBProvider.db.updatemt(download.text, serC1);
      DBProvider.db.updatest(download.text, serC1);
      DBProvider.db.updatesd(download.text, serC1);

      List ut = await DBProvider.db.getServerDetailsDataWithHNumUType(download.text, nameController.text);
      if(ut.length==0){
        Navigator.of(this.context,rootNavigator: true).pop();
        timer.cancel();
        showAlertDialogerr(this.context);
      }
      else{

        print(ut[0]['da']);
        String uType = ut[0]['da'];

        dbHelper.add(Student(name: download.text,
            lb: serC1,
            lc: serverip,
            ld: nameController.text,
            le: passwordController.text,
            lf: "Auto",
            lg: uType,
            lh: "No",
            li: serverport));
        refreshStudentList();
        hname=download.text;
        cleartext();
        Navigator.of(this.context,rootNavigator: true).pop();
        timer.cancel();
        showAlertDialog1(this.context);

      }

    }

    on TimeoutException catch (e) {
      Navigator.of(this.context,rootNavigator: true).pop();
      showAlertDialogerr(this.context);
      print('Timeout dbupdateError : $e');
    } on SocketException catch (e) {
      Navigator.of(this.context,rootNavigator: true).pop();
      showAlertDialogerr(this.context);
      print('Socket dbupdateError: $e');
    } on Error catch (e) {
      Navigator.of(this.context,rootNavigator: true).pop();
      showAlertDialogerr(this.context);
      print('General dbupdateError: $e');
    }

  }

  showAlertDialog1(BuildContext context1) {

    AlertDialog alert = AlertDialog(
      title: Text("Download Completed"),
      content: Text("Wired Setting Downloaded Successfully. Do you want to operate Devices?? "),
      actions: <Widget>[
        TextButton(
          onPressed: () {

            // Navigator.of(context1).pop();
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else if (Platform.isIOS) {
              exit(0);
            }
          },
          child: Text("Exit"),
        ),


        TextButton(
          onPressed: () {

            Navigator.pop(context1);
            Navigator.pushAndRemoveUntil(
                context1,
                MaterialPageRoute(builder: (BuildContext context) => MyApp(name: hname, lb: serC1)),
                    (Route<dynamic> route) => false
            );
            // Navigator.of(context1).push(
            //     MaterialPageRoute(builder: (context) => MyApp(name: hname, lb: serC1)));

          },
          child: Text("Yes"),
        ),
      ],
    );


    // show the dialog
    showDialog(
      context: context1,
      builder: (BuildContext context1) {
        return alert;
      },
    );
  }

  showAlertDialogerrortext(BuildContext context1) {

    AlertDialog alert = AlertDialog(
      title: Text("Invalid"),
      content: Text("Invalid Username/Password/Housename. Please check and try again"),
      actions: <Widget>[

        TextButton(
          onPressed: () {

            },
          child: Text("OK"),
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context1,
      builder: (BuildContext context1) {
        return alert;
      },
    );
  }


  showAlertDialogerrusr(BuildContext context1) {

    AlertDialog alert = AlertDialog(
      title: Text("Error User"),
      content: Text("Invalid Username/Password.Please try with proper credentials"),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            // Navigator.of(context1).pop();
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else if (Platform.isIOS) {
              exit(0);
            }
          },
          child: Text("Exit"),
        ),

        TextButton(
          onPressed: () {
            Navigator.pop(context1);

          },
          child: Text("Yes"),
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context1,
      builder: (BuildContext context1) {
        return alert;
      },
    );
  }

  showAlertDialogerr(BuildContext context1) {

    AlertDialog alert = AlertDialog(
      title: Text("Hello!"),
      content: Text("House not downloaded successfully.Do you want to go back and try downloading Again"),
      actions: <Widget>[
        TextButton(
          onPressed: () {

            Navigator.pop(this.context);
            Navigator.pop(this.context);
            //Navigator.canPop(this.context);
           // Navigator.of(this.context,rootNavigator: true).pop();
            // Navigator.of(context1).pop();
            // if (Platform.isAndroid) {
            //   SystemNavigator.pop();
            // } else if (Platform.isIOS) {
            //   exit(0);
            // }
          },
          child: Text("Exit"),
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context1,
      builder: (BuildContext context1) {
        return alert;
      },
    );
  }

  void cleartext() {

    nameController.clear();
    passwordController.clear();
    download.clear();
    download.clear();
  }


}


