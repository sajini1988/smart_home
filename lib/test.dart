// import 'package:drawer_mine/first.dart';
// import 'package:drawer_mine/second.dart';
import 'package:flutter/material.dart';
class MyApptest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;



  final _drawerItems = [
    DrawerItem("Pizza", Icons.local_pizza),
    DrawerItem("Drink", Icons.local_drink),
  ];

  _getPage(int index) {
    switch (index) {
      case 0:
        return First();

      case 1:
        return Second();
    }
  }

  _onItemSelected(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop();
  }

  List<Widget> _buildNavigationItems() {
    List<Widget> list = [];

    for (int i = 0; i < _drawerItems.length; i++) {
      list.add(ListTile(
        leading: Icon(_drawerItems[i].icon),
        title: Text(
          _drawerItems[i].title,
          style: TextStyle(fontSize: 16.0),
        ),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onItemSelected(i),
      ));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo'),
      ),
      body: _getPage(_selectedDrawerIndex),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.deepPurple,
              child: DrawerHeader(
                child: Center(
                  child: Text(
                    'Drawer Header',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ]..addAll(_buildNavigationItems()),
        ),
      ),
    );
  }
}

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}


class First extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(child: Text('Pizza')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.local_pizza),
        backgroundColor: Colors.deepPurple,
        onPressed: () {},
      ),
    );
  }
}

