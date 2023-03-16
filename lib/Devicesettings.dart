import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:dart_notification_center/dart_notification_center.dart' as FNC;
import 'GlobalService.dart';
import 'package:smart_home/Singleton.dart';
import 'package:smart_home/Swb/fanspeed.dart';

class DeviceSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new MyApp(),
    );
  }
}
class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final FanspeedState ani= new FanspeedState();
  var s=Singleton();
  String hname,hnum,rnum,rname,dnum,groupIdset,ddevmodel,modeltypeset,devicenameset="name";
  GlobalService _globalService = GlobalService();

  List deviceListViewData;

  String versionNo="1.30";
  String oldVersion= "1.30";

  bool val1=false;
  bool val2=false;
  bool val3=false;
  bool val4=false;
  bool val5=false;
  bool val6=false;
  bool val7=false;
  bool val8=false;//LED
  bool val9=false;//INVERSE

  Image irBtnImg = Image.asset('images/switchicons/ir_reset.png');
  Image fanBtnImg = Image.asset('images/switchicons/fan_speed.png');
  Image setBtnImg = Image.asset('images/switchicons/set.png');

  String dropdownValue="1";
  bool fanBtnImgV=false;

  onChangedFunction1(bool newValue1){
    setState(() {
      val1 = newValue1;
      String status = val1? "true":"false";
      if(status == "true"){
        sendDataDimmerBoard(chr: "911", castType: "01");
      }
      else if(status == "false")
      {
        sendDataDimmerBoard(chr: "912", castType: "01");
      }
    }
    );

  }

  onChangedFunction2(bool newValue2){
    setState(() {
      val2 = newValue2;
      String status = val2? "true":"false";
      if(status == "true"){
        sendDataDimmerBoard(chr: "915", castType: "01");
      }
      else if(status == "false")
      {
        sendDataDimmerBoard(chr: "916", castType: "01");
      }
    }
    );

  }
  onChangedFunction3(bool newValue3){
    setState(() {
      val3 = newValue3;
      String status = val3? "true":"false";
      if(status == "true") {
        sendDataDimmerBoard(chr: "913", castType: "01");
      }
      else if(status == "false")
      {
        sendDataDimmerBoard(chr: "914", castType: "01");
      }
    });

  }

  onChangedFunction4(bool newValue4){
    setState(() {
      val4 = newValue4;
      String status = val4? "true":"false";
      if(status == "true"){
        sendDataDimmerBoard(chr: "907", castType: "01");
      }
      else if(status == "false")
      {
        sendDataDimmerBoard(chr: "908", castType: "01");
      }
    });

  }

  onChangedFunction5(bool newValue5){
    setState(() {
      val5 = newValue5;
      String status = val5? "true":"false";
      if(status == "true"){
        sendDataDimmerBoard(chr: "909", castType: "01");
      }
      else if(status == "false")
      {
        sendDataDimmerBoard(chr: "910", castType: "01");
      }
    });

  }

  onChangedFunction6(bool newValue6){
    setState(() {
      val6 = newValue6;
      String status = val6? "true":"false";
      if(status == "true"){
        sendDataDimmerBoard(chr: "931", castType: "01");
      }
      else if(status == "false")
      {
        sendDataDimmerBoard(chr: "932", castType: "01");
      }

    });

  }

  onChangedFunction7(bool newValue7){
    setState(() {
      val7 = newValue7;

      String status = val7? "true" : "false";
      if(status == "true"){
        sendDataDimmerBoard(chr: "919", castType: "01");
      }
      else if(status == "false")
      {
        sendDataDimmerBoard(chr: "919", castType: "01");
      }
    });
  }

  onChangedFunction8(bool newValue8){
    setState(() {
      val8 = newValue8;
      String status = val8? "true" : "false";

      if(modeltypeset==("SWB")){
        print("enter SWB");
        if(status == "true"){
          sendDataDimmerBoard(chr: "936", castType: "01");
        }
        else if(status == "false")
        {
          sendDataDimmerBoard(chr: "937", castType: "01");
        }
      }
    }
    );

  }

  onChangedFunction9(bool newValue9){
    setState(() {
      val9 = newValue9;
      print("Inverse:$val9");
      String status = val9? "true" : "false";

      if(modeltypeset=="CUR"){

        print("enter cur");
        if(status == "true"){
          sendDataDimmerBoard(chr: "933", castType: "01");
        }
        else if(status == "false")
        {
          sendDataDimmerBoard(chr: "934", castType: "01");
        }
      }
    }
    );
  }

  Widget customSwitch1(String text, bool val, Function onChangedMethod){
    print("Text_is : $text");
    return Padding(
        padding: const EdgeInsets.all(0.0),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CupertinoSwitch(
                activeColor: Color.fromRGBO(66, 130, 208, 1),
                value: val1, onChanged: (newValue){
                onChangedMethod(newValue);
                  print("valI1: $val1");
                }
                ),
          ],
        )
    );
  }

  Widget customSwitch2(String text, bool val, Function onChangedMethod){
    print("Text_is : $text");
    return Padding(
        padding: const EdgeInsets.all(0.0),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            CupertinoSwitch(

                activeColor: Color.fromRGBO(66, 130, 208, 1),
                value: val2, onChanged: (newValue1){
              print("val2: $val2");
              onChangedMethod(newValue1);
            })


          ],
        )
    );
  }

  Widget customSwitch3(String text, bool val, Function onChangedMethod){
    print("Text_is : $text");
    return Padding(
        padding: const EdgeInsets.all(0.0),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            CupertinoSwitch(
                activeColor: Color.fromRGBO(66, 130, 208, 1),
                value: val3, onChanged: (newValue1){
                  onChangedMethod(newValue1);
              }
            )
          ],
        )
    );
  }

  Widget customSwitch4(String text, bool val, Function onChangedMethod){
    print("Text_is : $text");
    return Padding(
        padding: const EdgeInsets.all(0.0),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CupertinoSwitch(
                activeColor: Color.fromRGBO(66, 130, 208, 1),
                value: val4, onChanged: (newValue1){

              onChangedMethod(newValue1);
            })
          ],
        )
    );
  }

  Widget customSwitch5(String text, bool val, Function onChangedMethod){
    print("Text_is : $text");
    return Padding(
        padding: const EdgeInsets.all(0.0),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           // Transform.scale(
            //scale:0.1,
             // child:
            CupertinoSwitch(
                activeColor: Color.fromRGBO(66, 130, 208, 1),
                value: val5, onChanged: (newValue1){
                print("val5: $val5");
                onChangedMethod(newValue1);
            })
           // ),
          ],
        )
    );
  }

  Widget customSwitch6(String text, bool val, Function onChangedMethod){
    print("Text_is : $text");
    return Padding(
        padding: const EdgeInsets.all(0.0),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CupertinoSwitch(
                activeColor: Color.fromRGBO(66, 130, 208, 1),
                value: val6, onChanged: (newValue1){
                  onChangedMethod(newValue1);
              })
          ],
        )
    );
  }

  Widget customSwitch7(String text, bool val, Function onChangedMethod){
    print("Text_is : $text");
    return Padding(
        padding: const EdgeInsets.all(0.0),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CupertinoSwitch(
                activeColor: Color.fromRGBO(66, 130, 208, 1),
                value: val7, onChanged: (newValue1){
                  onChangedMethod(newValue1);
            })
          ],
        )
    );
  }

  Widget customSwitch8(String text, bool val, Function onChangedMethod){
    print("Text_is : $text");
    return Padding(
        padding: const EdgeInsets.all(0.0),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CupertinoSwitch(
                activeColor: Color.fromRGBO(66, 130, 208, 1),
                value: val8, onChanged: (newValue1){
                  onChangedMethod(newValue1);
            })
          ],
        )
    );
  }
  Widget customSwitch9(String text, bool val, Function onChangedMethod){
    print("Text_is : $text");
    return Padding(
        padding: const EdgeInsets.all(0.0),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CupertinoSwitch(
                activeColor: Color.fromRGBO(66, 130, 208, 1),
                value: val9, onChanged: (newValue1){
                  onChangedMethod(newValue1);
            })
          ],
        )
    );
  }

  iRButton(){
      // return
      //  IconButton(
      //     icon: irBtnImg,
      //     onPressed: () {
      //       sendDataDimmerBoard(chr: "930",castType: "01");
      //       },
      // );

      return Container(

        child: InkWell(
          onTap: (){
            sendDataDimmerBoard(chr: "930",castType: "01");

          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset('images/switchicons/ir_reset.png',
              height:MediaQuery.of(context).size.height/17,
              width :MediaQuery.of(context).size.width/17, fit: BoxFit.contain,),
          ),
        ),
      );

  }


  setIconButton() {
    return Container(
      child: InkWell(
        onTap: (){

          setState(() {
            print("I_am_set_Button");
            if(dropdownValue=="1"){
              print("I_Am_1");
              sendDataDimmerBoard(chr: "921",castType: "01");
            }
            else if(dropdownValue=="2"){
              print("I_Am_2");
              sendDataDimmerBoard(chr: "922",castType: "01");
            }
            else if(dropdownValue=="3"){
              print("I_Am_3");
              sendDataDimmerBoard(chr: "923",castType: "01");
            }
            else if(dropdownValue=="4"){
              print("I_Am_4");
              sendDataDimmerBoard(chr: "924",castType: "01");
            }
            else if(dropdownValue=="5"){
              print("I_Am_5");
              sendDataDimmerBoard(chr: "925",castType: "01");
            }
            else if(dropdownValue=="6"){
              print("I_Am_6");
              sendDataDimmerBoard(chr: "926",castType: "01");
            }

          });
        },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset('images/switchicons/set.png',
              height:MediaQuery.of(context).size.height/17,
              width :MediaQuery.of(context).size.width/17, fit: BoxFit.contain,),
          ),
      ),
    );
  }


  buildDropDown() {

    return
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3.1),
            child: SizedBox(
              //width: 50,

              child: ButtonTheme(
                minWidth: 30,

                alignedDropdown: true,
                child: DropdownButton<String>(
                  itemHeight: null,
                  isDense: true,
                  isExpanded: true,
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_drop_down_sharp),
                  elevation: 10,
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height:1,
                    //color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: <String>['1', '2', '3', '4', '5', '6']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                        // width: 5,
                        //alignment: Alignment.center,
                          child: Text(value)),

                    );
                  }).toList(),
                ),
              ),
            ),
          )
        ],
      );

    // else { // Just Divider with zero Height xD
    //   return Divider(color: Colors.white, height: 0.0);
    // }
  }


  Widget swbS051(){

    if(modeltypeset.contains("SWB")){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Transform.scale(
          //scale: 1.5,
          Visibility(
            visible: fanBtnImgV,
            child: Expanded(
              flex: 2,
              child: Container(

                child: InkWell(
                  onTap: (){
                    setState(() {
                      if(mounted) {
                        //showAlertDialog(context);

                        showDialog(
                          barrierColor: Colors.black26,
                          context: context,
                          builder: (context) {
                            return  Fanspeed();
                          },
                        );

                      }
                    });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset('images/switchicons/fan_speed.png',
                      height:MediaQuery.of(context).size.height/17,
                      width :MediaQuery.of(context).size.width/17, fit: BoxFit.contain,),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
              flex: 2,
              child:
              iRButton()

          ),
          Expanded(
            flex:2,

            child: buildDropDown(),
          ),

          Expanded(
            flex: 2,

            child: setIconButton(),
          )
        ],
      );
    }
    else{
      return Row();
    }

  }

  // showAlertDialog(BuildContext context){
  //   Widget cancelButton = TextButton(
  //     child: Text("Cancel"),
  //     onPressed: (){
  //       Navigator.of(context,rootNavigator: true).pop();
  //     },
  //   );
  //   Widget continueButton = TextButton(
  //     child: Text("Save"),
  //       onPressed: (){
  //       if(this.mounted){
  //         ani.Calculate();
  //         Navigator.of(context,rootNavigator: true).pop();
  //       }
  //     }
  //   );
  //   AlertDialog alert = AlertDialog(
  //     insetPadding: EdgeInsets.symmetric(
  //       horizontal: 50.0,
  //       vertical: 100.0,
  //     ),
  //     title: Text("Alert Dialog"),
  //     content: Fanspeed(),
  //     actions: [
  //       cancelButton,
  //       continueButton,
  //     ],
  //   );
  //
  //   showDialog(context: context, builder: (BuildContext context){
  //       return alert;
  //     }
  //   );
  //
  // }

  void sendDataDimmerBoard({String chr, String castType}) {

    String cast1=castType;
    String gI=groupIdset;
    String dnumS=dnum.padLeft(4,'0');
    String rnumS=rnum.padLeft(2,'0');
    String data = chr;
    String cE="000000000000000";
    String a = '0';

    String dataS = '*' + a + cast1 + gI + dnumS + rnumS + data + cE + '#';

    if(s.socketconnected==true){
      s.socket1(dataS);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    print("Enter init state");
    super.initState();

    FNC.DartNotificationCenter.unregisterChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.registerChannel(channel: 'MasterNotification');
    FNC.DartNotificationCenter.subscribe(channel: 'MasterNotification', onNotification: (options) {
      print('SWNotified: $options');
      swResponce(options);

    }, observer: null);

    FNC.DartNotificationCenter.unregisterChannel(channel: 'socketconndevice');
    FNC.DartNotificationCenter.registerChannel(channel: 'socketconndevice');
    FNC.DartNotificationCenter.subscribe(channel: 'socketconndevice', onNotification: (options) {
      socketsend();
    }, observer: null);

    hname = _globalService.hname;
    hnum = _globalService.hnum;
    rnum = _globalService.rnum;
    rname = _globalService.rname;
    dnum = _globalService.dnum;
    groupIdset = _globalService.groupId;
    ddevmodel = _globalService.ddevModel;
    modeltypeset = _globalService.modeltype;
    devicenameset = _globalService.devicename;

    print("global $hname,$hnum,$rnum,$rname,$dnum,$groupIdset,$ddevmodel,$modeltypeset,$devicenameset");

    userAdmin();
  }

  swResponce(String notification) {

    print("Sw $notification");
    print("length $notification.length");

    String sDev = dnum.padLeft(4, '0');
    String rdev = notification.substring(4, 8);

    print("responce $sDev,$rdev");



    if (sDev==(rdev)) {

      String responce1 = notification.substring(28,29);
      switch(responce1){
        case '0':
          val1=false;//touch
          val2=false;//IR
          val3=false;//Buzzer
          val4=false;//Memory
          break;

        case '1':
          val1 = false;//touch
          val2 = false;//ir
          val3 = false;//buzzer
          val4 = true;//memory
          break;

        case '2':
          val1 = true;
          val2 = false;
          val3 = false;
          val4 = false;
          break;

        case '3':
          val1 = true;
          val2 = false;
          val3 = false;
          val4 = true;
          break;

        case '4':
          val1 = false;
          val2 = false;
          val3 = true;
          val4 = false;
          break;

        case '5':
          val1 = false;
          val2 = false;
          val3 = true;
          val4 = true;
          break;

        case '6':

          val1 = true;
          val2 = false;
          val3 = true;
          val4 = false;
          break;

        case '7':
          val1 = true;
          val2 = false;
          val3 = true;
          val4 = true;
          break;

        case '8':
          val1 = false;
          val2 = true;
          val3 = false;
          val4 = false;
          break;

        case '9':
          val1 = false;
          val2 = true;
          val3 = false;
          val4 = true;
          break;

        case 'A':
          val1 = true;
          val2 = true;
          val3 = false;
          val4 = false;
          break;
        case 'B':
          val1 = true;
          val2 = true;
          val3 = false;
          val4 = true;
          break;
        case 'C':
          val1 = false;
          val2 = true;
          val3 = true;
          val4 = false;
          break;

        case 'D':
          val1 = false;
          val2 = true;
          val3 = true;
          val4 = true;
          break;
        case 'E':
          val1 = true;
          val2 = true;
          val3 = true;
          val4 = false;
          break;
        case 'F':
          val1 = true;
          val2 = true;
          val3 = true;
          val4 = true;
          break;
        default:
      }

      String response2 = notification.substring(29,30);
      switch(response2){
        case '0':
          val5 = false;
          val6 = false;
          val7 = false;
          // val8 = false;
          break;
        case '1':
          val5 = false;
          val6 = false;
          val7 = false;
          //val8 = false;
          break;
        case '2':
          val5 = true;
          val6 = false;
          val7 = false;
          //val8 = false;
          break;
        case '3':
          val5 = true;
          val6 = false;
          val7 = false;
          //val8 = false;
          break;
        case '4':
          val5 = false;
          val6 = false;
          val7 = true;
          //val8 = false;
          break;
        case '5':
          val5 = false;
          val6 = false;
          val7 = true;
          //val8 = false;
          break;
        case '6':
          val5 = true;
          val6 = false;
          val7 = true;
          //val8 = false;
          break;
        case '7':
          val5 = true;
          val6 = false;
          val7 = true;
          //val8 = false;
          break;
        case '8':
          val5 = false;
          val6 = true;
          val7 = false;
          //val8 = true;
          break;
        case '9':
          val5 = false;
          val6 = true;
          val7 = false;
          //val8 = true;
          break;
        case 'A':
          val5 = true;
          val6 = true;
          val7 = false;
          //val8 = false;
          break;
        case 'B':
          val5 = true;
          val6 = true;
          val7 = false;
          // val8 = true;
          break;
        case 'C':
          val5 = false;
          val6 = true;
          val7 = true;
          //val8 = true;
          break;

        case 'D':
          val5 = false;
          val6 = true;
          val7 = true;
          //val8 = true;
          break;
        case 'E':
          val5 = true;
          val6 = true;
          val7 = true;
          //val8 = true;
          break;
        case 'F':
          val5 = true;
          val6 = true;
          val7= true;
          //val8= true;
          break;
        default:
      }

      if(modeltypeset=="SWB"){

        String responce3=notification[25];
        print("enter swb responce $responce3");
        switch(responce3) {
          case '0':
            val8 = false;
            break;
          case '1':
            val8=true;
            break;
          default:
            val8=false;
        }

      }
      else if(modeltypeset == "CUR"){

        String responce3=notification[25];
        print("enter cur responce $responce3");
        switch(responce3) {
          case '0':
            val9 = false;
            break;
          case '1':
            val9=true;
            break;
          default:
            val9=false;
        }

      }



      String strVersion = notification.substring(20,21);
      if(strVersion.contains("A")){
        String version=notification[21]+"."+notification[22]+notification[23];
        versionNo=version;
        print("version_no $versionNo");
      }
      String serial = notification[27];
      dropdownValue=serial;
    }

    setState(() {
      val1=val1;
      val2=val2;
      val3=val3;
      val4=val4;
      val5=val5;
      val6=val6;
      val7=val7;
      val8=val8;
      versionNo=versionNo;
      dropdownValue=dropdownValue;
      deviceListViewData=deviceListViewData;
    });
  }

  void userAdmin()async{

    if(ddevmodel==("S051") || ddevmodel==("S021")){

      if(double.parse(versionNo) > double.parse(oldVersion)){
        fanBtnImgV=false;
      }
      else if(double.parse(versionNo) <= double.parse(oldVersion)){
        fanBtnImgV=true;
      }
    }
    else{
      fanBtnImgV=false;
    }

    DBHelper dbHelper;
    dbHelper = DBHelper();
    String userAdmin;
    List resultI = await dbHelper.getLocalDateHName(hname);
    userAdmin=resultI[0]['lg'];
    if(userAdmin.contains("SA")){
      switch(modeltypeset){
        case 'SWB':

          if(double.parse(versionNo) > double.parse(oldVersion)){
            deviceListViewData=["Touch", "IR", "Buzzer","LED", "Memory", "Hardware", "Manual Override", "Config Mode", "Version"];
          }
          else {
            deviceListViewData=["Touch", "IR", "Buzzer", "Memory", "Hardware", "Manual Override", "Config Mode", "Version"];
          }

          break;
        case 'PIR':
          deviceListViewData=["Hardware", "Config Mode", "Version"];
          break;

        case 'RGB':
          deviceListViewData=["Hardware", "Config Mode", "Version"];
          break;
        case 'CUR':
          deviceListViewData=["Touch", "IR", "Buzzer", "Memory", "Hardware", "Manual Override","Inverse", "Config Mode", "Version"];
          break;
        case 'PSC':
          deviceListViewData=["Buzzer","Hardware", "Manual Override","Config Mode", "Version"];
          break;
        case 'PLC':
          deviceListViewData=["Buzzer","Hardware", "Manual Override","Config Mode", "Version"];
          break;
        case 'SPNK':
          deviceListViewData=["Buzzer", "Memory", "Hardware", "Manual Override","Config Mode","Version"];
          break;
        case 'SDG':
          deviceListViewData=["Touch", "IR", "Buzzer", "Memory", "Hardware", "Manual Override", "Config Mode", "Version"];
          break;
        case 'swg':
          deviceListViewData=["Touch", "IR", "Buzzer", "Memory", "Hardware", "Manual Override", "Config Mode", "Version"];
          break;
        case 'slide':
          deviceListViewData=["Touch", "IR", "Buzzer", "Memory", "Hardware", "Manual Override", "Config Mode", "Version"];
          break;
        case 'sosh':
          deviceListViewData=["Touch", "IR", "Buzzer", "Memory", "Hardware", "Manual Override", "Config Mode", "Version"];
          break;
        case 'FM':
          deviceListViewData=["Touch", "IR", "Buzzer", "Memory", "Hardware", "Manual Override", "Config Mode", "Version"];
          break;

      }
    }
    else if(userAdmin.contains("A")){
      switch(modeltypeset){
        case 'SWB':
          deviceListViewData=["Touch", "IR", "Buzzer", "Memory","LED" ,"Hardware", "Manual Override", "Version"];
          break;
        case 'PIR':
          deviceListViewData=["Hardware","Version"];
          break;
        case 'RGB':
          deviceListViewData=["Hardware","Version"];
          break;
        case 'CUR':
          deviceListViewData=["Touch", "IR", "Buzzer", "Memory", "Hardware", "Manual Override","Version"];
          break;
        case 'PSC':
          deviceListViewData=["Buzzer","Hardware", "Manual Override","Version"];
          break;
        case 'PLC':
          deviceListViewData=["Buzzer","Hardware", "Manual Override","Version"];
          break;
        case 'SPNK':
          deviceListViewData=["Buzzer", "Memory", "Hardware", "Manual Override","Version"];
          break;
        case 'SDG':
          deviceListViewData=["Touch", "IR", "Buzzer", "Memory", "Hardware", "Manual Override","Version"];
          break;
          case 'swg':
          deviceListViewData=["Touch", "IR", "Buzzer", "Memory", "Hardware", "Manual Override","Version"];
          break;
        case 'slide':
          deviceListViewData=["Touch", "IR", "Buzzer", "Memory", "Hardware", "Manual Override","Version"];
          break;
        case 'sosh':
          deviceListViewData=["Touch", "IR", "Buzzer", "Memory", "Hardware", "Manual Override","Version"];
          break;

        case 'FM':
          deviceListViewData=["Touch", "IR", "Buzzer", "Memory", "Hardware", "Manual Override","Version"];
          break;

      }
    }

    setState(() {
      devicenameset=devicenameset;
      deviceListViewData=deviceListViewData;
      fanBtnImgV=fanBtnImgV;
    });

    socketsend();


  }

  socketsend(){

    if(s.socketconnected == true) {
      sendDataDimmerBoard(chr: "920", castType: "01");
    }
    else{
      s.checkindevice(hname, hnum);
    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(

            child:Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children:<Widget> [
                  // Expanded(
                  //   flex:0,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Container(
                  //         //color: Colors.green,
                  //         width: MediaQuery.of(context).size.width*0.70,
                  //         child:  Center(
                  //           child: Text(devicenameset, maxLines: 2,
                  //             overflow: TextOverflow.ellipsis,
                  //             textDirection: TextDirection.rtl,
                  //             textAlign: TextAlign.center,
                  //             style: TextStyle(
                  //                 color: Colors.black,
                  //                 fontWeight: FontWeight.w600,
                  //                 fontStyle: FontStyle.normal
                  //             ),
                  //           ),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  Expanded(
                    flex:9,
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:[
                        Expanded(flex: 80,
                            child: Container()),
                        Expanded(
                          flex: 840,
                          child: Container(
                            // color: Colors.yellowAccent,
                            width: MediaQuery.of(context).size.width*0.69,
                            child: deviceelement(),
                          ),
                        ),
                        Expanded(flex: 80,
                            child: Container()),
                      ],
                    ),

                  ),

                  Expanded(
                    flex:1,
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.start,

                      children:[
                        Container(
                             // color: Colors.redAccent,
                              width: MediaQuery.of(context).size.width*0.69,
                              child: swbS051()
                        )

                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ), );

  }

  Future<List> getdata() {
    return Future.delayed(Duration(seconds: 0), () {
      return deviceListViewData;
      // throw Exception("Custom Error");
    });
  }

  Widget deviceelement() {
    return FutureBuilder<List>(
        future: getdata(),
        builder: (context, snapshot){
          print("SCll $snapshot.data");

          // switch(snapshot.connectionState){
          //case ConnectionState.done:
          if (snapshot.hasError) {
            print('Error:${snapshot.error}');

          }
          else if(snapshot.hasData){

              return ListView.builder(

                    padding: EdgeInsets.zero,
                   //itemExtent: 20.0,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context ,index){
                    String data = deviceListViewData[index];
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(0.0),
                          child:  Row(
                            children: [
                              Expanded(child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Text("$data".toUpperCase(),style: TextStyle(fontSize: 13,color: Colors.grey[600],fontWeight: FontWeight.w400),),
                              )),
                              Column(
                                children: [
                                  if(data.contains("Touch"))
                                    customSwitch1(data, val1, onChangedFunction1),
                                  if(data.contains("IR"))
                                    customSwitch2(data, val2, onChangedFunction2),
                                  if(data.contains("Buzzer"))
                                    customSwitch3(data, val3, onChangedFunction3),
                                  if(data.contains("Memory"))
                                    customSwitch4(data, val4, onChangedFunction4),
                                  if(data.contains("Hardware"))
                                    customSwitch5(data, val5, onChangedFunction5),
                                  if(data.contains("Manual Override"))
                                    customSwitch6(data, val6, onChangedFunction6),
                                  if(data.contains("Config Mode"))
                                    customSwitch7(data, val7, onChangedFunction7),
                                  if(data.contains("LED"))
                                    customSwitch8(data, val8, onChangedFunction8),
                                  if(data.contains("Inverse"))
                                    customSwitch9(data, val9, onChangedFunction9),
                                  if(data.contains("Version"))
                                    Padding(padding: const EdgeInsets.only(right: 20.0,top: 12.0),
                                      child:Text(versionNo),
                                   ),
                                ]
                              )
                            ],
                          ),
                        ),

                      ],
                    );
                  });
          }
          else if (snapshot.data == null || snapshot.data.length == 0) {
            print("NoDataFound");
            return Text('No Data Found');
          }
          return CircularProgressIndicator();


        }
    );
  }







}





