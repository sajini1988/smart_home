//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/Timer/EditTimer_Popup.dart';
import 'package:smart_home/Timer/GlobalEditTimerListdata.dart';


class TimerDFanPage extends StatefulWidget {

  TimerDFanPage({Key key, this.number}) : super(key: key);
  final String number;
  @override
  _TimerDFanPageState createState() => _TimerDFanPageState(number1: number);
}

class _TimerDFanPageState extends State<TimerDFanPage> {

  _TimerDFanPageState({this.number1});
  final String number1;
  String dropdownValue="0";
  String username,usertype;
  String hname,hnum,rnum,rname,dnum,groupIdset,ddevmodel,modeltypeset,devicenameset="name";

  GlobalService _globalService = GlobalService();
  GlobalEdittimer _globalServiceEditTimer = GlobalEdittimer();

  String number="0";

  String sw1ondata;
  String sw1n;
  String fanv="No";
  Image imagefanon  = Image.asset('images/switchicons/fan1.png');

  String fanondata="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    hname = _globalService.hname;
    hnum = _globalService.hnum;
    rnum = _globalServiceEditTimer.roomno;
    dnum=_globalServiceEditTimer.dvnum;
    devicenameset=_globalServiceEditTimer.devicename;
    fanondata=_globalServiceEditTimer.ondata;
    dropdownValue=fanondata[14];
    _timerdbfunction();
  }

  _timerdbfunction()async {

    DBHelper dbHelper = DBHelper();
    List result = await dbHelper.getLocalDateHName(hname);

    username = result[0]['ld'];
    usertype = result[0]['lg'];

    setState(() {
      dropdownValue = dropdownValue;
      devicenameset=devicenameset;

    });

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

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        flex:10,
                        child: Container(
                          color: Colors.white,
                          child:Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width/50),),
                        )
                    ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [

                              Expanded(
                                child:Container(
                                  // color: Colors.blueAccent,
                                  child: Padding(padding: const EdgeInsets.only(left: 0.0),
                                    child: Transform.scale(scale: 1.30,
                                      child: IconButton(

                                        iconSize: MediaQuery.of(context).size.width/10,
                                        icon:imagefanon,
                                        splashRadius: 0.1,
                                        splashColor:Colors.transparent ,
                                        onPressed: ()=>{null},
                                      ),
                                    ),

                                  ),
                                ),
                                // flex:4,
                              ),
                              Expanded(
                                child:Container(
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(dropdownValue),
                                      buildDropDown(),
                                    ],
                                  ),
                                ),
                                // flex:6,
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

                  ],
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
                          child:Padding(padding: const EdgeInsets.all(10.0),),
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
                                    fanspeed();

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

  //return type String with function
  String sendDataSwitchBoard(String senddata,String casttype){

    String cast1 = casttype;
    String gI = "000";
    String c = dnum.padLeft(4, '0');
    String rN = rnum.padLeft(2, '0');
    String chr = senddata;
    String cE = "000000000000003";

    String a="0";
    String sData = a + cast1 + gI + c + rN + chr + cE ;
    print("Sending String is : $sData"); // input is : *001000000102920000000000000000# output is : 003300010100FFFFFFFFA120F001B3

    return sData;

  }

  buildDropDown() {

    return DropdownButton<String>(
      // value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down_sharp),
      elevation: 10,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height:2,
        //color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue)async {

        fanv="Yes";
        setState(() {
          dropdownValue = newValue;

        });

        await fanspeed();
      },
      items: <String>['0','1', '2', '3', '4']
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

  fanspeed(){

    print(fanondata.length);
    if(fanondata.length == 0){
      if(dropdownValue=="0"){
        print("fan Speed value zero");
      }
      else {
        fandata();
      }
    }
    else{
      print(dropdownValue);
      print(fanondata);


      if(dropdownValue=="0"){
        print("fan Speed value zero");

      }
      else{
        fandata();
      }

    }

  }

  fandata(){

    String ondata1="71";
    String ondatafan;
    ondatafan = "$ondata1"+dropdownValue;
    fanondata=sendDataSwitchBoard(ondatafan, "01");
    _globalServiceEditTimer.ondataset=fanondata;

    Navigator.pop(context);


  }






}


