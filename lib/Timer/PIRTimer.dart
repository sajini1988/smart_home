import 'package:flutter/material.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/Globaltimerdata.dart';
import 'package:smart_home/Timer/GlobalEditTimerListdata.dart';

class TimerPIRPage extends StatefulWidget {

  TimerPIRPage({Key key, this.number}) : super(key: key);
  final String number;

  @override
  _TimerPIRPageState createState() => _TimerPIRPageState(number1: number);
}

class _TimerPIRPageState extends State<TimerPIRPage> {

  _TimerPIRPageState({this.number1});
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

  bool imgsm= false;
  bool imgsi= false;

  String _pirenable,_pirdisable,_lightenable,_lightdisable;

  String onData,offData;
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

    _timerdbfunction();
  }

  _timerdbfunction()async {

    DBHelper dbHelper = DBHelper();
    List result = await dbHelper.getLocalDateHName(hname);

    username = result[0]['ld'];
    usertype = result[0]['lg'];

    print(number1);

    setState(() {

      if(number1 == "1"){
        onData = _globalEdittimer.ondata;
        offData = _globalEdittimer.offdata;

        print("data $onData,$offData");

        ondataarray = ondataarray1= onData.split(";");
        offdataarray = offdataarray1= offData.split(";");

        print(ondataarray.length);
        print(offdataarray.length);

        if(ondataarray.length==1){

          String data = _ondatasend = ondataarray[0];
          String data1 = _offdatasend = offdataarray[0];

          String selected = data[12]+data[13]+data[14];
          if(selected == "909"){
            _pirenable=data;
            _pirdisable=data1;
            imgsm=true;
            imgsi=false;
          }
          else if(selected == "101"){
            _lightenable=data;
            _lightdisable=data1;
            imgsm=false;
            imgsi=true;
          }
        }
        else if(ondataarray.length==2){

          String data = ondataarray[0];
          String data1 = ondataarray[1];

          print("$data,$data1");

          String offdata = offdataarray[0];
          String offdata1 = offdataarray[1];

          print("$offdata,$offdata1");

          _ondatasend=ondataarray[0]+';'+ondataarray[1];
          _offdatasend=offdataarray[0]+';'+offdataarray[1];

          String selected = data[12]+data[13]+data[14];
          print(selected);
          if(selected == "909"){
            _pirenable=data;
            _pirdisable=offData;
            imgsm=true;

          }
          else if(selected == "101"){
            _lightenable=data;
            _lightdisable=offdata;
            imgsi=true;
          }


          String selected1 = data1[12]+data1[13]+data1[14];
          print(selected1);
          if(selected1 == "909"){
            _pirenable=data1;
            _pirdisable=offdata1;
            imgsm=true;

          }
          else if(selected1 == "101"){
            _lightenable=data1;
            _lightdisable=offdata1;
            imgsi=true;
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
                                    icon: imgsm?img2:img1,
                                    onPressed: () {

                                        if(imgsm == true){
                                          imgsm=false;
                                          ondataarray.remove(_pirenable);
                                          offdataarray.remove(_pirdisable);
                                        }
                                        else if(imgsm == false){
                                          imgsm=true;
                                          _pirenable = sendDataPIR("909","01");
                                          _pirdisable = sendDataPIR("910","01");
                                          ondataarray.add(_pirenable);
                                          offdataarray.add(_pirdisable);
                                        }
                                        setState(() {
                                          imgsm=imgsm;
                                        });
                                      },
                                  ),
                                )
                              ),

                              Expanded(
                                flex:6,
                                child: Text("Motion"),
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
                                    icon: imgsi?img2:img1,
                                    onPressed: () {
                                        if(imgsi == true){
                                          imgsi=false;
                                          ondataarray.remove(_lightenable);
                                          offdataarray.remove(_lightdisable);
                                        }
                                        else if(imgsi == false){
                                          imgsi=true;
                                          _lightenable = sendDataPIR("101","01");
                                          _lightdisable = sendDataPIR("102","01");
                                          ondataarray.add(_lightenable);
                                          offdataarray.add(_lightdisable);
                                        }
                                        setState(() {
                                          imgsi=imgsi;
                                        });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                flex:6,
                                child:Text("Intensity") ,
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
                                      print("Select Switch for timers to be set");
                                    }
                                    else{


                                      if(ondataarray.length == 1){

                                        _ondatasend=ondataarray[0];
                                        _offdatasend=offdataarray[0];

                                        ondataarray1.add(_ondatasend);
                                        offdataarray1.add(_offdatasend);
                                        switchnumber.add("0");
                                      }
                                      else if(ondataarray.length == 2){

                                        _ondatasend=ondataarray[0]+';'+ondataarray[1];
                                        _offdatasend=offdataarray[0]+';'+offdataarray[1];

                                        ondataarray1.add(_ondatasend);
                                        offdataarray1.add(_offdatasend);
                                        switchnumber.add("0");
                                      }

                                       Navigator.pop(context);
                                        _globaltimer.ondataarrayset=ondataarray1;
                                        _globaltimer.offdataarrayset=offdataarray1;
                                        _globaltimer.switchnumberset=switchnumber;

                                        print("data is $_ondatasend,$_offdatasend,$ondataarray1,$offdataarray1,$switchnumber");

                                        if(number1 == "1"){
                                          _globalEdittimer.ondataset=_ondatasend;
                                          _globalEdittimer.offdataset=_offdatasend;
                                        }
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
  sendDataPIR(String senddata,String casttype){

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


