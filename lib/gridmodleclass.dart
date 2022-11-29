

// Gridmodle clientFromJson(String str) {
//   final jsonData = json.decode(str);
//   return Gridmodle.fromMap(jsonData);
// }
//
// String clientToJson(Gridmodle data) {
//   final dyn = data.toMap();
//   return json.encode(dyn);
// }

class Gridmodle {
  // int id;
  // String firstName;
  // String lastName;
  // bool blocked;
  String name;
  String img;
  String selectedimg;


  Gridmodle(

    this.name,
    this.img,
    this.selectedimg,
      );

  @override
  String toString() => '''{ ${this.name}, ${this.img}, ${this.selectedimg}}''';

  @override
  bool operator ==(other) {
    if (other is! Gridmodle) {
      return false;
    }
    return name == other.name &&
        img == other.img && selectedimg == other.selectedimg;
  }

  @override
  int get hashCode => (name + img + selectedimg).hashCode;

  // factory Gridmodle.fromMap(Map<String, dynamic> json) => new Gridmodle(
  //
  //     name: json["name"],
  //     img: json["img"],
  //     selectedimg: json["selectedimg"] ,
  //
  //
  // );
  //
  // Map<String, dynamic> toMap() => {
  //
  //   "name": name,
  //   "img": img,
  //   "selectedimg": selectedimg,
  //
  //
  // };
}

// import 'dart:convert';
//
// Gridmodle clientFromJson(String str) {
//   final jsonData = json.decode(str);
//   return Gridmodle.fromMap(jsonData);
// }
//
// String clientToJson(Gridmodle data) {
//   final dyn = data.toMap();
//   return json.encode(dyn);
// }
//
// class Gridmodle {
//   // int id;
//   // String firstName;
//   // String lastName;
//   // bool blocked;
//
//   String name;
//   String img;
//   String selectedimg;
//
//
//   Gridmodle({
//     this.name,
//     this.img,
//     this.selectedimg,
//
//   });
//
//   factory Gridmodle.fromMap(Map<String, dynamic> json) => new Gridmodle(
//
//       name: json["name"],
//     img: json["img"],
//     selectedimg: json["selectedimg"] ,
//
//
//   );
//
//   Map<String, dynamic> toMap() => {
//
//     "name": name,
//     "img": img,
//     "selectedimg": selectedimg,
//
//
//   };
// }