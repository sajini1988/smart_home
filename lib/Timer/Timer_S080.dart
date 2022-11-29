//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/Globaltimerdata.dart';

class TimerS080Page extends StatefulWidget {

  TimerS080Page({Key key, this.number}) : super(key: key);
  final String number;

  @override
  _TimerS080PageState createState() => _TimerS080PageState(number1: number);
}
class _TimerS080PageState extends State<TimerS080Page> {

  _TimerS080PageState({this.number1});
  final String number1;

  String Username,Usertype;

  GlobalService _globalService = GlobalService();
  Globaltimer _globaltimer = Globaltimer();

  String hname,hnum,rnum,rname,dnum,GroupIdset,ddevmodel,modeltypeset,devicenameset="name";

  Image bulbon=Image.asset('images/switchicons/bulb_on.png');
  Image bulboff=Image.asset('images/switchicons/bulb_off.png');

  Image imagehvon = Image.asset('images/switchicons/highvolt_on.png');
  Image imagehvoff = Image.asset('images/switchicons/highvolt_off.png');

  bool imgchange1=false;
  bool imgchange2=false;
  bool imgchange3=false;
  bool imgchange4=false;
  bool imgchange5=false;
  bool imgchange6=false;
  bool imgchange7=false;
  bool imgchange8=false;

  List ondataarray = [];
  List offdataarray = [];
  List switchnumber = [];

  String sw1ondata,sw1offdata,sw2ondata,sw2offdata,sw3ondata,sw3offdata,sw4ondata,sw4offdata,sw5ondata,sw5offdata,sw6ondata,sw6offdata,sw7ondata,sw7offdata,sw8ondata,sw8offdata,sw1n,sw2n,sw3n,sw4n,sw5n,sw6n,sw7n,sw8n;
  Image img1_On,img1_Off,img2_On,img2_Off,img3_On,img3_Off,img4_Off,img4_On,img5_Off,img5_On,img6_Off,img6_On,img7_Off,img7_On,img8_Off,img8_On;

  @override
  void initState(){
    super.initState();

    hname = _globalService.hname;
    hnum = _globalService.hnum;
    rnum = _globalService.rnum;
    rname = _globalService.rname;
    dnum = _globalService.dnum;
    GroupIdset = _globalService.groupId;
    ddevmodel = _globalService.ddevModel;
    modeltypeset = _globalService.modeltype;
    devicenameset = _globalService.devicename;

    img1_Off=bulboff;
    img1_On=bulbon;

    img2_Off=bulboff;
    img2_On=bulbon;

    img3_Off=bulboff;
    img3_On=bulbon;

    img4_Off=bulboff;
    img4_On=bulbon;

    img5_Off=bulboff;
    img5_On=bulbon;

    img6_Off=bulboff;
    img6_On=bulbon;

    img7_Off=imagehvoff;
    img7_On=imagehvon;

    img8_Off=imagehvoff;
    img8_On=imagehvon;

    timer_dbfunction();
  }

