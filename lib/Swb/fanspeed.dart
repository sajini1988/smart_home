//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/Singleton.dart';

int itemCount1 = 0;
int itemCount2 = 0;
int itemCount3 = 0;
int itemCount4 = 0;
String rnumfan,hnumfan,dnumfan,groupIdfan,fandata;

class Fanspeed extends StatefulWidget{
  @override
  State<Fanspeed> createState() => FanspeedState();
}

class FanspeedState extends State<Fanspeed> {

  var s=Singleton();

  Image plusimg= Image.asset('images/switchicons/plus.png');
  Image minusimg= Image.asset('images/switchicons/minus.png');

  int _mincount1=1;
  int _maxcount1=6;

  int _mincount2=1;
  int _maxcount2=7;

  int _mincount3 = 1;
  int _maxcount3 = 8;

  int _mincount4 = 1;
  int _maxcount4 = 9;

  GlobalService _globalService = GlobalService();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FNC.DartNotificationCenter.unregisterChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'MasterNotification', onNotification: (options) {
      print('SWNotified: $options');
      SwResponce(options);

    }, observer: null);

    print("enter fan speed init settings");
    rnumfan =_globalService.rnum;
    hnumfan =_globalService.hnum;
    dnumfan =_globalService.dnum;
    groupIdfan=_globalService.groupId;

    SendDataDimmerBoard1(chr: "935", CastType: "01");

  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // MaterialApp(
      // debugShowCheckedModeBanner: false,
      // home: Scaffold(
      //   body: Stack(
      //     children: [
      //       Container(
      //         width: MediaQuery.of(context).size.width,
      //         height: MediaQuery.of(context).size.height*0.35,
      //         color: Colors.white,
      //         child: Center(
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Expanded(
      //                   flex:1,
        elevation: 0,

        clipBehavior:Clip.antiAliasWithSaveLayer,
        insetPadding: EdgeInsets.all(50.0),
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

          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex: 1,
                    child: Container()),
                Expanded(
                    flex: 2,
                    child: Text("1",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),)),
                Expanded(flex: 2,
                  child: IconButton(onPressed: (){

                    setState(() {
                      if(itemCount1 > _mincount1) {
                        itemCount1--;
                      }
                      else{
                        print("u reched mincount");
                      }
                    });


                  },
                      icon: minusimg),
                ),

                Expanded(flex: 2,
                    child:
                    Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Color.fromRGBO(66, 130, 208, 1),   width: 3),
                          borderRadius: BorderRadius.all(
                              Radius.circular(8.0) //                 <--- border radius here
                          ),
                        ),

                        child: Text(itemCount1.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,color: Color.fromRGBO(66, 130, 208, 1)),))),

                Expanded(flex: 2,
                  child: IconButton(onPressed:(){
                    setState(() {
                      if(itemCount1 < _maxcount1) {
                        itemCount1++;
                      }
                      else{
                        print("u reched maxcount");
                      }
                    });

                  },

                      icon: plusimg),
                ),
                Expanded(flex: 1,
                    child: Container()),
              ],

            ),

            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Expanded(flex: 1,
                      child: Container()),
                  Expanded(flex: 2,child: Text("2", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold))) ,
                  Expanded(flex: 2,
                    child: IconButton(onPressed:(){
                      setState(() {
                        if(itemCount2 > _mincount2) {
                          itemCount2--;
                        }
                        else{
                          print("u reched mincount");
                        }
                      });
                    },
                        icon: minusimg),
                  ),
                  Expanded(flex: 2,child:
                  Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color.fromRGBO(66, 130, 208, 1),   width: 3),
                        borderRadius: BorderRadius.all(
                            Radius.circular(8.0) //                 <--- border radius here
                        ),
                      ),child: Text(itemCount2.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,color: Color.fromRGBO(66, 130, 208, 1))))),

                  Expanded(flex: 2,
                    child: IconButton(onPressed:(){
                      setState(() {
                        if(itemCount2 < _maxcount2) {
                          itemCount2++;
                        }
                        else{
                          print("u reched maxcount");
                        }
                      });

                    },

                        icon: plusimg),
                  ),
                  Expanded(flex: 1,
                      child: Container()),

                ]
            ),

            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Expanded(flex: 1,
                      child: Container()),

                  Expanded(flex: 2,child: Text("3", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold))) ,
                  Expanded(flex: 2,
                    child: IconButton(onPressed:(){
                      setState(() {
                        if(itemCount3 > _mincount3) {
                          itemCount3--;
                        }
                        else{
                          print("u reched mincount");
                        }
                      });

                    },
                        icon: minusimg),
                  ),
                  Expanded(flex: 2,
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Color.fromRGBO(66, 130, 208, 1),   width: 3),
                          borderRadius: BorderRadius.all(
                              Radius.circular(8.0) //                 <--- border radius here
                          ),
                        ),child: Text(itemCount3.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,color: Color.fromRGBO(66, 130, 208, 1)))),
                  ),

                  Expanded(flex: 2,
                    child: IconButton(onPressed:(){
                      setState(() {
                        if(itemCount3 < _maxcount3) {
                          itemCount3++;
                        }
                        else{
                          print("u reched maxcount");
                        }
                      });

                    },
                        icon: plusimg),
                  ),

                  Expanded(flex: 1,
                      child: Container()),

                ]

            ),

            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Expanded(flex: 1,
                      child: Container()),
                  Expanded(flex: 2,child: Text("4", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold))) ,
                  Expanded(flex: 2,
                    child: IconButton(onPressed:(){
                      setState(() {
                        if(itemCount4 > _mincount4) {
                          itemCount4--;
                        }
                        else{
                          print("u reched mincount");
                        }
                      });

                    },
                        icon: minusimg),
                  ),
                  Expanded(flex: 2,
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Color.fromRGBO(66, 130, 208, 1),   width: 3),
                          borderRadius: BorderRadius.all(
                              Radius.circular(8.0) //                 <--- border radius here
                          ),
                        ),child: Text(itemCount4.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,color: Color.fromRGBO(66, 130, 208, 1)))),
                  ),

                  // Text(itemCount4.toString()),

                  Expanded(flex: 2,
                    child: IconButton(onPressed:(){
                      setState(() {
                        if(itemCount4 < _maxcount4) {
                          itemCount4++;
                        }
                        else{
                          print("u reched maxcount");
                        }
                      });
                    },
                        icon: plusimg),
                  ),
                  Expanded(flex: 1,
                      child: Container()),
                ]
            ),

            Container(
              height: 2,
              color: Colors.grey,
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
                            //savefan();
                            Calculate();

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
        ));
    //               ],
    //             ),
    //           ),
    //
    //         )
    //       ],
    //     ),
    //   ),
    // );
    //);


  }



  SwResponce(String notification) {
    print("Sw $notification");
    print("lenght $notification.length");

    String sdev = dnumfan.padLeft(4, '0');
    String rdev = notification.substring(4, 8);

    print("responce $sdev,$rdev");

    print(notification[4]);
    print(notification[5]);
    print(notification[6]);
    print(notification[7]);
    print(notification[8]);
    print(notification[9]);
    print(notification[10]);

    if (sdev.contains(rdev)) {

      String strversion = notification.substring(20,21);
      if(strversion.contains("B")){
        itemCount1=int.parse(notification[21]);
        itemCount2=int.parse(notification[22]);
        itemCount3=int.parse(notification[23]);
        itemCount4=int.parse(notification[24]);

      }
      setState(() {
        itemCount1=itemCount1;
        itemCount2=itemCount2;
        itemCount3=itemCount3;
        itemCount4=itemCount4;
      });

    }
  }

  Calculate(){


    print("$itemCount1,$itemCount2,$itemCount3,$itemCount4");
    if(itemCount1==0 && itemCount2==0 && itemCount3 == 0 && itemCount4 == 0){
        flutter_toast("Set Values");
    }
    else if((itemCount1<itemCount2) && (itemCount2<itemCount3) && (itemCount3<itemCount4)){
      SendDataDimmerBoard(chr: "997", CastType: "01");

    }
    else{
      flutter_toast("Set Values in incremental Order");

    }

  }

  void SendDataDimmerBoard({String chr, String CastType}) {

    fandata="$itemCount1"+"$itemCount2"+"$itemCount3"+"$itemCount4";
    print("$groupIdfan,$dnumfan,$rnumfan,$fandata");
    String cast=CastType;
    String gI=groupIdfan;
    String d=dnumfan.padLeft(4,'0');
    String rnum=rnumfan.padLeft(2,'0');
    String data=chr;
    String fandata1=fandata;
    String cE="00000000000";

    String a="0";
    String sData = '*' + a + cast + gI + d + rnum + data + fandata1 + cE + '#';

    if(s.socketconnected == true){
      s.socket1(sData);
      print("Data sent");
    }


  }

  void SendDataDimmerBoard1({String chr, String CastType}) {

    String cast=CastType;
    String gI=groupIdfan;
    String d=dnumfan.padLeft(4,'0');
    String rnum=rnumfan.padLeft(2,'0');
    String data=chr;
    String cE="000000000000000";
    String a="0";
    String sData = '*' + a + cast + gI + d + rnum + data + cE + '#';

    if(s.socketconnected == true){
      s.socket1(sData);
      print("Data sent");
    }


  }

  flutter_toast(String message){
    
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