import 'dart:convert';

import 'package:dmt/model/patient.dart';
import 'package:dmt/model/physician.dart';

PatientOximetryResults patientOximetryResultsFromJson(String str) => PatientOximetryResults.fromJson(json.decode(str));

String patientOximetryResultsToJson(PatientOximetryResults data) => json.encode(data.toJson());

class PatientOximetryResults {
  int count;
  List<PatientOximetry> patientOximetry;
  PatientOximetryResults({
    required this.count,
    required this.patientOximetry,
  });

  factory PatientOximetryResults.fromJson(Map<String, dynamic> json) => PatientOximetryResults(
    count: json["count"],
    patientOximetry: List<PatientOximetry>.from(json["rows"] == null ?[] : json["rows"].map((x) => PatientOximetry.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "rows": List<dynamic>.from(patientOximetry.map((x) => x.toJson())),
  };
}

class PatientOximetry {
  PatientOximetry({
    required this.id,
    required this.patientid,
    required this.physicianid,
    required this.rxdate,
    required this.rxreceiveddate,
    required this.testingcondition,
    required this.oxigenlpm,
    required this.devicetype,
    required this.oximeterserialno,
    required this.diagnosisid,
    required this.diagnosis1Id,
    required this.diagnosis2Id,
    required this.aob,
    required this.script,
    required this.patientstatus,
    required this.scheduleConfirm,
    required this.status,
    required this.o2Setup,
    required this.o2SetupDate,
    required this.signed,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    required this.patient,
    required this.physician,
  });

  int id;
  int patientid;
  int physicianid;
  String rxdate;
  dynamic rxreceiveddate;
  String testingcondition;
  dynamic oxigenlpm;
  String devicetype;
  dynamic oximeterserialno;
  int diagnosisid;
  dynamic diagnosis1Id;
  dynamic diagnosis2Id;
  String aob;
  String script;
  String patientstatus;
  String scheduleConfirm;
  String status;
  String o2Setup;
  dynamic o2SetupDate;
  String signed;
  String createdAt;
  String createdBy;
  String updatedAt;
  String updatedBy;
  Patient patient;
  Physician physician;

  factory PatientOximetry.fromJson(Map<String, dynamic> json) => PatientOximetry(
    id: json["id"],
    patientid: json["patientid"],
    physicianid: json["physicianid"],
    rxdate: json["rxdate"] == null ? "" :DateTime.parse(json["rxdate"]).toString(),
    rxreceiveddate: json["rxreceiveddate"],
    testingcondition: json["testingcondition"],
    oxigenlpm: json["oxigenlpm"],
    devicetype: json["devicetype"],
    oximeterserialno: json["oximeterserialno"],
    diagnosisid: json["diagnosisid"],
    diagnosis1Id: json["diagnosis1id"],
    diagnosis2Id: json["diagnosis2id"],
    aob: json["aob"] == null ? "" : json["aob"],
    script: json["script"] == null ? "" : json["script"],
    patientstatus: json["patientstatus"],
    scheduleConfirm: json["scheduleConfirm"] == null ? "" : json["scheduleConfirm"],
    status: json["status"],
    o2Setup: json["o2setup"],
    o2SetupDate: json["o2setupDate"],
    signed: json["signed"],
    createdAt: json["createdAt"] ?? DateTime.parse(json["createdAt"]),
    createdBy: json["createdBy"],
    updatedAt: json["updatedAt"] ?? DateTime.parse(json["updatedAt"]),
    updatedBy: json["updatedBy"],
    patient: Patient.fromJson(json["patient"]),
    physician: Physician.fromJson(json["physician"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "patientid": patientid,
    "physicianid": physicianid,
    "rxdate": rxdate == null ? "" : rxdate.toString(),
    "rxreceiveddate": rxreceiveddate,
    "testingcondition": testingcondition,
    "oxigenlpm": oxigenlpm,
    "devicetype": devicetype,
    "oximeterserialno": oximeterserialno,
    "diagnosisid": diagnosisid,
    "diagnosis1id": diagnosis1Id,
    "diagnosis2id": diagnosis2Id,
    "aob": aob == null ? null : aob,
    "script": script == null ? null : script,
    "patientstatus": patientstatus,
    "scheduleConfirm": scheduleConfirm,
    "status": status,
    "o2setup": o2Setup,
    "o2setupDate": o2SetupDate,
    "signed": signed,
    "createdAt": createdAt.toString(),
    "createdBy": createdBy,
    "updatedAt": updatedAt.toString(),
    "updatedBy": updatedBy,
    "patient": patient.toJson(),
    "physician": physician.toJson(),
  };
}


