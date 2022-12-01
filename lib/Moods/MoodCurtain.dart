import 'package:flutter/material.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/Moods/MoodDB.dart';
import 'package:smart_home/GlobalService.dart';
import 'MoodDBModelClass.dart';

class MoodCurtain extends StatefulWidget{

  MoodCurtain({Key key,this.number}):super(key:key);
  final String number;
  @override
  _MyHomePageState createState()=>_MyHomePageState(number1: number);
}
class _MyHomePageState extends State<MoodCurtain> {
  _MyHomePageState({this.number1});
  final String number1;

  String username,usertype;
  String setValue;

  String curValue,sheerValue;
  String curState,sheerState;

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

  bool sheerchangeopen=false;
  bool sheerchangeclose=false;

  bool curtainChangeOpen=false;
  bool curtainChangeClose=false;

  bool sheerLabelVisible=false;
  bool sheerOpen=false;
  bool sheerClose=false;

  @override
  void initState() {

    super.initState();

    curValue="000";
    sheerValue="000";

    curState="000";
    sheerState="000";

    setValue="000,000";

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
    dnumSheer=_globalService.sheerdnum;


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

    if(number1 == "0"){

      if(ddevmodel==("CLNR")){

        print("num $dnumSheer");
        if(dnumSheer==("0000")){
          print("enter zero");
          sheerLabelVisible=false;
          sheerOpen = false;
          sheerClose = false;
          dnumC=dnum;
        }
        else if(dnumSheer.length==0){
          print("enter length zero");
          sheerLabelVisible=false;
          sheerOpen = false;
          sheerClose = false;
          dnumC=dnum;
        }
        else{
          print("enter not zero");
          sheerLabelVisible=true;
          sheerOpen = true;
          sheerClose = true;
          dnumC=dnum+','+dnumSheer;
        }
      }
      else if(ddevmodel==("CLS1")){
        sheerLabelVisible=false;
        sheerOpen=false;
        sheerClose=false;

        dnumC=dnum;
      }
      else if(ddevmodel.contains("CRS1")){
        sheerLabelVisible=false;
        sheerClose=false;
        sheerOpen=false;

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


    if(number1=="1"){
      if(ddevmodel == "CLNR"){
        List<String> dnumResults = dnum.split(',');
        print(dnumResults);
        if(dnumResults.length == 1){
          sheerLabelVisible=false;
          sheerOpen = false;
          sheerClose = false;
        }
        else{
          sheerLabelVisible=true;
          sheerOpen = true;
          sheerClose = true;
        }
      }
      else if(ddevmodel == "CLS1"){

        sheerLabelVisible=false;
        sheerOpen=false;
        sheerClose=false;

      }
      else if(ddevmodel == "CRS1"){

        sheerLabelVisible=false;
        sheerOpen=false;
        sheerClose=false;

      }

    }

    List<String> results = deviceData.split(',');
    print(results);
    if(results.length == 1){

      if(results[0].startsWith("101")){
        curtainChangeOpen = true;
        curValue="101";
        curState="Cu_op";
      }
      else if(results[0].startsWith("102")){
        curtainChangeClose = true;
        curValue="102";
        curState="Cu_cl";
      }

    }
    else if(results.length == 2){

      if(results[0].startsWith("101")){
        curtainChangeOpen = true;
        curValue="101";
        curState="Cu_op";
      }
      else if(results[0].startsWith("102")){
        curtainChangeClose = true;
        curValue="102";
        curState="Cu_cl";
      }

      if(results[1].startsWith("105")){
        sheerchangeopen=true;
        sheerValue="105";
        sheerState="Sh_op";
      }
      else if(results[1].startsWith("106")){
        sheerchangeclose=true;
        sheerValue="106";
        sheerState="Sh_cl";
      }
    }
    setState(() {
      sheerLabelVisible=sheerLabelVisible;
      sheerClose=sheerClose;
      sheerOpen=sheerOpen;
      curtainChangeOpen=curtainChangeOpen;
      curtainChangeClose=curtainChangeClose;
      sheerchangeopen=sheerchangeopen;
      sheerchangeclose=sheerchangeclose;
      devicenameset=_cData;
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(devicenameset,style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontStyle: FontStyle.normal),
                    ),
                  )
                  )
                ],
              ),
              Padding(padding: const EdgeInsets.all(10.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child:Visibility(
                        child: Text("Curtain")
                    ),
                  ),
                ],
              ),
              Padding(padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Transform.scale(
                      scale: 2.0,
                      child:Visibility(
                       // visible: bothopen,
                        child: IconButton(
                            iconSize: MediaQuery.of(context).size.width/10,
                            icon: curtainChangeOpen?open01:open,
                            splashRadius: 0.1,
                            splashColor:Colors.transparent ,
                            onPressed: () {

                              if(curtainChangeOpen==true){
                                curtainChangeOpen=false;
                                curtainChangeClose=false;

                                curValue="000";
                                curState="Cu_none";

                              }
                              else if(curtainChangeOpen==false){
                                curtainChangeOpen=true;
                                curtainChangeClose=false;

                                curValue="101";
                                curState="Cu_op";
                              }

                              setState(() {
                                curtainChangeOpen=curtainChangeOpen;
                                curtainChangeClose=curtainChangeClose;
                              });

                            }
                        ),
                      ),
                    ),

                    Transform.scale(
                      scale: 2.0,
                      child:Visibility(
                       // visible: bothclose,
                        child: IconButton(
                          iconSize: MediaQuery.of(context).size.width/10,
                          icon: curtainChangeClose?close01:close,
                          splashRadius: 0.1,
                          splashColor:Colors.transparent ,
                          onPressed: () {

                            curValue="102";
                            curState="Cu_cl";

                            if(curtainChangeClose==true){

                              curValue="000";
                              curState="Cu_None";

                              curtainChangeClose=false;
                              curtainChangeOpen=false;
                            }
                            else if(curtainChangeClose==false){

                              curValue="102";
                              curState="Cu_cl";

                              curtainChangeClose=true;
                              curtainChangeOpen=false;
                            }

                            setState(() {
                              curtainChangeClose=curtainChangeClose;
                              curtainChangeOpen=curtainChangeOpen;
                            });

                          }
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(padding: const EdgeInsets.all(10.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child:Visibility(
                      visible: sheerLabelVisible,
                        child: Text("Sheer")
                    ),
                  ),
                ],
              ),

              Padding(padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Transform.scale(
                      scale: 2.0,
                      child:Visibility(
                        visible: sheerOpen,
                        child: IconButton(
                            iconSize: MediaQuery.of(context).size.width/10,
                            icon: sheerchangeopen?open01:open,
                            splashRadius: 0.1,
                            splashColor:Colors.transparent ,
                            onPressed: () {

                              if(sheerchangeopen==true){
                                sheerValue="000";
                                sheerState="Sh_none";

                                sheerchangeopen=false;
                                sheerchangeclose=false;
                              }
                              else if(sheerchangeopen==false){

                                sheerValue="105";
                                sheerState="Sh_op";

                                sheerchangeopen=true;
                                sheerchangeclose=false;
                              }

                              setState(() {
                                sheerchangeopen=sheerchangeopen;
                                sheerchangeclose=sheerchangeclose;
                              });

                            }
                        ),
                      ),
                    ),

                    Transform.scale(
                      scale: 2.0,
                      child:Visibility(
                        visible: sheerClose,
                        child: IconButton(
                          iconSize: MediaQuery.of(context).size.width/10,
                          icon: sheerchangeclose?close01:close,
                          splashRadius: 0.1,
                          splashColor:Colors.transparent ,
                          onPressed: () {

                            if(sheerchangeclose==true){
                              sheerchangeclose=false;
                              sheerchangeopen=false;

                              sheerValue="000";
                              sheerState="Sh_none";
                            }
                            else if(sheerchangeclose==false){
                              sheerchangeclose=true;
                              sheerchangeopen=false;

                              sheerValue="106";
                              sheerState="Sh_cl";
                            }

                            setState(() {
                              sheerchangeclose=sheerchangeclose;
                              sheerchangeopen=sheerchangeopen;
                            });

                          }
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(padding: const EdgeInsets.all(5.0),),
              Container(
                height: 2,
                color: Colors.black54,
              ),
              Padding(padding: const EdgeInsets.all(5.0),),
              Row(

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
                        Navigator.of(context,rootNavigator: true).pop();
                        print('Tapped');
                      },
                      //   color: Colors.blueAccent,
                      //
                      //   onPressed: () =>
                      //   {
                      //   },
                      // child: Text(
                      //       "Cancel", softWrap: false, maxLines: 1,),
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
                        savecurtain();
                        print('Tapped');
                      },
                      //   color: Colors.blueAccent,
                      //
                      //   onPressed: () =>
                      //   {
                      //   },
                      // child: Text(
                      //       "Cancel", softWrap: false, maxLines: 1,),
                    ),
                  ]
              ),
            ],
          ),
        ),
      ),

    );
  }

  savecurtain()async{

    print("$curValue,$curState");
    print("$sheerValue,$sheerState");

    String adata,curVV,state;

    if(curValue.startsWith("000") && sheerValue.startsWith("000")){
      adata="No";
    }
    else{
      adata="Yes";
    }


    if(ddevmodel == "CRS1"){
      curVV=curValue;
      state= curState;
    }
    else if(ddevmodel == "CLS1"){
      curVV=curValue;
      state= curState;
    }
    else if(ddevmodel == "CLNR"){

      if(curValue=="000"){
        curVV=sheerValue;
        state=sheerState;
      }
      else if(sheerValue=="000"){
        curVV=curValue;
        state=curState;
      }
      else{
        curVV=curValue+","+sheerValue;
        state= curState+','+sheerState;
      }
    }



    int res = await mdb.update(MoodDBData(hnum: hnum,hname: hname,rnum: rnum,rname: rname, moodstno: number, moodstname: moodName, devicetype: "Null",devicemodel: ddevmodel,
        devicenum:dnumC, onoffnum:"0", devicedata: curVV, aEdata: adata,bEdata:state,cEdata:_cData, dEdata:username, eEdata:_eData,fEdata:_fData,gEdata:_gData,hEdata:_hData,iEdata:_iData,jEdata: _jData));

    print("update $res");

  }


}
