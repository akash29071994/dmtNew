import 'dart:convert';

import 'package:dmt/api/api.dart';
import 'package:dmt/api/requestheader.dart';
import 'package:dmt/model/hstResults.dart';
import 'package:dmt/model/patientOximetryResults.dart';
import 'package:flutter/cupertino.dart';

class HomeSleepTestController{


  Future<HstResults?> getHtsData(var body,BuildContext ctx) async {

    HstResults? results=null;
    var res= await ApiRequests(context: ctx).sendServerRequest(
        Api.hstResults, body);
    if(res != null){
      var data = json.decode(res);
      results = HstResults.fromJson(data);
    }
    return results;
    }
}

