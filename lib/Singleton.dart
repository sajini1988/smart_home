// ignore_for_file: await_only_futures

import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:flutter/foundation.dart' show TargetPlatform, debugDefaultTargetPlatformOverride, kIsWeb;
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:http/http.dart' as http;
import 'package:smart_home/LDatabase.dart';
import 'package:encrypt/encrypt.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;

import 'LDatabaseModelClass.dart';

void main() {
  print(Singleton().hashCode == Singleton().hashCode);
}
class Singleton {

  String ssidm = 'Unknown';
  final NetworkInfo _networkInfo = NetworkInfo();
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  ConnectivityResult result;
  int maxsize,maxsizet,maxsizeWl;
  String serverssid;
  DBHelper dbHelper;
  Geolocator geolocator;
  bool socketconnected=false;
  String networkconnected="No_Net";

  String adminName;
  String adminPassword;
  String serverIp;
  String serverPort;

  bool wireddb=false;
  bool timerdb=false;
  bool wirelessDb=false;

  Position position;
  
  // ignore: cancel_subscriptions
  StreamSubscription positionstream;
  Socket socket;

  BytesBuilder builder;
  BytesBuilder timerbuilder;
  BytesBuilder wrBuilder;

  String hnamef;
  String serc1;

  static final Singleton _instance = Singleton._internal();
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  factory Singleton() {
    return _instance;
  }
  Singleton._internal() {
    _enablePlatformOverrideForDesktop();
  }
  void _enablePlatformOverrideForDesktop() {
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
      debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
    }

  }

  Future<void>checkindevice(String hname, String hnum) async{

    //initNetworkInfo();
    Timer(Duration(seconds: 0
    ), () {
        checkforwificonnection(hname, hnum);
    });
  }

  Future<void> checkforwificonnection(String hname, String hnum) async {

    hnamef=hname;
    serc1=hnum;
    String hname1 = hname;
    String hnum1= hnum;
    connectivity(hname1,hnum1);

  }

  Future<void> connectivity(String hname,String hnum) async {
    print("connectivity :$hname $hnum");
    List res = await DBProvider.db.getServerDataWithHNum(hnum, hname);
    print("data $res");

    serverssid = res[0]['ss'];

    print("serverssid_$serverssid");
    print("networkssid_$ssidm");

    try {
      result = await _connectivity.checkConnectivity();
      if (result == ConnectivityResult.mobile) {
        print("Connected to mobile And remote connection function");
      } else if (result == ConnectivityResult.wifi) {
        print("connected to wifi");
      }
      else if (result == null) {
        print("Not Connected");
      }
    } on PlatformException catch (e) {
      print(e.toString());
    }
    _connectionStatus = result;
    checkconnection(hname,hnum);
  }


  void checkconnection(String hname, String hnum){

    if(_connectionStatus == ConnectivityResult.mobile){

      networkconnected = "Mobile";
      print("Remote Connection");
      remoteconnection(hnum,hname);

    }
    else if(_connectionStatus == ConnectivityResult.wifi){

      print("N$ssidm");
      print("D$serverssid");

     // print(ssidm.length);
     // print(serverssid.length);

     // print(ssidm == serverssid); // true, contain the same characters
     // print(identical(ssidm, serverssid)); // true, are the same object in memory

      if(serverssid==ssidm){

        print("Local");
        networkconnected = "LWi-Fi";
        localConnection(hnum,hname);
      }
      else if(ssidm.compareTo("NONE") == 0){

        print("Remoten");
        networkconnected = "RWi-Fi";
        remoteconnection(hnum,hname);
      }
      else {
        print("Remotes");
        networkconnected = "RWi-Fi";
        remoteconnection(hnum,hname);
      }
    }
    else{
      networkconnected = "No_Net";
    }
    networkregisterchannel();
  }
  void initNetworkInfo() async {

    bool serviceEnabled;
    LocationPermission permission;

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if(!serviceEnabled){

    }
    permission = await _geolocatorPlatform.checkPermission();
    print("permission is $permission");
    if(permission == LocationPermission.denied){

      permission = await Geolocator.requestPermission();

    }

    positionstream = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
      position = position;
     });



    // geolocator = Geolocator();
    // LocationOptions locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);
    // checkPermission();
    // positionStream = geolocator.getPositionStream(locationOptions).listen(
    //         (Position position) {
    //
    //       position = position;
    //     });
    String wifiName,
        wifiBSSID,
        wifiIPv4,
        wifiIPv6,
        wifiGatewayIP,
        wifiBroadcast,
        wifiSubmask;

    try {
      print("enter here");
      if (!kIsWeb && Platform.isIOS) {
        var status = await _networkInfo.getLocationServiceAuthorization();
        print("Status is $status");
        if (status == LocationAuthorizationStatus.notDetermined) {
          status = await _networkInfo.requestLocationServiceAuthorization();
        }
        if (status == LocationAuthorizationStatus.authorizedAlways ||
            status == LocationAuthorizationStatus.authorizedWhenInUse) {
          wifiName = await _networkInfo.getWifiName();
        } else {
          wifiName = await _networkInfo.getWifiName();
        }
      } else {
        wifiName = await _networkInfo.getWifiName();
      }
    } on PlatformException catch (e) {
      print(e.toString());
      wifiName = 'Failed to get Wifi Name';
    }
    try {
      print("enter hrere1");
      if (!kIsWeb && Platform.isIOS) {
        //var _networkInfo;
        var status = await _networkInfo.getLocationServiceAuthorization();
        print("Status is $status");
        if (status == LocationAuthorizationStatus.notDetermined) {
          status = await _networkInfo.requestLocationServiceAuthorization();
        }
        if (status == LocationAuthorizationStatus.authorizedAlways ||
            status == LocationAuthorizationStatus.authorizedWhenInUse) {
          wifiBSSID = await _networkInfo.getWifiBSSID();
        } else {
          wifiBSSID = await _networkInfo.getWifiBSSID();
        }
      } else {
        wifiBSSID = await _networkInfo.getWifiBSSID();
      }
    } on PlatformException catch (e) {
      print(e.toString());
      wifiBSSID = 'Failed to get Wifi BSSID';
    }

    try {
      print("enter here2");
      wifiIPv4 = await _networkInfo.getWifiIP();
    } on PlatformException catch (e) {
      print(e.toString());
      wifiIPv4 = 'Failed to get Wifi IPv4';
    }
    try {
      print("enter here3");
      wifiIPv6 = await _networkInfo.getWifiIPv6();
    } on PlatformException catch (e) {
      print(e.toString());
      wifiIPv6 = 'Failed to get Wifi IPv6';
    }

    try {
      print("enter here4");
      wifiSubmask = await _networkInfo.getWifiSubmask();
    } on PlatformException catch (e) {
      print(e.toString());
      wifiSubmask = 'Failed to get Wifi Submask address';
    }

    try {
      print("enter here5");
      wifiBroadcast = await _networkInfo.getWifiBroadcast();
    } on PlatformException catch (e) {
      print(e.toString());
      wifiBroadcast = 'Failed to get Wifi broadcast';
    }

    try {
      print("enter here6");
      wifiGatewayIP = await _networkInfo.getWifiGatewayIP();
    } on PlatformException catch (e) {
      print(e.toString());
      wifiGatewayIP = 'Failed to get Wifi gateway address';
    }

    try {
      print("enter here7");
      wifiSubmask = await _networkInfo.getWifiSubmask();
    } on PlatformException catch (e) {
      print(e.toString());
      wifiSubmask = 'Failed to get Wifi Submask';
    }

    // setState(() {

    ssidm = '$wifiName';
    // ignore: unnecessary_statements
    'Wifi BSSID: $wifiBSSID\n'
        'Wifi IPv4: $wifiIPv4\n'
        'Wifi IPv6: $wifiIPv6\n'
        'Wifi Broadcast: $wifiBroadcast\n'
        'Wifi Gateway: $wifiGatewayIP\n'
        'Wifi Submask: $wifiSubmask\n';
    print("SSID: $ssidm");
    ssidm=ssidm.replaceAll('"','');

  }
  Future<void> remoteconnection(String hnum, String hname) async{

    dbHelper = DBHelper();

    String hnum1=hnum;
    String hname1=hname;

    var res=[];
    res = await DBProvider.db.getServerDataWithHNum(hnum1,hname1);

    var url = res[0]['da'];
    print("url $url");

    var urls = Uri.parse(url);
    print(urls);
    int timeout = 5;

    try

    {
      print("enter try");
      http.Response response = await http.get(urls).timeout(Duration(seconds: timeout));
      print("enter response");

      print('Response statuscode: ${response.statusCode}');
      print("Response body: ${response.body}");
      try{

        if (response.statusCode == 200) {

          List data;
          try{
            data = json.decode(utf8.decode(response.bodyBytes));
          }
          on Error catch(e){
            print('General Error 220: $e');
          }

          String iP = (data[0]['IP']);
          String port =(data[0]['PORT']);
          print("IP is $iP Port is $port");

          List res = await dbHelper.getStudents1(hname,hnum);
          print(res);

          adminName = res[0]["ld"];
          adminPassword = res[0]["le"];

          serverIp = iP;
          serverPort = port;

          print("Name $adminName Pass $adminPassword ServerIp $serverIp ServerPort $serverPort");
          String sendsocket = "$adminName$adminPassword";
          socket1(sendsocket);

        }
        else {
          print('Request failed with status: ${response.statusCode}.');
          errorHttp(hnum1, hname1);
        }

      }
      on TimeoutException catch (e) {
        print('Timeout Error: $e');
        errorHttp(hnum1, hname1);
      } on SocketException catch (e) {
        print('Socket Error: $e');
        errorHttp(hnum1, hname1);
      } on Error catch (e) {
        print('General Error: $e');
      }


    } on TimeoutException catch (e) {
      print('Timeout Errorhttp: $e');
      errorHttp(hnum1, hname1);
    } on SocketException catch (e) {
      print('Socket Errorhttp: $e');
      errorHttp(hnum1, hname1);
    } on Error catch (e) {
      print('General Errorhttp: $e');
    }

  }

  void errorHttp(String hnum,hname) async{

    dbHelper = DBHelper();

    List res = await dbHelper.getStudents1(hname,hnum);
    print(res);

    var res1=[];
    res1 = await DBProvider.db.getServerDataWithHNum(hnum,hname);
    print("res1 $res1");

    adminName = res[0]["ld"];
    adminPassword = res[0]["le"];

    serverIp = res1[0]["ri"];
    serverPort = res1[0]["p"].toString();


    print("Name $adminName Pass $adminPassword ServerIp $serverIp ServerPort $serverPort");

    String sendsocket = "$adminName$adminPassword";
    socket1(sendsocket);

  }


  Future<void> localConnection(String hnum, String hname) async{

    dbHelper = DBHelper();

    List res = await dbHelper.getStudents1(hname,hnum);
    print(res);

    var res1=[];
    res1 = await DBProvider.db.getServerDataWithHNum(hnum,hname);
    print("res1 $res1");

    adminName = res[0]["ld"];
    adminPassword = res[0]["le"];

    serverIp = res1[0]["i"];
    serverPort = res1[0]["p"].toString();


    print("Name $adminName Pass $adminPassword ServerIp $serverIp ServerPort $serverPort");

    String sendsocket = "$adminName$adminPassword";
    socket1(sendsocket);

  }

  void socket1(String sendsocket)async {

    try {

      if (socketconnected == false) {
        socketregisterchannel();
         socket = await Socket.connect(serverIp, int.parse(serverPort));
        print("socket connection");
      }
      else if (socketconnected == true) {
        print("Socket Already Established");
        // socketregisterchannel();
      }
      final key = Key1.fromUtf8('edisonbrosmartha');
      final iv = IV.fromUtf8('AAAAAAAAAAAAAAAA');

      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      final encrypted = encrypter.encrypt(sendsocket, iv: iv);

      await socket.add(encrypted.bytes);


      // final decrypt = encrypter.decrypt(encrypted, iv: iv);
      // print(decrypt);

      // socket.asBroadcastStream(onListen:(subscription) {
      //   subscription.onData((data) {
      //

      //     print(data);
      //
      //              //todo something//
      //   });
      //   },
      //   onCancel: (subscription) {
      //
      //   },
      // );

      // try {
      //   socket.asBroadcastStream().listen((data1) async
      //   {
      //     String decrypt;
      //     print("data 1 is :$data1");
      //
      //     int len = data1.lengthInBytes;
      //     print("len:$len");
      //
      //
      //
      //     if (len <= 48) {
      //       String serverResponse = String.fromCharCodes(data1);
      //       print("Server Response: " + serverResponse);
      //       print(data1);
      //       Uint8List bytes = Uint8List.fromList(data1);
      //       print(base64.encode(bytes));
      //       decrypt = encrypter.decrypt64(base64.encode(bytes), iv: iv);
      //       print("decrypt:$decrypt");
      //
      //
      //       if (decrypt.startsWith('\$') && decrypt.endsWith('&')) {
      //         // flutter_toast(decrypt);
      //         String strl = decrypt.substring(1, (decrypt.length) - 1);
      //         maxsize = int.parse(strl);
      //         print("maxsizew:$maxsize");
      //         wireddb=true;
      //         builder = new BytesBuilder(copy: false);
      //       }
      //       else if(decrypt.startsWith('\$') && decrypt.endsWith('|')){
      //
      //         String strl = decrypt.substring(1, (decrypt.length) - 1);
      //         maxsizet = int.parse(strl);
      //         print("maxsizet:$maxsizet");
      //         timerdb=true;
      //
      //         timerbuilder = new BytesBuilder(copy: false);
      //         print(timerbuilder.length);
      //
      //       }
      //       else if (decrypt.startsWith('*') && decrypt.endsWith('#')) {
      //           //  flutter_toast(decrypt);
      //             String strl = decrypt.substring(1, (decrypt.length) - 1);
      //
      //             if(strl == "IACK"){
      //               print("insertion success");
      //               fluttertoast("Insertion Success");
      //             }
      //             else if(strl == "INACK"){
      //               print("insertion failure");
      //               fluttertoast("Insertion Failure");
      //             }
      //             else if(strl == "EACK"){
      //               print("insertion failure");
      //               fluttertoast("Insertion Failure");
      //             }
      //             else if(strl == "DNACK"){
      //               print("Delete Failure");
      //               fluttertoast("Delete Failure");
      //             }
      //             else if(strl == "DACK"){
      //               print("Delete Success");
      //               fluttertoast("Delete Success");
      //             }
      //             else if(strl == "UACK"){
      //               print("Update success");
      //               fluttertoast("Update Success");
      //             }
      //             else if(strl == "UNACK"){
      //               print("Update Failure");
      //               fluttertoast("Update failure");
      //             }
      //             else{
      //
      //               print(strl);
      //               fluttertoast(strl);
      //               FNC.DartNotificationCenter.post(channel: 'MasterNotification', options: strl);
      //             }
      //       }
      //       else if (decrypt=='*OK#\r\n') {
      //
      //         fluttertoast("*OK#");
      //         socketconnected = true;
      //         socketregisterchannel();
      //         socketconnectchannel();
      //       }
      //       else if (decrypt=='*ERRUSER') {
      //        // // flutter_toast(decrypt);
      //         print("socket disconnect");
      //         fluttertoast("error_user");
      //         socketconnected = false;
      //         socket.close();
      //         close("ERRUSER");
      //         socketregisterchannel();
      //         socketdisconnectchannel();
      //       }
      //
      //       else if(decrypt.startsWith('?') && decrypt.endsWith('#')){
      //
      //         String version = decrypt.substring(1, (decrypt.length) - 1);
      //
      //         FNC.DartNotificationCenter.post(
      //             channel: 'get_version', options: version);
      //
      //       }
      //       else if(decrypt.startsWith('*') && decrypt.endsWith('_')){
      //
      //         String version = decrypt.substring(1, (decrypt.length) - 1);
      //         FNC.DartNotificationCenter.post(
      //             channel: 'get_versionconnection', options: version);
      //
      //       }
      //       else if(decrypt.startsWith('(') && decrypt.endsWith(')')){
      //
      //         String time = decrypt.substring(1, (decrypt.length) - 1);
      //         FNC.DartNotificationCenter.post(
      //             channel: 'get_time', options: time);
      //
      //       }
      //       else if(decrypt.startsWith('!') && decrypt.endsWith('\$')){
      //
      //         String ssid = decrypt.substring(1, (decrypt.length) - 1);
      //         FNC.DartNotificationCenter.post(
      //             channel: 'get_ssid', options: ssid);
      //
      //       }
      //       else if(decrypt.startsWith('[') && decrypt.endsWith(']')){
      //
      //         String ebcode = decrypt.substring(1, (decrypt.length) - 1);
      //         FNC.DartNotificationCenter.post(
      //             channel: 'get_ebcode', options: ebcode);
      //
      //       }
      //       else if(decrypt.startsWith('&') || (decrypt.endsWith('&'))){
      //
      //
      //         String sva = decrypt;
      //         String room = sva.substring(0,4);
      //
      //         print("room $room");
      //
      //         if(sva==("&400U@")){
      //         // //  flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "AddUserNotification", options:sva);
      //         }
      //         else if(sva==("&400A@")){
      //         // //  flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "AddAdminNotification", options:sva);
      //         }
      //         else if(sva==("&400G@")){
      //         // //  flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "AddGuestNotification", options:sva);
      //         }
      //         else if(sva==("&004E@")){
      //          // // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "FailAddUserNotification", options:sva);
      //         }
      //         else if(sva==("&004B@")){
      //          // // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "FailAddUserNotification", options:sva);
      //         }
      //         else if(sva==("&004D@")) {
      //          // // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "FailAddUserNotification", options:sva);
      //         }
      //         else if(sva==("&110S@")){
      //          // // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "SuperAdminPasswordNotification", options:sva);
      //         }
      //         else if(sva==("&500A@")){
      //          // // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "AdminPasswordNotification", options:sva);
      //         }
      //         else if(sva==("&500U@")){
      //          // // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "UserPasswordNotification", options:sva);
      //         }
      //         else if(sva==("&500G@")){
      //          // // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "FailPasswordNotification", options:sva);
      //         }
      //         else if(sva==("&005@")){
      //           // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "FailPasswordNotification", options:sva);
      //         }
      //         else if(sva==("&800@")){
      //           // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "DeleteUserNotification", options:sva);
      //         }
      //         else if(sva==("&008@")){
      //           // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "FailDeleteNotification", options:sva);
      //         }
      //         else if(sva==("&110@")){
      //           // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "UserTimerDeleted", options:sva);
      //         }
      //         else if(sva==("&011@")){
      //           // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "UserDeletedTimernotDeleted", options:sva);
      //         }
      //         else if(sva==("&101@")){
      //           // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "UserTimernotDeleted", options:sva);
      //         }
      //         else if(sva==("&700@")){
      //           // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "SuccessUserNotification", options:sva);
      //         }
      //         else if(sva==("&007B@")){
      //           // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "FailUserNotification", options:sva);
      //         }
      //         else if(sva==("&007E@")){
      //           // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "FailUserNotification", options:sva);
      //         }
      //         else if(sva==("&007D@")){
      //           // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "FailUserNotification", options:sva);
      //         }
      //         else if(sva==("&120U@")){
      //           // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "UserAddedSuccessfully", options:sva);
      //         }
      //         else if(sva==("&120G@")){
      //           // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "GuestAddedSuccessfully", options:sva);
      //         }
      //         else if(sva==("&120A@")){
      //           // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "AdminAddedSuccessfully", options:sva);
      //         }
      //         else if(sva==("&120@")){
      //           // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "UserWithRoomsAddedSuccess", options:sva);
      //         }
      //         else if(sva==("&120B@")){
      //           // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "UserWithRoomsAddedError", options:sva);
      //         }
      //         else if(sva==("&012W@")){
      //           // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "User_not_present_in_ServerDetails", options:sva);
      //         }
      //         else if(sva==("&012WL@")){
      //           // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "User_not_present_in_UserTable", options:sva);
      //         }
      //         else if(sva==("&120W")){
      //           // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "Error while updating to server Details", options:sva);
      //         }
      //         else if(sva==("&120WL")){
      //           // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "Error while updating to user table", options:sva);
      //         }
      //         else if(sva==("&012ID@")){
      //           // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "Invalid Data Format", options:sva);
      //         }
      //         else if((sva==("&011W@")) || (sva==("&011WL@")) || (sva==("&011T@")) || (sva==("&011S@"))){
      //           // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "DeleteDevice", options:sva);
      //         }
      //         else if((room==("&010")) || (room==("&101")) ){
      //           // flutter_toast(decrypt);
      //           FNC.DartNotificationCenter.post(channel: "DeleteRoom", options:sva);
      //         }
      //
      //       }
      //     }
      //     else if(wireddb==true){
      //
      //       builder.add(data1);
      //       int wiredbytes=builder.length;
      //       if(maxsize.bitLength == 0){
      //
      //       }
      //       else{
      //
      //         if (wiredbytes == maxsize) {
      //
      //           Uint8List dt = builder.toBytes();
      //
      //           Directory documentsDirectory = await getApplicationDocumentsDirectory();
      //           String wiredpath = join(documentsDirectory.path, hnamef+ ".db");
      //           print("Pathwireless: $wiredpath");
      //
      //           ByteData data = dt.buffer.asByteData(0, dt.buffer.lengthInBytes);
      //           final buffer = data.buffer;
      //           File(wiredpath).writeAsBytes(
      //               buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
      //
      //           //socket.destroy();
      //
      //          // DBProvider.db.close();
      //           DBProvider.dbname = hnamef;
      //           //callingmethoad();
      //
      //           FNC.DartNotificationCenter.post(channel: "DownLoadW", options:"true");
      //           wireddb=false;
      //         }
      //       }
      //     }
      //     else if(timerdb==true){
      //
      //       print("timer db $timerdb");
      //       timerbuilder.add(data1);
      //       int timerbytes=timerbuilder.length;
      //       print("Timer $timerdb");
      //       print(timerbytes);
      //       print(maxsizet);
      //       if(maxsizet.bitLength == 0){
      //
      //       }
      //       else{
      //
      //         if (timerbytes == maxsizet) {
      //
      //
      //           Uint8List dt = timerbuilder.toBytes();
      //           io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
      //
      //           hnamef = hnamef.replaceAll(' ','');
      //           String timerpath = join(documentsDirectory.path, hnamef+"timer.db");
      //           print("Pathtimer: $timerpath");
      //
      //           ByteData data = dt.buffer.asByteData(0, dt.buffer.lengthInBytes);
      //           final buffer = data.buffer;
      //
      //           io.File(timerpath).writeAsBytes(
      //               buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
      //           timerdb=false;
      //
      //           print(timerdb);
      //
      //         }
      //       }
      //     }
      //   },
      //     onError: (error) {
      //
      //       socket.destroy();
      //       close("OnError");
      //       socketregisterchannel();
      //       socketdisconnectchannel();
      //
      //     },
      //     onDone: () {
      //       print("close");
      //     },
      //   );
      // }

      Stream<Uint8List> bcSteam = socket.asBroadcastStream();

      try {
        bcSteam.listen((data1) async {
          int len = data1.lengthInBytes;
          print("len:$len");

          if (len <= 48) {
            String serverResponse = String.fromCharCodes(data1);
            print("Server Response: " + serverResponse);
            print(data1);
            Uint8List bytes = Uint8List.fromList(data1);
            print(base64.encode(bytes));
            String decrypt;
            decrypt = encrypter.decrypt64(base64.encode(bytes), iv: iv);
            print("decryptnew:$decrypt");

            if (decrypt.startsWith('\$') && decrypt.endsWith('&')) {
              // flutter_toast(decrypt);
              String strl = decrypt.substring(1, (decrypt.length) - 1);
              maxsize = int.parse(strl);
              print("maxsizew:$maxsize");
              wireddb=true;
              builder = new BytesBuilder(copy: false);
            }

            else if (decrypt.startsWith('\$') && decrypt.endsWith(':')) {
              String strl = decrypt.substring(1, (decrypt.length) - 1);
              maxsizeWl = int.parse(strl);
              wirelessDb=true;
              wrBuilder=new BytesBuilder(copy: false);

            }
            else if(decrypt.startsWith('\$') && decrypt.endsWith('|')){

              String strl = decrypt.substring(1, (decrypt.length) - 1);
              maxsizet = int.parse(strl);
              print("maxsizet:$maxsizet");
              timerdb=true;

              timerbuilder = new BytesBuilder(copy: false);
              print(timerbuilder.length);

            }
            else if (decrypt.startsWith('*') && decrypt.endsWith('#')) {
              //  flutter_toast(decrypt);
              String strl = decrypt.substring(1, (decrypt.length) - 1);

              if(strl == "IACK"){
                print("insertion success");
                fluttertoast("Insertion Success");
              }
              else if(strl == "INACK"){
                print("insertion failure");
                fluttertoast("Insertion Failure");
              }
              else if(strl == "EACK"){
                print("insertion failure");
                fluttertoast("Insertion Failure");
              }
              else if(strl == "DNACK"){
                print("Delete Failure");
                fluttertoast("Delete Failure");
                FNC.DartNotificationCenter.post(channel: 'deleteError', options: "deleteerror");
              }
              else if(strl == "DACK"){
                print("Delete Success");
                fluttertoast("Delete Success");
                FNC.DartNotificationCenter.post(channel: 'deleteSuccess', options: "deleteSuccess");
              }
              else if(strl == "UACK"){
                print("Update success");
                fluttertoast("Update Success");
                FNC.DartNotificationCenter.post(channel: 'updateSuccess', options: "updateSuccess");
              }
              else if(strl == "UNACK"){
                print("Update Failure");
                fluttertoast("Update failure");
                FNC.DartNotificationCenter.post(channel: 'updateFailure', options: "updatefailure");
              }
              else{

                print(strl);
               // fluttertoast(strl);
                FNC.DartNotificationCenter.post(channel: 'MasterNotification', options: strl);
              }
            }
            else if (decrypt=='*OK#\r\n') {

            //  fluttertoast("*OK#");
              socketconnected = true;
              socketregisterchannel();
              socketconnectchannel();
            }
            else if (decrypt=='*ERRUSER') {
              // // flutter_toast(decrypt);
              print("socket disconnect");
              fluttertoast("error_user");
              close("ERRUSER");
              socketregisterchannel();
              socketdisconnectchannel();
            }

            else if(decrypt.startsWith('?') && decrypt.endsWith('#')){

              String version = decrypt.substring(1, (decrypt.length) - 1);

              FNC.DartNotificationCenter.post(
                  channel: 'get_version', options: version);

            }
            else if(decrypt.startsWith('*') && decrypt.endsWith('_')){

              String version = decrypt.substring(1, (decrypt.length) - 1);
              FNC.DartNotificationCenter.post(
                  channel: 'get_versionconnection', options: version);

            }
            else if(decrypt.startsWith('(') && decrypt.endsWith(')')){

              String time = decrypt.substring(1, (decrypt.length) - 1);
              FNC.DartNotificationCenter.post(
                  channel: 'get_time', options: time);

            }
            else if(decrypt.startsWith('!') && decrypt.endsWith('\$')){

              String ssid = decrypt.substring(1, (decrypt.length) - 1);
              FNC.DartNotificationCenter.post(
                  channel: 'get_ssid', options: ssid);

            }
            else if(decrypt.startsWith('[') && decrypt.endsWith(']')){

              String ebcode = decrypt.substring(1, (decrypt.length) - 1);
              FNC.DartNotificationCenter.post(
                  channel: 'get_ebcode', options: ebcode);

            }
            else if(decrypt.startsWith('&') || (decrypt.endsWith('&'))){


              String sva = decrypt;
              String room = sva.substring(0,4);

              print("room $room");

              if(sva==("&400U@")){
                // //  flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "AddUserNotification", options:sva);
              }
              else if(sva==("&400A@")){
                // //  flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "AddAdminNotification", options:sva);
              }
              else if(sva==("&400G@")){
                // //  flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "AddGuestNotification", options:sva);
              }
              else if(sva==("&004E@")){
                // // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "FailAddUserNotification", options:sva);
              }
              else if(sva==("&004B@")){
                // // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "FailAddUserNotification", options:sva);
              }
              else if(sva==("&004D@")) {
                // // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "FailAddUserNotification", options:sva);
              }
              else if(sva==("&110S@")){
                // // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "SuperAdminPasswordNotification", options:sva);
              }
              else if(sva==("&500A@")){
                // // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "AdminPasswordNotification", options:sva);
              }
              else if(sva==("&500U@")){
                // // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "UserPasswordNotification", options:sva);
              }
              else if(sva==("&500G@")){
                // // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "FailPasswordNotification", options:sva);
              }
              else if(sva==("&005@")){
                // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "FailPasswordNotification", options:sva);
              }
              else if(sva==("&800@")){
                // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "DeleteUserNotification", options:sva);
              }
              else if(sva==("&008@")){
                // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "FailDeleteNotification", options:sva);
              }
              else if(sva==("&110@")){
                // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "UserTimerDeleted", options:sva);
              }
              else if(sva==("&011@")){
                // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "UserDeletedTimernotDeleted", options:sva);
              }
              else if(sva==("&101@")){
                // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "UserTimernotDeleted", options:sva);
              }
              else if(sva==("&700@")){
                // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "SuccessUserNotification", options:sva);
              }
              else if(sva==("&007B@")){
                // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "FailUserNotification", options:sva);
              }
              else if(sva==("&007E@")){
                // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "FailUserNotification", options:sva);
              }
              else if(sva==("&007D@")){
                // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "FailUserNotification", options:sva);
              }
              else if(sva==("&120U@")){
                // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "UserAddedSuccessfully", options:sva);
              }
              else if(sva==("&120G@")){
                // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "GuestAddedSuccessfully", options:sva);
              }
              else if(sva==("&120A@")){
                // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "AdminAddedSuccessfully", options:sva);
              }
              else if(sva==("&120@")){
                // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "UserWithRoomsAddedSuccess", options:sva);
              }
              else if(sva==("&120B@")){
                // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "UserWithRoomsAddedError", options:sva);
              }
              else if(sva==("&012W@")){
                // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "User_not_present_in_ServerDetails", options:sva);
              }
              else if(sva==("&012WL@")){
                // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "User_not_present_in_UserTable", options:sva);
              }
              else if(sva==("&120W")){
                // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "Error while updating to server Details", options:sva);
              }
              else if(sva==("&120WL")){
                // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "Error while updating to user table", options:sva);
              }
              else if(sva==("&012ID@")){
                // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "Invalid Data Format", options:sva);
              }
              else if((sva==("&011W@")) || (sva==("&011WL@")) || (sva==("&011T@")) || (sva==("&011S@"))){
                // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "DeleteDevice", options:sva);
              }
              else if((room==("&010")) || (room==("&101")) ){
                // flutter_toast(decrypt);
                FNC.DartNotificationCenter.post(channel: "DeleteRoom", options:sva);
              }
            }

          }

          else if(wireddb==true){

            builder.add(data1);
            int wiredBytes=builder.length;

            if(maxsize.bitLength == 0){

            }
            else{

              print("$wiredBytes,$maxsize");

              if (wiredBytes == maxsize) {

                print("f $wiredBytes,$maxsize");

                Uint8List dt = builder.toBytes();

                Directory documentsDirectory = await getApplicationDocumentsDirectory();
                String wiredpath = join(documentsDirectory.path, hnamef+ ".db");
                print("Pathwireless: $wiredpath");

                ByteData data = dt.buffer.asByteData(0, dt.buffer.lengthInBytes);
                final buffer = data.buffer;
                File(wiredpath).writeAsBytes(
                    buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

              //  DBProvider.dbname = hnamef;
               callingMethod();
                wireddb=false;
              }
            }
          }

          else if(wirelessDb==true){

            print("ieless");
            wrBuilder.add(data1);
            int wirelessBytes=wrBuilder.length;

            if(maxsizeWl.bitLength == 0){

            }
            else{

              print("$wirelessBytes,$maxsizeWl");

              if (wirelessBytes == maxsizeWl) {

                print("f $wirelessBytes,$maxsizeWl");

                Uint8List dt = wrBuilder.toBytes();

                Directory documentsDirectory = await getApplicationDocumentsDirectory();
                String wirelessPath = join(documentsDirectory.path, hnamef+ ".WLS_db");
                print("Pathwireless: $wirelessPath");

                ByteData data = dt.buffer.asByteData(0, dt.buffer.lengthInBytes);
                final buffer = data.buffer;
                File(wirelessPath).writeAsBytes(
                    buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

                //  DBProvider.dbname = hnamef;

                wirelessDb=false;

                FNC.DartNotificationCenter.post(channel: "DownLoadWLS", options:"true");
              }
            }
          }
          else if(timerdb==true){

            print("timer db $timerdb");
            timerbuilder.add(data1);
            int timerbytes=timerbuilder.length;
            print("Timer $timerdb");
            print(timerbytes);
            print(maxsizet);
            if(maxsizet.bitLength == 0){

            }
            else{

              if (timerbytes == maxsizet) {


                Uint8List dt = timerbuilder.toBytes();
                io.Directory documentsDirectory = await getApplicationDocumentsDirectory();

                hnamef = hnamef.replaceAll(' ','');
                String timerpath = join(documentsDirectory.path, hnamef+"timer.db");
                print("Pathtimer: $timerpath");

                ByteData data = dt.buffer.asByteData(0, dt.buffer.lengthInBytes);
                final buffer = data.buffer;

                io.File(timerpath).writeAsBytes(
                    buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
                timerdb=false;


                FNC.DartNotificationCenter.post(channel: 'timerlistupdate', options: "timerlistupdate");

              }
            }
          }
        },
          onError: (error) {


            print("on error socket");
            close("OnError");
            socketregisterchannel();
            socketdisconnectchannel();
          },
          onDone: () {
            print("close");
          },
        );
      }
      on TimeoutException catch (e) {
        // flutter_toast("Timeoutsockdisscon_err");
        print('Timeout Errorsocket: $e');
        close("Timeout Errorsocket");
        socketregisterchannel();
        socketdisconnectchannel();

      } on SocketException catch (e) {
        print('Socket Errorsocket: $e');
        // flutter_toast("Sock_errdisconnect");
        close("Socket Errorsocket");
        socketregisterchannel();
        socketdisconnectchannel();

      } on Error catch (e) {
        //socketconnected = false;
        print('General Errorsocket: $e');
      }
    }
    on TimeoutException catch (e) {
      print('Timeout Errorconn: $e');
      // flutter_toast("sockconnectimeout");
      close("Timeout Errorconn");
      socketregisterchannel();
      socketdisconnectchannel();

    } on SocketException catch (e) {
      print('Socket Errorconn: $e');
      close("Socket Errorconn");
      // flutter_toast("sockconn_sockerr");
      socketregisterchannel();
      socketdisconnectchannel();

    } on Error catch (e) {
      print('General Errorconn: $e');

    }
  }


  Future<void> callingMethod() async {


    DBProvider.db.close();

    Timer(Duration(seconds: 3
    ), () async {

      DBProvider.dbname = hnamef;

      DBProvider.db.newClient();
      DBProvider.db.newClient1();
      DBProvider.db.newClient2();
      DBProvider.db.newClient3();


      DBProvider.db.update(hnamef,serc1 );
      DBProvider.db.updatemt(hnamef, serc1);
      DBProvider.db.updatest(hnamef, serc1);
      DBProvider.db.updatesd(hnamef, serc1);



      List ut = await DBProvider.db.getServerDetailsDataWithHNumUType(hnamef, adminName);
      if(ut.length==0){

        FNC.DartNotificationCenter.post(channel: "DownLoadWFailure", options:"true");

      }
      else{

        String uType = ut[0]['da'];

        List res = await dbHelper.getStudents1(hnamef, serc1);

        String hname = res[0]['name'];
        String hnum = res[0]['lb'];
        String ip = res[0]['lc'];
        String uname = res[0]['ld'];
        String uPass= res[0]['le'];
        String auto = res[0]['lf'];
        String lh = res[0]['lh'];
        String port = res[0]['li'];

        dbHelper.updatedb(Student(
            name: hname,
            lb: hnum,
            lc: ip,
            ld: uname,
            le: uPass,
            lf: auto,
            lg: uType,
            lh: lh,
            li: port));

        FNC.DartNotificationCenter.post(channel: "DownLoadW", options:"true");
      }


    }
    );




  }

  close(String message){

    print(message);
    print(socket);
    if(socket!=null){

      print("enter not null");
      socket.close();
      socket.destroy();
      socketconnected=false;
      print(socket);
    }
    else{
      print("enter null");
      socketconnected=false;
    }

  }

  fluttertoast(String message){

    Fluttertoast.showToast(
        msg: message,

        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      //  timeInSecForIosWeb: 0.1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
    );

  }

  socketconnectchannel(){

    print("socket");
    FNC.DartNotificationCenter.post(
        channel: 'socketconndevice', options: socketconnected);

  }

  socketregisterchannel(){
    print("socket");
    FNC.DartNotificationCenter.post(
        channel: 'socketconn', options: socketconnected);

  }

  socketdisconnectchannel(){
    print("socket");
    FNC.DartNotificationCenter.post(
        channel: 'socketdisconn', options: socketconnected);

  }

  networkregisterchannel(){
    print("network");
    FNC.DartNotificationCenter.post(
        channel: 'networkconn', options: networkconnected);

  }



}
