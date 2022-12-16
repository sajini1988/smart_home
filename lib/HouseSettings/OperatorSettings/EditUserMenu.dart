import 'package:flutter/material.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/HouseSettings/OperatorSettings/EditUserSettings.dart';
import 'package:smart_home/HouseSettings/OperatorSettings/roleChange.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:fluttertoast/fluttertoast.dart';

List data = [];

void showDialogBoxEdituser(BuildContext context)async{

  String selectedusername;
  String selectedusertype;
  String loggedusertype;
  Future<List> userdata;
  int tappedIndex=-1;

  ScrollController _scrollController=ScrollController();

  DBHelper db;
  db=DBHelper();

  GlobalService _globalService = GlobalService();
  String hname = _globalService.hname;
  String hnum = _globalService.hnum;

  List res = await db.getStudents1(hname, hnum);
  print(res);

  loggedusertype = res[0]['lg'];

  data = [];

  if(loggedusertype == "A"){

    List data1 = await DBProvider.db.getServerDetailsDataWithADN("U", hname);
    print("1 $data1");
    List data2 = await DBProvider.db.getServerDetailsDataWithADN("G", hname);
    print("2 $data2");

    data=data1+data2;

  }
  else if (loggedusertype == "SA") {
    List data1 = await DBProvider.db.getServerDetailsDataWithADN("A", hname);
    print("1 $data1");
    List data2 = await DBProvider.db.getServerDetailsDataWithADN("U", hname);
    print("2 $data2");
    List data3 = await DBProvider.db.getServerDetailsDataWithADN("G", hname);
    print("3 $data3");

    data=data1+data2+data3;
  }

  userdata=getgridlist();

  showDialog(context:context,builder: (context){

    return StatefulBuilder(builder: (context,setState){

      return AlertDialog(
        //scrollable: true,
        title: Text("EDIT USER",style: TextStyle(color: Colors.black)),
        content: SingleChildScrollView(
          child:Container(
              width: double.maxFinite,
             // color: Colors.red,
              child:Column(
                mainAxisSize: MainAxisSize.min,

                children: [

                  Divider(),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child:Scrollbar(
                        interactive: true,
                       // showTrackOnHover: true,
                        thumbVisibility:true,
                        thickness: 5,
                        controller: _scrollController,
                        child: FutureBuilder<List>(
                            future: userdata,
                            builder: (context,snapshot){
                              if(snapshot.hasData){

                                return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.length,
                                    controller: _scrollController,
                                    itemBuilder: (context,index){

                                      String user = snapshot.data[index]['un'];
                                      print(user);

                                      String usertype = snapshot.data[index]['da'];
                                      print(usertype);

                                      //final key = Key1.fromUtf8('edisonbrosmartha');
                                     // final iv=IV.fromLength(16);
                                      // final iv = IV.from('AAAAAAAAAAAAAAAA');
                                     // final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

                                     // // List<int> bytes = utf8.encode(snapshot.data[index]['ps']);
                                     //  print(bytes);
                                     //
                                     //  String bs4str = base64.encode(bytes);
                                     //  print(bs4str);


                                      // Encrypted encrypted=Encrypted.fromBase64(bs4str);
                                      // Encrypted encrypted=;

                                      //   final decrypted = encrypter.decrypt(encrypted, iv: iv);

                                      //  print(decrypted);

                                      // Encrypted encrypted=snapshot.data[index]['ps'];

                                      // final decrypted = encrypter.decrypt(encrypter.Encrypted.fromBase64(encrypted),iv:iv);

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

                                                selectedusername = snapshot.data[index]['un'];
                                                selectedusertype = snapshot.data[index]['da'];
                                                setState((){
                                                  tappedIndex=index;
                                                });

                                                },
                                            ),
                                            //Divider(),
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
            onPressed: () {


              Navigator.pop(context);
              AlertDialog alert = AlertDialog(
                elevation: 0,
                //insetPadding: EdgeInsets.zero,
                // contentPadding: EdgeInsets.zero,
                //clipBehavior: Clip.antiAliasWithSaveLayer,
                contentPadding: EdgeInsets.zero,
                titlePadding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                title: Text(""),
                // content: TimerS010Page(),
                content: Container(
                  width: MediaQuery.of(context).size.width*0.75,
                  child:RoleChangePage(username: selectedusername,role: selectedusertype),
                ),
                actions: [],
              );
              showDialog(context: context, builder: (BuildContext context) {
                return alert;
              }
              );

            },
            child: Text('Change Role'),
          ),

          TextButton(
            onPressed: () => Navigator.of(context,rootNavigator: true).pop(),
            child: Text('Cancel'),
          ),

          TextButton(
              onPressed: () {

                print("selected usertype $selectedusertype");

                if(selectedusertype == "A"){
                  fluttertoast("Access Denied");
                }
                else if(selectedusertype.length==0){
                  fluttertoast("Select User");
                }
                else{
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Edituser(username: selectedusername)));
                }
                },
              child: Text('Edit'),
          ),

          ],
        );

      });
    });
  }
  Future<List> getgridlist() {
    return Future.delayed(Duration(seconds: 0), () {
      return data;
      // throw Exception("Custom Error");
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


