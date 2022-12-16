

class Student {
  String name;
  String lb;
  String lc;
  String ld;
  String le;
  String lf;
  String lg;
  String lh;
  String li;

  Student({this.name,
      this.lb,
      this.lc,
      this.ld,
      this.le,
      this.lf,
      this.lg,
      this.lh,
      this.li
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{

      'name': name,
      'lb': lb,
      'lc': lc,
      'ld': ld,
      'le': le,
      'lf': lf,
      'lg': lg,
      'lh': lh,
      'li':li,

    };
    return map;
  }

  factory Student.fromMap(Map<String, dynamic> map) => new Student(
    name : map['name'],
    lb : map['lb'],
    lc : map['lc'],
    ld : map['ld'],
    le : map['le'],
    lf : map['lf'],
    lg : map['lg'],
    lh : map['lh'],
    li : map['li'],
  );

}
