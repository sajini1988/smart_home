class User {
  final String iP;
  final String pORT;
  User({this.iP, this.pORT});
  User.fromJson(Map<String, dynamic> data)
      : iP = data['IP'],
        pORT = data['PORT'];
}