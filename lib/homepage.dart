import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:smart_home/DownloadHome.dart' show Downloadhome;
import 'package:smart_home/main.dart';
import 'package:http/http.dart' as http;
import 'package:smart_home/GlobalService.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum AddHome {LOCAL, REMOTE , URL, IP }
Datagram dg;
String ip;
String ip_port, remoteip_port;

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  String lc;
  Timer timer;
  Timer newtimer;
  BuildContext cirdialogContext;
  BuildContext serverfodialogContext;
  BuildContext servernfodialogContext;
  int tag=0;

  AddHome _site = AddHome.LOCAL;
  // AddHome _site1 = AddHome.REMOTE;
  // AddHome _site2 = AddHome.IP;
  // AddHome _site3 = AddHome.URL;

  var _isVisibleuserid = false;
  var _isVisibleurl = false;
  var _isVisibleip = false;
  var _isVisibleport = false;
  var editbtn = false;
  var connectbtn= false;
  var urlv = false;
  var ipv= false;

  //bool _showCricle=false;

  TextEditingController use_idcontroller = TextEditingController();
  TextEditingController urlcontroller = TextEditingController();
  TextEditingController ipcontroller = TextEditingController();
  TextEditingController portcontroller = TextEditingController();

  GlobalService _globalService = GlobalService();

  String hname,hnum;


  @override
  void initState() {
    super.initState();
    hname = _globalService.hname;
    hnum = _globalService.hnum;

  }
  @override
  Widget build(BuildContext context) {

    urlcontroller.text = "https://edisonbro.in/automation/remoteip.php?q=";
    return WillPopScope(
      onWillPop: () async {
        // return Navigator.of(context).push(
        //   MaterialPageRoute(builder: (context) => MyApp(name: hname,lb: hnum)),
        // );
        return Navigator.canPop(context);
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Download Home")),
        body:ListView(
          children:[
            Column(
                children: <Widget>[
                Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('LOCAL'),
                      leading: Radio(
                        value: AddHome.LOCAL,
                        groupValue: _site,
                        onChanged: (AddHome value) {
                          setState(() {
                          _site = value;
                          urlv=false;
                          ipv=false;
                          connectbtn=false;
                          _isVisibleip=false;
                          _isVisibleport=false;
                          _isVisibleuserid=false;
                          _isVisibleurl=false;
                          editbtn=false;

                          });
                        },
                      ) ,
                      onTap: ()async
                      {
                        showDialog(
                            context: context,
                            barrierDismissible:false ,
                            builder: (BuildContext context) {
                              return Center(child: CircularProgressIndicator(),);
                            }
                          );

                        //buildShowDialog(context);
                        lc="false";
                        ip=await udp();
                        if(ip.contains('getip')){

                          ip=await udp();
                            // lc='false';
                            //timer.cancel();
                            //timer = Timer.periodic(Duration(milliseconds: 2), (timer) async{
                            // await udp();
                            // });
                          }
                          if(ip.startsWith("*")){

                            lc="true";
                            //timer.cancel();
                            //newtimer.cancel();
                            int idx = ip.indexOf(":");
                            //List iplist = [ip.substring(0,idx).trim(), ip.substring(idx+1).trim()];
                            String port = ip.substring(idx+1).trim();
                            int idx1 = port.indexOf(";");
                            //List portlist = [port.substring(0,idx1).trim(), port.substring(idx1+1).trim()];
                            String sip = ip.substring(1,idx).trim();
                            print(sip);

                            String sport = port.substring(0,idx1).trim();
                            print(sport);

                            ip_port=sip+':'+sport;

                            if(sip!=null){

                              Navigator.of(context,rootNavigator: true).pop();

                             // Navigator.pop(context);

                              Timer(Duration(milliseconds: 500), () async {
                                final ConfirmAction action = await _asyncConfirmDialog(context);
                                print(action);
                              });

                            }
                            else {

                              print("Please check your Wi-Fi Connection OR IF Server is ON");

                              Navigator.of(context,rootNavigator: true).pop();
                              Timer(Duration(milliseconds: 500), () async {
                                final ConfirmAction1 action = await _asyncConfirmDialog1(context);
                                print(action);
                              });
                              // Navigator.pop(context);

                            }
                          }
                          else{

                            print("Please check your Wifi Connection in Setting and Server is ON");

                            //showAlertDialog(context);
                            // Navigator.pop(context);

                            Navigator.of(context,rootNavigator: true).pop();
                            Timer(Duration(milliseconds: 500), () async {
                              final ConfirmAction1 action = await _asyncConfirmDialog1(context);
                              print(action);
                            });
                          }
                     },
                    ),
                  ),
                ],
              ),

              Row(
              children: [
                Expanded(
                child: ListTile(
                  title: const Text('REMOTE'),
                  leading: Radio(
                    value: AddHome.REMOTE,
                    groupValue: _site,
                    onChanged: (AddHome value) {
                      setState(() {

                        _site = value;
                        urlv=true;
                        ipv=true;
                        connectbtn=false;
                        _isVisibleurl=false;
                        _isVisibleuserid=false;
                        _isVisibleip=false;
                        _isVisibleport=false;
                        editbtn=false;

                      });
                    },
                  ),
                  onTap:() {

                    setState(() {
                      _site = AddHome.REMOTE;
                      urlv=true;
                      ipv=true;
                      connectbtn=false;
                      _isVisibleurl=false;
                      _isVisibleuserid=false;
                      _isVisibleip=false;
                      _isVisibleport=false;

                      });
                    },
                ),
                ),
              ],
            ),


              Visibility(
              visible: urlv,
                child: Padding(
                  padding: const EdgeInsets.only(left:20.0),
                  child:Row(
                    children: [

                      Expanded(
                      child: ListTile(
                        title: const Text('URL'),
                        leading: Radio(
                          value: AddHome.URL,
                          groupValue: _site,
                          onChanged: (AddHome value) {
                          setState(() {
                            tag=0;

                            _site = value;
                            editbtn = true;
                            _isVisibleuserid=true;
                            _isVisibleip = false;
                            _isVisibleport = false;
                            connectbtn=true;
                          });
                        },
                      ),
                        onTap:(){

                          setState(() {
                            tag=0;

                            _site = AddHome.URL;
                            editbtn = true;
                            _isVisibleuserid=true;
                            _isVisibleip = false;
                            _isVisibleport = false;
                            connectbtn=true;
                          });

                          } ,
                      ),
                      ),
                  ],
                ),
                ),
              ),
              Padding(

              padding: const EdgeInsets.only(left: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible:editbtn,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side:BorderSide(color:Colors.black38,width: 2.0)))),
                        child:Text('EDIT URL',style:TextStyle(color:Colors.black,fontWeight: FontWeight.w300,),),
                        onPressed: (){
                          setState(() {
                            _isVisibleurl=true;
                          });
                        },
                      ),
                  ),
                ],
              ),
              ),
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                visible: _isVisibleurl,
                  child: Expanded(
                    child: Padding(padding: EdgeInsets.only(left:10.0),
                      child:TextFormField(
                        controller: urlcontroller,
                        // initialValue: "https://edisonbro.in/automation/remoteip.php?q=",
                        decoration: InputDecoration(labelText: 'URL'),
                      ),

                    )
                )
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              Visibility(
                visible: _isVisibleuserid,
                child: Expanded(
                  child: Padding(padding: EdgeInsets.only(left:10.0),
                    child: TextField(
                          controller: use_idcontroller,
                          decoration: InputDecoration(labelText: 'USER_ID'),
                        )
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: ipv,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: const Text('IP'),
                          leading: Radio(
                            value: AddHome.IP,
                            groupValue: _site,
                            onChanged: (AddHome value) {
                              setState(() {

                                tag=1;
                                _site = value;
                                _isVisibleip = true;
                                _isVisibleport = true;

                                _isVisibleuserid = false;
                                _isVisibleurl = false;
                                editbtn = false;
                                connectbtn=true;
                              });
                            },
                          ),
                          onTap: (){

                            setState(() {

                              tag=1;
                              _site = AddHome.IP;
                              _isVisibleip = true;
                              _isVisibleport = true;

                              _isVisibleuserid = false;
                              _isVisibleurl = false;
                              editbtn = false;
                              connectbtn=true;
                            });


                          },
                        ),
                      ),
                    ],
                  ),


                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Visibility(
                        visible: _isVisibleip,
                        child: Expanded(
                        child: Padding(padding: EdgeInsets.only(left: 10.0),
                          child: TextField(
                            controller: ipcontroller,
                            decoration: InputDecoration(labelText: 'IP'),
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    Visibility(
                      visible: _isVisibleport,
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: TextField(
                              controller: portcontroller,
                              decoration: InputDecoration(labelText: 'PORT'),
                          ),
                        ),
                       ),
                    ),
                  ],
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Visibility(
                    visible: connectbtn,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          //backgroundColor: MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.black38, width: 2.0)))),
                      child: Text('Connect',style: TextStyle(fontSize: 20.0),),
                      onPressed: () {
                          print("Iam url: ${urlcontroller.text}");
                          print("Iam user id: ${use_idcontroller.text}");
                          String get = urlcontroller.text+use_idcontroller.text;
                          print("i am concatinated: $get");
                          print("Iam ip_text: ${ipcontroller.text}");
                          print("Iam port_text: ${portcontroller.text}");
                          if(tag==0) {

                            if (use_idcontroller.text.isNotEmpty) {
                              print("user_id is filled:");
                              showDialog(
                                  context: context,
                                  barrierDismissible:false ,
                                  builder: (BuildContext context) {
                                    return Center(child: CircularProgressIndicator(),);
                                  });


                              RemoteConnection();
                              Timer(Duration(seconds: 3), () {

                                Navigator.of(context,rootNavigator: true).pop();
                                print("Yeah, this line is printed after 3 seconds");
                                if (remoteip_port != null) {


                                 Timer(Duration(milliseconds: 100),(){
                                   Navigator.of(context).push(
                                       MaterialPageRoute(builder: (context) =>
                                           Downloadhome(todo: remoteip_port)));
                                   print(
                                       "I am Remote IP:PORT going to download home page $remoteip_port");
                                 });

                                }
                                else {

                                  Timer(Duration(milliseconds: 100),(){
                                    buildShowEDialog(context);
                                  });

                                }
                              });
                            }
                            else {
                              buildShowEUIDDialog(context);
                            }
                          }
                          else if(tag==1) {
                            if (ipcontroller.text.isNotEmpty &&
                                portcontroller.text.isNotEmpty) {
                              //ManualRemoteConnection();
                              //buildShowRDialog(context);
                              String MIP = ipcontroller.text;
                              String MPORT = portcontroller.text;
                              ip_port = MIP + ':' + MPORT;
                              print("manual ip: port is: $ip_port");

                              Navigator.of(context).push(

                                  MaterialPageRoute(builder: (context) =>
                                      Downloadhome(todo: ip_port)));
                              print(
                                  "I am Manual  IP:PORT going to download home page $ip_port");
                            }
                            else {
                              buildShowEIP_PDialog(context);
                            }
                          }
                    },
                    ),
                  ),
                ),
              ],
          ),
        ],),
            ),

        );

  }
  RemoteConnection()async{

    String get = urlcontroller.text+use_idcontroller.text;
    var url = get;
    var urls = Uri.parse(url);
    int timeout = 5;
    try {
      http.Response response = await http.get(urls).timeout(
          Duration(seconds: timeout));
      print('Response statuscode: ${response.statusCode}');
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {

        List data = json.decode(utf8.decode(response.bodyBytes));

        String IP = (data[0]['IP']);
        String Port = (data[0]['PORT']);

        remoteip_port = IP+':'+Port;
        print("iam Remote ip:port $remoteip_port");
        ip_port = remoteip_port;
        print("rrip: $ip_port");
      }
      else{
        print("Error while downloading");

      }
    }
    on TimeoutException catch (e){
      print('Timeout Error: $e');

    }
    on SocketException catch (e) {
      print('Socket Error: $e');

    } on Error catch (e) {

      print('General Error: $e');
    }
  }

  void ManualRemoteConnection() {
    String MIP = ipcontroller.text;
    String MPORT = portcontroller.text;
    ip_port = MIP+':'+MPORT;
    print("manual ip: port is: $ip_port");
  }

  progressIos() {

    print("enter indicator");
    return Container(

        color: Colors.grey[300],
        width: 70.0,
        height: 70.0,
        child: new Padding(padding: const EdgeInsets.all(5.0),child: new Center(child: new CircularProgressIndicator())));

  }


  // buildShowDialog(BuildContext context) {
  //   return showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return Center(
  //             child:Visibility(
  //               visible: _showCricle,
  //               child: new Row(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 new CircularProgressIndicator(),
  //               //new Text("Loading"),
  //             ],
  //           ),
  //         ));
  //       });
  // }



  buildShowEIP_PDialog(BuildContext context) {
    return showDialog<ConfirmAction1>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: const Text(
              'Please Enter valid IP & PORT details'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                },
            )
          ],
        );
      },
    );


  }

  buildShowEDialog(BuildContext context) {

    return showDialog<ConfirmAction1>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: const Text(
              'Could not connect to server.Try again later or check URL and USERID'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
               // Navigator.pop(context);

              },
            )
          ],
        );
      },
    );

  }

  buildShowEUIDDialog(BuildContext context) {
    return showDialog<ConfirmAction1>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Info'),
          content: const Text(
              'Please enter valid USER_ID Details'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {

                Navigator.pop(context);

              },
            )
          ],
        );
      },
    );

  }
}
enum ConfirmAction { Cancel, Accept}
Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Server Found'),
        content: const Text(
            'Server Found Successfully, \n proceed to next step?.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Home'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MyApp()));
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Downloadhome(todo: ip_port)));
            },
          )
        ],
      );
    },
  );
}