  timer_dbfunction()async{

    DBHelper dbHelper = DBHelper();
    List result = await dbHelper.getLocalDateHName(hname);
    print("res $result");

    Username = result[0]['ld'];
    Usertype = result[0]['lg'];

    print("name $Usertype,$Username");

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent,

        body: Align(
          alignment: Alignment.center,
          child:Container(
            color:Colors.transparent,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              shrinkWrap: true,

              //mainAxisSize: MainAxisSize.max,
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
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
                  children:[
                    Expanded(
                      flex: 10,
                      child:Container(

                        color: Colors.white,
                        child:Center(

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

                            ),)

                      ),
                    ),


                    ) ],
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
                  children:[
                    Expanded(
                        flex:10,
                        child:Container(
                          color: Colors.white,
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [

                              Padding(
                                padding: const EdgeInsets.all(05.0),
                                child:Transform.scale(
                                  scale: 2.5,
                                  child: IconButton(
                                      iconSize: MediaQuery.of(context).size.width/10,
                                      icon: imgchange1?img1_On:img1_Off,
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
                                          sw1ondata=SendDataSwitchBoard("201","01");
                                          sw1offdata=SendDataSwitchBoard("301","01");
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
                              Padding(
                                padding: const EdgeInsets.all(05.0),

                                child:Transform.scale(
                                  scale: 2.5,
                                  child: IconButton(
                                      iconSize: MediaQuery.of(context).size.width/10,
                                      icon: imgchange2?img2_On:img2_Off,
                                      splashRadius: 0.1,
                                      splashColor:Colors.transparent,
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
                                          sw2ondata=SendDataSwitchBoard("202","01");
                                          sw2offdata=SendDataSwitchBoard("302","01");
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
                              Padding(
                                padding: const EdgeInsets.all(05.0),

                                child:Transform.scale(
                                  scale: 2.5,
                                  child: IconButton(
                                      iconSize: MediaQuery.of(context).size.width/10,
                                      icon: imgchange3?img3_On:img3_Off,
                                      splashRadius: 0.1,
                                      splashColor:Colors.transparent ,
                                      onPressed: () {

                                        if(imgchange3==true){
                                          imgchange3=false;
                                          ondataarray.remove(sw3ondata);
                                          offdataarray.remove(sw3offdata);
                                          switchnumber.remove(sw3n);
                                        }
                                        else if(imgchange3==false){
                                          imgchange3=true;
                                          sw3n="3";
                                          sw3ondata=SendDataSwitchBoard("203","01");
                                          sw3offdata=SendDataSwitchBoard("303","01");
                                          ondataarray.add(sw3ondata);
                                          offdataarray.add(sw3offdata);
                                          switchnumber.add(sw3n);
                                        }
                                        setState(() {
                                          imgchange3=imgchange3;
                                          print("$imgchange3");
                                        });

                                      }
                                  ),
                                ),
                              )

                            ],
                          ),
                        )

                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 10,
                      child: Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [

                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child:Transform.scale(
                                scale: 2.5,
                                child: IconButton(
                                    iconSize: MediaQuery.of(context).size.width/10,
                                    icon: imgchange4?img4_On:img4_Off,
                                    splashRadius: 0.1,
                                    splashColor:Colors.transparent ,
                                    onPressed: () {

                                      if(imgchange4==true){
                                        imgchange4=false;
                                        ondataarray.remove(sw4ondata);
                                        offdataarray.remove(sw4offdata);
                                        switchnumber.remove(sw4n);
                                      }
                                      else if(imgchange4==false){
                                        imgchange4=true;
                                        sw4n="4";
                                        sw4ondata=SendDataSwitchBoard("204","01");
                                        sw4offdata=SendDataSwitchBoard("304","01");
                                        ondataarray.add(sw4ondata);
                                        offdataarray.add(sw4offdata);
                                        switchnumber.add(sw4n);
                                      }
                                      setState(() {
                                        imgchange4=imgchange4;
                                        print("$imgchange4");
                                      });

                                    }
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(05.0),
                              child:Transform.scale(
                                scale: 2.5,
                                child: IconButton(
                                    iconSize: MediaQuery.of(context).size.width/10,
                                    icon: imgchange5?img5_On:img5_Off,
                                    splashRadius: 0.1,
                                    splashColor:Colors.transparent ,
                                    onPressed: () {
                                      if(imgchange5==true){
                                        imgchange5=false;
                                        ondataarray.remove(sw5ondata);
                                        offdataarray.remove(sw5offdata);
                                        switchnumber.remove(sw5n);
                                      }
                                      else if(imgchange5==false){
                                        imgchange5=true;
                                        sw5n="5";
                                        sw5ondata=SendDataSwitchBoard("205","01");
                                        sw5offdata=SendDataSwitchBoard("305","01");
                                        ondataarray.add(sw5ondata);
                                        offdataarray.add(sw5offdata);
                                        switchnumber.add(sw5n);
                                      }
                                      setState(() {
                                        imgchange5=imgchange5;
                                        print("$imgchange5");
                                      });

                                    }
                                ),
                              ),

                            ),
                            Padding(
                              padding: const EdgeInsets.all(05.0),
                              child:Transform.scale(
                                scale: 2.5,
                                child: IconButton(
                                    iconSize: MediaQuery.of(context).size.width/10,
                                    icon: imgchange6?img6_On:img6_Off,
                                    splashRadius: 0.1,
                                    splashColor:Colors.transparent ,
                                    onPressed: () {

                                      if(imgchange6==true){
                                        imgchange6=false;
                                        ondataarray.remove(sw6ondata);
                                        offdataarray.remove(sw6offdata);
                                        switchnumber.remove(sw6n);
                                      }
                                      else if(imgchange6==false){
                                        imgchange6=true;
                                        sw6n="6";
                                        sw6ondata=SendDataSwitchBoard("206","01");
                                        sw6offdata=SendDataSwitchBoard("306","01");
                                        ondataarray.add(sw6ondata);
                                        offdataarray.add(sw6offdata);
                                        switchnumber.add(sw6n);
                                      }
                                      setState(() {
                                        imgchange6=imgchange6;
                                        print("$imgchange6");
                                      });
                                    }
                                ),
                              ),

                            )
                          ],
                        ),
                      ),
                    ),
                  ],

                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 10,
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
                                    icon: imgchange7?img7_On:img7_Off,
                                    splashRadius: 0.1,
                                    splashColor:Colors.transparent ,
                                    onPressed: () {

                                      if(imgchange7==true){
                                        imgchange7=false;
                                        ondataarray.remove(sw7ondata);
                                        offdataarray.remove(sw7offdata);
                                        switchnumber.remove(sw7n);
                                      }
                                      else if(imgchange7==false){
                                        imgchange7=true;
                                        sw7n="7";
                                        sw7ondata=SendDataSwitchBoard("207","01");
                                        sw7offdata=SendDataSwitchBoard("307","01");
                                        ondataarray.add(sw7ondata);
                                        offdataarray.add(sw7offdata);
                                        switchnumber.add(sw7n);
                                      }
                                      setState(() {
                                        imgchange7=imgchange7;
                                        print("$imgchange7");
                                      });

                                    }
                                ),
                              ),

                            ),

                            Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width/10),),
                            // Padding(
                            //   padding: const EdgeInsets.all(0.0),
                            //
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(05.0),

