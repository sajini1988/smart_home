//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/Moods/MoodDB.dart';
import 'package:smart_home/Moods/MoodS110.dart';
import 'package:smart_home/Moods/MoodS120.dart';
import 'package:smart_home/Moods/MoodS141.dart';
import 'package:smart_home/Moods/MoodS160.dart';
import 'package:smart_home/Singleton.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/HouseSettings/OperatorSettings/deleteRoomModelClass.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:smart_home/Moods/MoodS010.dart';
import 'package:smart_home/Moods/MoodS020.dart';
import 'package:smart_home/Moods/MoodS021.dart';
import 'package:smart_home/Moods/MoodS030.dart';
import 'package:smart_home/Moods/MoodS051.dart';
import 'package:smart_home/Moods/MoodS080.dart';
import 'package:smart_home/Moods/MoodCurtain.dart';
import 'package:smart_home/Moods/MoodPrjSosh.dart';
import 'package:smart_home/Moods/MoodOn.dart';
import 'package:smart_home/Moods/MoodRGB.dart';
import 'package:smart_home/Timer/RGBTimer.dart';

class MoodListPage extends StatefulWidget {

  MoodListPage({Key key, this.title}) :super(key: key);
  final String title;

  @override
  _MoodListPageState createState() => _MoodListPageState();
}

class _MoodListPageState extends State<MoodListPage>{

  var s=Singleton();
  GlobalService _globalService = GlobalService();
  String hname,hnum,rname,rnum,mooodname,moodnum,username;
  DBHelper dbHelper;
  String imgs = "disconnected";
  String imgn = "nonet";
  String options1="No_net";
  MDBHelper mdb;
  List res=[];
  Future<List>rooms;
  List<DeleteRoom>userdefinedrooms;
  List<DropdownMenuItem<int>> _menuItems;
  int _value=0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    hname=_globalService.hname;
    hnum=_globalService.hnum;
    rname=_globalService.rname;
    rnum=_globalService.rnum;
    moodnum=_globalService.moodnum;
    _globalService.moodlistrnumset=rnum;

    mdb = MDBHelper();

    details();
    getrooms();

