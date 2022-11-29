import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/Singleton.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:week_of_year/week_of_year.dart';
import 'package:intl/intl.dart';
import 'package:smart_home/Timer/PIRTimer.dart';
import 'package:smart_home/Timer/DoubleCurtainTimer.dart';
import 'package:smart_home/Timer/GlobalEditTimerListdata.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/Timer/TimerFan.dart';

class EditTimerPage extends StatefulWidget{
  @override
  State<EditTimerPage> createState() => _EditTimerPageState();
}

class _EditTimerPageState extends State<EditTimerPage> {

  var s = Singleton();

  GlobalEdittimer _globalServiceEditTimer = GlobalEdittimer();

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


  String fromTime,toTime;// To Send data to Timers
  String type,dvnum,modeltype,modeltypenum,switchno,repeatweekly,devicename,user,deviceID,onData,offData,repdate,days;
  String typeset,typeselec,typesend;

  //for cyclic operation
  int operationflag;
  int operationstartflag;
  int operationcompleteflag;

  bool sunday,monday,tuesday,wednesday,thursday,friday,saturday;
  bool rep,cyc,repd,_reppattern;

  String hname,hnum,rnum,rname;
  int sun,mon,tue,wed,thur,frid,sat;
  String repeat,repeatw;

  bool _repvisible,_cycvisible,_datevisible,_reppatternvisible,setoperationvisible;

  int weeknumber;

  String _cycontime,_cycofftime;
  DateTime _chosenDateTime=DateTime.now();
  String datec,date;
  DateFormat dateFormat;

  int _currentvalue1=1;
  int _currentvalue2=1;
  int _currentvalue3=1;
  int _currentvalue4=1;

  int _currentvalue5=4;
  int _currentvalue6=4;

  DateTime newDateTime;

  @override
  void initState() {
    super.initState();

    type = _globalServiceEditTimer.operatedType;
    modeltype = _globalServiceEditTimer.devicetype;
    modeltypenum = _globalServiceEditTimer.devicetypenum;
    switchno = _globalServiceEditTimer.switchnumber;
    days = _globalServiceEditTimer.dayssu;
    repeatweekly = _globalServiceEditTimer.repeatweekly;
    onData = _globalServiceEditTimer.ondata;
    offData = _globalServiceEditTimer.offdata;
    dvnum = _globalServiceEditTimer.dvnum;
    deviceID = _globalServiceEditTimer.deviceID;
    devicename = _globalServiceEditTimer.devicename;
    user = _globalServiceEditTimer.user;
    rnum= _globalServiceEditTimer.roomno;


    fromTime = _globalServiceEditTimer.fromtime;
    List<String> fromtimesplit = fromTime.split(":");
    String fromTime1 = fromtimesplit[0];
    String fromTime2 = fromtimesplit[1];

    toTime = _globalServiceEditTimer.totime;
    List<String> totimesplit = toTime.split(":");
    String toTime1 = totimesplit[0];
    String toTime2 = totimesplit[1];

    _currentvalue1 = int.parse(fromTime1);
    _currentvalue2 = int.parse(fromTime2);

    _currentvalue3 = int.parse(toTime1);
    _currentvalue4 = int.parse(toTime2);


    if (modeltype == "RGB1") {
      setoperationvisible = true;
    }
    else if (modeltype == "DMR1") {
      setoperationvisible = true;
    }
    else if ((modeltype == "S051") && (switchno == "98")) {
      setoperationvisible = true;
    }
    else if ((modeltype == "S021") && (switchno == "98")) {
      setoperationvisible = true;
    }
    else if ((modeltype == "WPS1") || (modeltype == "WPD1")) {
      setoperationvisible = true;
    }
    else if (modeltype == "CLNRSH") {
      setoperationvisible = true;
    }
    else if (modeltype == "CLNR") {
      setoperationvisible = true;
    }
    else {
      setoperationvisible = false;
    }

    dateFormat = DateFormat("yyyy-M-d");
    String string = dateFormat.format(_chosenDateTime);
    List lis = string.split(" ");

    datec = lis[0];
    date = lis[0];
    print(date);


    final date1 = newDateTime = DateTime.now();
    weeknumber = date1.weekOfYear;
    String weeknumber1 = ((weeknumber.toString()).length) == 1 ? ("0" +
        weeknumber.toString()) : weeknumber.toString();
    repeat = repeatw = weeknumber1;

    callFunction();

  }

