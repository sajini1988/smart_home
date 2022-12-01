import 'package:flutter/material.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/RGB/RGBLayout.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/Singleton.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class RGBIViewState extends StatefulWidget {
  @override
  _RGBIViewState createState() => _RGBIViewState();
}
class _RGBIViewState extends State<RGBIViewState> {

  GlobalService _globalService = GlobalService();
  var s=Singleton();
  Color currentColor;

  bool rgbStatus = false;

  int iSpeed = 121;
  int iSpeed1 = 0;

  String hnameRgb,hnumRgb,rnumRgb,dnumRgb,rnameRgb,groupIdRgb,dtypeRgb;
  String devicename="name";

  Color pickerColor =  Color(0xff443a49);
  Color currentColor1 = Colors.amber;

  int myValue = 1;
  final leadingWidgetWidth = 120.0;


  bool fadeImgchange = false;
  bool flashImgchange = false;
  bool smoothImgchange = false;
  bool strobeImgchange = false;


  Image fade01 = Image.asset('images/RGB/fade01.png');
  Image fade02 = Image.asset('images/RGB/fade02.png');

  Image flash01 = Image.asset('images/RGB/flash01.png');
  Image flash02 = Image.asset('images/RGB/flash02.png');

  Image smooth01 = Image.asset('images/RGB/smooth01.png');
  Image smooth02 = Image.asset('images/RGB/smooth02.png');

  Image strobe01 = Image.asset('images/RGB/strobe01.png');
  Image strobe02 = Image.asset('images/RGB/strobe02.png');


  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
      print("I_am_color_picker_value: $pickerColor");

