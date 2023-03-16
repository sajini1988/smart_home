//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/Moods/MoodDB.dart';
import 'package:smart_home/Moods/MoodDBModelClass.dart';
import 'package:smart_home/Moods/MoodList.dart';

class MoodS030Page extends StatefulWidget {
  MoodS030Page({Key key, this.number}) : super(key: key);
  final String number;
  @override
  _MoodS030PageState createState() => _MoodS030PageState(number1: number);
}
class _MoodS030PageState extends State<MoodS030Page> {

  _MoodS030PageState({this.number1});
  final String number1;

  String Username,Usertype;

  String hname,hnum,rnum,rname,dnum,GroupIdset,ddevmodel,modeltypeset,devicenameset="name",moodname;
  GlobalService _globalService = GlobalService();
  String number="0";

  String DeviceData,state,Onoffnum,Data_a,Data_b,Data_c,Data_d,Data_e,Data_f,Data_g,Data_h,Data_i,Data_j;

  String swValueS="";
  String fanv="No";

  Image bulbon=Image.asset('images/switchicons/bulb_on.png');
  Image bulboff=Image.asset('images/switchicons/bulb_off.png');

  Image imagehvon = Image.asset('images/switchicons/highvolt_on.png');
  Image imagehvoff = Image.asset('images/switchicons/highvolt_off.png');

  bool imgchange1=false;
  bool imgchange2=false;
  bool imgchange3=false;

  MDBHelper mdb;

  Image img1_On,img1_Off,img2_On,img2_Off,img3_On,img3_Off;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    mdb = MDBHelper();

    hname = _globalService.hname;
    hnum = _globalService.hnum;
    rname = _globalService.rname;
    GroupIdset = _globalService.groupId;
    ddevmodel = _globalService.ddevModel;
    modeltypeset = _globalService.modeltype;
    devicenameset = _globalService.devicename;
    number=_globalService.moodnum;

    print(number1);

    if(number1=="1"){
      dnum = _globalService.moodlistdnum;
      rnum = _globalService.moodlistrnum;
    }
    else if(number1 == "0"){
      dnum = _globalService.dnum;
      rnum = _globalService.rnum;
    }


    if(number.contains("1")){
      moodname = "Mood1";
    }
    else if(number.contains("2")){
      moodname = "Mood2";
    }
    else if(number.contains("3")){
      moodname = "Mood3";
    }


    img1_Off=bulboff;
    img1_On=bulbon;

    img2_Off=imagehvoff;
    img2_On=imagehvon;

    img3_Off=imagehvoff;
    img3_On=imagehvon;

