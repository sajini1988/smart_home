import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/Singleton.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:smart_home/Timer/TimerFan.dart';
import 'package:smart_home/Timer/Timer_DFN1.dart';
import 'package:smart_home/Timer/Timer_S042.dart';
import 'package:smart_home/Timer/Timer_S051.dart';
import 'package:smart_home/Timer/Timer_S010.dart';
import 'package:smart_home/Timer/Timer_S020.dart';
import 'package:smart_home/Timer/Timer_S021.dart';
import 'package:smart_home/Timer/Timer_S030.dart';
import 'package:smart_home/Timer/Timer_S080.dart';
import 'package:smart_home/Timer/Timer_S110.dart';
import 'package:smart_home/Timer/Timer_S120.dart';
import 'package:smart_home/Timer/Timer_S141.dart';
import 'package:smart_home/Timer/Timer_S160.dart';
import 'package:week_of_year/week_of_year.dart';
import 'package:smart_home/Globaltimerdata.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:smart_home/Timer/PIRTimer.dart';
import 'package:smart_home/Timer/DoubleCurtainTimer.dart';
import 'package:smart_home/Timer/TimerList.dart';
import 'package:smart_home/Timer/RGBTimer.dart';


class Timerpage extends StatefulWidget{

  @override
  State<Timerpage> createState() => _TimerpageState();

}
class _TimerpageState extends State<Timerpage>{

  var s = Singleton();

  Image sunsatimg = Image.asset('images/Timer/sun_sat.png');
  Image monimg = Image.asset('images/Timer/m.png');
  Image tuethurimg = Image.asset('images/Timer/tue_thur.png');
  Image wedimg = Image.asset('images/Timer/w.png');
  Image friimg = Image.asset('images/Timer/f.png');

  Image sunsatimg1 = Image.asset('images/Timer/sun_sat01.png');
  Image monimg1 = Image.asset('images/Timer/m01.png');
  Image tuethurimg1 = Image.asset('images/Timer/tue_thur_01.png');
  Image wedimg1 = Image.asset('images/Timer/w01.png');
  Image friimg1 = Image.asset('images/Timer/f01.png');

  Image radio = Image.asset('images/PIR/radio.png');
  Image radio1 = Image.asset('images/PIR/radio01.png');

  Image checkbox = Image.asset('images/Timer/check_box.png');
  Image checkbox1 = Image.asset('images/Timer/check_box01.png');

  String fromTime,toTime,onTime,offTime,sDate,cDate;// To Send data to Timers

  String type; //rep or repd or cyc
  String status; //ins,upd,del

  //for cyclic operation
  int operationflag;
  int operationstartflag;
  int operationcompleteflag;

  bool sunday,monday,tuesday,wednesday,thursday,friday,saturday;
  bool rep,cyc,repd,repPattern;

  //to store all the ondata,offdataarray,switchnumbers in array

  List ondataarray=[];
  List offdataarray=[];
  List switchnumber=[];

  int _currentvalue1=1;
  int _currentvalue2=1;
  int _currentvalue3=1;
  int _currentvalue4=1;

  int _currentvalue5=4;
  int _currentvalue6=4;

  GlobalService _globalService = GlobalService();
  Globaltimer _globaltimer = Globaltimer();

  String hname,hnum,rnum,rname,dnum,devicemodel,devicemodelnum,devicename,deviceID,groupId;

  int sun=0,mon=0,tue=0,wed=0,thur=0,frid=0,sat=0;
  String repeat,repeatw;

  bool repVisible,cycVisible,dateVisible,repPatternVisible,setoperationvisible;

  int weeknumber;
  String cycOntime,cycOfftime;
  DateTime _chosenDateTime=DateTime.now();
  String datec,Date;
  DateFormat dateFormat;

  Color colorOn=Colors.black54,colorOff= Color.fromRGBO(211, 211, 211, 0.9);
  Color colorBoth1,colorBoth2,colorBoth3;
  Color colorNumberCyc,colorNumberDate;

  @override
  void initState() {

    // TODO: implement initState
    super.initState();

    colorBoth1=colorOn;
    colorBoth2=colorOff;
    colorBoth3=colorOff;

    colorNumberCyc=colorOff;
    colorNumberDate=colorOff;

    dateFormat = DateFormat("yyyy-M-d");

    type="rep";
    final date = DateTime.now();
    weeknumber = date.weekOfYear;

    print(date.weekOfYear); // Get the iso week of year
    print(date.ordinalDate); // Get the ordinal date
    print(date.isLeapYear); // Is this a leap year?

    String string = dateFormat.format(_chosenDateTime);
    List lis = string.split(" ");

    
    datec = lis[0];
    Date=lis[0];
    print(date);

    repeat=repeatw=weeknumber.toString();

    repVisible=true;
    repPatternVisible= true;
    cycVisible=true;
    dateVisible=true;

    sunday=false;
    monday=false;
    tuesday=false;
    wednesday=false;
    thursday=false;
    friday=false;
    saturday=false;

    rep=true;
    repd=false;
    cyc=false;
    repPattern=false;

    hname=_globalService.hname;
    hnum=_globalService.hnum;
    rnum=(_globalService.rnum).padLeft(2,'0');
    rname=_globalService.rname;
    dnum=_globalService.dnum;
    devicemodel=_globalService.ddevModel;
    devicemodelnum=_globalService.ddevModelNum;
    devicename=_globalService.devicename;
    deviceID=_globalService.deviceID;
    groupId=_globalService.groupId;

    print("$hname,$hnum,$rnum,$rname,$dnum,$devicename,$devicemodel,$deviceID,$devicemodelnum");

    sun=mon=tue=wed=thur=frid=sat=0;

    if(devicemodel=='S051'){
      setoperationvisible=true;
    }
    else if(devicemodel=='S010'){
      setoperationvisible=true;
    }
    else if(devicemodel == 'S020'){
      setoperationvisible=true;
    }
    else if(devicemodel == 'S021'){
      setoperationvisible=true;
    }
    else if(devicemodel == 'S030'){
      setoperationvisible=true;
    }
    else if(devicemodel == 'S080'){
      setoperationvisible=true;
    }
    else if(devicemodel == 'SLT1'){
      setoperationvisible=true;
    }
    else if(devicemodel == 'CLNR'){
      setoperationvisible=true;
    }
    else if(devicemodel == 'CLNRSH'){
      setoperationvisible=true;
    }
    else if(devicemodel == 'CLS1'){
      setoperationvisible=false;
    }
    else if(devicemodel == 'CRS1'){
      setoperationvisible=false;
    }
    else if(devicemodel == 'WPD1'){
      setoperationvisible=true;
    }
    else if(devicemodel == 'WPS1'){
      setoperationvisible=true;
    }
    else if(devicemodel == 'RGB1'){
      setoperationvisible=true;
    }
    else if(devicemodel == 'GSK1'){
      setoperationvisible = false;
    }
    else if(devicemodel == 'PSC1' || devicemodel == 'PLC1' || devicemodel == 'SWG1' || devicemodel == 'SLG1' || devicemodel == 'ACR1' || devicemodel == 'GSR1' || devicemodel == 'FMD1'){
      setoperationvisible = false;
    }
    else if(devicemodel == 'SDG1' || devicemodel == 'DLS1' || devicemodel == 'SOSH'){
      setoperationvisible = false;
    }
    else if(devicemodel == 'CLB1'){
      setoperationvisible = false;
    }

    setState(() {
      setoperationvisible=setoperationvisible;
    });

    setdatadevices();

  }

