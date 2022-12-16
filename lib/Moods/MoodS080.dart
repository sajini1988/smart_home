//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/Moods/MoodDB.dart';
import 'package:smart_home/Moods/MoodDBModelClass.dart';
import 'package:smart_home/Moods/MoodList.dart';

class MoodS080Page extends StatefulWidget {
  MoodS080Page({Key key, this.number}) : super(key: key);
  final String number;
  @override
  _MoodS080PageState createState() => _MoodS080PageState(number1: number);
}
class _MoodS080PageState extends State<MoodS080Page> {

  _MoodS080PageState({this.number1});
  final String number1;

  String username,usertype;

  GlobalService _globalService = GlobalService();
  String hname,hnum,rnum,rname,dnum,groupIdset,ddevmodel,modeltypeset,devicenameset="name",moodName;
  String number="0";

  String fanv="No";

  String deviceData,state,onOffNum,aData,bData,cData,dData,eData,fData,gData,hData,iData,jData;

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

  MDBHelper mdb;

  Image img1On,img1Off,img2On,img2Off,img3On,img3Off,img4Off,img4On,img5Off,img5On,img6Off,img6On,img7Off,img7On,img8Off,img8On;

  @override
  void initState(){
    super.initState();

    mdb = MDBHelper();

    print(number1);

    if(number1=="1"){
      dnum = _globalService.moodlistdnum;
      rnum = _globalService.moodlistrnum;
    }
    else if(number1 == "0"){
      dnum = _globalService.dnum;
      rnum = _globalService.rnum;
    }


    hname = _globalService.hname;
    hnum = _globalService.hnum;
    rnum = _globalService.rnum;
    rname = _globalService.rname;
    groupIdset = _globalService.groupId;
    ddevmodel = _globalService.ddevModel;
    modeltypeset = _globalService.modeltype;
    devicenameset = _globalService.devicename;
    number=_globalService.moodnum;

    if(number.contains("1")){
      moodName="Mood1";
    }
    else if(number.contains("2")){
      moodName="Mood2";
    }
    else if(number.contains("3")){
      moodName="Mood3";
    }

    img1Off=bulboff;
    img1On=bulbon;

    img2Off=bulboff;
    img2On=bulbon;

    img3Off=bulboff;
    img3On=bulbon;

    img4Off=bulboff;
    img4On=bulbon;

    img5Off=bulboff;
    img5On=bulbon;

    img6Off=bulboff;
    img6On=bulbon;

    img7Off=imagehvoff;
    img7On=imagehvon;

    img8Off=imagehvoff;
    img8On=imagehvon;

    moodDbFunction();
  }

