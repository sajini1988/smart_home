import 'package:flutter/material.dart';
import 'package:smart_home/LDatabase.dart';
import 'package:smart_home/LDatabaseModelClass.dart';
import 'package:smart_home/Singleton.dart';
import 'package:smart_home/homepage.dart';
import 'package:smart_home/ServerDB.dart';
import 'package:group_list_view/group_list_view.dart';
import 'main.dart';
import 'package:smart_home/HouseSettings/SmartSettings.dart';
import 'package:smart_home/GlobalService.dart';
import 'package:smart_home/HouseSettings/OperatorSettings/UserSettings.dart';
import 'package:smart_home/HouseSettings/OperatorSettings/OperatorSettings.dart';
import 'package:smart_home/Timer/TimerDB.dart';

class SideDrawer extends StatefulWidget {
  const SideDrawer({Key key}) : super(key: key);
  @override
  _SideDrawerState createState() => _SideDrawerState();

}
class _SideDrawerState extends State<SideDrawer> {

  List settings = ["User Settings","Operator Settings","Smart Settings","Support","About Us"];
  List images = ["user_settings","operator_settings","home","support","aboutus"];
  List images1 = ["user_settings01","operator_settings01","home01","support01","aboutus01"];
  double heights;
  Color c;
  Color deleteiconcolor;
  Color textcolor;
  GlobalService _globalService = GlobalService();
  String hname,hnum;

  var s=Singleton();
  DBHelper dbHelper;

  Future<List<Student>> students;
  String sname;
  List studentstest=[];
  String userAdmin;


  @override
  void initState() {

    // TODO: implement initState
    super.initState();

    hname = _globalService.hname;
    hnum = _globalService.hnum;
    dbHelper = DBHelper();
    refreshStudentList1();
    getAdmin();

  }
  getAdmin()async{
    List result = await dbHelper.getLocalDateHName(hname);
    if(result.length==0){
      userAdmin="";
    }
    else{
      userAdmin=result[0]['lg'];
    }

  }
  // refreshStudentList1() {
  //   setState(() {
  //     students = dbHelper.getStudents();
  //   });
  // }

  refreshStudentList1() async {
    studentstest = await dbHelper.getStudentstest();
    setState(() {
      studentstest=studentstest;

    });
  }
  Future<List<Student>>refreshStudentList2() {

    return Future.delayed(Duration(seconds:0 ), () {
      students = dbHelper.getStudents();
      return students;
      // throw Exception("Custom Error");
    });

  }

