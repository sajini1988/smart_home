class Globaltimer {

  static final Globaltimer _instance = Globaltimer._internal();

  // passes the instantiation to the _instance object
  factory Globaltimer() => _instance;

  //initialize variables in here
  Globaltimer._internal() {
    _subscription=false;
    _switchnumber=[];
    _ondataarray=[];
    _offdataarray=[];

  }

  List _switchnumber=[],_ondataarray=[],_offdataarray=[];
  bool _subscription=false;

  bool get subscription=>_subscription;
  List get switchnumber =>_switchnumber;
  List get ondataarray =>_ondataarray;
  List get offdataarray =>_offdataarray;

  set subscriptionset(bool valueb) => _subscription=valueb;
  set ondataarrayset(List value) => _ondataarray=value;
  set offdataarrayset(List value) => _offdataarray=value;
  set switchnumberset(List value) => _switchnumber=value;
}