    _value=int.parse(rnum);


  }


  details()async{

    DBHelper dbHelper;
    dbHelper = DBHelper();

    List result = await dbHelper.getLocalDateHName(hname);
    print(result);

    username=result[0]['ld'];
    print(username);

    res = await mdb.getMooddataRooms(hname,hnum,rnum,moodnum,"Yes",username);
    print(res);

    setState(() {
      res=res;
    });


  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async {
        return Navigator.canPop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(66, 130, 208, 1),
          title: Text('Mood List'),
          actions: <Widget>[
          ],
        ),
        backgroundColor: Colors.white10,
        body: Center(

          child:Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: Column(

              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
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
                          child: Text("DELETE ALL"),
                        ),
                      ),
                      // ),
                      onPressed: () {
                       deleteAll();
                        print('Tapped');
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.blue,
                        child: DropdownButton<int>(
                            hint: Text(rname),
                            items: _menuItems,
                            value: _value,
                            onChanged: (value){
                              print("value is $value");
                              _value=value;
                              rnum=value.toString();
                              _globalService.moodlistrnumset=rnum;
                              details();
                              //   setState(() {
                            //     _value= value ;
                            //     },
                            //   );
                             }
                        )
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: dataBody(),
                      ),
                    ]
                  ),
                )
              ],
            ),
          ),
        ),
        ),
    );
  }

  deleteAll()async{

    int i =await mdb.deleteallfromDatabase(int.parse(rnum),hnum,hname,moodnum);
    print("value is $i");
    details();

  }

  getrooms()async{

    rooms=DBProvider.db.comlist();
    functiongetlist().then((List value) {
      userdefinedrooms=[];
      if(value.length>0){
        userdefinedrooms.add(DeleteRoom(rnumber: 0, rname: "Select Room"));
        for (int i = 0; i < value.length; i++) {
          userdefinedrooms.add(DeleteRoom(rnumber: value[i]['a'], rname: value[i]['b']));
        }
      }
      for(int i=0;i<userdefinedrooms.length;i++){
        print(userdefinedrooms[i].rnumber);
        print(userdefinedrooms[i].rname);
      }


      _menuItems = List.generate(userdefinedrooms.length, (i) => DropdownMenuItem(
          value: userdefinedrooms[i].rnumber,
          child: Text("${userdefinedrooms[i].rname}-${userdefinedrooms[i].rnumber.toString()}"
          )
      )
      );
      setState(() {
        _menuItems=_menuItems;
      });
    });

  }

  Future<List> functiongetlist() async {
    rooms = rooms;
    return rooms;
  }

  // Widget _verticalDivider = const VerticalDivider(
  //   color: Colors.black,
  //   thickness: 1,
  // );

  SingleChildScrollView dataBody() {
    return SingleChildScrollView( // horizontal scroll widget
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView( // vertical scroll widget
            scrollDirection: Axis.vertical,
            child: DataTable(
              columnSpacing: 0,
                border: TableBorder.all(
                  width: 1.0,color:Colors.black,
                ),
                dividerThickness:1,
                columns: [
                  DataColumn(
                      label:Center(child: Text('No  '))
                  ),
                //  DataColumn(label: _verticalDivider),

                  DataColumn(
                    label: Center(child: Text('  DeviceName  ')),
                  ),
                //
                  //  DataColumn(label: _verticalDivider),

                  DataColumn(
                    label: Center(child: Text('  MType  ')),
                  ),


                  //DataColumn(label: _verticalDivider),

                  DataColumn(
                    label: Center(child: Text('  Devtype  ')),
                  ),
                  //DataColumn(label: _verticalDivider),

                  DataColumn(
                    label: Center(child: Text('  Status  ')),

                  ),
                 // DataColumn(label: _verticalDivider),

                  DataColumn(
                    label: Center(child: Text('  Data  ')),
                  ),
                  //DataColumn(label: _verticalDivider),

                  DataColumn(
                    label: Center(child: Text('  DELETE  ')),
                  ),
                 // DataColumn(label: _verticalDivider),

                  DataColumn(
                    label: Center(child: Text('  EDIT  ')),
                  ),

                  DataColumn(
                    label: Center(child: Text('  Devno  ')),
                  ),
                 // DataColumn(label: _verticalDivider),
                ],
               // rows:[]
                rows: List.generate(res.length, (index) {

                  Color color;
                  int slno = index+1;
                  String no = slno.toString();
                  String devicename = res[index]["ec"];
                  String name = res[index]["stna"];
                  String devno = res[index]["dno"];
                  String devtype = res[index]["dna"];
                  String status = res[index]["eb"];
                  String data = res[index]["dd"];
                  String fdata="";

                  print("data is $data");


                  String dds,dds1,dds2,dds3;
                  if(devtype == "RGB1"){
                    List<String> dd = data.split(';');
                    String dd0=dd[0];


                    List<String> dd1 = dd0.split(',');

                    if(dd1.length == 1){

                      dds=dd1[0];
                      dds1="0";
                      dds2="0";
                      dds3="0";

                    }
                    else{

                      dds=dd1[0];
                      dds1=dd1[1];
                      dds2=dd1[2];
                      dds3=dd1[3];
                    }



                    if(dds=="104"){
                      fdata = "Flash";
                      color=Colors.black;
                    }
                    else if(dds == "105"){
                      fdata = "Strobe";
                      color=Colors.black;
                    }
                    else if(dds == "106"){
                      fdata ="Smooth";
                      color=Colors.black;
                    }
                    else if (dds == "107"){
                      fdata ="Fade";
                      color=Colors.black;
                    }
                    else if(dds == "0"){
                      fdata = "Off";
                      color = Colors.black;
                    }
                    else{
                      fdata = "Color";
                      color=Colors.red;

                    }

                  }
                  else if(devtype == "CLNR"){
                    fdata="OPEN/CLOSE";
                  }
                  else if(devtype == "CLS1"){

                    if(data == "101,000"){
                      fdata="OPEN";
                    }
                    else if(data == "102,000"){
                      fdata="CLOSE";
                    }
                    else if(data == "101"){
                      fdata = "OPEN";
                    }
                    else if(data == "102"){

                      fdata = "CLOSE";

                    }
                  }
                  else if(devtype == "CRS1"){
                    print("dv $devtype");
                    if(data == "101,000"){
                        fdata="OPEN";
                    }
                    else if(data == "102,000"){
                        fdata="CLOSE";
                    }
                    else if(data == "101"){
                      fdata = "OPEN";
                    }
                    else if(data == "102"){

                      fdata = "CLOSE";

                    }

                  }
                  else{
                    fdata=data;
                  }

                  print("dds $dds");


                  return DataRow(cells: [
                    DataCell(Container(child: Center(child: Text(no)))),
                    DataCell(Container(child: Center(child: Text(devicename)))),
                    DataCell(Container(child: Center(child: Text(name)))),
                    DataCell(Container(child: Center(child: Text(devtype)))),
                    DataCell(Container(child: Center(child: Text(status)))),

                    DataCell(Container(child: Center(child: Text(fdata,style: TextStyle(color:color),)))),


                    DataCell(
                      IconButton(icon: Icon(Icons.delete),
                        onPressed: () {
                              showAlertDialog(context, devno);
                        },
                      ),
                    ),
                    DataCell(
                      IconButton(icon: Icon(Icons.edit),
                        onPressed: () {
                            edit(devtype,devno);
                        },
                      ),
                    ),
                    DataCell(Container(child: Center(child: Text(devno)))),
                  ]);
              }),
        )
    ));
  }
  edit(String ddevmodel, String devNumls){

    _globalService.moodlistdnumset=devNumls;

    if ((ddevmodel==("S010"))|| ddevmodel==("SLT1")) {

      AlertDialog alert = AlertDialog(

        elevation:0,
        contentPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        clipBehavior:Clip.antiAliasWithSaveLayer,
        insetPadding: EdgeInsets.all(50.0),
        shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),

        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/2.75,
          child:MoodS010Page(number: "1"),
        ),

        backgroundColor: Colors.white,
        actions: [],
      );
      showDialog(
        // barrierColor: Colors.white.withOpacity(0),
          barrierDismissible: false,
          context: context, builder: (BuildContext context) {

        return alert;
      }
      );

    }
    else if(ddevmodel==("S051")){
      AlertDialog alert = AlertDialog(

        elevation: 0,
        contentPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        clipBehavior:Clip.antiAliasWithSaveLayer,
        insetPadding: EdgeInsets.all(50.0),
        shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),

        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/1.75,
          child:S051Page(number: "1"),
        ),
        backgroundColor: Colors.white,
        actions: [],
      );
      showDialog(context: context, builder: (BuildContext context){
        return alert;
      }
      );


    }
    else if(ddevmodel==("S080")){
      AlertDialog alert = AlertDialog(

        elevation: 0,
        contentPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        clipBehavior:Clip.antiAliasWithSaveLayer,
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(50.0),
        shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),

        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/1.75,
          child:MoodS080Page(number: "1"),
        ),

        actions: [],
      );
      showDialog(context: context, builder: (BuildContext context){
        return alert;
      }
      );

    }
    else if(ddevmodel==("S020")){
      AlertDialog alert = AlertDialog(

        elevation: 0,
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior:Clip.antiAliasWithSaveLayer,
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(50.0),
        shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),

        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/3,
          child:MoodS020Page(number: "1"),
        ),
        actions: [],
      );
      showDialog(context: context, builder: (BuildContext context){
        return alert;
      }
      );

    }

    else if(ddevmodel==("S021")){
      AlertDialog alert = AlertDialog(

        elevation: 0,
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior:Clip.antiAliasWithSaveLayer,
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(50.0),
        shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),

        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/2.50,
          child:MoodS021Page(number: "1"),
        ),
        actions: [],
      );
      showDialog(context: context, builder: (BuildContext context){
        return alert;
      }
      );
    }

    else if(ddevmodel==("S030")){
      AlertDialog alert = AlertDialog(

        elevation: 0,
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior:Clip.antiAliasWithSaveLayer,
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(50.0),
        shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),

        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/2.75,
          child:MoodS030Page(number: "1"),
        ),
        actions: [],
      );
      showDialog(context: context, builder: (BuildContext context){
        return alert;
      }
      );


    }

    else if(ddevmodel==("S110")){
      AlertDialog alert = AlertDialog(

        elevation: 0,
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior:Clip.antiAliasWithSaveLayer,
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(50.0),
        shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),
        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/2.75,
          child:MoodS110Page(number: "1"),
        ),
        actions: [],
      );
      showDialog(context: context, builder: (BuildContext context){
        return alert;
      }
      );

    }

    else if(ddevmodel==("S120")){
      AlertDialog alert = AlertDialog(

        elevation: 0,
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior:Clip.antiAliasWithSaveLayer,
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(50.0),
        shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),

        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height*2.75,
          child:MoodS120Page(number: "1"),
        ),
        actions: [],
      );
      showDialog(context: context, builder: (BuildContext context){
        return alert;
      }
      );


    }

    else if(ddevmodel==("S141")){
      AlertDialog alert = AlertDialog(

        elevation: 0,
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior:Clip.antiAliasWithSaveLayer,
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(50.0),
        shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),

        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height*1.75,
          child:S141Page(number: "1"),
        ),
        actions: [],
      );
      showDialog(context: context, builder: (BuildContext context){
        return alert;
      }
      );

    }

    else if(ddevmodel==("S160")){
      AlertDialog alert = AlertDialog(

        elevation: 0,
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior:Clip.antiAliasWithSaveLayer,
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(50.0),
        shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),

        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height*1.75,
          child:MoodS160Page(number: "1"),
        ),
        actions: [],
      );
      showDialog(context: context, builder: (BuildContext context){
        return alert;
      }
      );

    }
    else if(ddevmodel==("CLS1")){

      AlertDialog alert = AlertDialog(

        elevation: 0,
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior:Clip.antiAliasWithSaveLayer,
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(50.0),
        shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),
        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/3,
          child:MoodCurtain(number: "1"),
        ),

        actions: [],
      );
      showDialog(context: context, builder: (BuildContext context){
        return alert;
      }
      );

    }
    else if(ddevmodel==("CRS1")){

      AlertDialog alert = AlertDialog(

        elevation: 0,
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior:Clip.antiAliasWithSaveLayer,
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(50.0),
        shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),
        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/3,
          child:MoodCurtain(number: "1"),
        ),
        actions: [],
      );
      showDialog(context: context, builder: (BuildContext context){
        return alert;
      }
      );
    }
    else if(ddevmodel==("CLNR")) {
      AlertDialog alert = AlertDialog(

        elevation: 0,
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior:Clip.antiAliasWithSaveLayer,
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(50.0),
        shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),
        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/1.75,
          child:MoodCurtain(number: "1"),
        ),

        actions: [],
      );
      showDialog(context: context, builder: (BuildContext context) {
        return alert;
      }
      );
    }

    else if(ddevmodel =="PSC1" || ddevmodel=="SOSH" || ddevmodel == "SWG1" || ddevmodel == "SLG1") {
      AlertDialog alert = AlertDialog(

        elevation: 0,
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior:Clip.antiAliasWithSaveLayer,
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(50.0),
        shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),
        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/3,
          child:MoodProjSom(number: "1"),
        ),
        actions: [],
      );
      showDialog(context: context, builder: (BuildContext context){
        return alert;
      }
      );
    }
    else if(ddevmodel =="RGB1"){

      AlertDialog alert = AlertDialog(

        elevation:0,
        contentPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        clipBehavior:Clip.antiAliasWithSaveLayer,
        insetPadding: EdgeInsets.all(50.0),
        shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),

        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/1.75,
          child:MoodRGBPage(number: "1"),
        ),
        backgroundColor: Colors.white,
        actions: [],
      );
      showDialog(
        // barrierColor: Colors.white.withOpacity(0),
          barrierDismissible: false,
          context: context, builder: (BuildContext context) {
        return alert;
      }
      );
    }
    else if(ddevmodel =="ACR1" || ddevmodel == "GSR1" || ddevmodel == "GSK1" || ddevmodel == "SDG1" || ddevmodel == "PLC1") {
      AlertDialog alert = AlertDialog(

        elevation:0,
        contentPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        clipBehavior:Clip.antiAliasWithSaveLayer,
        insetPadding: EdgeInsets.all(50.0),
        shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(25)),

        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/2.75,
          child:MoodOnPage(number: "1"),
        ),
        backgroundColor: Colors.white,
        actions: [],
      );
      showDialog(
        // barrierColor: Colors.white.withOpacity(0),
          barrierDismissible: false,
          context: context, builder: (BuildContext context) {

        return alert;
      }
      );

    }

  }
  showAlertDialog(BuildContext context,String devnum) {

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Mood"),
      content: Text("Do you really want to Delete the Mood Selected ??? "),
      actions: [

        TextButton(
          onPressed: () {
            Navigator.pop(context);
            },
            child: Text("NO"),
        ),
        TextButton(
          onPressed: () {
              deletedvnum(devnum);
              Navigator.pop(context);
          },
          child: Text("Yes"),
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  deletedvnum(String devno)async{

    int i = await mdb.deletefromDatabase(int.parse(rnum),hnum,hname,moodnum,devno);
    print(i);
    details();

  }


  fluttertoast(String message){

    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
    );

  }
}