  void dispose1() {

    print("menu close & dispose method");
    print(s.socket);
    if(s.socket!=null){
      print("enter not null");
      s.socket.close();
      s.socketconnected=false;
      print(s.socket);
    }
    else{

      s.socketconnected=false;

    }
    DBProvider.db.close();
    TimerDBProvider.db.close();

  }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     child: SafeArea(
  //       child: Drawer(
  //         child: ListView(
  //           children: [
  //             ListTile(
  //               title: Text('Add Home'),
  //               leading: Icon(Icons.home),
  //               onTap: () {
  //
  //                 dispose();
  //                 Navigator.of(context).push(
  //                   MaterialPageRoute(builder: (context) => MyStatefulWidget()),
  //                 );
  //               },
  //             ),
  //
  //            // Expanded(
  //                FutureBuilder(
  //                 future: students,
  //                  builder: (context, snapshot) {
  //                   if (snapshot.hasData) {
  //                      return generateList(snapshot.data);
  //                   }
  //                   if (snapshot.data == null || snapshot.data.length == 0) {
  //                     return Text('No Data Found');
  //                   }
  //                   return CircularProgressIndicator();
  //                 },
  //                ),
  //
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: SafeArea(
        child: Drawer(
            child:Column(
            children:<Widget> [
              Expanded(
                flex: 10,
                  child: Container(
                      color:Colors.white,
                      child: Column(
                          children: <Widget>[

                            // Expanded(
                            //     flex:1,
                            //     child:Container(
                            //       color: Colors.blueGrey,
                            //
                            //     )
                            // ),

                            Expanded(
                                flex:2,
                                child:Container(
                                  decoration: BoxDecoration(
                                    //color: Colors.black,
                                    image: DecorationImage(
                                        image:AssetImage("images/navigation_icon/homeauto.png"),
                                        fit:BoxFit.scaleDown,
                                    ),
                                  ),
                                )
                            ),
                            Expanded(
                                flex:1,
                                child:GestureDetector(
                                    onTap: (){
                                      dispose1();
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => MyStatefulWidget()),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        image: DecorationImage(
                                            image:AssetImage("images/navigation_icon/add_home.png"),
                                            fit:BoxFit.scaleDown
                                        ),

                                      ),

                                    )
                                )
                            ),
                            Expanded(
                                flex:7,
                                child:Container(
                                  child: deviceelement(),
                                )
                            )
                          ]
                      )
                  )

              )
            ],

            )

        ),
      ),
    );

  }

  Future<List> getdata() {
    return Future.delayed(Duration(seconds: 0), () {
      return settings;
      // throw Exception("Custom Error");
    });
  }

  Widget deviceelement() {
    return FutureBuilder<List>(
        future: getdata(),
        builder: (context, snapshot) {
          print("SCll $snapshot.data");

          // switch(snapshot.connectionState){
          //case ConnectionState.done:
          if (snapshot.hasError) {
            print('Error:${snapshot.error}');
          }
          else if (snapshot.hasData) {
            return GroupListView(
              sectionsCount: 2,
              countOfItemInSection: (int section){
                int value;
                if(section == 0){


                  value = studentstest.length;
                  print("value $value $section");
                }
                else if(section == 1){
                  value = settings.length;
                  print("value $value $section");
                }
                return  value;
              },
              groupHeaderBuilder: (BuildContext context, int section) {

                if(section==0){
                  heights=0;
                }
                else if(section==1){
                  heights=2;
                }

                return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Container(
                        color: Colors.grey,
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        height:heights,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                            Column(
                                children: [
                                  if(section  == 0)
                                    Text(
                                      "",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      textAlign: TextAlign.left,
                                    ),
                                  if(section  == 1)
                                    Text(
                                      "",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      textAlign: TextAlign.left,
                                    ),
                                ]
                            ) ],
                          )
                        )));
              },
              itemBuilder: itemBuilder,
              separatorBuilder: (context, index) => Divider(
                color: Colors.white10,
                height: 0,
              ),
              sectionSeparatorBuilder: (context, section) => SizedBox(),


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

  // ignore: missing_return
  Widget itemBuilder(BuildContext context, IndexPath index) {
    String user, num;
    String imgs;

    if (index.section == 0) {
      user = studentstest[index.index]["name"];
      num = studentstest[index.index]["lb"];

      print(index.index);
      if (user == hname) {
        c = Color.fromARGB(0, 183, 184, 185);
        imgs = "home01";
        textcolor = Colors.blue;
        deleteiconcolor = Colors.blue;
      }
      else {
        c = Colors.white;
        imgs = "home";
        textcolor = Colors.black87;
        deleteiconcolor = Colors.grey;
      }

      return ListTile(

          tileColor: c,
          dense: true,
          contentPadding: EdgeInsets.only(left: 2.0, right: 5.0),
          //contentPadding: EdgeInsets.only(left: 0.0),
          //visualDensity
          //
          // : VisualDensity(horizontal: 0, vertical:-1),
          //contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal:0.0),
          leading: IconButton(
            icon: Image.asset(
                'images/navigation_icon/$imgs.png',
                fit: BoxFit.fill),
            onPressed: () {},
          ),
          title: Text(
            user,
            style: TextStyle(
              //fontSize: 15
                color: textcolor
            ),
            textScaleFactor: 1.40,

          ),
          trailing: IconButton(
            icon: Icon(Icons.delete,
                color: deleteiconcolor),

            onPressed: () {

              showAlertDialogdeleteRoom(context,user);

            },
          ),

          onTap: () {
            user = studentstest[index.index]["name"];
            num = studentstest[index.index]["lb"];

            setState(() {
              user = user;
              num = num;
            });
            dispose1();

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) =>
                    MyApp(name: user, lb: num)),
                    (Route<dynamic> route) => false
            );
            // Navigator.push(context,
            //   MaterialPageRoute(builder: (context) => MyApp(name: user, lb: num)),
            //MaterialPageRoute(builder: (context) =>MyHomePage(title: student.name,lb:student.lb)));,

          }
      );
    }
    else if (index.section == 1) {
      user = settings [index.index];
      String imgs = images[index.index];
      return ListTile(
        dense: true,
        contentPadding: EdgeInsets.only(left: 2.0, right: 5.0),
        leading: IconButton(
          icon: Image.asset(
              'images/navigation_icon/$imgs.png',
              fit: BoxFit.scaleDown),
          onPressed: () {},
        ),
        title: Text(
          user,
          textScaleFactor: 1.40,
          style: TextStyle(color: Colors.black87),
        ),
        onTap: () {
          if (user==("User Settings")) {

            if(userAdmin=="SA" || userAdmin == "A"){
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserSettings()));
            }
            else{
              fluttertoast("Access Denied");
            }


            //   //MaterialPageRoute(builder: (context) =>MyHomePage(title: student.name,lb:student.lb)),
            // );

            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(builder: (BuildContext context) => UserSettings()),
            //         (Route<dynamic> route) => false
            //);

            // Navigator
            //     .of(context)
            //     .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => UserSettings()));

          }
          else if (user==("Operator Settings")) {

            if(userAdmin == "SA" || userAdmin == "A"){
              Navigator.push(context, MaterialPageRoute(builder: (context) => OperatorSettings()));
            }
            else {
              fluttertoast("Access Denied");
            }


            //   //MaterialPageRoute(builder: (context) =>MyHomePage(title: student.name,lb:student.lb)),
            // );

            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(builder: (BuildContext context) => OperatorSettings()),
            //         (Route<dynamic> route) => false
            // );

            // Navigator
            //     .of(context)
            //     .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => OperatorSettings()));

          }
          else if (user==("Smart Settings")) {

            if(userAdmin == "A" || userAdmin == "SA"){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SmartSettings()));
            }
            else{
              fluttertoast("Access Denied");
            }

            //   //MaterialPageRoute(builder: (context) =>MyHomePage(title: student.name,lb:student.lb)),
            // );

            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(builder: (BuildContext context) =>SmartSettings() ),
            //         (Route<dynamic> route) => false
            // );

            // Navigator
            //     .of(context)
            //     .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => SmartSettings()));

          }
          else if (user==("Support")) {

            if(userAdmin == "SA" || userAdmin == "A"){

            }
            else{
              fluttertoast("Access Denied");
            }

          }
          else if (user==("About Us")) {
            if(userAdmin == "SA" || userAdmin == "A"){

            }
            else{
              fluttertoast("Access Denied");
            }

          }
        },
      );
    }
  }

   showAlertDialogdeleteRoom(BuildContext context,String user) {

      // Create button
      Widget yesButton = TextButton(
        child: Text("Yes"),
        onPressed: () {

          dbHelper.delete(user);
          refreshStudentList1();
          Navigator.of(context,rootNavigator: true).pop();


        },
      );

      Widget noButton = TextButton(
        child: Text("No"),
        onPressed: () {
          Navigator.of(context,rootNavigator: true).pop();
        },
      );

      // Create AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Alert"),
        content: Text("Do you want to Delete the House Selected ??"),
        actions: [
          yesButton,
          noButton
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



  }

  // SingleChildScrollView generateList(List<Student> students) {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.vertical,
  //     child: SizedBox(
  //       // width: MediaQuery.of(context).size.width,
  //       child: DataTable(
  //         columns: [
  //           DataColumn(
  //             label: Text(' NAME'),
  //           ),
  //           DataColumn(
  //             label: Text('DELETE'),
  //           )
  //         ],
  //         rows: students
  //             .map(
  //               (student) => DataRow(
  //             cells: [
  //               DataCell(
  //                 Text(student.name),
  //                 onTap: ()
  //                   {
  //                     dispose();
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(builder: (context) => MyApp(name: student.name, lb: student.lb)),
  //                       //MaterialPageRoute(builder: (context) =>MyHomePage(title: student.name,lb:student.lb)),
  //                     );
  //                   }
  //                 // => Scaffold
  //                 //     .of(context)
  //                 //     .showSnackBar(SnackBar(content: Text(student.name.toString()))),
  //
  //               ),
  //               DataCell(
  //                 IconButton(
  //                   icon: Icon(Icons.delete),
  //                   onPressed: () {
  //                     dbHelper.delete(student.name);
  //                     refreshStudentList1();
  //                   },
  //                 ),
  //               )
  //             ],
  //           ),
  //         )
  //             .toList(),
  //       ),
  //     ),
  //   );
  // }











