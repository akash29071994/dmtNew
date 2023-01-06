import 'dart:convert';

import 'package:flutter/widgets.dart';

LoginResult loginResultFromJson(String str) => LoginResult.fromJson(json.decode(str));

String loginResultToJson(LoginResult data) => json.encode(data.toJson());

class LoginResult {
  LoginResult({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  LoginResponse data;

  factory LoginResult.fromJson(Map<String, dynamic> json) => LoginResult(
    status: json["status"] ?? "",
    message: json["message"] ?? "",
    data: json.containsKey("data") ? LoginResponse.fromJson(json["data"]) : LoginResponse(),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class LoginResponse {
  LoginResponse({
     this.patientid = 0,
     this.dob = "",
     this.firstname = "",
     this.lastname = "",
     this.username = "",
  });

  int patientid;
  String dob;
  String firstname;
  String lastname;
  String username;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    patientid: json["patientid"] ?? 0,
    dob: json["dob"] ?? "",
    firstname: json["firstname"] ?? "",
    lastname: json["lastname"] ?? "",
    username: json["username"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "patientid": patientid,
    "dob": dob,
    "firstname": firstname,
    "lastname": lastname,
    "username": username,
  };
}