  callFunction() {

    setState(() {

      if(type=="Days"){

        typeset=typesend="rep";
        _repvisible=true;
        _reppatternvisible=true;
        _cycvisible=false;
        _datevisible=false;
        rep=true;
        repd=false;
        cyc=false;

        List<String> daySplitValues = days.split(",");
        String mv = daySplitValues[0];
        String tv = daySplitValues[1];
        String wv = daySplitValues[2];
        String thv = daySplitValues[3];
        String friV = daySplitValues[4];
        String satV = daySplitValues[5];
        String sunDv= daySplitValues[6];

        if(mv=="0"){
          monday=false;
          mon=0;
        }
        else{
          monday=true;
          mon=1;
        }

        if(tv=="0"){
          tuesday=false;
          tue=0;
        }
        else{
          tuesday=true;
          tue=1;
        }

        if(wv=="0"){
          wednesday=false;
          wed=0;
        }else{
          wednesday=true;
          wed=1;
        }

        if(thv == "0"){
          thursday=false;
          thur=0;
        }
        else{
          thursday=true;
          thur=1;
        }

        if(friV == "0"){
          friday=false;
          frid=0;
        }
        else{
          friday=true;
          frid=1;
        }

        if(satV == "0"){
          saturday=false;
          sat=0;
        }
        else{
          saturday=true;
          sat=1;
        }

        if(sunDv == "0"){
          sunday=false;
          sun=0;
        }
        else {
          sunday = true;
          sun=1;
        }

        if(repeatweekly=="0"){
          _reppattern=true;
          repeat="0";
        }
        else{
          _reppattern=false;
          repeat=repeatw;
        }

      }
      else if(type == "Date"){

        typeset=typesend="repd";
        sunday=monday=tuesday=wednesday=thursday=friday=saturday=sunday=false;
        mon=tue=wed=thur=frid=sat=sun=0;
        repdate = _globalServiceEditTimer.date;
        List<String> datesplitvalues = repdate.split("-");
        int year = int.parse(datesplitvalues[0]);
        int month = int.parse(datesplitvalues[1]);
        int dates = int.parse(datesplitvalues[2]);

        newDateTime=DateTime(year,month,dates);

        _repvisible=false;
        _reppatternvisible=true;
        _cycvisible=false;
        _datevisible=true;
        rep=false;
        repd=true;
        cyc=false;

        if(repeatweekly=="0"){
          _reppattern=true;
          repeat="0";
        }
        else{
          _reppattern=false;
          repeat=repeatw;
        }
      }
      else if(type == "Cyclic"){

        typeset=typesend="cyc";
        _repvisible=false;
        _reppatternvisible=false;
        _cycvisible=true;
        _datevisible=false;
        rep=false;
        repd=false;
        cyc=true;
        _reppattern=false;
        repeat=repeatw;

        sunday=monday=tuesday=wednesday=thursday=friday=saturday=sunday=false;
        mon=tue=wed=thur=frid=sat=sun=0;

        _cycontime = _globalServiceEditTimer.ontime;
        _cycofftime = _globalServiceEditTimer.offtime;

        List<String> ontimesplit = _cycontime.split(":");
        String sttime = ontimesplit[1];

        List<String> totimesplit = _cycofftime.split(":");
        String endtime= totimesplit[1];

        _currentvalue1 = int.parse(sttime);
        _currentvalue2 = int.parse(endtime);

      }

    });


  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      home: Scaffold(
        body:Center(
          child:Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child:Column(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex:1,
                    child: Container(
                      color: Colors.white,
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex:2,
                              child: Visibility(
                                visible: setoperationvisible,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                  Expanded(
                                    flex:1,
                                    child: Transform.scale(
                                      scale: 1.5,
                                      child: IconButton(
                                        icon:Image.asset("images/Timer/set_operation.png"),
                                        splashColor: Colors.transparent,
                                        splashRadius: 0.1,
                                        onPressed: (){
                                          if(modeltype == "WPS1" || modeltype == "WPD1"){

                                            AlertDialog alert = AlertDialog(

                                              elevation: 0,
                                              //insetPadding: EdgeInsets.zero,
                                              // contentPadding: EdgeInsets.zero,
                                              //clipBehavior: Clip.antiAliasWithSaveLayer,

                                              contentPadding: EdgeInsets.zero,
                                              titlePadding: EdgeInsets.zero,
                                              backgroundColor: Colors.transparent,

                                              title: Text(""),
                                              content: Container(
                                                width: MediaQuery.of(context).size.width*0.75,
                                                child: TimerPIRPage(number: "1"),
                                              ),
                                              actions: [],
                                            );
                                            showDialog(context: context, builder: (BuildContext context) {
                                              return alert;
                                            }
                                            );
                                          }
                                          else if (((modeltype == "S051") && (switchno == "98")) || ((modeltype == "S051") && (switchno == "98"))) {

                                            AlertDialog alert = AlertDialog(

                                              elevation: 0,
                                              //insetPadding: EdgeInsets.zero,
                                              // contentPadding: EdgeInsets.zero,
                                              //clipBehavior: Clip.antiAliasWithSaveLayer,

                                              contentPadding: EdgeInsets.zero,
                                              titlePadding: EdgeInsets.zero,
                                              backgroundColor: Colors.transparent,

                                              title: Text(""),
                                              content: Container(
                                                  width: MediaQuery.of(context).size.width*0.75,
                                                  child: TimerFanPage(number: "1"),
                                                ),
                                              actions: [],
                                            );
                                            showDialog(context: context, builder: (BuildContext context) {
                                              return alert;
                                            }
                                            );
                                          }
                                          else if((modeltype == "CLNR") || (modeltype == "CLNRSH")){

                                            AlertDialog alert = AlertDialog(

                                              elevation: 0,
                                              //insetPadding: EdgeInsets.zero,
                                              // contentPadding: EdgeInsets.zero,
                                              //clipBehavior: Clip.antiAliasWithSaveLayer,

                                              contentPadding: EdgeInsets.zero,
                                              titlePadding: EdgeInsets.zero,
                                              backgroundColor: Colors.transparent,

                                              title: Text(""),
                                              content: Container(
                                                width: MediaQuery.of(context).size.width*0.75,
                                                child: TimerCurtainPage(number: "1"),
                                              ),
                                              actions: [],
                                            );
                                            showDialog(context: context, builder: (BuildContext context) {
                                              return alert;
                                            }
                                          );


                                          }



                                }
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex:1,
                                    child: Text("Set Operation",style:TextStyle(fontSize: 8))
                                  )
                                ],
                            ),
                          ),
                        ),
                          Expanded(
                          flex:6,
                            child: Container(
                              child: Center(child: Text("TIMER")),
                          ),
                        ),
                          Expanded(
                          flex:2,
                          child: Container(),
                        )
                      ],
                      )
                    ),
                  ),