  setdatadevices(){
    
    if(devicemodel == 'PSC1'){
      sendonData("101", "01");
      sendoffData("102", "01");
      switchnumber.add("0");
    }
    else if(devicemodel == 'PLC1'){
      sendonData("201", "01");
      sendoffData("301", "01");
      switchnumber.add("0");
    }
    else if(devicemodel == 'GSK1'){
      sendonData("201", "01");
      sendoffData("301", "01");
      switchnumber.add("0");
    }

    else if(devicemodel == 'FMD1'){
      sendonData("201", "01");
      sendoffData("301", "01");
      switchnumber.add("0");
    }
    else if(devicemodel == 'SDG1'){
      sendonData("201", "01");
      sendoffData("301", "01");
      switchnumber.add("0");
    }
    else if(devicemodel == 'ACR1'){
      sendonData("201", "01");
      sendoffData("301", "01");
      switchnumber.add("0");
    }
    else if(devicemodel == 'GSR1'){
      sendonData("201", "01");
      sendoffData("301", "01");
      switchnumber.add("0");
    }
    else if(devicemodel == 'CLB1'){
      sendonData("201", "01");
      sendoffData("301", "01");
      switchnumber.add("0");
    }
    else if(devicemodel == "CLS1" || devicemodel == "CRS1" || devicemodel == "SWG1" || devicemodel == "SLG1" || devicemodel == "SOSH"){

      sendonData("101", "01");
      sendoffData("102", "01");
      switchnumber.add("0");

      print("$ondataarray,$offdataarray,$switchnumber");
      
    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dialog(

        // debugShowCheckedModeBanner: false,
        // home: Scaffold(
        //   body: Center(
        //       child:Container(
        //           width: MediaQuery.of(context).size.width,
        //           padding: EdgeInsets.all(0),
        //           color: Colors.white,


        elevation: 0,

        clipBehavior:Clip.antiAliasWithSaveLayer,
        insetPadding: EdgeInsets.all(30.0),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[

                      Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width/50),),
                      Expanded(
                        flex:1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex:2,
                              child:Visibility(
                                visible: setoperationvisible,
                                  child:Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex:1,
                                          child: Transform.scale(
                                            scale: 1.75,
                                            child: IconButton(
                                              icon: Image.asset("images/Timer/set_operation.png"),
                                              splashRadius: 0.1,
                                              splashColor:Colors.transparent,
                                              onPressed: () {

                                                if(devicemodel=="S051"){

                                                  showDialog(
                                                    barrierColor: Colors.black26,
                                                    context: context,
                                                    builder: (context) {
                                                      return S051TimerPage(
                                                          number: "0"
                                                      );
                                                    },
                                                  );

                                                }
                                              else if(devicemodel=="RGB1"){
                                                  // AlertDialog alert = AlertDialog(
                                                  //
                                                  //   elevation: 0,
                                                  //   contentPadding: EdgeInsets.zero,
                                                  //   titlePadding: EdgeInsets.zero,
                                                  //   title: Text(""),
                                                  //   shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),
                                                  //   content: Container(
                                                  //     width: MediaQuery.of(context).size.width*0.75,
                                                  //     child:RGBTimerPage(number: '0',),
                                                  //   ),
                                                  //   backgroundColor: Colors.transparent,
                                                  //   actions: [],
                                                  // );
                                                  // showDialog(context: context, builder: (BuildContext context) {
                                                  //   return alert;
                                                  // }
                                                  // );

                                                  showDialog(
                                                    barrierColor: Colors.black26,
                                                    context: context,
                                                    builder: (context) {
                                                      return RGBTimerPage(number: '0',);
                                                    },
                                                  );
                                              }
                                              else if(devicemodel=="S010" || devicemodel == "SLT1"){

                                                  showDialog(
                                                    barrierColor: Colors.black26,
                                                    context: context,
                                                    builder: (context) {
                                                      return TimerS010Page(number: '0',);
                                                    },
                                                  );

                                              }
                                              else if(devicemodel=="S020"){

                                                  showDialog(
                                                    barrierColor: Colors.black26,
                                                    context: context,
                                                    builder: (context) {
                                                      return TimerS020Page(number: '0',);
                                                    },
                                                  );



                                              }
                                              else if(devicemodel=="S021"){


                                                  showDialog(
                                                    barrierColor: Colors.black26,
                                                    context: context,
                                                    builder: (context) {
                                                      return TimerS021Page(
                                                          number: "0"
                                                      );
                                                    },
                                                  );

                                              }
                                              else if(devicemodel=="S030"){


                                                  showDialog(
                                                    barrierColor: Colors.black26,
                                                    context: context,
                                                    builder: (context) {
                                                      return TimerS030Page(
                                                          number: "0"
                                                      );
                                                    },
                                                  );

                                              }
                                              else if(devicemodel=="S080"){



                                                  showDialog(
                                                    barrierColor: Colors.black26,
                                                    context: context,
                                                    builder: (context) {
                                                      return TimerS080Page(
                                                          number: "0"
                                                      );
                                                    },
                                                  );
                                              }
                                              else if((devicemodel == "CLNRSH") || (devicemodel == "CLNR")){


                                                  showDialog(
                                                    barrierColor: Colors.black26,
                                                    context: context,
                                                    builder: (context) {
                                                      return TimerCurtainPage(number: '0',);
                                                    },
                                                  );

                                              }
                                              else if(devicemodel == "WPS1"){



                                                  showDialog(
                                                    barrierColor: Colors.black26,
                                                    context: context,
                                                    builder: (context) {
                                                      return TimerPIRPage(
                                                          number: "0"
                                                      );
                                                    },
                                                  );
                                              }
                                              else if(devicemodel == "WPD1"){



                                                  showDialog(
                                                    barrierColor: Colors.black26,
                                                    context: context,
                                                    builder: (context) {
                                                      return TimerPIRPage(
                                                          number: "0"
                                                      );
                                                    },
                                                  );
                                              }

                                                else if(devicemodel == "DFN1"){


                                                  showDialog(
                                                    barrierColor: Colors.black26,
                                                    context: context,
                                                    builder: (context) {
                                                      return TimerDFanPage(number: '0',);
                                                    },
                                                  );


                                                }
                                                else if(devicemodel == "S042"){

                                                  showDialog(
                                                    barrierColor: Colors.black26,
                                                    context: context,
                                                    builder: (context) {
                                                      return TimerS042Page(number: '0',);
                                                    },
                                                  );


                                                }
                                                else if(devicemodel == "S110"){

                                                  showDialog(
                                                    barrierColor: Colors.black26,
                                                    context: context,
                                                    builder: (context) {
                                                      return TimerS110Page(number: '0',);
                                                    },
                                                  );

                                                }
                                                else if(devicemodel == "S120"){


                                                  showDialog(
                                                    barrierColor: Colors.black26,
                                                    context: context,
                                                    builder: (context) {
                                                      return TimerS120Page(number: '0',);
                                                    },
                                                  );


                                                }
                                                else if(devicemodel == "S141"){

                                                  showDialog(
                                                    barrierColor: Colors.black26,
                                                    context: context,
                                                    builder: (context) {
                                                      return S141TimerPage(number: '0',);
                                                    },
                                                  );


                                                }
                                                else if(devicemodel == "S160"){

                                                  showDialog(
                                                    barrierColor: Colors.black26,
                                                    context: context,
                                                    builder: (context) {
                                                      return TimerS160Page(number: '0',);
                                                    },
                                                  );


                                                }
                                                else if(devicemodel == "SFN1"){

                                                  showDialog(
                                                    barrierColor: Colors.black26,
                                                    context: context,
                                                    builder: (context) {
                                                      return TimerFanPage(number: '0',);
                                                    },
                                                  );
                                                }
                                              }
                                            ),
                                          )
                                      ),
                                      Expanded(
                                        flex:1,
                                        child: Text("Set Operation",style:TextStyle(fontSize: 8))
                                      )
                                    ],
                                  )
                              ),
                            ),
                            Expanded(
                              flex:6,
                              child: Container(
                                child: Center(child: Text("TIMER",style: TextStyle(
                                    decoration: TextDecoration.underline,fontSize: 14.0
                                ),)),
                              ),
                            ),
                            Expanded(
                                flex:2,
                                child:Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        flex:1,
                                        child: Transform.scale(
                                          scale: 1.75,
                                          child: IconButton(
                                              icon: Image.asset("images/Timer/timer_list.png"),
                                              splashRadius: 0.1,
                                              splashColor:Colors.transparent,
                                              onPressed: () {
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => TimerList()));

                                              }
                                          ),
                                        )
                                    ),
                                    Expanded(
                                        flex:1,
                                        child: Text("Timer List",style:TextStyle(fontSize: 8))
                                    )
                                  ],
                                )
                            )
                          ],
                        ),
                      ),



                      Expanded(
                        flex:0,
                        child:Padding(
                          padding:EdgeInsets.fromLTRB(10, 5, 10, 8),
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex:5,
                              child: Center(
                                  child: Text("FROM")),
                            ),
                            Expanded(
                              flex:5,
                              child: Center(child: Text("TO")),
                            ),
                          ],
                        ),

                      ),),



                      Expanded(
                        flex:0,
                        child: Container(
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children:[
                              // Expanded(
                              //   flex:1,
                              //   child:Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //     children: [
                              //       Expanded(
                              //         flex:5,
                              //         child: Center(child: Text("FROM")),
                              //       ),
                              //       Expanded(
                              //         flex:5,
                              //         child: Center(child: Text("TO")),
                              //       ),
                              //   ],
                              //   )
                              // ),
                              Expanded(
                                  flex:1,
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [

                                      Expanded(
                                          flex:1,
                                          child:Container()
                                      ),
                                      Expanded(
                                        flex:1,
                                        child: NumberPicker(
                                          itemCount: 3,
                                          value: _currentvalue1,
                                          minValue: 00,
                                          maxValue: 23,
                                          zeroPad: true,
                                          step: 1,
                                          infiniteLoop: true,
                                          itemHeight: 22,
                                          itemWidth: 100,
                                          axis: Axis.vertical,
                                          haptics: false,
                                          textStyle: TextStyle(color: Colors.grey,fontSize: 13,fontWeight: FontWeight.w500,),
                                          decoration: BoxDecoration(
                                            //borderRadius: BorderRadius.circular(16),
                                            //border: Border.all(color: Colors.black26),
                                            border: Border(
                                                top:BorderSide(color: Colors.grey,width: 1),
                                                bottom: BorderSide(color: Colors.grey,width: 1)

                                            ),

                                          ),
                                          onChanged: (value) => setState(() => _currentvalue1 = value),
                                          selectedTextStyle:TextStyle(
                                            color: Color.fromRGBO( 66,130, 208,1),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13.0,
                                            fontStyle: FontStyle.normal,
                                          ),

                                        ),
                                      ),

                                      Expanded(
                                        flex:1,
                                        child:Center(child: Text(":"))
                                      ),
                                      Expanded(
                                        flex:1,
                                        child: NumberPicker(
                                          itemCount: 3,
                                          value: _currentvalue2,
                                          minValue: 00,
                                          maxValue: 59,
                                          zeroPad: true,
                                          step: 1,
                                          infiniteLoop: true,
                                          itemHeight: 22,
                                          itemWidth: 100,
                                          axis: Axis.vertical,
                                          haptics: false,
                                          textStyle: TextStyle(color: Colors.grey,fontSize: 13,fontWeight: FontWeight.w500,),
                                          decoration: BoxDecoration(
                                            //borderRadius: BorderRadius.circular(16),
                                            //border: Border.all(color: Colors.black26),
                                            border: Border(
                                                top:BorderSide(color: Colors.grey,width: 1),
                                                bottom: BorderSide(color: Colors.grey,width: 1)

                                            ),

                                          ),
                                          onChanged: (value) => setState(() => _currentvalue2 = value),
                                          selectedTextStyle:TextStyle(
                                            color: Color.fromRGBO( 66,130, 208,1),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                            fontStyle: FontStyle.normal,
                                          ),

                                        ),
                                      ),

                                      Expanded(
                                          flex:1,
                                          child:Container()
                                      ),

                                      Expanded(
                                        flex:1,
                                        child: NumberPicker(
                                          itemCount: 3,
                                          value: _currentvalue3,
                                          minValue: 00,
                                          maxValue: 24,
                                          zeroPad: true,
                                          step: 1,
                                          infiniteLoop: true,
                                          itemHeight: 22,
                                          itemWidth: 100,
                                          axis: Axis.vertical,
                                          haptics: false,
                                          textStyle: TextStyle(color: Colors.grey,fontSize: 13,fontWeight: FontWeight.w500,),
                                          decoration: BoxDecoration(
                                            //borderRadius: BorderRadius.circular(16),
                                            //border: Border.all(color: Colors.black26),
                                            border: Border(
                                                top:BorderSide(color: Colors.grey,width: 1),
                                                bottom: BorderSide(color: Colors.grey,width: 1)

                                            ),

                                          ),
                                          onChanged: (value) => setState(() => _currentvalue3 = value),
                                          selectedTextStyle:TextStyle(
                                            color: Color.fromRGBO( 66,130, 208,1),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.normal,
                                          ),

                                        ),
                                      ),
                                      Expanded(
                                          flex:1,
                                          child:Center(child: Text(":"))
                                      ),
                                      Expanded(
                                        flex:1,
                                        child: NumberPicker(
                                          itemCount: 3,
                                          value: _currentvalue4,
                                          minValue: 00,
                                          maxValue: 59,
                                          zeroPad: true,
                                          step: 1,
                                          infiniteLoop: true,
                                          itemHeight: 22,
                                          itemWidth: 100,
                                          axis: Axis.vertical, haptics: false,
                                          textStyle: TextStyle(color: Colors.grey,fontSize: 13,fontWeight: FontWeight.w500,),
                                          decoration: BoxDecoration(
                                            //borderRadius: BorderRadius.circular(16),
                                            //border: Border.all(color: Colors.black26),
                                            border: Border(
                                                top:BorderSide(color: Colors.grey,width: 1),
                                                bottom: BorderSide(color: Colors.grey,width: 1)

                                            ),

                                          ),
                                          onChanged: (value) => setState(() => _currentvalue4 = value),
                                          selectedTextStyle:TextStyle(
                                            color: Color.fromRGBO( 66,130, 208,1),
                                            fontSize: 13,fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.normal,
                                          ),

                                        ),
                                      ),
                                      Expanded(
                                          flex:1,
                                          child:Container()
                                      ),
                                    ],
                                  )
                              )
                            ],
                          ),
                        ),
                      ),

                      Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width/60),),

                      Expanded(
                        flex:1,
                        child:Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [

                              Expanded(
                                  flex:1,
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(padding: const EdgeInsets.fromLTRB(10,0,0,0),),

                                      Expanded(
                                        flex:1,
                                        child: Transform.scale(scale: 1.30,
                                          child: IconButton(
                                            //iconSize: MediaQuery.of(context).size.width/10,
                                            splashRadius: 5.0,
                                            splashColor:Colors.blue,
                                            icon:rep?radio1:radio,
                                            onPressed: (){
                                              if(rep == true){
                                               // rep=false;
                                                type="rep";
                                                status="ins";
                                                cyc=false;
                                                repd=false;
                                                repVisible=true;
                                                cycVisible=true;
                                                dateVisible=true;
                                                repPatternVisible=true;
                                              }
                                              else if(rep == false){
                                                type="rep";
                                                status="ins";
                                                rep=true;
                                                cyc=false;
                                                repd=false;
                                                repVisible=true;
                                                cycVisible=true;
                                                dateVisible=true;
                                                repPatternVisible=true;
                                              }

                                              colorBoth1=colorOn;
                                              colorBoth2=colorOff;
                                              colorBoth3=colorOff;

                                              colorNumberCyc=colorOff;
                                              colorNumberDate=colorOff;

                                              setState(() {
                                                rep=rep;
                                                cyc=cyc;
                                                repd=repd;
                                                repVisible=repVisible;
                                                cycVisible=cycVisible;
                                                dateVisible=dateVisible;
                                                repPatternVisible=repPatternVisible;
                                              });

                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex:9,
                                        child: Text("  REPEAT ON DAYS  ",style: TextStyle(
                                          color: colorBoth1
                                        ),),
                                      ),
                                    ],
                                  )
                              ),
                              Expanded(
                                  flex:1,
                                  child:Visibility(
                                    visible: repVisible,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: Container(),
                                        ),
                                        Expanded(
                                         // flex:1,
                                          child: Transform.scale(scale: 1.25,
                                              child: IconButton(
                                                //iconSize: MediaQuery.of(context).size.width/10,
                                                splashRadius: 5.0,
                                                splashColor:Colors.blue,
                                                icon:sunday?sunsatimg1:sunsatimg,
                                                onPressed: (){

                                                  setState(() {
                                                    if(sunday==false){
                                                      sunday=true;
                                                      sun=1;
                                                    }
                                                    else if(sunday == true){
                                                      sunday=false;
                                                      sun=0;
                                                    }
                                                  });

                                                },
                                              ),
                                          ),
                                      ),
                                      Expanded(
                                       // flex:1,
                                        child: Transform.scale(scale:1.25,
                                          child:IconButton(
                                           // iconSize: MediaQuery.of(context).size.width/10,
                                            splashRadius: 1.0,
                                            splashColor:Colors.blue,
                                            icon:monday?monimg1:monimg,
                                            onPressed: (){
                                              setState(() {
                                                if(monday==false){
                                                  monday=true;
                                                  mon=1;
                                                }
                                                else if(monday == true){
                                                  monday=false;
                                                  mon=0;
                                                }
                                              });
                                              },
                                          ),
                                        )
                                      ),
                                      Expanded(
                                       // flex:1,
                                        child: Transform.scale(scale:1.25,
                                         child: IconButton(
                                           // iconSize: MediaQuery.of(context).size.width/10,
                                            splashRadius: 1.0,
                                            splashColor:Colors.blue,
                                            icon:tuesday?tuethurimg1:tuethurimg,
                                            //Image.asset('images/Timer/tue_thur.png'),
                                            onPressed: (){
                                              setState(() {

                                                if(tuesday==false){
                                                  tuesday=true;
                                                  tue=1;
                                                }
                                                else if(tuesday == true){
                                                  tuesday=false;
                                                  tue=0;
                                                }

                                              });
                                            },
                                          ),
                                        )
                                      ),
                                      Expanded(
                                       // flex:1,
                                        child: Transform.scale(scale:1.25,
                                         child:
                                          IconButton(
                                            //iconSize: MediaQuery.of(context).size.width/10,
                                            splashRadius: 1.0,
                                            splashColor:Colors.blue,
                                            icon:wednesday?wedimg1:wedimg,
                                            onPressed: (){
                                                setState(() {
                                                  if(wednesday==false){
                                                    wednesday=true;
                                                    wed=1;
                                                  }
                                                  else if(wednesday == true){
                                                    wednesday=false;
                                                    wed=0;
                                                  }
                                                });
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                       // flex:1,
                                        child: Transform.scale(scale: 1.25,
                                          child:
                                          IconButton(
                                           // iconSize: MediaQuery.of(context).size.width/10,
                                            splashRadius: 1.0,
                                            splashColor:Colors.blue,
                                            icon:thursday?tuethurimg1:tuethurimg,
                                            onPressed: (){
                                              setState(() {
                                                if(thursday==true){
                                                  thursday=false;
                                                  thur=0;
                                                }
                                                else if(thursday==false){
                                                  thursday=true;
                                                  thur=1;
                                                }
                                              });
                                            },
                                        ),
                                        )
                                      ),
                                      Expanded(
                                       // flex:1,
                                        child: Transform.scale(scale:1.25,
                                          child:IconButton(
                                           // iconSize: MediaQuery.of(context).size.width/10,
                                            splashRadius: 1.0,

                                            splashColor:Colors.blue,
                                            icon:friday?friimg1:friimg,
                                            onPressed: (){
                                              setState(() {
                                                if(friday == false){
                                                  friday=true;
                                                  frid=1;
                                                }
                                                else if(friday == true){
                                                  friday=false;
                                                  frid=0;
                                                }
                                              });

                                            },
                                          ),
                                        )
                                      ),
                                      Expanded(
                                       // flex:1,
                                        child: Transform.scale(scale:1.25,
                                          child:
                                          IconButton(
                                            // iconSize: MediaQuery.of(context).size.width/10,
                                            splashRadius: 5.0,
                                            splashColor:Colors.blue,
                                            icon:saturday?sunsatimg1:sunsatimg,
                                            onPressed: (){
                                              setState(() {
                                                if(saturday == false){
                                                  saturday=true;
                                                  sat=1;
                                                }
                                                else if(saturday == true){
                                                  saturday=false;
                                                  sat=0;
                                                }
                                              });

                                            },
                                          ),
                                        ),
                                      ),
                                        Expanded(
                                          child: Container(),
                                        ),
                                    ],
                                  )
                                ),
                              )
                            ],
                          ),
                        )
                      ),
                      //Padding(padding: const EdgeInsets.all(2.0),),
                      Expanded(
                        flex:2,
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [

                              Expanded(
                                flex:1,
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [

                                    Padding(padding: const EdgeInsets.fromLTRB(10,0,0,0),),

                                    Expanded(
                                      flex:1,
                                      child: Transform.scale(scale:1.30,
                                        child:
                                        IconButton(
                                          // iconSize: MediaQuery.of(context).size.width/10,
                                          splashRadius: 5.0,
                                          splashColor:Colors.blue,
                                          icon:cyc?radio1:radio,
                                          onPressed: (){

                                            monday=tuesday=thursday=wednesday=thursday=friday=saturday=sunday=false;

                                            colorBoth1=colorOff;
                                            colorBoth2=colorOn;
                                            colorBoth3=colorOff;

                                            colorNumberCyc=Colors.blue;
                                            colorNumberDate=colorOff;


                                            if(cyc == true){
                                             // cyc=false;
                                              type="cyc";
                                              status="ins";
                                              rep=false;
                                              repd=false;
                                              cycVisible=true;
                                              repVisible=true;
                                              dateVisible=true;
                                              repPatternVisible=false;
                                            }
                                            else if(cyc == false){
                                              type="cyc";
                                              status="ins";
                                              cyc= true;
                                              rep=false;
                                              repd=false;
                                              cycVisible=true;
                                              repVisible=true;
                                              dateVisible=true;
                                              repPatternVisible=false;
                                            }
                                            setState(() {
                                              cyc=cyc;
                                              rep=rep;
                                              repd=repd;
                                              cycVisible=cycVisible;
                                              repVisible=repVisible;
                                              dateVisible=dateVisible;
                                              repPatternVisible=repPatternVisible;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex:9,
                                      child: Text("  CYCLIC  ",style: TextStyle(color: colorBoth2),),
                                    ),

                                  ]
                                ),
                              ),
                              Expanded(
                                flex:2,
                                child:Visibility(
                                  visible: cycVisible,
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        flex:2,
                                        child: Container(),
                                      ),
                                      Expanded(
                                        flex:2,
                                        child: Center(child: Text("ON TIME",style: TextStyle(color: colorBoth2),)),
                                      ),
                                      Expanded(
                                        flex:1,
                                        child: NumberPicker(
                                          itemCount: 3,
                                          value: _currentvalue5,
                                          minValue: 2,
                                          maxValue: 60,
                                          step: 2,
                                          zeroPad: false,
                                          infiniteLoop: true,
                                          itemHeight: 25,
                                          itemWidth: 100,
                                          textStyle: TextStyle(color: colorBoth2,fontSize: 13,fontWeight: FontWeight.w500,),
                                          selectedTextStyle:TextStyle(
                                            color: colorNumberCyc,
                                            fontSize: 13,fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.normal,
                                          ),

                                          decoration: BoxDecoration(
                                            //borderRadius: BorderRadius.circular(16),
                                            //border: Border.all(color: Colors.black26),
                                            border: Border(
                                                top:BorderSide(color: Colors.grey,width: 1),
                                                bottom: BorderSide(color: Colors.grey,width: 1)

                                            ),

                                          ),
                                          onChanged: (value) => setState(() => _currentvalue5 = value),

                                        ),
                                      ),

                                      Expanded(
                                        flex:1,
                                        child: Container(),
                                      ),


                                      Expanded(
                                        flex:2,
                                        child: Center(child: Text("OFF TIME",style: TextStyle(
                                          color: colorBoth2),)),
                                      ),
                                      Expanded(
                                        flex:1,
                                        child: NumberPicker(
                                          value: _currentvalue6,
                                          itemCount: 3,
                                          minValue: 2,
                                          maxValue: 60,
                                          step: 2,
                                          zeroPad: false,
                                          infiniteLoop: true,
                                          itemHeight: 25,
                                          itemWidth: 100,

                                          textStyle: TextStyle(
                                              color: colorBoth2,fontSize: 13,fontWeight: FontWeight.w500,
                                          ),
                                          selectedTextStyle:TextStyle(
                                            color: colorNumberCyc,
                                            fontSize: 13,fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.normal,
                                          ),

                                          decoration: BoxDecoration(
                                            //borderRadius: BorderRadius.circular(16),
                                            //border: Border.all(color: Colors.black26),
                                            border: Border(
                                                top:BorderSide(color: Colors.grey,width: 1),
                                                bottom: BorderSide(color: Colors.grey,width: 1)

                                            ),

                                          ),
                                          onChanged: (value) => setState(() => _currentvalue6 = value),

                                        ),
                                      ),

                                      Expanded(
                                        flex:2,
                                        child: Container(),
                                      )
                                    ]
                                  ),
                                )
                              )
                            ]
                          )
                        ),
                      ),
                      Expanded(
                        flex:2,
                        child: Container(
                          color: Colors.white,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    flex:1,
                                    child:Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [

                                          Padding(padding: const EdgeInsets.fromLTRB(10,0,0,0),),

                                          Expanded(
                                            flex:1,
                                            child: Transform.scale(scale:1.30,
                                              child:
                                              IconButton(
                                                // iconSize: MediaQuery.of(context).size.width/10,
                                                splashRadius: 5.0,
                                                splashColor:Colors.blue,
                                                icon:repd?radio1:radio,
                                                onPressed: (){

                                                  colorBoth1=colorOff;
                                                  colorBoth2=colorOff;
                                                  colorBoth3=colorOn;

                                                  colorNumberCyc=colorOff;
                                                  colorNumberDate=colorOn;

                                                  monday=tuesday=wednesday=thursday=friday=saturday=sunday=false;

                                                  if(repd == true){
                                                   // repd=false;
                                                    type="repd";
                                                    status="ins";
                                                    rep=false;
                                                    cyc=false;
                                                    dateVisible=true;
                                                    cycVisible=true;
                                                    repVisible=true;
                                                    repPatternVisible=true;
                                                  }
                                                  else{
                                                    type="repd";
                                                    status="ins";

                                                    repd=true;
                                                    cyc=false;
                                                    rep=false;
                                                    dateVisible=true;
                                                    cycVisible=true;
                                                    repVisible=true;
                                                    repPatternVisible=true;
                                                  }
                                                  setState(() {
                                                    repd=repd;
                                                    rep=rep;
                                                    cyc=cyc;
                                                    dateVisible=dateVisible;
                                                    cycVisible=cycVisible;
                                                    repVisible=repVisible;
                                                    repPatternVisible=repPatternVisible;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex:9,
                                            child: Text("  SELECTED DATE  ",style: TextStyle(
                                              color: colorBoth3
                                            ),),
                                          ),
                                        ]
                                    ),
                                  ),

                                  Expanded(
                                    flex:2,
                                    child:Visibility(
                                      visible: dateVisible,
                                      child:Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            flex:1,
                                            child: Container(),
                                          ),
                                          Expanded(
                                            flex:8,

                                              child:CupertinoTheme(
                                                data: CupertinoThemeData(
                                                  brightness: Brightness.light,
                                                  textTheme: CupertinoTextThemeData(


                                                    dateTimePickerTextStyle: TextStyle(
                                                        fontSize: 16,
                                                        color: colorNumberDate
                                                    ),
                                                    //primaryColor: Colors.blue
                                                    // pickerTextStyle: TextStyle(
                                                    //   color: Colors.blue,
                                                    // ),
                                                  ),
                                                ),
                                                child: CupertinoDatePicker(
                                                  mode:CupertinoDatePickerMode.date,
                                                  initialDateTime: DateTime.now(),
                                                  onDateTimeChanged: (val) {
                                                    _chosenDateTime = val;
                                                    String string = dateFormat.format(_chosenDateTime);
                                                    print(string);
                                                    List lis = string.split(" ");
                                                    Date = lis[0];
                                                    setState(() {
                                                      Date=Date;
                                                    });

                                                  },
                                                ),
                                              )
                                            // child:DefaultTextStyle.merge(
                                            //   style:TextStyle(fontSize: 5),
                                            //   child: CupertinoDatePicker(
                                            //       mode:CupertinoDatePickerMode.date,
                                            //       initialDateTime: DateTime.now(),
                                            //       onDateTimeChanged: (val) {
                                            //         _chosenDateTime = val;
                                            //         String string = dateFormat.format(_chosenDateTime);
                                            //         print(_chosenDateTime);
                                            //         List lis = string.split(" ");
                                            //         Date = lis[0];
                                            //         setState(() {
                                            //             Date=Date;
                                            //         });
                                            //       }),
                                            // )
                                          ),
                                          Expanded(
                                            flex:1,
                                            child: Container(),
                                          ),

                                        ]
                                      ),
                                    )
                                  )
                                ]
                            )
                        ),
                      ),
                      Expanded(
                        flex:2,
                        child: Container(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                 Expanded(
                                   flex:1,
                                      child:Visibility(
                                        visible: repPatternVisible,
                                        child:Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                flex:2,
                                                child: Transform.scale(scale:0.75,
                                                 child: IconButton(
                                                // iconSize: MediaQuery.of(context).size.width/10,
                                                  splashRadius: 5.0,
                                                  splashColor:Colors.blue,
                                                  icon:repPattern?checkbox1:checkbox,
                                                  onPressed: (){

                                                  if(repPattern == true){
                                                    repPattern=false;
                                                    repeat=repeatw;
                                                  }
                                                  else if (repPattern == false){
                                                    repPattern=true;
                                                    repeat="0";
                                                  }

                                                  setState(() {
                                                    repPattern=repPattern;
                                                  });
                                                },
                                               ),
                                              ),
                                          ),

                                          Expanded(
                                            flex:8,
                                            child: Text("Repeat Pattern"),
                                        ),
                                        ]
                                      ),
                                      )
                                 ),
                                Expanded(
                                  flex:1,
                                  child:Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [

                                        ElevatedButton(
                                          // padding: EdgeInsets.all(5.0),
                                          // textColor: Colors.white,
                                          // // splashColor: Colors.greenAccent,
                                          // elevation: 8.0,
                                          // child: Container(
                                          //   decoration: BoxDecoration(
                                          //     image: DecorationImage(
                                          //         image: AssetImage('images/Moods/save_button.png'),
                                          //         fit: BoxFit.fill),
                                          //   ),
                                          //   child: Padding(
                                          //     padding: const EdgeInsets.all(10.0),
                                          //     child: Text("CANCEL"),
                                          //   ),
                                          // ),
                                          // // ),

                                          child: Text('CANCEL'),
                                          style: ElevatedButton.styleFrom(
                                              primary: Color.fromRGBO(66, 130, 208, 1),
                                              shape: StadiumBorder()
                                          ),
                                          onPressed: () {

                                            Navigator.pop(context);
                                            print('Tapped');
                                          },
                                        ),
                                        ElevatedButton(
                                          // padding: EdgeInsets.all(8.0),
                                          // textColor: Colors.white,
                                          // // splashColor: Colors.greenAccent,
                                          // elevation: 8.0,
                                          // child: Container(
                                          //   decoration: BoxDecoration(
                                          //     image: DecorationImage(
                                          //         image: AssetImage('images/Moods/save_button.png'),
                                          //         fit: BoxFit.fill),
                                          //   ),
                                          //   child: Padding(
                                          //     padding: const EdgeInsets.all(8.0),
                                          //     child: Center(child: Text("SET TIMER")),
                                          //   ),
                                          // ),
                                          // // ),

                                          child: Text('SET TIMER'),
                                          style: ElevatedButton.styleFrom(
                                              primary: Color.fromRGBO(66, 130, 208, 1),
                                              shape: StadiumBorder()
                                          ),
                                          onPressed: () async {

                                            print(_globalService.modeltype);



                                            if(_globalService.modeltype == "SWB" || _globalService.modeltype == 'PIR' || _globalService.modeltype=="RGB"){

                                              ondataarray=_globaltimer.ondataarray;
                                              offdataarray=_globaltimer.offdataarray;
                                              switchnumber=_globaltimer.switchnumber;

                                            }

                                            if(_globalService.ddevModel == "CLNR" || _globalService.ddevModel=="CLNRSH"){

                                              print("clnr2");

                                              ondataarray=_globaltimer.ondataarray;
                                              offdataarray=_globaltimer.offdataarray;
                                              switchnumber=_globaltimer.switchnumber;

                                            }

                                            String t1='0',t2='0',t3,t4;

                                              print(type);
                                              print(repeat);

                                              if(_currentvalue3==24){
                                                _currentvalue4=00;
                                              }

                                              fromTime=(_currentvalue1.toString()).padLeft(2,'0')+":"+(_currentvalue2.toString()).padLeft(2,'0');
                                              toTime=(_currentvalue3.toString()).padLeft(2,'0')+":"+(_currentvalue4.toString()).padLeft(2,'0');

                                              print("$fromTime,$toTime");
                                              print(ondataarray.length);

                                              if(ondataarray.length==0){
                                                print("Please select the Operation");
                                                fluttertoast("Please select the Operation");
                                              }
                                              else{
                                                if(fromTime==toTime){
                                                  print("From Time and To Time should not be same");
                                                  fluttertoast("From Time and To Time should not be same");
                                                }
                                                else if((fromTime=="00:00") && (toTime=="24:00")){
                                                  print("From Time and To Time should not be same");
                                                  fluttertoast("From Time and To Time should not be same");
                                                }
                                                else if((toTime == "00:00")){
                                                  print("Set Timers properly");
                                                  fluttertoast("Set Timers Properly");
                                                }
                                                else{

                                                  if(type.length==0){
                                                    print("Select Type");
                                                    fluttertoast("Select Type");
                                                  }
                                                  else{



                                                    print(ondataarray);
                                                    print(offdataarray);
                                                    print(switchnumber);

                                                    for(int i=0;i<ondataarray.length;i++){

                                                      print(i);

                                                      if (type == 'cyc') {
                                                          operationflag = 1;
                                                          operationstartflag = 0;
                                                          operationcompleteflag = 0;

                                                          print(datec);

                                                          cycOntime = "00" + ":" + (_currentvalue5.toString()).padLeft(2, '0');
                                                          cycOfftime = "00" + ":" + (_currentvalue6.toString()).padLeft(2, '0');

                                                          String data = fromTime+","+toTime+","+cycOntime+","+cycOfftime+","+fromTime+","+datec+","+operationflag.toString()+","+operationstartflag.toString()+","+operationcompleteflag.toString()+","+devicemodel+","+ondataarray[i]+","+offdataarray[i]+","+devicemodelnum+","+dnum+","+deviceID+","+switchnumber[i]+","+rnum+","+devicename;
                                                          String senddata = "["+data+"!";
                                                          print(senddata);

                                                          if(s.socketconnected==true){
                                                            s.socket1(senddata);

                                                          }
                                                          else {
                                                            fluttertoast("Not connected");
                                                          }
                                                      }
                                                      else if (type == 'rep') {
                                                          t3 = "1";
                                                          t4 = "0";
                                                          String daterep = "0000-00-00";

                                                          print("s");
                                                          print(switchnumber[i]);

                                                          String data = t1+","+t2+","+t3+","+t4+","+daterep+","+fromTime+","+toTime+","+t1+","+mon.toString()+","+tue.toString()+","+wed.toString()+","+thur.toString()+","+frid.toString()+","+sat.toString()+","+sun.toString()+","+repeat+","+devicemodel+","+ondataarray[i]+","+offdataarray[i]+","+devicemodelnum+","+dnum+","+deviceID+","+switchnumber[i]+","+rnum+","+devicename;
                                                          String senddata = "["+data+']';
                                                          print(senddata);

                                                          if(s.socketconnected==true) {
                                                            s.socket1(senddata);

                                                          }
                                                          else {
                                                            fluttertoast("Not connected");
                                                          }

                                                      }
                                                      else if (type == 'repd') {
                                                          print(Date);
                                                          mon = tue = wed =thur = frid = sat = sun = 0;
                                                          t3 = "0";
                                                          t4 = "1";

                                                          String data = t1+","+t2+","+t3+","+t4+","+Date+","+fromTime+","+toTime+","+t1+","+mon.toString()+","+tue.toString()+","+wed.toString()+","+thur.toString()+","+frid.toString()+","+sat.toString()+","+sun.toString()+","+repeat+","+devicemodel+","+ondataarray[i]+","+offdataarray[i]+","+devicemodelnum+","+dnum+","+deviceID+","+switchnumber[i]+","+rnum+","+devicename;
                                                          String senddata = "["+data+"]";
                                                          print(senddata);

                                                          if(s.socketconnected==true){
                                                            s.socket1(senddata);

                                                          }
                                                          else {
                                                            fluttertoast("Not connected");
                                                          }
                                                      }
                                                      await Future.delayed(const Duration(seconds: 1));
                                                    }
                                                    Navigator.pop(context,true);
                                                  }
                                                }

                                              }
                                            },
                                        ),
                                      ]
                                  ),
                                ),
                              ]

                          ),
                        ),
                      ),

                      Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width/30),)


                    ],

                  )


            );
    //       )
    //     )
    // );
  }


  sendonData(String senddata,String casttype){

    String cast1 = casttype;
    String gI = "000";
    String c = dnum.padLeft(4, '0');
    String rN = rnum.padLeft(2, '0');
    String chr = senddata;
    String cE = "000000000000003";

    String a="0";
    String sData = a + cast1 + gI + c + rN + chr + cE ;
    print("Sending String is : $sData"); //is : *001000000102920000000000000000# output is : 003300010100FFFFFFFFA120F001B3

    ondataarray.add(sData);

  }

  sendoffData(String senddata,String casttype){

    String cast1 = casttype;
    String gI = "000";
    String c = dnum.padLeft(4, '0');
    String rN = rnum.padLeft(2, '0');
    String chr = senddata;
    String cE = "000000000000003";

    String a="0";
    String sData = a + cast1 + gI + c + rN + chr + cE ;
    print("Sending String is : $sData"); //// input is : *001000000102920000000000000000# output is : 003300010100FFFFFFFFA120F001B3

    offdataarray.add(sData);

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





}
