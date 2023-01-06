// To parse this JSON data, do
//
//     final reaobResults = reaobResultsFromJson(jsonString);

import 'dart:convert';

import 'package:dmt/model/patient.dart';
import 'package:dmt/model/physician.dart';

ReaobResults reaobResultsFromJson(String str) => ReaobResults.fromJson(json.decode(str));

String reaobResultsToJson(ReaobResults data) => json.encode(data.toJson());

class ReaobResults {
  int count;
  List<ReaobResultsData>? rows;
  ReaobResults({
    this.count = 0,
    this.rows,
  });



  factory ReaobResults.fromJson(Map<String, dynamic> json) => ReaobResults(
    count: json["count"],
    rows: List<ReaobResultsData>.from(json["rows"].map((x) => ReaobResultsData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "rows": List<dynamic>.from(rows!.map((x) => x.toJson())),
  };
}

class ReaobResultsData {
  int id;
  int patientid;
  int companyid;
  int physicianid;
  int clinicianid;
  int physicianadminid;
  int pointofcontactid;
  int diagnosisid;
  dynamic diagnosis1Id;
  dynamic diagnosis2Id;
  String visittype;
  String faxreport;
  dynamic scheduleddate;
  String entereddate;
  String patientstatus;
  String qualifyingstatus;
  String status;
  String signed;
  String createdAt;
  String createdBy;
  String updatedAt;
  String updatedBy;
  Patient? patient;
  Physician? physician;
  Clinicianuser? clinicianuser;
  Map<String, int>? reexercisetest;
  dynamic rertrnpatientinformation;

  ReaobResultsData({
    this.id = 0,
    this.patientid= 0,
    this.companyid= 0,
    this.physicianid= 0,
    this.clinicianid= 0,
    this.physicianadminid= 0,
    this.pointofcontactid= 0,
    this.diagnosisid= 0,
    this.diagnosis1Id= 0,
    this.diagnosis2Id= 0,
    this.visittype="",
    this.faxreport="",
    this.scheduleddate="",
    this.entereddate="",
    this.patientstatus="",
    this.qualifyingstatus="",
    this.status="",
    this.signed="",
    this.createdAt="",
    this.createdBy="",
    this.updatedAt="",
    this.updatedBy="",
    this.patient,
    this.physician,
    this.clinicianuser,
    this.reexercisetest,
    this.rertrnpatientinformation,
  });



  factory ReaobResultsData.fromJson(Map<String, dynamic> json) => ReaobResultsData(
    id: json["id"],
    patientid: json["patientid"],
    companyid: json["companyid"],
    physicianid: json["physicianid"],
    clinicianid: json["clinicianid"],
    physicianadminid: json["physicianadminid"],
    pointofcontactid: json["pointofcontactid"],
    diagnosisid: json["diagnosisid"],
    diagnosis1Id: json["diagnosis1id"],
    diagnosis2Id: json["diagnosis2id"],
    visittype: json["visittype"],
    faxreport: json["faxreport"],
    scheduleddate: json["scheduleddate"],
    entereddate: json["entereddate"],
    patientstatus: json["patientstatus"],
    qualifyingstatus: json["qualifyingstatus"],
    status: json["status"],
    signed: json["signed"],
    createdAt:json["createdAt"],
    createdBy: json["createdBy"],
    updatedAt: json["updatedAt"],
    updatedBy: json["updatedBy"],
    patient: Patient.fromJson(json["patient"]),
    physician: Physician.fromJson(json["physician"]),
    clinicianuser: Clinicianuser.fromJson(json["clinicianuser"]),
    //reexercisetest: Map.from(json["reexercisetest"]).map((k, v) => MapEntry<String, int>(k, v == null ? null : v)),
    rertrnpatientinformation: json["rertrnpatientinformation"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "patientid": patientid,
    "companyid": companyid,
    "physicianid": physicianid,
    "clinicianid": clinicianid,
    "physicianadminid": physicianadminid,
    "pointofcontactid": pointofcontactid,
    "diagnosisid": diagnosisid,
    "diagnosis1id": diagnosis1Id,
    "diagnosis2id": diagnosis2Id,
    "visittype": visittype,
    "faxreport": faxreport,
    "scheduleddate": scheduleddate,
    "entereddate": entereddate,
    "patientstatus": patientstatus,
    "qualifyingstatus": qualifyingstatus,
    "status": status,
    "signed": signed,
    "createdAt": createdAt,
    "createdBy": createdBy,
    "updatedAt": updatedAt,
    "updatedBy": updatedBy,
    "patient": patient!.toJson(),
    "physician": physician!.toJson(),
    "clinicianuser": clinicianuser!.toJson(),
    "reexercisetest": Map.from(reexercisetest!).map((k, v) => MapEntry<String, dynamic>(k, v == null ? null : v)),
    "rertrnpatientinformation": rertrnpatientinformation,
  };
}

class Clinicianuser {
  int id;
  String username;
  String type;
  Clinicianuser({
    this.id = 0,
    this.username="",
    this.type="",
  });

  factory Clinicianuser.fromJson(Map<String, dynamic> json) => Clinicianuser(
    id: json["id"],
    username: json["username"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "type": type,
  };
}