class Second extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(child: Text('Drink')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.local_drink),
        backgroundColor: Colors.deepPurple,
        onPressed: () {},
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
//
//
// class MyApptest extends StatelessWidget {
//
//   @override
//
//   Widget build(BuildContext context) {
//
//     return MaterialApp(
//
//       title: 'Nicesnippets',
//
//       theme: ThemeData(
//
//         primarySwatch: Colors.red,
//
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//
//       ),
//
//       home: MyHomePage(title: 'Welcome to Nicesnippets'),
//
//     );
//
//   }
//
// }
//
//
// class MyHomePage extends StatefulWidget {
//
//   @override
//
//   MyHomePage({Key key, this.title}) : super(key: key);
//
//   final String title;
//
//   State createState() => _State();
//
// }
//
//
//
//
// class _State extends State {
//
//   TextEditingController nameController = TextEditingController();
//
//   int _radioValue = 0;
//
//
//   void _handleRadioValueChange(int value) {
//
//     setState(() {
//
//       _radioValue = value;
//
//
//       switch (_radioValue) {
//
//         case 0:
//
//           break;
//
//         case 1:
//
//           break;
//
//         case 2:
//
//           break;
//
//       }
//
//     });
//
//   }
//
//
//   @override
//
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//
//         appBar: AppBar(
//
//           title: Text('Welcome to Nicesnippets'),
//
//         ),
//
//         body: Padding(
//
//
//             padding: EdgeInsets.all(10),
//
//
//             child: ListView(
//
//               children: [
//
//                 Container(
//
//                     alignment: Alignment.center,
//
//                     padding: EdgeInsets.all(10),
//
//                     margin: const EdgeInsets.only(top: 50),
//
//                     child: Text(
//
//                       'Radio Button',
//
//                       style: TextStyle(
//
//                           color: Colors.red,
//
//                           fontWeight: FontWeight.w500,
//
//                           fontSize: 30),
//
//                     )),
//
//                 new Row(
//
//                   mainAxisAlignment: MainAxisAlignment.center,
//
//                   children: [
//
//                     new Radio(
//
//                       value: 0,
//
//                       groupValue: _radioValue,
//
//                       onChanged: _handleRadioValueChange,
//
//                     ),
//
//                     new Text(
//
//                       'First',
//
//                       style: new TextStyle(fontSize: 16.0),
//
//                     ),
//
//                     new Radio(
//
//                       value: 1,
//
//                       groupValue: _radioValue,
//
//                       onChanged: _handleRadioValueChange,
//
//                     ),
//
//                     new Text(
//
//                       'Second',
//
//                       style: new TextStyle(
//
//                         fontSize: 16.0,
//
//                       ),
//
//                     ),
//
//                     new Radio(
//
//                       value: 2,
//
//                       groupValue: _radioValue,
//
//                       onChanged: _handleRadioValueChange,
//
//                     ),
//
//                     new Text(
//
//                       'Last',
//
//                       style: new TextStyle(fontSize: 16.0),
//
//                     ),
//
//                   ],
//
//                 ),
//
//                 Container(
//
//                     height: 50,
//
//                     padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//
//                     child: RaisedButton(
//
//                       textColor: Colors.white,
//
//                       color: Colors.red,
//
//                       child: Text('Button'),
//
//                       onPressed: () {
//
//                         print(nameController.text);
//
//                       },
//
//                     )),
//
//               ],
//
//             )));
//
//   }
//
//
//
// }

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
//
//
// //void main() => runApp(MyApp());
// class MyApptest extends StatefulWidget {
//   @override
//   _MyState createState() {
//     return _MyState();
//   }
// }
//
// class _MyState extends State<MyApptest>
// {
//   bool _value = false;
//   int val = -1;
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: Scaffold(
//             appBar: AppBar(
//               backgroundColor: Colors.green[400],
//               title: Text("Flutter RadioButton"),
//             ),
//             body: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 ListTile(
//                   title: Text("Male"),
//                   leading: Radio(
//                     value: 1,
//                     groupValue: val,
//                     onChanged: (value) {
//                       setState(() {
//                         val = value;
//                       });
//                     },
//                     activeColor: Colors.green,
//                   ),
//                 ),
//                 ListTile(
//                   title: Text("Female"),
//                   leading: Radio(
//                     value: 2,
//                     groupValue: val,
//                     onChanged: (value) {
//                       setState(() {
//                         val = value;
//                       });
//                     },
//                     activeColor: Colors.green,
//                   ),
//                 ),
//               ],
//             )
//         )
//     );
//   }
// }
//
//
// // import 'dart:async';
// // import 'package:flutter/material.dart';
// //
// // // void main() {
// // //   runApp(new MaterialApp(
// // //     debugShowCheckedModeBanner: false,
// // //     home: new MyApp(),
// // //   ));
// // // }
// //
// // class MyApptest extends StatefulWidget {
// //   @override
// //   MyApptestState createState() => new MyApptestState();
// // }
// //
// // class MyApptestState extends State<MyApptest> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return new Scaffold(
// //       appBar: new AppBar(
// //         title: new Text('Slider Demo'),
// //       ),
// //       body: new Container(
// //         color: Colors.blueAccent,
// //         padding: new EdgeInsets.all(32.0),
// //         child: new ProgressIndicatorDemo(),
// //       ),
// //     );
// //   }
// // }
// //
// // class ProgressIndicatorDemo extends StatefulWidget {
// //
// //   @override
// //   _ProgressIndicatorDemoState createState() =>
// //       new _ProgressIndicatorDemoState();
// // }
// //
// // class _ProgressIndicatorDemoState extends State<ProgressIndicatorDemo>
// //     with SingleTickerProviderStateMixin {
// //   AnimationController controller;
// //   Animation<double> animation;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     controller = AnimationController(
// //         duration: const Duration(milliseconds: 2000), vsync: this);
// //     animation = Tween(begin: 0.0, end: 1.0).animate(controller)
// //       ..addListener(() {
// //         setState(() {
// //           // the state that has changed here is the animation object’s value
// //         });
// //       });
// //     controller.repeat();
// //   }
// //
// //
// //   @override
// //   void dispose() {
// //     controller.stop();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return new Center(
// //         child: new Container(
// //           child:  LinearProgressIndicator( value:  animation.value,),
// //
// //         )
// //     );
// //   }
// //
// // }
// //
// // // import 'package:flutter/material.dart';
// // //
// // // // void main() {
// // // //   runApp(MyApp());
// // // // }
// // //
// // // class MyApptest extends StatelessWidget {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return MaterialApp(
// // //       debugShowCheckedModeBanner: false,
// // //       title: 'Flutter Demo',
// // //       home: HomePage(),
// // //     );
// // //   }
// // // }
// // //
// // // class HomePage extends StatefulWidget {
// // //   @override
// // //   _HomePageState createState() => _HomePageState();
// // // }
// // //
// // // class _HomePageState extends State<HomePage> {
// // //
// // //   GlobalKey<FormState> _key = new GlobalKey();
// // //
// // //   bool _autoValidate = false;
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: Colors.white,
// // //       appBar: AppBar(
// // //         centerTitle: true,
// // //         elevation: 0.0,
// // //         title:  Text('Multi-Form Validation',
// // //             style: TextStyle(
// // //               color: Colors.white,
// // //               fontSize: 24.0,
// // //               fontWeight: FontWeight.w500,
// // //               fontFamily: 'Cera Pro',
// // //             )),
// // //       ),
// // //       body: Form(
// // //         key: _key,
// // //         autovalidate: _autoValidate,
// // //         child: Padding(
// // //           padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
// // //           child: ListView(
// // //             children: <Widget>[
// // //               TextFormField(
// // //                 validator: _validateName,
// // //                 decoration: InputDecoration(
// // //                     labelText: 'Name',
// // //                     hintText: 'Enter your name.'
// // //                 ),
// // //               ),
// // //               SizedBox(height: 10.0),
// // //               TextFormField(
// // //                 validator: _validateUserName,
// // //                 decoration: InputDecoration(
// // //                     labelText: 'UserName',
// // //                     hintText: 'Enter your username.'
// // //                 ),
// // //               ),
// // //               SizedBox(height: 10.0),
// // //               TextFormField(
// // //                 validator: _validateAge,
// // //                 keyboardType: TextInputType.number,
// // //                 decoration: InputDecoration(
// // //                     labelText: 'Age',
// // //                     hintText: 'Enter your age.'
// // //                 ),
// // //               ),
// // //               SizedBox(height: 10.0),
// // //               TextFormField(
// // //                 validator: _validateBio,
// // //                 decoration: InputDecoration(
// // //                     labelText: 'Bio',
// // //                     hintText: 'Enter your bio.'
// // //                 ),
// // //               ),
// // //               SizedBox(height: 10.0),
// // //               Row(
// // //                 mainAxisAlignment: MainAxisAlignment.center,
// // //                 children: <Widget>[
// // //                   RaisedButton(
// // //                     color: Colors.blue,
// // //                     child: Text('Save', style: TextStyle(color: Colors.white, fontSize: 16.0)),
// // //                     onPressed: () {
// // //                       if(_key.currentState.validate()){
// // //                         showDialog(
// // //                             builder: (context) => AlertDialog(
// // //                               title: Text('Validated'),
// // //                             ), context: context
// // //                         );
// // //                       }
// // //                     },
// // //                   ),
// // //                 ],
// // //               )
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   String _validateName(String value){
// // //     if(value.length == 0){
// // //       return '*Required Field';
// // //     } else if(value.length < 3){
// // //       return 'Name is too short';
// // //     } else {
// // //       return null;
// // //     }
// // //   }
// // //
// // //   String _validateUserName(String value){
// // //     if(value.length == 0){
// // //       return '*Required Field';
// // //     } else if(value.length < 3){
// // //       return 'UserName is too short';
// // //     } else {
// // //       return null;
// // //     }
// // //   }
// // //
// // //   String _validateAge(String value){
// // //     String pattern = r'(^[1-9 ]*$)';
// // //     RegExp regExp = new RegExp(pattern);
// // //     if(value.length == 0){
// // //       return '*Required Field';
// // //     } else if(!regExp.hasMatch(value)) {
// // //       return 'Age should be numeric';
// // //     } else {
// // //       return null;
// // //     }
// // //   }
// // //
// // //   String _validateBio(String value){
// // //     if(value.length == 0){
// // //       return '*Required Field';
// // //     } else if(value.length < 20){
// // //       return 'Bio should be more than 20 charectors';
// // //     } else {
// // //       return null;
// // //     }
// // //   }
// // // }
// //
// //
// //
