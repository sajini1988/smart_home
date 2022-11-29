import 'package:flutter/material.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/Moods/MoodDB.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/Moods/MoodDBModelClass.dart';
import 'package:smart_home/Moods/MoodList.dart';

class MoodProjSom extends StatefulWidget{

  MoodProjSom({Key key,this.number}):super(key:key);
  final String number;
  @override
  _MyHomePageState createState()=>_MyHomePageState(number1: number);
}
class _MyHomePageState extends State<MoodProjSom> {

  _MyHomePageState({this.number1});
  final String number1;

  String username,usertype;
  String setValue;

  String curValue;
  String curState;

  String hname,hnum,rnum,rname,dnum,dnumSheer,groupIdset,ddevmodel,modeltypeset,devicenameset="name",moodName;
  String deviceData,state,onOffNum,_aData,_bData,_cData,_dData,_eData,_fData,_gData,_hData,_iData,_jData;

  String dnumC;

  GlobalService _globalService = GlobalService();
  String number = "0";

  String swValueS="";
  String fanv="No";

  MDBHelper mdb;

  Image open=Image.asset('images/Curtain/open.png');
  Image open01=Image.asset('images/Curtain/open01.png');

  Image close=Image.asset('images/Curtain/close.png');
  Image close01=Image.asset('images/Curtain/close01.png');

  Image stop=Image.asset('images/Curtain/stop.png');
  Image stop01=Image.asset('images/Curtain/stop01.png');

  bool devChangeOpen=false;
  bool devChangeClose=false;



  @override
  void initState() {

    super.initState();

    curValue="000";
    curState="000";

    setValue="000";

    mdb = MDBHelper();

    print(number1);

    if(number1=="1"){
      dnumC = _globalService.moodlistdnum;
      rnum = _globalService.moodlistrnum;
    }
    else if(number1 == "0"){
      dnum = _globalService.dnum;
      rnum = _globalService.rnum;
    }

    hname = _globalService.hname;
    hnum = _globalService.hnum;
    rname = _globalService.rname;
    groupIdset = _globalService.groupId;
    ddevmodel = _globalService.ddevModel;
    modeltypeset = _globalService.modeltype;
    devicenameset = _globalService.devicename;
    number=_globalService.moodnum;

    if(number==("1")){
      moodName="Mood1";
    }
    else if(number==("2")){
      moodName="Mood2";
    }
    else if(number==("3")){
      moodName="Mood3";
    }
    moodDbFunction();
  }

