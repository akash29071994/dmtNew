// To parse this JSON data, do
//
//     final hstResults = hstResultsFromJson(jsonString);

import 'dart:convert';

import 'package:dmt/model/patient.dart';

HstResults hstResultsFromJson(String str) => HstResults.fromJson(json.decode(str));

String hstResultsToJson(HstResults data) => json.encode(data.toJson());

class HstResults {
  int count;
  List<HstResultsData>? rows;

  HstResults({
    this.count = 0,
    this.rows,
  });
  factory HstResults.fromJson(Map<String, dynamic> json) => HstResults(
    count: json["count"],
    rows: List<HstResultsData>.from(json["rows"].map((x) => HstResultsData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "rows": List<dynamic>.from(rows!.map((x) => x.toJson())),
  };
}

class HstResultsData {
  int id;
  String status;
  dynamic ahi;
  dynamic insurance;
  String signed;
  Patient? patient;
  Hstofficeuse? hstofficeuse;
  Hstinterpretation? hstinterpretation;
  HstResultsData({
    this.id = 0,
    this.status = "",
    this.ahi,
    this.insurance,
    this.signed = "",
    this.patient,
    this.hstofficeuse,
    this.hstinterpretation,
  });

  factory HstResultsData.fromJson(Map<String, dynamic> json) => HstResultsData(
    id: json["id"],
    status: json["status"],
    ahi: json["ahi"],
    insurance: json["insurance"],
    signed: json["signed"],
    patient: Patient.fromJson(json["patient"]),
    hstofficeuse: Hstofficeuse.fromJson(json["hstofficeuse"]),
    // hstinterpretation: Hstinterpretation.fromJson(json["hstinterpretation"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "ahi": ahi,
    "insurance": insurance,
    "signed": signed,
    "patient": patient?.toJson(),
    "hstofficeuse": hstofficeuse?.toJson(),
    "hstinterpretation": hstinterpretation?.toJson(),
  };
}

class Hstinterpretation {
  int hstid;
  Hstinterpretation({
    this.hstid = 0,
  });
  factory Hstinterpretation.fromJson(Map<String, dynamic> json) => Hstinterpretation(
    hstid: json["hstid"],
  );

  Map<String, dynamic> toJson() => {
    "hstid": hstid,
  };
}

class Hstofficeuse {
  String referralreceiveddate;
  var shippeddate;
  var returndate;
  String interpretdate;
  var studydate;
  Orderingphysician? orderingphysician;
  var interpretingphysician;
  Hstofficeuse({
    this.referralreceiveddate = "",
    this.shippeddate,
    this.returndate,
    this.interpretdate = "",
    this.studydate,
    this.orderingphysician,
    this.interpretingphysician,
  });



  factory Hstofficeuse.fromJson(Map<String, dynamic> json) => Hstofficeuse(
    referralreceiveddate: json["referralreceiveddate"],
    shippeddate: json["shippeddate"],
    returndate: json["returndate"],
    interpretdate: json["interpretdate"]==null?"":json["interpretdate"],
    studydate: json["studydate"],
    orderingphysician: Orderingphysician.fromJson(json["orderingphysician"]),
    interpretingphysician: json["interpretingphysician"],
  );

  Map<String, dynamic> toJson() => {
    "referralreceiveddate": referralreceiveddate,
    "shippeddate": shippeddate,
    "returndate": returndate,
    "interpretdate": interpretdate,
    "studydate": studydate,
    "orderingphysician": orderingphysician?.toJson(),
    "interpretingphysician": interpretingphysician,
  };
}

class Orderingphysician {
  Orderingphysician({
    this.id = 0,
    this.username = "",
  });

  int id;
  String username;

  factory Orderingphysician.fromJson(Map<String, dynamic> json) => Orderingphysician(
    id: json["id"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
  };
}




