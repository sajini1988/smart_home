import 'package:flutter/material.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:smart_home/Singleton.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:fluttertoast/fluttertoast.dart';

List data = [];
void showDialogBoxDeleteuser(BuildContext context) async {

  String loggedUsertype;
  String password;
  String userSelected;
  String usertypeSelected;

  FNC.DartNotificationCenter.unregisterChannel(channel: 'DeleteUserNotification');
  FNC.DartNotificationCenter.registerChannel(channel: 'DeleteUserNotification');
  FNC.DartNotificationCenter.subscribe(channel: 'DeleteUserNotification', onNotification: (options) async {
    print('deleteuser: $options');
    int i = await DBProvider.db.deleteServerDetailsUser(userSelected);
    int i1 = await DBProvider.db.deleteuserTable(usertypeSelected);
    print("deleted $i $i1");

    showDialogBoxDeleteuser(context);


    Fluttertoast.showToast(
        msg: "Deleted $userSelected",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
    );



  },observer: null);

  FNC.DartNotificationCenter.unregisterChannel(channel: 'FailDeleteNotification');
  FNC.DartNotificationCenter.registerChannel(channel: 'FailDeleteNotification');
  FNC.DartNotificationCenter.subscribe(channel: 'FailDeleteNotification', onNotification: (options) {
    print('deleteFailed: $options');
    print("failed");

    Fluttertoast.showToast(
        msg: "Delete failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
    );

  },observer: null);


  Future<List> userdata;

  var s = Singleton();
  int tappedIndex=-1;

  DBHelper db;
  db = DBHelper();
  GlobalService _globalService = GlobalService();
  String hname = _globalService.hname;
  String hnum = _globalService.hnum;

  List res = await db.getStudents1(hname, hnum);
  print(res);

  loggedUsertype = res[0]['lg'];
  password = res[0]['le'];

  print("logged usertype is $loggedUsertype,$password");

  data = [];

  if (loggedUsertype == "A") {

    List data1 = await DBProvider.db.getServerDetailsDataWithADN("U", hname);
    List data2 = await DBProvider.db.getServerDetailsDataWithADN("G", hname);
    data=data1+data2;
  }
  else if (loggedUsertype == "SA") {
    List data1 = await DBProvider.db.getServerDetailsDataWithADN("A", hname);
    List data2 = await DBProvider.db.getServerDetailsDataWithADN("U", hname);
    List data3 = await DBProvider.db.getServerDetailsDataWithADN("G", hname);

    data=data1+data2+data3;
  }

  userdata=getgridlist();

  showDialog(context: context, builder: (context) {

    return StatefulBuilder(builder: (context,setState){

      return AlertDialog(
       // scrollable: true,
        title: Text("DELETE USER",style: TextStyle(color: Colors.black)),

        content: SingleChildScrollView(
          child:SizedBox(
            width: double.maxFinite,
            child:Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Divider(),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child:Scrollbar(
                    thumbVisibility:true,
                    thickness: 5,
                    child: FutureBuilder<List>(
                      future: userdata,
                      builder: (context,snapshot){
                      if(snapshot.hasData){

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context,index){

                          String user = snapshot.data[index]['un'];
                          String usertype = snapshot.data[index]['da'];


                          return Column(
                          children:<Widget>[
                            ListTile(
                              tileColor:tappedIndex == index ? Colors.black12 : Colors.white,
                              dense:true,
                              contentPadding: EdgeInsets.only(left: 2.0, right: 5.0),
                              title: Text(
                              user,
                              style: TextStyle(
                                //fontSize: 15
                                  color: Colors.black
                              ),
                              textScaleFactor: 1.40,

                              ),
                              trailing:CircleAvatar(
                                backgroundImage:  AssetImage('images/UGA.png'),
                                maxRadius: 15,

                                child: Text(usertype)),

                              onTap: (){
                                setState((){
                                  tappedIndex=index;
                                  print("index $tappedIndex");

                                  userSelected = snapshot.data[tappedIndex]['un'];
                                  print("user $user");

                                  usertypeSelected = snapshot.data[tappedIndex]['da'];
                                  print("user type $usertypeSelected");

                                });
                              },
                            ),
                          ]
                          );
                          });
                      }
                      if (snapshot.data == null || snapshot.data.length == 0) {
                        print("NoDataFound");
                        return Text('No Data Found');
                      }
                        return CircularProgressIndicator();
                      }
                    )

                  ),
                )
              ],
            )
          ),
        ),

        actions: [

          TextButton(
            onPressed: () => Navigator.of(context,rootNavigator: true).pop(),
            child: Text('CANCEL'),
          ),

          TextButton(
            onPressed: () {

                String data;
                if(usertypeSelected == null){
                  print("select User");
                }
                else if(usertypeSelected.length == 0){
                  print("select user");
                }
                else{
                  data = "<"+password+userSelected+"?";
                  print(data);
                  if(s.socketconnected == true){
                    s.socket1(data);
                    Navigator.of(context).pop();

                  }
                  else{
                    print("Socket not conneected");
                  }
                }
              },
            child: Text('DELETE'),
          ),

        ],
      );

    });

  });


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


Future<List> getgridlist() {
  return Future.delayed(Duration(seconds: 0), () {
    return data;
    // throw Exception("Custom Error");
  });
}
