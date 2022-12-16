import 'dart:async';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home/Singleton.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:focus_detector/focus_detector.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Edituser extends StatefulWidget{

  Edituser({Key key,this.username}):super(key:key);
  final String username;
  @override
  _Edituser createState()=>_Edituser(username);
}
class _Edituser extends State<Edituser> {

  _Edituser(this.username);
  String username;

  GlobalService _globalService = GlobalService();
  String hnameuser,hnumuser;

  var rnumdetails = new Map();
  var rnamedetails = new Map();

  List listrooms = [];
  List devices = [];
  List devicenames = [];
  List roomselected=[] ;
  List deviceseleted=[];
  List sectionopened = [];
  List _droomselected = [];

  String uname,roomlist,devicelist;

  String setOfRooms="",setOfDevices="";

  var s=Singleton();

  double heights;

  int i = 0;

  Image img1=Image.asset('images/check_box.png');
  Image img2=Image.asset('images/check_box01.png');

  Image imgup = Image.asset('images/up.png');
  Image imgdown = Image.asset('images/down.png');

  Image imgselected;
  Image imgselectedd;

  Image dropdown;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );

    hnameuser=_globalService.hname;
    hnumuser=_globalService.hnum;

    asyncMethod();

    imgselected=img1;
    imgselectedd=img1;

    dropdown=imgup;

    FNC.DartNotificationCenter.unregisterChannel(channel: 'SuccessUserNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'SuccessUserNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'SuccessUserNotification', onNotification: (options) {
      print('USER: $options');
      adduserwithdevicesuccess();
    }, observer: null);

    FNC.DartNotificationCenter.unregisterChannel(channel: 'FailUserNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'FailUserNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'FailUserNotification', onNotification: (options) {
      print('USER: $options');
      failadduserwithdevicefailure();

    }, observer: null);

  }
  asyncMethod() async {
    print("enter async method");
    await getrooms();
    await addroomdevice();
    await getdevicesadded();
  }


  adduserwithdevicesuccess()async{

    int i = await DBProvider.db.updateuserdetailstouser(username,setOfRooms,setOfDevices);
    print(i);

    // Create button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {

       Navigator.pop(context);
       Navigator.pop(context);

      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("User Details Updated Successfully"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
    //showalert("User Details update Successfully");
  }

  failadduserwithdevicefailure() {

    // Create button

    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {

        Navigator.pop(context);
        Navigator.pop(context);

      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("failed to update user details"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
   // showalert("fialed to update user details");
  }

  getrooms() async {

    listrooms = await DBProvider.db.comlist();
    print("rooms is $listrooms");

    for(int i=0;i<listrooms.length;i++){
      sectionopened.add("1");
    }

  }

  Future<List>getroomsfuture() {

    return Future.delayed(Duration(seconds:0), () {
      return listrooms;
      // throw Exception("Custom Error");
    });

  }

  @override
  Widget build(BuildContext context) => FocusDetector(
    onFocusGained: () {

    },
    onFocusLost: () {

    },
    child: WillPopScope(onWillPop: () async {
          return _onBackPressed();
        },
        child: Scaffold(

          appBar: AppBar(
            backgroundColor: Color.fromRGBO(66, 130, 208, 1),
            title: Text('Edit User Settings'),
            actions: <Widget>[
            ],),
          backgroundColor: Colors.white10,
          body: Container(
              color: Colors.white,
              child:Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment:MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(child: Text("User: $username")),
                          Padding(padding: const EdgeInsets.all(10.0),),
                          Center(child: Text("Select Room Access")),
                          Padding(padding: const EdgeInsets.all(10.0),),
                          Container(

                           // color: Colors.w,
                              child:ConstrainedBox(
                                constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height*0.4),
                                child:Scrollbar(
                                  thumbVisibility:true,
                                  thickness: 5,
                                  child:deviceelementsd() ,
                                )

                              )
                          ),

                          Padding(padding: const EdgeInsets.all(10.0),),

                          Center(
                            child: MaterialButton(
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
                                  child: Text("SUBMIT"),
                                ),
                              ),
                              onPressed: () {

                                print('Tapped');
                                submitt();
                              },

                            ),
                          ),
                        ],
                  ),
                ),
            ),
          )
        ),),
    )
  );


  void submitt()async {
    setOfRooms = "";
    setOfDevices = "";
    String changeP = "";

    changeP = username;

    print(deviceseleted);
    print(username);

    if (deviceseleted.length == 0) {

      // Create button
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {

          //Navigator.canPop(context);
           Navigator.of(context,rootNavigator: true).pop();

        },
      );

      // Create AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Alert"),
        content: Text("Select one Device"),
        actions: [

          okButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return alert;
        },
      );

    }
    else {
      print("device present");
      changeP = changeP + ":";

      _droomselected = [];

      for (int i = 0; i < deviceseleted.length; i++) {
        String dvno = deviceseleted[i];
        List res = await DBProvider.db.getRnumSwitchBoardData(
            hnumuser, hnameuser, dvno);
        print(res);
        if (res.length == 0) {

        } else {
          String roomno = await res[0]['a'].toString();
          //String roomname = await res[i]['b'];
          _droomselected.add(roomno);
        }

        List res1 = await DBProvider.db.getRnumMasterTableData(
            hnumuser, hnameuser, dvno);
        print(res1);
        if (res1.length == 0) {

        }
        else {
          String roomno = await res1[0]['a'].toString();
          //String roomname = await res1[i]['b'];
          _droomselected.add(roomno);
        }
      }

      print(_droomselected);
      var roomIds = _droomselected.toSet().toList();
      print(roomIds);

      int roomc = roomIds.length;
      for (int i = 0; i < roomc; i++) {
        String val = roomIds[i];
        changeP = changeP + val;
        setOfRooms = setOfRooms + val;

        if (!(i == (roomc - 1))) {
          setOfRooms = setOfRooms + ";";
          changeP = changeP + ";";
        }
      }

      changeP = changeP + ":";
      int devicec = deviceseleted.length;
      for (int i = 0; i < devicec; i++) {
        String val = deviceseleted[i];

        if (val.length == 0) {
          print(val.length);
        }
        else {
          changeP = changeP + val;
          setOfDevices = setOfDevices + val;
        }

        if (!(i == (devicec - 1))) {
          if (val.length == 0) {

          }
          else {
            setOfDevices = setOfDevices + ";";
            changeP = changeP + ";";
          }
        }
      }

      String datatosend = "<" + changeP + "}";
      print(datatosend);

      if (s.socketconnected == true) {
         s.socket1(datatosend);
      }
      else{

        fluttertoast("Not Connected");


      }
    }
  }

  fluttertoast(String message){

    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
    );

  }


  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) =>
      new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to cancel'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          //SizedBox(height: 20),
          new GestureDetector(
            onTap: () async {
              Navigator.of(context).pop(true);
              int i = await DBProvider.db.updateuserdetailstouser(username,roomlist,devicelist);
              print(i);

            },
            child: Text("YES"),
          ),
        ],
      ),
    ) ??
        false;
  }

  Widget deviceelementsd() {
    return FutureBuilder<List>(
        future: getroomsfuture(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error:${snapshot.error}');
          }
          else if (snapshot.hasData) {
            print("Group list :${snapshot.hasData}");
            print('G List Data:${snapshot.data}');

            return GroupListView(
              sectionsCount: listrooms.length,
              shrinkWrap: false,
              scrollDirection: Axis.vertical,
              countOfItemInSection: (int section) {
                  if(sectionopened.elementAt(section)=="0"){
                    i=0;
                  }
                  else if(sectionopened.elementAt(section)=="1"){
                    int roomnumberint = listrooms[section]['a'];
                    List rnum=rnumdetails[roomnumberint];

                    if(rnum == null){
                      i=0;
                    }
                    else{
                      i=rnum.length;
                    }

                  }
                  else{
                    i=0;
                  }
                  return i;
                },
                groupHeaderBuilder: (BuildContext context, int section) {

                  String roomnumber = listrooms[section]['a'].toString();
                  if(roomselected.contains(roomnumber)){
                    imgselected=img2;
                  }
                  else{
                    imgselected=img1;
                  }

                  if(sectionopened.elementAt(section)=="0"){
                    dropdown=imgup;
                  }
                  else if(sectionopened.elementAt(section)=="1"){
                    dropdown=imgdown;
                  }
                  else{
                    dropdown=imgup;
                  }
                heights = 0;
                return Column(
                    children: [
                      Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child:Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          //color: Colors.white,
                              padding: EdgeInsets.all(0.0),
                            //  height: 2,
                              child:  Row(
                                children: [
                                  Column(
                                    children: [

                                      Padding(padding: const EdgeInsets.only(right: 20.0,top: 12.0),
                                          child:IconButton(
                                            splashRadius: 0.1,
                                            splashColor:Colors.transparent,
                                            iconSize: MediaQuery.of(context).size.width/50,
                                            icon: imgselected,
                                            onPressed: () {

                                              print("section is $section");
                                              String roomnumber = listrooms[section]['a'].toString();
                                              int roomnumberi = listrooms[section]['a'];


                                              if(roomselected.contains(roomnumber)){
                                                roomselected.remove(roomnumber);
                                                List rumdata = rnumdetails[roomnumberi];
                                                for(int i=0;i<rumdata.length;i++){
                                                  deviceseleted.remove(rumdata[i]);
                                                }
                                                imgselected=img1;
                                              }
                                              else{
                                                roomselected.add(roomnumber);
                                                imgselected=img2;
                                                List rumdata = rnumdetails[roomnumberi];
                                                for(int i=0;i<rumdata.length;i++){
                                                  deviceseleted.add(rumdata[i]);
                                                }
                                              }
                                              setState(() {
                                                  imgselected=imgselected;
                                              });

                                              },),
                                      )]
                                 ),
                                  Expanded(child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(listrooms[section]['b']+' - '+listrooms[section]['a'].toString(),style: TextStyle(fontSize: 13),),
                                    )
                                  ),

                                  Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: IconButton(
                                          splashRadius: 0.1,
                                          splashColor:Colors.transparent,
                                          iconSize: MediaQuery.of(context).size.width/50,
                                          icon: dropdown,
                                          onPressed: () {
                                            if(sectionopened[section] == "1"){
                                              sectionopened[section]="0";
                                            }
                                            else if(sectionopened[section] == '0'){
                                              sectionopened[section]="1";
                                           }
                                            setState(() {
                                              sectionopened=sectionopened;
                                            });
                                          }
                                        ),
                                     )
                                  ),
                                ]
                              ),
                        )
                      )
                    ]
                );
              },
              itemBuilder: _itemBuilder,
              separatorBuilder: (context, index) =>
                  SizedBox(height: 0),
                  // Divider(
                  //   color: Colors.black,
                  //   height: 2,
                  // ),
              sectionSeparatorBuilder: (context, section) => SizedBox(height:0),
            );
          }
          else if (snapshot.data == null || snapshot.data.length == 0) {
            print("NoDataFound");
            return Text('No Data Found');
          }
          return CircularProgressIndicator();
        }
    );
  }

  Widget _itemBuilder(BuildContext context, IndexPath index) {

    String rname = listrooms[index.section]['b'];
    List rnames = rnamedetails[rname];

    int rnumi = listrooms[index.section]['a'];
    List rnums = rnumdetails[rnumi];
    print(rnums);

    String rnumvalue=rnums[index.index];
    print("device $rnumvalue");
    print("selected is $deviceseleted");
    if(deviceseleted.contains(rnumvalue)){
      imgselectedd=img2;

    }
    else{
      imgselectedd=img1;
      
    }


    return ListTile(

        tileColor:Colors.blueAccent,
        dense:true,
        contentPadding: EdgeInsets.only(left: 2.0, right: 5.0),
        leading: Padding(padding: const EdgeInsets.fromLTRB(25, 5, 5, 5),
          child:IconButton(
            icon: imgselectedd,
            onPressed: () {

              String rnumvalue=rnums[index.index];
              print(rnumvalue);
              print(deviceseleted);
              if(deviceseleted.contains(rnumvalue)){
                deviceseleted.remove(rnumvalue);
              }
              else{
                deviceseleted.add(rnumvalue);
              }

              setState(() {
                deviceseleted=deviceseleted;
              });

            },
        )),
        title: Text(rnames[index.index]+" - "+rnums[index.index],
          style: TextStyle(
            //fontSize: 15
              color: Colors.blue
          ),
          textScaleFactor: 1.40,
        ),
        onTap:(){

        }
    );

  }

  void addroomdevice()async {
    await addrooms();
    await setstate();
  }

  addrooms()async {

    for (int i = 0; i < listrooms.length; i++) {

      devicenames = [];
      devices = [];

      int roomno = await listrooms[i]['a'];
      String roomname = await listrooms[i]['b'];

      int sccount = await DBProvider.db.GetSwitchCountWithRNAndHN(roomno, hnumuser, hnameuser);
      List switchboarddata = await DBProvider.db.getSwitchBoardDateFromRNumAndHNum(roomno.toString(), hnumuser, hnameuser);

      if (sccount != 0) {
        for (int cp = 0; cp < sccount; cp++) {
          String devicename = switchboarddata[cp]['ec'];
          String deviceno = switchboarddata[cp]['d'].toString();

          devicenames.add(devicename);
          devices.add(deviceno);

          rnamedetails[roomname] = devicenames;
          rnumdetails[roomno] = devices;
        }
      }

      List masdata = [];
      masdata = await DBProvider.db.DataFromMTRNumAndHNum(roomno, hnumuser, hnameuser);
      int masterc = masdata.length;
      if (masterc != 0) {
        for (int cp = 0; cp < masterc; cp++) {

          String devicename = masdata[cp]['ec'];
          String deviceno = masdata[cp]['d'].toString();

          devicenames.add(devicename);
          devices.add(deviceno);

          rnamedetails[roomname] = devicenames;
          rnumdetails[roomno] = devices;
        }
      }
    }
  }
  setstate(){
    setState(() {
      rnamedetails=rnamedetails;
      rnumdetails=rnumdetails;
    });
  }

  getdevicesadded() async{

    List res = await DBProvider.db.getUserDataWithUName(username);
    print(res);

    uname=res[0]['un'];
    roomlist=res[0]['rns'];
    devicelist=res[0]['ea'];
    List devicelisttable=[];

    if(devicelist.length == 0)
    {
      devicelisttable=[];
    }
    else{
      devicelisttable=devicelist.split(';');
    }

    deviceseleted=devicelisttable;
    print(deviceseleted);
    setState(() {
      deviceseleted=deviceseleted;
    });

  }


}

