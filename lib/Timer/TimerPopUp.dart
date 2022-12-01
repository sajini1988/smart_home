import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/Singleton.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:smart_home/Timer/Timer_S051.dart';
import 'package:smart_home/Timer/Timer_S010.dart';
import 'package:smart_home/Timer/Timer_S020.dart';
import 'package:smart_home/Timer/Timer_S021.dart';
import 'package:smart_home/Timer/Timer_S030.dart';
import 'package:smart_home/Timer/Timer_S080.dart';
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

  int sun,mon,tue,wed,thur,frid,sat;
  String repeat,repeatw;

  bool repVisible,cycVisible,dateVisible,repPatternVisible,setoperationvisible;

  int weeknumber;
  String cycOntime,cycOfftime;
  DateTime _chosenDateTime=DateTime.now();
  String datec,Date;
  DateFormat dateFormat;

  @override
  void initState() {

    // TODO: implement initState
    super.initState();

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
    else if(devicemodel == 'PSC1' || devicemodel == 'PLC1' || devicemodel == 'SWG1' || devicemodel == 'SLG1' || devicemodel == 'ACR1' || devicemodel == 'GSR1'){
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
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
              child:Container(
                  width: MediaQuery.of(context).size.width,


                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[

                      Expanded(
                        flex:1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                            scale: 1.5,
                                            child: IconButton(
                                              icon: Image.asset("images/Timer/set_operation.png"),
                                              splashRadius: 0.1,
                                              splashColor:Colors.transparent,
                                              onPressed: () {

                                                if(devicemodel=="S051"){
                                                AlertDialog alert = AlertDialog(
                                                  elevation: 0,
                                                  contentPadding: EdgeInsets.zero,
                                                  titlePadding: EdgeInsets.zero,
                                                  title: Text(""),
                                                  //content: S051TimerPage(),
                                                  shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),

                                                  content: Container(
                                                    width: MediaQuery.of(context).size.width*0.75,
                                                    child:S051TimerPage(number: '0',),
                                                  ),
                                                  backgroundColor: Colors.transparent,
                                                  actions: [],
                                                );
                                                showDialog(context: context, builder: (BuildContext context) {
                                                  return alert;
                                                }
                                                );
                                              }
                                              else if(devicemodel=="RGB1"){
                                                  AlertDialog alert = AlertDialog(

                                                    elevation: 0,
                                                    contentPadding: EdgeInsets.zero,
                                                    titlePadding: EdgeInsets.zero,
                                                    title: Text(""),
                                                    shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),
                                                    content: Container(
                                                      width: MediaQuery.of(context).size.width*0.75,
                                                      child:RGBTimerPage(number: '0',),
                                                    ),
                                                    backgroundColor: Colors.transparent,
                                                    actions: [],
                                                  );
                                                  showDialog(context: context, builder: (BuildContext context) {
                                                    return alert;
                                                  }
                                                  );
                                              }
                                              else if(devicemodel=="S010"){
                                                AlertDialog alert = AlertDialog(
                                                  elevation: 0,
                                                  //insetPadding: EdgeInsets.zero,
                                                  // contentPadding: EdgeInsets.zero,
                                                  //clipBehavior: Clip.antiAliasWithSaveLayer,
                                                  contentPadding: EdgeInsets.zero,
                                                  titlePadding: EdgeInsets.zero,
                                                  backgroundColor: Colors.transparent,
                                                  title: Text(""),
                                                 // content: TimerS010Page(),
                                                  content: Container(
                                                    width: MediaQuery.of(context).size.width*0.75,
                                                    child:TimerS010Page(number: '0',),
                                                  ),
                                                  actions: [],
                                                );
                                                showDialog(context: context, builder: (BuildContext context) {
                                                  return alert;
                                                }
                                                );
                                              }
                                              else if(devicemodel=="S020"){

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
                                                    child:TimerS020Page(number: '0',),
                                                  ),
                                                  //content: TimerS020Page(),
                                                  actions: [],
                                                );
                                                showDialog(context: context, builder: (BuildContext context) {
                                                    return alert;
                                                  }
                                                );

                                              }
                                              else if(devicemodel=="S021"){

                                                AlertDialog alert = AlertDialog(

                                                  elevation: 0,
                                                  //insetPadding: EdgeInsets.zero,
                                                  // contentPadding: EdgeInsets.zero,
                                                  //clipBehavior: Clip.antiAliasWithSaveLayer,
                                                  titlePadding: EdgeInsets.zero,
                                                  contentPadding: EdgeInsets.zero,
                                                  backgroundColor: Colors.transparent,
                                                  title: Text(""),
                                                  //content: TimerS021Page(),
                                                  content: Container(
                                                    width: MediaQuery.of(context).size.width*0.75,
                                                    child:TimerS021Page(number:'0'),
                                                  ),
                                                  actions: [],
                                                );
                                                showDialog(context: context, builder: (BuildContext context) {
                                                  return alert;
                                                }
                                                );

                                              }
                                              else if(devicemodel=="S030"){

                                                AlertDialog alert = AlertDialog(

                                                  elevation: 0,
                                                  //insetPadding: EdgeInsets.zero,
                                                  // contentPadding: EdgeInsets.zero,
                                                  //clipBehavior: Clip.antiAliasWithSaveLayer,
                                                  titlePadding: EdgeInsets.zero,
                                                  contentPadding: EdgeInsets.zero,
                                                  backgroundColor: Colors.transparent,
                                                  title: Text(""),
                                                  //content: TimerS030Page()

                                                  content: Container(
                                                    width: MediaQuery.of(context).size.width*0.75,
                                                    child:TimerS030Page(number: '0',),
                                                  ),

                                                  actions: [],
                                                );
                                                showDialog(context: context, builder: (BuildContext context) {
                                                  return alert;
                                                }
                                                );

                                              }
                                              else if(devicemodel=="S080"){

                                                AlertDialog alert = AlertDialog(

                                                  elevation: 0,
                                                  //insetPadding: EdgeInsets.zero,
                                                  // contentPadding: EdgeInsets.zero,
                                                  //clipBehavior: Clip.antiAliasWithSaveLayer,

                                                  contentPadding: EdgeInsets.zero,
                                                  titlePadding: EdgeInsets.zero,
                                                  backgroundColor: Colors.transparent,

                                                  title: Text(""),
                                                  // content: TimerS080Page(),
                                                  content: Container(
                                                    width: MediaQuery.of(context).size.width*0.75,
                                                    child:TimerS080Page(number: '0',),
                                                  ),
                                                  actions: [],
                                                );
                                                showDialog(context: context, builder: (BuildContext context) {
                                                  return alert;
                                                }
                                                );
                                              }
                                              else if((devicemodel == "CLNRSH") || (devicemodel == "CLNR")){

                                                AlertDialog alert = AlertDialog(

                                                  elevation: 0,
                                                  contentPadding: EdgeInsets.zero,
                                                  titlePadding: EdgeInsets.zero,
                                                  backgroundColor: Colors.transparent,

                                                  title: Text(""),
                                                 // content: TimerCurtainPage(),
                                                  content: Container(
                                                    width: MediaQuery.of(context).size.width*0.75,
                                                    child:TimerCurtainPage(number: '0',),
                                                  ),

                                                  actions: [],
                                                );
                                                showDialog(context: context, builder: (BuildContext context) {
                                                  return alert;
                                                }
                                                );


                                              }
                                              else if(devicemodel == "WPS1"){

                                                AlertDialog alert = AlertDialog(

                                                  elevation: 0,
                                                  //insetPadding: EdgeInsets.zero,
                                                  // contentPadding: EdgeInsets.zero,
                                                  //clipBehavior: Clip.antiAliasWithSaveLayer,

                                                  contentPadding: EdgeInsets.zero,
                                                  titlePadding: EdgeInsets.zero,
                                                  backgroundColor: Colors.transparent,

                                                  title: Text(""),
                                                 // content: TimerPIRPage(number: "0",),
                                                  content: Container(
                                                    width: MediaQuery.of(context).size.width*0.75,
                                                    child: TimerPIRPage(number: "0"),
                                                  ),
                                                  actions: [],
                                                );
                                                showDialog(context: context, builder: (BuildContext context) {
                                                  return alert;
                                                }
                                                );
                                              }
                                              else if(devicemodel == "WPD1"){

                                                AlertDialog alert = AlertDialog(

                                                  elevation: 0,
                                                  //insetPadding: EdgeInsets.zero,
                                                  // contentPadding: EdgeInsets.zero,
                                                  //clipBehavior: Clip.antiAliasWithSaveLayer,

                                                  contentPadding: EdgeInsets.zero,
                                                  titlePadding: EdgeInsets.zero,
                                                  backgroundColor: Colors.transparent,

                                                  title: Text(""),
                                                 // content: TimerPIRPage(number: "0",),
                                                  content: Container(
                                                    width: MediaQuery.of(context).size.width*0.75,
                                                    child: TimerPIRPage(number: "0",),
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
                                child: Center(child: Text("TIMER")),
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
                                          scale: 1.5,
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

                     // Expanded(child: SizedBox.shrink()),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                      child:
                      Expanded(
                        flex:1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex:5,
                              child: Center(child: Text("FROM")),
                            ),
                            Expanded(
                              flex:5,
                              child: Center(child: Text("TO")),
                            ),
                          ],
                        ),

                      ),
                  ),



                      Expanded(
                        flex:1,
                        child: Container(
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                        //  itemCount: 2,
                                          value: _currentvalue1,
                                          minValue: 00,
                                          maxValue: 23,
                                          zeroPad: true,
                                          onChanged: (value) => setState(() => _currentvalue1 = value),
                                          selectedTextStyle:TextStyle(
                                            color: Color.fromRGBO( 66,130, 208,1),
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
                                        flex:1,
                                        child: NumberPicker(
                                          value: _currentvalue2,
                                          minValue: 00,
                                          maxValue: 59,
                                          zeroPad: true,
                                          onChanged: (value) => setState(() => _currentvalue2 = value),
                                          selectedTextStyle:TextStyle(
                                            color: Color.fromRGBO( 66,130, 208,1),
                                            fontWeight: FontWeight.bold,
                                            //fontSize: 5.0,
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
                                          value: _currentvalue3,
                                          minValue: 00,
                                          maxValue: 24,
                                          zeroPad: true,
                                          onChanged: (value) => setState(() => _currentvalue3 = value),
                                          selectedTextStyle:TextStyle(
                                            color: Color.fromRGBO( 66,130, 208,1),
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
                                        flex:1,
                                        child: NumberPicker(
                                          value: _currentvalue4,
                                          minValue: 00,
                                          maxValue: 59,
                                          zeroPad: true,
                                          infiniteLoop: false,
                                          haptics: false,
                                          selectedTextStyle:TextStyle(
                                              color: Color.fromRGBO( 66,130, 208,1),
                                              fontWeight: FontWeight.bold,
                                              //fontSize: 5.0,
                                              fontStyle: FontStyle.normal,
                                          ),
                                          onChanged: (value) => setState(() => _currentvalue4 = value),
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
                                        child: Text("  REPEAT ON DAYS  "),
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
                                      child: Text("  CYCLIC  "),
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
                                        child: Center(child: Text("ON TIME")),
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
                                            color: Color.fromRGBO( 66,130, 208,1),
                                            fontWeight: FontWeight.bold,
                                            //fontSize: 5.0,
                                            fontStyle: FontStyle.normal,
                                          ),
                                          onChanged: (value) => setState(() => _currentvalue5 = value),

                                        ),
                                      ),
                                      Expanded(
                                        flex:2,
                                        child: Center(child: Text("OFF TIME")),
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
                                            color: Color.fromRGBO( 66,130, 208,1),
                                            fontWeight: FontWeight.bold,
                                            //fontSize: 5.0,
                                            fontStyle: FontStyle.normal,
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
                                            child: Text("  SELECTED DATE  "),
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
                                            child:DefaultTextStyle.merge(
                                              style:TextStyle(fontSize: 5),
                                              child: CupertinoDatePicker(
                                                  mode:CupertinoDatePickerMode.date,
                                                  initialDateTime: DateTime.now(),
                                                  onDateTimeChanged: (val) {
                                                    _chosenDateTime = val;
                                                    String string = dateFormat.format(_chosenDateTime);
                                                    print(_chosenDateTime);
                                                    List lis = string.split(" ");
                                                    Date = lis[0];
                                                    setState(() {
                                                        Date=Date;
                                                    });
                                                  }),
                                            )
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
                                          padding: EdgeInsets.all(14.0),
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
                                              child: Center(child: Text("SAVE")),
                                            ),
                                          ),
                                          // ),
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

                                                          String data = t1+","+t2+","+t3+","+t4+","+daterep+","+fromTime+","+toTime+","+t1+","+sun.toString()+","+mon.toString()+","+tue.toString()+","+wed.toString()+","+thur.toString()+","+frid.toString()+","+sat.toString()+","+repeat+","+devicemodel+","+ondataarray[i]+","+offdataarray[i]+","+devicemodelnum+","+dnum+","+deviceID+","+switchnumber[i]+","+rnum+","+devicename;
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

                                                          String data = t1+","+t2+","+t3+","+t4+","+Date+","+fromTime+","+toTime+","+t1+","+sun.toString()+","+mon.toString()+","+tue.toString()+","+wed.toString()+","+thur.toString()+","+frid.toString()+","+sat.toString()+","+repeat+","+devicemodel+","+ondataarray[i]+","+offdataarray[i]+","+devicemodelnum+","+dnum+","+deviceID+","+switchnumber[i]+","+rnum+","+devicename;
                                                          String senddata = "["+data+"]";
                                                          print(senddata);

                                                          if(s.socketconnected==true){
                                                            s.socket1(senddata);
                                                          }
                                                          else {
                                                            fluttertoast("Not connected");
                                                          }
                                                      }
                                                      await Future.delayed(const Duration(seconds: 2));
                                                    }
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
                    ],

                  )


            )
          )
        )
    );
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
