import 'package:flutter/material.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/Moods/MoodDB.dart';
import 'package:smart_home/homepage.dart';
import 'MoodDBModelClass.dart';
import 'package:smart_home/Moods/MoodList.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/cupertino.dart';

class MoodRGBPage extends StatefulWidget {
  MoodRGBPage({Key key, this.number}) : super(key: key);
  final String number;
  @override
  _MoodRGBPageState createState() => _MoodRGBPageState(number1: number);
}

class _MoodRGBPageState extends State<MoodRGBPage> {

  _MoodRGBPageState({this.number1});
  final String number1;

  Color currentColor1 = Colors.amber;
  Color currentColor;

  final leadingWidgetWidth = 120.0;
  int iSpeed=120,count = 0;
  int iSpeed1 = 0;
  int myValue=1;

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

  String username,usertype;
  String hname,hnum,rnum,rname,dnum,groupIdset,ddevmodel,modeltypeset,devicenameset="name",moodName;
  GlobalService _globalService = GlobalService();

  String number="0";
  String deviceData,state,onOffNum,aData,bData,cData,dData,eData,fData,gData,hData,iData,jData;
  String swValueS="";

  MDBHelper mdb;

  String rgbColorEffect="0",rgbSpeed="0",rgbBright="0",rgbOnOff="0";
  bool status=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    mdb = MDBHelper();

    print(number1);

    if(number1=="1"){
      dnum = _globalService.moodlistdnum;
      rnum=_globalService.moodlistrnum;
    }
    else if(number1 == "0"){
      dnum = _globalService.dnum;
      rnum = _globalService.rnum;
    }

    hname = _globalService.hname;
    hnum = _globalService.hnum;
    rname = _globalService.rname;
    groupIdset = _globalService.groupId;
    ddevmodel = _globalService.ddevModel;
    modeltypeset = _globalService.modeltype;
    devicenameset = _globalService.devicename;
    number=_globalService.moodnum;

    if(number.contains("1")){
      moodName="Mood1";
    }
    else if(number.contains("2")){
      moodName="Mood2";
    }
    else if(number.contains("3")){
      moodName="Mood3";
    }

