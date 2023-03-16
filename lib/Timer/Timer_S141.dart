//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/Singleton.dart';
import 'package:smart_home/Globaltimerdata.dart';

class S141TimerPage extends StatefulWidget {

  S141TimerPage({Key key, this.number}) : super(key: key);
  final String number;

  @override
  _S141TimerPageState createState() => _S141TimerPageState(number1: number);
}

class _S141TimerPageState extends State<S141TimerPage>{

  _S141TimerPageState({this.number1});
  final String number1;

  GlobalService _globalService = GlobalService();
  Globaltimer _globaltimer = Globaltimer();

  var s= Singleton();

  String Username,Usertype;
  String hname,hnum,rnum,rname,dnum,GroupIdset,ddevmodel,modeltypeset,devicenameset="name";

  String swValueS="";
  String fanv="No";

  Image bulbon=Image.asset('images/switchicons/bulb_on.png');
  Image bulboff=Image.asset('images/switchicons/bulb_off.png');

  Image imagehvon = Image.asset('images/switchicons/highvolt_on.png');
  Image imagehvoff = Image.asset('images/switchicons/highvolt_off.png');

  Image socketNOn = Image.asset('images/switchicons/socketOn.png');
  Image socketNOff = Image.asset('images/switchicons/socketOff.png');

  Image imagefanon  = Image.asset('images/switchicons/fan1.png');

  bool imgchange1=false;
  bool imgchange2=false;
  bool imgchange3=false;
  bool imgchange4=false;
  bool imgchange5=false;

  List ondataarray = [];
  List offdataarray = [];
  List switchnumber = [];

  String dropdownValue="0";
  Image img1_On,img1_Off,img2_On,img2_Off,img3_On,img3_Off,img4_Off,img4_On,img5_Off,img5_On;

  String sw1ondata,sw1offdata,sw2ondata,sw2offdata,sw3ondata,sw3offdata,sw4ondata,sw4offdata,sw5ondata,sw5offdata,fanondata="",fanoffdata="";
  String sw1n,sw2n,sw3n,sw4n,sw5n,fanswn;

  @override
  void initState() {
    // TODO: implement initState
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

    print("$hname,$hnum,$rnum,$rname,$dnum,$GroupIdset,$ddevmodel,$modeltypeset,$devicenameset");

    img1_Off = bulboff;
    img1_On= bulbon;

    img2_Off=bulboff;
    img2_On=bulbon;

    img3_Off=bulboff;
    img3_On=bulbon;

    img4_Off=imagehvoff;
    img4_On=imagehvon;

    img5_Off=socketNOff;
    img5_On=socketNOn;

    timer_dbfunction();


  }

  fanspeed(){

    print(fanondata.length);
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
    ondatafan = "$ondata1"+dropdownValue;
    fanondata=SendDataSwitchBoard(ondatafan, "01");
    fanoffdata=SendDataSwitchBoard("723", "01");
    fanswn="98";

    ondataarray.add(fanondata);
    offdataarray.add(fanoffdata);
    switchnumber.add(fanswn);

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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child:Transform.scale(
                                  scale: 2.5,
                                  child: IconButton(
                                      iconSize: MediaQuery.of(context).size.width/10,
                                      icon: imgchange1?img1_On:img1_Off,
                                      splashRadius: 0.1,
                                      splashColor:Colors.transparent ,
                                      onPressed: () {
                                        print("pressed");
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

                              Padding(padding: const EdgeInsets.all(10.0),),
                              Transform.scale(scale: 2.5,
                                child: IconButton(
                                  iconSize: MediaQuery.of(context).size.width/10,
                                  icon: imgchange4?img4_On:img4_Off,
                                  splashRadius: 0.1,
                                  splashColor:Colors.transparent ,
                                  onPressed: (){
                                    print("pressed");
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

                                  },
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
                      flex:10,
                      child: Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Transform.scale(scale: 2.5,
                                child: IconButton(
                                  iconSize: MediaQuery.of(context).size.width/10,
                                  icon: imgchange3?img3_On:img3_Off,
                                  splashRadius: 0.1,
                                  splashColor:Colors.transparent ,
                                  onPressed: (){

                                    print("pressed");
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
                                  },
                                ),
                              ),
                            )
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Transform.scale(
                                  scale: 2.5,
                                  child: new IconButton(
                                    iconSize: MediaQuery.of(context).size.width/10,
                                    icon: imgchange2?img2_On:img2_Off,
                                    splashRadius: 0.1,
                                    splashColor:Colors.transparent ,
                                    onPressed: (){

                                      print("pressed");
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
                                        print("$imgchange1");
                                      });

                                    },
                                  ),
                                ),

                              ),
                              Padding(padding: const EdgeInsets.all(10.0),),
                              Transform.scale(scale: 2.5,
                                child: IconButton(
                                  iconSize: MediaQuery.of(context).size.width/10,
                                  icon: imgchange5?img5_On:img5_Off,
                                  splashRadius: 0.1,
                                  splashColor:Colors.transparent ,
                                  onPressed: (){

                                    print("pressed");
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

                                  },
                                ),
                              )

                            ],
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
                                flex:6,
                              ),
                            ],
                          ),
                        )
                    )
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
                        flex: 10,
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

                                  savefan();
                                  print('Tapped');
                                },
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
                          child:Padding(padding: const EdgeInsets.all(5.0),),
                        )

                    ),
                  ],
                ),
              ],
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
    String sData = a + cast1 + gI + c + rN + chr + cE;
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