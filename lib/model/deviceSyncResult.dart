// To parse this JSON data, do
//
//     final deviceSyncResult = deviceSyncResultFromJson(jsonString);

import 'dart:convert';

List<DeviceSyncResult> deviceSyncResultFromJson(String str) => List<DeviceSyncResult>.from(json.decode(str).map((x) => DeviceSyncResult.fromJson(x)));

String deviceSyncResultToJson(List<DeviceSyncResult> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DeviceSyncResult {
  int id;
  int oximetryid;
  String studysession;
  DateTime datetime;
  int pulserate;
  int spo2;
  dynamic createdAt;
  dynamic createdBy;
  dynamic updatedAt;
  dynamic updatedBy;

  DeviceSyncResult({
    required this.id,
    required this.oximetryid,
    required this.studysession,
    required this.datetime,
    required this.pulserate,
    required this.spo2,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });



  factory DeviceSyncResult.fromJson(Map<String, dynamic> json) => DeviceSyncResult(
    id: json["id"],
    oximetryid: json["oximetryid"],
    studysession: json["studysession"],
    datetime: DateTime.parse(json["datetime"]),
    pulserate: json["pulserate"],
    spo2: json["spo2"],
    createdAt: json["createdAt"],
    createdBy: json["createdBy"],
    updatedAt: json["updatedAt"],
    updatedBy: json["updatedBy"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "oximetryid": oximetryid,
    "studysession": studysession,
    "datetime": datetime.toIso8601String(),
    "pulserate": pulserate,
    "spo2": spo2,
    "createdAt": createdAt,
    "createdBy": createdBy,
    "updatedAt": updatedAt,
    "updatedBy": updatedBy,
  };
}
