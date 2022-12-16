

class MoodDBData {
  String hnum;
  String hname;
  String rnum;
  String rname;
  String moodstno;
  String moodstname;
  String devicetype;
  String devicemodel;
  String devicenum;
  String onoffnum;//Off or ON
  String devicedata;//data set to be opearted
  String aEdata;
  String bEdata;
  String cEdata;//Devicename
  String dEdata;//Username
  String eEdata;
  String fEdata;
  String gEdata;
  String hEdata;
  String iEdata;
  String jEdata;


  MoodDBData({this.hnum,
    this.hname,
    this.rnum,
    this.rname,
    this.moodstno,
    this.moodstname,
    this.devicetype,
    this.devicemodel,
    this.devicenum,
    this.onoffnum,
    this.devicedata,
    this.aEdata,
    this.bEdata,
    this.cEdata,
    this.dEdata,
    this.eEdata,
    this.fEdata,
    this.gEdata,
    this.hEdata,
    this.iEdata,
    this.jEdata,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
         'hn': hnum,
      'hna': hname,
      'rn': rnum,
      'rna': rname,
      'stno': moodstno,
      'stna': moodstname,
      'dt': devicetype,
      'dna': devicemodel,
      'dno':devicenum,
      'OnOff':onoffnum,
      'dd':devicedata,
      'ea':aEdata,
      'eb':bEdata,
      'ec':cEdata,
      'ed':dEdata,
      'ee':eEdata,
      'ef':fEdata,
      'eg':gEdata,
      'eh':hEdata,
      'ei':iEdata,
      'ej':jEdata
    };
    return map;
  }

  factory MoodDBData.fromMap(Map<String, dynamic> map) => new MoodDBData(
    hnum : map['hn'],
    hname : map['hna'],
    rnum : map['rn'],
    rname : map['rna'],
    moodstno : map['stno'],
    moodstname : map['stna'],
    devicetype : map['dt'],
    devicemodel : map['dna'],
    devicenum : map['dno'],
    onoffnum: map['OnOff'],
    devicedata: map['dd'],
      aEdata : map['ea'],
      bEdata : map['eb'],
      cEdata : map['ec'],
      dEdata : map['ed'],
      eEdata: map['ee'],
      fEdata: map['ef'],
      gEdata: map['eg'],
      hEdata: map['eh'],
      iEdata: map['ei'],
      jEdata: map['ej']
  );

}