    mood_dbfunction();

  }

  mood_dbfunction()async{
    DBHelper dbHelper = DBHelper();

    List result = await dbHelper.getLocalDateHName(hname);
    print("res $result");

    Username = result[0]['ld'];
    Usertype = result[0]['lg'];

    print("name $Usertype,$Username");

    int count = await mdb.getCountHNumandRNumWithSetNumDnum(hname,hnum, rnum, number, dnum, Username);
    print(count);

    if(count == 0){

      mdb.add(MoodDBData(hnum: hnum,hname: hname,rnum: rnum,rname: rname, moodstno: number, moodstname: moodname, devicetype: "Null",devicemodel: ddevmodel,
          devicenum: dnum, onoffnum:"0", devicedata: "0", aEdata: "No", bEdata:"Off",cEdata:devicenameset,dEdata:Username,eEdata:"Null",fEdata:"Null",gEdata:"Null",hEdata:"Null",iEdata: "Null",jEdata: "Null"));

    }

    List res = await mdb.getMooddata(hname,hnum, rnum, number, dnum, Username);
    print(res);

    hnum=res[0]['hn'];
    hname=res[0]['hna'];
    rnum=res[0]['rn'];
    rname=res[0]['rna'];
    number=res[0]['stno'];
    moodname=res[0]['stna'];
    ddevmodel=res[0]['dna'];
    dnum=res[0]['dno'];
    Onoffnum=res[0]['Onoff'];
    DeviceData=res[0]['dd'];
    Data_a=res[0]['ea'];
    Data_b=res[0]['eb'];
    Data_c=res[0]['ec'];
    Data_d=res[0]['ed'];
    Data_e=res[0]['ee'];
    Data_f=res[0]['ef'];
    Data_g=res[0]['eg'];
    Data_h=res[0]['eh'];
    Data_i=res[0]['ei'];
    Data_j=res[0]['ej'];

    List<String> results = DeviceData.split(':');
    print(results);

    for(int i=0;i<results.length;i++) {
      String s = results[i];
      print("ss $s");

      if (s.startsWith("1")) {
        print("enter1");
        imgchange1 = true;
      }

      if (s.startsWith("2")) {
        print("enter2");
        imgchange2 = true;
      }

      if (s.startsWith("3")) {
        print("enter3");
        imgchange3 = true;
      }
    }

    setState(() {
      imgchange1 = imgchange1;
      imgchange2 = imgchange2;
      imgchange3 = imgchange3;
      devicenameset = Data_c;
    });

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
      // debugShowCheckedModeBanner: false,
      // home: Scaffold(
      //   backgroundColor: Colors.transparent,
      //   body: Align(
      //     alignment: Alignment.center,
      //     child:Container(
      //       color: Colors.transparent,
      //       width: MediaQuery.of(context).size.width/1.4,
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
                              padding: const EdgeInsets.all(10.0),
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
                            Padding(
                              padding: const EdgeInsets.all(05.0),

                              child:Transform.scale(
                                scale: 2.5,
                                child: IconButton(
                                    iconSize: MediaQuery.of(context).size.width/10,
                                    icon: imgchange2?img2_On:img2_Off,
                                    splashRadius: 0.1,
                                    splashColor:Colors.transparent ,
                                    onPressed: () {

                                      print("pressed");
                                      if(imgchange2==true){
                                        imgchange2=false;
                                      }
                                      else if(imgchange2==false){
                                        imgchange2=true;
                                      }
                                      setState(() {
                                        imgchange2=imgchange2;
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
                                    icon: imgchange3?img3_On:img3_Off,
                                    splashRadius: 0.1,
                                    splashColor:Colors.transparent ,
                                    onPressed: () {

                                      print("pressed");
                                      if(imgchange3==true){
                                        imgchange3=false;
                                      }
                                      else if(imgchange3==false){
                                        imgchange3=true;
                                      }
                                      setState(() {
                                        imgchange3=imgchange3;
                                        print("$imgchange1");
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
                              //   color: Colors.blueAccent,
                              //
                              //   onPressed: () =>
                              //   {
                              //   },
                              // child: Text(
                              //       "Cancel", softWrap: false, maxLines: 1,),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ],
                )

              ],
            ),
          );
  }

  savefan()async{

    if(imgchange1 == true){
      if(imgchange2 == true){
        if(imgchange3 == true){
          swValueS="1:2:3";
        }
        else{
          swValueS="1:2";
        }
      }
      else{

        if(imgchange3==true){
          swValueS="1:3";
        }
        else{
          swValueS="1";
        }

      }
    }
    else{

      if(imgchange2 == true) {
        if (imgchange3 == true) {
          swValueS="2:3";
        }
        else{
          swValueS="2";
        }
      }
      else{

        if(imgchange3==true){
          swValueS="3";
        }
        else{
          swValueS="";
        }

      }

    }

    if(fanv.contains("Yes")){

    }
    else if(fanv.contains("No")){
      print("fan contains no");
      if(swValueS.length !=0){
        swValueS=swValueS;
      }
      else{
        swValueS="0";
      }
    }

    state="Off";
    if(swValueS.contains("0")){
      Onoffnum="0";
    }
    else{
      state="On";
      Onoffnum="1";
    }

    print("swvalue $swValueS \nState $state \nOnOffnum $Onoffnum");


    int res = await mdb.update(MoodDBData(hnum: hnum,hname: hname,rnum: rnum,rname: rname, moodstno: number, moodstname: moodname, devicetype: "Null",devicemodel: ddevmodel,
        devicenum: dnum, onoffnum:Onoffnum, devicedata: swValueS, aEdata: "Yes", bEdata:state,cEdata:Data_c,dEdata:Data_d,eEdata:Data_e,fEdata:Data_f,gEdata:Data_g,hEdata:Data_h,iEdata:Data_i,jEdata: Data_j));

    print("update $res");

  }

}
