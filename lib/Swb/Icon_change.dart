//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/GlobalService.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;


class IconchangePage extends StatefulWidget{
  @override
  _IconChangePageState createState() => _IconChangePageState();
}

class _IconChangePageState extends State<IconchangePage>{


  GlobalService _globalService = GlobalService();
  String hname,hnum,rnum,rname,dnum,devicemodel,devicemodelnum,devicename,deviceID,bulbnumber;
  List<String> images=["ac_off","aqua_off","bulb_off","cfl_off","cur_off","dimmer_off","dlock_off","eb_off","gey_off","lamp_off","nameboard_off","rgb_off","socket_off","speaker_off","tb_off","tv_off"];
  List<String> names = ["ac","auqa","bulb","cfl","curtain","dimmr","door","ebulb","geyser","bedlamp","disp","rgb","socket","speaker","tubelight","tv"];
  List<String> imageshv;
  String name;
  var details = new Map();

  @override
  void initState()
  {
    super.initState();

    hname=_globalService.hname;
    hnum=_globalService.hnum;
    rnum=_globalService.rnum;
    rname=_globalService.rname;
    dnum=_globalService.dnum;
    devicemodel=_globalService.ddevModel;
    devicemodelnum=_globalService.ddevModelNum;
    devicename=_globalService.devicename;
    deviceID=_globalService.deviceID;
    bulbnumber=_globalService.bulb;

    setState(() {
      bulbnumber=bulbnumber;
    });
    swdetails();
  }
  swdetails() async{

    List res1 = await DBProvider.db.getSwitchBoardDateFromRNumAndHNumWithDN(rnum, hnum, dnum, hname);
    print(res1);

    String Bicon1=res1[0]['bi1'];
    String Bicon2=res1[0]['bi2'];
    String Bicon3=res1[0]['bi3'];
    String Bicon4=res1[0]['bi4'];
    String Bicon5=res1[0]['bi5'];
    String Bicon6=res1[0]['bi6'];
    String Bicon7=res1[0]['bi7'];
    String Bicon8=res1[0]['bi8'];

    details['bi1'] = Bicon1;
    details['bi2'] = Bicon2;
    details['bi3'] = Bicon3;
    details['bi4'] = Bicon4;
    details['bi5'] = Bicon5;
    details['bi6'] = Bicon6;
    details['bi7'] = Bicon7;
    details['bi8'] = Bicon8;

    print(details);
    print(details['bi1']);
    print(details['bi2']);
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
          child: Container(
            color: Colors.transparent,
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
                      flex: 10,
                      child: Container(
                        color: Colors.white,
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text('Change Icon',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal
                            ),
                              maxLines: 2,
                            ),
                          ),
                        ),
                      ),
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
                            fit: BoxFit.fitHeight,
                            child: Text(bulbnumber,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ),
                      ),
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
                        child: GridView.builder(
                          itemCount: images.length,
                          itemBuilder: (BuildContext context, int index) {
                            String img = images[index];

                            return Container(
                              alignment: Alignment.topLeft,
                              child:GestureDetector(
                                onTap: (){
                                   name=names[index];
                                   changeimageindb();
                                  // flutter_toast("$name $index");
                                  },
                                  child: new Image.asset(
                                  'images/switchicons/$img.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            );

                            //return Image.asset('images/switchicons/$img.png', fit: BoxFit.fill);
                          },
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 2,
                             // mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                          ),
                         // padding: EdgeInsets.all(10),
                          shrinkWrap: true,
                        )
                      ),

                    ),

                  ],

                )

              ],
            ),

          ),
        ),
      ),
    );
  }

  changeimageindb()async{

    if(bulbnumber == "b1t"){
      details['bi1']=name;
    }
    else if(bulbnumber == "b2t"){
      details['bi2']=name;
    }
    else if(bulbnumber == "b3t"){
      details['bi3']=name;
    }
    else if(bulbnumber == "b4t"){
      details['bi4']=name;
    }
    else if(bulbnumber == "b5t"){
      details['bi5']=name;
    }
    else if(bulbnumber == "b6t"){
      details['bi6']=name;
    }
    else if(bulbnumber == "b7t"){
      details['bi7']=name;
    }
    else if(bulbnumber == "b8t"){
      details['bi8']=name;
    }

    print(details);
    int i = await DBProvider.db.updateSWTableIcon(hname,hnum,rnum,dnum,details);
    print("$i");
    reload();
    Navigator.of(context).pop();

  }

  reload(){

    if(devicemodel=="S051"){

      FNC.DartNotificationCenter.post(
          channel: 'changeicon_switch51', options: "done");

    }
    else if(devicemodel == "S021"){

      FNC.DartNotificationCenter.post(
          channel: 'changeicon_switch21', options: "done");

    }
    else if(devicemodel == "S010"){

      FNC.DartNotificationCenter.post(
          channel: 'changeicon_switch10', options: "done");

    }
    else if(devicemodel == "S030"){

      FNC.DartNotificationCenter.post(
          channel: 'changeicon_switch30', options: "done");

    }
    else if(devicemodel == "S020"){

      FNC.DartNotificationCenter.post(
          channel: 'changeicon_switch20', options: "done");

    }
    else if(devicemodel == "S030"){

      FNC.DartNotificationCenter.post(
          channel: 'changeicon_switch30', options: "done");

    }
    else if(devicemodel == "S080"){

      FNC.DartNotificationCenter.post(
          channel: 'changeicon_switch80', options: "done");

    }
    else if(devicemodel == "SLT1"){

      FNC.DartNotificationCenter.post(
          channel: 'changeicon_switch10', options: "done");
    }


  }

}
