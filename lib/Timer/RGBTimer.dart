import 'package:flutter/material.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/Globaltimerdata.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class RGBTimerPage extends StatefulWidget {

  RGBTimerPage({Key key, this.number}) : super(key: key);
  final String number;
  @override
  _RGBTimerPageState createState() => _RGBTimerPageState(number1: number);
}

class _RGBTimerPageState extends State<RGBTimerPage> {

  _RGBTimerPageState({this.number1});
  final String number1;

  Color currentColor1 =Colors.amber;

  String username,usertype;
  String hname,hnum,rnum,rname,dnum,groupIdset,ddevmodel,modeltypeset,devicenameset="name";

  GlobalService _globalService = GlobalService();
  Globaltimer _globaltimer = Globaltimer();

  String number="0";

  List ondataarray = [];
  List offdataarray = [];
  List switchnumber = [];

  Color currentColor;

  final leadingWidgetWidth = 120.0;
  int iSpeed = 120, count = 0;
  int iSpeed1 = 0;

  int myValue = 1;

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

  String rgbColorEffect,rgbSpeed,rgbBright;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    hname = _globalService.hname;
    hnum = _globalService.hnum;
    rnum = _globalService.rnum;
    rname = _globalService.rname;
    dnum = _globalService.dnum;
    groupIdset = _globalService.groupId;
    ddevmodel = _globalService.ddevModel;
    modeltypeset = _globalService.modeltype;
    devicenameset = _globalService.devicename;
    timerdbfunction();

  }

  timerdbfunction()async {

    DBHelper dbHelper = DBHelper();
    List result = await dbHelper.getLocalDateHName(hname);

    username = result[0]['ld'];
    usertype = result[0]['lg'];
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(

      elevation: 0,
      clipBehavior:Clip.antiAliasWithSaveLayer,
      insetPadding: EdgeInsets.all(70.0),
      backgroundColor: Color(0xffffffff),
      shape: RoundedRectangleBorder(
        //borderRadius: BorderRadius.circular(15.0),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(25.0),
          bottomLeft: Radius.circular(25.0),
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),


        ),

      ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:<Widget> [

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
                        flex:10,
                        child:Container(
                          color: Colors.white,
                          child: Center(
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  "$devicenameset",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal
                                  ), maxLines: 2,

                                ),
                              )
                          ),
                        )
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        flex:10,
                        child: Container(
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [

                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: IconButton(
                                  iconSize: MediaQuery.of(context).size.width / 10,
                                  icon: Image.asset(
                                      'images/RGB/white.png'),
                                  onPressed: () {

                                    setState(() {
                                      currentColor = Colors.white;

                                      fadeImgchange = false;
                                      strobeImgchange = false;
                                      flashImgchange = false;
                                      smoothImgchange = false;

                                      rgbColorEffect =
                                          "0," + currentColor.red.toString() +
                                              "," +
                                              currentColor.green.toString() +
                                              "," +
                                              currentColor.blue.toString() +
                                              ",B";
                                      });
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

                                    setState(() {
                                      currentColor =
                                          Color.fromRGBO(0, 255, 0, 10);

                                      fadeImgchange = false;
                                      strobeImgchange = false;
                                      flashImgchange = false;
                                      smoothImgchange = false;

                                      rgbColorEffect =
                                          "0," + currentColor.red.toString() +
                                              "," +
                                              currentColor.green.toString() +
                                              "," +
                                              currentColor.blue.toString() +
                                              ",B";
                                      });
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
                                  icon: Image.asset('images/RGB/orange.png'),
                                  onPressed: () {

                                    setState(() {
                                      currentColor =
                                          Color.fromRGBO(255, 165, 0, 10);
                                      rgbColorEffect =
                                          "0," + currentColor.red.toString() +
                                              "," +
                                              currentColor.green.toString() +
                                              "," +
                                              currentColor.blue.toString() +
                                              ",B";

                                      fadeImgchange = false;
                                      strobeImgchange = false;
                                      flashImgchange = false;
                                      smoothImgchange = false;
                                    });

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
                                  icon: Image.asset('images/RGB/blue.png'),
                                  onPressed: () {

                                    setState(() {
                                      currentColor =
                                          Color.fromRGBO(0, 0, 255, 10);
                                      rgbColorEffect =
                                          "0," + currentColor.red.toString() +
                                              "," +
                                              currentColor.green.toString() +
                                              "," +
                                              currentColor.blue.toString() +
                                              ",B";

                                      fadeImgchange = false;
                                      strobeImgchange = false;
                                      flashImgchange = false;
                                      smoothImgchange = false;
                                    });
                                    },
                                ),
                              ),

                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: IconButton(iconSize: MediaQuery.of(context).size.width / 10,
                                  icon: Image.asset('images/RGB/red.png'),
                                  onPressed: () {

                                  setState(() {
                                    currentColor =
                                        Color.fromRGBO(255, 0, 0, 10);
                                    rgbColorEffect =
                                        "0," + currentColor.red.toString() +
                                            "," +
                                            currentColor.green.toString() +
                                            "," + currentColor.blue.toString() +
                                            ",B";

                                    fadeImgchange = false;
                                    strobeImgchange = false;
                                    flashImgchange = false;
                                    smoothImgchange = false;
                                  });

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

                                    setState(() {
                                      currentColor =
                                          Color.fromRGBO(255, 0, 128, 10);
                                      rgbColorEffect =
                                          "0," + currentColor.red.toString() +
                                              "," +
                                              currentColor.green.toString() +
                                              "," +
                                              currentColor.blue.toString() +
                                              ",B";

                                      fadeImgchange = false;
                                      strobeImgchange = false;
                                      flashImgchange = false;
                                      smoothImgchange = false;
                                    });

                                    },
                                ),
                              ),
                            ],
                          ),

                        )
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Expanded(
                        flex:10,
                        child:Container(
                          color:Colors.white,
                            padding: EdgeInsets.all(2), height: 100,  child: Column(
                          children: [
                            Flexible(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                                //Image.asset("images/up.png" ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.40,
                                  color: Colors.white,
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

                                                    setState(() {
                                                        currentColor = value;
                                                        currentColor1 = currentColor;

                                                        rgbColorEffect = "0," +
                                                          currentColor.red.toString() +
                                                          "," +
                                                          currentColor.green.toString() +
                                                          "," +
                                                          currentColor.blue.toString() +
                                                          ",B";
                                                      });
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

                                              setState(() {

                                                  print(iSpeed);
                                                  if (iSpeed < 130) {
                                                    iSpeed ++;
                                                    iSpeed1 = iSpeed-120;
                                                  }
                                                  iSpeed1 = iSpeed - 120;
                                                  rgbSpeed = iSpeed.toString() +","+
                                                      "000,000,000,A";
                                              });

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

                                                setState(() {
                                                  if (iSpeed > 121) {
                                                    iSpeed--;
                                                    iSpeed1 = iSpeed - 120;
                                                    }
                                                });
                                                rgbSpeed = iSpeed.toString() + ","+
                                                    "000,000,000,A";

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
                          child:
                          Column(
                            children: [
                              Row(

                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Slider(value: myValue.toDouble(),


                                      onChanged: (value) {
                                        setState(() {


                                        });
                                      },
                                      min: 1,
                                      max: 10,

                                      onChangeEnd: (double value) {
                                        print('Ended change on $value');
                                        print(value.toInt());

                                        myValue = value.toInt();
                                        print("my_value_is: $myValue");

                                        int x = 130;

                                        int y = myValue + x;
                                        print("_sliding_value: $y");
                                        String slide = y.toString() + "," +
                                            "000,000,000,A";

                                        print("_sliding_value_rgb: $slide");
                                        if (myValue < 1)
                                          myValue = 1;
                                        rgbBright = slide;
                                        },
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                    width: 50,
                                    height: 20,
                                    color: currentColor,
                                      )
                                  )
                                ],
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
                        child: Container(
                          color:Colors.white,
                        child:Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  flex: 2,
                                  fit: FlexFit.tight,
                                  child: IconButton(
                                      iconSize: MediaQuery.of(context).size.width / 10,
                                      icon: flashImgchange ? flash02 : flash01,

                                      splashRadius: 0.1,
                                      splashColor: Colors.transparent,
                                      onPressed: () {

                                        if (flashImgchange == false) {
                                          flashImgchange = true;
                                          strobeImgchange = false;
                                          fadeImgchange = false;
                                          smoothImgchange = false;
                                        }
                                        currentColor = Colors.transparent;
                                        rgbColorEffect = "104,000,000,000,A";

                                        setState(() {
                                          flashImgchange = flashImgchange;
                                        });
                                      }
                                  ),
                                ),


                                Flexible(
                                  flex: 2,
                                  fit: FlexFit.tight,
                                  child: IconButton(
                                      iconSize: MediaQuery.of(context).size.width / 10,
                                      icon: strobeImgchange ? strobe02 : strobe01,

                                      splashRadius: 0.1,
                                      splashColor: Colors.transparent,
                                      onPressed: () {

                                        if (strobeImgchange == false) {
                                          strobeImgchange = true;
                                          flashImgchange = false;
                                          fadeImgchange = false;
                                          smoothImgchange = false;
                                        }
                                        currentColor = Colors.transparent;
                                        rgbColorEffect = "105,000,000,000,A";

                                        setState(() {
                                          strobeImgchange = strobeImgchange;
                                        });
                                      }
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
                                      splashRadius: 0.1,
                                      splashColor: Colors.transparent,
                                      onPressed: () {

                                        if (fadeImgchange == false) {
                                          fadeImgchange = true;
                                          strobeImgchange = false;
                                          flashImgchange = false;
                                          smoothImgchange = false;
                                        }
                                        currentColor = Colors.transparent;
                                        rgbColorEffect = "107,000,000,000,A";

                                        setState(() {
                                          fadeImgchange = fadeImgchange;
                                        });
                                      }
                                  ),
                                ),

                                Flexible(
                                  flex: 2,
                                  fit: FlexFit.tight,
                                  child: IconButton(
                                      iconSize: MediaQuery.of(context).size.width / 10,
                                      icon: smoothImgchange ? smooth02 : smooth01,
                                      splashRadius: 0.1,
                                      splashColor: Colors.transparent,
                                      onPressed: () {

                                        if (smoothImgchange == false) {
                                          smoothImgchange = true;
                                          strobeImgchange= false;
                                          flashImgchange = false;
                                          fadeImgchange = false;
                                        }
                                        currentColor = Colors.transparent;
                                        rgbColorEffect = "106,000,000,000,A";
                                        setState(() {
                                          smoothImgchange = smoothImgchange;
                                        });
                                      }
                                  ),

                                ),
                              ],
                            ),
                          ],
                        ),

                    ),
                    ),],
                ),

                Container(
                  height: 2,
                  color: Colors.black54,
                ),

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          flex:10,
                          child: Container(
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                          fit: BoxFit.fill),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Center(child: Text("  SAVE  ")),
                                    ),
                                  ),
                                  // ),
                                  onPressed: () {
                                    print('Tapped');


                                      String rgbInst,rgbBrightInst,rgbSpeedInst,rgbOndataRgb,rgbOffdataRgb;

                                      //color
                                      if (rgbColorEffect != null ||
                                          !rgbColorEffect.contains("") ||
                                          rgbColorEffect != "") {
                                        rgbInst = rgbColorEffect;
                                      }
                                      else {
                                        rgbInst = "0,255,000,000,A";
                                      }

                                      List<String> splitData = rgbInst.split(',');
                                      rgbInst = transmitdata(splitData[0], splitData[1], splitData[2], splitData[3], splitData[4]);

                                      //Bright
                                      if(rgbBright==null||rgbBright == ""){
                                        rgbBrightInst = "132,000,000,000,A";
                                      }
                                      else{
                                        rgbBrightInst = rgbBright;
                                      }

                                      final splitData1 = rgbBrightInst
                                          .split(",")
                                          .map((x) => x.trim())
                                          .where((element) =>
                                      element.isNotEmpty)
                                          .toList();

                                      rgbBrightInst = transmitdata(
                                          splitData1[0], splitData1[1],
                                          splitData1[2], splitData1[3],
                                          splitData1[4]);

                                      //Speed
                                      if(rgbSpeed==null||rgbSpeed == ""){
                                        rgbSpeedInst = "121,000,000,000,A";
                                      }
                                      else{
                                        rgbSpeedInst = rgbSpeed;
                                      }

                                      final splitData2 = rgbSpeedInst
                                          .split(",")
                                          .map((x) => x.trim())
                                          .where((element) =>
                                      element.isNotEmpty)
                                          .toList();

                                      rgbSpeedInst = transmitdata(
                                          splitData2[0], splitData2[1],
                                          splitData2[2], splitData2[3],
                                          splitData2[4]);

                                      //ondata
                                      rgbOndataRgb = "102,000,000,000,A";
                                      final splitData3 = rgbOndataRgb.split(
                                          ",");
                                      rgbOndataRgb = transmitdata(
                                          splitData3[0], splitData3[1],
                                          splitData3[2], splitData3[3],
                                          splitData3[4]);

                                      switchnumber.add("0");
                                      ondataarray.add(rgbOndataRgb+";"+rgbInst+";"+rgbBrightInst+";"+rgbSpeedInst);
                                      print("onda $ondataarray");

                                      //Offdata

                                      rgbOffdataRgb = "103,000,000,000,A";
                                      final splitData4 = rgbOffdataRgb.split(
                                          ",");
                                      rgbOffdataRgb = transmitdata(
                                          splitData4[0], splitData4[1],
                                          splitData4[2], splitData4[3],
                                          splitData4[4]);


                                      offdataarray.add(rgbOffdataRgb);

                                    if(ondataarray.length==0){
                                      print("Select Switch for timers to be set");
                                    }
                                    else{

                                      Navigator.pop(context);
                                      _globaltimer.ondataarrayset=ondataarray;
                                      _globaltimer.offdataarrayset=offdataarray;
                                      _globaltimer.switchnumberset=switchnumber;

                                    }





                                  },
                                ),
                              ],
                            ),

                          )
                      ),
                    ]
                ),
              ],
            ),
          );

  }

  String transmitdata(final String val, final String rc, final String gc,
      final String bc, String type) {

    String str;
    String str2 = "" + val;
    while (str2.length < 3) str2 = "0" + str2;
    String redStr = "" + rc;
    while (redStr.length < 3) redStr = "0" + redStr;
    print("redStr" + redStr);
    String greenStr = "" + gc;
    while (greenStr.length < 3) greenStr = "0" + greenStr;
    print("greenStr" + greenStr);
    String blueStr = "" + bc;
    while (blueStr.length < 3) blueStr = "0" + blueStr;
    print("blueStr" + blueStr);

    String rN = rnum.padLeft(2, '0');
    String devN= dnum.padLeft(4 , '0');




    if (type.contains("A")) {

      str = "0" + "01" + "000" + devN + rN + str2 + "000000000000003";
      print("TypeA_str" + str);

    } else {

      str = "0" + "01" + "000" + devN + rN + "112" + redStr + greenStr + blueStr + "000003";
      print("Type_b_str" + str);

    }

    return  str;
  }



}


