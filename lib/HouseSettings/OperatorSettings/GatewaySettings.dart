import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/Singleton.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:focus_detector/focus_detector.dart';

class GatewaySettingsPage extends StatefulWidget {

  GatewaySettingsPage({Key key, this.title}) :super(key: key);
  final String title;

  @override
  _GatewaySettingsPageState createState() => _GatewaySettingsPageState();
}

class _GatewaySettingsPageState extends State<GatewaySettingsPage>{

  GlobalService _globalService = GlobalService();
  String hname,hnum;
  DateTime _chosenDateTime=DateTime.now();

  String dropdownValue1="00";
  String dropdownValue2="00";
  bool visible=false;
  String datetime="yyyy-mm-dd hh:mm:ss";
  String date = "Select Date";
  var s = Singleton();

  var ssidController = TextEditingController();
  var versionnumberController =  TextEditingController();
  var ebCodeController = TextEditingController();

  String imgs = "disconnected";
  String imgn= "nonet";
  String options1="No_net";

  @override
  void initState(){
    super.initState();

    hname=_globalService.hname;
    hnum=_globalService.hnum;

    print(_chosenDateTime);
    List lis = _chosenDateTime.toString().split(" ");
    String set = lis[0];
     setState(() {
      date=set;
    });

    FNC.DartNotificationCenter.unregisterChannel(channel: "get_time");
    FNC.DartNotificationCenter.unregisterChannel(channel: "get_ssid");
    FNC.DartNotificationCenter.unregisterChannel(channel: "get_version");
    FNC.DartNotificationCenter.unregisterChannel(channel: "get_ebcode");

    FNC.DartNotificationCenter.registerChannel(channel: 'get_time');
    FNC.DartNotificationCenter.registerChannel(channel: 'get_ssid');
    FNC.DartNotificationCenter.registerChannel(channel: 'get_version');
    FNC.DartNotificationCenter.registerChannel(channel: 'get_ebcode');

    FNC.DartNotificationCenter.subscribe(channel: 'get_time', onNotification: (options) {
        gettime(options);
      }, observer: null,
    );
    FNC.DartNotificationCenter.subscribe(channel: 'get_ssid', onNotification: (options) {
      getssid(options);
      },observer: null,
    );
    FNC.DartNotificationCenter.subscribe(channel: 'get_version', onNotification: (options) {
          getversion(options);
        }, observer: null,
    );

    FNC.DartNotificationCenter.subscribe(channel: 'get_ebcode', onNotification: (options) {
        getebcode(options);
      }, observer: null,
    );

    send();



  }