  moodDbFunction()async{

    DBHelper dbHelper = DBHelper();
    List result = await dbHelper.getLocalDateHName(hname);
    print("res $result");

    username = result[0]['ld'];
    usertype = result[0]['lg'];

    print("name $usertype,$username");

    int count = await mdb.getCountHNumandRNumWithSetNumDnum(hname,hnum, rnum, number, dnum, username);
    print(count);


    if(count == 0){

      mdb.add(MoodDBData(hnum: hnum,hname: hname,rnum: rnum,rname: rname, moodstno: number, moodstname: moodName, devicetype: "Null",devicemodel: ddevmodel,
          devicenum: dnum, onoffnum:"0", devicedata: "0", aEdata: "No", bEdata:"Off",cEdata:devicenameset,dEdata:username,eEdata:"Null",fEdata:"Null",gEdata:"Null",hEdata:"Null",iEdata: "Null",jEdata: "Null"));

    }

    List res = await mdb.getMooddata(hname,hnum, rnum, number, dnum, username);
    print(res);

    hnum=res[0]['hn'];
    hname=res[0]['hna'];
    rnum=res[0]['rn'];
    rname=res[0]['rna'];
    number=res[0]['stno'];
    moodName=res[0]['stna'];
    ddevmodel=res[0]['dna'];
    dnum=res[0]['dno'];
    onOffNum=res[0]['Onoff'];
    deviceData=res[0]['dd'];
    aData=res[0]['ea'];
    bData=res[0]['eb'];
    cData=res[0]['ec'];
    dData=res[0]['ed'];
    eData=res[0]['ee'];
    fData=res[0]['ef'];
    gData=res[0]['eg'];
    hData=res[0]['eh'];
    iData=res[0]['ei'];
    jData=res[0]['ej'];

    List<String> results = deviceData.split(':');
    print(results);

    for(int i=0;i<results.length;i++){
      String s= results[i];
      print("ss $s");

      if(s.startsWith("1")){

        print("enter1");
        imgchange1=true;
      }

      if(s.startsWith("2")){
        print("enter2");
        imgchange2=true;
      }

      if(s.startsWith("3")){
        print("enter3");
        imgchange3=true;
      }

      if(s.startsWith("4")){
        print("enter4");
        imgchange4=true;
      }

      if(s.startsWith("5")){
        print("enter5");
        imgchange5=true;
      }

      if(s.startsWith("6")){
        print("enter6");
        imgchange6=true;
      }

      if(s.startsWith("7")){
        print("enter7");
        imgchange7=true;
      }

      if(s.startsWith("8")){
        print("enter8");
        imgchange8=true;
      }

      setState(() {
        imgchange1=imgchange1;
        imgchange2=imgchange2;
        imgchange3=imgchange3;
        imgchange4=imgchange4;
        imgchange5=imgchange5;
        imgchange6=imgchange6;
        imgchange7=imgchange7;
        imgchange8=imgchange8;
        devicenameset=cData;

      });

    }
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
            color:Colors.white,
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
                          child:Padding(padding: const EdgeInsets.all(4.0),),
                        )

                    ),
                  ],
                ),



                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                  children:[
                    Expanded(
                      flex:10,
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
                            ),
                          )
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

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        flex:10,
                        child:Container(
                          color:Colors.white,
                          child:Row(
                            mainAxisAlignment:MainAxisAlignment.spaceAround,
                              children:[
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
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
                                Padding(padding: const EdgeInsets.all(05.0),
                                  child:Transform.scale(
                                    scale: 2.5,
                                    child: IconButton(
                                      iconSize: MediaQuery.of(context).size.width/10,
                                        icon: imgchange2?img2On:img2Off,
                                        splashRadius: 0.1,
                                        splashColor:Colors.transparent,
                                        onPressed: () {

                                          if(imgchange2==true){
                                            imgchange2=false;
                                          }
                                          else if(imgchange2==false){
                                            imgchange2=true;
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
                                        icon: imgchange3?img3On:img3Off,
                                        splashRadius: 0.1,
                                        splashColor:Colors.transparent ,
                                        onPressed: () {

                                        if(imgchange3==true){
                                          imgchange3=false;
                                        }
                                        else if(imgchange3==false){
                                          imgchange3=true;
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
                        ),
                      ),
                    ]
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
                              padding: const EdgeInsets.all(5.0),
                              child:Transform.scale(
                                scale: 2.5,
                                child: IconButton(
                                    iconSize: MediaQuery.of(context).size.width/10,
                                    icon: imgchange4?img4On:img4Off,

                                    splashRadius: 0.1,
                                    splashColor:Colors.transparent ,
                                    onPressed: () {

                                      if(imgchange4==true){
                                        imgchange4=false;
                                      }
                                      else if(imgchange4==false){
                                        imgchange4=true;
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
                                    icon: imgchange5?img5On:img5Off,
                                    splashRadius: 0.1,
                                    splashColor:Colors.transparent ,
                                    onPressed: () {
                                      if(imgchange5==true){
                                        imgchange5=false;
                                      }
                                      else if(imgchange5==false){
                                        imgchange5=true;
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
                                    icon: imgchange6?img6On:img6Off,
                                    splashRadius: 0.1,
                                    splashColor:Colors.transparent ,
                                    onPressed: () {

                                      if(imgchange6==true){
                                        imgchange6=false;
                                      }
                                      else if(imgchange6==false){
                                        imgchange6=true;
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
                                    icon: imgchange7?img7On:img7Off,
                                    splashRadius: 0.1,
                                    splashColor:Colors.transparent ,
                                    onPressed: () {

                                      if(imgchange7==true){
                                        imgchange7=false;
                                      }
                                      else if(imgchange7==false){
                                        imgchange7=true;
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

                            Padding(
                              padding: const EdgeInsets.all(05.0),

                              child:Transform.scale(
                                scale: 2.5,
                                child: IconButton(
                                    iconSize: MediaQuery.of(context).size.width/10,
                                    icon: imgchange8?img8On:img8Off,
                                    splashRadius: 0.1,
                                    splashColor:Colors.transparent ,
                                    onPressed: () {

                                      if(imgchange8==true){
                                        imgchange8=false;
                                      }
                                      else if(imgchange8==false){
                                        imgchange8=true;
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
                                      fit: BoxFit.fill),
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
                  ],
                ),
              ],
            ),
          ),

        ),
      ),
    );
  }

  savefan()async{

    String swValueS="";
    if(imgchange1 == true) {
      if (imgchange2 == true) {
        if (imgchange3 == true) {
          if (imgchange4 == true) {
            if (imgchange5 == true) {
              if (imgchange6 == true) {
                if (imgchange7 == true) {
                  swValueS = "1:2:3:4:5:6:7";
                }
                else {
                  swValueS = "1:2:3:4:5:6";
                }
              }
              else {
                if (imgchange7 == true) {
                  swValueS = "1:2:3:4:5:7";
                }
                else {
                  swValueS = "1:2:3:4:5";
                }
              }
            }
            else {
              if (imgchange6 == true) {

                if (imgchange7 == true) {

                  swValueS = "1:2:3:4:6:7";
                }
                else {
                  swValueS = "1:2:3:4:6";
                }
              }
              else {
                if (imgchange7 == true) {
                  swValueS = "1:2:3:4:7";
                }
                else {
                  swValueS = "1:2:3:4";
                }
              }
            }
          }
          else {
            if (imgchange5 == true) {
              if (imgchange6 == true) {
                if (imgchange7 == true) {
                    swValueS = "1:2:3:5:6:7";
                }
                else {
                  swValueS = "1:2:3:5:6";
                }
              }
              else {
                if (imgchange7 == true) {
                  swValueS = "1:2:3:5:7";
                }
                else {
                  swValueS = "1:2:3:5";
                }
              }
            }
            else {
              if (imgchange6 == true) {
                if (imgchange7 == true) {
                  swValueS = "1:2:3:6:7";
                }
                else {
                  swValueS = "1:2:3:6";
                }
              }
              else {
                if (imgchange7 == true) {
                  swValueS = "1:2:3:7";
                }
                else {
                  swValueS = "1:2:3";
                }
              }
            }
          }
        }
        else {
          if (imgchange4 == true) {
            if (imgchange5 == true) {
              if (imgchange6 == true) {
                if (imgchange7 == true) {
                  swValueS = "1:2:4:5:6:7";
                }
                else {
                  swValueS = "1:2:4:5:6";
                }
              }
              else {
                if (imgchange7 == true) {
                  swValueS = "1:2:4:5:7";
                }
                else {
                  swValueS = "1:2:4:5";
                }
              }
            }
            else {
              if (imgchange6 == true) {
                if (imgchange7 == true) {
                  swValueS = "1:2:4:6:7";
                }
                else {
                  swValueS = "1:2:4:6";
                }
              }
              else {
                if (imgchange7 == true) {
                  swValueS = "1:2:4:7";
                }
                else {
                  swValueS = "1:2:4";
                }
              }
            }
          }
          else {
            if (imgchange5 == true) {
              if (imgchange6 == true) {
                if (imgchange7 == true) {
                  swValueS = "1:2:5:6:7";
                }
                else {
                  swValueS = "1:2:5:6";
                }
              }
              else {
                if (imgchange7 == true) {
                  swValueS = "1:2:5:7";
                }
                else {
                  swValueS = "1:2:5";
                }
              }
            }
            else {
              if (imgchange6 == true) {
                if (imgchange7 == true) {
                  swValueS = "1:2:6:7";
                }
                else {
                  swValueS = "1:2:6";
                }
              }
              else {
                if (imgchange7 == true) {
                  swValueS = "1:2:7";
                }
                else {
                  swValueS = "1:2";
                }
              }
            }
          }
        }
      }
      else {
        if (imgchange3 == true) {
          if (imgchange4 == true) {
            if (imgchange5 == true) {
              if (imgchange6 == true) {
                if (imgchange7 == true) {
                  swValueS = "1:3:4:5:6:7";
                }
                else {
                  swValueS = "1:3:4:5:6";
                }
              }
              else {
                if (imgchange7 == true) {
                  swValueS = "1:3:4:5:7";
                }
                else {
                  swValueS = "1:3:4:5";
                }
              }
            }
            else {
              if (imgchange6 == true) {
                if (imgchange7 == true) {
                  swValueS = "1:3:4:6:7";
                }
                else {
                  swValueS = "1:3:4:6";
                }
              }
              else {
                if (imgchange7 == true) {
                  swValueS = "1:3:4:7";
                }
                else {
                  swValueS = "1:3:4";
                }
              }
            }
          }
          else {
            if (imgchange5 == true) {
              if (imgchange6 == true) {
                if (imgchange7 == true) {
                  swValueS = "1:3:5:6:7";
                }
                else {
                  swValueS = "1:3:5:6";
                }
              }
              else {
                if (imgchange7 == true) {
                  swValueS = "1:3:5:7";
                }
                else {
                  swValueS = "1:3:5";
                }
              }
            }
            else {
              if (imgchange6 == true) {
                if (imgchange7 == true) {
                  swValueS = "1:3:6:7";
                }
                else {
                  swValueS = "1:3:6";
                }
              }
              else {
                if (imgchange7 == true) {
                  swValueS = "1:3:7";
                }
                else {
                  swValueS = "1:3";
                }
              }
            }
          }
        }
        else {
          if (imgchange4 == true) {
            if (imgchange5 == true) {
              if (imgchange6 == true) {
                if (imgchange7 == true) {
                  swValueS = "1:4:5:6:7";
                }
                else {
                  swValueS = "1:4:5:6";
                }
              }
              else {
                if (imgchange7 == true) {
                  swValueS = "1:4:5:7";
                }
                else {
                  swValueS = "1:4:5";
                }
              }
            }
            else {
              if (imgchange6 == true) {
                if (imgchange7 == true) {
                  swValueS = "1:4:6:7";
                }
                else {
                  swValueS = "1:4:6";
                }
              }
              else {
                if (imgchange7 == true) {
                  swValueS = "1:4:7";
                }
                else {
                  swValueS = "1:4";
                }
              }
            }
          }
          else {
            if (imgchange5 == true) {
              if (imgchange6 == true) {
                if (imgchange7 == true) {
                  swValueS = "1:5:6:7";
                }
                else {
                  swValueS = "1:5:6";
                }
              }
              else {
                if (imgchange7 == true) {
                  swValueS = "1:5:7";
                }
                else {
                  swValueS = "1:5";
                }
              }
            }
            else {

              if(imgchange6 == true) {
                if(imgchange7 == true){
                  swValueS="1:6:7";
                }else{
                  swValueS="1:6";
                }
              }
              else
                {
                  if (imgchange7 == true) {
                    swValueS = "1:7";
                  }
                  else {
                    swValueS = "1";
                  }
                }
              }
            }
          }
        }
      }
      else{

      if(imgchange2 == true){
        if(imgchange3 == true){
          if(imgchange4 == true){
            if(imgchange5 == true){
              if(imgchange6 == true){
                if(imgchange7 == true){
                  swValueS="2:3:4:5:6:7";
                }
                else{
                  swValueS="2:3:4:5:6";
                }
              }
              else{
                if(imgchange7 == true){
                  swValueS="2:3:4:5:7";
                }
                else{
                  swValueS="2:3:4:5";
                }
              }
            }
            else{
              if(imgchange6 == true){
                if(imgchange7 == true){
                  swValueS="2:3:4:6:7";
                }
                else{
                  swValueS="2:3:4:6";
                }
              }
              else{

                if(imgchange7 == true){
                  swValueS="2:3:4:7";
                }
                else{
                  swValueS="2:3:4";
                }
              }
            }
          }
          else{
            if(imgchange5 == true){
              if(imgchange6 == true){
                if(imgchange7 == true){
                  swValueS="2:3:5:6:7";
                }
                else{
                  swValueS="2:3:5:6";
                }
              }
              else{
                if(imgchange7 == true){
                  swValueS="2:3:5:7";
                }
                else{
                  swValueS="2:3:5";
                }
              }
            }
            else{
              if(imgchange6 == true){
                if(imgchange7 == true){
                  swValueS="2:3:6:7";
                }
                else{
                  swValueS="2:3:6";
                }
              }
              else{
                if(imgchange7 == true){
                  swValueS="2:3:7";
                }
                else {
                  swValueS="2:3";
                }
              }
            }
          }
        }

        else{

          if(imgchange4 == true){
            if(imgchange5 == true){
              if(imgchange6 == true){
                if(imgchange7 == true){
                  swValueS="2:4:5:6:7";
                }
                else{
                  swValueS="2:4:5:6";
                }
              }
              else{

                if(imgchange7 == true){
                  swValueS="2:4:5:7";
                }
                else{
                  swValueS="2:4:5";
                }
              }
            }
            else{
              if(imgchange6 == true){
                if(imgchange7 == true){
                  swValueS="2:4:6:7";
                }
                else{
                  swValueS="2:4:6";
                }
              }
              else{
                if(imgchange7 == true){
                  swValueS="2:4:7";
                }
                else{
                  swValueS="2:4";
                }
              }
            }
          }
          else{

            if(imgchange5 == true){
              if(imgchange6 == true){
                if(imgchange7 == true){
                  swValueS="2:5:6:7";
                }
                else{
                  swValueS="2:5:6";
                }
              }
              else{
                if(imgchange7 == true){
                  swValueS="2:5:7";
                }
                else{
                  swValueS="2:5";
                }
              }
            }
            else{
              if(imgchange6 == true){
                if(imgchange7 == true){
                  swValueS="2:6:7";
                }
                else{
                  swValueS="2:6";
                }
              }
              else{
                if(imgchange7 == true){
                  swValueS="2:7";
                }
                else{
                  swValueS="2";
                }
              }
            }
          }
        }
      }
      else{

            if(imgchange3 == true){
              if(imgchange4 == true){
                if(imgchange5 == true){
                  if(imgchange6 == true){
                    if(imgchange7 == true){
                      swValueS="3:4:5:6:7";
                    }
                    else{
                      swValueS="3:4:5:6";
                    }
                  }
                  else{
                    if(imgchange7 == true){
                      swValueS="3:4:5:7";
                    }
                    else{
                      swValueS="3:4:5";
                    }
                  }
                }
                else{
                  if(imgchange6 == true){
                    if(imgchange7 == true){
                      swValueS="3:4:6:7";
                    }
                    else{
                      swValueS="3:4:6";
                    }
                  }
                  else{

                    if(imgchange7 == true){
                      swValueS="3:4:7";
                    }
                    else{
                      swValueS="3:4";
                    }
                  }
                }
              }
              else{
                if(imgchange5 == true){
                  if(imgchange6 == true){
                    if(imgchange7 == true){
                      swValueS="3:5:6:7";
                    }
                    else{
                      swValueS="3:5:6";
                    }
                  }
                  else{
                    if(imgchange7 == true){
                      swValueS="3:5:7";
                    }
                    else{
                      swValueS="3:5";
                    }
                  }
                }
                else{
                  if(imgchange6 == true){
                    if(imgchange7 == true){
                      swValueS="3:6:7";
                    }
                    else{
                      swValueS="3:6";
                    }
                  }
                  else{
                    if(imgchange7 == true){
                      swValueS="3:7";
                    }
                    else{
                      swValueS="3";
                    }
                  }
                }
              }
            }
            else{
              if(imgchange4 == true){
                if(imgchange5 == true){
                  if(imgchange6 == true){
                    if(imgchange7 == true){
                      swValueS="4:5:6:7";
                    }
                    else{
                      swValueS="4:5:6";
                    }
                  }
                  else{
                    if(imgchange7 == true){
                      swValueS="4:5:7";
                    }
                    else{
                      swValueS="4:5";
                    }
                  }
                }
                else{

                  if(imgchange6 == true){
                    if(imgchange7 == true){
                      swValueS="4:6:7";
                    }
                    else{
                      swValueS="4:6";
                    }
                  }
                  else{

                    if(imgchange7 == true){
                      swValueS="4:7";
                    }
                    else{
                      swValueS="4";
                    }
                  }
                }
              }
              else{

                if(imgchange5 == true){
                  if(imgchange6 == true){
                    if(imgchange7 == true){
                      swValueS="5:6:7";
                    }
                    else{
                      swValueS="5:6";
                    }
                  }
                  else{
                    if(imgchange7 == true){
                      swValueS="5:7";
                    }
                    else{
                      swValueS="5";
                    }
                  }
                }
                else{
                  if(imgchange6 == true){
                    if(imgchange7 == true){
                      swValueS="6:7";
                    }
                    else{
                      swValueS="6";
                    }
                  }
                  else{
                    if(imgchange7 == true){
                      swValueS="7";
                    }
                    else{
                      swValueS="";
                    }
                  }
                }
              }
            }
      }
    }


    print("$swValueS");

    String svalues1_7=swValueS;
    String svalues8;

    print("values ins $svalues1_7,$svalues8");

    if(imgchange8 == true){
      svalues8="8";
    }
    else{

      svalues8="";
    }

    String combine;

    if(svalues1_7.length!=0){
      if(svalues8.length==0){
        combine = svalues1_7;
      }
      else{
        combine = svalues1_7+':'+svalues8;
      }
    }
    else{
      combine=svalues8;
    }


    if(fanv.contains("Yes")){


    }
    else if(fanv.contains("No")){

      print("fan contains no");
      if(combine.length !=0){
        combine=combine;
      }
      else{
        combine="0";
      }

    }

    if(combine.contains("0")){
      state="Off";
      onOffNum="0";
    }
    else{
      state="On";
      onOffNum="1";
    }


    print("value $combine \nState $state \nOnOffnum $onOffNum");


    int res = await mdb.update(MoodDBData(hnum: hnum,hname: hname,rnum: rnum,rname: rname, moodstno: number, moodstname: moodName, devicetype: "Null",devicemodel: ddevmodel,
        devicenum: dnum, onoffnum:onOffNum, devicedata: combine, aEdata: "Yes", bEdata:state,cEdata:cData,dEdata:dData,eEdata:eData,fEdata:fData,gEdata:gData,hEdata:hData,iEdata:iData,jEdata: jData));

    print("update $res");

  }

}