  moodDbFunction()async{

    DBHelper dbHelper = DBHelper();
    List result = await dbHelper.getLocalDateHName(hname);

    username = result[0]['ld'];
    usertype = result[0]['lg'];

    if(number1 == "0") {
      if (ddevmodel == "PSC1") {
        dnumC=dnum;
      }
      else if (ddevmodel == "PLC1") {
        dnumC=dnum;
      }
      else if(ddevmodel == "SOSH"){
        dnumC=dnum;
      }
    }

    print("d is $dnumC");
    int count = await mdb.getCountHNumandRNumWithSetNumDnum(hname,hnum, rnum, number, dnumC, username);
    print(count);


    if (count == 0) {
      mdb.add(MoodDBData(hnum: hnum,
          hname: hname,
          rnum: rnum,
          rname: rname,
          moodstno: number,
          moodstname: moodName,
          devicetype: "Null",
          devicemodel: ddevmodel,
          devicenum: dnumC,
          onoffnum: "0",
          devicedata: setValue,
          aEdata: "No",
          bEdata: "Off",
          cEdata: devicenameset,
          dEdata: username,
          eEdata: "Null",
          fEdata: "Null",
          gEdata: "Null",
          hEdata: "Null",
          iEdata: "Null",
          jEdata: "Null"));
    }

    List res = await mdb.getMooddata(hname,hnum, rnum, number, dnumC, username);
    print("res is $res");

    hnum = res[0]['hn'];
    hname = res[0]['hna'];
    rnum = res[0]['rn'];
    rname = res[0]['rna'];
    number = res[0]['stno'];
    moodName = res[0]['stna'];
    ddevmodel = res[0]['dna'];
    dnum = res[0]['dno'];
    onOffNum = res[0]['Onoff'];
    deviceData = res[0]['dd'];
    _aData = res[0]['ea'];
    _bData = res[0]['eb'];
    _cData = res[0]['ec'];
    _dData = res[0]['ed'];
    _eData = res[0]['ee'];
    _fData = res[0]['ef'];
    _gData = res[0]['eg'];
    _hData = res[0]['eh'];
    _iData = res[0]['ei'];
    _jData = res[0]['ej'];

    print("c$_aData,$_bData,$_dData");


    List<String> results = deviceData.split(',');
    print(results);
    if(results.length == 1){

      if(results[0].startsWith("101")){
        devChangeOpen = true;
        curValue="101";
        curState="open";
      }
      else if(results[0].startsWith("102")){
        devChangeClose = true;
        curValue="102";
        curState="close";
      }

    }

    setState(() {
      devChangeOpen=devChangeOpen;
      devChangeClose=devChangeClose;
      devicenameset=_cData;
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
          child: Container(
            color: Colors.transparent,
            width:MediaQuery.of(context).size.width/1.4,
            child:ListView(
              shrinkWrap: true,
              children:<Widget> [

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Expanded(
                        flex:10,
                        child:Container(
                          color: Colors.white,
                          child:Padding(padding: const EdgeInsets.all(4.0),),
                        )

                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Expanded(
                        child: Container(
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              Expanded(
                                flex:3,
                                child: Container(
                                  color: Colors.white,
                                ),
                              ),

                              Expanded(
                                  flex:4,
                                  child:Container(
                                    color: Colors.white,
                                    child: Center(
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            "Mood $number",
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
                              Expanded(
                                  flex:3,
                                  child: Transform.scale(
                                    scale: 0.9,
                                    child: IconButton(
                                        icon: Image.asset("images/Timer/timer_list.png"),
                                        splashRadius: 0.1,
                                        splashColor:Colors.transparent,
                                        onPressed: () {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MoodListPage()));
                                        }
                                    ),
                                  )
                              ),
                            ],
                          ),
                        )
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
                          child:Padding(padding: const EdgeInsets.all(4.0),),
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
                          child:Center(
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  devicenameset,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal
                                  ),
                                  maxLines: 2,),
                              )
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
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(05.0),
                              child: Transform.scale(
                                scale: 2.0,
                                child: IconButton(
                                    iconSize: MediaQuery.of(context).size.width/10,
                                    icon: devChangeOpen?open01:open,
                                    splashRadius: 0.1,
                                    splashColor:Colors.transparent ,
                                    onPressed: () {

                                      if(devChangeOpen==true){
                                        devChangeOpen=false;
                                        devChangeClose=false;

                                        curValue="000";
                                        curState="None";

                                      }
                                      else if(devChangeOpen==false){
                                        devChangeOpen=true;
                                        devChangeClose=false;

                                        curValue="101";
                                        curState="Open";
                                      }

                                      setState(() {
                                        devChangeOpen=devChangeOpen;
                                        devChangeClose=devChangeClose;
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
                                scale: 2.0,

                                // visible: bothclose,
                                child: IconButton(
                                    iconSize: MediaQuery.of(context).size.width/10,
                                    icon: devChangeClose?close01:close,
                                    splashRadius: 0.1,
                                    splashColor:Colors.transparent ,
                                    onPressed: () {

                                      if(devChangeClose==true){

                                        curValue="000";
                                        curState="None";

                                        devChangeClose=false;
                                        devChangeOpen=false;
                                      }
                                      else if(devChangeClose==false){

                                        curValue="102";
                                        curState="Close";

                                        devChangeClose=true;
                                        devChangeOpen=false;
                                      }

                                      setState(() {
                                        devChangeClose=devChangeClose;
                                        devChangeOpen=devChangeOpen;
                                      });

                                    }
                                ),

                              ),
                            ),

                          ],
                        )
                      ),
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
                                Navigator.of(context,rootNavigator: true).pop();
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

                                Navigator.of(context,rootNavigator: true).pop();
                                saveDevice();
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
                          child:Padding(padding: const EdgeInsets.all(5.0),),
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

  saveDevice()async{

    print("$curValue,$curState");

    String adata,curVV,state;

    if(curValue.startsWith("000")){
      adata="No";
    }
    else{
      adata="Yes";
    }


    if(ddevmodel == "PSC1"){
      curVV=curValue;
      state= curState;
    }
    if(ddevmodel == "PLC1"){
      curVV=curValue;
      state= curState;
    }
    else if(ddevmodel == "SOSH"){
      curVV=curValue;
      state= curState;
    }


    int res = await mdb.update(MoodDBData(hnum: hnum,hname: hname,rnum: rnum,rname: rname, moodstno: number, moodstname: moodName, devicetype: "Null",devicemodel: ddevmodel,
        devicenum:dnumC, onoffnum:"0", devicedata: curVV, aEdata: adata,bEdata:state,cEdata:_cData, dEdata:username, eEdata:_eData,fEdata:_fData,gEdata:_gData,hEdata:_hData,iEdata:_iData,jEdata: _jData));

    print("update $res");

  }


}
