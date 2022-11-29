class GlobalEdittimer {

  static final GlobalEdittimer _instance = GlobalEdittimer._internal();

  // passes the instantiation to the _instance object
  factory GlobalEdittimer() => _instance;

  //initialize variables in here
  GlobalEdittimer._internal() {
    _subscription=false;
    _roomno="empty";
    _operatedType="empty";
    _dvnum="empty";
    _devicetype="empty";
    _devicetypenum="empty";
    _switchnumber="empty";
    _repeatweekly="empty";
    _devicename="empty";
    _user="empty";
    _paasw="empty";
    _hname="empty";
    _hnum="empty";
    _deviceID="empty";
    _ondata = "empty";
    _offdata = "empty";
    _fromtime = "empty";
    _totime = "empty";
    _ontime = "empty";
    _offtime = "empty";
    _dayssu= "empty";
    _date="empty";

  }

  String _roomno="empty",_operatedType="empty",_dvnum="empty",_devicetype="empty",_devicetypenum="empty",_switchnumber="empty",_repeatweekly="empty",_devicename="empty",_user="empty",_paasw="empty",_hname="empty",_hnum="empty",_deviceID="empty";
  String _ondata="empty",_offdata = "empty",_fromtime = "empty",_totime = "empty",_ontime = "empty",_offtime = "empty",_dayssu = "empty",_date = "empty";
  bool _subscription=false;

  bool get subscription=>_subscription;
  String get roomno =>_roomno;
  String get operatedType =>_operatedType;
  String get dvnum =>_dvnum;
  String get devicetype => _devicetype;
  String get devicetypenum => _devicetypenum;
  String get switchnumber => _switchnumber;
  String get repeatweekly => _repeatweekly;
  String get devicename => _devicename;
  String get user => _user;
  String get paasw => _paasw;
  String get hname => _hname;
  String get hnum => _hnum;
  String get deviceID => _deviceID;
  String get ondata => _ondata;
  String get offdata => _offdata;
  String get fromtime => _fromtime;
  String get totime => _totime;
  String get ontime => _ontime;
  String get offtime => _offtime;
  String get dayssu => _dayssu;
  String get date => _date;

  set subscriptionset(bool valueb) => _subscription=valueb;
  set roomnoset(String value) => _roomno=value;
  set operatedTypeset(String value) => _operatedType=value;
  set dvnumset(String value) => _dvnum=value;
  set devicetypeset(String value) => _devicetype=value;
  set devicetypenumset(String value) => _devicetypenum=value;
  set switchnumberset(String value) => _switchnumber=value;
  set repeatweeklyset(String value) => _repeatweekly=value;
  set devicenameset(String value) => _devicename=value;
  set userset(String value) => _user=value;
  set paaswset(String value) => _paasw=value;
  set hnameset(String value) => _hname=value;
  set hnumset(String value) => _hnum=value;
  set deviceIDset(String value) => _deviceID=value;
  set ondataset(String value) => _ondata = value;
  set offdataset(String value) => _offdata = value;
  set fromtimeset(String value) => _fromtime = value;
  set totimeset(String value) => _totime = value;
  set ontimeset(String value) => _ontime = value;
  set offtimeset(String value) => _offtime = value;
  set dayssuset(String value) => _dayssu = value;
  set dateset(String value) => _date = value;
}