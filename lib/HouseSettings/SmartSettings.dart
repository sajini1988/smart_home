import 'package:flutter/material.dart';
import 'package:smart_home/Singleton.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:focus_detector/focus_detector.dart';

class SmartSettings extends StatefulWidget{
  SmartSettings({Key key, todo,}): super(key:key);

  @override
  _SmartSettings createState() => _SmartSettings();
}

class _SmartSettings extends State<SmartSettings>{

  var s=Singleton();
  GlobalService _globalService = GlobalService();
  String hname,hnum,rnum,rname,dnum;
  String imgs = "disconnected";
  String imgn= "nonet";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    hname = _globalService.hname;
    hnum = _globalService.hnum;
    rnum = _globalService.rnum;
    rname = _globalService.rname;
    dnum = _globalService.dnum;

    socketsend();
  }


  socketsend(){

    if(s.socketconnected == true) {
        imgs="connected";
    }
    else{
      imgs="disconnected";
      s.checkindevice(hname, hnum);
    }

    if (s.networkconnected.contains("Mobile")) {
      print("Mobile");
      imgn = "3g";

    }
    else if (s.networkconnected.contains("LWi-Fi")) {
      imgn = 'local_sig';

    }
    else if (s.networkconnected.contains("RWi-Fi")) {
      imgn = 'remote01';

    }
    else if (s.networkconnected.contains("No_Net")) {
      imgn = 'nonet';

    }

    setState(() {
      imgs=imgs;
      imgn=imgn;
    });



  }

  @override
  Widget build(BuildContext context)=>FocusDetector(

      onFocusLost: () {
        print("focus slost");
      },
      onFocusGained: () {
        print("focus sgained");
      },
      // onVisibilityLost: () {
      //   print("visibiliy slost");
      // },
      // onVisibilityGained: () {
      //   print("visibiliy sgained");
      // },
      onForegroundLost: () {
        print("foreground slost");
      },
      onForegroundGained: () {
        print("foregrround sgained");
      },

      child: WillPopScope(onWillPop: () async {
      // return Navigator.of(context).push(
      //   MaterialPageRoute(builder: (context) => MyApp(name:hname,lb:hnum)),
      // );
        return Navigator.canPop(context);
        },child:Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(66, 130, 208, 1),
            title: Text("Smart Settings"),
            actions: <Widget>[
              IconButton(
                icon: Image.asset('images/$imgs.png',
                    fit: BoxFit.cover),
                onPressed: () {
                  s.checkindevice(hname, hnum);
                },
              ),
              IconButton(
                icon: Image.asset('images/$imgn.png',
                    fit: BoxFit.cover),
                onPressed: () {},
            ),

        ],),
        backgroundColor: Colors.white,
          body: Center(
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width/20),),
                Padding(padding: EdgeInsets.only(left: 20,right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:<Widget> [
                    Expanded(
                        flex: 6,
                        child: Container(
                          color: Colors.white,
                          child:Text(
                          "All Switches",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                         textScaleFactor: 1.50,
                         // style: TextStyle(fontSize: 18.0),
                          maxLines: 2,),
                        )
                    ),
                      Expanded(
                        child: IconButton(
                          icon: Image.asset('images/PIR/on.png'), onPressed: () {
                            sendcasttype("03");
                        },
                        ),
                        flex: 2,
                      ),

                      Expanded(
                        child: IconButton(
                          icon: Image.asset('images/PIR/off.png'), onPressed: () {
                            sendcasttype("04");
                        },
                        ),
                        flex: 2,
                      )
                    ],
                )),

                Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width/30),),

                Padding(padding: EdgeInsets.only(left:20,right: 20),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:<Widget> [
                    Expanded(
                        flex: 6,
                        child: Container(
                          color: Colors.white,
                          child:Text(
                            "All Switches and FAN",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            textScaleFactor: 1.50,
                            // style: TextStyle(fontSize: 18.0),
                            maxLines: 2,),
                        )
                    ),
                    Expanded(


                      child: IconButton(
                        icon: Image.asset('images/PIR/on.png'), onPressed: () {
                          sendcasttype("02");
                      },
                      ),
                      flex: 2,
                    ),

                    Expanded(
                      child: IconButton(
                        icon: Image.asset('images/PIR/off.png'), onPressed: () {
                          sendcasttype("05");
                      },
                      ),
                      flex: 2,
                    )
                  ],
                  ) )
              ]
            )


        )
        ),
    )));



  sendcasttype(String cast){

    String a="0";
    String ce="000000000000000000000000000";
    String sData = '*' + a + cast + ce + '#';
    print("Sending String is : $sData"); // input is : *001000000102920000000000000000# output is : 003300010100FFFFFFFFA120F001B3

    if(s.socketconnected == true){
      s.socket1(sData);
    }
    else{

    }

  }
  
}
