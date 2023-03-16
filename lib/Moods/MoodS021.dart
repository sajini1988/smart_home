//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/Moods/MoodDB.dart';
import 'package:smart_home/Moods/MoodDBModelClass.dart';
import 'package:smart_home/Moods/MoodList.dart';


class MoodS021Page extends StatefulWidget {
  MoodS021Page({Key key, this.number}) : super(key: key);
  final String number;
  @override
  _MoodS021PageState createState() => _MoodS021PageState(number1: number);
}

class _MoodS021PageState extends State<MoodS021Page> {

  _MoodS021PageState({this.number1});
  final String number1;

  String username,usertype;

  GlobalService _globalService = GlobalService();
  String hname,hnum,rnum,rname,dnum,groupIdset,ddevmodel,modeltypeset,devicenameset="name",moodname;
  String number="0";

  String devicedata,state,onoffnum,aData,bData,cData,dData,eData,fData,gData,hData,iData,jData;

  String swValueS="";
  String fanv="No";

  bool imgchange1=false;
  bool imgchange2=false;

  Image bulbon=Image.asset('images/switchicons/bulb_on.png');
  Image bulboff=Image.asset('images/switchicons/bulb_off.png');

  Image imagehvon = Image.asset('images/switchicons/highvolt_on.png');
  Image imagehvoff = Image.asset('images/switchicons/highvolt_off.png');

  Image img1On,img1Off,img2On,img2Off;

  Image imagefanon  = Image.asset('images/switchicons/fan1.png');

  String dropdownvalue="0";

  MDBHelper mdb;

  @override
  void initState() {
    super.initState();

    mdb = MDBHelper();

    img1Off = bulboff;
    img1On = bulbon;

    img2Off = imagehvoff;
    img2On = imagehvon;

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

    rname = _globalService.rname;
    //dnum = _globalService.dnum;
    groupIdset = _globalService.groupId;
    ddevmodel = _globalService.ddevModel;
    modeltypeset = _globalService.modeltype;
    devicenameset = _globalService.devicename;
    number = _globalService.moodnum;

    if (number.contains("1")) {
      moodname = "Mood1";
    }
    else if (number.contains("2")) {
      moodname = "Mood2";
    }
    else if (number.contains("3")) {
      moodname = "Mood3";

    }

    mooddbfunction();
  }
  mooddbfunction()async{

    DBHelper dbHelper = DBHelper();

    List result = await dbHelper.getLocalDateHName(hname);
    print("res $result");

    username = result[0]['ld'];
    usertype = result[0]['lg'];

    print("name $usertype,$username");

    int count = await mdb.getCountHNumandRNumWithSetNumDnum(hname,hnum, rnum, number, dnum, username);
    print(count);


    if(count == 0){

      mdb.add(MoodDBData(hnum: hnum,hname: hname,rnum: rnum,rname: rname, moodstno: number, moodstname: moodname, devicetype: "Null",devicemodel: ddevmodel,
          devicenum: dnum, onoffnum:"0", devicedata: "0", aEdata: "No", bEdata:"Off",cEdata:devicenameset,dEdata:username,eEdata:"Null",fEdata:"Null",gEdata:"Null",hEdata:"Null",iEdata: "Null",jEdata: "Null"));

    }

    List res = await mdb.getMooddata(hname,hnum, rnum, number, dnum, username);
    print(hnum);
    print(res);

    hnum=res[0]['hn'];
    hname=res[0]['hna'];
    rnum=res[0]['rn'];
    rname=res[0]['rna'];
    number=res[0]['stno'];
    moodname=res[0]['stna'];
    ddevmodel=res[0]['dna'];
    dnum=res[0]['dno'];
    onoffnum=res[0]['Onoff'];
    devicedata=res[0]['dd'];
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

    List<String> results = devicedata.split(':');
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

      if(s.startsWith("fan")){
        print("enter fan");
        List<String> results = devicedata.split('-');
        if(results[0].contains("fan")){
          fanv="Yes";
          String fandata=results[1];
          dropdownvalue=fandata;
        }
      }

      setState(() {
        imgchange1=imgchange1;
        imgchange2=imgchange2;
        dropdownvalue=dropdownvalue;
        devicenameset=cData;
      });

    }
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
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
                          child: Center(
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
                                padding: const EdgeInsets.all(05.0),
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
                              Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width/25),),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child:Transform.scale(
                                  scale: 2.5,
                                  child: IconButton(
                                      iconSize: MediaQuery.of(context).size.width/10,
                                      icon: imgchange2?img2On:img2Off,
                                      splashRadius: 0.1,
                                      splashColor:Colors.transparent ,
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
                                  // color: Colors.greenAccent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(dropdownvalue),
                                      buildDropDown(),
                                    ],
                                  ),
                                ),
                                flex:6,
                              ),
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
                                  savefan();

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

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

    );

  }

  savefan()async{

    if(imgchange1 == true){
      if(imgchange2 == true){
        swValueS="1:2";
      }
      else{
        swValueS="1";
      }
    }
    else{

      if(imgchange2 == true){
        swValueS="2";
      }
      else{
        swValueS="";
      }

    }

    if(fanv.contains("Yes")){

      if(swValueS.length !=0){
        print("length not equal to zero");
        if(dropdownvalue==("0")){

          print("fan value is zero");
          swValueS=swValueS+":fan-$dropdownvalue";
        }
        else{
          print("fan value is not zero");
          swValueS=swValueS+":fan-$dropdownvalue";
        }

      }

      else{

        print("swlength value zero. check for fan");
        if(dropdownvalue==("0")){
          swValueS="0"+":fan-$dropdownvalue";
        }
        else{
          swValueS="0"+":fan-$dropdownvalue";
        }

      }

    }
    else if(fanv.contains("No")){

      if(swValueS.length!=0){
        swValueS=swValueS+":fan-$dropdownvalue";
      }
      else{
        swValueS="0"+":fan-$dropdownvalue";
      }

    }

    if(swValueS.contains("0"+":fan-0")){
      state="Off";
      onoffnum="0";
    }
    else{
      state="On";
      onoffnum="1";
    }


    print("swvalue $swValueS \nState $state \nOnOffnum $onoffnum");


    int res = await mdb.update(MoodDBData(hnum: hnum,hname: hname,rnum: rnum,rname: rname, moodstno: number, moodstname: moodname, devicetype: "Null",devicemodel: ddevmodel,
        devicenum: dnum, onoffnum:onoffnum, devicedata: swValueS, aEdata: "Yes", bEdata:state,cEdata:cData,dEdata:dData,eEdata:eData,fEdata:fData,gEdata:gData,hEdata:hData,iEdata:iData,jEdata: jData));

    print("update $res");



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
      onChanged: (String newValue) {
        setState(() {
          dropdownvalue = newValue;
        });
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

}