                 // Spacer(),

                  Expanded(
                    flex:1,
                    child: Container(
                      color: Colors.grey,
                      child:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          Expanded(
                          flex:1,
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex:5,
                                child:Center(child: Text("FROM")),
                              ),
                              Expanded(
                                flex:5,
                                child: Center(child: Text("TO")),
                              ),
                            ],
                          )
                          ),],
                      ),
                    ),
                  ),

                  Expanded(
                    flex:2,
                    child: Container(
                      color: Colors.white,
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              flex:1,
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [

                                  Expanded(
                                    flex:2,
                                    child: NumberPicker(
                                      value: _currentvalue1,
                                      minValue: 00,
                                      maxValue: 23,
                                      zeroPad: true,
                                      onChanged: (value) =>setState(() => _currentvalue1 = value),
                                      selectedTextStyle: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex:1,
                                      child:Center(child: Text(":"))
                                  ),
                                  Expanded(
                                    flex:2,
                                    child: NumberPicker(
                                      value: _currentvalue2,
                                      minValue: 00,
                                      maxValue: 59,
                                      zeroPad: true,
                                      onChanged: (value) => setState(() => _currentvalue2 = value),
                                      selectedTextStyle:TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        //fontSize: 5.0,
                                        fontStyle: FontStyle.normal,
                                      ),

                                    ),
                                  ),

                                  Expanded(
                                    flex:2,
                                    child: NumberPicker(
                                      value: _currentvalue3,
                                      minValue: 00,
                                      maxValue: 24,
                                      zeroPad: true,
                                      onChanged: (value) => setState(() => _currentvalue3 = value),
                                      selectedTextStyle:TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        //fontSize: 5.0,
                                        fontStyle: FontStyle.normal,
                                      ),

                                    ),
                                  ),
                                  Expanded(
                                      flex:1,
                                      child:Center(child: Text(":"))
                                  ),
                                  Expanded(
                                    flex:2,
                                    child: NumberPicker(
                                      value: _currentvalue4,
                                      minValue: 00,
                                      maxValue: 59,
                                      zeroPad: true,
                                      infiniteLoop: false,
                                      haptics: false,
                                      selectedTextStyle:TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        //fontSize: 5.0,
                                        fontStyle: FontStyle.normal,
                                      ),
                                      onChanged: (value) => setState(() => _currentvalue4 = value),
                                    ),
                                  ),

                                ],
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
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

                                    Expanded(
                                      flex:1,
                                      child: Transform.scale(scale: 1.5,
                                        child: IconButton(
                                          //iconSize: MediaQuery.of(context).size.width/10,
                                          splashRadius: 5.0,
                                          splashColor:Colors.blue,
                                          icon:rep?radio1:radio,
                                          onPressed: (){

                                            typeselec="rep";
                                            type="Days";

                                            if(typeset=="cyc" && typeselec == "rep"){
                                              typesend="cyc_rep";
                                            }
                                            else if(typeset == "repd" && typeselec == "rep"){
                                              typesend="repd_rep";
                                            }
                                            else if(typeset == "rep" && typeselec == "rep"){
                                              typesend="rep";
                                            }

                                            if(rep == true){
                                              // rep=false;

                                              cyc=false;
                                              repd=false;
                                              _repvisible=true;
                                              _cycvisible=false;
                                              _datevisible=false;
                                              _reppatternvisible=true;
                                            }
                                            else if(rep == false){


                                              rep=true;
                                              cyc=false;
                                              repd=false;
                                              _repvisible=true;
                                              _cycvisible=false;
                                              _datevisible=false;
                                              _reppatternvisible=true;
                                            }
                                            setState(() {
                                              rep=rep;
                                              cyc=cyc;
                                              repd=repd;
                                              _repvisible=_repvisible;
                                              _cycvisible=_cycvisible;
                                              _datevisible=_datevisible;
                                              _reppatternvisible=_reppatternvisible;
                                            });

                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex:9,
                                      child: Text("REPEAT ON DAYS"),
                                    ),
                                  ],
                                )
                            ),
                            Expanded(
                              flex:1,
                              child:Visibility(
                                  visible: _repvisible,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        // flex:1,
                                        child: Transform.scale(scale: 1.5,
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
                                          child: Transform.scale(scale:1.5,
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
                                          child: Transform.scale(scale:1.5,
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
                                        child: Transform.scale(scale:1.5,
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
                                          child: Transform.scale(scale: 1.5,
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
                                          child: Transform.scale(scale:1.5,
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
                                        child: Transform.scale(scale:1.5,
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
                                      )
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

                                      Expanded(
                                        flex:1,
                                        child: Transform.scale(scale:1.5,
                                          child:
                                          IconButton(
                                            // iconSize: MediaQuery.of(context).size.width/10,
                                            splashRadius: 5.0,
                                            splashColor:Colors.blue,
                                            icon:cyc?radio1:radio,
                                            onPressed: (){

                                              type="Cyclic";
                                              typeselec="cyc";

                                              if(typeset=="cyc" && typeselec == "cyc"){
                                                typesend="cyc";
                                              }
                                              else if(typeset == "repd" && typeselec == "cyc"){
                                                typesend="repd_cyc";
                                              }
                                              else if(typeset == "rep" && typeselec == "cyc"){
                                                typesend="rep_cyc";
                                              }

                                              if(cyc == true){
                                                // cyc=false;
                                                rep=false;
                                                repd=false;
                                                _cycvisible=true;
                                                _repvisible=false;
                                                _datevisible=false;
                                                _reppatternvisible=false;
                                              }
                                              else if(cyc == false){

                                                cyc= true;
                                                rep=false;
                                                repd=false;
                                                _cycvisible=true;
                                                _repvisible=false;
                                                _datevisible=false;
                                                _reppatternvisible=false;
                                              }
                                              setState(() {
                                                cyc=cyc;
                                                rep=rep;
                                                repd=repd;
                                                _cycvisible=_cycvisible;
                                                _repvisible=_repvisible;
                                                _datevisible=_datevisible;
                                                _reppatternvisible=_reppatternvisible;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex:9,
                                        child: Text("CYCLIC"),
                                      ),

                                    ]
                                ),
                              ),
                              Expanded(
                                  flex:2,
                                  child:Visibility(
                                    visible: _cycvisible,
                                    child:Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            flex:2,
                                            child: Text("ON TIME"),
                                          ),
                                          Expanded(
                                            flex:2,
                                            child: NumberPicker(
                                              itemCount: 3,
                                              value: _currentvalue5,
                                              minValue: 2,
                                              maxValue: 60,
                                              step: 2,
                                              zeroPad: false,
                                              selectedTextStyle:TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                //fontSize: 5.0,
                                                fontStyle: FontStyle.normal,
                                              ),
                                              onChanged: (value) => setState(() => _currentvalue5 = value),

                                            ),
                                          ),
                                          Expanded(
                                            flex:2,
                                            child: Text("OFF TIME"),
                                          ),
                                          Expanded(
                                            flex:2,
                                            child: NumberPicker(
                                              value: _currentvalue6,
                                              itemCount: 3,
                                              minValue: 2,
                                              maxValue: 60,
                                              step: 2,
                                              zeroPad: false,
                                              selectedTextStyle:TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                //fontSize: 5.0,
                                                fontStyle: FontStyle.normal,
                                              ),
                                              onChanged: (value) => setState(() => _currentvalue6 = value),

                                            ),
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
                        color: Colors.white,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex:1,
                                child:Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [

                                      Expanded(
                                        flex:1,
                                        child: Transform.scale(scale:1.5,
                                          child:
                                          IconButton(
                                            // iconSize: MediaQuery.of(context).size.width/10,
                                            splashRadius: 5.0,
                                            splashColor:Colors.blue,
                                            icon:repd?radio1:radio,
                                            onPressed: (){

                                              type="Date";
                                              typeselec="repd";
                                              newDateTime=DateTime.now();

                                              if(typeset=="cyc" && typeselec == "repd"){
                                                typesend="cyc_repd";
                                              }
                                              else if(typeset == "repd" && typeselec == "repd"){
                                                typesend="repd";
                                              }
                                              else if(typeset == "rep" && typeselec == "repd"){
                                                typesend="rep_repd";
                                              }

                                              if(repd == true){
                                                // repd=false;

                                                rep=false;
                                                cyc=false;
                                                _datevisible=true;
                                                _cycvisible=false;
                                                _repvisible=false;
                                                _reppatternvisible=true;
                                              }
                                              else{

                                                repd=true;
                                                cyc=false;
                                                rep=false;
                                                _datevisible=true;
                                                _cycvisible=false;
                                                _repvisible=false;
                                                _reppatternvisible=true;
                                              }
                                              setState(() {
                                                repd=repd;
                                                rep=rep;
                                                cyc=cyc;
                                                _datevisible=_datevisible;
                                                _cycvisible=_cycvisible;
                                                _repvisible=_repvisible;
                                                _reppatternvisible=_reppatternvisible;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex:9,
                                        child: Text("SELECTED DATE"),
                                      ),
                                    ]
                                ),
                              ),

                              Expanded(
                                  flex:2,
                                  child:Visibility(
                                    visible: _datevisible,
                                    child:Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                              flex:10,
                                              child:DefaultTextStyle.merge(
                                                style:TextStyle(fontSize: 5),
                                                child: CupertinoDatePicker(
                                                    mode:CupertinoDatePickerMode.date,
                                                    initialDateTime: newDateTime,
                                                    onDateTimeChanged: (val) {
                                                      _chosenDateTime = val;
                                                      String string = dateFormat.format(_chosenDateTime);
                                                      print(string);
                                                      List lis = string.split(" ");
                                                      date = lis[0];
                                                      setState(() {
                                                        date=date;
                                                      });
                                                    }),
                                              )
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
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:[
                          Expanded(
                            flex:1,
                            child:Visibility(
                              visible:_reppatternvisible,
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
                                        icon:_reppattern?checkbox1:checkbox,
                                        onPressed: (){

                                          if(_reppattern == true){
                                            _reppattern=false;
                                            repeat=repeatw;
                                          }
                                          else if (_reppattern == false){
                                            _reppattern=true;
                                            repeat="0";
                                          }
                                          setState(() {
                                            _reppattern=_reppattern;
                                          });
                                          },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex:8,
                                    child: Text("Repeat Pattern"),
                                  ),
                                ],
                              )

                            )
                          ),
                          Expanded(
                            flex:1,
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      child: Text("SAVE"),
                                    ),
                                  ),
                                  // ),
                                  onPressed: () {

                                    print('Tapped');

                                    String t1='0',t2='0',t3,t4;

                                    operationflag = 1;
                                    operationstartflag = 0;
                                    operationcompleteflag = 0;

                                    onData = _globalServiceEditTimer.ondata;
                                    offData = _globalServiceEditTimer.offdata;

                                    if(_currentvalue3==24){
                                      _currentvalue4=00;
                                    }

                                    String newfromTime=(_currentvalue1.toString()).padLeft(2,'0')+":"+(_currentvalue2.toString()).padLeft(2,'0');
                                    String newtoTime=(_currentvalue3.toString()).padLeft(2,'0')+":"+(_currentvalue4.toString()).padLeft(2,'0');

                                    if(newfromTime==newtoTime){
                                      print("From Time and To Time should not be same");
                                      fluttertoast("From Time and To Time should not be same");
                                    }

                                    else if((newfromTime=="00:00") && (newtoTime=="24:00")){
                                      print("From Time and To Time should not be same");
                                      fluttertoast("From Time and To Time should not be same");
                                    }
                                    else if((newtoTime == "00:00")){
                                      print("Set Timers properly");
                                      fluttertoast("Set Timers Properly");
                                    }
                                    else{

                                      print(typesend);

                                      if(typesend == "cyc"){

                                        _cycontime = "00" + ":" + (_currentvalue5.toString()).padLeft(2, '0');
                                        _cycofftime = "00" + ":" + (_currentvalue6.toString()).padLeft(2, '0');

                                        String data = newfromTime+","+newtoTime+","+_cycontime+","+_cycofftime+","+newfromTime+","+datec+","+operationflag.toString()+","+operationstartflag.toString()+","+operationcompleteflag.toString()+","+modeltype+","+onData+","+offData+","+modeltypenum+","+dvnum+","+deviceID+","+switchno+","+rnum+","+devicename+","+fromTime+","+toTime;
                                        String _senddata = "["+data+"~";
                                        print(_senddata);

                                        if(s.socketconnected==true){
                                          s.socket1(_senddata);
                                        }

                                      }
                                      else if(typesend == "rep"){

                                        t3="1";
                                        t4="0";

                                        String _daterep="0000-00-00";
                                        String data = t1+","+t2+","+t3+","+t4+","+_daterep+","+newfromTime+","+newtoTime+","+t1+","+mon.toString()+","+tue.toString()+","+wed.toString()+","+thur.toString()+","+frid.toString()+","+sat.toString()+","+sun.toString()+","+repeat+","+modeltype+","+onData+","+offData+","+modeltypenum+","+dvnum+","+deviceID+","+switchno+","+rnum+","+devicename+","+fromTime+","+toTime;
                                        String _senddata = "["+data+'}';
                                        print(_senddata);

                                        if(s.socketconnected==true){
                                          s.socket1(_senddata);
                                        }
                                      }
                                      else if(typesend == "repd"){

                                        mon = tue = wed =thur = frid = sat = sun = 0;
                                        t3 = "0";
                                        t4 = "1";

                                        String data = t1+","+t2+","+t3+","+t4+","+date+","+newfromTime+","+newtoTime+","+t1+","+mon.toString()+","+tue.toString()+","+wed.toString()+","+thur.toString()+","+frid.toString()+","+sat.toString()+","+sun.toString()+","+repeat+","+modeltype+","+onData+","+offData+","+modeltypenum+","+dvnum+","+deviceID+","+switchno+","+rnum+","+devicename+","+fromTime+","+toTime;
                                        String _senddata = "["+data+"} ";
                                        print(_senddata);

                                        if(s.socketconnected==true){
                                          s.socket1(_senddata);
                                        }

                                      }
                                      else if(typesend == "repd_cyc"){

                                        _cycontime = "00" + ":" + (_currentvalue5.toString()).padLeft(2, '0');
                                        _cycofftime = "00" + ":" + (_currentvalue6.toString()).padLeft(2, '0');

                                        String data = newfromTime+","+newtoTime+","+_cycontime+","+_cycofftime+","+newfromTime+","+datec+","+operationflag.toString()+","+operationstartflag.toString()+","+operationcompleteflag.toString()+","+modeltype+","+onData+","+offData+","+modeltypenum+","+dvnum+","+deviceID+","+switchno+","+rnum+","+devicename+","+fromTime+","+toTime;
                                        String _senddata = "["+data+">";
                                        print(_senddata);

                                        if(s.socketconnected==true){
                                          s.socket1(_senddata);
                                        }

                                      }
                                      else if(typesend == "repd_rep"){

                                        t3="1";
                                        t4="0";

                                        String _daterep="0000-00-00";
                                        String data = t1+","+t2+","+t3+","+t4+","+_daterep+","+newfromTime+","+newtoTime+","+t1+","+mon.toString()+","+tue.toString()+","+wed.toString()+","+thur.toString()+","+frid.toString()+","+sat.toString()+","+sun.toString()+","+repeat+","+modeltype+","+onData+","+offData+","+modeltypenum+","+dvnum+","+deviceID+","+switchno+","+rnum+","+devicename+","+fromTime+","+toTime;
                                        String _senddata = "["+data+'<';
                                        print(_senddata);

                                        if(s.socketconnected==true){
                                          s.socket1(_senddata);
                                        }

                                      }
                                      else if(typesend == "cyc_repd"){

                                        mon = tue = wed =thur = frid = sat = sun = 0;
                                        t3 = "0";
                                        t4 = "1";

                                        String data = t1+","+t2+","+t3+","+t4+","+date+","+newfromTime+","+newtoTime+","+t1+","+mon.toString()+","+tue.toString()+","+wed.toString()+","+thur.toString()+","+frid.toString()+","+sat.toString()+","+sun.toString()+","+repeat+","+modeltype+","+onData+","+offData+","+modeltypenum+","+dvnum+","+deviceID+","+switchno+","+rnum+","+devicename+","+fromTime+","+toTime;
                                        String _senddata = "["+data+"%";
                                        print(_senddata);

                                        if(s.socketconnected==true){
                                          s.socket1(_senddata);
                                        }

                                      }
                                      else if(typesend == "cyc_rep"){

                                        t3="1";
                                        t4="0";

                                        String _daterep="0000-00-00";
                                        String data = t1+","+t2+","+t3+","+t4+","+_daterep+","+newfromTime+","+newtoTime+","+t1+","+mon.toString()+","+tue.toString()+","+wed.toString()+","+thur.toString()+","+frid.toString()+","+sat.toString()+","+sun.toString()+","+repeat+","+modeltype+","+onData+","+offData+","+modeltypenum+","+dvnum+","+deviceID+","+switchno+","+rnum+","+devicename+","+fromTime+","+toTime;
                                        String _senddata = "["+data+'%';
                                        print(_senddata);

                                        if(s.socketconnected==true){
                                          s.socket1(_senddata);
                                        }

                                      }
                                      else if(typesend == "rep_repd"){

                                        mon = tue = wed =thur = frid = sat = sun = 0;
                                        t3 = "0";
                                        t4 = "1";

                                        String data = t1+","+t2+","+t3+","+t4+","+date+","+newfromTime+","+newtoTime+","+t1+","+mon.toString()+","+tue.toString()+","+wed.toString()+","+thur.toString()+","+frid.toString()+","+sat.toString()+","+sun.toString()+","+repeat+","+modeltype+","+onData+","+offData+","+modeltypenum+","+dvnum+","+deviceID+","+switchno+","+rnum+","+devicename+","+fromTime+","+toTime;
                                        String _senddata = "["+data+"<";
                                        print(_senddata);

                                        if(s.socketconnected==true){
                                          s.socket1(_senddata);
                                        }


                                      }
                                      else if(typesend == "rep_cyc"){

                                        _cycontime = "00" + ":" + (_currentvalue5.toString()).padLeft(2, '0');
                                        _cycofftime = "00" + ":" + (_currentvalue6.toString()).padLeft(2, '0');

                                        String data = newfromTime+","+newtoTime+","+_cycontime+","+_cycofftime+","+newfromTime+","+datec+","+operationflag.toString()+","+operationstartflag.toString()+","+operationcompleteflag.toString()+","+modeltype+","+onData+","+offData+","+modeltypenum+","+dvnum+","+deviceID+","+switchno+","+rnum+","+devicename+","+fromTime+","+toTime;
                                        String _senddata = "["+data+">";
                                        print(_senddata);

                                        if(s.socketconnected==true){
                                          s.socket1(_senddata);
                                        }

                                      }

                                      Navigator.pop(context);

                                    }

                                    },
                                ),

                              ]
                            )
                          )
                        ]
                      )
                    )
                  )
                ]
            )

          ),

        )
      )
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

}


