import 'package:flutter/material.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/Globaltimerdata.dart';
import 'package:smart_home/Timer/GlobalEditTimerListdata.dart';


class TimerCurtainPage extends StatefulWidget {

  TimerCurtainPage({Key key, this.number}) : super(key: key);
  final String number;

  @override
  _TimerCurtainPageState createState() => _TimerCurtainPageState(number1: number);
}
class _TimerCurtainPageState extends State<TimerCurtainPage> {

  _TimerCurtainPageState({this.number1});
  final String number1;

  String username,usertype;
  String hname,hnum,rnum,rname,dnum,groupIdset,ddevmodel,modeltypeset,devicenameset="name";

  GlobalService _globalService = GlobalService();
  Globaltimer _globaltimer = Globaltimer();
  GlobalEdittimer _globalEdittimer = GlobalEdittimer();


  List ondataarray = [];
  List offdataarray = [];

  List ondataarray1 = [];
  List offdataarray1 = [];
  List switchnumber = [];

  Image img1=Image.asset('images/check_box.png');
  Image img2=Image.asset('images/check_box01.png');

  bool shimg= false;
  bool cuimg= false;

  String sheerenable,sheerdisable,curtainenable,curtaindisable;

  String onDatacu,offDatacu;
  String _ondatasend,_offdatasend;

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

    setState((){

      if(number1 == "1"){
        onDatacu=_globalEdittimer.ondata;
        offDatacu=_globalEdittimer.offdata;

        ondataarray = ondataarray1=onDatacu.split(";");
        offdataarray= offdataarray1=offDatacu.split(";");

        if(ondataarray.length == 1){

          String data = _ondatasend = ondataarray[0];
          String data1 = _offdatasend = offdataarray[0];

          String selected = data[12]+data[13]+data[14];
          if(selected == "105"){
            sheerenable=data;
            sheerdisable=data1;
            shimg=true;

          }
          else if(selected == "101"){

            curtainenable=data;
            curtaindisable=data1;
            cuimg=true;

          }



        }
        else if(ondataarray.length == 2){

          String data = ondataarray[0];
          String data1 = ondataarray[1];
          print("$data,$data1");

          String offdata = offdataarray[0];
          String offdata1 = offdataarray[1];
          print("$offdata,$offdata1");

          _ondatasend=ondataarray[0]+';'+ondataarray[1];
          _offdatasend=offdataarray[0]+';'+offdataarray[1];

          String selected = data[12]+data[13]+data[14];
          print("v $selected");
          if(selected =="105"){

            sheerenable=data;
            sheerdisable=offdata;
            shimg=true;

          }
          else if(selected == "101"){

            curtainenable=data;
            curtaindisable=offdata;
            cuimg=true;
          }

          String selected1 = data1[12]+data1[13]+data1[14];
          print(" v2 $selected1");
          if(selected1 == "105"){

            sheerenable=data1;
            sheerdisable=offdata1;
            shimg=true;

          }
          else if(selected1 == "101"){

            curtainenable=data1;
            curtaindisable=offdata1;
            cuimg=true;

          }

        }


      }

    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.center,
          child:Container(
            color: Colors.transparent,
            child: ListView(
              shrinkWrap: true,
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

                                Expanded(
                                    flex:4,
                                    child: Transform.scale(scale: 1,
                                      child:IconButton(
                                        splashRadius: 0.1,
                                        splashColor:Colors.transparent,
                                        // iconSize: MediaQuery.of(context).size.width/50,
                                        icon: shimg?img2:img1,
                                        onPressed: () {

                                          if(shimg == true){
                                            shimg =false;
                                            ondataarray.remove(sheerenable);
                                            offdataarray.remove(sheerdisable);
                                          }
                                          else if(shimg == false){
                                            shimg=true;
                                            sheerenable = sendDataPIR("105","01");
                                            sheerdisable = sendDataPIR("106","01");
                                            ondataarray.add(sheerenable);
                                            offdataarray.add(sheerdisable);
                                          }
                                          setState(() {
                                            shimg=shimg;
                                          });
                                        },
                                      ),
                                    )
                                ),

                                Expanded(
                                  flex:6,
                                  child: Text("Sheer"),
                                ),

                              ]
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
                              Expanded(
                                flex:4,
                                //child: Padding(padding: const EdgeInsets.only(right: 20.0,top: 12.0),
                                child:Transform.scale(scale: 1,
                                  child:IconButton(
                                    splashRadius: 0.1,
                                    splashColor:Colors.transparent,
                                    iconSize: MediaQuery.of(context).size.width/50,
                                    icon: cuimg?img2:img1,
                                    onPressed: () {

                                      print(cuimg);

                                      if(cuimg == true){
                                        cuimg=false;
                                        ondataarray.remove(curtaindisable);
                                        offdataarray.remove(curtaindisable);
                                      }
                                      else if(cuimg == false){
                                        cuimg=true;
                                        curtainenable = sendDataPIR("101","01");
                                        curtaindisable = sendDataPIR("102","01");
                                        ondataarray.add(curtainenable);
                                        offdataarray.add(curtaindisable);
                                      }
                                      setState(() {
                                        cuimg=cuimg;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                flex:6,
                                child:Text("Curtain") ,
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
                                    print('Tapped');
                                    if(ondataarray.length==0){
                                      print("Select data for timers to be set");
                                    }
                                    else{

                                      String ondatasend,offdatasend;

                                      if(ondataarray.length == 1){

                                        ondatasend=ondataarray[0];
                                        offdatasend=offdataarray[0];

                                        ondataarray1.add(ondatasend);
                                        offdataarray1.add(offdatasend);
                                        switchnumber.add("0");


                                      }
                                      else if(ondataarray.length == 2){

                                        ondatasend=ondataarray[0]+';'+ondataarray[1];
                                        offdatasend=offdataarray[0]+';'+offdataarray[1];

                                        ondataarray1.add(ondatasend);
                                        offdataarray1.add(offdatasend);
                                        switchnumber.add("0");
                                      }

                                      print("$ondataarray1,$offdataarray1,$switchnumber");
                                      _globaltimer.ondataarrayset=ondataarray1;
                                      _globaltimer.offdataarrayset=offdataarray1;
                                      _globaltimer.switchnumberset=switchnumber;

                                      Navigator.pop(context);

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
          ),
        ),
      ),
    );
  }

  //return type String with function
  String sendDataPIR(String senddata,String casttype){

    String cast1 = casttype;
    String gI = groupIdset;
    String c = dnum.padLeft(4, '0');
    String rN = rnum.padLeft(2, '0');
    String chr = senddata;
    String cE = "000000000000003";

    String a="0";
    String sData = a + cast1 + gI + c + rN + chr + cE ;
    print("Sending String is : $sData"); // input is : *001000000102920000000000000000# output is : 003300010100FFFFFFFFA120F001B3

    return sData;

  }


}


