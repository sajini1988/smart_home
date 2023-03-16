import 'package:flutter/material.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/Singleton.dart';
import 'package:smart_home/Globaltimerdata.dart';

class TimerS021Page extends StatefulWidget {

  TimerS021Page({Key key, this.number}) : super(key: key);
  final String number;

  @override
  _TimerS021PageState createState() => _TimerS021PageState(number1: number);
}

class _TimerS021PageState extends State<TimerS021Page> {

  _TimerS021PageState({this.number1});
  final String number1;

  String username,usertype;
  var s = Singleton();

  GlobalService _globalService = GlobalService();
  Globaltimer _globaltimer = Globaltimer();

  String hname,hnum,rnum,rname,dnum,groupIdset,ddevmodel,modeltypeset,devicenameset="name";

  bool imgchange1=false;
  bool imgchange2=false;

  Image bulbon=Image.asset('images/switchicons/bulb_on.png');
  Image bulboff=Image.asset('images/switchicons/bulb_off.png');

  Image imagehvon = Image.asset('images/switchicons/highvolt_on.png');
  Image imagehvoff = Image.asset('images/switchicons/highvolt_off.png');

  Image img1On,img1Off,img2On,img2Off;
  Image imagefanon  = Image.asset('images/switchicons/fan1.png');

  List ondataarray = [];
  List offdataarray = [];
  List switchnumber = [];

  String dropdownValue="0";

  String sw1ondata,sw1offdata,sw2ondata,sw2offdata,fanondata="",fanoffdata="";
  String sw1n,sw2n,fanswn;

  @override
  void initState() {
    super.initState();

    img1Off = bulboff;
    img1On = bulbon;

    img2Off = imagehvoff;
    img2On = imagehvon;

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
  timerdbfunction()async{

    DBHelper dbHelper = DBHelper();

    List result = await dbHelper.getLocalDateHName(hname);
    print("res $result");

    username = result[0]['ld'];
    usertype = result[0]['lg'];

    print("name $usertype,$username");

  }

  fanspeed(){
    if(fanondata.length == 0){
      fandata();
    }
    else{

      print(dropdownValue);
      print(fanondata);
      print(fanoffdata);
      print(fanswn);


      if(dropdownValue=="0"){

        print("zero");
        ondataarray.remove(fanondata);
        offdataarray.remove(fanoffdata);
        switchnumber.remove(fanswn);


      }
      else{

        print("not zero");
        ondataarray.remove(fanondata);
        offdataarray.remove(fanoffdata);
        switchnumber.remove(fanswn);
        fandata();
      }



    }
  }

  fandata(){

    String ondata1="71";
    String ondatafan;
    ondatafan = "$ondata1"+dropdownValue.toString();
    fanondata=sendDataSwitchBoard(ondatafan, "01");
    fanoffdata=sendDataSwitchBoard("723", "01");
    fanswn="98";

    ondataarray.add(fanondata);
    offdataarray.add(fanoffdata);
    switchnumber.add(fanswn);

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
              children: <Widget>[

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
                      flex: 10,
                        child: Container(
                          color: Colors.white,
                          child: Center(
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child:
                                Text(
                                  devicenameset,
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

                            Padding(
                              padding: const EdgeInsets.all(05.0),
                              child:Transform.scale(
                                scale: 2.5,
                                child: IconButton(
                                    iconSize: MediaQuery.of(context).size.width/10,
                                    icon: imgchange1?img1On:img1Off,
                                    splashRadius: 0.1,
                                    splashColor:Colors.transparent ,
                                    onPressed: () {

                                      if(imgchange1==true){
                                        imgchange1=false;
                                        ondataarray.remove(sw1ondata);
                                        offdataarray.remove(sw1offdata);
                                        switchnumber.remove(sw1n);
                                      }
                                      else if(imgchange1==false){
                                        imgchange1=true;
                                        sw1n="1";
                                        sw1ondata=sendDataSwitchBoard("201","01");
                                        sw1offdata=sendDataSwitchBoard("301","01");
                                        ondataarray.add(sw1ondata);
                                        offdataarray.add(sw1offdata);
                                        switchnumber.add(sw1n);
                                      }
                                      setState(() {
                                        imgchange1=imgchange1;
                                        print("$imgchange1");
                                      });

                                    }
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width/25),),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child:Transform.scale(
                                scale: 2.5,
                                child: IconButton(
                                    iconSize: MediaQuery.of(context).size.width/10,
                                    icon: imgchange2?img2On:img2Off,
                                    splashRadius: 0.1,
                                    splashColor:Colors.transparent ,
                                    onPressed: () {

                                      if(imgchange2==true){
                                        imgchange2=false;
                                        ondataarray.remove(sw2ondata);
                                        offdataarray.remove(sw2offdata);
                                        switchnumber.remove(sw2n);
                                      }
                                      else if(imgchange2==false){
                                        imgchange2=true;
                                        sw2n="2";
                                        sw2ondata=sendDataSwitchBoard("202","01");
                                        sw2offdata=sendDataSwitchBoard("302","01");
                                        ondataarray.add(sw2ondata);
                                        offdataarray.add(sw2offdata);
                                        switchnumber.add(sw2n);
                                      }
                                      setState(() {
                                        imgchange2=imgchange2;
                                        print("$imgchange2");
                                      });
                                    }
                                ),
                              ),

                            ),
                          ],
                        ),
                      ),
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
                          mainAxisAlignment: MainAxisAlignment.start,
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
                              flex:4,
                            ),
                            Expanded(
                              child:Container(
                                // color: Colors.greenAccent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    Text(dropdownValue),
                                    buildDropDown(),
                                  ],
                                ),
                              ),
                              flex:6,
                            ),

                          ],
                        ),
                      ),
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
                          child:Padding(padding: const EdgeInsets.all(5.0),),
                        )

                    ),
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
                          child:Padding(padding: const EdgeInsets.all(5.0),),
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
                                savefan();
                                print('Tapped');
                              },
                            ),

                          ],
                        ),
                      )
                    ),
                  ],
                ),

              ],
            ),

          );


  }

  //return type String with function
  String sendDataSwitchBoard(String senddata,String casttype){

    String cast1 = casttype;
    String gI = groupIdset;
    String c = dnum.padLeft(4, '0');
    String rN = rnum.padLeft(2, '0');
    String chr = senddata;
    String cE = "000000000000003";

    String a="0";
    String sData = a + cast1 + gI + c + rN + chr + cE;
    print("Sending String is : $sData"); // input is : *001000000102920000000000000000# output is : 003300010100FFFFFFFFA120F001B3

    return sData;

  }


  savefan()async{

    if(ondataarray.length == 0){
      print("Select any Switch for timers to be set");
    }
    else{
      print("ONDATA : $ondataarray,OFFDATA: $offdataarray,SWNO: $switchnumber");
      Navigator.pop(context);
      _globaltimer.ondataarrayset=ondataarray;
      _globaltimer.offdataarrayset=offdataarray;
      _globaltimer.switchnumberset=switchnumber;
    }
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
      onChanged: (String newValue)async
      {
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

}