  send() async {
    String data = "150";
    String send = "{"+data+'?';
    if(s.socketconnected == true){
      s.socket1(send);
    }
    else{
      s.checkindevice(hname, hnum);
    }
    await Future.delayed(const Duration(milliseconds: 500));
    String data1 = "151";
    String datasend1 = "{"+data1+'#';
    if(s.socketconnected==true){
      s.socket1(datasend1);
    }
    else {

    }
    await Future.delayed(const Duration(milliseconds: 500));

    String data2 = "153";
    String send2 = '{'+data2+'%';
    if(s.socketconnected == true){
      s.socket1(send2);
    }
    else{

    }

    await Future.delayed(const Duration(milliseconds: 500));

    String data3 = "154";
    String send3 = '{'+data3+'!';
    if(s.socketconnected == true){
      s.socket1(send3);
    }
    else{

    }
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

  gettime(String data){
    print(data);
    String change = data.replaceAll('_', ':');
    print(change);
    setState(() {
      datetime=change;
    });
  }

  getssid(String data){
      print(data);
      setState(() {
        ssidController.text=data;
      });
  }

  getversion(String data){
      print(data);
      setState(() {
        versionnumberController.text=data;
      });
  }

  getebcode(String data){
      print(data);
      setState(() {
        ebCodeController.text=data;
      });
  }

  @override
  Widget build(BuildContext context) => FocusDetector(

    onFocusLost: (){

      FNC.DartNotificationCenter.unregisterChannel(channel: "networkconn");
      FNC.DartNotificationCenter.unregisterChannel(channel: "socketconn");

    },
    onFocusGained: (){

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
      child: WillPopScope(onWillPop: () async {
        return Navigator.canPop(context);
        },
        child:Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(66, 130, 208, 1),
            title: Text("Gateway Settings"),
            actions: <Widget>[
              IconButton(
                icon: Image.asset(
                    'images/$imgs.png',
                    fit: BoxFit.fill),
                onPressed: () {
                  s.checkindevice(hname, hnum);
                },
              ),

              IconButton(
                icon: Image.asset(
                    'images/$imgn.png',
                    fit: BoxFit.fill),
                onPressed: () {},
              ),
            ],
          ),
          backgroundColor: Colors.white,
           body: Center(child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[

                  Expanded(
                    flex:1,
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Expanded(
                          flex:5,
                          child:Container()
                        ),

                        Expanded(
                          flex:5,
                          child:Transform.scale(
                            scale: 1,
                            child: IconButton(
                                icon: Image.asset("images/GatewaySettings/reboot_gateway.png"),
                                splashRadius: 0.1,
                                splashColor:Colors.transparent ,
                                onPressed: () {
                                  String data = "152";
                                  String datasend = "{"+data+'\$';
                                  if(s.socketconnected==true){
                                    s.socket1(datasend);
                                  }
                                }
                            ),
                          ),
                        ),
                      ],
                    )
                  ),
                  Expanded(
                      flex:1,
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                        Expanded(
                          flex:3,
                          child:MaterialButton(
                              padding: EdgeInsets.all(8.0),
                              textColor: Colors.white,
                              // splashColor: Colors.greenAccent,
                              elevation: 8.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('images/GatewaySettings/set.png'),
                                      fit: BoxFit.cover),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("Referesh"),
                                ),
                              ),
                              onPressed: () {
                                  print('Tapped');

                                  String data = "150";
                                  String send = "{"+data+'?';
                                  if(s.socketconnected == true){
                                    s.socket1(send);
                                  }
                                  else{

                                  }
                                },
                            ),
                          ),

                          Expanded(
                            flex: 4,
                              child: Container(
                                child: Padding(padding: const EdgeInsets.all(8.0),
                                  child: Text(datetime),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.black ,
                                      width: 1.0 ,
                                    ),
                                      borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              // child: TextField(
                              //   enabled: false,
                              //   controller: datetimeController,
                              //   keyboardType: TextInputType.multiline,
                              //   maxLines: 2,
                              //   enableInteractiveSelection: false,
                              //   decoration:InputDecoration(
                              //     // counterText: '',
                              //     enabledBorder: OutlineInputBorder(
                              //       borderSide: const BorderSide(width: 1, color: Colors.black),
                              //       borderRadius: BorderRadius.all(Radius.circular(15)),
                              //     ),
                              //
                              //     contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                              //     labelText: 'yyyy-mm-dd '
                              //         'hh:mm:ss',
                              //     hintText: 'yyyy-mm-dd '
                              //         'hh:mm:ss',
                              //     hintMaxLines: 2
                              //   ),
                              // )
                          ),
                          Expanded(
                            flex:3,
                              child:Transform.scale(
                                scale: 1.5,
                                child: IconButton(
                                    icon: Image.asset("images/GatewaySettings/edit.png"),
                                    splashRadius: 0.1,
                                    splashColor:Colors.transparent ,
                                    onPressed: () {

                                      if(visible==true){
                                        visible=false;
                                      }
                                      else if(visible==false){
                                        visible=true;
                                      }
                                      setState(() {
                                        visible=visible;
                                      });
                                    }
                                ),
                              ),
                          ),
                        ],
                      )
                  ),
                  Visibility(
                    visible: visible,
                      child: Expanded(
                        flex:1,
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [

                          // Expanded(
                          //   flex:2,
                          //   child:MaterialButton(
                          //     padding: EdgeInsets.all(8.0),
                          //     textColor: Colors.white,
                          //     // splashColor: Colors.greenAccent,
                          //     elevation: 8.0,
                          //     child: Container(
                          //       decoration: BoxDecoration(
                          //         image: DecorationImage(
                          //             image: AssetImage('images/GatewaySettings/set.png'),
                          //             fit: BoxFit.cover),
                          //       ),
                          //       child: Padding(
                          //         padding: const EdgeInsets.all(5.0),
                          //         child: Text("Select Date"),
                          //       ),
                          //     ),
                          //     onPressed: () {
                          //         print('Tapped');
                          //       },
                          //   ),
                          // ),

                          Expanded(
                            flex: 3,
                            child:GestureDetector(
                              onTap: (){
                                  print("tapped");
                                  _showDatePicker(context);
                                  },
                              child:Container(
                                child: Padding(padding: const EdgeInsets.all(8.0),
                                  child: Center(child: Text(date)),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.black ,
                                    width: 1.0 ,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),
                          Padding(padding: const EdgeInsets.all(3.0)),
                          Expanded(
                            flex:1,
                            child: Text("Time"),
                          ),
                          Expanded(
                            flex:1,
                            child: buildDropDown1(),
                          ),

                          Expanded(
                            flex:1,
                            child: Text("Hrs"),
                          ),
                          Expanded(
                            flex:1,

                            child: buildDropDown2(),
                          ),
                          Expanded(
                            flex:1,
                            child: Text("Min"),
                          ),
                        ],
                      )
                    )
                  ),
                  Visibility(
                    visible: visible,
                    child: Expanded(
                      flex:1,
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex:7,
                            child: Container(),
                          ),
                          Expanded(
                            flex:3,
                            child:MaterialButton(
                              padding: EdgeInsets.all(8.0),
                              textColor: Colors.white,
                              // splashColor: Colors.greenAccent,
                              elevation: 8.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('images/GatewaySettings/set.png'),
                                      fit: BoxFit.fill),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("SET"),
                                ),
                              ),
                              onPressed: () {
                                print('Tapped');

                                String data = date+" "+dropdownValue1+":"+dropdownValue2+":"+"00";
                                String datasend = "{"+data+"^";
                                  if(s.socketconnected == true){
                                    s.socket1(datasend);
                                  }

                                  else{

                                  }
                                },
                            ),
                          ),
                        ],
                      )
                  ),),
                  Expanded(
                      flex:1,
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          Expanded(
                            child:MaterialButton(
                              padding: EdgeInsets.all(8.0),
                              textColor: Colors.white,
                              // splashColor: Colors.greenAccent,
                              elevation: 8.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('images/GatewaySettings/set.png'),
                                      fit: BoxFit.fill),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("Get SSID"),
                                ),
                              ),
                              onPressed: () {

                                print('Tapped');
                                String data = "151";
                                String datasend = "{"+data+'#';
                                if(s.socketconnected==true){
                                  s.socket1(datasend);
                                }
                                else {

                                  }

                                },
                            ),
                          ),

                          Expanded(
                              child: TextField(
                                enabled: true,
                                controller: ssidController,
                                decoration:InputDecoration(
                                  // counterText: '',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(width: 1, color: Colors.black),
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                  ),

                                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                  labelText: 'SSID',
                                ),
                              )
                          ),
                          Expanded(
                            child:MaterialButton(
                              padding: EdgeInsets.all(8.0),
                              textColor: Colors.white,
                              // splashColor: Colors.greenAccent,
                              elevation: 8.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('images/GatewaySettings/set.png'),
                                      fit: BoxFit.fill),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("Set SSID"),
                                ),
                              ),
                              onPressed: () {

                                print('Tapped');

                                if(ssidController.text.length == 0){
                                  print("Invalid. Enter text over there");
                                }
                                else{

                                  String data = ssidController.text;
                                  String datatosend = '{'+data+'*';
                                  if(s.socketconnected == true){
                                    s.socket1(datatosend);
                                  }
                                  else{

                                  }

                                }

                              },

                            ),
                          ),

                        ],
                      )
                  ),

                  Expanded(
                      flex:1,
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          Expanded(
                            flex:2,
                            child: Container(),
                          ),

                          Expanded(
                            flex:4,
                              child: TextFormField(
                                enableInteractiveSelection: false,
                                enabled: false,
                                controller: versionnumberController,
                                decoration:InputDecoration(
                                  // counterText: '',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(width: 1, color: Colors.black),
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                  ),

                                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                  labelText: 'Version',
                                ),
                              )
                          ),
                          Expanded(
                            flex:4,

                            child:MaterialButton(
                              padding: EdgeInsets.all(10.0),
                              textColor: Colors.white,
                              // splashColor: Colors.greenAccent,
                              elevation: 8.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('images/GatewaySettings/set.png'),
                                      fit: BoxFit.fill),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(5.0,0.0,0.0,0.0),
                                    child:Text("Version Number")),
                                ),
                              ),
                              onPressed: () {

                                String data = "153";
                                String send = '{'+data+'%';
                                if(s.socketconnected == true){
                                  s.socket1(send);
                                }
                                else{

                                }
                                print('Tapped');

                              },

                            ),
                          ),

                        ],
                      )
                  ),

                  Expanded(

                      flex:1,
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          Expanded(
                            flex:1,
                            child: Container(),
                          ),

                          Expanded(
                            flex:6,
                              child: TextFormField(
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                                enabled: false,
                                enableInteractiveSelection: false,
                                controller: ebCodeController,
                                decoration:InputDecoration(
                                  // counterText: '',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(width: 1, color: Colors.black),
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                  ),

                                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                  labelText: 'EBCode',
                                ),
                              )
                          ),
                          Expanded(
                            flex:3,
                            child:MaterialButton(
                              padding: EdgeInsets.all(8.0),
                              textColor: Colors.white,
                              // splashColor: Colors.greenAccent,
                              elevation: 8.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('images/GatewaySettings/set.png'),
                                      fit: BoxFit.fill),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("EB Code"),
                                ),
                              ),
                              onPressed: () {

                                  print('Tapped');
                                  String data = "154";
                                  String send = '{'+data+'!';

                                  s.socket1(send);
                                },
                            ),
                          ),

                        ],
                      )
                  ),
                  Expanded(
                      flex:1,
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white,
                          ))
                        ],
                      )
                  ),
                ],
              ),
           )
        ),
        )
      )
  );


  alert(){

  }



  buildDropDown1() {

    return DropdownButton<String>(
      value: dropdownValue1,
      icon: const Icon(Icons.arrow_drop_down_rounded),
      elevation: 0
      ,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height:0,
        //color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue1 = newValue;
        });
      },
      items: <String>['00','01', '02', '03', '04', '05', '06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );

    // else { // Just Divider with zero Height xD
    //   return Divider(color: Colors.white, height: 0.0);
    // }
  }
  buildDropDown2() {

    return DropdownButton<String>(
      value: dropdownValue2,
      icon: const Icon(Icons.arrow_drop_down_sharp),
      elevation: 10,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height:2,
        //color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue2 = newValue;
        });
      },
      items: <String>['00','01', '02', '03', '04', '05', '06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49','50','51','52','53','54','55','56','57','58','59','60']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );

    // else { // Just Divider with zero Height xD
    //   return Divider(color: Colors.white, height: 0.0);
    // }
  }

  // Show the modal that contains the CupertinoDatePicker
  void _showDatePicker(ctx) {


    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) =>
            Container(
              height: 270,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  Container(
                    height: 200,
                    child: CupertinoDatePicker(
                      mode:CupertinoDatePickerMode.date,
                        initialDateTime: DateTime.now(),
                        onDateTimeChanged: (val) {
                          setState(() {
                            _chosenDateTime = val;
                            print(_chosenDateTime);
                            List lis = _chosenDateTime.toString().split(" ");
                            String set = lis[0];
                            setState(() {
                              date=set;
                            });

                          });
                        }),
                  ),

                  // Close the modal
                  CupertinoButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      // print(_chosenDateTime);
                      // List lis = _chosenDateTime.toString().split(" ");
                      // String set = lis[0];
                      // setState(() {
                      //   date=set;
                      // });
                    }
                  )
                ],
              ),
            ));
  }


}


