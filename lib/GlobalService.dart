class GlobalService {

  static final GlobalService _instance = GlobalService._internal();

  // passes the instantiation to the _instance object
  factory GlobalService() => _instance;
  //initialize variables in here
  GlobalService._internal() {
    _subscription=false;
    _hname="empty";
    _hnum="empty";
    _rnum="empty";
    _dnum="empty";
    _rname="empty";
    _groupId="empty";
    _ddevModel="empty";
    _ddevModelNum="empty";
    _modeltype="empty";
    _devicename="empty";
    _dnumsh="empty";
    _moodnum="empty";
    _deviceID="empty";
    _bulb="empty";
    _moodlistdnum="empty";
    _moodlistrnum="empty";
    _timerlistrnum = "empty";
  }

  String _hname="empty",_hnum="empty",_rnum="empty",_dnum="empty",_rname="empty",_groupId="empty",_ddevModel="empty",_ddevModelNum="empty",_modeltype="empty",_devicename="empty",_dnumsh="empty",_moodnum="empty",_deviceID="empty",_bulb="empty",_moodlistdnum="empty",_moodlistrnum="empty",_timerlistrnum="empty";
  bool _subscription=false;

  bool get subscription=> _subscription;
  String get hname => _hname;
  String get hnum => _hnum;
  String get rnum => _rnum;
  String get dnum => _dnum;
  String get rname => _rname;
  String get groupId => _groupId;
  String get ddevModel => _ddevModel;
  String get ddevModelNum => _ddevModelNum;
  String get modeltype  => _modeltype;
  String get devicename => _devicename;
  String get sheerdnum => _dnumsh;
  String get moodnum => _moodnum;
  String get deviceID => _deviceID;
  String get bulb => _bulb;
  String get moodlistdnum => _moodlistdnum;
  String get moodlistrnum => _moodlistrnum;
  String get timerlistrnum => _timerlistrnum;

  set subscriptionset(bool valueb) => _subscription=valueb;
  set hnameset(String value) => _hname=value;
  set hnumset(String value) => _hnum=value;
  set rnumset(String value) => _rnum=value;
  set dnumset(String value) => _dnum=value;
  set rnameset(String value) => _rname=value;
  set groupIdset(String value) => _groupId=value;
  set ddevModelset(String value) => _ddevModel=value;
  set ddevModelNumset(String value) => _ddevModelNum=value;
  set modeltypeset(String value) => _modeltype=value;
  set devicenameset(String value) => _devicename=value;
  set sheerdnumset(String value) => _dnumsh=value;
  set moodnumset(String value) => _moodnum=value;
  set deviceIDset(String value) => _deviceID=value;
  set bulbnumberset(String value) => _bulb=value;
  set moodlistdnumset(String value) => _moodlistdnum=value;
  set moodlistrnumset(String value) => _moodlistrnum=value;
  set timerlistrnumset(String value) => _timerlistrnum=value;






 // int _myVariable;

  //short getter for my variable
//  int get myVariable => _myVariable;

  //short setter for my variable
  //set myVariable(int value) => myVariable = value;

 // void incrementMyVariable() => _myVariable++;
}