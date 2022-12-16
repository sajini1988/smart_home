//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/Singleton.dart';
import 'package:smart_home/Globaltimerdata.dart';

class TimerS110Page extends StatefulWidget {

  TimerS110Page({Key key, this.number}) : super(key: key);
  final String number;

  @override
  _TimerS110PageState createState() => _TimerS110PageState(number1:number);
}
class _TimerS110PageState extends State<TimerS110Page> {

  _TimerS110PageState({this.number1});
  final String number1;

  var s= Singleton();

  String Username,Usertype;

  GlobalService _globalService = GlobalService();
  Globaltimer _globaltimer = Globaltimer();
  String hname,hnum,rnum,rname,dnum,GroupIdset,ddevmodel,modeltypeset,devicenameset="name";
  String number="0";

  Image bulbon=Image.asset('images/switchicons/bulb_on.png');
  Image bulboff=Image.asset('images/switchicons/bulb_off.png');

  Image imagehvon = Image.asset('images/switchicons/highvolt_on.png');
  Image imagehvoff = Image.asset('images/switchicons/highvolt_off.png');

  Image socketNOn = Image.asset('images/switchicons/socketOn.png');
  Image socketNOff = Image.asset('images/switchicons/socketOff.png');

  bool imgchange1=false;
  bool imgchange2=false;

  List ondataarray = [];
  List offdataarray = [];
  List switchnumber = [];

  Image img1_On,img1_Off,img2_On,img2_Off;

  String sw1ondata,sw1offdata,sw2ondata,sw2offdata;
  String sw1n,sw2n;

  @override
  void initState(){
    super.initState();

    img1_Off=bulboff;
    img1_On=bulbon;

    img2_Off=socketNOff;
    img2_On=socketNOn;

    hname = _globalService.hname;
    hnum = _globalService.hnum;
    rnum = _globalService.rnum;
    rname = _globalService.rname;
    dnum = _globalService.dnum;
    GroupIdset = _globalService.groupId;
    ddevmodel = _globalService.ddevModel;
    modeltypeset = _globalService.modeltype;
    devicenameset = _globalService.devicename;

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
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              shrinkWrap: true,
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
                      flex:10,
                      child: Container(

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
                              ),
                            )

                        ),

                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex:10,
                      child: Container(
                          color:Colors.white,
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [

                              Padding(
                                padding: const EdgeInsets.all(05.0),
                                child:Transform.scale(
                                  scale: 2.5,
                                  child: IconButton(
                                      splashRadius: 0.1,
                                      splashColor:Colors.transparent,
                                      iconSize: MediaQuery.of(context).size.width/10,
                                      icon: imgchange1?img1_On:img1_Off,
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

                            ],
                          )
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
                  mainAxisAlignment: MainAxisAlignment.center,
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

                                  savedata();
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


  savedata()async{

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
