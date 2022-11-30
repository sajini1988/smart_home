
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/Moods/MoodDB.dart';
import 'MoodDBModelClass.dart';
import 'package:smart_home/Moods/MoodList.dart';

class MoodOnPage extends StatefulWidget {

  MoodOnPage({Key key, this.number}) : super(key: key);
  final String number;
  @override
  _MoodOnPageState createState() => _MoodOnPageState(number1: number);
}

class _MoodOnPageState extends State<MoodOnPage> {

  _MoodOnPageState({this.number1});
  final String number1;

  String username,usertype;
  String hname,hnum,rnum,rname,dnum,groupIdset,ddevmodel,modeltypeset,devicenameset="name",moodname;
  GlobalService _globalService = GlobalService();
  String number="0";

  String devicedata,state,onoffnum,aData,bData,cData,dData,eData,fData,gData,hData,iData,jData;

  String swValueS="";

  bool imgchange1=false;

  Image bulbon=Image.asset('images/switchicons/bulb_on.png');
  Image bulboff=Image.asset('images/switchicons/bulb_off.png');

  MDBHelper mdb;

  Image img1On,img1Off;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    mdb = MDBHelper();

    print(number1);

    if(number1=="1"){
      dnum = _globalService.moodlistdnum;
      rnum=_globalService.moodlistrnum;
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

    if(number.contains("1")){
      moodname="Mood1";
    }
    else if(number.contains("2")){
      moodname="Mood2";
    }
    else if(number.contains("3")){
      moodname="Mood3";
    }

    img1Off = bulboff;
    img1On= bulbon;

    mooddbfunction();
  }

  mooddbfunction()async {
    DBHelper dbHelper = DBHelper();
    List result = await dbHelper.getLocalDateHName(hname);

    username = result[0]['ld'];
    usertype = result[0]['lg'];

    int count = await mdb.getCountHNumandRNumWithSetNumDnum(hname,hnum, rnum, number, dnum, username);
    print(count);

    if (count == 0) {
      mdb.add(MoodDBData(hnum: hnum,
          hname: hname,
          rnum: rnum,
          rname: rname,
          moodstno: number,
          moodstname: moodname,
          devicetype: "Null",
          devicemodel: ddevmodel,
          devicenum: dnum,
          onoffnum: "0",
          devicedata: "0",
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

    List res = await mdb.getMooddata(hname,hnum, rnum, number, dnum, username);
    print(res);

    hnum = res[0]['hn'];
    hname = res[0]['hna'];
    rnum = res[0]['rn'];
    rname = res[0]['rna'];
    number = res[0]['stno'];
    moodname = res[0]['stna'];
    ddevmodel = res[0]['dna'];
    dnum = res[0]['dno'];
    onoffnum = res[0]['Onoff'];
    devicedata = res[0]['dd'];
    aData = res[0]['ea'];
    bData = res[0]['eb'];
    cData = res[0]['ec'];
    dData = res[0]['ed'];
    eData = res[0]['ee'];
    fData = res[0]['ef'];
    gData = res[0]['eg'];
    hData = res[0]['eh'];
    iData = res[0]['ei'];
    jData = res[0]['ej'];

    List<String> results = devicedata.split(':');
    print(results);

    for (int i = 0; i < results.length; i++) {
      String s = results[i];
      print("ss $s");

      if (s.startsWith("201")) {
        print("enter1");
        imgchange1 = true;
      }
      else if(s.startsWith("301")){
        imgchange1=false;
      }

      setState(() {
        imgchange1 = imgchange1;
        devicenameset=cData;
      });
    }
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:[
                    Expanded(
                      flex:10,
                      child:Container(
                        color:Colors.white,
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(padding: const EdgeInsets.all(10.0),
                              child:Transform.scale(
                                scale: 3,
                                child: IconButton(
                                    icon: imgchange1?img1On:img1Off,
                                    splashRadius: 0.1,
                                    splashColor:Colors.transparent ,
                                    onPressed: () {
                                      print("pressed");
                                      if(imgchange1==true){
                                        imgchange1=false;
                                      }
                                      else if(imgchange1==false){
                                        imgchange1=true;
                                      }
                                      setState(() {
                                        imgchange1=imgchange1;
                                        print("$imgchange1");
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
                          child:Padding(padding: const EdgeInsets.all(5.0),),
                        )

                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ), );
  }

  savefan()async{

    if(imgchange1 == true){
      swValueS="201";
    }
    else if(imgchange1 == false){
      swValueS="301";
    }



    if(swValueS==("201")){
      state="On";
      onoffnum="1";
    }
    else if(swValueS==("301")){
      state = "Off";
      onoffnum = "1";
    }

    print("swvalue $swValueS \nState $state \nOnOffnum $onoffnum");


    int res = await mdb.update(MoodDBData(hnum: hnum,hname: hname,rnum: rnum,rname: rname, moodstno: number, moodstname: moodname, devicetype: "Null",devicemodel: ddevmodel,
        devicenum: dnum, onoffnum:onoffnum, devicedata: swValueS, aEdata: "Yes", bEdata:state,cEdata:cData,dEdata:dData,eEdata:eData,fEdata:fData,gEdata:gData,hEdata:hData,iEdata:iData,jEdata: jData));

    print("update $res");

  }

}