      print(pickerColor.red);
      print(pickerColor.green);
      print(pickerColor.blue);
      transmitData(
          0, pickerColor.red, pickerColor.green, pickerColor.blue, "B");
    });
  }


  @override
  void initState() {

    super.initState();

    FNC.DartNotificationCenter.unregisterChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'MasterNotification', onNotification: (options) {
      print('ACNotified: $options');
      rgbResponce(options);
    }, observer: null);
    // TODO: implement initState

    hnameRgb = hnameRGB;
    hnumRgb= hnumRGB;
    rnumRgb = rnumRGB;
    dnumRgb = dnumRGB;
    rnameRgb = rnameRGB;
    groupIdRgb = groupIdRGB;
    dtypeRgb = dtypeRGB;

    rgbDetails();
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

  rgbDetails(){
    details();
  }

  void details()async{

    DBHelper dbHelper;
    dbHelper = DBHelper();

    List result = await dbHelper.getLocalDateHName(hnameRgb);
    String userAdmin = result[0]['lg'];
    print(userAdmin);

    if (userAdmin == 'U' || userAdmin == 'G') {

    }

    List acdata = await DBProvider.db.DataFromMTRNumAndHNumGroupIdDetails1WithDN(rnumRgb, hnumRgb, hnameRgb, groupIdRgb, dnumRgb);
    devicename = acdata[0]['ec'];
    _globalService.devicenameset=devicename;

    setState(() {
      devicename=devicename;
    });

    socketsend();
  }

  socketsend(){

    if(s.socketconnected == true){
      sendDataRgb(senddata: "920",castType: "01");
    }
    else{
      s.checkindevice(hnameRGB,hnumRGB);
    }
  }

  void transmitData(final int val, final int rc, final int gc, final int bc, String type) {

    String str2 = "" + val.toString();
    while (str2.length < 3)str2 = "0" + str2;

    String redStr = "" + rc.toString();
    while (redStr.length < 3)redStr = "0" + redStr;

    String greenStr = "" + gc.toString();
    while (greenStr.length < 3)greenStr = "0" + greenStr;

    String blueStr = "" + bc.toString();
    while (blueStr.length < 3)blueStr = "0" + blueStr;



    String cast1 = "01";
    String gI = groupIdRgb;
    String c = dnumRgb.padLeft(4, '0');
    String rN = rnumRgb.padLeft(2, '0');
    String cE = "000000000000000";
    String a = "0";



    if (type == ("A")) {
      String sData = '*' + a + cast1 + gI + c + rN + str2 + cE + '#';
      if (s.socketconnected == true) {
        s.socket1(sData);
      }
      else {

      }
    }
    else {
      print("_Iam_bbb_variable:");

      // str = "0" + "01" + "000" + devno + roomno+"112"+redStr+greenStr+blueStr+"000000";
      String sData = '*' + a + cast1 + gI + c + rN + "112" + redStr + greenStr + blueStr + "000000" + '#';
      if (s.socketconnected == true) {
        s.socket1(sData);
      }
      else {

      }

    }
  }


  rgbResponce(String notification) {
    print("rgb $Notification");
    String cDev = dnumRGB.padLeft(4, '0');
    String rDev = notification.substring(4, 8);

    if (cDev==(rDev)) {

      setState(() {
        String ds = notification.substring(8, 10);
        String brigVal = notification.substring(10, 11);
        String speedVal = notification.substring(11, 12);
        String effectsVal = notification.substring(12, 13);
        String redVal = "00", greenVal = "00", blueVal = "00";
        String hex;

        if (brigVal == ("A")) {
          myValue = 10;
        }
        else if (brigVal == "F") {

        }
        else {
          int brightInt = 0;
          try {
            brightInt = int.parse(brigVal);
            myValue = brightInt;
            }
          catch (Exception) {

          }
        }

        print(myValue);

        if (speedVal==("A")) {
          iSpeed1 = 10;
          iSpeed = 120 + 10;
        } else if (speedVal == ("F") || speedVal == ("0")) {
          iSpeed1 = 0;
          iSpeed = 120 + 0;
        } else {
          int speedInt = 0;
          try {
            speedInt = int.parse(speedVal);
            iSpeed1 = speedInt;
            iSpeed = 120 + speedInt;

          } catch (Exception) {

          }
        }

        print(iSpeed1);
        print(iSpeed);

        if (ds == "01") {
          rgbStatus = true;

          if (effectsVal == "0") {

            redVal = notification.substring(13, 15);
            greenVal = notification.substring(15, 17);
            blueVal = notification.substring(17, 19);

            final String finalRedVal = redVal;
            final String finalGreenVal = greenVal;
            final String finalBlueVal = blueVal;

            hex = '#${finalRedVal + finalGreenVal + finalBlueVal}';

            smoothImgchange = false;
            fadeImgchange = false;
            strobeImgchange = false;
            flashImgchange = false;

            String color1 = hex.replaceAll('#', '0xff');
            currentColor = Color(int.parse(color1));
          }
          else if (effectsVal == ("1")) {
          smoothImgchange = true;
          fadeImgchange = false;
          strobeImgchange = false;
          flashImgchange = false;
          currentColor = Colors.transparent;
          iSpeed1=iSpeed1;
          myValue=myValue;

          }
          else if (effectsVal == ("2")) {
          smoothImgchange = false;
          fadeImgchange = true;
          strobeImgchange = false;
          flashImgchange = false;
          currentColor = Colors.transparent;
          iSpeed1=iSpeed1;
          myValue=myValue;
         }
          else if (effectsVal == ("3")) {
          smoothImgchange = false;
          fadeImgchange = false;
          strobeImgchange = true;
          flashImgchange = false;
          currentColor = Colors.transparent;
          iSpeed1=iSpeed1;
          myValue=myValue;
          }
          else if (effectsVal == ("4")) {
          smoothImgchange = false;
          fadeImgchange = false;
          strobeImgchange = false;
          flashImgchange = true;
          currentColor = Colors.transparent;
          iSpeed1=iSpeed1;
          myValue=myValue;
          }
        }
        else if(ds == "02"){

          currentColor = Colors.transparent;
          iSpeed1 = 0;
          myValue = 1;
          smoothImgchange = false;
          fadeImgchange = false;
          strobeImgchange = false;
          flashImgchange = false;


        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Expanded(
                    child: IconButton(
                      iconSize: MediaQuery.of(context).size.width/10,
                      splashRadius: 0.1,
                      splashColor:Colors.transparent,
                      icon:Image.asset('images/switchicons/all_on.png'),
                      onPressed: () {
                        sendDataRgb(senddata: "102",castType: "01");
                      },
                    ),
                  ),
                  Expanded(
                    child:Center(
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          devicename,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal
                          ),
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      iconSize: MediaQuery.of(context).size.width/10,
                      splashRadius: 0.1,
                      splashColor:Colors.transparent,
                      icon:Image.asset('images/switchicons/all_off.png'),
                      onPressed: () {
                        sendDataRgb(senddata: "103",castType: "01");
                      },
                    ),
                  ),
                ],
              ),

              Container(
                //color: Colors.cyan,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: IconButton(
                        iconSize: MediaQuery
                            .of(context)
                            .size
                            .width / 10,
                        icon: Image.asset('images/RGB/white.png'),
                        onPressed: () {

                          if (rgbStatus) {
                            currentColor = Color.fromRGBO(255, 255, 255, 10);
                            transmitData(0, 255, 255, 255, "B");
                          }
                          else {
                            flutterToast("please switch on the device first");
                          }

                        },
                      ),

                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: IconButton(
                        iconSize: MediaQuery
                            .of(context)
                            .size
                            .width / 10,
                        icon: Image.asset('images/RGB/green.png'),
                        onPressed: () {

                          if (rgbStatus) {

                            currentColor = Color.fromRGBO(0, 255, 0, 10);
                            transmitData(0, 0, 255, 0, "B");
                          }
                          else {
                            flutterToast(
                                "please switch on the device first");
                          }
                        },
                      ),

                    ),

                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: IconButton(
                        iconSize: MediaQuery.of(context).size.width / 10,
                        icon: Image.asset('images/RGB/orange.png'),
                        onPressed: () {

                          if (rgbStatus) {
                            currentColor =
                                Color.fromRGBO(255, 165, 0, 10);
                            transmitData(0, 255, 165, 0, "B");
                          }
                          else {
                            flutterToast(
                                "please switch on the device first");
                          }
                        },
                      ),

                    ),

                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: IconButton(
                        iconSize: MediaQuery.of(context).size.width / 10,
                        icon: Image.asset('images/RGB/blue.png'),
                        onPressed: () {

                            if (rgbStatus) {
                              currentColor = Color.fromRGBO(0, 0, 255, 10);
                              transmitData(0, 0, 0, 255, "B");
                            }
                            else {
                              flutterToast("please switch on the device first");
                            }
                          },
                      ),

                    ),

                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: IconButton(
                        iconSize: MediaQuery
                            .of(context)
                            .size
                            .width / 10,
                        icon: Image.asset('images/RGB/red.png'),
                        onPressed: () {

                          if (rgbStatus) {
                            currentColor = Color.fromRGBO(255, 0, 0, 10);

                            transmitData(0, 255, 0, 0, "B");
                          }
                          else {
                            flutterToast(
                                "please switch on the device first");
                          }
                        },
                      ),

                    ),

                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: IconButton(
                        iconSize: MediaQuery
                            .of(context)
                            .size
                            .width / 10,
                        icon: Image.asset('images/RGB/pink.png'),
                        onPressed: () {

                          if (rgbStatus) {
                            currentColor =
                                Color.fromRGBO(255, 0, 128, 10);

                            transmitData(0, 255, 0, 128, "B");
                          }
                          else {
                            flutterToast(
                                "please switch on the device first");
                          }
                          },
                      ),

                    ),


                  ],
                ),
              ),

              Container(
                  padding: EdgeInsets.all(2), height: 100,  child: Column(
                children: [
                  Flexible(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                      //Image.asset("images/up.png" ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.40,
                        // color: Colors.blue,
                        child: Wrap(
                          // alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,

                            children: [
                              ClipRRect(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0,top: 0.0),
                                  child: Transform.scale(
                                    scale: 0.6 ,
                                    alignment: Alignment.topLeft,


                                    child: ColorPicker(

                                      pickerColor: currentColor1,
                                      paletteType: PaletteType.hueWheel,
                                      // onColorChanged: changeColor,
                                      onColorChanged: (Color value) {
                                        if (rgbStatus) {
                                          setState(() {
                                            currentColor = value;
                                            currentColor1 = currentColor;
                                            print(
                                                "I_am_color_picker_value11: $currentColor");
                                            print(Color.fromARGB(
                                                0, currentColor.red,
                                                currentColor.green,
                                                currentColor.blue));
                                            print(currentColor.red);
                                            print(currentColor.green);
                                            print(currentColor.blue);

                                            transmitData(0, currentColor.red,
                                                currentColor.green,
                                                currentColor.blue, "B");
                                          });
                                        }
                                        else {
                                          flutterToast(
                                              "please switch on the device first");
                                        }

                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ] ),
                      ),


                      Container(
                        padding: EdgeInsets.all(2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: IconButton(
                              //iconSize: MediaQuery.of(context).size.width/10,
                                icon: Image.asset('images/RGB/uparrow.png'),
                                onPressed: () {

                                  print(rgbStatus);

                                  if (rgbStatus) {
                                    setState(() {
                                      print(rgbStatus);
                                      print(iSpeed);
                                      if (iSpeed < 130) {
                                        iSpeed++;
                                        iSpeed1
                                        = iSpeed-120;
                                      }
                                      iSpeed1 = iSpeed - 120;
                                      print(iSpeed1);
                                      print(iSpeed);
                                    });
                                    transmitData(iSpeed, 000, 000, 000, "A");
                                  }
                                  else {
                                    flutterToast("please switch on the device first");
                                  }
                                },
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text(iSpeed1.toString()),
                            ),

                            Flexible(
                              flex: 1,
                              child: IconButton(
                                icon: Image.asset(
                                    'images/RGB/downarrow.png'),
                                  onPressed: () {
                                    if (rgbStatus) {
                                      setState(() {
                                        if (iSpeed > 121) {
                                          iSpeed--;
                                          iSpeed1 = iSpeed - 120;
                                        }
                                      });

                                      print(iSpeed1);
                                      print(iSpeed);

                                      transmitData(
                                          iSpeed, 000, 000, 000, "A");
                                    }
                                    else {
                                      flutterToast(
                                          "please switch on the device first");
                                    }
                                },
                              ),
                            ),
                          ],
                       )
                      )
                      ]
                    ),
                    ),
                  ],
                )
              ),

              Row(
                children: [
                  //SizedBox(height: 300),
                  Expanded(
                    flex: 4,
                    child: Slider(
                      value: myValue.isNaN == true || myValue == null ? 0 : myValue.toDouble(),
                      onChanged: (value) {
                        if (rgbStatus) {
                          setState(() {
                            myValue = value.toInt();
                          });
                        }
                      },
                      min: 1,
                      max: 10,

                      onChangeEnd: (double value) {
                        if (rgbStatus) {

                          myValue = value.toInt();
                          int x = 130;
                          int y = myValue + x;
                          transmitData(y, 000, 000, 000, "A");
                        }
                        else {
                          flutterToast(
                              "please switch on the device first");
                        }
                      },
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container(
                      width: 40,
                      height: 20,
                      color: currentColor,
                    )
                  )
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //SizedBox(height: 400),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: IconButton(
                      iconSize: MediaQuery
                          .of(context)
                          .size
                          .width / 10,
                      icon: flashImgchange
                          ? flash02
                          : flash01,
                      onPressed: () {

                        if (rgbStatus) {
                          currentColor = Colors.black;
                          sendDataRgb(senddata: "104", castType: "01");
                        }
                        else {
                          flutterToast("please switch on the device first");
                        }
                      },
                    ),

                  ),

                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: IconButton(
                      iconSize: MediaQuery
                          .of(context)
                          .size
                          .width / 10,
                      icon: strobeImgchange
                          ? strobe02
                          : strobe01,
                      onPressed: () {
                        if (rgbStatus) {
                          currentColor = Colors.black;
                          sendDataRgb(senddata: "105", castType: "01");
                        }
                        else {
                          flutterToast("please switch on the device first");
                        }
                      },
                    ),

                  ),

                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: IconButton(
                      iconSize: MediaQuery
                          .of(context)
                          .size
                          .width / 10,
                      icon: fadeImgchange ? fade02 : fade01,
                      onPressed: () {
                        if (rgbStatus) {
                          currentColor = Colors.black;
                          sendDataRgb(senddata: "107", castType: "01");;
                        }
                        else {
                          flutterToast(
                              "please switch on the device first");
                        }
                      },
                    ),

                  ),

                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: IconButton(
                      iconSize: MediaQuery.of(context).size.width / 10,
                      icon: smoothImgchange ? smooth02 : smooth01,
                      onPressed: () {
                        if (rgbStatus) {
                          currentColor = Colors.black;
                          sendDataRgb(senddata: "106", castType: "01");
                        }
                        else {
                          flutterToast("please switch on the device first");
                        }
                      },
                    ),

                  ),
                ],
              ),

              Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width/25),),
              Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width/25),),


            ],
          ),
        ),
      ),
    );
  }

  void sendDataRgb({String senddata, String castType}) {

    String cast1 = castType;
    String gI = groupIdRGB;
    String c = dnumRGB.padLeft(4, '0');
    String rN = rnumRGB.padLeft(2, '0');
    String chr = senddata;
    String cE = "000000000000000";

    String a="0";
    String sData = '*' + a + cast1 + gI + c + rN + chr + cE + '#';
    print("Sending String is : $sData"); // input is : *001000000102920000000000000000# output is : 003300010100FFFFFFFFA120F001B3

    if(s.socketconnected == true){
      s.socket1(sData);
    }
    else{

    }

  }

  flutterToast(String message){

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