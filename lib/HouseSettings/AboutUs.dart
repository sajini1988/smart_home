
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:focus_detector/focus_detector.dart';



class AboutUs extends StatefulWidget {

  AboutUs({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _AboutUsState createState() => _AboutUsState();

}
class _AboutUsState extends State<AboutUs> {


  String appName,packageName,version,buildNumber;

  @override
  void initState() {

    super.initState();

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appName = packageInfo.appName;
      packageName = packageInfo.packageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
      print("$appName,$packageName,$version,$buildNumber");

      setState(() {
        version=version;
      });
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

      onForegroundLost: () {
        print("foreground slost");
      },
      onForegroundGained: () {
        print("foregrround sgained");
      },

      child: WillPopScope(onWillPop: () async {
          return Navigator.canPop(context);
      },child:Scaffold(
        appBar: AppBar(
          toolbarHeight: 40.0,
          backgroundColor: Color.fromRGBO(66, 130, 208, 1),
          title: Text("About Us",style:TextStyle(fontSize: 18)),
          actions: <Widget>[],
        ),
        backgroundColor: Colors.white,
        body: Center(
            child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width/20),),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                            child: new Image.asset(
                              'images/navigation_icon/homeauto.png',
                              height: 60.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],

                      ),

                      Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width/30),),


                      Padding(padding: EdgeInsets.only(left: 20,right: 20),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:<Widget> [
                              Expanded(
                                  flex: 6,
                                  child: Container(
                                    color: Colors.white,
                                    child:Text(
                                      "EdisonBro",
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      textScaleFactor: 1.50,
                                      // style: TextStyle(fontSize: 18.0),
                                      maxLines: 2,
                                    style: TextStyle(color: Color.fromRGBO(66, 130, 208, 1)),),
                                  )
                              ),

                            ],
                          )
                      ),

                      Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width/50),),

                      Padding(padding: EdgeInsets.only(left: 20,right: 20),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:<Widget> [
                              Expanded(
                                  flex: 6,
                                  child: Container(
                                    color: Colors.white,
                                    child:Text(
                                      "Living Space Automation Version $version",
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      textScaleFactor: 1.50,
                                      // style: TextStyle(fontSize: 18.0),
                                      maxLines: 2,
                                    style: TextStyle(
                                      color: Color.fromRGBO(66, 130, 208, 1)
                                    ),),
                                  )
                              ),

                            ],
                          )),

                      Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width/30),),


                    ]
                )


            )
        ),
      )));





}