                              child:Transform.scale(
                                scale: 2.5,
                                child: IconButton(
                                    iconSize: MediaQuery.of(context).size.width/10,
                                    icon: imgchange8?img8_On:img8_Off,
                                    splashRadius: 0.1,
                                    splashColor:Colors.transparent ,
                                    onPressed: () {

                                      if(imgchange8==true){
                                        imgchange8=false;
                                        ondataarray.remove(sw8ondata);
                                        offdataarray.remove(sw8offdata);
                                        switchnumber.remove(sw8n);
                                      }
                                      else if(imgchange8==false){
                                        imgchange8=true;
                                        sw8n="8";
                                        sw8ondata=SendDataSwitchBoard("208","01");
                                        sw8offdata=SendDataSwitchBoard("308","01");
                                        ondataarray.add(sw8ondata);
                                        offdataarray.add(sw8offdata);
                                        switchnumber.add(sw8n);
                                      }
                                      setState(() {
                                        imgchange8=imgchange8;
                                        print("$imgchange8");
                                      });

                                    }
                                ),
                              ),

                            )
                          ],
                        ),
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
                          child:Padding(padding: const EdgeInsets.all(10.0),),
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
                          child:Padding(padding: const EdgeInsets.all(10.0),),
                        )

                    ),
                  ],
                ),
              ],
            ),
          ),

        ),
      ),
    );
  }

  //return type String with function
  String SendDataSwitchBoard(String send_data,String casttype){

    String cast1 = casttype;
    String gI = GroupIdset;
    String c = dnum.padLeft(4, '0');
    String rN = rnum.padLeft(2, '0');
    String chr = send_data;
    String cE = "000000000000003";

    String a="0";
    String sData = a + cast1 + gI + c + rN + chr + cE ;
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




}