enum ConfirmAction1 { Cancel, Accept}
Future<ConfirmAction1> _asyncConfirmDialog1(BuildContext context) async {
  return showDialog<ConfirmAction1>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Server Not Found'),
        content: const Text(
            'Please Check Your Wi-Fi Connection in Settings And Check whether Server is ON'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
                Navigator.pop(context);
              },
          )
        ],
      );
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

Future<String>udp() async{

  String ipMob="";
  for (var interface in await NetworkInterface.list()) {
    print('== Interface name: ${interface.name} ==');

      if(interface.name == "wlan0") {
        for (var addr in interface.addresses) {
          print('${addr.address} ,${addr.host} ,${addr.isLoopback}, ${addr
              .rawAddress} ,${addr.type.name}');
          ipMob = addr.address;
        }
      }
      else if(interface.name == "en0"){

        for (var addr in interface.addresses) {
          print('${addr.address} ,${addr.host} ,${addr.isLoopback}, ${addr
              .rawAddress} ,${addr.type.name}');
          ipMob = addr.address;
        }

      }
  }

  print("ip $ipMob");

  fluttertoast(ipMob);

  String ipNew;
  if(ipMob.length<=0) {
    ipNew="192.168.2.255";
    print(ipNew);
  }
  else
    {
    var arr = ipMob.split('.');
    ipNew=arr[0]+'.'+arr[1]+'.'+arr[2]+'.255';
    print(ipNew);

  }

  var dESTINATIONADDRESS=InternetAddress(ipNew);
  print(dESTINATIONADDRESS);

  ip="";

  RawDatagramSocket.bind(InternetAddress.anyIPv4, 9952).then((RawDatagramSocket udpSocket) {
    udpSocket.broadcastEnabled = true;
    udpSocket.listen((e) {
      Datagram dg = udpSocket.receive();
      if (dg != null) {
        print("udp");
        print("received ${dg.data}");

        print(utf8.decode(dg.data));
        print("server Ip22: "+utf8.decode(dg.data));
        ip= utf8.decode(dg.data);
        print(ip);
        fluttertoast(ip);
      }
      else{

        print("error in udp connection");

      }

    });

    List<int> data = utf8.encode('getip\r\n');
    udpSocket.send(data, dESTINATIONADDRESS, 9952);
    print("data sent");

  });

  await new Future.delayed(const Duration(seconds: 2));
  return ip;
}



