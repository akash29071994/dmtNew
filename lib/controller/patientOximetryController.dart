import 'dart:convert';

import 'package:dmt/api/api.dart';
import 'package:dmt/api/requestheader.dart';
import 'package:dmt/model/deviceSyncResult.dart';
import 'package:dmt/model/patientOximetryResults.dart';
import 'package:flutter/cupertino.dart';

class PatientOximetryController{

  List<PatientOximetry> patientOximetry = [];


  Future<PatientOximetryResults?> getPatientOximetry(var body,BuildContext ctx) async {

    PatientOximetryResults? results=null;
    var res= await ApiRequests(context: ctx).sendServerRequest(
        Api.oximetryRresults, body);
    if(res != null){
      var data = json.decode(res);
      results = PatientOximetryResults.fromJson(data);
    }
    return results;
    }

  Future<DeviceSyncResult?> sendDeviceToServer(var body,BuildContext ctx) async {

    DeviceSyncResult? results=null;
    var res= await ApiRequests(context: ctx).sendServerRequest(
        Api.sendDataDeviceToServer, body);
    if(res != null){
      var data = json.decode(res);
      //results = DeviceSyncResult.fromJson(data);
    }
    return results;
  }
}