    moodDbFunction();
  }

  moodDbFunction()async {
    DBHelper dbHelper = DBHelper();
    List result = await dbHelper.getLocalDateHName(hname);

    username = result[0]['ld'];
    usertype = result[0]['lg'];

    int count = await mdb.getCountHNumandRNumWithSetNumDnum(hname,hnum, rnum, number, dnum, username);
    print(count);

    if (count == 0) {
      mdb.add(MoodDBData(hnum: hnum,
          hname: hname,
          rnum: rnum,
          rname: rname,
          moodstno: number,
          moodstname: moodName,
          devicetype: "Null",
          devicemodel: ddevmodel,
          devicenum: dnum,
          onoffnum: "0",
          devicedata: "0",
          aEdata: "No",
          bEdata: "Off",
          cEdata: devicenameset,
          dEdata: username,
          eEdata: "Null",
          fEdata: "Null",
          gEdata: "Null",
          hEdata: "Null",
          iEdata: "Null",
          jEdata: "Null"));
    }

    List res = await mdb.getMooddata(hname,hnum, rnum, number, dnum, username);
    print(res);

    hnum = res[0]['hn'];
    hname = res[0]['hna'];
    rnum = res[0]['rn'];
    rname = res[0]['rna'];
    number = res[0]['stno'];
    moodName = res[0]['stna'];
    ddevmodel = res[0]['dna'];
    dnum = res[0]['dno'];
    onOffNum = res[0]['OnOff'];
    deviceData = res[0]['dd'];
    aData = res[0]['ea'];
    bData = res[0]['eb'];
    cData = res[0]['ec'];
    dData = res[0]['ed'];
    eData = res[0]['ee'];
    fData = res[0]['ef'];
    gData = res[0]['eg'];
    hData = res[0]['eh'];
    iData = res[0]['ei'];
    jData = res[0]['ej'];


    print("data $onOffNum");

    List<String> results = deviceData.split(';');
    print(results);

    for (int i = 0; i < results.length; i++) {
      String s = results[i];
      print("ss $s");

    }

    if(onOffNum == "1"){
      status = true;
      rgbOnOff = "1";
      rgbOnOffStatus(status);

    }else{
      status = false;
      rgbOnOff = "0";
      rgbOnOffStatus(status);

    }

    if(onOffNum == '1'){

      String firstElement = results[0];
      rgbColorEffect=firstElement;
      List<String>colorEffectsArray=firstElement.split(",");
      if(colorEffectsArray[0] == '0'){
         currentColor=Color.fromRGBO(int.parse(colorEffectsArray[1]), int.parse(colorEffectsArray[2]), int.parse(colorEffectsArray[3]), 10);
      }
      else if(colorEffectsArray[0] =="104") {

        currentColor = Colors.transparent;

        flashImgchange = true;
        strobeImgchange = false;
        fadeImgchange = false;
        smoothImgchange = false;
      }
      else if(colorEffectsArray[0]=="105") {

        currentColor = Colors.transparent;

        flashImgchange = false;
        strobeImgchange = true;
        fadeImgchange = false;
        smoothImgchange = false;

      }
      else if(colorEffectsArray[0] == "106") {


        currentColor = Colors.transparent;

        flashImgchange = false;
        strobeImgchange = false;
        fadeImgchange = false;
        smoothImgchange = true;

      }
      else if(colorEffectsArray[0] =="107") {

        currentColor = Colors.transparent;
        flashImgchange = false;
        strobeImgchange = false;
        fadeImgchange= true;
        smoothImgchange = false;

      }

      String secondElementB = results[1];
      rgbBright=secondElementB;
      List<String>brightnessArray=secondElementB.split(",");
      String brightness = brightnessArray[0];
      myValue = int.parse(brightness)-130;

      String thirdElementSP = results[2];
      rgbSpeed=thirdElementSP;
      List<String>speedArray = thirdElementSP.split(",");
      iSpeed = int.parse(speedArray[0]);

      if (int.parse(speedArray[0]) > 120 && (int.parse(speedArray[0]) < 131)) {

        iSpeed1 = iSpeed - 120;
        print("isSpeed_value_is: $iSpeed1");
      }
    }

    setState((){

      currentColor=currentColor;
      flashImgchange=flashImgchange;
      strobeImgchange=strobeImgchange;
      fadeImgchange=fadeImgchange;
      smoothImgchange=smoothImgchange;
      iSpeed1=iSpeed1;
      iSpeed=iSpeed;
      myValue=myValue;


    });
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(
      // debugShowCheckedModeBanner: false,
      // home: Scaffold(
      //   backgroundColor: Colors.transparent,
      //   body: Align(
      //     alignment: Alignment.center,
      //     child:Container(
      //       color: Colors.transparen,

      elevation:0,
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
                                flex:3,
                                child: Container(
                                  color: Colors.white,
                                  child:customSwitch1(status, rgbOnOffStatus)
                                ),
                              ),

                              Expanded(
                                  flex:4,
                                  child:Container(
                                    color: Colors.white,
                                    child: Center(
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            "Mood $number",
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
                              Expanded(
                                  flex:3,
                                  child: Transform.scale(
                                    scale: 0.9,
                                    child: IconButton(
                                        icon: Image.asset("images/Timer/timer_list.png"),
                                        splashRadius: 0.1,
                                        splashColor:Colors.transparent,
                                        onPressed: () {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MoodListPage()));
                                        }
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
                                  ),
                                  maxLines: 2,
                                ),
                              )
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

                                    if(rgbOnOff == "0"){
                                      fluttertoast("Please Switch On the device Above");
                                    }
                                    else{

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

                                    if(rgbOnOff == "0"){
                                      fluttertoast("Please Switch On the device Above");
                                    }
                                    else{
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
                                  icon: Image.asset('images/RGB/orange.png'),
                                  onPressed: () {

                                    if(rgbOnOff == "0"){
                                      fluttertoast("Please Switch On the device Above");
                                    }
                                    else{
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
                                  icon: Image.asset('images/RGB/blue.png'),
                                  onPressed: () {

                                    if(rgbOnOff == "0"){
                                      fluttertoast("Please Switch On the device Above");
                                    }
                                    else{

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
                                    }


                                  },
                                ),
                              ),

                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: IconButton(iconSize: MediaQuery.of(context).size.width / 10,
                                  icon: Image.asset('images/RGB/red.png'),
                                  onPressed: () {

                                    if(rgbOnOff == "0"){
                                      fluttertoast("Please Switch On the device Above");
                                    }
                                    else{

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

                                    if(rgbOnOff == "0"){
                                      fluttertoast("Please Switch On the device Above");
                                    }
                                    else{

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

                                    }

                                  },
                                ),
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

                                                if(rgbOnOff == "0"){

                                                  fluttertoast("Please switch on the Device");

                                                }
                                                else {

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

                                            if(rgbOnOff == "0"){
                                              fluttertoast("Please Switch On the device Above");
                                            }
                                            else{

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

                                            if(rgbOnOff == "0"){
                                              fluttertoast("Please Switch On the device Above");
                                            }
                                            else{

                                              setState(() {
                                                if (iSpeed > 121) {
                                                  iSpeed--;
                                                  iSpeed1 = iSpeed - 120;
                                                }
                                              });
                                              rgbSpeed = iSpeed.toString() + ","+
                                                  "000,000,000,A";
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
                                    flex: 7,
                                    child: Slider(value: myValue.toDouble(),


                                      onChanged: (value) {
                                        setState(() {


                                        });
                                      },
                                      min: 1,
                                      max: 10,

                                      onChangeEnd: (double value) {

                                        if(rgbOnOff == "0"){
                                          fluttertoast("Please Switch On the device Above");
                                        }
                                        else{
                                          myValue = value.toInt();
                                          int x = 130;
                                          int y = myValue + x;
                                          String slide = y.toString() + "," +
                                              "000,000,000,A";
                                          if (myValue < 1)
                                            myValue = 1;
                                          rgbBright = slide;
                                        }
                                        },
                                    ),
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        width: 50,
                                        height: 20,
                                        color: currentColor,
                                      )
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Container(

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

                                        if(rgbOnOff == "0"){
                                          fluttertoast("Please Switch On the device Above");
                                        }
                                        else{
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

                                        if(rgbOnOff == "0"){
                                          fluttertoast("Please Switch On the device Above");
                                        }
                                        else{
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

                                        if(rgbOnOff == "0"){
                                          fluttertoast("Please Switch On the device Above");
                                        }
                                        else{

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

                                        if(rgbOnOff == "0"){
                                          fluttertoast("Please Switch On the device Above");
                                        }
                                        else{

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
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(child: Text("  SAVE  ")),
                                  ),
                                ),
                                // ),
                                onPressed: () {


                                  saveRgb();
                                  print('Tapped');
                                },
                              ),
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
    );

  }

  Widget customSwitch1(bool status1, Function rgbOnOffStatus) {
    return CupertinoSwitch(

        activeColor: Colors.lightBlue,
        value: status, onChanged: (newValue){
      rgbOnOffStatus(newValue);
      print("vali1: $status");
    });
  }
  
  void rgbOnOffStatus(bool newStatus){

    setState((){
      status=newStatus;
      String rgbStatus = status ? "true":"false";
      if(rgbStatus == "true"){
        rgbOnOff="1";
      }
      else if(rgbStatus == "false"){
        rgbOnOff="0";
      }


    });
    
  }

  saveRgb()async{
    if(rgbOnOff==("0")){
      state="Off";
      onOffNum="0";
      swValueS="0";
      print("$state,$cData,$dData");
      int res = await mdb.update(MoodDBData(hnum: hnum,hname: hname,rnum: rnum,rname: rname, moodstno: number, moodstname: moodName, devicetype: "Null",devicemodel: ddevmodel,
          devicenum: dnum, onoffnum:rgbOnOff, devicedata: swValueS, aEdata: "Yes", bEdata:state,cEdata:cData,dEdata:dData,eEdata:eData,fEdata:fData,gEdata:gData,hEdata:hData,iEdata:iData,jEdata: jData));
      print(res);
      Navigator.of(context,rootNavigator: true).pop();
    }
    else{


      if(rgbColorEffect == "0" || rgbSpeed == "0" || rgbBright == "0"){
        print("$rgbColorEffect, $rgbSpeed, $rgbBright");
        fluttertoast("Select Required color or Special effects,Speed,Brightness");
      }
      else{

        state = "On";
        onOffNum = "1";
        print("values $rgbColorEffect,$rgbBright,$rgbSpeed");
        swValueS=rgbColorEffect+";"+rgbBright+";"+rgbSpeed;
        int res = await mdb.update(MoodDBData(hnum: hnum,hname: hname,rnum: rnum,rname: rname, moodstno: number, moodstname: moodName, devicetype: "Null",devicemodel: ddevmodel,
            devicenum: dnum, onoffnum:rgbOnOff, devicedata: swValueS, aEdata: "Yes", bEdata:state,cEdata:cData,dEdata:dData,eEdata:eData,fEdata:fData,gEdata:gData,hEdata:hData,iEdata:iData,jEdata: jData));
        print(res);

        Navigator.of(context,rootNavigator: true).pop();

      }


    }

  }

}


